Return-Path: <kvm+bounces-55050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 014E0B2CF84
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 00:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A20B01659B4
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 22:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3181239567;
	Tue, 19 Aug 2025 22:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IX2XLVyF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47E81E835D
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 22:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755643861; cv=none; b=GuvwCyKi8YfULAwXzSKWVvTkUdeTH+eyUjGw057zlC0/DDFys/sgCZvXwEljGpcQnvhyFNu0S7IOWyql1IlL4DjvpkzaxkHI5wTNKi5jNTZUuHtUdGGTY5hm9FQ//6Cv6vv0Z7fshsteXKuhZtg7TENudOcXo44moDgD3DLPYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755643861; c=relaxed/simple;
	bh=O/G2r3Y2Ig0ObvWmkHM8QHVdbOy+ELCW90Ohvv9YlWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XMKYY6GSLl2wy3gGR20cDobiKt/MFAWlnvRoPw8lH3L3Uu6Tz5Gwc+yT8lME8F1Q+6MF1eghJEBALa/Mv8C2BMoPLvY6W8h0/MXO5sWgKydJdhm1EgEI0hGLpiDnd8mQxFDh2aMZmhLlWMv3MJhFIC7A20hcf3bycNbBJpS4VkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IX2XLVyF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174c65b0so11438229a12.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 15:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755643859; x=1756248659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8F1d8ensmdynhKAiK090uPNzvX61uCn7sQals2duC9I=;
        b=IX2XLVyFtXgMKIGdEPmi4xcZ7l+5T0cNE5TTOPa7zcLFYKDzxVGaCGLy01XcSg3ARS
         QNClBjci/CVS42mU6ZWu56tP23R/ZEq7+22/4E4SQ+ZS52y5e7D4CDi6gi2ZL+Dscf3G
         VFWBLd12ZdSYInZVxFiE/hDPZyCU1Ke8n/y6rSQsrMYF3o3yI7WzQ319YfUt9nAODQzx
         q5zV5D5e8yn2rXYd+DFcCrOxd9W15fG6JXpzQ8cDkUa7QPKb5v1+IzcunTrJUXbO+L1n
         qWucDkQiQrkX41t5rEGTLnar9b25Kj+ECumYEegH6ie6/UL2cRcKkQ82qSVxz/anLMMQ
         yATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755643859; x=1756248659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8F1d8ensmdynhKAiK090uPNzvX61uCn7sQals2duC9I=;
        b=vsZ1p2yIbBgoJ4Gvjz0AG/NwBt4AjdGrCnGQ7gh/FxTiU/DbxnQPo1IUTlDIaUDRnL
         xJyI1qmm3J7oszsqIk6wu7Oyz3O8SVYK7+hRmOO5YPzv7hsLaQ10rt+B9WaqgMcYNmjZ
         dgo+rbrYXiwNYSJwNWxzrcIME206zvhiivQQS8bF+auz4zdz6H7SZyNUnv9/Kf283pLQ
         LZsy/QFF4KBZNAoR5QqpqU2FVX/NfRad5mkbK1bW3nfOELpqljt1IOOhtlJ3AfpcRc4B
         57plbG1d34bMovRDv0g+9uOuBPdeg7pb8g6vcaexQ+NUl7TKOPuEvedO6bJGyP/DMZFG
         uTBg==
X-Forwarded-Encrypted: i=1; AJvYcCU29DZ7nwNeUawhCPdKcMajOMsfUSq9trH79V9SbhTeWENR+G6VJW3sL4vThdCMpLuCMeg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaUjZ9MtgzapTqEoIM8rTG2kHA+srxycS+Kgo9Y5zGLv0gjoGt
	gqbXamDUk0P3jMH5bPuUJj+FiQaBjuGGsuEB1EWBns8rp/rLhLxkk4ddX8HhbJ37QENzwM9BnnL
	1Nd2IsQ==
