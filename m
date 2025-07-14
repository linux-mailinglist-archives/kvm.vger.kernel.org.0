Return-Path: <kvm+bounces-52350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4248CB045E8
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 18:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A331188E869
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF8225EFBF;
	Mon, 14 Jul 2025 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Us816Ql9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A67412BF24
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 16:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752511808; cv=none; b=lZBTvtYne1bNNjLoZjEA8ega2m4svg1jqFTtRxmeqAmVter+HnAZEIFvZlesIm//fCKSAefoW+bgWlctrtu8CsGq1GhnHckB9I3Q6cbYO6ssR4LbbCf/OL+Bufh76DLc4FZebwtUE/OvP4mHn7ZKH4v94zBr4Dv9e2DAxrZ6Jak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752511808; c=relaxed/simple;
	bh=+u8ijcOJ3zljOgtWN6MeFwvJau7rJ8FUIfUEVt/tOig=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YTl1DwNF996iOG+PULG/9hRfDPbgMXkKoB49mJ7xAFYdaoTRw7tGCsM6F0VGz/ex8RBlXPYtqVrRcd6QHsSmJ7mwuChFjqxQhy5ipGJ/mJ/o+aiYrtPPpef7UA8Ri80Ce7iOYyGGTUGn4T4/sPk1JZ0SNsNY5GDB7jYT3h5hhFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Us816Ql9; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74b185fba41so3999570b3a.1
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752511806; x=1753116606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/lRA3Lmbx+WYHtJuKxkOr0j62kfUWW7KunEBa7xsiUM=;
        b=Us816Ql9D2m6XXChO7/AVpBQYkJ3g5EyK9s9j5ZXJLTCyFVLP8EE+w7i0JaxqaAqyV
         XNPBtm+n0+l2jl4Q4mPX1XV6A8qtdHdVtdQ7g8kWRuE2DTsunFXDuOLqRjlshUkQyDcU
         H3sqtHtSuAoMpFoRdkasVVAakAP1rcMimVUrIeRmjPp6rOiHjySTcsFW1a0NJjED1WEO
         BRXxTn/1XBJsu0dvqh3zvHpfcUYnc3pzcInGwQit/gdgFRko/6NO5dGIcIm0RbzdouYC
         hkMSg2o5oFNVRf7i7C/TzM3PQtZCHpYQwDcSe1pKqu9YTb3Rsh1NccuXTDj2PRckoXoA
         sMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752511806; x=1753116606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/lRA3Lmbx+WYHtJuKxkOr0j62kfUWW7KunEBa7xsiUM=;
        b=UgHau51jqih5208uKXCnWd3nO4oqL99KUwe5vuw867Inm4TXXIVtkfQT8FcSEI4mgi
         tMBFip0uKfEClliAofSgLdN/kKbAxngVXFkvko5GEPrW/o08BhWupiMxdFs9lxFG3REB
         7RipkCK3WA2WwuhA+N0Qfb7JQAp1fRzXAmvY9bbZgtwLSw8/i9U08ES6IDE7464HvqwM
         eIPcERftQxQRphtvo6tQShY+LIXitGwZOwOkhZcBjbZwE4I6tUb4ac5ooGjzTGp8itCO
         37fnDdrP4OPVH8xKgULGVrcbeMerBOG6s/6gICfrpryB5JJfDu5k2S9o1f+ZPBT9fpx+
         1Uwg==
X-Forwarded-Encrypted: i=1; AJvYcCWr3sXhh3KGeZ7dsjoTz2yrDGxsRyaw0NDSZK+RvrjM+3mp3VvFsYb6zZQZIQBSq/2Rv3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpsB6R/4Gy/q3rZ7UujBHAS0QGqnQuafIjlvVPFFXpQWr/syan
	rIXNbGAfecY63GqJGtyZ4F2hUcFvQ4GV66fV06QZHWiM5mjgFimorpDfqICFyPNKkkWx+wu6Ja9
	GvEwOmA==
