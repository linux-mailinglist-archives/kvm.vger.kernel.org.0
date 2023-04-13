Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654506E12EA
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 18:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDMQ6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 12:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDMQ6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 12:58:05 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09D14E6F
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 09:58:05 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4919C1477;
        Thu, 13 Apr 2023 09:58:49 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C20F3F6C4;
        Thu, 13 Apr 2023 09:58:03 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [RFC PATCH kvmtool 2/2] virtio/rng: return at least one byte of entropy
Date:   Thu, 13 Apr 2023 17:57:57 +0100
Message-Id: <20230413165757.1728800-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230413165757.1728800-1-andre.przywara@arm.com>
References: <20230413165757.1728800-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In contrast to the original v0.9 virtio spec (which was rather vague),
the virtio 1.0+ spec demands that a RNG request returns at least one
byte:
"The device MUST place one or more random bytes into the buffer, but it
MAY use less than the entire buffer length."

Our current implementation does not prevent returning zero bytes, which
upsets an assert in EDK II. Since we open the fd with O_NONBLOCK, a
return with not the whole buffer filled seems possible.

Take care of that special case, by switching the /dev/urandom file
descriptor into blocking mode when a 0-return happens, than wait for one
byte to arrive. We then switch back to non-blocking mode, and try to
read even more (in case multiple bytes became available at once).
This makes sure we return at least one byte of entropy and become spec
compliant.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Sami Mujawar <sami.mujawar@arm.com>
---
 virtio/rng.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/virtio/rng.c b/virtio/rng.c
index eab8f3ac0..0a0b31a16 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -66,8 +66,35 @@ static bool virtio_rng_do_io_request(struct kvm *kvm, struct rng_dev *rdev, stru
 
 	head	= virt_queue__get_iov(queue, iov, &out, &in, kvm);
 	len	= readv(rdev->fd, iov, in);
-	if (len < 0 && errno == EAGAIN)
-		len = 0;
+	if (len < 0 && errno == EAGAIN) {
+		/*
+		 * The virtio 1.0 spec demands at least one byte of entropy.
+		 * Switch the /dev/urandom file descriptor to blocking mode,
+		 * then wait for one byte to arrive. Switch it back to
+		 * non-blocking mode, and try to read even more, if available.
+		 */
+		int flags = fcntl(rdev->fd, F_GETFL);
+
+		if (flags < 0)
+			return false;
+
+		fcntl(rdev->fd, F_SETFL, flags & ~O_NONBLOCK);
+		len = read(rdev->fd, iov[0].iov_base, 1);
+		if (len < 1)
+			return false;
+		fcntl(rdev->fd, F_SETFL, flags);
+		iov[0].iov_base++;
+		iov[0].iov_len--;
+		len = readv(rdev->fd, iov, in);
+		if (len < 0) {
+			if (errno == EAGAIN)	/* no more bytes yet */
+				len = 1;
+			else
+				return false;	/* some error */
+		} else {
+			len++;			/* the one byte already read */
+		}
+	}
 
 	virt_queue__set_used_elem(queue, head, len);
 
-- 
2.25.1

