Return-Path: <kvm+bounces-55780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F20C9B3715C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 19:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D93F366ECC
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958DC2E7BDC;
	Tue, 26 Aug 2025 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="niOLBQaZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02342D0C7B
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229485; cv=none; b=Vvy0bK/wXFAHQgJaCe5t5QT0nxotLXs2N3Gkr9n+fFYOt+ItG3hkLZmN8wUV8trlLTv22DUM5COp+vMJ3hMZTlHHwAmTj0lvtDssEsB5P4FaDCVV4aeUbCN8X2gt9bqYqwzrA1/qKv7lAV+BWZ/rmx1wJMdATQQWcuk/VQBbsXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229485; c=relaxed/simple;
	bh=wlXAC48l9HeoETx+1S2JCCMxb76UoHT2HZti0qu21rQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tq1JsPYXa06DSSjZcT5BbGPL4bFI513wXhVRqZF6zMdIMFJ0O4Py9M/GjGAboS0A74FD0/HrtGIg0F7SAS+wRYjbkXOjVf5nZpDoI/Pz6uJB/T3ZJ1d06P5JOZvnU991G94wyZOtZb6bK6j+can+M3rIMi6eM8HzSC7yjpe69cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=niOLBQaZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445803f0cfso64527235ad.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 10:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756229481; x=1756834281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+VkPKEfiEBtNUsHM/Rw/t6rk+QUhjWHCoc9fIKfrHXg=;
        b=niOLBQaZNqtDIfKZEXfFSq2ZO5l4lhc48q37Yl+ZTwuuB4jUFqPbESUKGTCqqDwbCv
         SSgXUZKvGl32+z7iYqH/Y0zq/IzO2Fto7qwxgrzaUYw1ZJe1rarZ+Jm49jLrN7Bq/bIx
         w3PKCZjE0yT6VGC9AgyFxpwYbIKLbpWVrguVWd0r0qU6hga8/VJxFACsdmE5NvIzEKrR
         Dp5bXv05crnd7JarQJhdYZtlcbsnQ7BCQ6nwjxD3J6bnB2UOWo/X+OajYZ7CWYgJAH74
         qq2J1tYc/N5ufqoYnggMke8VJMSRlKSXVjy2AiKo63uwOYGz3hYCO6DdOyz9A2YD4aHX
         bFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756229481; x=1756834281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+VkPKEfiEBtNUsHM/Rw/t6rk+QUhjWHCoc9fIKfrHXg=;
        b=uP0iK8OqOODpaT1OU1sTxxek7HtLXmxKwad8t3dBr7Z1ruNjvg1QFmymFG/8S7bjkY
         bmRiinba3I+RzdnixrSd6Zon0r05UoodFzZklc2n761hG9SwNOuqWFawI/qPz9l73bOS
         E/fhiMGMfJNnGbwHkHAaBRB9cAiYFAG++fsdSmIGMMp0IpZnXzdBRIZDdH0/U1ZTpUj6
         tXVTWGz3uTULZbfzSePwmDjtyfx0T8CD2vByUohMDzJcnddTGixm7wPqvYFE+CQ+AIaY
         Y+GCAp1pKm9k2MpxfLSLfUs5FDgAGjTB4KqT8K9tAhlrEm1kX2skTm7gpznW/g8YkiRk
         UBrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8Mt+Fx0vjB2yKaD8iM+QwbKKowxCsD1comxRit7qyeB8RHVh2t40ABbi9uwfGdH00X4o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBVkeheGaNdJ2hGXpf7gsIIgwZvGyfJ9M828lD0NJGiQi0R90e
	Q0/ospb/jrVcxkbuQSpA2aSC+P9Eg6N4YVtKDuzUWx1ZcBnMLp9hY4AKX6iClHJ+RJdOiNGJMYq
	wvB8rWw==