X-Google-Smtp-Source: AGHT+IFrmqOWZv/+ru5luYuDmZgKFXLWqs4vM+qkel82s6TmdzUTtjhLo6c0sGKuG8MkQ3bXxpcIuMMTXL4=
X-Received: from pfwy25.prod.google.com ([2002:a05:6a00:1c99:b0:746:24d7:a6aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b70f:b0:748:e1e4:71ec
 with SMTP id d2e1a72fcca58-74ee2556e2bmr18728324b3a.12.1752511805750; Mon, 14
 Jul 2025 09:50:05 -0700 (PDT)
Date: Mon, 14 Jul 2025 09:50:04 -0700
In-Reply-To: <aHUe5HY4C2vungCd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com> <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
 <aHUYwCNDWlsar3qk@google.com> <15D0C887-E17F-4432-8716-BF62EEE61B6B@sjtu.edu.cn>
 <aHUe5HY4C2vungCd@google.com>
Message-ID: <aHU1PGWwp9f6q8sk@google.com>
Subject: Re: [BUG] NULL pointer dereference in sev_writeback_caches during KVM
 SEV migration kselftest on AMD platform
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: Srikanth Aithal <sraithal@amd.com>, linux-next@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 14, 2025, Sean Christopherson wrote:
> On Mon, Jul 14, 2025, Zheyun Shen wrote:
> I think this is the fix, testing now...
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 95668e84ab86..1476e877b2dc 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1936,6 +1936,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>         dst->enc_context_owner = src->enc_context_owner;
>         dst->es_active = src->es_active;
>         dst->vmsa_features = src->vmsa_features;
> +       memcpy(&dst->have_run_cpus, &src->have_run_cpus, sizeof(src->have_run_cpus));
>  
>         src->asid = 0;
>         src->active = false;
> @@ -1943,6 +1944,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>         src->pages_locked = 0;
>         src->enc_context_owner = NULL;
>         src->es_active = false;
> +       memset(&src->have_run_cpus, 0, sizeof(src->have_run_cpus));
>  
>         list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);

Gah, that's niether sufficient nor correct.  I was thinking KVM_VM_DEAD would guard
accesses to the bitmask, but that only handles the KVM_RUN path.  And we don't
want to skip the WBINVD when tearing down the source, because nothing guarantees
the destination has pinned all of the source's memory.

And conversely, I don't think KVM needs to copy over the mask itself.  If a CPU
was used for the source VM but not the destination VM, then it can only have
cached memory that was accessible to the source VM.  And a CPU that was run in
the source is also used by the destination is no different than a CPU that was
run in the destination only.

So as much as I want to avoid allocating another cpumask (ugh), it's the right
thing to do.  And practically speaking, I doubt many real world users of SEV will
be using MAXSMP, i.e. the allocations don't exist anyways.

Unless someone objects and/or has a better idea, I'll squash this:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 95668e84ab86..e39726d258b8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2072,6 +2072,17 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
        if (ret)
                goto out_source_vcpu;
 
+       /*
+        * Allocate a new have_run_cpus for the destination, i.e. don't copy
+        * the set of CPUs from the source.  If a CPU was used to run a vCPU in
+        * the source VM but is never used for the destination VM, then the CPU
+        * can only have cached memory that was accessible to the source VM.
+        */
+       if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+               ret = -ENOMEM;
+               goto out_source_vcpu;
+       }
+
        sev_migrate_from(kvm, source_kvm);
        kvm_vm_dead(source_kvm);
        cg_cleanup_sev = src_sev;
@@ -2771,13 +2782,18 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
                goto e_unlock;
        }
 
+       mirror_sev = to_kvm_sev_info(kvm);
+       if (!zalloc_cpumask_var(&mirror_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+               ret = -ENOMEM;
+               goto e_unlock;
+       }
+
        /*
         * The mirror kvm holds an enc_context_owner ref so its asid can't
         * disappear until we're done with it
         */
        source_sev = to_kvm_sev_info(source_kvm);
        kvm_get_kvm(source_kvm);
-       mirror_sev = to_kvm_sev_info(kvm);
        list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 
        /* Set enc_context_owner and copy its encryption context over */

