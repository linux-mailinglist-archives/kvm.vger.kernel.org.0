Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2243D99F5
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhG2AKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 20:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhG2AKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 20:10:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BD7C061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso4903976ybq.10
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5DbD1Q+qmrgXW1lgcWRvAuq0EQtstHhiJ0h0O5Opgts=;
        b=Z0pFd+fRkipK8U/pIAuUqtwvdVc9bEtZHmh/lq85Abvzhs5wjcYtzX2H3ZtFokcwqx
         eFSqqr2JIZzkkdZ2Sgoj19OzmTFwDsaozKtGyeK8AzoZqClGTmfVmPxopBamClvTTpRf
         kZmLya08L+m+O/tFpv9IXq/kfLsueulX4mGILCb9UBg47awjjy/LxWbS4/XUJcs4+fxO
         eiDGg5elS7VOqz54L3FzfLusNXSYZNpqXPV3oEa/OaeYy4y7KFJsgAB5MxOi8smZQ6AT
         jyhCHBP/iIoWJZgL7SgImPXg1TK29bNScECn30ZqGmtRP74JLyoWf9XdrQTzfPZGydOB
         RYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5DbD1Q+qmrgXW1lgcWRvAuq0EQtstHhiJ0h0O5Opgts=;
        b=ksAbz19jwMDTpIe08j1/EsPIubvGfeC+d8vU3LlY0iFKB+z3Wr42QLBy2G3k5JR5uq
         4A12RY9lj9997jyA0UQGbygw+LaexnaT8rKFGHY+BDDN8b1EDbHUNUyMzwBiigCYBaCr
         f3TgEfC4Mo3GPk1kjtwOvMFpFYu+F9JJ88bzGTHxfkOWZC0KweeHr8xS9pyO3Htvr1M6
         saB4vaK0Zi6oUrGSDHMhsjtKxBTQ4gO7UDEVFTa5QSkWrXuWR43tx6Y39/Ul3XgM8p/a
         DyWuTqsJeMtJEBWCuvsFPuZu9B5Kfg+sB0mjElPMoi/W9M1WCh2HkxgN/FAa7CYhCU9X
         ykUg==
X-Gm-Message-State: AOAM5317mEDCw4OExZah0AojK5UEbZZJvepnqSev47dZV7wJfSWMT+LI
        9SY/70RtrblJEUn9qcTbHgBKZ/nsTt/BARuycl+0Ohr7chZAfcP2HT3gLPpnMDwpVp74FyjZIZ6
        /LWhrAdAOmj3BGc9mLOmM0uWW57H2MH3kvefgKLMERFnSE+e07h1a2HdWzg==
X-Google-Smtp-Source: ABdhPJz/QxbjCh4OAB6U0SLDDIYt3vC9UfRhP52R2YQR2YhIealazv3Pac7KW7OwIkfUIEfN9ABqvxBOSnI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:6088:: with SMTP id u130mr3181834ybb.257.1627517430962;
 Wed, 28 Jul 2021 17:10:30 -0700 (PDT)
Date:   Thu, 29 Jul 2021 00:10:08 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-10-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 09/13] KVM: arm64: Allow userspace to configure a vCPU's
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
        Andrew Jones <drjones@redhat.com>,
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

Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.32.0.432.gabb21c7263-goog

