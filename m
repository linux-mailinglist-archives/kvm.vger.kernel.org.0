Return-Path: <kvm+bounces-11431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73987876E8C
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95417285871
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C86B374F9;
	Sat,  9 Mar 2024 01:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cFfeOdfH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB992364A5
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947662; cv=none; b=Ne+FQsuf12yBMDdQ0ACJdxjgox45+eegJ1gMUil1SGEuBW66CWhppB6I+y12yC2bnmOXtyN4sOYf5oga8QXPbs9mD1wXAljIyxeEAPMlgP368Zm4kvdQa6mdZiWsnhWeTMOUlb8v6ah4ywAT0tw0m1bA1aDWCOprOZyRCIDxHmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947662; c=relaxed/simple;
	bh=asA2Q64cYEdVnPGwxvGxEdtiJ+4njYAq1P8HIi+00oU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U9ag6WHWKYIfPdHqY9F43cDmjxsmlSVl21ZebV/CxjQZbxKBwF8M3R8ddRqEnSN5V8pn1LMfMTjkQYq8sHn2S1o/kaUbf8Q12FWXBGD6IOQc5OM21x2y+GQloSfZWyuIP1959dAvPJivnqU5lGxQd2L3l6u2YRQasVWLHfKslx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cFfeOdfH; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc58cddb50so4401773276.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947660; x=1710552460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7zfSsZ0P3OmkAxzO4p6XnXAYwdNDLv4d4j/tO3LJoqY=;
        b=cFfeOdfHuHVcK2WWbInVR/NCHRniyKHTKGOEmI+/qlMx5l7PySK6cczYdfNxUMLEm5
         4L4Nl2sb+PI9TGt9muRci4ZIldxj2kN6ao/9kQjXryX63bd3unbhobzQai35FIz/KFlO
         3ReUMEGy8j9RF8tY5IBJe84g/ETCAgE+Ss2Byue9rrI41A5HTucoZSoeBQuIJsjKK2In
         LhBbzx3H3loWYhp0cnobrkdxqKJjnChXH2Taa799sBs/YSLIhjKmrvQ4tpqyebH0GTXX
         Ccpbh07pfqFEPvWGi7qYgj3dH+OczKI2H/q3MVsYuEu/67RVYePhAcYf+x7p3jCUtY/L
         8IPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947660; x=1710552460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7zfSsZ0P3OmkAxzO4p6XnXAYwdNDLv4d4j/tO3LJoqY=;
        b=bbkLJYQaa6ghTC08W31q3zXyPwbXPo65KkxyHpiLKZm+joaVHZ0lvZa+jJsOJgxYE2
         d98S3AN2wk1n342tLcBIVnl+MKjGbUhXCAIUJhZt0ohObOXDDgCLqR+VhE1wYiHrzCOE
         xmbbcrpVC4j1l5hVXEwmB+hVDJ7gJxCE/49w+BGbqrsfJZHxblapE6dhXvTo8G+er71c
         zYb6JhCNj3/tNDc5fjgKZuQOUCWELO582W5WHubszopYhhKIK/YxfK+1U8D4xVjzMlS6
         pBCUPxtAo0oWFyFLVBgrmjJ4t+C7W/EAJ2kY7HIK3ojOhSuKCKwYbnKNHiWJnhFjHp1I
         ulKA==
X-Forwarded-Encrypted: i=1; AJvYcCV4voG4Y1NwfSxLV+rva2dbf8f3Y0ZOL6cjPi6z+UhR/+plGuzPgcw/KPcHg9xWUn4q+6PbLaWuuUSCIq2pxE6y7ITJ
X-Gm-Message-State: AOJu0YxdcYXuKrh17Hp0u3maZ79fCkZBT0ZV6khbGX4B2rQla24iMXIv
	/GZcLxzOQAImkCKq/5upDkKK0uT6Mi9g+pP70WSSmGEMyOixw0Z1cByZMZQFtUXgVP4m7JfXwQZ
	kIA==
