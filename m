Return-Path: <kvm+bounces-35132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29CEAA09E97
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E0BB188C458
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3AD621C9EE;
	Fri, 10 Jan 2025 23:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KzLsAPZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A576521C182
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 23:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550337; cv=none; b=b43c8HcOXd4q68gC9hmyzJ4Jg+kUJ1JvwkZBJh+ieJHwIF9GwVhDW7Ud88Pd6gPGJGhl5CLz95cVD6jbcrcojhu5VuO8IlvK4KeCyUjCbKgzeHOq9SxMUPt4XqIZueSel5MmLkBceT9OPEe/C+vjEEgReh38dBx94HCCh7lLCQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550337; c=relaxed/simple;
	bh=qwwCBe4e5rIu2wqp7SKhes2U0CxRWxystyzE7XiQFik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b4I7u95hcNZ/e7YwYaG59vw+RIz/QLWN0RqcfVJhW11ctUQUHnvNtF6HdjGVhYr4W8PIgx84TjcLIR7rLA6JYQvd1iDC25+b0eAChPBZGyxCk3cb7tQHjQUI8D7w2RbTklWnE/s6BMOCpJtzjwVJi42HnP7y/hZsBZ1/6Jya3Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KzLsAPZ+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21631cbf87dso47827495ad.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 15:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736550334; x=1737155134; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbjbwXZaGMiDE53Fofc94r/1JS3NOYYG2R1MIedjxPA=;
        b=KzLsAPZ+cZtN0CsNIaLNkJGGEmOM1Fdm2Je/KKN8gClQES3P0TS8qQQMaBeS1xZyGe
         qep1kdIreT1uReb5CHbPvbytzaW/ldBXk44f2Z0LTG/ETAY5CRP9aeZFi1bET3YER5uJ
         dyEg/GgDYWuKGHOmZPEy+zKs2KF9qWloXUwCdqgopuh/ElnKGSBmbmCeMz5VIyxUmHDw
         BJ/KvrOEDmz/4174quMN07ptE8I0ViEBVABIL33T1ghvAKD2RNlZVfnJwMCNkexAi649
         Bl1jTWNc+SNFcCWbbMxDqOEakwvOuhVRYul53RagmKNJ0sSwz/ZxKc2l/sKfhIbwQJDf
         2WoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736550334; x=1737155134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbjbwXZaGMiDE53Fofc94r/1JS3NOYYG2R1MIedjxPA=;
        b=QNqOGZkcuyUBYQ5qg7f04nqQu0qiXgTLDObOvXGTADuSnu/8UsJIcm04YcDa/xWCFg
         m7n5/8BqNnDrlnOE4PA2T+JqXJvtz09XkXKAdUU4xXg/WLK1GzDBYqga20ehSn0mts+6
         dvaLYmkEcRqBA82vHBljuhC9UKSjaSIUoqWK78tUs4xJr/Tc2IV1vdFHjnEP6ElJ4ZUB
         qHfUKjn4dMgD0vnC77VsuIEveEPTWNE6c4h8dwyWVFQCFA9O98x/QVkJJuTLLEdiwdJv
         TX2GyT+SOCw+fFzdA1GlOCvYuz07XyyBv9AH7FkjRz4Hxg8GkAVK9aY20c6JjzV1iwMQ
         mJUA==
X-Forwarded-Encrypted: i=1; AJvYcCUqusDu8s7Dl7b+2BGlFCJZj8Q+Pg4Lkl+ds3pifcx1xS4ccV5cFDHG38oB4SqQ00zKD4E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Mf2BoLysgooGe8Gj/9dWuffLjSbVkuF0pH+XRnWfItlWmebG
	sx+DENHR3zKsFQ8p3Pjv5DTVotQXPySQEZE2sG1pEm9oy0/QcIRx6hh8UILx74rld6nMPI7UDwx
	/Wg==
X-Google-Smtp-Source: AGHT+IF9AyGUF1y8DBCbFQem8z3smlyU6oHuCoxZoy7yuU69//Bt6h2PknZ3SLzIoI23Qhg9v6e2ZvM4Vro=
X-Received: from pgbbx32.prod.google.com ([2002:a05:6a02:520:b0:7fd:4450:8101])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2d2:b0:215:a039:738
 with SMTP id d9443c01a7336-21a83f42444mr201250965ad.5.1736550333870; Fri, 10
 Jan 2025 15:05:33 -0800 (PST)
Date: Fri, 10 Jan 2025 15:05:32 -0800
In-Reply-To: <20241105184333.2305744-7-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-7-jthoughton@google.com>
Message-ID: <Z4GnvHqZqxW7sRjs@google.com>
Subject: Re: [PATCH v8 06/11] KVM: x86/mmu: Only check gfn age in shadow MMU
 if indirect_shadow_pages > 0
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, James Houghton wrote:
> Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
> shadow MMU by, rather than checking if our memslot has rmaps, check if

No "our" (pronouns bad).

> there are any indirect_shadow_pages at all.

Again, use wording that is more conversational.  I also think it's worthwhile to
call out when this optimization is helpful.  E.g.

When aging SPTEs and the TDP MMU is enabled, process the shadow MMU if and
only if the VM has at least one shadow page, as opposed to checking if the
VM has rmaps.  Checking for rmaps will effectively yield a false positive
if the VM ran nested TDP VMs in the past, but is not currently doing so.

> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 793565a3a573..125d4c3ccceb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1582,6 +1582,11 @@ static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
>  	return young;
>  }
>  
> +static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)

I think this should be kvm_may_have_shadow_mmu_sptes(), or something along those
lines that makes it clear the check is imprecise.  E.g. to avoid someone thinking
that KVM is guaranteed to have shadow MMU SPTEs if it returns true.

> +{
> +	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
> +}
> +
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
> @@ -1589,7 +1594,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (tdp_mmu_enabled)
>  		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
>  
> -	if (kvm_memslots_have_rmaps(kvm)) {
> +	if (kvm_has_shadow_mmu_sptes(kvm)) {
>  		write_lock(&kvm->mmu_lock);
>  		young |= kvm_rmap_age_gfn_range(kvm, range, false);
>  		write_unlock(&kvm->mmu_lock);
> @@ -1605,7 +1610,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (tdp_mmu_enabled)
>  		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
>  
> -	if (!young && kvm_memslots_have_rmaps(kvm)) {
> +	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {
>  		write_lock(&kvm->mmu_lock);
>  		young |= kvm_rmap_age_gfn_range(kvm, range, true);
>  		write_unlock(&kvm->mmu_lock);
> -- 
> 2.47.0.199.ga7371fff76-goog
> 

