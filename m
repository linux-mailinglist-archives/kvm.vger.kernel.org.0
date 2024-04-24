Return-Path: <kvm+bounces-15745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9ED8AFE19
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 04:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DB431F240CD
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A8F1401F;
	Wed, 24 Apr 2024 01:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6M489X4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D382125C1;
	Wed, 24 Apr 2024 01:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713923996; cv=none; b=JWgLNswps16+6L9Sy+aZ1dRUpa8SRE9ZpaY4+zz5FYV6W9jCXrKLxW9W2nb+hIRMXKtb6z8YMViZ2wEjhmEkq/Hjz36BBvg/dWjrz0h7445KKD2h3hMs2EGaYgRFDYcwjuNNhdvrrJhfOTmcbaiP8M1ga585zLpVxmsGz4H5bb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713923996; c=relaxed/simple;
	bh=DyNPAzKwbokZufqAtuH44GkPsBoseooq6vKYJRnGTls=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=AIP+xfrM0yDk/kwoU7C1alcEgPOXTzAMl93LkplmukV57Td4uNhfdZ64day9nkIx/KQdqi88/Q+DkSrdFrsFe/VI7aA0Y0Qdg20eff/4hNLbiPva7VUheUyJPa870dEPEu80e7G7J81WDRKG+O//uo19ocBxpKrrHRzNteMlqvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6M489X4; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713923996; x=1745459996;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=DyNPAzKwbokZufqAtuH44GkPsBoseooq6vKYJRnGTls=;
  b=B6M489X4xc8ftvXGGaNHg3/S0hBOuZtA4LyXnKTEGQ24Nx8dX3lGHamn
   e6OlIRlbTCWTR9uwuDjD4KfIiDegxdAz+x+0T+1cZuzInnmdSGdWL0NlP
   nUlF1+7Rs+u6CG13itkmqEAol5rJMfAEvwsj3nnaApagrchnQTUFzAJuC
   Fe+eXH0RP+lS7Ftv9AWP1fW/WBLHhC4OVNB4/1E17rnkQBbqZ2smyoaDt
   Smddm5lYOM4BbA//NJ8PR4xwMD3+x8WNalz2YT/t3x009TzbAC3CSFV3J
   P1j5FnadgF7LALB7DOMPJ5+Tf17e5rFhUi4TkKpstuDNpAAJ78B6A9Dd3
   w==;
X-CSE-ConnectionGUID: DeZ+m4eiTTGjGehUYvMcBw==
X-CSE-MsgGUID: DkpnNzSWTGyOlC7BAiNlpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9408467"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9408467"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 18:59:48 -0700
X-CSE-ConnectionGUID: xNecZULcRNyluOPYVbRgzQ==
X-CSE-MsgGUID: 92dJW6OOSnKEeJSXPg7ZxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24615469"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 18:59:46 -0700
Message-ID: <60c1bfe3-2210-4670-afa9-d4f789208650@intel.com>
Date: Wed, 24 Apr 2024 09:59:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] KVM: selftests: x86: Add test for
 KVM_PRE_FAULT_MEMORY
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com, binbin.wu@linux.intel.com, seanjc@google.com,
 rick.p.edgecombe@intel.com
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-7-pbonzini@redhat.com>
 <b7d6bb0c-6ee4-4f93-a1a0-5ee6f49c0c59@intel.com>
Content-Language: en-US
In-Reply-To: <b7d6bb0c-6ee4-4f93-a1a0-5ee6f49c0c59@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/23/2024 11:18 PM, Xiaoyao Li wrote:
> On 4/19/2024 4:59 PM, Paolo Bonzini wrote:
> 
> ...
> 
>> +static void __test_pre_fault_memory(unsigned long vm_type, bool private)
>> +{
>> +    const struct vm_shape shape = {
>> +        .mode = VM_MODE_DEFAULT,
>> +        .type = vm_type,
>> +    };
>> +    struct kvm_vcpu *vcpu;
>> +    struct kvm_run *run;
>> +    struct kvm_vm *vm;
>> +    struct ucall uc;
>> +
>> +    uint64_t guest_test_phys_mem;
>> +    uint64_t guest_test_virt_mem;
>> +    uint64_t alignment, guest_page_size;
>> +
>> +    vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
>> +
>> +    alignment = guest_page_size = 
>> vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
>> +    guest_test_phys_mem = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
>> +#ifdef __s390x__
>> +    alignment = max(0x100000UL, guest_page_size);
>> +#else
>> +    alignment = SZ_2M;
>> +#endif
>> +    guest_test_phys_mem = align_down(guest_test_phys_mem, alignment);
>> +    guest_test_virt_mem = guest_test_phys_mem;
> 
> guest_test_virt_mem cannot be assigned as guest_test_phys_mem, which 
> leads to following virt_map() fails with

The root cause is that vm->pa_bits is 52 while vm->va_bits is 48. So 
vm->max_gfn is beyond the capability of va space

> ==== Test Assertion Failure ====
>    lib/x86_64/processor.c:197: sparsebit_is_set(vm->vpages_valid, (vaddr 
>  >> vm->page_shift))
>    pid=4773 tid=4773 errno=0 - Success
>       1    0x000000000040f55c: __virt_pg_map at processor.c:197
>       2    0x000000000040605e: virt_pg_map at kvm_util_base.h:1065
>       3     (inlined by) virt_map at kvm_util.c:1571
>       4    0x0000000000402b75: __test_pre_fault_memory at 
> pre_fault_memory_test.c:96
>       5    0x000000000040246e: test_pre_fault_memory at 
> pre_fault_memory_test.c:133 (discriminator 3)
>       6     (inlined by) main at pre_fault_memory_test.c:140 
> (discriminator 3)
>       7    0x00007fcb68429d8f: ?? ??:0
>       8    0x00007fcb68429e3f: ?? ??:0
>       9    0x00000000004024e4: _start at ??:?
>    Invalid virtual address, vaddr: 0xfffffffc00000
> 
>> +
>> +    vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
>> +                    guest_test_phys_mem, TEST_SLOT, TEST_NPAGES,
>> +                    private ? KVM_MEM_GUEST_MEMFD : 0);
>> +    virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, TEST_NPAGES);
> 
> 
> 
> 
> 


