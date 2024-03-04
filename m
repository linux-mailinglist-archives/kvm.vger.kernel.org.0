Return-Path: <kvm+bounces-10817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F808708C9
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 18:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5BA81C22EF2
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 17:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8004961691;
	Mon,  4 Mar 2024 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OOiqjkmC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9196167A
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709574910; cv=none; b=cmHfmuicEF7dRk1bHT9ymE/7wz58nGE0xwqioxfij05O5EW2OD96M2kkA6yhhvaOC2eXtuKlQbTjjAukrCCBjFoYvHp8MtscIIuVMe6dP3rKxrVzsfjvaJjZb0EqDatpEa3OzZZiCRVDY+sG9E3lnfjpnwAE03XPOstzmKfO8uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709574910; c=relaxed/simple;
	bh=vQrzAyvnO9cTC2zo0TDeRdPOpjiKgnZgYt5AOEExxRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QUCLcptszYkdtxyQv3O8mkci3obr0CTkqDUotRuDc2kxKrZ+h1IlNGjK2/BBOITiiEWfBubv8wpibxpr5rAwybEd9mfACW5DxvwprU8/doBpdi0HWXVy3r3EEAHgfWTqqDcHofjUu+UUQv4DNZI8H8lh6o68+pJ1ChzZ6n0+PuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OOiqjkmC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e4e8fae664so3826075b3a.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 09:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709574908; x=1710179708; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=axU4h5sQNk59uPfyb9BlGWg0FQuKd8D22txYUHgqfsk=;
        b=OOiqjkmCSRK/D/lHYAqaBlYjn2eX14KuA/bZvHSQrPXZRdv3CbVKqwse/FFdnYDsTV
         YENP2n/Hvh0XjDMQZ4sWHsRdwweiP0K8ZdKZBSamcUr7ZlpvZ4R2zfHch5byfVIiCXXf
         RyZ9H32DURcO79mX8YSPl5clNu/J5aY/DQ7QCFJj8LE3vF5Gpj93n523Sl1V3bhZ8oHL
         sZ2EGVIeJG8TYUOfy9zaSv5VBVL5hEYKemH7q2oJb7vxG4nZM63kWUdDWZbNsIsUtiNC
         yC9pVgXUTxQWqb5rHHeKkMQTYzVG661wpK6YYR7z4Dtifi3FKvwsGE+mHDVH7IfFZ6WC
         lAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709574908; x=1710179708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=axU4h5sQNk59uPfyb9BlGWg0FQuKd8D22txYUHgqfsk=;
        b=eq+fXuQ9d/HgV4IXDzxWREsyMuStuLliL7aN3bpqEFnVkr81CN9tb7wJirKRTbhmv4
         ZkILl+jYUDQGcuHOpaFzRkaFmd9J1pwOp5lZDz2uWM7YIkLL4jRxGY00qLT1rPz1I4Kw
         xDXTKwKsNDdZaAdavi+l0D6N7+c9a//BMbEylVwEYHbADofC+aI6HyTbtJc8ZuaddUC5
         p9EmV1rSeC5bGZ8xDDJzGjcNjbAeuAs9d9aMZ6yzvQvjUQnZQgy4gDmiTlYosIMM9iNz
         x7YA0vs+VtDxTD83amuIDPP8rX8TYzX1v7tsL4jMGptawHZzFxkFHf4vlIO64ZJ7rnez
         hsHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoYm3j42W5deP0QL3axO0veqISQK75uqOW3WHzR+xVPsJ8RhJ4NC2MYbGFyhpvF1cSVjCPUTyuHH5vdO8tHajL0pOa
X-Gm-Message-State: AOJu0Ywm5FWRsH9EL0NIixIi5cWmb1Pr/FVjJLIinSKWqSyJBOv53+3f
	HgUb1ImHbnM2DnVENWPR9sEVSx8NMHb8D3EbAc1MFpeC1+sTqGwSAR8bdTYHiLBzXnYoLdSv0E7
	2zw==
X-Google-Smtp-Source: AGHT+IFg6ysgWmyL1B+R7gMX2anlCJ0cYqu7laChtGAPwU0HnAjkjothNO9Fsa2VNTibZcwGc9svzrcS3uQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d28:b0:6e5:547c:2f82 with SMTP id
 fa40-20020a056a002d2800b006e5547c2f82mr422385pfb.6.1709574907668; Mon, 04 Mar
 2024 09:55:07 -0800 (PST)
Date: Mon, 4 Mar 2024 09:55:06 -0800
In-Reply-To: <1880816055.4545532.1709260250219.JavaMail.zimbra@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1880816055.4545532.1709260250219.JavaMail.zimbra@sjtu.edu.cn>
Message-ID: <ZeYK-hNDQz5cFhre@google.com>
Subject: Re: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: pbonzini@redhat.com, tglx@linutronix.de, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

+Tom

"KVM: SVM:" for the shortlog scope.

On Fri, Mar 01, 2024, Zheyun Shen wrote:
> On AMD CPUs without ensuring cache consistency, each memory page reclamation in
> an SEV guest triggers a call to wbinvd_on_all_cpus, thereby affecting the
> performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest might only
> utilize 8 of these cores. Meanwhile, host can use qemu-affinity to bind these 8 vCPUs
> to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU runs
> can help avoid flushing the cache for all CPUs every time.

This needs an unequivocal statement from AMD that flushing caches only on CPUs
that do VMRUN is sufficient.  That sounds like it should be obviously correct,
as I don't see how else a cache line can be dirtied for the encrypted PA, but
this entire non-coherent caches mess makes me more than a bit paranoid.

> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> ---
>  arch/x86/include/asm/smp.h |  1 +
>  arch/x86/kvm/svm/sev.c     | 28 ++++++++++++++++++++++++----
>  arch/x86/kvm/svm/svm.c     |  4 ++++
>  arch/x86/kvm/svm/svm.h     |  3 +++
>  arch/x86/lib/cache-smp.c   |  7 +++++++
>  5 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 4fab2ed45..19297202b 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -120,6 +120,7 @@ void native_play_dead(void);
>  void play_dead_common(void);
>  void wbinvd_on_cpu(int cpu);
>  int wbinvd_on_all_cpus(void);
> +int wbinvd_on_cpus(struct cpumask *cpumask);

KVM already has an internal helper that does this, see kvm_emulate_wbinvd_noskip().
I'm not necessarily advocating that we keep KVM's internal code, but I don't want
two ways of doing the same thing.

>  void smp_kick_mwait_play_dead(void);
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f760106c3..b6ed9a878 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -215,6 +215,21 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>          sev->misc_cg = NULL;
>  }
>  
> +struct cpumask *sev_get_cpumask(struct kvm *kvm)
> +{
> +        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +        return &sev->cpumask;
> +}
> +
> +void sev_clear_cpumask(struct kvm *kvm)
> +{
> +        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +        cpumask_clear(&sev->cpumask);
> +}
> +
> +

Unnecessary newline.  But I would just delete these helpers.

>  static void sev_decommission(unsigned int handle)
>  {
>          struct sev_data_decommission decommission;
> @@ -255,6 +270,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>          if (unlikely(sev->active))
>                  return ret;
>  
> +        cpumask_clear(&sev->cpumask);

This is unnecessary, the mask is zero allocated.

>          sev->active = true;
>          sev->es_active = argp->id == KVM_SEV_ES_INIT;
>          asid = sev_asid_new(sev);
> @@ -2048,7 +2064,8 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>           * releasing the pages back to the system for use. CLFLUSH will
>           * not do this, so issue a WBINVD.
>           */
> -        wbinvd_on_all_cpus();
> +        wbinvd_on_cpus(sev_get_cpumask(kvm));
> +        sev_clear_cpumask(kvm);

Instead of copy+paste WBINVD+cpumask_clear() everywhere, add a prep patch to
replace relevant open coded calls to wbinvd_on_all_cpus() with calls to
sev_guest_memory_reclaimed().  Then only sev_guest_memory_reclaimed() needs to
updated, and IMO it helps document why KVM is blasting WBINVD.

That's why I recommend deleting sev_get_cpumask() and sev_clear_cpumask(), there
really should only be two places that touch the mask itself: svm

>          __unregister_enc_region_locked(kvm, region);
>  
> @@ -2152,7 +2169,8 @@ void sev_vm_destroy(struct kvm *kvm)
>           * releasing the pages back to the system for use. CLFLUSH will
>           * not do this, so issue a WBINVD.
>           */
> -        wbinvd_on_all_cpus();
> +        wbinvd_on_cpus(sev_get_cpumask(kvm));
> +        sev_clear_cpumask(kvm);
>  
>          /*
>           * if userspace was terminated before unregistering the memory regions
> @@ -2343,7 +2361,8 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>          return;
>  
>  do_wbinvd:
> -        wbinvd_on_all_cpus();
> +        wbinvd_on_cpus(sev_get_cpumask(vcpu->kvm));
> +        sev_clear_cpumask(vcpu->kvm);
>  }
>  
>  void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -2351,7 +2370,8 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>          if (!sev_guest(kvm))
>                  return;
>  
> -        wbinvd_on_all_cpus();
> +        wbinvd_on_cpus(sev_get_cpumask(kvm));
> +        sev_clear_cpumask(kvm);

This is unsafe from a correctness perspective, as sev_guest_memory_reclaimed()
is called without holding any KVM locks.  E.g. if a vCPU runs between blasting
WBINVD and cpumask_clear(), KVM will fail to emit WBINVD on a future reclaim.

Making the mask per-vCPU, a la vcpu->arch.wbinvd_dirty_mask, doesn't solve the
problem as KVM can't take vcpu->mutex in this path (sleeping may not be allowed),
and that would create an unnecessary/unwated bottleneck.

The simplest solution I can think of is to iterate over all possible CPUs using
cpumask_test_and_clear_cpu().

>  }
>  
>  void sev_free_vcpu(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c8..f9bfa6e57 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4107,6 +4107,10 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>  
>          amd_clear_divider();
>  
> +    if (sev_guest(vcpu->kvm))

Use tabs, not spaces.

> +                cpumask_set_cpu(smp_processor_id(), sev_get_cpumask(vcpu->kvm));

This does not need to be in the noinstr region, and it _shouldn't_ be in the
noinstr region.  There's already a handy dandy pre_sev_run() that provides a
convenient location to bury this stuff in SEV specific code.

> +    
>          if (sev_es_guest(vcpu->kvm))
>                  __svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
>          else
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139c..1577e200e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -90,6 +90,7 @@ struct kvm_sev_info {
>          struct list_head mirror_entry; /* Use as a list entry of mirrors */
>          struct misc_cg *misc_cg; /* For misc cgroup accounting */
>          atomic_t migration_in_progress;
> +        struct cpumask cpumask; /* CPU list to flush */

That is not a helpful comment.  Flush what?  What adds to the list?  When is the
list cleared.  Even the name is fairly useless, e.g. "

I'm also pretty sure this should be a cpumask_var_t, and dynamically allocated
as appropriate.  And at that point, it should be allocated and filled if and only
if the CPU doesn't have X86_FEATURE_SME_COHERENT.

