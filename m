Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8C7421BBA
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhJEBVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbhJEBVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:19 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB75C061749
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:29 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h8-20020a05620a284800b0045ec745583cso3191815qkp.6
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=modZ4Z9L3oEO9aqybHoesg/sa8IbbaN9vhBoj4nUzK0=;
        b=bgOdRvGy03wHhuqC9IIWVXjHgLq8ER1bPqdM1eoyXmXxE5CTK7haSaS4mfh/hFn9q4
         FxjgPFxCEJ1rzeLtbTrxE1cTleYeu++bEADbAMjp7zprbkOOnMc9ZvfaCcxQXojsV8y1
         I+aEzmFUySG1t/PpYK4H2Z99PTMG/HHRRUGzmOlIDY7oKn3c5FcGo14NVlAl/tx+kMuW
         1vR3br3ecMYhOd+n2ZAa+EatFnDPUicWKaUBq5eTJGWrRU7vs05BT2Vvi0zCSC5qv29K
         XyHXwpoBbsC8l8mLdjuqfQyju7XswglWVz/fUv08P/x+ouQka4yadX/J/xKLLWZ5MQe1
         RfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=modZ4Z9L3oEO9aqybHoesg/sa8IbbaN9vhBoj4nUzK0=;
        b=rTnREsMrUkLLluMPjf582acM7LTKi28Iu68XuixECQtn0SapviQ6Ntsvml2mWF8Fr6
         zEPhIygP3depBgb53+6RBYa4/ZY9QsmS0/L65GFTQi2DlpIAWyxjy9jaUn/8u3zuQSbx
         LWaSp5sZU8fhK4KPZSA9rWkjNpVwSzN7Elx4LDEmYkZ52FL/jbvUpOTZLcxnBbybckKg
         c8UAK+8n3EYGMIvYOu/OHDSNAT3Cm89bCv1oRGwvhS+Js6wLunlx+0Ac0/9RWkNw7iM5
         lz4X46VJebg1XbBx59IhxFiANSWAVcuQqVpBomMuO8Bj/P2zLqoYx9iT4bHX7K8VVGfT
         C/7g==
X-Gm-Message-State: AOAM5333SHVg0k0WPWRIWBZm+KWox+AR8NlCKQfGeCSC+6RJXKY9Pu+L
        QOd1a5Z/OvG0mRFkhFPuODEME577DqAzrLJimlBXTtV2k2nPoNNeDn81NCfqZwLx1vs1fZRWWC9
        cCWQq5WR7i9R4DXzNFGePwXrbtfCTkHGPDHVpu/016ZwH/JMiXTAlDxzkymR7uHA=
X-Google-Smtp-Source: ABdhPJx9MR9eKbMFUs47zy96xYIn215NokaRZrbiaxTy5wQJPpw7gxng1q29efocogl6eAoijKwKJfRIvzZmlA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:476a:: with SMTP id
 d10mr2875568qvx.20.1633396768417; Mon, 04 Oct 2021 18:19:28 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:13 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 03/11] KVM: arm64: vgic-v2: Check cpu interface region is
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index cc0ad227b380..08ae34b1a986 100644
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
+		r = vgic_check_iorange(kvm, *addr_ptr, *addr, alignment, size);
 		if (!r)
 			*addr_ptr = *addr;
 	} else {
-- 
2.33.0.800.g4c38ced690-goog

