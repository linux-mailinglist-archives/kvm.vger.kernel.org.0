Return-Path: <kvm+bounces-34103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DD49F72D1
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B93C5162A70
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54991531C0;
	Thu, 19 Dec 2024 02:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tBhfkvOP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2582E8633A
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576151; cv=none; b=jkxRlleEJssSVnA3ubCbRKUZAdAyH7oEdsN85n24t6iiOoVSTU1WMRgKkzyta9GAFFDbj8SZypIN2xTyQtiQfDPqmLReULc8R1L43DY/zLKtsNCeaj/Rjpaw/IXqMlAlx7bO7f8+ytvT6rhuDbahQrexZz4t4LgNEKwIsccdNYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576151; c=relaxed/simple;
	bh=wqR7x6AVUn9CFmwRHzguFjVoQEXqBhut+J2L9R1+Mok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=enPiizNL7YClJWixHNu4KYrsnF7JKVCVAjr/JSCom8ev4xssl6Kk2ptnf8L1Gglmde4xm0kj67bdYuVTveJQSoYixk4R0aOve/zqvdhkfYIFSxa6P0huQr40rHJurtY0Il+854Hs4rvvuAaH9oh09ct438Jnb0wF5w3er4WdOSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tBhfkvOP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7eaac1e95ffso161268a12.2
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576149; x=1735180949; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VbFFCvosM7beCnQ9jmt3aQywf9OTnT50KhFJlLu0KQA=;
        b=tBhfkvOPIT/CHSYhgrT3dppHsSXQ86rflCKPcaRHYCDLXHC2FbUvW5eM9eFCXADRxo
         QOwnVKbL3sxkl32tXdFn8wbtkWvs1ssxV3dW99wWfilB2IZebD8A28ldOuW9PTsGjh/N
         X7otq7i0Ac0CxJfX4//hIu7g8qj9ZZauNQqAf0YvTdA30L5DvMukycKGjN2FtukmKUVo
         hD044k+C6X4EnBkocQfMAxbPiSb3zTbErtVVsYo7Mau2yZrW6R3+x/c7UjIXDzUrx+Rd
         yVepqhyl+bhq/RvrkyFWNm2qIsdlZC6+ZQ1l9ofYXxhyqebQhyxgN+EpVrjeyrEg2ijx
         L9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576149; x=1735180949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VbFFCvosM7beCnQ9jmt3aQywf9OTnT50KhFJlLu0KQA=;
        b=IsPnTf7Dlj9glT3jp7jCuECgbGyoQwDt19YIOJdgMu6NdWbMdO4I0W+szSXWhWAo1P
         briBsi3JwOuKi0QqRPe1seOTS/0If1o19pZIVbDaCSPuEOV7Nc4rDz82rYPcoxhp9ql3
         C3HuNyTCENv9kTvYq2csdOtFaSBzSnmgD/8d8OVW5OMFXw1tHPbIZZ03Xq5555/ZN739
         VKlzBveOW32ZkCIKKjUT4wxqRGADWLb3SwU/d0OPWasdMKIFincxMwPrZvW/dxxFijGI
         VIJK2IzEB5n1cQGpilZEY7ReEMUlde6nDPIZhR4ovfh81aNS7KRHekya0t8ShwzAOMDt
         iZHw==
X-Gm-Message-State: AOJu0YxmYvGKsd3KPVAbdPtgFKLzVaZCMBb5B6i4hAFPOWQVcNGM9PtF
	6Q/zktVIKu+ZsohLHVXQbgiZBunmz1M4wPiO6FzneZOtbeTElKkyGwOCbZCna+hVQshKLNAjZFV
	R+A==
X-Google-Smtp-Source: AGHT+IF6gl9bmvRqTdsnr4nvCU9pHdNTaqp0SGQ23mTpUKWZXZwSyIvzFrJHRPlH6t5aNqXiP+AKz8ZN3i0=
X-Received: from pgeu9.prod.google.com ([2002:a63:a909:0:b0:7ff:d6:4f28])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f99:b0:1e1:ab63:c5ed
 with SMTP id adf61e73a8af0-1e5b48233b1mr8061533637.23.1734576149409; Wed, 18
 Dec 2024 18:42:29 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:50 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457554492.3295736.445579202892214043.b4-ty@google.com>
