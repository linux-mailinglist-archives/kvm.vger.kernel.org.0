Return-Path: <kvm+bounces-28238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E88996B59
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9968F1C22986
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF64198E74;
	Wed,  9 Oct 2024 13:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vyh/xcSW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ADB19882F
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 13:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728479146; cv=none; b=EjzjGryLp6q9jSqWq0Y2M2Oxu/1LwM5t8mStfDWQt6uMSO2+C5tAN4ksTBFcsWgpVHvjQpW8JCfiRzTiRj6ljfsfHoV4yWUxtxPliNJW3xaoQdWtdDnImRkI0mv6MFWEjAHBYYbIJN1o774XevKi3qxOzzvmiUhMsNbHAROX70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728479146; c=relaxed/simple;
	bh=NgO/vc7pC+KSeRyD6TqTvTQ6tVFd67ypnLZUSz0PNwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HQxrQQ9yShMMsWSpyYquLH5nvnbhZyma85zlS3000Dv2KWQIGfLcfQ8VMZZC1sLSrb4JtX6wDM/lIuniLMyo0GyaRpEIWbZprNyDrpEqKXsxWFO1Gkx3nS1ppqP7f93c1OnWhvPrgRU/dJgtU8/eubF2Y1gYIBawll6/mEN4oFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vyh/xcSW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e29df9d3abso837423a91.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 06:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728479144; x=1729083944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M+ZV/trcDNRdWSOYX2HW3DTnbErvfouDCVlcZiKYTHY=;
        b=vyh/xcSWLTW+0AV7upkdnods6nwP1IS4YjtrM65ALprnzPmiy3beVwJ15R+xYn+WET
         DE3DTB9Fz7t2GrWSCVudEV/iREFgIkgI6J5G5Txkdm6JparfVdn3gH1M3UwxZTEoE9u7
         HOMV9H5vUgrA/hFgj4vGdKJt5+aWw2KUlycMA3S8JKGft+Uuz7GeNuoWO4ivCpO/gx7n
         RJEiIOzmQkKyYNRG3NPBNg5tdxxrNHAACJ25Op7eyZmTrhK7PLw1vzblOCRMZWeA0BEx
         8M5nYFTVvhlVm1CAdtF9c0rmtpbyER31eFH/Uv01zGQrtxc7q46TcDw30L7EWMQhCVug
         cZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728479144; x=1729083944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M+ZV/trcDNRdWSOYX2HW3DTnbErvfouDCVlcZiKYTHY=;
        b=Yt21gPreKS4nLSiieN+rYsSuIhcfPv6H6cOnD9cVMVMtrjIULAOmF5dHZlZhhBxk+H
         rRLItOLcACaMeBk+t78Jg9lRdLwxz0dVqPexC3W/VBcds3r9CvB8ztlq7F1WukZc/xBP
         Ovh4X6VzsSM6akPr4R94sSwvBSVf6ZQN+2V5ChPR8m0y7zzD+7j+4PzsQ4ZAJAoHiEjw
         Z+dzCgs8pI+HtsxQbH4qN/tBxUjrBd0Qj6OqlSvOoYZDx0iYtodP3zIzqyrBKpAjzNJU
         ZyCy/csH/sVXV3n/8PZujEK2R6a58a/52i829MpRA4lZrMTjp5M/5HeKMR5k29NBtk8y
         d5UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIZCfv7kfNbN9ho6yl5X/kAbKbZ/JgB0OuLsLcM8tU+lRBA0R0Gn77mzcJZC1ol5HeVLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRiZt5vbglIql7jwxSLacEm5HgFYQWW91OGfbYG3b2tYv2/K6P
	d5O6wKFaOIv3BAz3KiYvrzvkk2ktUHUfBVMAE2ByAiXhwo4dcvrX9nG074fidfwzejEZ1SxsPF6
	4IA==
X-Google-Smtp-Source: AGHT+IGNE2KC1dM0KxpRBNF8b2Z0D674nnv00es7vxsYOwAQzlqghuv/SjG5RmZWL23gCO1GPG5K9PVxbZE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c20d:b0:2d8:a37d:b762 with SMTP id
 98e67ed59e1d1-2e2a250ecfamr2290a91.4.1728479144156; Wed, 09 Oct 2024 06:05:44
 -0700 (PDT)
Date: Wed, 9 Oct 2024 06:05:42 -0700
In-Reply-To: <ZwZEEHeRWEA2JUsj@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003230105.226476-1-pbonzini@redhat.com> <ZwAeJ1RtReFiRiNd@google.com>
 <ZwZEEHeRWEA2JUsj@yzhao56-desk.sh.intel.com>
Message-ID: <ZwZ_pkw3pGoA0gA6@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: fix KVM_X86_QUIRK_SLOT_ZAP_ALL for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 09, 2024, Yan Zhao wrote:
> On Fri, Oct 04, 2024 at 09:56:07AM -0700, Sean Christopherson wrote:
> > >  arch/x86/kvm/mmu/mmu.c | 60 ++++++++++++++++++++++++++++++++----------
> > >  1 file changed, 46 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e081f785fb23..912bad4fa88c 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1884,10 +1884,14 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
> > >  		if (is_obsolete_sp((_kvm), (_sp))) {			\
> > >  		} else
> > >  
> > > -#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
> > > +#define for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
> > >  	for_each_valid_sp(_kvm, _sp,					\
> > >  	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
> > > -		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
> > > +		if ((_sp)->gfn != (_gfn)) {} else
> > 
> > I don't think we should provide this iterator, because it won't do what most people
> > would it expect it to do.  Specifically, the "round gfn for level" adjustment that
> > is done for direct SPs means that the exact gfn comparison will not get a match,
> > even when a SP does "cover" a gfn, or was even created specifically for a gfn.
> Right, zapping of sps with no gptes are not necessary.
> When role.direct is true, the sp->gfn can even be a non-slot gfn with the leaf
> entries being mmio sptes. So, it should be ok to ignore
> "!sp_has_gptes(_sp) && (_sp)->gfn == (_gfn)".
> 
> Tests of "normal VM + nested VM + 3 selftests" passed on the 3 configs
> 1) modprobe kvm_intel ept=0,
> 2) modprobe kvm tdp_mmu=0
>    modprobe kvm_intel ept=1
> 3) modprobe kvm tdp_mmu=1
>    modprobe kvm_intel ept=1
> 
> with quirk disabled + below change
> 
> @@ -7071,7 +7077,7 @@ static void kvm_mmu_zap_memslot_pages_and_flush(struct kvm *kvm,
>                 struct kvm_mmu_page *sp;
>                 gfn_t gfn = slot->base_gfn + i;
> 
> -               for_each_gfn_valid_sp(kvm, sp, gfn)
> +               for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn)
>                         kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> 
>                 if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {

Ya, I have a patch that I'll send today.

