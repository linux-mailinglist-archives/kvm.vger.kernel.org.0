Return-Path: <kvm+bounces-34024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 707079F5C1E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 02:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3E7D164D76
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D593594C;
	Wed, 18 Dec 2024 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fidwSART"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85D035943
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 01:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734484433; cv=none; b=Zywy5JOE5HyvoTtXtHKiC+dF5K/JipPgp9+UUhNQQ5Au6BtWL3qajvHs8o3z7Pm5vgy7xq5zAW0JQ/wpB/p1DTS4XWLKVXFcDGzhGOlwstUyMLHEsFjQesygztiwwup+TYG4KiZgb6RAF0i+HX9ZC/vpMoqr6CBpRAgdJ1svXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734484433; c=relaxed/simple;
	bh=/h3ONN/IyZz3Kdfkoxenzh1+VPG6JNHL/ZihFq7snjo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TMSQCfMq/tbXtGog2r7GfI7xkG6zlFH5nhX+dFlcc9SudmX0olv2eF0/nvcB5Pib1B8n/WbTz+vpwUrc4W1U0E3p8Vyj+KGRGq+y3WRtA60T3DHDCie3zGPKfsynbLbOXuR/B7rolczGnIQxCiLMhHBRPcCa7zVdEI7EHL7v2xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fidwSART; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734484429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KOqVBUjFEFA/B4b63+2BCUMNQs7lk4Ic4IMDllNXhlY=;
	b=fidwSARTUZcCd7KQV91u/azQQhNuzFHgDUBGiV+51uPyMqwCZ0kwg5CDlzwK7j+686tkVf
	E+tqbvGjLwVs34wM+X4szW5JO5DBvTc+0jJEXuofCeFTogvYxjuuDBNp9kZx+A5hd3sDlH
	YjsvTjuwZUGGBJnQBBeu3QjeFtGeaIQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-myE5vFIONUqf5GBHKh5R3w-1; Tue, 17 Dec 2024 20:13:48 -0500
X-MC-Unique: myE5vFIONUqf5GBHKh5R3w-1
X-Mimecast-MFC-AGG-ID: myE5vFIONUqf5GBHKh5R3w
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a9d4ea9e0cso61040865ab.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 17:13:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734484428; x=1735089228;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KOqVBUjFEFA/B4b63+2BCUMNQs7lk4Ic4IMDllNXhlY=;
        b=hnUFEIPJVi4PWMBpYUm3wOvSsugVC1rzDPQoOfYcl3NZavXYgQuibWc4kgj+aCQ9rT
         bbdNSIH4cpXXcHyWohfTz96ZaztnZ/Ao7JbYERX6T576y/JNIwmf+p4IFnwvxLurCrBt
         h6GCt9VMK1LaHUXTKOJjcfMh8oJoEX0xwhNMNHS8p7DgAViQsUp0kL7xJmbWM2DpZldu
         45omd9ZMHYkC4rqEPXvPXLZjsFPPjpaThE9WPKN2PDuw+FVPKuAj7LEeOXGhuO1DNOME
         kqLeqvJT66rmy8rH70Ed+zhsLi7ORdoTELvEaC89jXi07ZqLs20ViiRCytfzQLXlV/d0
         jTJA==
X-Gm-Message-State: AOJu0YwWoDx4fpoIlNjdXMsbv68tHBKz1ytDBOhnB5pbvdoHxCczxjCY
	jxEKMzZ4X/pKdvhE/bzRDSvrD4TzKesZObb/iqoCgwF3yI33Vrr6uo+0klSYEVBbaKmVE+qhiet
	tEDmtqFK4uhywHs+lU2uT6qfnFhaU55XizJ5PvOzRq0VFSpfovuJLxlqUZw==
X-Gm-Gg: ASbGncubrO0UiImGku3XbEm/LI2/6fSCePtLHlwjiMhkCma8BB4859E/uHfdexw6ola
	ttfY32DAznIu2hAc44ZnyBxk9dl8YBIDnvd9HuRPvs5t386fTAu848SpveO4iKtVUvF7Xn5csLi
	1zqjx+6lJlkjlGbjjCA+V0glztV/ueegxzs8C1vL9kf8QVgc8uaEnXrJ98o2GnbcVGW99+2qVGa
	hAz/6UOaqLmm+LVCV0DFqFCNJ+5nO60XUfd1byrT7wv4Ypv75ewh94L
X-Received: by 2002:a05:6e02:1565:b0:3a7:fd5a:8b8a with SMTP id e9e14a558f8ab-3bdc1848d0amr10784545ab.12.1734484427836;
        Tue, 17 Dec 2024 17:13:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGm64y/daaOHyRo6YJuXKz6sDU+T4+1qOBO2RdKJv6641OBKWosCnSpZ25WXdARkUSizopfEQ==
X-Received: by 2002:a05:6e02:1565:b0:3a7:fd5a:8b8a with SMTP id e9e14a558f8ab-3bdc1848d0amr10784325ab.12.1734484427432;
        Tue, 17 Dec 2024 17:13:47 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b2475af0desm23936495ab.5.2024.12.17.17.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 17:13:46 -0800 (PST)
