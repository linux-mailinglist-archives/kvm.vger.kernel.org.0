Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD693108B1
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhBEKG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBEKEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:04:23 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78349C0617AA
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:03:40 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nm1so3348995pjb.3
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioiNjnFim0WwNMLpqZvgmNVZtgITdPMhocz2H3dneLk=;
        b=tlKgPMwOuPKHyoNc2MRRwpS5hMH4652VyHhYA/JCs3/B+VjFdmgMPIgdUxHAebTVOb
         M9fr27VcfQJ3aizjqK1dBq4vbo6HiNzEikaiLLZmFHi9ZmHjovVVcIjCx1hSiB+cOWcj
         weXml2M/LSiW/4vKoGKdAfh35IP9qrkzLoJGPpldPeXuyeX0balA+u9v6rDvNTyb5K+W
         Vn6NOKz7MdwD58Qz2BEeR5Xs8c9tuuICGE2S4yCNbVvyvse01zPDsCIXt+iPjniC0Nc9
         iQhhMR+w4bO5nTCwLFkY+72+EXVsB/h1s+RYruzTrnErrsm/ptP6RmFqZcB1clR55o6S
         mvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioiNjnFim0WwNMLpqZvgmNVZtgITdPMhocz2H3dneLk=;
        b=mzqzyPys6TZqbkPm5TbSQ7Q5aRhjqZgwzhr4Fg5AFIW/s2YYl6mkn100+u4tdv2VzV
         74BfzesGh5++wwvrXFPXEWo4cDk+A2JO/fAlf0aoisDsgunoCruwGtvxDOrMEGpflt3r
         ng6pcxXverZZaTHNY8EVhEDVb63kMkVJ1VsdLS4lRAXNmyVksS2f1JEUe5DHR7jCpV6i
         PMl6JzDInIKxCS9ZLT5lDAv5J1dcbZinE7ok4WBCzkFQ91Nmb68Ytfq42ffoY9RSfKry
         fza0IbuwNjyWRAQ83n7Mr1XMtcJniUHZeAwxNfzZDqXz5l0ngA8EYGZqDiBKt2ZorcBv
         Si8g==
X-Gm-Message-State: AOAM533U5WiPNYuuVZ3qlLXVRdb3ci+G7bb7mjNv5EOSNzaCI/yiSE6f
        FhqnAyPSyeXmbsqDDbMy09S22g==
X-Google-Smtp-Source: ABdhPJytYhEvPY5WfM5al4ZEHEIDG7FVy08PoUnjYPNpd+F/ePJ3S9H0vKaxn5uWbd7IuPASeTbSpg==
X-Received: by 2002:a17:902:6b89:b029:da:fc41:baec with SMTP id p9-20020a1709026b89b02900dafc41baecmr3584404plk.39.1612519420061;
        Fri, 05 Feb 2021 02:03:40 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.03.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:03:39 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RFC: timer passthrough 2/9] KVM: vmx: enable host lapic timer offload preemtion timer
Date:   Fri,  5 Feb 2021 18:03:10 +0800
Message-Id: <20210205100317.24174-3-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use preemption timer to handle host timer

Signed-off-by: Zhimin Feng <fengzhimin@bytedance.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 54 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  1 +
 3 files changed, 56 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eb6a611963b7..82a51f0d01a2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -826,6 +826,7 @@ struct kvm_vcpu_arch {
 	} pv_cpuid;
 
 	bool timer_passth_enable;
+	u64 tscd;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 38b8d80fa157..0bf9941df842 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5629,6 +5629,13 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vcpu->arch.timer_passth_enable) {
+		local_irq_disable();
+		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), LOCAL_TIMER_VECTOR);
+		local_irq_enable();
+
+		return EXIT_FASTPATH_NONE;
+	}
 	if (!vmx->req_immediate_exit &&
 	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
 		kvm_lapic_expired_hv_timer(vcpu);
@@ -6640,6 +6647,51 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
+static void vmx_host_lapic_timer_offload(struct kvm_vcpu *vcpu)
+{
+	struct timer_passth_info *local_timer_info;
+	u64 tscl;
+	u64 guest_tscl;
+	u64 delta_tsc;
+	struct hrtimer *timer;
+
+	if (!vcpu->arch.timer_passth_enable)
+		return;
+
+	local_timer_info = &per_cpu(passth_info, smp_processor_id());
+
+	tscl = rdtsc();
+	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
+
+	timer = &vcpu->arch.apic->lapic_timer.timer;
+	if (hrtimer_active(timer))
+		hrtimer_cancel(timer);
+
+	if (local_timer_info->host_tscd > tscl) {
+		delta_tsc = (u32)((local_timer_info->host_tscd - tscl) >>
+				cpu_preemption_timer_multi);
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, delta_tsc);
+		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
+				PIN_BASED_VMX_PREEMPTION_TIMER);
+	} else {
+		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
+				PIN_BASED_VMX_PREEMPTION_TIMER);
+	}
+
+	wrmsrl(MSR_IA32_TSCDEADLINE, 0);
+	if (vcpu->arch.tscd > guest_tscl) {
+		wrmsrl(MSR_IA32_TSCDEADLINE, vcpu->arch.tscd);
+	} else {
+		if (vcpu->arch.tscd > 0) {
+			if (!atomic_read(&vcpu->arch.apic->lapic_timer.pending)) {
+				atomic_inc(&vcpu->arch.apic->lapic_timer.pending);
+				kvm_inject_pending_timer_irqs(vcpu);
+				kvm_x86_ops.sync_pir_to_irr(vcpu);
+			}
+		}
+	}
+}
+
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
@@ -6761,6 +6813,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_wait_lapic_expire(vcpu);
 
+	vmx_host_lapic_timer_offload(vcpu);
+
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
 	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d353a9c9881..e51fd52a4862 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9912,6 +9912,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 	vcpu->arch.timer_passth_enable = false;
+	vcpu->arch.tscd = 0;
 
 	kvm_hv_vcpu_init(vcpu);
 
-- 
2.11.0

