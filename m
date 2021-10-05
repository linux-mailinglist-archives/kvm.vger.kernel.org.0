Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B00421BB6
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJEBVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhJEBVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:15 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047CCC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:26 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a188-20020a627fc5000000b004446be17615so10095312pfd.7
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IV4bAX7aZbOWgsyTP/uC/+QKOTMTTiF20MdPsNzdqGo=;
        b=idVd0svEOjdLh2xDcyN/pE+oF0Uh0qm8kXmVQyvpwu/Zr1F+aV0G4HLahuFubXDPvK
         YBNJWaov5wPWZV0MG3S0i8lK2eA+uDo0Z2ljfSXfE4LsRsWPMp9QP1IVL4V59L1u7JaN
         8lTLknOPSU5MeCVpZgGTBAxPTaz0c2d3dwbp060SiOxUCciMPzLiJ+PaYI+eCG22h9oy
         O6mQz8u8Cak9qIhseNWK4w86SSvKUUyUMMljKEMj/m76CG4emOwaBopYu+90Gq5uKbqO
         dvl7PyDrL7le6ZQm99+j9PU3OrIVvx/PRo3wcTlGc7IYkD5fWhFYy1lBr8hpSR58C6Km
         TPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IV4bAX7aZbOWgsyTP/uC/+QKOTMTTiF20MdPsNzdqGo=;
        b=ukWhQgN3GP4fnr3P4Gm89VlLLsBkn9okytdANn7tR98t2XMBJt3OMRjGzh2SZJYgGO
         FWgBh7YObFBoWRScTnggrLyImbS6e8gdEInof+DdPmbXogbCuDXG2fAvC6O2a/UaIsog
         afAL5dpXQB00AtR2XVUdoITFtdKJXOKm4tGFiOuxupS12dltai+w5qctBVUV/CCnJ+Bt
         Xg2UifhTQASCgIVpyeMNxPfQtWNW4d8jKHHxh6xbN1dBGOox1Q5817bBPce9orDuvf+q
         6i1kbh59vjZ2eCfU84jqyKLJ36nHiUH8ndSFL+B61B5Z86AZBIBY7KXnDok4daqoNYz3
         0uTg==
X-Gm-Message-State: AOAM530ciyAKJuw5cuOXXCMaMnE+rt44K+DzOO5KzrLWoOTrTvSmGfyU
        gS4wLYag2iCs2IKiIPY6BlkJTMx7491DUBzrcTGLRD1NwgemftFt4xU2EsaAf+PXiVAdBPR2XAZ
        8cRCTDVAZdZN8F8QYwENb1r867x4spOr9pkoq0u5yzyqn2gckCqx+SHIbQB09lOM=
X-Google-Smtp-Source: ABdhPJyB26ALWNynLvgWkZeYBngyxImps90TdSrxE5EA7kXmAsk/88jmmKB1FlcqJkxP0cDf2LNG5WFeQIoMDg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:7a8b:: with SMTP id
 q11mr369754pjf.35.1633396765327; Mon, 04 Oct 2021 18:19:25 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:11 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 01/11] kvm: arm64: vgic: Introduce vgic_check_iorange
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

Add the new vgic_check_iorange helper that checks that an iorange is
sane: the start address and size have valid alignments, the range is
within the addressable PA range, start+size doesn't overflow, and the
start wasn't already defined.

No functional change.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h            |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 7740995de982..cc0ad227b380 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 	return 0;
 }
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size)
+{
+	int ret;
+
+	ret = vgic_check_ioaddr(kvm, &ioaddr, addr, alignment);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED(size, alignment))
+		return -EINVAL;
+
+	if (addr + size < addr)
+		return -EINVAL;
+
+	if (addr + size > kvm_phys_size(kvm))
+		return -E2BIG;
+
+	return 0;
+}
+
 static int vgic_check_type(struct kvm *kvm, int type_needed)
 {
 	if (kvm->arch.vgic.vgic_model != type_needed)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 14a9218641f5..4be01c38e8f1 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 		      phys_addr_t addr, phys_addr_t alignment);
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size);
+
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
-- 
2.33.0.800.g4c38ced690-goog

