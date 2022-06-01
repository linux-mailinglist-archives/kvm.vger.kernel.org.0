Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896F853AB51
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348736AbiFAQwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbiFAQwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:52:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 562843336E
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:52:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 220C61063;
        Wed,  1 Jun 2022 09:52:46 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7227D3F66F;
        Wed,  1 Jun 2022 09:52:45 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: [PATCH kvmtool 1/4] virtio/mmio: avoid unaligned accesses
Date:   Wed,  1 Jun 2022 17:51:35 +0100
Message-Id: <20220601165138.3135246-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601165138.3135246-1-andre.przywara@arm.com>
References: <20220601165138.3135246-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The virtio-mmio code is using unaligned accesses, to its struct
virtio_mmio, as revealed by -fsanitize=undefined.
A closer inspection reveals that this is due to a misplaced u8 member
in struct virtio_mmio, and it inheriting the "packed" attribute from
struct virtio_mmio_hdr.
The simplest fix for the issue is to just move the "u8 irq" member to
the end, so that even with the "packed" attribute in effect, the other
members stay all naturally aligned.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/virtio-mmio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index 6bc50bd1..13dcccb6 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -45,10 +45,10 @@ struct virtio_mmio {
 	u32			addr;
 	void			*dev;
 	struct kvm		*kvm;
-	u8			irq;
 	struct virtio_mmio_hdr	hdr;
 	struct device_header	dev_hdr;
 	struct virtio_mmio_ioevent_param ioeventfds[VIRTIO_MMIO_MAX_VQ];
+	u8			irq;
 };
 
 int virtio_mmio_signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq);
-- 
2.25.1

