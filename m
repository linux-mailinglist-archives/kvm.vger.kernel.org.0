Return-Path: <kvm+bounces-17452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B48388C6B92
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 19:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B48A11C226CC
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BAA482DB;
	Wed, 15 May 2024 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SxVWhf0d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9527D28680;
	Wed, 15 May 2024 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715794539; cv=none; b=WrFM+UaMIFMXzaRDA5qu373kcShkVRgfXaN2rM9vWhjob7IGJKC5ZXqe9ZBDTcXlVYNrYI6q7b/kDoAEklj3EWE/Y3S6xTP9Amuy4FxwfYLuUqp3BpKkTq0eH1cMoPMaa1cMvae01xcKQTZraFs6kJdUTww9SDTw46LXCnc65rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715794539; c=relaxed/simple;
	bh=bMXMTNE3OZS4/T3Ia9cod0oRbe/kxZEwCK4cz+pCvPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOInMzX42h/ixD6+8waVkHBCBk1f+JsQPBkhR55mlF3YqqUxFTJTvEYgY8leNx8jw4QpQsCarzNq3lD5K/ktqQVBo85zsxK9T+ubhyAXXzXUyNaq8e+hxgIFkWG58DTqZ6bl/dB7RG5cjC6tAqsQiHY8IeeE+/yvbSMGVbyVzRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SxVWhf0d; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715794537; x=1747330537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bMXMTNE3OZS4/T3Ia9cod0oRbe/kxZEwCK4cz+pCvPE=;
  b=SxVWhf0dOQ9u3zYiOlxY8I9KjC2xO4s8iMlBs6WPaeyBKVVDPvIiRor+
   bgH4f9yaUbaAXIYtnZquD5vejUYKnXLEK3eCykxleWccIerygPFcrF6wy
   C4n2OFMTNtb8CriIvgRPsZzpX19VGlGjDEiyliAjv4sc9oR1pVeMGp50n
   O1z2zrZ2BB7XHLZ7p8TQ/PH0ePc2szFRdKbpOcbtLsXlxNXuqsKK5I8aI
   iPKW0nZGvlwTm0U8HIMdQi7bEv19FCQrdDcIEsHfKP1wyPnvK4vfsljeU
   EIRtQmItTy4+lMX6+GY1nchMXm7G1GIvZoO+betIIRMWdPE7VePzStpXn
   g==;
X-CSE-ConnectionGUID: 7Knlw3k5TsOQ80L0Mx6cTQ==
X-CSE-MsgGUID: 2DJn9QUWTgmtZk1r708OCA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22465741"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="22465741"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 10:35:36 -0700
X-CSE-ConnectionGUID: ChK8VZQxRjCKrNmXGhQmDg==
X-CSE-MsgGUID: 8/AIo60qTcq2zS8LstgONg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31263346"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 10:35:36 -0700
Date: Wed, 15 May 2024 10:35:36 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, sagis@google.com, yan.y.zhao@intel.com,
	dmatlack@google.com
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240515173536.GE168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240515005952.3410568-11-rick.p.edgecombe@intel.com>

On Tue, May 14, 2024 at 05:59:46PM -0700,
Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

...snip...

> @@ -619,6 +776,8 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 */
>  	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
>  
> +
> +	role = sptep_to_sp(iter->sptep)->role;
>  	/*
>  	 * Process the zapped SPTE after flushing TLBs, and after replacing
>  	 * REMOVED_SPTE with 0. This minimizes the amount of time vCPUs are
> @@ -626,7 +785,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * SPTEs.
>  	 */
>  	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			    0, iter->level, true);
> +			    SHADOW_NONPRESENT_VALUE, role, true);
>  
>  	return 0;
>  }

This SHADOW_NONPRESENT_VALUE change should go to another patch at [1]
I replied to [1].

[1] https://lore.kernel.org/kvm/20240507154459.3950778-3-pbonzini@redhat.com/
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

