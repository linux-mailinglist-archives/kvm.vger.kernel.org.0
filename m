Return-Path: <kvm+bounces-9909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E2C86791A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 757D71F26FFA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B408212D766;
	Mon, 26 Feb 2024 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLckvUP1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B51313B2BE;
	Mon, 26 Feb 2024 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958230; cv=none; b=GepthXsp7w27LghAs+v9/AErriKw+FhZsHuoZ1fAUEHciWF1R9jYmzgRhKDgCoHYij4R/2vaBgd7HXyXt/JS4JCOW/xmBiHNxk9y4WHBFIn0wg/fwlpgxJv3agccA7c+dIruK4wl6Pdtd7ELzhkaZYzVU9Bctr+LkyfJuYhDJM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958230; c=relaxed/simple;
	bh=oFLpUu2MeS6BRZ/Jxq6k+lA8YlZJnhVOkKcRl5d5Fow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GV+ylua7fheFl3uRfLZcrDXnNr0XnBg4iqiT/1iKtcLwlWSCX2swWux7PfmjYg2hQ4Lyz9cfAn9wItS79Zm+btr+RUjHndks7tUeGFUxrnyeMLlriBS+o65CqV7BOXxHoSZ8dNU04c0qzQ2+qg7r42sJtVWi0tlgqgNy65vuHyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLckvUP1; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1db6e0996ceso23695275ad.2;
        Mon, 26 Feb 2024 06:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958227; x=1709563027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUYgIc9I0TbzhgfqqzmtJ/r7wde5wI9PGH/CYLTDvPE=;
        b=iLckvUP15BVLyuUhvdIyi+ZB/uypMJv+NuNqi9LjlgpBsXZJB+vTCb/h2+7KLZ/8/S
         XJHCDX3O1UtfIuoyn6uPQCMluaVjLnL3SkiqEj+07ATztrV2JID6l6nphZ5fvzKP/jdk
         tGt8vrZeNjaAweKJjcOEjWUXIaEHhucykgiAi7Fs51uGU98jcCeNQ4/AWNOyAfyXgbex
         dwYBBsWsJcVXl8kKtKnWkiRR0xL8d1/0qBbt48KRMbLmDCBgvWC7FCaSRRMjlmfDlQ61
         2upN6PqvRPUW4I93K6lIqvheZMzMbkFVqQSchM8oPWAsu5di6K99VfcOMLpMrTK3biSw
         JTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958227; x=1709563027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aUYgIc9I0TbzhgfqqzmtJ/r7wde5wI9PGH/CYLTDvPE=;
        b=fPg2fPWROG4TKCsMV7ZYijn+2rYKvg4+Hzpx2555qL0tMHChqimWbhumwhZWumqrKB
         C0l1OJXKlPZjMwWwnC9rQZ4Fx5NVM2ErkFgWg0aPaiFW28Q7iwukB00EZOQFPTVqTgZ/
         uIWU9zOShK/U/mXthXVuLRiCDps+ErnSlMcHwmJmiHjBOj7rEetg+yh81TIUe6Z0TAwU
         iXSkDeYto/SYKXxCq+Df1y/xzvTLFeyqCzTmY0vV33yJDwQDG72DXcvJodYqDNKWyAmC
         X1Hojv1qh/AwoEP0BJIXeNcQZZ4blVFGjGcDwpcoxq0WIyGHlBO07yHhE6jt5VjFDrO8
         kP0A==
X-Forwarded-Encrypted: i=1; AJvYcCXATpXRsbkHv5jwinxVDbyuXtU0JXvwuWrp2BYRny3NEd8OZ5IrNwmKw4FtDvuNVGMG7SZ7pdBPuNADrTPXyACx8j3F
X-Gm-Message-State: AOJu0YzDSVgwMTJckG/haZamQ2hsWW+vXijmQJaU1fKIE0KeX+Qb1oH0
	2F1mA724CFrW8WX7pDVxkuAZkVV3TFnugYmQSKC2joGcPkx6GN1G1D59jM0S
X-Google-Smtp-Source: AGHT+IFJaJHhws5Iu1WFFipNsAdqIIPIxk4VjyF0aTOqhtII3ndXXVxgujlU2qF2jxijoIMCL/nFaw==
X-Received: by 2002:a17:903:2343:b0:1db:d256:9327 with SMTP id c3-20020a170903234300b001dbd2569327mr8634686plh.19.1708958227515;
        Mon, 26 Feb 2024 06:37:07 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id li6-20020a170903294600b001dc94fde843sm2603712plb.177.2024.02.26.06.37.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:07 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 46/73] KVM: x86/PVM: Support for CPUID faulting
Date: Mon, 26 Feb 2024 22:36:03 +0800
Message-Id: <20240226143630.33643-47-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

