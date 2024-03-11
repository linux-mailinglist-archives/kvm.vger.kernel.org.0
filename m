Return-Path: <kvm+bounces-11545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 110B7878182
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 940F41F23919
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776593FBB4;
	Mon, 11 Mar 2024 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SpMTcSyk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160873FBBB
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166925; cv=none; b=LMgMv/2C1gJn1P1PaNHNVgzrJGHJhglq9f4GUcDFcGSD7MZNGHeijifsi6cb8+RvK5/n1Q2RvyyRppWMgsA2rQ1eOJAnIeimm58fSbIKlFlMhSyR3hv27xfcLXM7bGXl9+KDcrYNGW+K3MOs7aKr7NIcZ2h6O1wkY+uRHLeDnTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166925; c=relaxed/simple;
	bh=56NMSsh78LIDXtUGQ15OJt1n/hifnfNYi6T6+1kMdJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eq6HAWem4I8sy0nB0UpgvAAcUzWmeLMybFicMgGkvpGZgAZ0/fkPw/yR8DRVWTM75MokodeDVwyAp8suMyLE6H1Rukg0FbWeyLlr8Qe3LvPwouULjvlTL2xh1+4E4IC+RuloPr22mfxgtyXV0POxmdpMOmtll8Bs9jXjXjLj0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SpMTcSyk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710166922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RAM/g6tP3EohpH0ynb9pjDy8L9dI16bvnaUHNHXa5y0=;
	b=SpMTcSykS0R89oXjrmcRwnToZVUXvm/r/VfQfVVG/oniRoF2bpgvgAGVSm081E0GS96VV6
	kUcrQEwGqdf7oXfxbxVVv2hfTGtWjO072F6yKFjoTaazbyQcGkpE4AzjCXiPqc1hThZP9V
	hC1eDQJ3pQG2HlVrUmQHEx4+ZV9XgvU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-GQifLuluMfOd0pJzzGE-oA-1; Mon, 11 Mar 2024 10:22:01 -0400
X-MC-Unique: GQifLuluMfOd0pJzzGE-oA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d449d68bc3so2991811fa.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710166918; x=1710771718;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RAM/g6tP3EohpH0ynb9pjDy8L9dI16bvnaUHNHXa5y0=;
        b=Q4xrlLKbG3HJRgHiEmXJfy+9y7pCbHhexzyAM26ArTRspHdYZREyDct7g6drYfe/+h
         ovI64bdpqk7dN7X67dF/K7bahVu90omuHHpvb9O678z876E5sVgi4Rz10i/QOPaPbmIL
         Of/CsFr2fcuTYpV22AFbco3GkzyNaIJL/yi2KzSPCg0vVkvCf3xq9jzEd+NVw7FAtjFN
         J6lpLOFjcJ9H50kkOaId1yIHUmi+JvoNbr175bpOkh28zdzjH9SkvAka7YaRfx/SAwwm
         lepj6p+oUgbZwg3+2xL7lJngGBICWtyYkV4lhV+sUxyNOkZS9h+/06nrtuPVgfO/k/xW
         8p8g==
X-Gm-Message-State: AOJu0YyWxUhXlhNd8fpe8Feh9tgqgc9IzXuwh1s0854HaadoX+PwyynZ
	5GZpiI8YGvAUU9SbIG7kN9FtTuw8gMjPJ9yKeM1jAdmajaXFJWozBEOkwUDuatwV9ZHVA6QyiiP
	j0D4ykcarZ1tja6ED4UYqFquw4FM33XNhNerj5JhqzOaoqNguLQlafahoyw==
X-Received: by 2002:a2e:928c:0:b0:2d2:7813:6ca3 with SMTP id d12-20020a2e928c000000b002d278136ca3mr3987056ljh.9.1710166917845;
        Mon, 11 Mar 2024 07:21:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEudDoSlDrAPGJDZZw9T6E13NYse0casdKPoAa9Hjpb6Oa45x3X+Yn3zLjLLEayZ4IwFH+K1A==
X-Received: by 2002:a2e:928c:0:b0:2d2:7813:6ca3 with SMTP id d12-20020a2e928c000000b002d278136ca3mr3987042ljh.9.1710166917408;
        Mon, 11 Mar 2024 07:21:57 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id et8-20020a056402378800b00566a4dec01fsm2972343edb.11.2024.03.11.07.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:21:56 -0700 (PDT)
