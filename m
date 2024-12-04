Return-Path: <kvm+bounces-33095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0489F9E486B
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 00:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E2061880563
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 23:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB741F541D;
	Wed,  4 Dec 2024 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xk1r79Rj"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EDB1AB6D4
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 23:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733353662; cv=none; b=mqrrCsWAOag3QTdXulw1OMIAdHKcfUIRH6G/OA+7Bc1ZbPIB4YRZjt8MVXZcpDqT/+NLQd7KQGnCQF+yt6WqU7QDWzP5sPA7uhC+9zhcGovOkFIqKp0zr7KmwIAfvD/hu7CVjKrSl7xms73WYrsnXpCZ6+kH8fF6ZmFMhMMc46Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733353662; c=relaxed/simple;
	bh=qNj1yw5cwuK310Hud/aNqTEbGoEkUBx/cyZRJ9/mwlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iAEErfgCr2gTYDHxw7XR++SCjrEC5mUEFqMHqNT0heaTpGbgmTPyocIoeAjKFf2arijfj47VplfTwRfh8hWcBVrWzYD1HQ6v7BhGVLK9grSBXw2MdcnZFP8frNLMmu2yn286Zvjm4OGednGVnMAV3hG/FikcrTnruW/tpRaGuNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xk1r79Rj; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Dec 2024 15:07:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733353658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BmRuvCEl+afeDDoFH+S4Ae7biN9cmirFzO8povIhSlU=;
	b=xk1r79Rje9lKH6Gxehv7Myok+SqBGaILt9N1vHxuCICfEcxyKTF+uj/5FJp++2mvkSZ0Oe
	dmE/wZBmxgrtmkSEAoa/27/kNUUZHboEzkpcwY+yvUQvkXDeySUVhY/vfWptdCso/3Zca7
	r2bcl0ynh2WdL4KV0CjZUT2HyksinF4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, Wang@google.com,
	Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
Message-ID: <Z1Dgr_TnaFQT04Pi@linux.dev>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <20241204191349.1730936-7-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204191349.1730936-7-jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT

Hi James,

On Wed, Dec 04, 2024 at 07:13:41PM +0000, James Houghton wrote:
> Adhering to the requirements of KVM Userfault:
> 
> 1. When it is toggled (either on or off), zap the second stage with
>    kvm_arch_flush_shadow_memslot(). This is to (1) respect
>    userfault-ness and (2) to reconstruct block mappings.
> 2. While KVM_MEM_USERFAULT is enabled, restrict new second-stage mappings
>    to be PAGE_SIZE, just like when dirty logging is enabled.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>   I'm not 100% sure if kvm_arch_flush_shadow_memslot() is correct in
>   this case (like if the host does not have S2FWB).

Invalidating the stage-2 entries is of course necessary for correctness
on the !USERFAULT -> USERFAULT transition, and the MMU will do the right
thing regardless of whether hardware implements FEAT_S2FWB.

What I think you may be getting at is the *performance* implications are
quite worrying without FEAT_S2FWB due to the storm of CMOs, and I'd
definitely agree with that.

> @@ -2062,6 +2069,20 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				   enum kvm_mr_change change)
>  {
>  	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +	u32 changed_flags = (new ? new->flags : 0) ^ (old ? old->flags : 0);
> +
> +	/*
> +	 * If KVM_MEM_USERFAULT changed, drop all the stage-2 mappings so that
> +	 * we can (1) respect userfault-ness or (2) create block mappings.
> +	 */
> +	if ((changed_flags & KVM_MEM_USERFAULT) && change == KVM_MR_FLAGS_ONLY)
> +		kvm_arch_flush_shadow_memslot(kvm, old);

I'd strongly prefer that we make (2) a userspace problem and don't
eagerly invalidate stage-2 mappings on the USERFAULT -> !USERFAULT
change.

Having implied user-visible behaviors on ioctls is never good, and for
systems without FEAT_S2FWB you might be better off avoiding the unmap in
the first place.

So, if userspace decides there's a benefit to invalidating the stage-2
MMU, it can just delete + recreate the memslot.

-- 
Thanks,
Oliver

