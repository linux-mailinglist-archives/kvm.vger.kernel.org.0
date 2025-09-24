Return-Path: <kvm+bounces-58697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F39BB9B8E0
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CEEB16E0A9
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D41E3168F6;
	Wed, 24 Sep 2025 18:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZXt6SR8+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A4D2DF3F2
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739471; cv=none; b=KOFk9wi8doIARPKLZdJghoX2LUHdUptlYz1UBqjFBOIxSC3ji39ORZ6wfucFT5IEm55cYxMsoCz55XPm5iJ79MM1NtHHAocksXZ3o2fqsgieW5dgVcoNsz4g5p24G3kiSilEs0xOOOoL5F+DpK2U44CtMbxzBYTmqDX5c0GHhvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739471; c=relaxed/simple;
	bh=RgvezA3ejmnVmUHQV+WlYVjWSEH3Xui/VTOEfAJDgBg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BK2DVwfxFMkryzC4WhuXY72XYS+w/WalNVgHgqLeSm19PKd+0J59reEBXSsfli+r0girnifqyvhw6TQb9JgqILTHl5OoyhxOxfW9AM6RlwwkRmOoZTEtoHZrXfXvgPsHJzaooligykVlf0YE8UkG2+EsprPVo+hmZY4Tmqm5MRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZXt6SR8+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso195192a91.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758739469; x=1759344269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CcIMtgKDvR0vmR/Q3QFgwGqwOGEUB+blops9CWWhEQU=;
        b=ZXt6SR8+f3IB4mFqSITEGI2xgbGnTgtzMc3lifESACacH0Txd4mYWvFPhx1Fuhd8HC
         EIatTHuTL9PsVVjZfUOhyhK2y6oIkQJfHRwcO26MdiVb7i/viPDWMlG0OrBKDqKTgQcb
         +Sk+dZGky6r2eevBAXKIMbjmARl+JxEIzF760vBIt36taHcO4xTXGIXUZZFsJJF3Y9NO
         42vG0tQCalXyO95bghsO/hvI0A3PaHizpPs/j/HHG6b64On+SC7KVEtKAw58OSaVEf4G
         IfXd3x+rFPdXYM633iWyN94FyjDHRelQO77WxaDKyX/VdQADidjazImldw+JzDLIKeNL
         mfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739469; x=1759344269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CcIMtgKDvR0vmR/Q3QFgwGqwOGEUB+blops9CWWhEQU=;
        b=QZRHLAj15ADzy6ncC7My4xs0A8zt1P9XPvsPXWGAXr3qhOESJS9fPguD7h7Ts+MNEE
         cB+LU8cosMXvdU4S+Od+f8w6AQkB9VyG6P/edRNSlC2NTX/q/+qSSkZWjPaFFeUoR7+k
         +uYgromr1luhtXi9BKjCAwiOOeHfOSjrDyEyFXzS0aWnMG2AxKxH50IRFEy7zwY96yR9
         NQyFYcmyhQsZea6doE6PUTgcx8kO/pbMUiK1IAFSWNhzCJ4OA9R43tRP9cgMlXwOaJ+M
         LfUpkfZthTjyWnNvorOa8VfTn2aDrogh2LFibeF28VR7qWKEMCvXxjscHlpdvD0Pwm3q
         32uw==
X-Gm-Message-State: AOJu0YwG+57mzHrN6xLJNZbRX2YILeKGTAjZ7HkxUBwg3SHDQuL41uZZ
	x/jZNPo/o+6ZeZIn45YC9hVBAp00Z0Zumy7CuvxZKTEyQC0v0S26S8p/4yod6ejDXcl2y1T0O9E
	Aykx2cA==
