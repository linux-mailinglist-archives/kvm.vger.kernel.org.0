Return-Path: <kvm+bounces-58964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B5FBA8842
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58E3A162BA5
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91EC27F171;
	Mon, 29 Sep 2025 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kb6UkcHW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D87D25CC5E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759136726; cv=none; b=Vn4HOVAspjtRawjrAK1SOkkH3WCbvoL905OuniiBNyG4tZPvv9dNCLXiOEplYJsuk4ueBcbzCUKSGccPJ6zUoyKH0a36srbmLwSoguYhDSFvq6dw4jWTzObm2v/PrfyKJgZ4DxgTSKoB4haJPUzUkOgqzQv719utPwdSq9bgdSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759136726; c=relaxed/simple;
	bh=YHUcpuTalHZA4hemrg/nP7XpE6XvqXCshF/oUy6UeGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XlX9PEfHUf/7FGyJuw7mAMlxRAYZ1OCBtoz6LuIORZ8YzPLMoEICZtt/mj06ecvNX6tz3Zcfx8NilFZmvxN5Z5OlSWtjAHulK/km0EQIY4y7G6I94LS9Zu3dUp5QsXbDykDLV9WpkO6rGErfcdf1SPxxplI8aptbcdYLv1fHpfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kb6UkcHW; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4de60f19a57so781111cf.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759136723; x=1759741523; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C/7KexrLTQ/LQEgTu519hhOOiaONCYy510f2xT+sojQ=;
        b=Kb6UkcHWVqCxrjWJo5D5cF1b/dyJZzUO582r3J2IOxtb9Gsdwr/SU9GVN/RHcaFo1K
         2bwY+pjh2Sjt6NFkBlcVZsQyITJtWqtFnXR+vJm8z1dNLlBTw9v+Aa1bVTfudHd4MVE4
         kJQub4/o/vHadVi6b16wuRX9Rmf5zDxurthnvHSQPr5OIu/grG1ucrR2jC9whCCab+UD
         /afh2zK2Qxp0Pszxa3H1YUOmfdeNm/6ExTBNW/gpzhnrpnG40h4PODezAvsvvDwvh3U3
         Iyt3r0BYQV+sGQvzanWzV5DVpSbl2OmChYGlzlvV9nGuCi7I9Ucnq8Zkjf2BM0qSvzp+
         txww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759136723; x=1759741523;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C/7KexrLTQ/LQEgTu519hhOOiaONCYy510f2xT+sojQ=;
        b=B9iTMGNmq6gN3zE6qE8mIotj59HzJD4Hoz9OLGP5lV+skMg4SHSypgjaUIKFHQviWb
         6uocjhkzHQvVe17/VLbxjGciUdh4nyWxnD8Jrb9ctkhSkJT7wj83+iPQt3cKDT60LhXy
         0tvcJjpdRE5dEQB/Rh1dyVcPFKzsHOenIXTh+W9veiIN5V3+nKvSa5oyfpzUbGDo3bN7
         mgIsP2xBYc5xasQ9l9D/K/nqKQLjstTfmcXagLBSp4RpgA3tlIWp2uqLhhemskF9xtlu
         /a3CCA4BtyTpaGXDOoVcipq8uIrUDJ7O01iV9WAdPd1fIa5QdLoSFvIKcnT+E58pOWBL
         BqIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVySqQ6XSAOB8LeOoEYAGaF0PvR2x1bGkAL6ohWtiVgTlQaCyOdicD0cvyZ5QCrUjJVo5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLvw39E+UgZ9q/c+sRXFPijv8/TXjlfQaErVjg/QswdcZXwqOE
	BAZ+ZUP4le3DeuHyLxf0HAehRUR0EcnAS/JA7nUl3jeleCMH07AXYQWWWGJAXazxWWN57G8jUIl
	hhEGw+9+9bFVVSfrhl2K0swzBsx6GwXqxioQYWmru
X-Gm-Gg: ASbGncsKuGb7L/gg2Qnv2kM1x5bkpzVc7jjATkJpeXRLYz+qhQ2JbkkExk12rA9hxjb
	sgP7Y5mNrnAt6Ab6Rx7vY7NiR5cqAMeJN0D93ieS4c+SCEzNwpLEO6MZm2BBEa3DI7ZZJPSwX08
	AGhxYgWsFn68c422KeZW6neMRpKsyz11JOaI2v+vCys7LiprDjOuqUA+m+WJGfSjPzkGbhjRFwK
	LhJfb4h19XyjJpafp1eAsztHDGyWRW4r9vJ
X-Google-Smtp-Source: AGHT+IE9FwjifHjYqEr8O9QVsg2ndMEg5anPajj+QeMi7ECPrPoQ3fsIF/+mLMicYUBikti+ripJ0opmTFD6Z8BxmYo=
X-Received: by 2002:a05:622a:305:b0:4b3:7533:c1dd with SMTP id
 d75a77b69052e-4e258d16373mr426881cf.1.1759136722468; Mon, 29 Sep 2025
 02:05:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