Message-ID: <f27274a9-fc5d-4be3-a364-5f5a471c20bd@redhat.com>
Date: Mon, 11 Mar 2024 15:21:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: Selftests changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240308223702.1350851-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:36, Sean Christopherson wrote:
> Add SEV(-ES) smoke tests, and start building out infrastructure to utilize the
> "core" selftests harness and TAP.  In addition to provide TAP output, using the
> infrastructure reduces boilerplate code and allows running all testscases in a
> test, even if a previous testcase fails (compared with today, where a testcase
> failure is terminal for the entire test).
> 
> As noted in the PMU pull request, the "Use TAP interface" changes have a few
> conflicts.  3 of 4 are relatively straightforward, but the one in
> userspace_msr_exit_test.c's test_msr_filter_allow() is a pain.  At least, I
> thought so as I botched it at least twice.  (LOL, make that three times, as I
> just botched my test merge resolution).
> 
> The code should end up looking like this:
> 
> ---
> KVM_ONE_VCPU_TEST_SUITE(user_msr);
> 
> KVM_ONE_VCPU_TEST(user_msr, msr_filter_allow, guest_code_filter_allow)
> {
> 	struct kvm_vm *vm = vcpu->vm;
> 	uint64_t cmd;
> 	int rc;
> 
> 	sync_global_to_guest(vm, fep_available);
> 
> 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
> ---
> 
> The resolutions I've been using can be found in kvm-x86/next.
> 
> 
> The following changes since commit db7d6fbc10447090bab8691a907a7c383ec66f58:
> 
>    KVM: remove unnecessary #ifdef (2024-02-08 08:41:06 -0500)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.9
> 
> for you to fetch changes up to e9da6f08edb0bd4c621165496778d77a222e1174:
> 
>    KVM: selftests: Explicitly close guest_memfd files in some gmem tests (2024-03-05 13:31:20 -0800)
> 
> ----------------------------------------------------------------
> KVM selftests changes for 6.9:
> 
>   - Add macros to reduce the amount of boilerplate code needed to write "simple"
>     selftests, and to utilize selftest TAP infrastructure, which is especially
>     beneficial for KVM selftests with multiple testcases.
> 
>   - Add basic smoke tests for SEV and SEV-ES, along with a pile of library
>     support for handling private/encrypted/protected memory.
> 
>   - Fix benign bugs where tests neglect to close() guest_memfd files.
> 
> ----------------------------------------------------------------

Pulled, thanks.

Paolo

> Ackerley Tng (1):
>        KVM: selftests: Add a macro to iterate over a sparsebit range
> 
> Dongli Zhang (1):
>        KVM: selftests: Explicitly close guest_memfd files in some gmem tests
> 
> Michael Roth (2):
>        KVM: selftests: Make sparsebit structs const where appropriate
>        KVM: selftests: Add support for protected vm_vaddr_* allocations
> 
> Peter Gonda (5):
>        KVM: selftests: Add support for allocating/managing protected guest memory
>        KVM: selftests: Explicitly ucall pool from shared memory
>        KVM: selftests: Allow tagging protected memory in guest page tables
>        KVM: selftests: Add library for creating and interacting with SEV guests
>        KVM: selftests: Add a basic SEV smoke test
> 
> Sean Christopherson (4):
>        KVM: selftests: Move setting a vCPU's entry point to a dedicated API
>        KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
>        KVM: selftests: Use the SEV library APIs in the intra-host migration test
>        KVM: selftests: Add a basic SEV-ES smoke test
> 
> Thomas Huth (7):
>        KVM: selftests: x86: sync_regs_test: Use vcpu_run() where appropriate
>        KVM: selftests: x86: sync_regs_test: Get regs structure before modifying it
>        KVM: selftests: Add a macro to define a test with one vcpu
>        KVM: selftests: x86: Use TAP interface in the sync_regs test
>        KVM: selftests: x86: Use TAP interface in the fix_hypercall test
>        KVM: selftests: x86: Use TAP interface in the vmx_pmu_caps test
>        KVM: selftests: x86: Use TAP interface in the userspace_msr_exit test
> 
>   tools/testing/selftests/kvm/Makefile               |   2 +
>   tools/testing/selftests/kvm/guest_memfd_test.c     |   3 +
>   .../selftests/kvm/include/aarch64/kvm_util_arch.h  |   7 ++
>   .../selftests/kvm/include/kvm_test_harness.h       |  36 ++++++
>   .../testing/selftests/kvm/include/kvm_util_base.h  |  61 +++++++++--
>   .../selftests/kvm/include/riscv/kvm_util_arch.h    |   7 ++
>   .../selftests/kvm/include/s390x/kvm_util_arch.h    |   7 ++
>   tools/testing/selftests/kvm/include/sparsebit.h    |  56 +++++++---
>   .../selftests/kvm/include/x86_64/kvm_util_arch.h   |  23 ++++
>   .../selftests/kvm/include/x86_64/processor.h       |   8 ++
>   tools/testing/selftests/kvm/include/x86_64/sev.h   | 107 ++++++++++++++++++
>   .../testing/selftests/kvm/lib/aarch64/processor.c  |  24 +++-
>   tools/testing/selftests/kvm/lib/kvm_util.c         |  67 ++++++++++--
>   tools/testing/selftests/kvm/lib/riscv/processor.c  |   9 +-
>   tools/testing/selftests/kvm/lib/s390x/processor.c  |  13 ++-
>   tools/testing/selftests/kvm/lib/sparsebit.c        |  48 ++++----
>   tools/testing/selftests/kvm/lib/ucall_common.c     |   3 +-
>   tools/testing/selftests/kvm/lib/x86_64/processor.c |  45 +++++++-
>   tools/testing/selftests/kvm/lib/x86_64/sev.c       | 114 +++++++++++++++++++
>   .../selftests/kvm/x86_64/fix_hypercall_test.c      |  27 +++--
>   .../kvm/x86_64/private_mem_conversions_test.c      |   2 +
>   .../selftests/kvm/x86_64/sev_migrate_tests.c       |  60 +++-------
>   .../testing/selftests/kvm/x86_64/sev_smoke_test.c  |  88 +++++++++++++++
>   .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 121 +++++++++++++++------
>   .../selftests/kvm/x86_64/userspace_msr_exit_test.c |  52 +++------
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |  52 ++-------
>   26 files changed, 802 insertions(+), 240 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/kvm_test_harness.h
>   create mode 100644 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
>   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
> 