Subject: Re: [PATCH v3 00/57] KVM: x86: CPUID overhaul, fixes, and caching
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 27 Nov 2024 17:33:27 -0800, Sean Christopherson wrote:
> The super short TL;DR: snapshot all X86_FEATURE_* flags that KVM cares
> about so that all queries against guest capabilities are "fast", e.g. don't
> require manual enabling or judgment calls as to where a feature needs to be
> fast.
> 
> The guest_cpu_cap_* nomenclature follows the existing kvm_cpu_cap_*
> except for a few (maybe just one?) cases where guest cpu_caps need APIs
> that kvm_cpu_caps don't.  In theory, the similar names will make this
> approach more intuitive.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[01/57] KVM: x86: Use feature_bit() to clear CONSTANT_TSC when emulating CPUID
        https://github.com/kvm-x86/linux/commit/ccf4c1d15d5a
[02/57] KVM: x86: Limit use of F() and SF() to kvm_cpu_cap_{mask,init_kvm_defined}()
        https://github.com/kvm-x86/linux/commit/4b027f5af907
[03/57] KVM: x86: Do all post-set CPUID processing during vCPU creation
        https://github.com/kvm-x86/linux/commit/85e5ba83c016
[04/57] KVM: x86: Explicitly do runtime CPUID updates "after" initial setup
        https://github.com/kvm-x86/linux/commit/ec3d4440b2c8
[05/57] KVM: x86: Account for KVM-reserved CR4 bits when passing through CR4 on VMX
        https://github.com/kvm-x86/linux/commit/7520a53b8e0a
[06/57] KVM: selftests: Update x86's set_sregs_test to match KVM's CPUID enforcement
        https://github.com/kvm-x86/linux/commit/bf4dfc3aa875
[07/57] KVM: selftests: Assert that vcpu->cpuid is non-NULL when getting CPUID entries
        https://github.com/kvm-x86/linux/commit/08833719e770
[08/57] KVM: selftests: Refresh vCPU CPUID cache in __vcpu_get_cpuid_entry()
        https://github.com/kvm-x86/linux/commit/a2a791e82086
[09/57] KVM: selftests: Verify KVM stuffs runtime CPUID OS bits on CR4 writes
        https://github.com/kvm-x86/linux/commit/01bcd829c63f
[10/57] KVM: x86: Move __kvm_is_valid_cr4() definition to x86.h
        https://github.com/kvm-x86/linux/commit/b0c3d6871778
[11/57] KVM: x86/pmu: Drop now-redundant refresh() during init()
        https://github.com/kvm-x86/linux/commit/ac32cbd4dfc6
[12/57] KVM: x86: Drop now-redundant MAXPHYADDR and GPA rsvd bits from vCPU creation
        https://github.com/kvm-x86/linux/commit/21d7f06d1a83
[13/57] KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS after vCPU creation
        https://github.com/kvm-x86/linux/commit/04cd8f8628d8
[14/57] KVM: x86: Reject disabling of MWAIT/HLT interception when not allowed
        https://github.com/kvm-x86/linux/commit/c829ccd4d9dc
[15/57] KVM: x86: Drop the now unused KVM_X86_DISABLE_VALID_EXITS
        https://github.com/kvm-x86/linux/commit/af5366bea2cb
[16/57] KVM: selftests: Fix a bad TEST_REQUIRE() in x86's KVM PV test
        https://github.com/kvm-x86/linux/commit/7b2658cb33c7
[17/57] KVM: selftests: Update x86's KVM PV test to match KVM's disabling exits behavior
        https://github.com/kvm-x86/linux/commit/59cb3acdb316
[18/57] KVM: x86: Zero out PV features cache when the CPUID leaf is not present
        https://github.com/kvm-x86/linux/commit/01d1059d635a
[19/57] KVM: x86: Don't update PV features caches when enabling enforcement capability
        https://github.com/kvm-x86/linux/commit/f21958e328a9
[20/57] KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
        https://github.com/kvm-x86/linux/commit/6416b0fb1660
[21/57] KVM: x86: Account for max supported CPUID leaf when getting raw host CPUID
        https://github.com/kvm-x86/linux/commit/96cbc766baf0
[22/57] KVM: x86: Unpack F() CPUID feature flag macros to one flag per line of code
        https://github.com/kvm-x86/linux/commit/ccf93de484a3
[23/57] KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init()
        https://github.com/kvm-x86/linux/commit/3cc359ca29ad
[24/57] KVM: x86: Add a macro to init CPUID features that are 64-bit only
        https://github.com/kvm-x86/linux/commit/6eac4d99a967
[25/57] KVM: x86: Add a macro to precisely handle aliased 0x1.EDX CPUID features
        https://github.com/kvm-x86/linux/commit/264969b48a29
[26/57] KVM: x86: Handle kernel- and KVM-defined CPUID words in a single helper
        https://github.com/kvm-x86/linux/commit/46505c0f69f9
[27/57] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to avoid macro collisions
        https://github.com/kvm-x86/linux/commit/8d862c270bf1
[28/57] KVM: x86: Harden CPU capabilities processing against out-of-scope features
        https://github.com/kvm-x86/linux/commit/3d142340d717