Message-ID: <7f8a8ccbd0a8325b5a1e756d5c55a5fc5992908d.camel@redhat.com>
Subject: Re: [PATCH v3 00/57] KVM: x86: CPUID overhaul, fixes, and caching
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko
 Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>, Kechen Lu <kechenl@nvidia.com>, Oliver
 Upton <oliver.upton@linux.dev>,  Binbin Wu <binbin.wu@linux.intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>, Robert Hoo
 <robert.hoo.linux@gmail.com>
Date: Tue, 17 Dec 2024 20:13:45 -0500
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
References: <20241128013424.4096668-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-11-27 at 17:33 -0800, Sean Christopherson wrote:
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
> This series also adds more hardening, e.g. to assert at compile-time if a
> feature flag is passed to the wrong word.  It also sets the stage for even
> more hardening in the future, as tracking all KVM-supported features allows
> shoving known vs. used features into arrays at compile time, which can then
> be checked for consistency irrespective of hardware support.  E.g. allows
> detecting if KVM is checking a feature without advertising it to userspace.
> This extra hardening is future work; I have it mostly working, but it's ugly
> and requires a runtime check to process the generated arrays.
> 
> There are *multiple* potentially breaking changes in this series (in for a
> penny, in for a pound).  However, I don't expect any fallout for real world
> VMMs because the ABI changes either disallow things that couldn't possibly
> have worked in the first place, or are following in the footsteps of other
> behaviors, e.g. KVM advertises x2APIC, which is 100% dependent on an in-kernel
> local APIC.
> 
>  * Disallow stuffing CPUID-dependent guest CR4 features before setting guest
>    CPUID.
>  * Disallow KVM_CAP_X86_DISABLE_EXITS after vCPU creation
>  * Reject disabling of MWAIT/HLT interception when not allowed
>  * Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID.
>  * Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
> 
> Validated the flag rework by comparing the output of KVM_GET_SUPPORTED_CPUID
> (and the emulated version) at the beginning and end of the series, on AMD
> and Intel hosts that should support almost every feature known to KVM.
> 
> Maxim, I did my best to incorporate all of your feedback, and when we
> disagreed, I tried to find an approach that I we can hopefully both live
> with, at least until someone comes up with a better idea.
> 
> I _think_ the only suggestion that I "rejected" entirely is the existence
> of ALIASED_1_EDX_F.  I responded to the previous thread, definitely feel
> free to continue the conversation there (or here).
> 
> If I missed something you care strongly about, please holler!

Hi,

I did go over this patch series, I don't think I have anything to add,
there are still things I disagree, especially the F* macros, IMHO this
makes the code less readable.

So if you want to merge this, I won't object.

Thanks,
Best regards,
	Maxim Levitsky

