Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913C03CEE5C
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387949AbhGSUif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383756AbhGSSKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 14:10:09 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B92C061788
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:38:15 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id h7-20020a6bb7070000b0290525efa1b760so13269611iof.16
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=92yThg6uO5wYmeILOZOePwh93S5XAe0V6zbbybcWJO0=;
        b=i8aV3pLEUHpV8nXWQejniH7FEzLP8jg949SwENv5zTVoiJGTZd5TwY/1w91ERZrox0
         dlN3HwtTO31IwGn6e/B3TuSCOQQm7dKyNiUV40v7hxEjbFWEcyRcZxC168KOP6k1/OfS
         jxKYpIBm3d2p9W8ifhUVEwp1lD83DfArX3ITyaWijicrxxCBJMTO7Fi5HTNoxzRWdCeb
         EE+WfmCQTV60LLuIRSFP9gaxAN7buL4cIwzvgC6gcZfzZ3hKUE+R4RsZmIWW/axj9le0
         HQjD41G7SS0PeezOqVyGly61uUTLoGTrnjv0d+tQNKIRhIkJ8oBIss8deXzS95QsbtGr
         sc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=92yThg6uO5wYmeILOZOePwh93S5XAe0V6zbbybcWJO0=;
        b=KsIrrNbZuntSOYoe1sVPx7SDlSinrbc+r7AEPhAu2PyZTrriBPRqDlVVQjIPwPtv7Q
         6Q4IVEYqmiBXwhCja5nREorfC6jK5RvAwyt9IAAvxA1bzSq2AvX/MPADiacbFFPiWDbT
         f9JXeOXuDOKHQxs0pbQ4Ho5CXfWg6+oz8aG9nnWAq6TrhPAS+gk9tXklhBZ4f7Glz3tB
         hk9tLvKSNjIfiFpU7GJdC6tDe0Fg7S6Qy04GnH7AH/mpw2X1ckFcFE2HnwV6EZcp+Ihx
         ZLNUiTnSMOxw6EK6LRkbvB9hG01lMWMkPsoPD8DuVr3ZdkLaLPe44bZSlCSEiz4IbKhf
         aPog==
X-Gm-Message-State: AOAM532QrBm01OTcoSl7i7Sx3bR9XGcAlC30xVKqnkkOUC11i/0FoeiC
        tiUoCKlUjJX5GvG9rpdj1hIIEZAi5GRJjqFa0YXGvKSzn6XlYP5gEhAgbrq5d/tDRWajLamwa9f
        CFRgS20RVhnp/wFddL2yXbnrQGtFOLlrHMCyT6FI+TOsdaFWPwMksG+j9Tg==
X-Google-Smtp-Source: ABdhPJyUcgnGwNxKx/wbpDMOBmF7XheuCQzfCiRREH/w9XfYAuChqvaYmfRLxURgaVhKUn8EYU62XV0YxJ8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:ab0a:: with SMTP id v10mr3181975ilh.17.1626720608785;
 Mon, 19 Jul 2021 11:50:08 -0700 (PDT)
Date:   Mon, 19 Jul 2021 18:49:45 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-9-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 08/12] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new vCPU attribute that allows userspace to directly manipulate
the virtual counter-timer offset. Exposing such an interface allows for
the precise migration of guest virtual counter-timers, as it is an
indepotent interface.

Uphold the existing behavior of writes to CNTVOFF_EL2 for this new
interface, wherein a write to a single vCPU is broadcasted to all vCPUs
within a VM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 22 ++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arch_timer.c             | 68 ++++++++++++++++++++++++-
 3 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index b46d5f742e69..7b57cba3416a 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -139,6 +139,28 @@ configured values on other VCPUs.  Userspace should configure the interrupt
 numbers on at least one VCPU after creating all VCPUs and before running any
 VCPUs.
 
+2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
+------------------------------------------------
+
+:Parameters: Pointer to a 64-bit unsigned counter-timer offset.
+
+Returns:
+
+	 ======= ======================================
+	 -EFAULT Error reading/writing the provided
+	 	 parameter address
+	 -ENXIO  Attribute not supported
+	 ======= ======================================
+
+Specifies the guest's virtual counter-timer offset from the host's
+virtual counter. The guest's virtual counter is then derived by
+the following equation:
+
+  guest_cntvct = host_cntvct - KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
+
+KVM does not allow the use of varying offset values for different vCPUs;
+the last written offset value will be broadcasted to all vCPUs in a VM.
+
 3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
 ==================================
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..008d0518d2b1 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -365,6 +365,7 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER	2
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..d2b1b13af658 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1305,7 +1305,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	}
 }
 
-int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+int kvm_arm_timer_set_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	int __user *uaddr = (int __user *)(long)attr->addr;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
@@ -1338,7 +1338,39 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return 0;
 }
 
-int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	u64 offset;
+
+	if (get_user(offset, uaddr))
+		return -EFAULT;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		update_vtimer_cntvoff(vcpu, offset);
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
+	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+		return kvm_arm_timer_set_attr_irq(vcpu, attr);
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		return kvm_arm_timer_set_attr_offset(vcpu, attr);
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_timer_get_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	int __user *uaddr = (int __user *)(long)attr->addr;
 	struct arch_timer_context *timer;
@@ -1359,11 +1391,43 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return put_user(irq, uaddr);
 }
 
+int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	struct arch_timer_context *timer;
+	u64 offset;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		timer = vcpu_vtimer(vcpu);
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	offset = timer_get_offset(timer);
+	return put_user(offset, uaddr);
+}
+
+int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
+	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+		return kvm_arm_timer_get_attr_irq(vcpu, attr);
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		return kvm_arm_timer_get_attr_offset(vcpu, attr);
+	}
+
+	return -ENXIO;
+}
+
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
 		return 0;
 	}
 
-- 
2.32.0.402.g57bb445576-goog

