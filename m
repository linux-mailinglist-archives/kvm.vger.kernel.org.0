Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D973C3108B3
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhBEKIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhBEKFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:05:20 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72493C061226
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:04:22 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s23so4174731pgh.11
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/PJ61fo9xTy9RzimRJay/I1Dn+ye7aFiCT1Xg00M47A=;
        b=dpbVjHXkQKB9iA8D5ashsIXA85IFaphjDhkfSQvcZxwUr8TPbimSegZ2EnH02lOVxa
         ma6MmsFR4b3XqGPPX8iwJ+L6cKapGB6Ue3jHPnB+SDdKHhmqBHvk9z/2Viwtucf6Wsfb
         0t6TnlC++1J1AyOKN7j5Rk4pDNOf71PuAwRMlB+rueoU5B80Srh6CuQq8C46YsPBCP4A
         JRkNakS+B527bAw5L0UYcoK6QwWeEnK48FyS2MTLpc75eFKSolfxhZTGaVUhcoLsoNZY
         i3XMjEMw9fQt3//GMcldipNMRr7zOMVGk9LoGqZMR5JdqF0/75NsmJXS8VSWP1+OP59V
         nIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/PJ61fo9xTy9RzimRJay/I1Dn+ye7aFiCT1Xg00M47A=;
        b=GYbqX8Ry0cuqF0YWS8DgtEyjZr5erJxM4+sl8QPkUOCpcStsSWHLd8OCnW+vJHQAKR
         mSLUc8EmtLesRrJdOZgnJPaOz5UEEaMa3H7YFvKqRvJBvlDg1rxbURowoqtjTAYB2oOD
         CUp9TnJDaNPkE9WIIozyv19V2ej1JSb+xjHE0B88RZ4ER4yHQ7Xy6rSsU30TqyJ8Cs2E
         RsNb404FGlS6XdWuOfBfjpLrbl2ZTofCXHT0Lm3oZDwGIgnlfFqPOmnAcL2Rp2Oy9Isq
         Sy/QDbwKQhRIBWX2nJ8QBaPixkiSG5TXSy+rn/TPgQ6fICt5xkRCDfWHcKhpzmhbV8UI
         lT9Q==
X-Gm-Message-State: AOAM530VaGkHJJXn2WDJfcuED5H6OtIyo94eaLthulGBrDh4uOBHE9td
        uCvH8kVW2eKiEQhg561IdehcIw==
X-Google-Smtp-Source: ABdhPJyurS1vSa9vpFd+/2RfkAauqDvIZcNkk7cwo7pe8dfRMslNQfdGhdO1frzJOWpFjjcnNVv2Ag==
X-Received: by 2002:a65:624a:: with SMTP id q10mr3678993pgv.2.1612519462027;
        Fri, 05 Feb 2021 02:04:22 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.04.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:04:21 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 8/9] KVM: vmx: Dynamically open or close the timer-passthrough for pre-vm
Date:   Fri,  5 Feb 2021 18:03:16 +0800
Message-Id: <20210205100317.24174-9-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Timer passthrough is default disabled

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/lapic.c            | 10 +-------
 arch/x86/kvm/vmx/vmx.c          | 52 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c              |  6 +++++
 include/linux/kvm_host.h        |  1 +
 include/uapi/linux/kvm.h        |  2 ++
 tools/include/uapi/linux/kvm.h  |  2 ++
 virt/kvm/kvm_main.c             |  1 +
 8 files changed, 62 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7971c9e755a4..9855ef419793 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1304,9 +1304,8 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
-	void (*set_timer_passthrough)(struct kvm_vcpu *vcpu, bool enable);
-	int (*host_timer_can_passth)(struct kvm_vcpu *vcpu);
 	void (*switch_to_sw_timer)(struct kvm_vcpu *vcpu);
+	int (*set_timer_passth_state)(struct kvm *kvm, void *argp);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9b2f8b99fbf6..9ba4157f9b81 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1508,15 +1508,6 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 		}
 		apic->lapic_timer.timer_mode = timer_mode;
 		limit_periodic_timer_frequency(apic);
-
-		if (kvm_x86_ops.host_timer_can_passth(apic->vcpu)) {
-			if (apic_lvtt_tscdeadline(apic)) {
-				kvm_x86_ops.set_timer_passthrough(apic->vcpu, true);
-			} else {
-				if (apic->vcpu->arch.timer_passth_enable)
-					kvm_x86_ops.set_timer_passthrough(apic->vcpu, false);
-			}
-		}
 	}
 }
 