> 
> v3:
>  - Collect more reviews.
>  - Too many to list.
>  
> v2:
>  - Collect a few reviews (though I dropped several due to the patches changing
>    significantly).
>  - Incorporate KVM's support into the vCPU's cpu_caps. [Maxim]
>  - A massive pile of new patches.
> 
> Sean Christopherson (57):
>   KVM: x86: Use feature_bit() to clear CONSTANT_TSC when emulating CPUID
>   KVM: x86: Limit use of F() and SF() to
>     kvm_cpu_cap_{mask,init_kvm_defined}()
>   KVM: x86: Do all post-set CPUID processing during vCPU creation
>   KVM: x86: Explicitly do runtime CPUID updates "after" initial setup
>   KVM: x86: Account for KVM-reserved CR4 bits when passing through CR4
>     on VMX
>   KVM: selftests: Update x86's set_sregs_test to match KVM's CPUID
>     enforcement
>   KVM: selftests: Assert that vcpu->cpuid is non-NULL when getting CPUID
>     entries
>   KVM: selftests: Refresh vCPU CPUID cache in __vcpu_get_cpuid_entry()
>   KVM: selftests: Verify KVM stuffs runtime CPUID OS bits on CR4 writes
>   KVM: x86: Move __kvm_is_valid_cr4() definition to x86.h
>   KVM: x86/pmu: Drop now-redundant refresh() during init()
>   KVM: x86: Drop now-redundant MAXPHYADDR and GPA rsvd bits from vCPU
>     creation
>   KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS after vCPU creation
>   KVM: x86: Reject disabling of MWAIT/HLT interception when not allowed
>   KVM: x86: Drop the now unused KVM_X86_DISABLE_VALID_EXITS
>   KVM: selftests: Fix a bad TEST_REQUIRE() in x86's KVM PV test
>   KVM: selftests: Update x86's KVM PV test to match KVM's disabling
>     exits behavior
>   KVM: x86: Zero out PV features cache when the CPUID leaf is not
>     present
>   KVM: x86: Don't update PV features caches when enabling enforcement
>     capability
>   KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
>   KVM: x86: Account for max supported CPUID leaf when getting raw host
>     CPUID
>   KVM: x86: Unpack F() CPUID feature flag macros to one flag per line of
>     code
>   KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init()
>   KVM: x86: Add a macro to init CPUID features that are 64-bit only
>   KVM: x86: Add a macro to precisely handle aliased 0x1.EDX CPUID
>     features
>   KVM: x86: Handle kernel- and KVM-defined CPUID words in a single
>     helper
>   KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to avoid macro collisions
>   KVM: x86: Harden CPU capabilities processing against out-of-scope
>     features
>   KVM: x86: Add a macro to init CPUID features that ignore host kernel
>     support
>   KVM: x86: Add a macro to init CPUID features that KVM emulates in
>     software
>   KVM: x86: Swap incoming guest CPUID into vCPU before massaging in
>     KVM_SET_CPUID2
>   KVM: x86: Clear PV_UNHALT for !HLT-exiting only when userspace sets
>     CPUID
>   KVM: x86: Remove unnecessary caching of KVM's PV CPUID base
>   KVM: x86: Always operate on kvm_vcpu data in cpuid_entry2_find()
>   KVM: x86: Move kvm_find_cpuid_entry{,_index}() up near
>     cpuid_entry2_find()
>   KVM: x86: Remove all direct usage of cpuid_entry2_find()
>   KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
>   KVM: x86: Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
>   KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"
>   KVM: x86: Replace guts of "governed" features with comprehensive
>     cpu_caps
>   KVM: x86: Initialize guest cpu_caps based on guest CPUID
>   KVM: x86: Extract code for generating per-entry emulated CPUID
>     information
>   KVM: x86: Treat MONTIOR/MWAIT as a "partially emulated" feature
>   KVM: x86: Initialize guest cpu_caps based on KVM support
>   KVM: x86: Avoid double CPUID lookup when updating MWAIT at runtime
>   KVM: x86: Drop unnecessary check that cpuid_entry2_find() returns
>     right leaf
>   KVM: x86: Update OS{XSAVE,PKE} bits in guest CPUID irrespective of
>     host support
>   KVM: x86: Update guest cpu_caps at runtime for dynamic CPUID-based
>     features
>   KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
>   KVM: x86: Replace (almost) all guest CPUID feature queries with
>     cpu_caps
>   KVM: x86: Drop superfluous host XSAVE check when adjusting guest
>     XSAVES caps
>   KVM: x86: Add a macro for features that are synthesized into
>     boot_cpu_data
>   KVM: x86: Pull CPUID capabilities from boot_cpu_data only as needed
>   KVM: x86: Rename "SF" macro to "SCATTERED_F"
>   KVM: x86: Explicitly track feature flags that require vendor enabling
>   KVM: x86: Explicitly track feature flags that are enabled at runtime
>   KVM: x86: Use only local variables (no bitmask) to init kvm_cpu_caps
> 
>  Documentation/virt/kvm/api.rst                |  10 +-
>  arch/x86/include/asm/kvm_host.h               |  47 +-
>  arch/x86/kvm/cpuid.c                          | 967 ++++++++++++------
>  arch/x86/kvm/cpuid.h                          | 128 +--
>  arch/x86/kvm/governed_features.h              |  22 -
>  arch/x86/kvm/hyperv.c                         |   2 +-
>  arch/x86/kvm/lapic.c                          |   4 +-
>  arch/x86/kvm/mmu.h                            |   2 +-
>  arch/x86/kvm/mmu/mmu.c                        |   4 +-
>  arch/x86/kvm/pmu.c                            |   1 -
>  arch/x86/kvm/reverse_cpuid.h                  |  23 +-
>  arch/x86/kvm/smm.c                            |  10 +-
>  arch/x86/kvm/svm/nested.c                     |  22 +-
>  arch/x86/kvm/svm/pmu.c                        |   8 +-
>  arch/x86/kvm/svm/sev.c                        |  21 +-
>  arch/x86/kvm/svm/svm.c                        |  46 +-
>  arch/x86/kvm/svm/svm.h                        |   4 +-
>  arch/x86/kvm/vmx/hyperv.h                     |   2 +-
>  arch/x86/kvm/vmx/nested.c                     |  18 +-
>  arch/x86/kvm/vmx/pmu_intel.c                  |   4 +-
>  arch/x86/kvm/vmx/sgx.c                        |  14 +-
>  arch/x86/kvm/vmx/vmx.c                        |  61 +-
>  arch/x86/kvm/x86.c                            | 153 ++-
>  arch/x86/kvm/x86.h                            |   6 +-
>  include/uapi/linux/kvm.h                      |   4 -
>  .../selftests/kvm/include/x86_64/processor.h  |  18 +-
>  .../selftests/kvm/x86_64/kvm_pv_test.c        |  38 +-
>  .../selftests/kvm/x86_64/set_sregs_test.c     |  63 +-
>  28 files changed, 1017 insertions(+), 685 deletions(-)
>  delete mode 100644 arch/x86/kvm/governed_features.h
> 
> 
> base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14



