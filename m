Return-Path: <kvm+bounces-65516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D43FCAE5C5
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 23:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B01B530BF365
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 22:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACEC2DEA94;
	Mon,  8 Dec 2025 22:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mF1ASN28"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7502882A9
	for <kvm@vger.kernel.org>; Mon,  8 Dec 2025 22:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765234158; cv=none; b=o5oPWTdU7JnYbHlNSSrHgD49u94GylAxeV3iWlA8tpAwRQbU7a3OJr9XDqIQcNj8rQhuxmjP9BYCRMcD/wSXJ+FK94zS32E6493HlRSIUFKf16Bz3yd5HQ5GBXkbMN4dZPTd34JjSkBp+JtrEKRRglgaM0nIZsrvQwl5eaPe+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765234158; c=relaxed/simple;
	bh=RuG+hqFKqvdPB8GRWvH6QWB2lc3R18bCQJRZoRfcUnQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CDFiTig6gV5vA5I6eW67SorW37+DnAMBSraxj/nfCLgm6uJtsz4ozyg5jmlUxYJ7uXt2Sjt6xzxIujlrfXAIoNQV63Wns0zd8FPvM/l0I5ObV/bu8pdsU3Fc5OHB9HpkB09HnHk++vlI5Jo22HMpgBXoNE/7GrWnDJU4InZLAno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mF1ASN28; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e5a18652so58449865ad.1
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 14:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765234155; x=1765838955; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQtNhp91RwMmmDtOT/Iz2jw2/TI3xMlSl3Ff8p3Yeh4=;
        b=mF1ASN28NnMgVOmlzhk9LfH5tGWYEMaFl1nnB3JZrv1Uskx3UOHdz0vUOs/lu2VA4n
         +GUigcZiGF6ZZrtNaxykjwGvCYjGH6m1N4HwD/c8I7fXSMiCDLbpj8ZxGIQC1YAKU6HO
         /BH2m5HkOIDQaE1lQajku9274Q1UiK4x5D8aeG7yykcUeVY/Nnwwyc1GUrhCZ2SYZEfm
         Kyyf9rkNe+nozaCjnUBFWLif+MwYXZi4NCXpqt+Lb1KkoVYP7jnFnUIvkYiMUtZsE3CR
         xwPjrYK5oVrd8vQVdtXIg/Zp5aTyFL+e0hno7U4O0Es02Aheh55dJOv+nxwO7MXH5/io
         Fnyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765234155; x=1765838955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQtNhp91RwMmmDtOT/Iz2jw2/TI3xMlSl3Ff8p3Yeh4=;
        b=vlplmkENOeGCdKYG96ivi7tyjCweCR1443HcAa3bWOnlvmU6lV6JRQ7GrJAzcTrivz
         CXps9tLg9hu9fHFGc2IlvF7OcQ6hVeUy/Xxb4OiEEibywB2G/AiBV0mSnG48jsrSH8tB
         8/dg6SjsMPZDt7PjPoaF+eePeuuibXk2+mstKW4Nf+dPmc8DEW3Nhim0tnen6lM4QEUc
         He5cLWqe2cY0Um3Wd8iIzwtMBPMwuXmbNYV1WD0a9+FS4sPnad1C9vIqZpFkuyQztjyl
         gdGtfot42gcRBe5K7zseIJnCDGSgg7P7Wfz0M4HJl5pU78u8Y5EEPTHiLUrtFoGlc7TQ
         DcHA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ7YvkM/udezdLok0zqsGGZFq9dKoVktibqeYebfnXslk4qV1uVSNECXnUh/q+5UBMqPc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxl3AGXGjweEmQ2XkFILmqBQ4zDowestgsTD6ML+Px7eR0jMba
	GVsWt86ADgZhK6t4pIz0DV1R7i2I2lisFTYBtheZ8RhlexbsrsMd0DskgDjbtlMxwZTtCZfGCX+
	R44tmyw==