X-Google-Smtp-Source: AGHT+IH8Dtk11/iXlRV2JDXYmRPBJjQyOw0TtR1krn5nmzHVB9u9lIPp4DhpJM9xf0qfXKszXE3zpw15jWU=
X-Received: from pjbso3.prod.google.com ([2002:a17:90b:1f83:b0:31f:1707:80f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c7:b0:31e:f3b7:49d2
 with SMTP id 98e67ed59e1d1-324e1178297mr1156941a91.0.1755643859135; Tue, 19
 Aug 2025 15:50:59 -0700 (PDT)
Date: Tue, 19 Aug 2025 15:50:57 -0700
In-Reply-To: <aJ87AGnK9J0mafoi@LAPTOP-I1KNRUTF.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com> <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
 <87o6tttliq.fsf@redhat.com> <aHWjPSIdp5B-2UBl@google.com> <87tt2nm6ie.fsf@redhat.com>
 <aJE9x_pjBVIdiEJN@google.com> <ce7ef1f0-c098-4669-85f3-b6ebb437a568@linux.microsoft.com>
 <aJKW9gTeyh0-pvcg@google.com> <aJ87AGnK9J0mafoi@LAPTOP-I1KNRUTF.localdomain>
Message-ID: <aKT_0Zuj2MBRrh6p@google.com>
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB flushes
From: Sean Christopherson <seanjc@google.com>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, alanjiang@microsoft.com, 
	chinang.ma@microsoft.com, andrea.pellegrini@microsoft.com, 
	Kevin Tian <kevin.tian@intel.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 15, 2025, Jeremi Piotrowski wrote:
> On Tue, Aug 05, 2025 at 04:42:46PM -0700, Sean Christopherson wrote:
> I started working on extending patch 5, wanted to post it here to make sure I'm
> on the right track.
> 
> It works in testing so far and shows promising performance - it gets rid of all
> the pathological cases I saw before.

Nice :-)

> I haven't checked whether I broke SVM yet, and I need figure out a way to
> always keep the cpumask "offstack" so that we don't blow up every struct
> kvm_mmu_page instance with an inline cpumask - it needs to stay optional.

Doh, I meant to include an idea or two for this in my earlier response.  /The
best I can come up with is 

> I also came across kvm_mmu_is_dummy_root(), that check is included in
> root_to_sp(). Can you think of any other checks that we might need to handle?

Don't think so?

> @@ -3827,6 +3829,9 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>  	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
>  	++sp->root_count;
>  
> +	if (level >= PT64_ROOT_4LEVEL)

Was this my code?  If so, we should move this into the VMX code, because the fact
that PAE roots can be ignored is really a detail of nested EPT, not the overall
sceheme.

> +		kvm_x86_call(alloc_root_cpu_mask)(sp);

Ah shoot.  Allocating here won't work, because mmu_lock is held and allocating
might sleep.  I don't want to force an atomic allocation, because that can dip
into pools that KVM really shouldn't use.

The "standard" way KVM deals with this is to utilize a kvm_mmu_memory_cache.  If
we do that and add e.g kvm_vcpu_arch.mmu_roots_flushed_cache, then we trivially
do the allocation in mmu_topup_memory_caches().  That would eliminate the error
handling in vmx_alloc_root_cpu_mask(), and might make it slightly less awful to
deal with the "offstack" cpumask.

Hmm, and then instead of calling into VMX to do the allocation, maybe just have
a flag to communicate that vendor code wants per-root flush tracking?  I haven't
thought hard about SVM, but I wouldn't be surprised if SVM ends up wanting the
same functionality after we switch to per-vCPU ASIDs.

> +
>  	return __pa(sp->spt);
>  }

...

> @@ -3307,22 +3309,34 @@ void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  	vpid_sync_context(vmx_get_current_vpid(vcpu));
>  }
>  
> -static void __vmx_flush_ept_on_pcpu_migration(hpa_t root_hpa)
> +void vmx_alloc_root_cpu_mask(struct kvm_mmu_page *root)
>  {

This should be conditioned on enable_ept.

> +	WARN_ON_ONCE(!zalloc_cpumask_var(&root->cpu_flushed_mask,
> +					GFP_KERNEL_ACCOUNT));
> +}
> +
> +static void __vmx_flush_ept_on_pcpu_migration(hpa_t root_hpa, int cpu)
> +{
> +	struct kvm_mmu_page *root;
> +
>  	if (!VALID_PAGE(root_hpa))
>  		return;
>  
> +	root = root_to_sp(root_hpa);
> +	if (!root || cpumask_test_and_set_cpu(cpu, root->cpu_flushed_mask))

Hmm, this should flush if "root" is NULL, because the aforementioned "special"
roots don't have a shadow page.

But unless I'm missing an edge case (of an edge case), this particular code can
WARN_ON_ONCE() since EPT should never need to use any of the special roots.  We
might need to filter out dummy roots somewhere to avoid false positives, but that
should be easy enough.

For the mask, it's probably worth splitting test_and_set into separate operations,
as the common case will likely be that the root has been used on this pCPU.  The
test_and_set version will generate a LOCK BTS instruction, and so for the common
case where the bit is already set, KVM will generate an atomic access, which can
cause noise/bottlenecks 

E.g.

	if (WARN_ON_ONCE(!root))
		goto flush;

	if (cpumask_test_cpu(cpu, root->cpu_flushed_mask))
		return;

	cpumask_set_cpu(cpu, root->cpu_flushed_mask);

flush:
	vmx_flush_tlb_ept_root(root_hpa);

> +		return;
> +
>  	vmx_flush_tlb_ept_root(root_hpa);
>  }
>  
> -static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu)
> +static void vmx_flush_ept_on_pcpu_migration(struct kvm_mmu *mmu, int cpu)
>  {
>  	int i;
>  
> -	__vmx_flush_ept_on_pcpu_migration(mmu->root.hpa);
> +	__vmx_flush_ept_on_pcpu_migration(mmu->root.hpa, cpu);
>  
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> -		__vmx_flush_ept_on_pcpu_migration(mmu->prev_roots[i].hpa);
> +		__vmx_flush_ept_on_pcpu_migration(mmu->prev_roots[i].hpa, cpu);
>  }
>  
>  void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b4596f651232..4406d53e6ebe 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -84,6 +84,7 @@ void vmx_flush_tlb_all(struct kvm_vcpu *vcpu);
>  void vmx_flush_tlb_current(struct kvm_vcpu *vcpu);
>  void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr);
>  void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu);
> +void vmx_alloc_root_cpu_mask(struct kvm_mmu_page *root);
>  void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
>  u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu);
>  void vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall);
> -- 
> 2.39.5
> 


