Return-Path: <kvm+bounces-17442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E0C8C69D2
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9F1728341A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486B7156221;
	Wed, 15 May 2024 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WTtZjw49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E835664CFC
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715787281; cv=none; b=neLaps3q79HLsTd3U7XOVUnUbEVsC4aa4xA/d10y8I8prz4AYNofyq/WcbkL/jwB6f20cz2S60M1b15kPc5hIz60dpFPz3XfSIM3WZzgwA4H1n6BCfVJu2EuNZuOqcnYLA0TAi9dq2thDSvWzNnnGGlBQVYn+rhP9WqwdMIvLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715787281; c=relaxed/simple;
	bh=+6lvtOMgb8NfcJpPVhWpPBvUs9h1AGaJCCBTFnP3VW4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EQLndz6YiAHkxOP4xwFf0/LHRw3TS45NOWdwOM0cb4LPinZZnUdFZzj83iuiwWBoisT2ns3I1aFCNEYY2G0znM5UEtuNqaP09CrgM4lwZiURgtwDKPMD+tDKxxdkI+bd1l8jtJkxrX9opOYaajl77uvXE0IA3oSOvhAFVOrQUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WTtZjw49; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-622ce716ceaso45778487b3.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 08:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715787279; x=1716392079; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E0LavojhfVwl7DnLAtnm8Qy4FATLmcCOxBK1w2ovU0k=;
        b=WTtZjw49yJAlrBsWoLMDPiBAFbMDa25LWrj1ZJ7Bssxq0pl0kWbu8Jhh4U+71o6Xoj
         QDUO4mOXZR1ViT71COSuuf/VMARSHOy58m/r+0zq8u6A3IMLks/yAUpdoDNRRZLOdd+X
         7ZUs5yzUiSa+9Es7UPC1nwDoZKUtwuyHBEHzciH0cdcL6/nkJ9xrNxLvY/FmnU5skhWv
         zAShlLPON77vhSsuE61DgqHCsoWEVGlO+w8ExNVbrBq7RHbHVHL1IiLEuccDPNd9X0J/
         wu3GyzaSFYxTnJNFGgI76lZV4fasx4c69uFwrQDo8xF3LF1XJKIwIDqP+1ngm+jHYaCF
         TaLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715787279; x=1716392079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E0LavojhfVwl7DnLAtnm8Qy4FATLmcCOxBK1w2ovU0k=;
        b=UiA3ugn1bv2LkJHrGUPAu97e+GCtkA7izzBTYMyDZ43vjpZMcvgkMbFwqA+bZpMRh3
         xoTlPZFSjFVEY4AW8/ri1qvzxpOF8uJy5pmXeF5vOMCyLFmsaK+bjIkrul4JPF3715T7
         Qd/02R5EkEY/4TYmgw9NmAlAurvk6U3PikosHeKRhOmVM1/JiEaoHpsQCHfzd0SztwX8
         JAmZU/Z/vBszaOurQa1RjNQVP9NDF01/8e/4iUyfugwv2+vEJfXIJsBXlHbQDikdh5sL
         my1O8h7Bvqa7wSCAnw4guwBz35LboqSirXk+xF2IXRjCCrcQEEfNUpytBaRkPrZf08/6
         lZdg==
X-Forwarded-Encrypted: i=1; AJvYcCUyFgM9x6ZQ7yNgDLHVyA+AJFNQ5Pe01x2adujrmrBSS2L4LcwGicTVpdGmd9opaOcnzjdis3UBcQsEZaLbQnSSqp65
X-Gm-Message-State: AOJu0YzB2f/rC4+kXeb1DF/oOBmuEACc/N9rvcMQrFQtZA+BQ2JbHtkM
	zpQC9d4qxN01EEp1UulI3k2qxrRt5+nUfO8V+0/+K2e+V1wKEtd6lHolPRGq6xjxpvju9qQF8xf
	OhA==
X-Google-Smtp-Source: AGHT+IF5uAGw+7wTn1ut3VTIpcletP4NVFs8Qv2hh7B6QoVI5g2sD9UfP2zaDADu7pIYOlsU4mejwOydYwQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e2cb:0:b0:61a:f3ea:3994 with SMTP id
 00721157ae682-620993b8121mr40095297b3.3.1715787278967; Wed, 15 May 2024
 08:34:38 -0700 (PDT)
