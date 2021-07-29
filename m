Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C9D3DAA4D
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhG2RdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhG2RdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 13:33:17 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30DAC0613D5
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:13 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so4259241qkd.0
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tWp4QqVMPEQEhDxfNdWfM4hSXZXvk7lxfQAckJjLAqA=;
        b=BfRwJ0QWyzCLQRDRmQyJEtUje8JBbrz83rAucF5ipfus6AeWvzpnDjCnWn70+9KgiI
         yZhuYBnczFa2hUQAYmcWeLwcwjbbyhP/AHnczh8DeS7tVlNWKHx5WgFsghbm0gfF0jts
         p4D80XWLp5DrD+8YI8Bv3Jkqj30WmCgIcuTVo3n2YbVrUzVVT4pwkQ5GkY9/D5QBVc9Z
         dnEnzNYzCNkgUqPp4ztl9Gy8McDpJj9oApriBT8ka/5VCKDXQ3kt1ETJMP7UhKnDo/we
         BC7jj6qgA2ZilNiHkMX2tU5Sb1rRvQUKX+eXS5zTgnGI/aJSMZAvKnEsh4fWjrR1q0Qg
         i/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tWp4QqVMPEQEhDxfNdWfM4hSXZXvk7lxfQAckJjLAqA=;
        b=RtSCyx/gjFn7q6iSBT9GAJ1KsU9oljYJyWcmq7+fXIgFhKd4J6UGtUAWt/O9YRzydB
         kttor4K3AAXBbUWyLGX4l/EfkeHAQ6gS5bTo8ra9o8bXUnBwzc/MUMpkF8s0SVjHcQB+
         MAPyQhKh5v3P5sz7kwgy7NkYKggtGszvDcv3LmYwrFluzPqeqrgSycDgVmD8VDsiau1+
         LDUACfk6UQ6onkUA7xr0rTiI22EYTBeI9GJNh18eKtfqjLHAayFdfh++16Piq0BIbbZd
         pikNh62NVzPVVR0V43Q4y7RIP7UDzUSEJU48tfNQvwYhIX1olzIHrnBpfVNlBTWo7S4a
         aB5Q==
X-Gm-Message-State: AOAM531kDcNAAUMposCLAM4jR2QoQz2/qRvCoYkWg2wVFA7zKRi7/Awa
        4ZwrNOpVTIpcXExOhRf2mBuDeecJC8KaReR57NV+CTyEWE0ePuNMEO4uXkiJcT4ykJoIujb2sCO
        fs3q2V7Qp//Yycq7MMC9aHXD688f6KLmEhKyO99ZvMse4Bbzj0w0pk6Z+Lw==
X-Google-Smtp-Source: ABdhPJxCE/6cxmHAmOJ15Lxiq41dl28sqCTb6rChEr3qenRhc+JvYfDFTpk5+e6maSQNBVbFIuPvL2wVyws=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:a63:: with SMTP id
 ef3mr6461527qvb.15.1627579993003; Thu, 29 Jul 2021 10:33:13 -0700 (PDT)
Date:   Thu, 29 Jul 2021 17:32:56 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-10-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 09/13] KVM: arm64: Allow userspace to configure a vCPU's
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
index 0f46f2588905..ecbab7adc602 100644
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