X-Google-Smtp-Source: AGHT+IHojf4NK4oLugsTS5XfSGTRk4QbLmnqRQLIh2si4edSqQ/wMyzbmJ/fMB8FGp5tmKAFLUAegxOiqZE=
X-Received: from plcc19.prod.google.com ([2002:a17:902:c1d3:b0:248:8be8:f33])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b44:b0:246:931e:4db4
 with SMTP id d9443c01a7336-246931e5571mr153388275ad.45.1756229481211; Tue, 26
 Aug 2025 10:31:21 -0700 (PDT)
Date: Tue, 26 Aug 2025 10:31:19 -0700
In-Reply-To: <20250821042915.3712925-16-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-16-sagis@google.com>
Message-ID: <aK3vZ5HuKKeFuuM4@google.com>
Subject: Re: [PATCH v9 15/19] KVM: selftests: Hook TDX support to vm and vcpu creation
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 20, 2025, Sagi Shahar wrote:
> TDX require special handling for VM and VCPU initialization for various
> reasons:
> - Special ioctlss for creating VM and VCPU.
> - TDX registers are inaccessible to KVM.
> - TDX require special boot code trampoline for loading parameters.
> - TDX only supports KVM_CAP_SPLIT_IRQCHIP.

Please split this up and elaborate at least a little bit on why each flow needs
special handling for TDX.  Even for someone like me who is fairly familiar with
TDX, there's too much "Trust me bro" and not enough explanation of why selftests
really need all of these special paths for TDX.

At least four patches, one for each of your bullet points.  Probably 5 or 6, as
I think the CPUID handling warrants its own patch.

> Hook this special handling into __vm_create() and vm_arch_vcpu_add()
> using the utility functions added in previous patches.
>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 24 ++++++++-
>  .../testing/selftests/kvm/lib/x86/processor.c | 49 ++++++++++++++-----
>  2 files changed, 61 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b4c8702ba4bd..d9f0ff97770d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -4,6 +4,7 @@
>   *
>   * Copyright (C) 2018, Google LLC.
>   */
> +#include "tdx/tdx_util.h"
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> @@ -465,7 +466,7 @@ void kvm_set_files_rlimit(uint32_t nr_vcpus)
>  static bool is_guest_memfd_required(struct vm_shape shape)
>  {
>  #ifdef __x86_64__
> -	return shape.type == KVM_X86_SNP_VM;
> +	return (shape.type == KVM_X86_SNP_VM || shape.type == KVM_X86_TDX_VM);
>  #else
>  	return false;
>  #endif
> @@ -499,6 +500,12 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
>  	for (i = 0; i < NR_MEM_REGIONS; i++)
>  		vm->memslots[i] = 0;
>  
> +	if (is_tdx_vm(vm)) {
> +		/* Setup additional mem regions for TDX. */
> +		vm_tdx_setup_boot_code_region(vm);
> +		vm_tdx_setup_boot_parameters_region(vm, nr_runnable_vcpus);
> +	}
> +
>  	kvm_vm_elf_load(vm, program_invocation_name);
>  
>  	/*
> @@ -1728,11 +1735,26 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
>  	return (void *) ((uintptr_t) region->host_alias + offset);
>  }
>  
> +static bool is_split_irqchip_required(struct kvm_vm *vm)
> +{
> +#ifdef __x86_64__
> +	return is_tdx_vm(vm);
> +#else
> +	return false;
> +#endif
> +}
> +
>  /* Create an interrupt controller chip for the specified VM. */
>  void vm_create_irqchip(struct kvm_vm *vm)
>  {
>  	int r;
>  
> +	if (is_split_irqchip_required(vm)) {
> +		vm_enable_cap(vm, KVM_CAP_SPLIT_IRQCHIP, 24);
> +		vm->has_irqchip = true;
> +		return;
> +	}

Ugh.  IMO, this is a KVM bug.  Allowing KVM_CREATE_IRQCHIP for a TDX VM is simply
wrong.  It _can't_ work.  Waiting until KVM_CREATE_VCPU to fail setup is terrible
ABI.

If we stretch the meaning of ENOTTY a bit and return that when trying to create
a fully in-kernel IRQCHIP for a TDX VM, then the selftests code Just Works thanks
to the code below, which handles the scenario where KVM was be built without
support for in-kernel I/O APIC (and PIC and PIT).

