Return-Path: <kvm+bounces-22264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 449AB93C838
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 20:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B816F1F21B11
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 18:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856312C1B4;
	Thu, 25 Jul 2024 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0O+hwPJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAC321350
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721931469; cv=none; b=l3LpNZjjpOawrVzTPa/ABRMAXGyqpgMlyMIwr/TcS4O881ZBpGcHhep2fMomYRVZ0jR6lMWNjv6O0Yj4+CTBOVVDazULKo1ruWisdkRV6Gap1xVmpCuoF2YaxHzMuN6JNibcuZY5rXtTWdyjInBYqRnzg2C6TNfI+eABjlTK8AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721931469; c=relaxed/simple;
	bh=7TGdImb3lenZ6if5s4D0hbXhdDde95DNNoZfafPu3I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7WFEzGLbdHRB8lDymtOkBAuW4aAVqDQA9eqqzKZ/qEHgIweRYHrBRe4IABQWAnI/dcSXbCkCgIYnWPPZmy9JUwy35dPFhBNO1z3Ytb2n+W7Fmv/DfRchnWJZ6+JAS0hvTXnrng2zDgWRYzdzcN+22Wu4KhzF+Hnr/QvXqX0baQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0O+hwPJq; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-70d1cbbeeaeso149830b3a.0
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 11:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721931468; x=1722536268; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCU/39n/MEh1qJPI6jK5LfqbsxyFwdIdQzHQHHv611A=;
        b=0O+hwPJqirc88Dd0P+wWSlKQSkkrmqATFfdchfD7NapXyvBCRzpqVHbYYKmKT6pwVC
         xgPQZXCWKhl/DsAJoL72NBeh/YljM+k7gln/rHbqCh6wCQvzKshXxHPFH6ZtH4QagctC
         IhApB9eOLZ55PDNxtmEQtSThiFGhli4UQIlDYAjsOFNzJwnrabnSWOon2tDOXnCPXhEv
         NkygSz7RMD+TzdiRsNA9PzNyVNdns52gpcyczWJg7IL0aDbmfjH+63G5SCFfo8UWRzoJ
         ADtDpUyoULPqJNPoogNoU8aG3xYyGkloRfFbawX4YBzMWUNhF/fEQ/VzQAm94pbWEq+1
         sdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721931468; x=1722536268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCU/39n/MEh1qJPI6jK5LfqbsxyFwdIdQzHQHHv611A=;
        b=UHnzslYhUKQo/K3zqq+9Q1bZkOX6VB1bh8Ap2ocUn6UJJiejajRNqjeLVrPXY8i7Ea
         aaKE+HDgplxlw5DRVW82+kV3B+zhGh3Kh7Vp3VlInd+6SfizN0TUihDmT8klRcNgBt6n
         m1vrtxvbuEIzooZ/sdWz/orqhkuP/dVTNODB+cyDR9qzlqpcVDHWKPHwWdm6qqfMrL8J
         nav/FMUfgG3B9LiB9Fi4n4gYvgsRdP4neutybJR8Gj/P193rrkhy7XCGM57e3hqIwus5
         w9usnQSzuZHGvxNbl0mtTr02vlcQeg4IGyOuY6mPUIytHCgQ9xYxCDg+eMxyniVXsbhE
         CkcA==
X-Forwarded-Encrypted: i=1; AJvYcCWE1uo636BCMRTHTunYdUj20tur2mToCtof9ROcKoKP0zIICvB4IZBY7d85bJRTFwk0BO5R9JJchLihEkJ1H19Ssena
X-Gm-Message-State: AOJu0YyePMrztnqREGNz/txFFnOyqVldVoOu639iR9SL4mQYsgmJkvoy
	9gmkGlQERFxvLRZPKuuuRievHy1gAaWN286SMoVjuigXCnRzKsT3EIUFvINobQ==
X-Google-Smtp-Source: AGHT+IGgJJ2MHUDyfdNf8nuLsnVaCfQ9A96+ttKTHUsGKEKorXbwZR90OZ/UEb7mApStThubbs9AYw==
X-Received: by 2002:a05:6a00:2d8c:b0:70e:8070:f9d0 with SMTP id d2e1a72fcca58-70eae8d5c8amr3531836b3a.9.1721931466986;
        Thu, 25 Jul 2024 11:17:46 -0700 (PDT)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f884c245sm1490390a12.50.2024.07.25.11.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 11:17:46 -0700 (PDT)
Date: Thu, 25 Jul 2024 11:17:41 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 08/11] KVM: x86: Optimize kvm_{test_,}age_gfn a little
 bit
Message-ID: <ZqKWxfqRoJzUWroG@google.com>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-9-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724011037.3671523-9-jthoughton@google.com>

On 2024-07-24 01:10 AM, James Houghton wrote:
> Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the

nit: Use () when referring to functions.

> shadow MMU by, rather than checking if our memslot has rmaps, check if
> there are any indirect_shadow_pages at all.

What is optimized by checking indirect_shadow_pages instead of
have_rmaps and what's the benefit? Smells like a premature optimization.

> 
> Also, for kvm_test_age_gfn, reorder the TDP MMU check to be first. If we
> find that the range is young, we do not need to check the shadow MMU.

This should be a separate commit since it's a logically distinct change
and no dependency on the other change in this commit (other than both
touch the same function).

Splitting the commits up will also make it easier to write more specific
short logs (instead of "optimize a little bit" :)

Also, the commit re-orders kvm_age_gfn() as well but the commit message
only mentions kvm_test_age_gfn(). No objection to keeping the two
functions consistent but it should be called out in the commit message.

> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7b93ce8f0680..919d59385f89 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1629,19 +1629,24 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
>  	__rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
>  }
>  
> +static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
> +{
> +	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
> +}
> +
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
>  
> -	if (kvm_memslots_have_rmaps(kvm)) {
> +	if (tdp_mmu_enabled)
> +		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
> +
> +	if (kvm_has_shadow_mmu_sptes(kvm)) {
>  		write_lock(&kvm->mmu_lock);
>  		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
> -	if (tdp_mmu_enabled)
> -		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
> -
>  	return young;
>  }
>  
> @@ -1649,15 +1654,15 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	bool young = false;
>  
> -	if (kvm_memslots_have_rmaps(kvm)) {
> +	if (tdp_mmu_enabled)
> +		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
> +
> +	if (!young && kvm_has_shadow_mmu_sptes(kvm)) {

nit: A short comment here might be helpful to explain why young is
checked.

>  		write_lock(&kvm->mmu_lock);
>  		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
> -	if (tdp_mmu_enabled)
> -		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
> -
>  	return young;
>  }
>  
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

