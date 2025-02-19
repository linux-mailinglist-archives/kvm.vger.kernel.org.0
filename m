Return-Path: <kvm+bounces-38524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE7AA3AEC2
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:16:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21AEA3A912E
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58CC1E4AB;
	Wed, 19 Feb 2025 01:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pfkZtJhR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E733596B
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927590; cv=none; b=righEL1AX99ZUodwK93uSWahka3K++M0JMkHy2ontSM9dJ7yLfFCYd7UeHqc8aRQbHaRsBroYj1eTULgXRqb0ByIJVrRLavnvBnDfQrLvS7kmaf5zi+FokzS0Oo2EBPSaR5pyAwKGcMbENr569Yahgc56ckhPLi0aFCThwvYJ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927590; c=relaxed/simple;
	bh=Hpkq/EcMyJN9QiR56zDrCtS+nsBUJ5LGhT0AM8AYzdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IcP9DaodDOPVePFDp2+4qqWQzsu63eO52ylaMNlmOisT5+J3E4qC+ZXKMCM20Xra8PkRk43AP6vsd17IPPCV+A64fCSjFyExL/pA2e2pTf40d6U9W7JDiPhJqlX+lsaS8pE00/CW4N5XHeJQTiygiIcaAhT1Ov/pwQgL8vkujqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pfkZtJhR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc2e648da3so9248637a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739927588; x=1740532388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mflWO/XRCQHvh/IrZqjybYfqPWjo26dMgGNhYoPDdmY=;
        b=pfkZtJhR/lKXsty60EsUQuPtx2Mn/ODgeIHvThQ/GUKjznCJAfxB4mB3JINGDBWwGS
         PTjvy5kw3z80SsIRdxFHsBaNO0OPVBHOEo9vT6ojFY8Ep7jnDDT3ExKFuZiCB8qAEJ5v
         fwYSJxJgNUPSz1E4EAo421G5OA+Q61ynCbUbpg9L5ba76pHNHsbkxkqX/fWrjBlNp3oB
         HrizeQK2p9b8sWD2SOCLy/Terksq8tpAoGpVBp+TjkKtIS/mgqjgszyaw6iz14NGm4yk
         MfJcs011UYOUPJJ1+9/wjXBXq2BRUemTzEwBmYL6dClsf1ClL7qNIQZfHP/6SaNCHp/V
         dUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739927588; x=1740532388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mflWO/XRCQHvh/IrZqjybYfqPWjo26dMgGNhYoPDdmY=;
        b=CQg7I9nVFq7UidMtc5ubwC73/WttLeelxwsdwpy49Nswb2EIZNvv4dcW30Q6IRNYHz
         GnnHua/PQ9OAYFcitoPpEQoqy2onN1EqrUbFBzRMchDY7aWA6j8sfbaOLVTEAkPTTUp/
         peMwLwPJvnOuiJNPZ0Nacz1HkNJ1yIqub5bqiGTfT116FWC8ARxXGWH6jgZ6dCoqz+y+
         O4CIMrqzUBljdsdAmUzR72UW9Jt2LCie5LWy0r4gq9L6sMXkdEF76kkIawMY9cHdIE7e
         RIqETCcslaoYS/vhbO3WGN8omx0ft5AdAOxxvMd8zktkbAsMVCrr065aGXrKJfSmPYJh
         S+zg==
X-Forwarded-Encrypted: i=1; AJvYcCXG6lGbYc/TTVtm96WLdmBfWcLMdJk61hWwQU4bFYtk94PhQRUE6FMRYvArVfyNMuWiWhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTTsvM3t3naewg7cpCRsa1CDCxX75L52nCFuZS0B+8THAfi1J4
	8KICGXQggdcuNURmMXkjNRbkwUq2lyZcv2wn60rnhjpfU6KcHf5mP602/GAh01lxji4XIL5Rugm
	Ccg==