[29/57] KVM: x86: Add a macro to init CPUID features that ignore host kernel support
        https://github.com/kvm-x86/linux/commit/5c8de4b3a5bc
[30/57] KVM: x86: Add a macro to init CPUID features that KVM emulates in software
        https://github.com/kvm-x86/linux/commit/6174004ebd25
[31/57] KVM: x86: Swap incoming guest CPUID into vCPU before massaging in KVM_SET_CPUID2
        https://github.com/kvm-x86/linux/commit/8c01290bda1a
[32/57] KVM: x86: Clear PV_UNHALT for !HLT-exiting only when userspace sets CPUID
        https://github.com/kvm-x86/linux/commit/63d8c702c2d4
[33/57] KVM: x86: Remove unnecessary caching of KVM's PV CPUID base
        https://github.com/kvm-x86/linux/commit/a5b32718081e
[34/57] KVM: x86: Always operate on kvm_vcpu data in cpuid_entry2_find()
        https://github.com/kvm-x86/linux/commit/285185f8e479
[35/57] KVM: x86: Move kvm_find_cpuid_entry{,_index}() up near cpuid_entry2_find()
        https://github.com/kvm-x86/linux/commit/8b30cb367c46
[36/57] KVM: x86: Remove all direct usage of cpuid_entry2_find()
        https://github.com/kvm-x86/linux/commit/136d605b4365
[37/57] KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
        https://github.com/kvm-x86/linux/commit/9be4ec35d668
[38/57] KVM: x86: Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
        https://github.com/kvm-x86/linux/commit/9aa470f5ddb2
[39/57] KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"
        https://github.com/kvm-x86/linux/commit/2c5e168e5ce1
[40/57] KVM: x86: Replace guts of "governed" features with comprehensive cpu_caps
        https://github.com/kvm-x86/linux/commit/7ea34578aea7
[41/57] KVM: x86: Initialize guest cpu_caps based on guest CPUID
        https://github.com/kvm-x86/linux/commit/a7a308f863a1
[42/57] KVM: x86: Extract code for generating per-entry emulated CPUID information
        https://github.com/kvm-x86/linux/commit/ff402f56e8eb
[43/57] KVM: x86: Treat MONTIOR/MWAIT as a "partially emulated" feature
        https://github.com/kvm-x86/linux/commit/d4b9ff3d55de
[44/57] KVM: x86: Initialize guest cpu_caps based on KVM support
        https://github.com/kvm-x86/linux/commit/e592ec657d84
[45/57] KVM: x86: Avoid double CPUID lookup when updating MWAIT at runtime
        https://github.com/kvm-x86/linux/commit/963180ae0637
[46/57] KVM: x86: Drop unnecessary check that cpuid_entry2_find() returns right leaf
        https://github.com/kvm-x86/linux/commit/cfd157452609
[47/57] KVM: x86: Update OS{XSAVE,PKE} bits in guest CPUID irrespective of host support
        https://github.com/kvm-x86/linux/commit/1f66590d7ff0
[48/57] KVM: x86: Update guest cpu_caps at runtime for dynamic CPUID-based features
        https://github.com/kvm-x86/linux/commit/75d4642fce01
[49/57] KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
        https://github.com/kvm-x86/linux/commit/820545bdfeb0
[50/57] KVM: x86: Replace (almost) all guest CPUID feature queries with cpu_caps
        https://github.com/kvm-x86/linux/commit/8f2a27752e80
[51/57] KVM: x86: Drop superfluous host XSAVE check when adjusting guest XSAVES caps
        https://github.com/kvm-x86/linux/commit/cbdeea032bfe
[52/57] KVM: x86: Add a macro for features that are synthesized into boot_cpu_data
        https://github.com/kvm-x86/linux/commit/75c489e12d4b
[53/57] KVM: x86: Pull CPUID capabilities from boot_cpu_data only as needed
        https://github.com/kvm-x86/linux/commit/3fd55b522795
[54/57] KVM: x86: Rename "SF" macro to "SCATTERED_F"
        https://github.com/kvm-x86/linux/commit/9b2776c7cf2b
[55/57] KVM: x86: Explicitly track feature flags that require vendor enabling
        https://github.com/kvm-x86/linux/commit/0fea7aa2dc6a
[56/57] KVM: x86: Explicitly track feature flags that are enabled at runtime
        https://github.com/kvm-x86/linux/commit/ac9d1b7591a2
[57/57] KVM: x86: Use only local variables (no bitmask) to init kvm_cpu_caps
        https://github.com/kvm-x86/linux/commit/871ac338ef55

--
https://github.com/kvm-x86/linux/tree/next

