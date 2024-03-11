Return-Path: <kvm+bounces-11552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 724C88781D5
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F269A2810F4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455C1405D8;
	Mon, 11 Mar 2024 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKgMHx9H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDE03FB8F
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710168068; cv=none; b=J534pjZxTrKPqyR3dxc1DmbDPw/fpcs+Pvf0+kCgKAKxo9UqljsUn2TEOU1xdk6r8Y2y/X2+UCMSMK4+c6naCTksBm5OTeHvF8Z2L/DEjZDBXcpagyUJGOpq344j75i+zI5s2718kx1Iv7PfI3JcnKEqkLWMD4824hZzgAV/mwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710168068; c=relaxed/simple;
	bh=yucr9s/lBBGdWtlJzYXkiwRLHLQBsa6ElDX2Jb0ofJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DbOH1n9LjB2AW4llFfEAIQevxMc7h+gsItlgXLYWZAfjEO0ejCMEAkx95VVCuxGr0WYTOQaPGel9/SJZp3ZZ1dYXWV/6Ya65RSVGCAZkvvZdud7BD/6d7ISmD5t+vaI9kN71kL5nC9X+abKylsH2TX4Bw06k3tgNTMp9c7xey/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KKgMHx9H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710168065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1Ln6DMStTH/dqt1H0TtHk7/u1gLfSe+VO2DEgx5urmQ=;
	b=KKgMHx9Hz7FwZLNMZkMkd+5Pk17ywpJqaZu4KCSvguJ6PYzV1HyFUyOQYjwQDe6D3joCjO
	Y1hBQfA38o6mGVRfqCqGbaRkc33Rs8toOEM42HtXOK/OTH15DW75lKrxgJOBcpoazH9O5x
	mmq2tuKuTHZaSxtsOGqwsFTyyyiAZ08=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361--RyKpIcGNnGOSzXroMZpqA-1; Mon, 11 Mar 2024 10:41:04 -0400
X-MC-Unique: -RyKpIcGNnGOSzXroMZpqA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a4488afb812so232827866b.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710168062; x=1710772862;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ln6DMStTH/dqt1H0TtHk7/u1gLfSe+VO2DEgx5urmQ=;
        b=n3aSPgLN/H5xw3Az2YQV5Lmu2mttJmU3XnUYuAbHARSW9UdCniOuHAlr4jfeGvxFaH
         eW+E3VruRuFiRlCF4M3ns7ejlCcTxNynIrS6SBnURPxVvnw7bXBYBrJWckq1CHATZuR7
         MX8/vEkjt/6j+OKLy+G6AF5NthsQ3kmqGXSiIEqoiXJTowpNVnYc2EchL6XmuzAFhBxX
         t4Ej9SCHx1cUefdQPEzyodhO52QY25k3pOJg4z5T9ThzgDiUbpL3LNKpTFdCnlRkbr8U
         aR5IVZyI3sfdyapSk6zJI+WZrTLzUzKEDxMlv8FhHqHlG41v6KoNdoyKj6MrqKPuVwaV
         FWNg==
X-Gm-Message-State: AOJu0YyFvXe/IzUAHYE15y2O7c6gg676Loi8+5orgJoSSKG3WSrMWer+
	YgLGS9FihZLbqhmFMZH+qZhM27piI6C2zYyzLXt25Pa/WpV7owju7BmgHe/Tyers+xRJKxTX26y
	b307+WBgqMeNYBkFJwdhop6oAF29k4Xp8gIT0nShiQhnNtxhpGtyI1qkFqw==
X-Received: by 2002:a17:907:a08f:b0:a46:130a:468 with SMTP id hu15-20020a170907a08f00b00a46130a0468mr5144858ejc.13.1710168062194;
        Mon, 11 Mar 2024 07:41:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUMs/7QIelXz7wC33a4600qJYkmd2LfwG1fV6c3sHMloSd28mQwMCofxePmzuSEOZvd6Qvxg==
