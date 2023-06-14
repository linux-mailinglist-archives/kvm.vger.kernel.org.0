Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA770F4FA
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 13:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjEXLWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 07:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjEXLWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 07:22:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 408F5A3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 04:22:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C9761595;
        Wed, 24 May 2023 04:23:01 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9EE63F67D;
        Wed, 24 May 2023 04:22:14 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool v3 2/2] virtio/rng: return at least one byte of entropy
Date:   Wed, 24 May 2023 12:22:07 +0100
Message-Id: <20230524112207.586101-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524112207.586101-1-andre.przywara@arm.com>
References: <20230524112207.586101-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
upsets an assert in EDK II. /dev/urandom should always return at least
256 bytes of entropy, unless interrupted by a signal.

Repeat the read if that happens, and give up if that fails as well.
This makes sure we return some entropy and become spec compliant.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Sami Mujawar <sami.mujawar@arm.com>
---
 virtio/rng.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/virtio/rng.c b/virtio/rng.c
index e6e70ced3..77a3a1138 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -61,13 +61,25 @@ static u64 get_host_features(struct kvm *kvm, void *dev)
 static bool virtio_rng_do_io_request(struct kvm *kvm, struct rng_dev *rdev, struct virt_queue *queue)
 {
 	struct iovec iov[VIRTIO_RNG_QUEUE_SIZE];
-	ssize_t len = 0;
+	ssize_t len;
 	u16 out, in, head;
 
 	head	= virt_queue__get_iov(queue, iov, &out, &in, kvm);
 	len	= readv(rdev->fd, iov, in);
-	if (len < 0 && errno == EAGAIN)
-		len = 0;
+	if (len < 0 && (errno == EAGAIN || errno == EINTR)) {
+		/*
+		 * The virtio 1.0 spec demands at least one byte of entropy,
+		 * so we cannot just return with 0 if something goes wrong.
+		 * The urandom(4) manpage mentions that a read from /dev/urandom
+		 * should always return at least 256 bytes of randomness, so
+		 * just retry here, with the requested size clamped to that
+		 * maximum, in case we were interrupted by a signal.
+		 */
+		iov[0].iov_len = min(iov[0].iov_len, 256UL);
+		len = readv(rdev->fd, iov, 1);
+		if (len < 1)
+			return false;
+	}
 
 	virt_queue__set_used_elem(queue, head, len);
 
-- 
2.25.1

