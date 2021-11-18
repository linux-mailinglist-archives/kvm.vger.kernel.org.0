Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22B04559A3
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343615AbhKRLLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343599AbhKRLLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:11:12 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C30C061570;
        Thu, 18 Nov 2021 03:08:12 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so7866108pjb.5;
        Thu, 18 Nov 2021 03:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yV6Z6mOtzVk7r22nV+6uVyIHOaPeyekpA0C9QvKiS1w=;
        b=Vmfud0yckSu8N7LCXLbuJ1zYsyucBf18JDQ/anQXqHXBnIV7ngxMekeB57U2FWCT6z
         ocDvxgC7iiExO4+4efUXVZ/wn+X0Fak+ZD4JpKom9o99OizaVISgbBnHOExkNmniB9Wd
         aSGJMh6EOpKH944Vb3t38bINmB4CeOPrZ7jI6DTfMiDNXHz4jUoB/sE5JAWgsYCrRRob
         Vgsk25jj1x46QwD3HXtwLiVbVuQDvJ072GoIg4J49K901ZRSXiRF2Rf8O6y5SIFxzXiv
         Iwbw8CJ//AHdi21dKIvYjj2kzYUFoDLHPKFCFj8ZxRvNqnTtZTWWN5mC/VfsVGuFiwt7
         Q9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yV6Z6mOtzVk7r22nV+6uVyIHOaPeyekpA0C9QvKiS1w=;
        b=trDUE/GgHYXsxWdYoWfUZJBgIXvi3umZenniw/VahjIjGZWzYb287WMUV7IugLGdSh
         WRdY18W5G7QWVMs4kFUDC/vx8w1qHRz3TVY1qREnuQ+Ph/cuVZidop7oUETos5Aph3GU
         dtOSfJRPV1+MqX+ocxbpKjSMm/SImrAI81IeQgSRSkFLkeuliSdYen29SOMraAUDaial
         5GiHVycCV5JHJI8Ni44zINXNK50c1JTuDME410xWkIiROOdDFE0IOQYF9bmLWvb2YBnn
         1reAIo/Jc/3Ecy1eA7EX1MVJ/rpPClBBH/3bDh1xQEMVIj6UnFstm6XcLDW5mKdecdSs
         Ufvw==
X-Gm-Message-State: AOAM531wgE+qsbVX2TPuZHRy4RJR9uNrNdjkxQzp8p4sqS3yQ35s3Jqw
        QRQ+D+nXl0vcgWyi0KhL2qjUrt/VUVE=
X-Google-Smtp-Source: ABdhPJyhfqNff/2QkthErbTw2UavCmg6E0aNJE9gEkuQVBZ0i94mjZ1z+yHoUPyRmHONuzxH19bcdw==
X-Received: by 2002:a17:90a:9dca:: with SMTP id x10mr9487837pjv.170.1637233691773;
        Thu, 18 Nov 2021 03:08:11 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id y190sm2871691pfg.153.2021.11.18.03.08.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:11 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 01/15] KVM: VMX: Use x86 core API to access to fs_base and inactive gs_base
Date:   Thu, 18 Nov 2021 19:08:00 +0800
Message-Id: <20211118110814.2568-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

And they use FSGSBASE instructions when enabled.

Cc: x86@kernel.org
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ----------
 arch/x86/kernel/process_64.c    |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 14 +++++++-------
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1fcb345bc107..4cbb402f5636 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1808,16 +1808,6 @@ static inline void kvm_load_ldt(u16 sel)
 	asm("lldt %0" : : "rm"(sel));
 }
 
-#ifdef CONFIG_X86_64
-static inline unsigned long read_msr(unsigned long msr)
-{
-	u64 value;
-
-	rdmsrl(msr, value);
-	return value;
-}
-#endif
-
 static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 {
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3402edec236c..296bd5c2e38b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -443,6 +443,7 @@ unsigned long x86_gsbase_read_cpu_inactive(void)
 
 	return gsbase;
 }
+EXPORT_SYMBOL_GPL(x86_gsbase_read_cpu_inactive);
 
 void x86_gsbase_write_cpu_inactive(unsigned long gsbase)
 {
@@ -456,6 +457,7 @@ void x86_gsbase_write_cpu_inactive(unsigned long gsbase)
 		wrmsrl(MSR_KERNEL_GS_BASE, gsbase);
 	}
 }
+EXPORT_SYMBOL_GPL(x86_gsbase_write_cpu_inactive);
 
 unsigned long x86_fsbase_read_task(struct task_struct *task)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3127c66a1651..48a34d1a2989 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1156,11 +1156,11 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	} else {
 		savesegment(fs, fs_sel);
 		savesegment(gs, gs_sel);
-		fs_base = read_msr(MSR_FS_BASE);
-		vmx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+		fs_base = x86_fsbase_read_cpu();
+		vmx->msr_host_kernel_gs_base = x86_gsbase_read_cpu_inactive();
 	}
 
-	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+	x86_gsbase_write_cpu_inactive(vmx->msr_guest_kernel_gs_base);
 #else
 	savesegment(fs, fs_sel);
 	savesegment(gs, gs_sel);
@@ -1184,7 +1184,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	++vmx->vcpu.stat.host_state_reload;
 
 #ifdef CONFIG_X86_64
-	rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+	vmx->msr_guest_kernel_gs_base = x86_gsbase_read_cpu_inactive();
 #endif
 	if (host_state->ldt_sel || (host_state->gs_sel & 7)) {
 		kvm_load_ldt(host_state->ldt_sel);
@@ -1204,7 +1204,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 #endif
 	invalidate_tss_limit();
 #ifdef CONFIG_X86_64
-	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+	x86_gsbase_write_cpu_inactive(vmx->msr_host_kernel_gs_base);
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
 	vmx->guest_state_loaded = false;
@@ -1216,7 +1216,7 @@ static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
 {
 	preempt_disable();
 	if (vmx->guest_state_loaded)
-		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+		vmx->msr_guest_kernel_gs_base = x86_gsbase_read_cpu_inactive();
 	preempt_enable();
 	return vmx->msr_guest_kernel_gs_base;
 }
@@ -1225,7 +1225,7 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 {
 	preempt_disable();
 	if (vmx->guest_state_loaded)
-		wrmsrl(MSR_KERNEL_GS_BASE, data);
+		x86_gsbase_write_cpu_inactive(data);
 	preempt_enable();
 	vmx->msr_guest_kernel_gs_base = data;
 }
-- 
2.19.1.6.gb485710b