Date: Wed, 15 May 2024 08:34:37 -0700
In-Reply-To: <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com> <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
Message-ID: <ZkTWDfuYD-ThdYe6@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
From: Sean Christopherson <seanjc@google.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, erdemaktas@google.com, sagis@google.com, 
	yan.y.zhao@intel.com, dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Tue, May 14, 2024, Rick Edgecombe wrote:
> When virtualizing some CPU features, KVM uses kvm_zap_gfn_range() to zap
> guest mappings so they can be faulted in with different PTE properties.
> 
> For TDX private memory this technique is fundamentally not possible.
> Remapping private memory requires the guest to "accept" it, and also the
> needed PTE properties are not currently supported by TDX for private
> memory.
> 
> These CPU features are:
> 1) MTRR update
> 2) CR0.CD update
> 3) Non-coherent DMA status update

Please go review the series that removes these disaster[*], I suspect it would
literally have taken less time than writing this changelog :-)

[*] https://lore.kernel.org/all/20240309010929.1403984-1-seanjc@google.com

> 4) APICV update
> 
> Since they cannot be supported, they should be blocked from being
> exercised by a TD. In the case of CRO.CD, the feature is fundamentally not
> supported for TDX as it cannot see the guest registers. For APICV
> inhibit it in future changes.
> 
> Guest MTRR support is more of an interesting case. Supported versions of
> the TDX module fix the MTRR CPUID bit to 1, but as previously discussed,
> it is not possible to fully support the feature. This leaves KVM with a
> few options:
>  - Support a modified version of the architecture where the caching
>    attributes are ignored for private memory.
>  - Don't support MTRRs and treat the set MTRR CPUID bit as a TDX Module
>    bug.
> 
> With the additional consideration that likely guest MTRR support in KVM
> will be going away, the later option is the best. Prevent MTRR MSR writes
> from calling kvm_zap_gfn_range() in future changes.
> 
> Lastly, the most interesting case is non-coherent DMA status updates.
> There isn't a way to reject the call. KVM is just notified that there is a
> non-coherent DMA device attached, and expected to act accordingly. For
> normal VMs today, that means to start respecting guest PAT. However,
> recently there has been a proposal to avoid doing this on selfsnoop CPUs
> (see link). On such CPUs it should not be problematic to simply always
> configure the EPT to honor guest PAT. In future changes TDX can enforce
> this behavior for shared memory, resulting in shared memory always
> respecting guest PAT for TDX. So kvm_zap_gfn_range() will not need to be
> called in this case either.
> 
> Unfortunately, this will result in different cache attributes between
> private and shared memory, as private memory is always WB and cannot be
> changed by the VMM on current TDX modules. But it can't really be helped
> while also supporting non-coherent DMA devices.
> 
> Since all callers will be prevented from calling kvm_zap_gfn_range() in
> future changes, report a bug and terminate the guest if other future
> changes to KVM result in triggering kvm_zap_gfn_range() for a TD.
> 
> For lack of a better method currently, use kvm_gfn_shared_mask() to
> determine if private memory cannot be zapped (as in TDX, the only VM type
> that sets it).
> 
> Link: https://lore.kernel.org/all/20240309010929.1403984-6-seanjc@google.com/
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU Part 1:
>  - Remove support from "KVM: x86/tdp_mmu: Zap leafs only for private memory"
>  - Add this KVM_BUG_ON() instead
> ---
>  arch/x86/kvm/mmu/mmu.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d5cf5b15a10e..808805b3478d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6528,8 +6528,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>  
>  	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
>  
> -	if (tdp_mmu_enabled)
> +	if (tdp_mmu_enabled) {
> +		/*
> +		 * kvm_zap_gfn_range() is used when MTRR or PAT memory
> +		 * type was changed.  TDX can't handle zapping the private
> +		 * mapping, but it's ok because KVM doesn't support either of
> +		 * those features for TDX. In case a new caller appears, BUG
> +		 * the VM if it's called for solutions with private aliases.
> +		 */
> +		KVM_BUG_ON(kvm_gfn_shared_mask(kvm), kvm);

Please stop using kvm_gfn_shared_mask() as a proxy for "is this TDX".  Using a
generic name quite obviously doesn't prevent TDX details for bleeding into common
code, and dancing around things just makes it all unnecessarily confusing.

If we can't avoid bleeding TDX details into common code, my vote is to bite the
bullet and simply check vm_type.

This KVM_BUG_ON() also should not be in the tdp_mmu_enabled path.  Yeah, yeah,
TDX is restricted to the TDP MMU, but there's no reason to bleed that detail all
over the place.

>  		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
> +	}
>  
>  	if (flush)
>  		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
> -- 
> 2.34.1
> 

