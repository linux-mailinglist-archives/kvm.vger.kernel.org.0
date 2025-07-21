Return-Path: <kvm+bounces-53009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D83B0C90B
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 18:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDC425435CF
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DE22D949E;
	Mon, 21 Jul 2025 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mJbSP07v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77D2E03E0
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753116276; cv=none; b=gBUITGag0dImn+tdW0kx4rsoL/lAra0BWShux0OrpShq3cF3v7sGBOU9YRW8RcxIvRHNMflbY3isheIRvEk8Ph7T99ERcQGqgYEM4x8JMsN+l5t0WoI8eAc0LHIaQHohsZ5Fk/84enSvgDuTpaIYaYHGHkVBwuQosaHkGBCOi10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753116276; c=relaxed/simple;
	bh=dxma/JmZ6o/YZ5FlfOynVEJl94kUhfodB6bptkyLfbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LpYBGjPuSmqprleuYjQwizgLm0cW556YsPdOJA2bb65eFJlwSFt/cJjjMX6stdbi73YjVKMokAnjd74j57FaPQw8H8GougxCLPYWx2qVI8FGzoybmbB1Tvrih62gfSZEKg/cibvoKwGuqCglL9UCCFVNy0WS1Ioz7yg+OoBHfeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mJbSP07v; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so6713883a91.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 09:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753116274; x=1753721074; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4x9weyqk5iszgR+emVch9BaS5KFFqt0IQ3wLvBJxPdc=;
        b=mJbSP07vWDHkA8I0Xm83rjOQDBDuEP014vJWujiOhP+vWqAV/92oQtOOEUqIKH8rM2
         GZt/4f8SkRbypmlHpV1K/eZMQAvWMpP8vXXMLI/inqmbpcPzMxjW0rtIpLFOah7dKSJS
         uD6rPUSfqjCMEiyWCZ2zmDhVNNIgfipXsTor2j9ctHCafQSif6b42A1D2debLuIGycZs
         dQ4Q93MB8liTm9EPJyqzaI2hmp5TG+jC95ypOl4f4JVCxTrGNCceNQzmSPL0AOZu+Sws
         540SYM67aiNNwCSyahQZaEsjwmw8UwVy/Qr+pTpzgj2ElgI5xbIjMYcMbcXeEEYQIEAY
         NuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753116274; x=1753721074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4x9weyqk5iszgR+emVch9BaS5KFFqt0IQ3wLvBJxPdc=;
        b=KYVl4hxTNeaM9mLIqkMm6zR6tcg06fPGwvHL1U6fk29u8a2BolL0huFG0sWRvBMN7D
         Bto/g7bCPryiTXHLOMR4f7U0bbNKeTvRzc2loGkXIsgGbLhbFLJSAd6FJSm2QE98qaZh
         v6b6ok1Qf6bBkIzsYobsyhVxO+WoEwwglk5w24q+vz/VaxS2DBgp8bTIS5RXl0lHqwhy
         zYHzj43pDThFwHG/Jj2p0N/1cbeWXM2zMkG7r3J1Pq8dYkZt5afRi2+r6wOKuvHuUZhV
         7QXI7iogrY76hSUpcwmUqERaeGDlKju7xeVJRwKFcYbJNTsQyNluHDToDZ2zc5Y0UOpk
         8JiA==
X-Gm-Message-State: AOJu0YwtXKtbxO9hqalOs5IA8eWfL3dkvxvJ7pqwqx7dg74eVs07MeBB
	q8RPCs0O5Tomt2tRwvDzLzMQYw933P74bHfrigja+e8RjXdLTQqSZm9mLP3rt6OeviC2WaSaik9
	907WIVA==
X-Google-Smtp-Source: AGHT+IHLtmM9b2ohCo6v8xL5lzq5k6sLkOhmrbwVm3iSaR1J0L8EXLNkJNiYHZYz68JZXhiAQifqzelMv8o=
X-Received: from pjk13.prod.google.com ([2002:a17:90b:558d:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d00c:b0:311:c1ec:7d05
 with SMTP id 98e67ed59e1d1-31caf92238dmr25136631a91.35.1753116274516; Mon, 21
 Jul 2025 09:44:34 -0700 (PDT)
Date: Mon, 21 Jul 2025 09:44:33 -0700
In-Reply-To: <20250717162731.446579-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-4-tabba@google.com>
Message-ID: <aH5ucRmtSjzJcaxf@google.com>
Subject: Re: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
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
> Introduce kvm_arch_supports_gmem() to explicitly indicate whether an
> architecture supports guest_memfd.
> 
> Previously, kvm_arch_has_private_mem() was used to check for guest_memfd
> support. However, this conflated guest_memfd with "private" memory,
> implying that guest_memfd was exclusively for CoCo VMs or other private
> memory use cases.
> 
> With the expansion of guest_memfd to support non-private memory, such as
> shared host mappings, it is necessary to decouple these concepts. The
> new kvm_arch_supports_gmem() function provides a clear way to check for
> guest_memfd support.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++-
>  include/linux/kvm_host.h        | 11 +++++++++++
>  virt/kvm/kvm_main.c             |  4 ++--
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index acb25f935d84..bde811b2d303 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2277,8 +2277,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  #ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)

Don't support/use macros, just make kvm_arch_supports_gmem() a "normal" arch hook.
kvm_arch_has_private_mem() is a macro so that kvm_arch_nr_memslot_as_ids() can
resolve to a compile-time constant when CONFIG_KVM_GMEM is false, and so that it's
a trivial check when true.

kvm_arch_supports_gmem() is only ever used in slow paths, check_memory_region_flags()
and kvm_vm_ioctl_check_extension_generic().  Of course, after my suggestions from
patch 2, it goes away completely.

>  #else
>  #define kvm_arch_has_private_mem(kvm) false
> +#define kvm_arch_supports_gmem(kvm) false

This is silly.  It adds code to x86 *and* makes the generic code more complex.
Again, a moot point in the end, but for future reference this isn't a pattern we
should encourage.