@@ -2219,6 +2210,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	apic->lapic_timer.tscdeadline = data;
+	vcpu->arch.tscd = data;
 	start_apic_timer(apic);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 98eca70d4251..b88f744478e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -216,6 +216,8 @@ static DEFINE_MUTEX(vmx_l1d_flush_mutex);
 /* Storage for pre module init parameter parsing */
 static enum vmx_l1d_flush_state __read_mostly vmentry_l1d_flush_param = VMENTER_L1D_FLUSH_AUTO;
 
+static void vmx_set_timer_passthrough(struct kvm_vcpu *vcpu, bool enable);
+
 static const struct {
 	const char *option;
 	bool for_parse;
@@ -6742,9 +6744,9 @@ static void vmx_restore_passth_timer(struct kvm_vcpu *vcpu)
 		host_tscd = local_timer_info->host_tscd;
 		rdmsrl(MSR_IA32_TSC_DEADLINE, guest_tscd);
 
-		if (guest_tscd != 0 &&
-			guest_tscd != host_tscd) {
+		if (guest_tscd != 0 && guest_tscd != host_tscd) {
 			vcpu->arch.tscd = guest_tscd;
+			vcpu->arch.apic->lapic_timer.tscdeadline = vcpu->arch.tscd;
 		}
 
 		if (host_tscd > rdtsc())
@@ -6873,6 +6875,15 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_wait_lapic_expire(vcpu);
 
+	if (vcpu->arch.timer_passth_enable) {
+		if (!atomic_read(&vcpu->kvm->timer_passth_state)) {
+			vcpu->arch.apic->lapic_timer.tscdeadline =
+				vcpu->arch.tscd;
+			vmx_set_timer_passthrough(vcpu, false);
+		}
+	} else if (atomic_read(&vcpu->kvm->timer_passth_state)) {
+		vmx_set_timer_passthrough(vcpu, true);
+	}
 	vmx_host_lapic_timer_offload(vcpu);
 
 	/*
@@ -7838,6 +7849,40 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static int vmx_set_timer_passth_state(struct kvm *kvm, void *argp)
+{
+	int r = -1;
+	int i;
+	struct kvm_vcpu *vcpu;
+	int state;
+
+	if (copy_from_user(&state, argp, sizeof(int)))
+		goto out;
+
+	if (!!state) {
+		/* judge whether support timer-pasth */
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (!vmx_host_timer_can_passth(vcpu) ||
+				(vcpu->arch.apic->lapic_timer.timer_mode !=
+				APIC_LVT_TIMER_TSCDEADLINE)) {
+				pr_err("host don't support timer passthrough\n");
+				goto out;
+			}
+		}
+	}
+
+	if (kvm->timer_passth_state.counter != (!!state)) {
+		atomic_set(&kvm->timer_passth_state, !!state);
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			kvm_vcpu_kick(vcpu);
+		}
+	}
+	r = 0;
+
+out:
+	return r;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7966,9 +8011,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
-	.set_timer_passthrough = vmx_set_timer_passthrough,
-	.host_timer_can_passth = vmx_host_timer_can_passth,
 	.switch_to_sw_timer = vmx_passth_switch_to_sw_timer,
+	.set_timer_passth_state = vmx_set_timer_passth_state,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b4aa925d6d9..7db74bd9d362 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5692,6 +5692,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_X86_SET_MSR_FILTER:
 		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
 		break;
+	case KVM_SET_TIMER_PASSTH_STATE: {
+		r = -EFAULT;
+		if (kvm_x86_ops.set_timer_passth_state)
+			r = kvm_x86_ops.set_timer_passth_state(kvm, argp);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f2e2a09ebbd..b3de12c3f473 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -505,6 +505,7 @@ struct kvm {
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
+	atomic_t timer_passth_state;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..6e26bc342599 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1557,6 +1557,8 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_X86_MSR_FILTER */
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
 
+#define KVM_SET_TIMER_PASSTH_STATE  _IO(KVMIO,   0xc7)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index ca41220b40b8..6e26bc342599 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1557,6 +1557,8 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_X86_MSR_FILTER */
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
 
+#define KVM_SET_TIMER_PASSTH_STATE  _IO(KVMIO,   0xc7)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..7e7a3adede62 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -751,6 +751,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	INIT_LIST_HEAD(&kvm->devices);
+	atomic_set(&kvm->timer_passth_state, 0);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
-- 
2.11.0