X-Google-Smtp-Source: AGHT+IEBAa2iEtk67DgSzp7ce8gECYaEnydFphu0i8/4uZFDi13HL72ep52GdzDpEzM9zUFQjM1JY9keGZE=
X-Received: from pfbic22.prod.google.com ([2002:a05:6a00:8a16:b0:730:4672:64ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c8e:b0:732:288b:c049
 with SMTP id d2e1a72fcca58-7329de4ec7emr2406484b3a.1.1739927588402; Tue, 18
 Feb 2025 17:13:08 -0800 (PST)
Date: Tue, 18 Feb 2025 17:13:07 -0800
In-Reply-To: <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com> <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
Message-ID: <Z7UwI-9zqnhpmg30@google.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 18, 2025, Maxim Levitsky wrote:
> On Tue, 2025-02-04 at 00:40 +0000, James Houghton wrote:
> > By aging sptes locklessly with the TDP MMU and the shadow MMU, neither
> > vCPUs nor reclaim (mmu_notifier_invalidate_range*) will get stuck
> > waiting for aging. This contention reduction improves guest performance
> > and saves a significant amount of Google Cloud's CPU usage, and it has
> > valuable improvements for ChromeOS, as Yu has mentioned previously[1].
> > 
> > Please see v8[8] for some performance results using
> > access_tracking_perf_test patched to use MGLRU.
> > 
> > Neither access_tracking_perf_test nor mmu_stress_test trigger any
> > splats (with CONFIG_LOCKDEP=y) with the TDP MMU and with the shadow MMU.
> 
> 
> Hi, I have a question about this patch series and about the
> access_tracking_perf_test:
> 
> Some time ago, I investigated a failure in access_tracking_perf_test which
> shows up in our CI.
> 
> The root cause was that 'folio_clear_idle' doesn't clear the idle bit when
> MGLRU is enabled, and overall I got the impression that MGLRU is not
> compatible with idle page tracking.
>
> I thought that this patch series and the 'mm: multi-gen LRU: Have secondary
> MMUs participate in MM_WALK' patch series could address this but the test
> still fails.
> 
> 
> For the reference the exact problem is:
> 
> 1. Idle bits for guest memory under test are set via /sys/kernel/mm/page_idle/bitmap
> 
> 2. Guest dirties memory, which leads to A/D bits being set in the secondary mappings.
> 
> 3. A NUMA autobalance code write protects the guest memory. KVM in response
>    evicts the SPTE mappings with A/D bit set, and while doing so tells mm
>    that pages were accessed using 'folio_mark_accessed' (via kvm_set_page_accessed (*) )
>    but due to MLGRU the call doesn't clear the idle bit and thus all the traces
>    of the guest access disappear and the kernel thinks that the page is still idle.
> 
> I can say that the root cause of this is that folio_mark_accessed doesn't do
> what it supposed to do.
> 
> Calling 'folio_clear_idle(folio);' in MLGRU case in folio_mark_accessed()
> will probably fix this but I don't have enough confidence to say if this is
> all that is needed to fix this.  If this is the case I can send a patch.

My understanding is that the behavior is deliberate.  Per Yu[1], page_idle/bitmap
effectively isn't supported by MGLRU.

[1] https://lore.kernel.org/all/CAOUHufZeADNp_y=Ng+acmMMgnTR=ZGFZ7z-m6O47O=CmJauWjw@mail.gmail.com

> This patch makes the test pass (but only on 6.12 kernel and below, see below):
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 59f30a981c6f..2013e1f4d572 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -460,7 +460,7 @@ void folio_mark_accessed(struct folio *folio)
>  {
>         if (lru_gen_enabled()) {
>                 folio_inc_refs(folio);
> -               return;
> +               goto clear_idle_bit;
>         }
>  
>         if (!folio_test_referenced(folio)) {
> @@ -485,6 +485,7 @@ void folio_mark_accessed(struct folio *folio)
>                 folio_clear_referenced(folio);
>                 workingset_activation(folio);
>         }
> +clear_idle_bit:
>         if (folio_test_idle(folio))
>                 folio_clear_idle(folio);
>  }
> 
> 
> To always reproduce this, it is best to use a patch to make the test run in a
> loop, like below (although the test fails without this as well).

..

> With the above patch applied, you will notice after 4-6 iterations that the
> number of still idle pages soars:
> 
> Populating memory             : 0.798882357s

...

> vCPU0: idle pages: 132558 out of 262144, failed to mark idle: 0 no pfn: 0
> Mark memory idle              : 2.711946690s
> Writing to idle memory        : 0.302882502s
> 
> ...
> 
> (*) Turns out that since kernel 6.13, this code that sets accessed bit in the
> primary paging structure, when the secondary was zapped was *removed*. I
> bisected this to commit:
> 
> 66bc627e7fee KVM: x86/mmu: Don't mark "struct page" accessed when zapping SPTEs
> 
> So now the access_tracking_test is broken regardless of MGLRU.

Just to confirm, do you see failures on 6.13 with MGLRU disabled?  

> Any ideas on how to fix all this mess?

The easy answer is to skip the test if MGLRU is in use, or if NUMA balancing is
enabled.  In a real-world scenario, if the guest is actually accessing the pages
that get PROT_NONE'd by NUMA balancing, they will be marked accessed when they're
faulted back in.  There's a window where page_idle/bitmap could be read between
making the VMA PROT_NONE and re-accessing the page from the guest, but IMO that's
one of the many flaws of NUMA balancing.

That said, one thing is quite odd.  In the failing case, *half* of the guest pages
are still idle.  That's quite insane.

Aha!  I wonder if in the failing case, the vCPU gets migrated to a pCPU on a
different node, and that causes NUMA balancing to go crazy and zap pretty much
all of guest memory.  If that's what's happening, then a better solution for the
NUMA balancing issue would be to affine the vCPU to a single NUMA node (or hard
pin it to a single pCPU?).