X-Received: by 2002:a17:907:a08f:b0:a46:130a:468 with SMTP id hu15-20020a170907a08f00b00a46130a0468mr5144824ejc.13.1710168061842;
        Mon, 11 Mar 2024 07:41:01 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id t25-20020a1709063e5900b00a45c8c9a876sm2911741eji.88.2024.03.11.07.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:41:00 -0700 (PDT)
Message-ID: <3d9fcdfd-dbc7-409a-bc1c-c1b8f601ace9@redhat.com>
Date: Mon, 11 Mar 2024 15:40:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: PMU changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-6-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240308223702.1350851-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:36, Sean Christopherson wrote:
> Lots of PMU fixes and cleanups, along with related selftests.  The most notable
> fix is to *not* disallow the use of fixed counters and event encodings just
> because the CPU doesn't report support for the matching architectural event
> encoding.
> 
> Note, the selftests changes have several annoying conflicts with "the" selftests
> pull request that you'll also receive from me.  I recommend merging that one
> first, as I found it slightly easier to resolve the conflicts in that order.
> 
> P.S. I expect to send another PMU related pull request of 3-4 fixes at some
> point during the merge window.  But they're all small and urgent (if we had a
> few more weeks for 6.8, I'd have tried to squeeze them into 6.8).
> 
> The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:
> 
>    Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.9
> 
> for you to fetch changes up to 812d432373f629eb8d6cb696ea6804fca1534efa:
> 
>    KVM: x86/pmu: Explicitly check NMI from guest to reducee false positives (2024-02-26 15:57:22 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 PMU changes for 6.9:
> 
>   - Fix several bugs where KVM speciously prevents the guest from utilizing
>     fixed counters and architectural event encodings based on whether or not
>     guest CPUID reports support for the _architectural_ encoding.
> 
>   - Fix a variety of bugs in KVM's emulation of RDPMC, e.g. for "fast" reads,
>     priority of VMX interception vs #GP, PMC types in architectural PMUs, etc.
> 
>   - Add a selftest to verify KVM correctly emulates RDMPC, counter availability,
>     and a variety of other PMC-related behaviors that depend on guest CPUID,
>     i.e. are difficult to validate via KVM-Unit-Tests.
> 
>   - Zero out PMU metadata on AMD if the virtual PMU is disabled to avoid wasting
>     cycles, e.g. when checking if a PMC event needs to be synthesized when
>     skipping an instruction.
> 
>   - Optimize triggering of emulated events, e.g. for "count instructions" events
>     when skipping an instruction, which yields a ~10% performance improvement in
>     VM-Exit microbenchmarks when a vPMU is exposed to the guest.
> 
>   - Tighten the check for "PMI in guest" to reduce false positives if an NMI
>     arrives in the host while KVM is handling an IRQ VM-Exit.
> 
> ----------------------------------------------------------------
> Dapeng Mi (1):
>        KVM: selftests: Test top-down slots event in x86's pmu_counters_test
> 
> Jinrong Liang (7):
>        KVM: selftests: Add vcpu_set_cpuid_property() to set properties
>        KVM: selftests: Add pmu.h and lib/pmu.c for common PMU assets
>        KVM: selftests: Test Intel PMU architectural events on gp counters
>        KVM: selftests: Test Intel PMU architectural events on fixed counters
>        KVM: selftests: Test consistency of CPUID with num of gp counters
>        KVM: selftests: Test consistency of CPUID with num of fixed counters
>        KVM: selftests: Add functional test for Intel's fixed PMU counters
> 
> Like Xu (1):
>        KVM: x86/pmu: Explicitly check NMI from guest to reducee false positives
> 
> Sean Christopherson (32):
>        KVM: x86/pmu: Always treat Fixed counters as available when supported
>        KVM: x86/pmu: Allow programming events that match unsupported arch events
>        KVM: x86/pmu: Remove KVM's enumeration of Intel's architectural encodings
>        KVM: x86/pmu: Setup fixed counters' eventsel during PMU initialization
>        KVM: x86/pmu: Get eventsel for fixed counters from perf
>        KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC index on AMD
>        KVM: x86/pmu: Prioritize VMX interception over #GP on RDPMC due to bad index
>        KVM: x86/pmu: Apply "fast" RDPMC only to Intel PMUs
>        KVM: x86/pmu: Disallow "fast" RDPMC for architectural Intel PMUs
>        KVM: x86/pmu: Treat "fixed" PMU type in RDPMC as index as a value, not flag
>        KVM: x86/pmu: Explicitly check for RDPMC of unsupported Intel PMC types
>        KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
>        KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
>        KVM: selftests: Expand PMU counters test to verify LLC events
>        KVM: selftests: Add a helper to query if the PMU module param is enabled
>        KVM: selftests: Add helpers to read integer module params
>        KVM: selftests: Query module param to detect FEP in MSR filtering test
>        KVM: selftests: Move KVM_FEP macro into common library header
>        KVM: selftests: Test PMC virtualization with forced emulation
>        KVM: selftests: Add a forced emulation variation of KVM_ASM_SAFE()
>        KVM: selftests: Add helpers for safe and safe+forced RDMSR, RDPMC, and XGETBV
>        KVM: selftests: Extend PMU counters test to validate RDPMC after WRMSR
>        KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is disabled
>        KVM: x86/pmu: Add common define to capture fixed counters offset
>        KVM: x86/pmu: Move pmc_idx => pmc translation helper to common code
>        KVM: x86/pmu: Snapshot and clear reprogramming bitmap before reprogramming
>        KVM: x86/pmu: Add macros to iterate over all PMCs given a bitmap
>        KVM: x86/pmu: Process only enabled PMCs when emulating events in software
>        KVM: x86/pmu: Snapshot event selectors that KVM emulates in software
>        KVM: x86/pmu: Expand the comment about what bits are check emulating events
>        KVM: x86/pmu: Check eventsel first when emulating (branch) insns retired
>        KVM: x86/pmu: Avoid CPL lookup if PMC enabline for USER and KERNEL is the same
> 
>   arch/x86/include/asm/kvm-x86-pmu-ops.h             |   4 +-
>   arch/x86/include/asm/kvm_host.h                    |  11 +-
>   arch/x86/kvm/emulate.c                             |   2 +-
>   arch/x86/kvm/kvm_emulate.h                         |   2 +-
>   arch/x86/kvm/pmu.c                                 | 163 ++++--
>   arch/x86/kvm/pmu.h                                 |  57 +-
>   arch/x86/kvm/svm/pmu.c                             |  22 +-
>   arch/x86/kvm/vmx/nested.c                          |   2 +-
>   arch/x86/kvm/vmx/pmu_intel.c                       | 222 +++-----
>   arch/x86/kvm/x86.c                                 |  15 +-
>   arch/x86/kvm/x86.h                                 |   6 -
>   tools/testing/selftests/kvm/Makefile               |   2 +
>   .../testing/selftests/kvm/include/kvm_util_base.h  |   4 +
>   tools/testing/selftests/kvm/include/x86_64/pmu.h   |  97 ++++
>   .../selftests/kvm/include/x86_64/processor.h       | 148 +++--
>   tools/testing/selftests/kvm/lib/kvm_util.c         |  62 ++-
>   tools/testing/selftests/kvm/lib/x86_64/pmu.c       |  31 ++
>   tools/testing/selftests/kvm/lib/x86_64/processor.c |  15 +-
>   .../selftests/kvm/x86_64/pmu_counters_test.c       | 620 +++++++++++++++++++++
>   .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 143 ++---
>   .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c |   2 +-
>   .../selftests/kvm/x86_64/userspace_msr_exit_test.c |  29 +-
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   2 +-
>   23 files changed, 1262 insertions(+), 399 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/pmu.h
>   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/pmu.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> 


