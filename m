Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0A241B698
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbhI1Stx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242296AbhI1Stw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:49:52 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8099C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:12 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id w10-20020ac87e8a000000b002a68361412bso102111608qtj.7
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SRAJJGG3Meq60fJArI5V58NqIezmfGYq9oG//j0UJy4=;
        b=gz2f1clVsINkVP6NIRdH73tTk/+NC1lndVFY8Ks8c/mZOEVqy7lrdZZMeNIZHOfqsR
         QcU3QjumkuT98r6uzQTnO1MpoK+AMep01FJUZ2WhP0Z7b+n/9k6BglSNBHT3yNJxmQyV
         V57QtyAImWfetwVF8+qmYsLpRQzTbqrPVIKHNbcHpvup/TAHuBFRlhMHiHgZ8T+kVapS
         0P78ZcNTCt0nnTTcCRoD8dINcAfsRc+g7GtnNO5bwNDA9FqQw2KPsfnt47PfGhtKffrE
         wKHw0dOq7DzE1vRFmDPZX66JAxHzIgv1XdPoPiRqNhTQX+uaFCRneTxei85Dypb1QGVm
         AuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SRAJJGG3Meq60fJArI5V58NqIezmfGYq9oG//j0UJy4=;
        b=CAzx5BMlhiSesraemq86dzsNvq3+K6ZISwxXP18TJSn//MM7SsDGMxmUZWLoIgC10H
         j3Jupshm/pstSahl5NkiTqBTPAoOYk1ZJsoNjwkkQURWFaoTWdj8Pk42c+iE1Ztn3UMS
         KeYmNpHRe8EIyaT/YiOh3JdFqckP1PtSYa1aoq6hgWogW7st7FE4cMtgsqy0exQwQs0s
         EOuS6yt9tDu/PzI7FYj1UEeIstR9UrNcnR+AGXfuEhhXY10J0AFTpXL6y+HjkelbMSLP
         0o7kdocsxZMkpDNwAxGrIEm4VY6pHdk4XqBmsFH4uVXCJftZdSswRTEh54kHlpjW2k22
         kwPA==
X-Gm-Message-State: AOAM532vBtL94kLxDfVptmw5TIR1+KACpnt7xNKlypoBenz1kuFPNwKR
        N7J7eQpGyXnlnjwlcbXuUb0cI5e3HxBHF2Xl8Apq9tWvi7ZCrHsGxubwt5HvLVOBV6h4irhDf9j
        EwEoZdRv+TNFWle1Ta9txynMQtJrx3Xu/H+bfMTiY7ApEwpN8DGm3vKGMu59qWuY=
X-Google-Smtp-Source: ABdhPJzP3Fh4vY9K3xp2ukBeuRRfH9cOkSP8HPXbiCcgsIo9+m8jiJA3CBwtrricg5KcU+UwN+TiqVzb93a/Uw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:732:: with SMTP id
 c18mr7310791qvz.9.1632854891937; Tue, 28 Sep 2021 11:48:11 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:47:57 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 03/10] KVM: arm64: vgic-v2: Check cpu interface region is
 not above the VM IPA size
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the GICv2 CPU interface does not extend beyond the
VM-specified IPA range (phys_size).

  base + size > phys_size AND base < phys_size

Add the missing check into kvm_vgic_addr() which is called when setting
the region. This patch also enables some superfluous checks for the
distributor (vgic_check_ioaddr was enough as alignment == size for the
distributors).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f714aded67b2..b379eb81fddb 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -79,7 +79,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 {
 	int r = 0;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
-	phys_addr_t *addr_ptr, alignment;
+	phys_addr_t *addr_ptr, alignment, size;
 	u64 undef_value = VGIC_ADDR_UNDEF;
 
 	mutex_lock(&kvm->lock);
@@ -88,16 +88,19 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_4K;
+		size = KVM_VGIC_V2_DIST_SIZE;
 		break;
 	case KVM_VGIC_V2_ADDR_TYPE_CPU:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_cpu_base;
 		alignment = SZ_4K;
+		size = KVM_VGIC_V2_CPU_SIZE;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_64K;
+		size = KVM_VGIC_V3_DIST_SIZE;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_REDIST: {
 		struct vgic_redist_region *rdreg;
@@ -162,7 +165,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		goto out;
 
 	if (write) {
-		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
+		r = vgic_check_iorange(kvm, addr_ptr, *addr, alignment, size);
 		if (!r)
 			*addr_ptr = *addr;
 	} else {
-- 
2.33.0.685.g46640cef36-goog

