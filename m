Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028FA6E7FFD
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 19:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbjDSRBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 13:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjDSRBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 13:01:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 911E86A5B
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 10:01:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22CEE152B;
        Wed, 19 Apr 2023 10:02:36 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BF803F5A1;
        Wed, 19 Apr 2023 10:01:51 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool v2 1/2] virtio/rng: switch to using /dev/urandom
Date:   Wed, 19 Apr 2023 18:01:35 +0100
Message-Id: <20230419170136.1883584-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419170136.1883584-1-andre.przywara@arm.com>
References: <20230419170136.1883584-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment we use /dev/random as the backing device to provide random
numbers to our virtio-rng implementation. The downside of doing so is
that it may block indefinitely - or return EAGAIN repeatedly in our case.
On one headless system without ample noise sources (no keyboard, mouse,
or network traffic) I measured 30 seconds to gain one byte of randomness.
At the moment EDK II insists in waiting for all of the requsted random
bytes (for its EFI_RNG_PROTOCOL runtime service) to arrive, that held up
a Linux kernel boot for more than 10 minutes(!).

According to the Internet(TM), on Linux /dev/urandom provides the same
quality random numbers as /dev/random, it just does not block when the
entropy estimation algorithm suggests so. For all practical purposes the
recommendation is to just use /dev/urandom, QEMU did the switch as well
in 2019 [1].

Use /dev/urandom instead of /dev/random when opening the file descriptor
providing the randomness source for the virtio/rng implementation.
Due to a special behaviour documented on the urandom(4) manpage, a read
from /dev/urandom will never block, so we can drop the O_NONBLOCK flag.

[1] https://gitlab.com/qemu-project/qemu/-/commit/a2230bd778d8

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/rng.c b/virtio/rng.c
index 8f85d5ec1..e6e70ced3 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -166,7 +166,7 @@ int virtio_rng__init(struct kvm *kvm)
 	if (rdev == NULL)
 		return -ENOMEM;
 
-	rdev->fd = open("/dev/random", O_RDONLY | O_NONBLOCK);
+	rdev->fd = open("/dev/urandom", O_RDONLY);
 	if (rdev->fd < 0) {
 		r = rdev->fd;
 		goto cleanup;
-- 
2.25.1