X-Google-Smtp-Source: AGHT+IFcW7KzgO/BpgyMqKPfaZjTeUEzLTWFoMFPJK2iqgZo0BYHsKQoyclB2VWqfLuEY3nnCdYV1aYmGj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa83:0:b0:dc2:3441:897f with SMTP id
 t3-20020a25aa83000000b00dc23441897fmr185240ybi.6.1709947659928; Fri, 08 Mar
 2024 17:27:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:21 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-6-seanjc@google.com>
Subject: [PATCH v6 5/9] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a single
 64-bit value
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Track the "basic" capabilities VMX MSR as a single u64 in vmcs_config
instead of splitting it across three fields, that obviously don't combine
into a single 64-bit value, so that KVM can use the macros that define MSR
bits using their absolute position.  Replace all open coded shifts and
masks, many of which are relative to the "high" half, with the appropriate
macro.

Opportunistically use VMX_BASIC_32BIT_PHYS_ADDR_ONLY instead of an open
coded equivalent, and clean up the related comment to not reference a
specific SDM section (to the surprise of no one, the comment is stale).

No functional change intended (though obviously the code generation will
be quite different).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h      |  5 +++++
 arch/x86/kvm/vmx/capabilities.h |  6 ++----
 arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++++++--------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c3a97dca4a33..ce6d166fc3c5 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -150,6 +150,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
 }
 
+static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
+{
+	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
+}
+
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
 	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..86ce8bb96bed 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -54,9 +54,7 @@ struct nested_vmx_msrs {
 };
 
 struct vmcs_config {
-	int size;
-	u32 basic_cap;
-	u32 revision_id;
+	u64 basic;
 	u32 pin_based_exec_ctrl;
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
@@ -76,7 +74,7 @@ extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
-	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
+	return	vmcs_config.basic & VMX_BASIC_INOUT;
 }
 
 static inline bool cpu_has_virtual_nmis(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71cc6e3b3221..e312c48f542f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2554,13 +2554,13 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
-	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u64 basic_msr;
 	u64 misc_msr;
 	int i;
 
@@ -2679,29 +2679,29 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_vmexit_control &= ~x_ctrl;
 	}
 
-	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
+	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
-	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+	if (vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE)
 		return -EIO;
 
 #ifdef CONFIG_X86_64
-	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-	if (vmx_msr_high & (1u<<16))
+	/*
+	 * KVM expects to be able to shove all legal physical addresses into
+	 * VMCS fields for 64-bit kernels, and per the SDM, "This bit is always
+	 * 0 for processors that support Intel 64 architecture".
+	 */
+	if (basic_msr & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EIO;
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != X86_MEMTYPE_WB)
+	if (vmx_basic_vmcs_mem_type(basic_msr) != X86_MEMTYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
 
-	vmcs_conf->size = vmx_msr_high & 0x1fff;
-	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
-
-	vmcs_conf->revision_id = vmx_msr_low;
-
+	vmcs_conf->basic = basic_msr;
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
@@ -2851,13 +2851,13 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
-	memset(vmcs, 0, vmcs_config.size);
+	memset(vmcs, 0, vmx_basic_vmcs_size(vmcs_config.basic));
 
 	/* KVM supports Enlightened VMCS v1 only */
 	if (kvm_is_using_evmcs())
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
-		vmcs->hdr.revision_id = vmcs_config.revision_id;
+		vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 	if (shadow)
 		vmcs->hdr.shadow_vmcs = 1;
@@ -2950,7 +2950,7 @@ static __init int alloc_kvm_area(void)
 		 * physical CPU.
 		 */
 		if (kvm_is_using_evmcs())
-			vmcs->hdr.revision_id = vmcs_config.revision_id;
+			vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 		per_cpu(vmxarea, cpu) = vmcs;
 	}
-- 
2.44.0.278.ge034bb2e1d-goog


