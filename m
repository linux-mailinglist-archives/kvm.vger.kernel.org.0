Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945613116EC
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 00:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhBEXUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 18:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhBEKE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:04:29 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B896C06121D
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:03:47 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id n10so4178562pgl.10
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LonXl/15tkQWb44D5TjLTQyIRrN2PpMazddzhn/PCHg=;
        b=mw/Oa5P5KOZBJw7Qamf5I2esCc/1Z4uBTEM6tkIoeeZGhsBurR4+jWZSN3ckqtzCDa
         78Bx/wNzizIGYyCPBL9Qm44682csen0V2rFwuxpoB7P/bam2KNGhESn4G7nHrn6PfD95
         terpl+IIJD5jkyCfrVuNFoqO3mn7JTvTUjdRNYvoU2GwngL34qf+2GKGmxq8kzrM1msL
         732gJ8FhSUlvwt4EwHXb8If+xKyM/fDR6uH8FVpPhUI48IR2cOWvy1q9LzXZWv+aUlPe
         tqKO3OUghK79GQIXBjWwA2CynjL5LvQ44/rVy0Pci0rUqYrrgbDHz37UMj8DEJHtpoh/
         Qb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LonXl/15tkQWb44D5TjLTQyIRrN2PpMazddzhn/PCHg=;
        b=kx1/F115/Do5M0exjIon3W6tguzCkqQPuvNsPraZGgxsLBYsXUdX/VmvWMPEC10+CO
         kzHlyZR/Dplx3BRwBT1wR/qqSHTtpnSMd+ofzZcNKi2NV0luzxCQ2J+isEtlvIRXo97B
         GYYXSWmTMZ/X2Z8ILi9zhbQAh06h8VMV8KP0NN4HlsYO+p5i84PZduIMvYyWAXQnPfTq
         qRC5qicrs9BebTMT+ktfp81EuohFNrIzusECvy6O/hGf3n+ECCUVa+gwmWIcaL9ke2B/
         z1HCSfjcHabsCmfCuu3TYjSUtuJypNb+r5phsvZyQJEQuWb/6jcue03XhBwGMI/P6Lik
         dfhw==
X-Gm-Message-State: AOAM53375PDtW2h1MYYKGxiqAfXiIzXVhMhhQUyjvBaPiSI90zW6XLzb
        kJLhEgUB4AgQ4ldnnbrCvp6hJA==
X-Google-Smtp-Source: ABdhPJzwjleE19Eu2t8sLfNPCuvLyxsIGIhDVtX43FebkOLq7I+EbNqKKkVP7E+KCYjLqA7LB0HDwQ==
X-Received: by 2002:a63:7885:: with SMTP id t127mr3620590pgc.15.1612519426977;
        Fri, 05 Feb 2021 02:03:46 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.03.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:03:46 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 3/9] KVM: vmx: enable passthrough timer to guest
Date:   Fri,  5 Feb 2021 18:03:11 +0800
Message-Id: <20210205100317.24174-4-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow Guest to write tscdeadline msr directly.

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/lapic.c            |  9 +++++++
 arch/x86/kvm/vmx/vmx.c          | 56 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 82a51f0d01a2..500fa031297d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -533,6 +533,7 @@ struct tick_device {
 
 struct timer_passth_info {
 	u64 host_tscd;
+	bool host_in_tscdeadline;
 	struct clock_event_device *curr_dev;
 
 	void (*orig_event_handler)(struct clock_event_device *dev);
@@ -1302,6 +1303,8 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+	void (*set_timer_passthrough)(struct kvm_vcpu *vcpu, bool enable);
+	int (*host_timer_can_passth)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 86c33d53c90a..9b2f8b99fbf6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1508,6 +1508,15 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 		}
 		apic->lapic_timer.timer_mode = timer_mode;
 		limit_periodic_timer_frequency(apic);
+
+		if (kvm_x86_ops.host_timer_can_passth(apic->vcpu)) {
+			if (apic_lvtt_tscdeadline(apic)) {
+				kvm_x86_ops.set_timer_passthrough(apic->vcpu, true);
+			} else {
+				if (apic->vcpu->arch.timer_passth_enable)
+					kvm_x86_ops.set_timer_passthrough(apic->vcpu, false);
+			}
+		}
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0bf9941df842..0c1b5ee4bb8e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,6 +47,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/apicdef.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -705,6 +706,8 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		/* PT MSRs. These are handled in pt_update_intercept_for_msr() */
 		return true;
+	case MSR_IA32_TSC_DEADLINE:
+		return true;
 	}
 
 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
@@ -7670,6 +7673,54 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void host_lapic_timer_in_deadline(void *junk)
+{
+	unsigned int v;
+	struct timer_passth_info *local_timer_info;
+	int cpu = smp_processor_id();
+
+	local_timer_info = &per_cpu(passth_info, cpu);
+	v = apic_read(APIC_LVTT);
+	local_timer_info->host_in_tscdeadline = (v & APIC_LVT_TIMER_TSCDEADLINE);
+}
+
+static bool host_all_cpu_in_tscdeadline(void)
+{
+	int cpu;
+	struct timer_passth_info *local_timer_info;
+
+	for_each_online_cpu(cpu) {
+		local_timer_info = &per_cpu(passth_info, cpu);
+		if (!local_timer_info->host_in_tscdeadline)
+			return false;
+	}
+
+	return true;
+}
+
+static int vmx_host_timer_can_passth(struct kvm_vcpu *vcpu)
+{
+	if (!enable_timer_passth || !cpu_has_vmx_msr_bitmap() ||
+			!host_all_cpu_in_tscdeadline())
+		return 0;
+	return 1;
+}
+
+static void vmx_set_timer_passthrough(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (enable) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC_DEADLINE,
+									  MSR_TYPE_RW);
+		vcpu->arch.timer_passth_enable = 1;
+	} else {
+		vmx_enable_intercept_for_msr(vcpu, MSR_IA32_TSC_DEADLINE,
+									 MSR_TYPE_RW);
+		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
+				PIN_BASED_VMX_PREEMPTION_TIMER);
+		vcpu->arch.timer_passth_enable = 0;
+	}
+}
+
 static void hardware_unsetup(void)
 {
 	if (enable_timer_passth)
@@ -7817,6 +7868,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
+	.set_timer_passthrough = vmx_set_timer_passthrough,
+	.host_timer_can_passth = vmx_host_timer_can_passth,
 };
 
 static __init int hardware_setup(void)
@@ -7987,6 +8040,9 @@ static __init int hardware_setup(void)
 	vmx_set_cpu_caps();
 
 	if (enable_timer_passth)
+		on_each_cpu(host_lapic_timer_in_deadline, NULL, 1);
+
+	if (enable_timer_passth)
 		on_each_cpu(vmx_host_timer_passth_init, NULL, 1);
 
 	r = alloc_kvm_area();
-- 
2.11.0