X-Google-Smtp-Source: AGHT+IGV//7skv54QJLySBQbcFRbAbxGPOTct1X0PIO4Gnw4f9XxHcSKjMzEc+bVcrJZMyBaZbfJYke7ZAw=
X-Received: from pjbsu8.prod.google.com ([2002:a17:90b:5348:b0:343:5c2:dd74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fc4:b0:330:bca5:13d9
 with SMTP id 98e67ed59e1d1-349a2636261mr7005185a91.32.1765234155348; Mon, 08
 Dec 2025 14:49:15 -0800 (PST)
Date: Mon, 8 Dec 2025 14:49:13 -0800
In-Reply-To: <20251026201911.505204-22-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-22-xin@zytor.com>
Message-ID: <aTdV6bX14SGz_JWZ@google.com>
Subject: Re: [PATCH v9 21/22] KVM: nVMX: Guard SHADOW_FIELD_R[OW] macros with
 VMX feature checks
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

+Yosry

On Sun, Oct 26, 2025, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Add VMX feature checks to the SHADOW_FIELD_R[OW] macros to prevent access
> to VMCS fields that may be unsupported on some CPUs.
> 
> Functions like copy_shadow_to_vmcs12() and copy_vmcs12_to_shadow() access
> VMCS fields that may not exist on certain hardware, such as
> INJECTED_EVENT_DATA.  To avoid VMREAD/VMWRITE warnings, skip syncing fields
> tied to unsupported VMX features.
> 
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
> 
> Change in v5:
> * Add TB from Xuelian Guo.
> 
> Change since v2:
> * Add __SHADOW_FIELD_R[OW] for better readability or maintability (Sean).

Coming back to this with fresh eyes, handling fields that conditionally exist
_only_ for VMCS shadowing is somewhat ridiculous.  For PML and the VMX preemption
timer, the special case handling makes sense because the fields are emulated by
KVM irrespective of hardware suport.  But for fields that KVM doesn't emulate in
software, e.g. GUEST_INTR_STATUS and the FRED fields, allowing accesses through
emulated VMREAD/VMWRITE and then filtering out VMCS shadowing accesses is just us
being stubborn.

I still 100% think that not restricting based on the virtual CPU model defined by
userspace is the way to go[*], because that'd require an absurd amount of effort,
complexity, and memory to solve a problem no one actually cares about.  But
updating KVM's array of vmcs12 fields once during kvm-intel.ko load isn't difficult,
and would make KVM suck a little less when running on old hardware.

E.g. running the test_vmwrite_vmread KUT subtest on CPUs without TSC scaling still
fails with the wonderful:

  FAIL: VMX_VMCS_ENUM.MAX_INDEX expected: 19, actual: 17

due to QEMU (sanely) setting the max index to 17 (VMX preemption timer) when the
virtual CPU model doesn't support TSC scaling.

And looking forward, we're going to have the same mess with FRED due QEMU (again,
sanely) basing its 

    if (f[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
        /* FRED injected-event data (0x2052).  */
        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x52);
    } else if (f[FEAT_VMX_EXIT_CTLS] &
               VMX_VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
        /* Secondary VM-exit controls (0x2044).  */
        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x44);
    } else if (f[FEAT_VMX_SECONDARY_CTLS] & VMX_SECONDARY_EXEC_TSC_SCALING) {
        /* TSC multiplier (0x2032).  */
        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x32);
    } else {
        /* Preemption timer (0x482E).  */
        kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM, 0x2E);
    }

KVM will still have virtualization holes, e.g. if userspace hides TSC scaling when
running on hardware+KVM that supports TSC scaling, but as above I don't think that's
a problem worth solving.

I'll post a patch (just need to test on bare metal) to sanitize vmcs12 fields,
at which point FRED nVMX support shouldn't have to do anything special beyond
noting the depending, i.e. it should only take a few lines of code.

[*] https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com

