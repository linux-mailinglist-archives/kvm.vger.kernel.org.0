Return-Path: <kvm+bounces-53928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B19B1A6A7
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 17:54:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD92C160E6B
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7EB721A43D;
	Mon,  4 Aug 2025 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBUnxxf/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EA5218AAF
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754322577; cv=none; b=N4k/iIg/QbQRYM7UWsIWsI8+x1KfZQEmXoGARFOwzQug44WA1PoRtv44SIngivUnWtLtPQSqiT3SaBTAKaMXq7T1ZttXAEKfjgfw7OhLtkYivm3FxzNSFv3/mAn+adzQozPNifI9zBcPr3p/dLqR+SxNmZimt1xIeT/umesCT2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754322577; c=relaxed/simple;
	bh=fgQf3AzdPQXO0jCjF1Jj/luAySkWXiCqRjmQm+Hbd2Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=u0RR4vsfbD9ozFQeFwd8lBGgtymSYytnKrz6SWYpjJ88s1VySpB54F6tCFHUkMc7R0jn0dmJqFpNlMwe1whZ9F8hHZTt/r5K0pBYEizjFOzoKLlbjrjW/aII9HlWtzDQZZ2ntxDaL3PakaHGuMPGwPhjfr99dyHnWwE5Iok2Tvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBUnxxf/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754322574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mp91VSTUj4He/K83QIVxaDFmWFwOZixH7dnV0delk0Y=;
	b=eBUnxxf/CZ35uXyaCh4VXifA3tqTOfLU9HbsAih+3Eu9ZivhaO5/IUUEC/ZmGr57wI1TEl
	iX71MFDpv+NKyCzBxEJakP1Nysg2bchndV431zpjzNzKDINb6nNacHzAbQshQLzc+lXBd9
	qFTxMm9yDJUIZWTm8UBPARf7m7RHQwo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-EI4FJxT-OdOZFadyHrviFw-1; Mon, 04 Aug 2025 11:49:33 -0400
X-MC-Unique: EI4FJxT-OdOZFadyHrviFw-1
X-Mimecast-MFC-AGG-ID: EI4FJxT-OdOZFadyHrviFw_1754322572
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451d3f03b74so24244605e9.3
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 08:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322572; x=1754927372;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mp91VSTUj4He/K83QIVxaDFmWFwOZixH7dnV0delk0Y=;
        b=g57lkkXzxAuGwy8WD4T9TLeDJdCtMGMQBbumCuOat0TsExzzkvigM3pfkmjpx9SeQ3
         3idJc76sFMk81BAoTvW0tNBUI/fH6w6u9yX1Cp+g5tqrgz0rf+rIuoZbpC7Mia8Vpssj
         6ONwI1xN0GkbkaiZ5ByLp+CVYEH4/wbvxSS0RZS2WGE/ML7+ROsvV+39JV7KQ2TYlPDh
         ZMfvwzwjFyWr0HfrVbTJhpD1YeAeNFml5rvBQdMV6/ucEVAsrfnYCka25y1pGLqN3OKk
         sVQ6EbA9QgcS5B6Ze7AyZw7eUYcTjX9Fv2pXpr9Oy3FlAYEzS5WQlAI8z6GrV4hwlsU2
         2yiA==
X-Forwarded-Encrypted: i=1; AJvYcCVbXeckqUunios4Avz4chny7zuvjKghLuEvxvZ2JAWygioVMFH/U6WNlPNGXFKvAz6y7f8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy754SD+n1Aj7zwNztW0K6S186BGZWIQTx2z6AqhKOw2O+lU5wY
	fel1f5qp8Ah5DXBNUiwXMvbw8l+pDquMHzCojZHGbIej5RHYQYEKD+YgdPy3iD+KjJSGfDweleT
	7jOey0lDgk72jJvDSbYHGSsbyBz1RbVq7ZKQL1aHMvWhKWf/S7bWB9j2eyjL8Sf5YKSAosHxeN9
	bzP77pKtI5USf+S9ZjzsTb8ZxTqFd2a+hZuMJmt0AA
X-Gm-Gg: ASbGncvMJ59y47yDRn96QPoQuxvHqTioLrjAvU2E3mvQ/fRxQTu97PXtpc9+Vy9C2a/
	SOnzOBpa6CnjufolnIQk7lefiy1TpjjFPGmXvywmfNjVCXGuTta9GKgW6HFKxN3rfBVqMpzKoMa
	0oYfnT/kOaMG9j2FdSlUXQcAU/jpiw/yZd0zTPoVzabmtCod6Vimp8yAoFxaYOplYEKOdpHdWmj
	Y9VzPXT06nqcd2N/nLVfOOqKcEYUyUHKgVfPndNcOUGLVmKyUaeb8yUGMf68OpI8lHqzJHjvjxj
	U6HpQIzZMJZ+owLhp3zAbsW15JwivJ76wHk=
