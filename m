Return-Path: <kvm+bounces-35914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F317CA15ACA
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 02:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4F62168DBD
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04557FC0B;
	Sat, 18 Jan 2025 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3MXlWmws"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEA525A63C
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 01:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737162346; cv=none; b=DWvThcCkHuejX1MnnTij7pRp212bCKEsLfwcxM4gjQMvKJz2t9QMyEDIGrznGZUcAhWN/eQyebSV8x4cYa9B1F1nnal+NgwC/X54ziYmOETmJ1C3aunbE+xZAgyNVQd5eAwB+RfxqH7GMMEDSh4ra4B7BjS3ILKpHYflR0cY3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737162346; c=relaxed/simple;
	bh=Q/TINJUO8d2fOGe9JWbqFqDyKh7waSf5CJ+SpnwXEVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lz5/rAInz03LFDVM9SkBWXSn8Nale1DUJZOMaTolTpaS0ell6m9YZsRQOSFjGUD0bJ4PIst1H/IxAhK8ke6HzdhRAEMvR9OvvP4WSEdmFATVLP6hsbhoatfmqVhZSFb1TyX27TDcozmFDzk+3huFpNFOI9L8oTeLatMt51Dy3Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3MXlWmws; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f5538a2356so5101374a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737162344; x=1737767144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wyh5C9zC3vuSZuTnGAGVYg2j9KLur0MVGQPHVsQm1yE=;
        b=3MXlWmwssOaHvn4JCKu93GpPsm2D2nCZCzMbk73lXzzZqGaOsfQf9g5KWEEJbB5ywY
         sF4ZjF33IkgDNZNSV3aeEc/hYa3YC/KWlDkoZUgQMT8z623PuKTbeV629aqEYQlW39ZJ
         BaTX4Ladv9Mo+ZTeibagZqmoc3cY1qIx1jMUmtTqKShrL2oBILeZ9ucmM0OUGah+TwRx
         2fE4ACLv0zWZGmoVaXWUtNzx+vHqhNruGnbhv9Tmo34ac9QCc6zvlMtp+GvBomsJqioO
         6RC8/cbDqd8BwxkDdQT7q0otDNbhl47+Fcs/82HlLXCd1WXOMh/FF3joOuGRVyuNQplW
         +Dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737162344; x=1737767144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wyh5C9zC3vuSZuTnGAGVYg2j9KLur0MVGQPHVsQm1yE=;
        b=tIlgXVRgwsuGkAecn3lntDnIyW6SS4wqYYEBNlLA424mjgZFdlaCPlWM/p2RBvMTTa
         W0HUJ12LFwFoW5K+/3HLNelvSSJmrAy8FiEntUrk3gG94KLCBvRePTXeCiPAwd645GFF
         1xUIwiUk8qh22OZG7VXJ03t7vH3B7EU19ZXt4g1eYbRzlKb3u2Qqq7hMVmyL1h+s+ALH
         HJkIICpEPVwRNrMbzxkWE7+tbGdJWCsXJ89u+4FCfXaQLxCSFDZZvyvKGUmEuqV/+pli
         X9jpUvxa0ht7KT1R8cgKyFi/kV2mbMOdpm059Q4KgNMOagqtR97xeCPveHPPSspw+yE1
         hfpw==
X-Forwarded-Encrypted: i=1; AJvYcCXfLWTx8Pts8tejIm3xQs4o42mDyKmRE2Zs1TKop+rGKO8oxb/eL9p0qiL51hWvUxg4cJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoHViGiJ5M0An4GvIIEbJc2Zk3Ec086/BZMMC/KJeSLTUqHsOH
	1lDqF/f3EhSrjhpwpnrMs7nn4FdfEDBd1mr5PeqNBcp/gQIP/iEWUsIKwT2gzHerXQNu3AL5FzI
	Ggw==
X-Google-Smtp-Source: AGHT+IFbFqS0H7ctmQ/zosfCbMGK7ZNM4mMgLKLsDqrW5+LVcr2Y80YkNVAWyodcvOgfToaFg1wxh48u/HE=
X-Received: from pjbsd15.prod.google.com ([2002:a17:90b:514f:b0:2ea:46ed:5d3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18f:b0:2ee:d7d3:3019
 with SMTP id 98e67ed59e1d1-2f782c7a769mr8119864a91.12.1737162344033; Fri, 17
 Jan 2025 17:05:44 -0800 (PST)
Date: Fri, 17 Jan 2025 17:05:42 -0800
In-Reply-To: <20241222193445.349800-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241222193445.349800-1-pbonzini@redhat.com> <20241222193445.349800-10-pbonzini@redhat.com>
Message-ID: <Z4r-Znz1GQ2E1vMX@google.com>
Subject: Re: [PATCH v6 09/18] KVM: x86/tdp_mmu: Extract root invalid check
 from tdx_mmu_next_root()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, yan.y.zhao@intel.com, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Dec 22, 2024, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Extract tdp_mmu_root_match() to check if the root has given types and use
> it for the root page table iterator.  It checks only_invalid now.
> 
> TDX KVM operates on a shared page table only (Shared-EPT), a mirrored page
> table only (Secure-EPT), or both based on the operation.  KVM MMU notifier
> operations only on shared page table.  KVM guest_memfd invalidation
> operations only on mirrored page table, and so on.  Introduce a centralized
> matching function instead of open coding matching logic in the iterator.
> The next step is to extend the function to check whether the page is shared
> or private
> 
> Link: https://lore.kernel.org/kvm/ZivazWQw1oCU8VBC@google.com/
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Message-ID: <20240718211230.1492011-10-rick.p.edgecombe@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5b01038ddce8..e0ccfdd4200b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -92,6 +92,14 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
>  
> +static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_valid)
> +{
> +	if (only_valid && root->role.invalid)
> +		return false;
> +
> +	return true;

Ugh, this is almost as bad as

	if (x)
		return true;

	return false;

Just do

	return !only_valid || root->role.invalid;

And I vote to drop the helper, "match" makes me think about things like roles
and addresses, not just if a root is valid.

> +}
> +
>  /*
>   * Returns the next root after @prev_root (or the first root if @prev_root is
>   * NULL).  A reference to the returned root is acquired, and the reference to
> @@ -125,7 +133,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  						   typeof(*next_root), link);
>  
>  	while (next_root) {
> -		if ((!only_valid || !next_root->role.invalid) &&
> +		if (tdp_mmu_root_match(next_root, only_valid) &&

E.g. this can just as easily be 

		    !only_valid || root->role.invalid &&

which is amusingly even fewer characters :-D

>  		    kvm_tdp_mmu_get_root(next_root))
>  			break;
>  
> @@ -176,7 +184,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)		\
>  		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&		\
>  		    ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
> -		     ((_only_valid) && (_root)->role.invalid))) {		\
> +		     !tdp_mmu_root_match((_root), (_only_valid)))) {		\
>  		} else
>  
>  #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
> -- 
> 2.43.5
> 
> 