For PVM, CPUID faulting relies on hardware, so the guest could access
the host CPUID information if CPUID faulting is not enabled. To enable
the guest to access its own CPUID information, introduce a module
parameter to force enable CPUID faulting for the guest.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 69 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index e6464095d40b..fd3d6f7301af 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -29,6 +29,9 @@
 MODULE_AUTHOR("AntGroup");
 MODULE_LICENSE("GPL");
 
+static bool __read_mostly enable_cpuid_intercept = 0;
+module_param_named(cpuid_intercept, enable_cpuid_intercept, bool, 0444);
+
 static bool __read_mostly is_intel;
 
 static unsigned long host_idt_base;
@@ -168,6 +171,53 @@ static bool pvm_disallowed_va(struct kvm_vcpu *vcpu, u64 va)
 	return !pvm_guest_allowed_va(vcpu, va);
 }
 
+static void __set_cpuid_faulting(bool on)
+{
+	u64 msrval;
+
+	rdmsrl_safe(MSR_MISC_FEATURES_ENABLES, &msrval);
+	msrval &= ~MSR_MISC_FEATURES_ENABLES_CPUID_FAULT;
+	msrval |= (on << MSR_MISC_FEATURES_ENABLES_CPUID_FAULT_BIT);
+	wrmsrl(MSR_MISC_FEATURES_ENABLES, msrval);
+}
+
+static void reset_cpuid_intercept(struct kvm_vcpu *vcpu)
+{
+	if (test_thread_flag(TIF_NOCPUID))
+		return;
+
+	if (enable_cpuid_intercept || cpuid_fault_enabled(vcpu))
+		__set_cpuid_faulting(false);
+}
+
+static void set_cpuid_intercept(struct kvm_vcpu *vcpu)
+{
+	if (test_thread_flag(TIF_NOCPUID))
+		return;
+
+	if (enable_cpuid_intercept || cpuid_fault_enabled(vcpu))
+		__set_cpuid_faulting(true);
+}
+
+static void pvm_update_guest_cpuid_faulting(struct kvm_vcpu *vcpu, u64 data)
+{
+	bool guest_enabled = cpuid_fault_enabled(vcpu);
+	bool set_enabled = data & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT;
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if (!(guest_enabled ^ set_enabled))
+		return;
+	if (enable_cpuid_intercept)
+		return;
+	if (test_thread_flag(TIF_NOCPUID))
+		return;
+
+	preempt_disable();
+	if (pvm->loaded_cpu_state)
+		__set_cpuid_faulting(set_enabled);
+	preempt_enable();
+}
+
 // switch_to_smod() and switch_to_umod() switch the mode (smod/umod) and
 // the CR3.  No vTLB flushing when switching the CR3 per PVM Spec.
 static inline void switch_to_smod(struct kvm_vcpu *vcpu)
@@ -335,6 +385,8 @@ static void pvm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 
 	segments_save_host_and_switch_to_guest(pvm);
 
+	set_cpuid_intercept(vcpu);
+
 	kvm_set_user_return_msr(0, (u64)entry_SYSCALL_64_switcher, -1ull);
 	kvm_set_user_return_msr(1, pvm->msr_tsc_aux, -1ull);
 	if (ia32_enabled()) {
@@ -352,6 +404,8 @@ static void pvm_prepare_switch_to_host(struct vcpu_pvm *pvm)
 
 	++pvm->vcpu.stat.host_state_reload;
 
+	reset_cpuid_intercept(&pvm->vcpu);
+
 #ifdef CONFIG_MODIFY_LDT_SYSCALL
 	if (unlikely(current->mm->context.ldt))
 		kvm_load_ldt(GDT_ENTRY_LDT*8);
@@ -937,6 +991,17 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		/* It is ignored now. */
 		break;
+	case MSR_MISC_FEATURES_ENABLES:
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		if (!ret)
+			pvm_update_guest_cpuid_faulting(vcpu, data);
+		break;
+	case MSR_PLATFORM_INFO:
+		if ((data & MSR_PLATFORM_INFO_CPUID_FAULT) &&
+		     !boot_cpu_has(X86_FEATURE_CPUID_FAULT))
+			return 1;
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		break;
 	case MSR_PVM_VCPU_STRUCT:
 		if (!PAGE_ALIGNED(data))
 			return 1;
@@ -2925,6 +2990,10 @@ static int __init hardware_cap_check(void)
 		pr_warn("CMPXCHG16B is required for guest.\n");
 		return -EOPNOTSUPP;
 	}
+	if (!boot_cpu_has(X86_FEATURE_CPUID_FAULT) && enable_cpuid_intercept) {
+		pr_warn("Host doesn't support cpuid faulting.\n");
+		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
-- 
2.19.1.6.gb485710b