X-Received: by 2002:a5d:5d0e:0:b0:3b7:8525:e9cc with SMTP id ffacd0b85a97d-3b8d9474b30mr6851039f8f.18.1754322572352;
        Mon, 04 Aug 2025 08:49:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIjQYt8kn5K1KiyZc+opRlRMeQATeYuM04IBXVfIUgbfBca8ACZBnnd7veGeB9S3HxGg9o9w==
X-Received: by 2002:a5d:5d0e:0:b0:3b7:8525:e9cc with SMTP id ffacd0b85a97d-3b8d9474b30mr6850997f8f.18.1754322571839;
        Mon, 04 Aug 2025 08:49:31 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459c58ed07fsm65384015e9.22.2025.08.04.08.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:49:31 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 alanjiang@microsoft.com, chinang.ma@microsoft.com,
 andrea.pellegrini@microsoft.com, Kevin Tian <kevin.tian@intel.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 linux-hyperv@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB
 flushes
In-Reply-To: <aHWjPSIdp5B-2UBl@google.com>
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
 <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com>
 <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
 <87o6tttliq.fsf@redhat.com> <aHWjPSIdp5B-2UBl@google.com>
Date: Mon, 04 Aug 2025 17:49:29 +0200
Message-ID: <87tt2nm6ie.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

...

>
> It'll take more work than the below, e.g. to have VMX's construct_eptp() pull the
> level and A/D bits from kvm_mmu_page (vendor code can get at the kvm_mmu_page with
> root_to_sp()), but for the core concept/skeleton, I think this is it?
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e838cb6c9e1..298130445182 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3839,6 +3839,37 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
>  
> +struct kvm_tlb_flush_root {
> +       struct kvm *kvm;
> +       hpa_t root;
> +};
> +
> +static void kvm_flush_tlb_root(void *__data)
> +{
> +       struct kvm_tlb_flush_root *data = __data;
> +
> +       kvm_x86_call(flush_tlb_root)(data->kvm, data->root);
> +}
> +
> +void kvm_mmu_flush_all_tlbs_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{
> +       struct kvm_tlb_flush_root data = {
> +               .kvm = kvm,
> +               .root = __pa(root->spt),
> +       };
> +
> +       /*
> +        * Flush any TLB entries for the new root, the provenance of the root
> +        * is unknown.  Even if KVM ensures there are no stale TLB entries
> +        * for a freed root, in theory another hypervisor could have left
> +        * stale entries.  Flushing on alloc also allows KVM to skip the TLB
> +        * flush when freeing a root (see kvm_tdp_mmu_put_root()), and flushing
> +        * TLBs on all CPUs allows KVM to elide TLB flushes when a vCPU is
> +        * migrated to a different pCPU.
> +        */
> +       on_each_cpu(kvm_flush_tlb_root, &data, 1);

Would it make sense to complement this with e.g. a CPU mask tracking all
the pCPUs where the VM has ever been seen running (+ a flush when a new
one is added to it)?

I'm worried about the potential performance impact for a case when a
huge host is running a lot of small VMs in 'partitioning' mode
(i.e. when all vCPUs are pinned). Additionally, this may have a negative
impact on RT use-cases where each unnecessary interruption can be seen
problematic. 

> +}
> +
>  static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>                             u8 level)
>  {
> @@ -3852,7 +3883,8 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>         WARN_ON_ONCE(role.direct && role.has_4_byte_gpte);
>  
>         sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
> -       ++sp->root_count;
> +       if (!sp->root_count++)
> +               kvm_mmu_flush_all_tlbs_root(vcpu->kvm, sp);
>  
>         return __pa(sp->spt);
>  }
> @@ -5961,15 +5993,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>         kvm_mmu_sync_roots(vcpu);
>  
>         kvm_mmu_load_pgd(vcpu);
> -
> -       /*
> -        * Flush any TLB entries for the new root, the provenance of the root
> -        * is unknown.  Even if KVM ensures there are no stale TLB entries
> -        * for a freed root, in theory another hypervisor could have left
> -        * stale entries.  Flushing on alloc also allows KVM to skip the TLB
> -        * flush when freeing a root (see kvm_tdp_mmu_put_root()).
> -        */
> -       kvm_x86_call(flush_tlb_current)(vcpu);
>  out:
>         return r;
>  }
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 65f3c89d7c5d..3cbf0d612f5e 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -167,6 +167,8 @@ static inline bool is_mirror_sp(const struct kvm_mmu_page *sp)
>         return sp->role.is_mirror;
>  }
>  
> +void kvm_mmu_flush_all_tlbs_root(struct kvm *kvm, struct kvm_mmu_page *root);
> +
>  static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  {
>         /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7f3d7229b2c1..3ff36d09b4fa 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -302,6 +302,7 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
>          */
>         refcount_set(&root->tdp_mmu_root_count, 2);
>         list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
> +       kvm_mmu_flush_all_tlbs_root(vcpu->kvm, root);
>  
>  out_spin_unlock:
>         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>

-- 
Vitaly