X-Google-Smtp-Source: AGHT+IGdKdg5RrocGQ7l0SMORVibrCJKSXzLOMrUb4w/kkABf/l87NU7+RRumaDt8Jt/2G13wvaZO2t4DuA=
X-Received: from pjbsi14.prod.google.com ([2002:a17:90b:528e:b0:330:5945:699e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4d:b0:330:6f16:c4ce
 with SMTP id 98e67ed59e1d1-3342a22c92fmr643820a91.1.1758739469446; Wed, 24
 Sep 2025 11:44:29 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:39 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873602866.2143908.7929679883637280070.b4-ty@google.com>
Subject: Re: [PATCH v16 00/51] KVM: x86: Super Mega CET
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 19 Sep 2025 15:32:07 -0700, Sean Christopherson wrote:
> As the subject suggests, this series continues to grow, as there an absolutely
> stupid number of edge cases and interactions.
> 
> There are (a lot) more changes between v15 and v16 than I was hoping for, but
> there all fairly "minor" in the sense that it's things like disabling SHSTK
> when using the shadow MMU.  I.e. it's mostly "configuration" fixes, and very
> few logical changes (outside of msrs_test.c, which has non-trivial changes due
> to ignore_msrs, argh).
> 
> [...]

Unless someone finds a truly egregious bug, the hashes are now frozen.  Please
post any fixups as standalone patches based on kvm-x86/next, and I'll apply on
top as appropriate.

Thanks everyone!


Applied 1-3 to kvm-x86 svm:

[01/51] KVM: SEV: Rename kvm_ghcb_get_sw_exit_code() to kvm_get_cached_sw_exit_code()
        https://github.com/kvm-x86/linux/commit/e0ff302b79c5
[02/51] KVM: SEV: Read save fields from GHCB exactly once
        https://github.com/kvm-x86/linux/commit/bd5f500d2317
[03/51] KVM: SEV: Validate XCR0 provided by guest in GHCB
        https://github.com/kvm-x86/linux/commit/4135a9a8ccba

The ex_str() selftest patch to kvm-x86 selftests:

[44/51] KVM: selftests: Add ex_str() to print human friendly name of exception vectors
        https://github.com/kvm-x86/linux/commit/df1f294013da

And the rest to kvm-x86 cet (including patch "26.5"):

[04/51] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
        https://github.com/kvm-x86/linux/commit/06f2969c6a12
[05/51] KVM: x86: Report XSS as to-be-saved if there are supported features
        https://github.com/kvm-x86/linux/commit/c0a5f2989122
[06/51] KVM: x86: Check XSS validity against guest CPUIDs
        https://github.com/kvm-x86/linux/commit/338543cbe033
[07/51] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
        https://github.com/kvm-x86/linux/commit/9622e116d0d2
[08/51] KVM: x86: Initialize kvm_caps.supported_xss
        https://github.com/kvm-x86/linux/commit/779ed05511f2
[09/51] KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
        https://github.com/kvm-x86/linux/commit/e44eb58334bb
[10/51] KVM: x86: Add fault checks for guest CR4.CET setting
        https://github.com/kvm-x86/linux/commit/586ef9dcbb28
[11/51] KVM: x86: Report KVM supported CET MSRs as to-be-saved
        https://github.com/kvm-x86/linux/commit/6a11c860d8a4
[12/51] KVM: VMX: Introduce CET VMCS fields and control bits
        https://github.com/kvm-x86/linux/commit/d6c387fc396b
[13/51] KVM: x86: Enable guest SSP read/write interface with new uAPIs
        https://github.com/kvm-x86/linux/commit/9d6812d41535
[14/51] KVM: VMX: Emulate read and write to CET MSRs
        https://github.com/kvm-x86/linux/commit/8b59d0275c96
[15/51] KVM: x86: Save and reload SSP to/from SMRAM
        https://github.com/kvm-x86/linux/commit/1a61bd0d126a
[16/51] KVM: VMX: Set up interception for CET MSRs
        https://github.com/kvm-x86/linux/commit/25f3840483e6
[17/51] KVM: VMX: Set host constant supervisor states to VMCS fields
        https://github.com/kvm-x86/linux/commit/584ba3ffb984
[18/51] KVM: x86: Don't emulate instructions affected by CET features
        https://github.com/kvm-x86/linux/commit/57c3db7e2e26
[19/51] KVM: x86: Don't emulate task switches when IBT or SHSTK is enabled
        https://github.com/kvm-x86/linux/commit/82c0ec028258
[20/51] KVM: x86: Emulate SSP[63:32]!=0 #GP(0) for FAR JMP to 32-bit mode
        https://github.com/kvm-x86/linux/commit/d4c03f63957c
[21/51] KVM: x86/mmu: WARN on attempt to check permissions for Shadow Stack #PF
        https://github.com/kvm-x86/linux/commit/296599346c67
[22/51] KVM: x86/mmu: Pretty print PK, SS, and SGX flags in MMU tracepoints
        https://github.com/kvm-x86/linux/commit/843af0f2e461
[23/51] KVM: x86: Allow setting CR4.CET if IBT or SHSTK is supported
        https://github.com/kvm-x86/linux/commit/b3744c59ebc5
[24/51] KVM: nVMX: Always forward XSAVES/XRSTORS exits from L2 to L1
        https://github.com/kvm-x86/linux/commit/19e6e083f3f9
[25/51] KVM: x86: Add XSS support for CET_KERNEL and CET_USER
        https://github.com/kvm-x86/linux/commit/69cc3e886582
[26/51] KVM: x86: Disable support for Shadow Stacks if TDP is disabled
        https://github.com/kvm-x86/linux/commit/1f6f68fcfe43
[26.5/51] KVM: x86: Initialize allow_smaller_maxphyaddr earlier in setup
        https://github.com/kvm-x86/linux/commit/f705de12a22c
[27/51] KVM: x86: Disable support for IBT and SHSTK if allow_smaller_maxphyaddr is true
        https://github.com/kvm-x86/linux/commit/343acdd158a5
[28/51] KVM: x86: Enable CET virtualization for VMX and advertise to userspace
        https://github.com/kvm-x86/linux/commit/e140467bbdaf
[29/51] KVM: VMX: Configure nested capabilities after CPU capabilities
        https://github.com/kvm-x86/linux/commit/f7336d47be53
[30/51] KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2
        https://github.com/kvm-x86/linux/commit/033cc166f029
[31/51] KVM: nVMX: Prepare for enabling CET support for nested guest
        https://github.com/kvm-x86/linux/commit/625884996bff
[32/51] KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
        https://github.com/kvm-x86/linux/commit/8060b2bd2dd0
[33/51] KVM: nVMX: Add consistency checks for CET states
        https://github.com/kvm-x86/linux/commit/62f7533a6b3a
[34/51] KVM: nVMX: Advertise new VM-Entry/Exit control bits for CET state
        https://github.com/kvm-x86/linux/commit/42ae6448531b
[35/51] KVM: SVM: Emulate reads and writes to shadow stack MSRs
        https://github.com/kvm-x86/linux/commit/48b2ec0d540c
[36/51] KVM: nSVM: Save/load CET Shadow Stack state to/from vmcb12/vmcb02
        https://github.com/kvm-x86/linux/commit/c5ba49458513
[37/51] KVM: SVM: Update dump_vmcb with shadow stack save area additions
        https://github.com/kvm-x86/linux/commit/c7586aa3bed4
[38/51] KVM: SVM: Pass through shadow stack MSRs as appropriate
        https://github.com/kvm-x86/linux/commit/38c46bdbf998
[39/51] KVM: SEV: Synchronize MSR_IA32_XSS from the GHCB when it's valid
        https://github.com/kvm-x86/linux/commit/b5fa221f7b08
[40/51] KVM: SVM: Enable shadow stack virtualization for SVM
        https://github.com/kvm-x86/linux/commit/8db428fd5229
[41/51] KVM: x86: Add human friendly formatting for #XM, and #VE
        https://github.com/kvm-x86/linux/commit/d37cc4819a48
[42/51] KVM: x86: Define Control Protection Exception (#CP) vector
        https://github.com/kvm-x86/linux/commit/f2f5519aa4e3
[43/51] KVM: x86: Define AMD's #HV, #VC, and #SX exception vectors
        https://github.com/kvm-x86/linux/commit/fddd07626baa

[45/51] KVM: selftests: Add an MSR test to exercise guest/host and read/write
        https://github.com/kvm-x86/linux/commit/9c38ddb3df94
[46/51] KVM: selftests: Add support for MSR_IA32_{S,U}_CET to MSRs test
        https://github.com/kvm-x86/linux/commit/27c41353064f
[47/51] KVM: selftests: Extend MSRs test to validate vCPUs without supported features
        https://github.com/kvm-x86/linux/commit/a8b9cca99cf4
[48/51] KVM: selftests: Add KVM_{G,S}ET_ONE_REG coverage to MSRs test
        https://github.com/kvm-x86/linux/commit/80c2b6d8e7bb
[49/51] KVM: selftests: Add coverage for KVM-defined registers in MSRs test
        https://github.com/kvm-x86/linux/commit/3469fd203bac
[50/51] KVM: selftests: Verify MSRs are (not) in save/restore list when (un)supported
        https://github.com/kvm-x86/linux/commit/947ab90c9198
[51/51] KVM: VMX: Make CR4.CET a guest owned bit
        https://github.com/kvm-x86/linux/commit/d292035fb5d2

--
https://github.com/kvm-x86/linux/tree/next