In-Reply-To: <20250926163114.2626257-2-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 29 Sep 2025 10:04:46 +0100
X-Gm-Features: AS18NWCOsAQZsJ0pH01KfX0ftLLUaZJXc5t68ACBrAA3mzpfYo09UYNbOtUCHs4
Message-ID: <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Fri, 26 Sept 2025 at 17:31, Sean Christopherson <seanjc@google.com> wrote:
>
> Add a guest_memfd flag to allow userspace to state that the underlying
> memory should be configured to be shared by default, and reject user page
> faults if the guest_memfd instance's memory isn't shared by default.
> Because KVM doesn't yet support in-place private<=>shared conversions, all
> guest_memfd memory effectively follows the default state.
>
> Alternatively, KVM could deduce the default state based on MMAP, which for
> all intents and purposes is what KVM currently does.  However, implicitly
> deriving the default state based on MMAP will result in a messy ABI when
> support for in-place conversions is added.
>
> For x86 CoCo VMs, which don't yet support MMAP, memory is currently private
> by default (otherwise the memory would be unusable).  If MMAP implies
> memory is shared by default, then the default state for CoCo VMs will vary
> based on MMAP, and from userspace's perspective, will change when in-place
> conversion support is added.  I.e. to maintain guest<=>host ABI, userspace
> would need to immediately convert all memory from shared=>private, which
> is both ugly and inefficient.  The inefficiency could be avoided by adding
> a flag to state that memory is _private_ by default, irrespective of MMAP,
> but that would lead to an equally messy and hard to document ABI.
>
> Bite the bullet and immediately add a flag to control the default state so
> that the effective behavior is explicit and straightforward.
>
> Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Fuad Tabba <tabba@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/api.rst                 | 10 ++++++++--
>  include/uapi/linux/kvm.h                       |  3 ++-
>  tools/testing/selftests/kvm/guest_memfd_test.c |  5 +++--
>  virt/kvm/guest_memfd.c                         |  6 +++++-
>  4 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c17a87a0a5ac..4dfe156bbe3c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6415,8 +6415,14 @@ guest_memfd range is not allowed (any number of memory regions can be bound to
>  a single guest_memfd file, but the bound ranges must not overlap).
>
>  When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
> -supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
> -enables mmap() and faulting of guest_memfd memory to host userspace.
> +supports GUEST_MEMFD_FLAG_MMAP and  GUEST_MEMFD_FLAG_DEFAULT_SHARED.  Setting

There's an extra space between `and` and `GUEST_MEMFD_FLAG_DEFAULT_SHARED`.

> +the MMAP flag on guest_memfd creation enables mmap() and faulting of guest_memfd
> +memory to host userspace (so long as the memory is currently shared).  Setting
> +DEFAULT_SHARED makes all guest_memfd memory shared by default (versus private
> +by default).  Note!  Because KVM doesn't yet support in-place private<=>shared
> +conversions, DEFAULT_SHARED must be specified in order to fault memory into
> +userspace page tables.  This limitation will go away when in-place conversions
> +are supported.

I think that a more accurate (and future proof) description of the
mmap flag could be something along the lines of:

+ Setting GUEST_MEMFD_FLAG_MMAP enables using mmap() on the file descriptor.

+ Setting GUEST_MEMFD_FLAG_DEFAULT_SHARED makes all memory in the file shared
+ by default, as opposed to private. Shared memory can be faulted into host
+ userspace page tables. Private memory cannot.

>  When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>  guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6efa98a57ec1..38a2c083b6aa 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1599,7 +1599,8 @@ struct kvm_memory_attributes {
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>
>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> -#define GUEST_MEMFD_FLAG_MMAP  (1ULL << 0)
> +#define GUEST_MEMFD_FLAG_MMAP          (1ULL << 0)
> +#define GUEST_MEMFD_FLAG_DEFAULT_SHARED        (1ULL << 1)
>
>  struct kvm_create_guest_memfd {
>         __u64 size;
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index b3ca6737f304..81b11a958c7a 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -274,7 +274,7 @@ static void test_guest_memfd(unsigned long vm_type)
>         vm = vm_create_barebones_type(vm_type);
>
>         if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> -               flags |= GUEST_MEMFD_FLAG_MMAP;
> +               flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>
>         test_create_guest_memfd_multiple(vm);
>         test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
> @@ -337,7 +337,8 @@ static void test_guest_memfd_guest(void)
>                     "Default VM type should always support guest_memfd mmap()");
>
>         size = vm->page_size;
> -       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
> +       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
> +                                            GUEST_MEMFD_FLAG_DEFAULT_SHARED);
>         vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
>
>         mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 08a6bc7d25b6..19f05a45be04 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -328,6 +328,9 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>         if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>                 return VM_FAULT_SIGBUS;
>
> +       if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_DEFAULT_SHARED))
> +               return VM_FAULT_SIGBUS;
> +
>         folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>         if (IS_ERR(folio)) {
>                 int err = PTR_ERR(folio);
> @@ -525,7 +528,8 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>         u64 valid_flags = 0;
>
>         if (kvm_arch_supports_gmem_mmap(kvm))
> -               valid_flags |= GUEST_MEMFD_FLAG_MMAP;
> +               valid_flags |= GUEST_MEMFD_FLAG_MMAP |
> +                              GUEST_MEMFD_FLAG_DEFAULT_SHARED;

At least for now, GUEST_MEMFD_FLAG_DEFAULT_SHARED and
GUEST_MEMFD_FLAG_MMAP don't make sense without each other. Is it worth
checking for that, at least until we have in-place conversion? Having
only GUEST_MEMFD_FLAG_DEFAULT_SHARED set, but GUEST_MEMFD_FLAG_MMAP,
isn't a useful combination.

That said, these are all nits, I'll leave it to you. With that:

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



>
>         if (flags & ~valid_flags)
>                 return -EINVAL;
> --
> 2.51.0.536.g15c5d4f767-goog
>

