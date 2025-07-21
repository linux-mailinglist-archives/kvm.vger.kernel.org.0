Return-Path: <kvm+bounces-53016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3865EB0C9B8
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 19:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D1B017ABFF
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71CB2E11D6;
	Mon, 21 Jul 2025 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IqBEV0zu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A6729E0F4
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753119102; cv=none; b=PnNN4pOtM4K/NP7eFKccPrBPt2psFVi6Bqwm7v3cE+W6OGHyrWvzuihGBVcamwDomCBgCWRrCMpfNF5KbPD6mQR4vZaS348HKt0HsPUdeI4RV0flocoVCCac/6BylWqSzRPQytkwsfXKUB3jKTmcl6voyZ/kMHH/gYcDeDn/JaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753119102; c=relaxed/simple;
	bh=dkm0lyEKR/hUProV5PxXFoXmxP1JWKqe20DkCmt225w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fHLh855w0eppLVJWe99bRB5tOBKBxBwPJYc6CN5qsq8HYBk2NY6xuM+tPKBMW9vE7xhO8ZsFj1biBY0W56G0GXhLx7anSmWgDjOXuf5dpSNdmwHhi33sKeS0MG++VSGiqr4Wvdthgwgj/8J4LwNqjY/FXK1yseu0D+Wf+MTU4hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IqBEV0zu; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c00e965d0so2853613a12.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 10:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753119101; x=1753723901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RSln/MKxaz6pbnhToBUcsd5CJU17vyymHtLzt6u7vIs=;
        b=IqBEV0zuKz/Hwt6LbhObCE9+fQfa9NcbWxhbTuGLke7OFI5UlXdDeAiro6F3fZP6e+
         5UuQ0LpHPA43VOsbF5Px63SkiRIyeISXtzEEDHgZ3wKVU8CI61uyEkJcJUkOIiyiwoFt
         AawrEnvkeCOR2FXPkZIPtHQjg1Ef1CRILZk3hSPvcMnBqh4FSRFNw5MJs412ICXW4Q/c
         vOtngEm5kSo4uIURHgIQzWdJnH7mAkbwf3sbzcNDrNaZoRkc4fGabIYW0e953Uy0UuZN
         GSQZWknlI2v7RImnQiMBPLrosmMx4QTooYiZX4qGct3gkXkznq2tnFFPnpWHrUqmkd3t
         lASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753119101; x=1753723901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSln/MKxaz6pbnhToBUcsd5CJU17vyymHtLzt6u7vIs=;
        b=bPxxyqWeOO2E5mjJM/rrjexaE13ANECKoK4z5V1cprAR9jZ31AvuERYnTdzH3Jnosd
         pZodrEeXoBRFQhpfoO2xAVRtU9gIIPa2PK0vibPyq3KDeauf4Wkc1rdn4DP1qGW7pKtE
         MrVjM1yIbjf9TilNhGZ9enhhRF96M8r+/Vvvu3LrxB1Nyzmlrdm8A3tL97ZFihLOpgpq
         ouI8zgPgSNP3njNhrIFQicOIqE7mxQ+yOkwmEisCQrrxgTZYbcSRWDRz3lJffBrcol5b
         fHdhhSR8qqHA84R3YdbHVkuLC++z/aGh58KyILhvP9SdgsJPjxhEeXgxARteyZNUKvRX
         OeaQ==
X-Gm-Message-State: AOJu0YzKUL/d+V3rknRW2p9yy8v8QvS0dtP1APwpnwFryhUQ6wQ1fHFq
	nE3H6/vhzOdRN2eOwtfC/9lQljd0eJ5m8JSJUaQJJ1cvpkKs4OuC4r8UcrPAiBrf67FWtsCDNuE
	n806XEg==
X-Google-Smtp-Source: AGHT+IHKvmg6wx/J1JbCtyV7n/8+lPoe0UGP9o7wTaBYQtOLo2cMF1vbrd7+a3IA2/sXmgwXQiNECYqTZBw=
X-Received: from pjtu4.prod.google.com ([2002:a17:90a:c884:b0:313:1c10:3595])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d00b:b0:312:639:a06a
 with SMTP id 98e67ed59e1d1-31c9e79383bmr30253550a91.31.1753119100498; Mon, 21
 Jul 2025 10:31:40 -0700 (PDT)
Date: Mon, 21 Jul 2025 10:31:38 -0700
In-Reply-To: <20250717162731.446579-20-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-20-tabba@google.com>
Message-ID: <aH55ehVij1_dzZWO@google.com>
Subject: Re: [PATCH v15 19/21] KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Fuad Tabba wrote:
> Introduce the new KVM capability KVM_CAP_GMEM_MMAP. This capability
> signals to userspace that a KVM instance supports host userspace mapping
> of guest_memfd-backed memory.
> 
> The availability of this capability is determined per architecture, and
> its enablement for a specific guest_memfd instance is controlled by the
> GUEST_MEMFD_FLAG_MMAP flag at creation time.
> 
> Update the KVM API documentation to detail the KVM_CAP_GMEM_MMAP
> capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
> information regarding support for mmap in guest_memfd.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 9 +++++++++
>  include/uapi/linux/kvm.h       | 1 +
>  virt/kvm/kvm_main.c            | 4 ++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 43ed57e048a8..5169066b53b2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6407,6 +6407,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
>  guest_memfd range is not allowed (any number of memory regions can be bound to
>  a single guest_memfd file, but the bound ranges must not overlap).
>  
> +When the capability KVM_CAP_GMEM_MMAP is supported, the 'flags' field supports
> +GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation enables mmap()
> +and faulting of guest_memfd memory to host userspace.
> +
> +When the KVM MMU performs a PFN lookup to service a guest fault and the backing
> +guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> +consumed from guest_memfd, regardless of whether it is a shared or a private
> +fault.
> +
>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>  
>  4.143 KVM_PRE_FAULT_MEMORY
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3beafbf306af..698dd407980f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -960,6 +960,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_EL2 240
>  #define KVM_CAP_ARM_EL2_E2H0 241
>  #define KVM_CAP_RISCV_MP_STATE_RESET 242
> +#define KVM_CAP_GMEM_MMAP 243

KVM_CAP_GUEST_MEMFD_MMAP please.  I definitely don't want "gmem" in any of the
uAPI.

>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 46bddac1dacd..f1ac872e01e9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4916,6 +4916,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #ifdef CONFIG_KVM_GMEM
>  	case KVM_CAP_GUEST_MEMFD:
>  		return !kvm || kvm_arch_supports_gmem(kvm);
> +#endif
> +#ifdef CONFIG_KVM_GMEM_SUPPORTS_MMAP
> +	case KVM_CAP_GMEM_MMAP:

As alluded to in my feedback in patch 2, this should be inside CONFIG_KVM_GUEST_MEMFD.

> +		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
>  #endif
>  	default:
>  		break;
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

