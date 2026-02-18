Return-Path: <kvm+bounces-71294-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMDqJ3NIlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71294-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:17:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E922F15ADDE
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BAC2303A844
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2CB3334688;
	Wed, 18 Feb 2026 23:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FvFulrru"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08138D
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456532; cv=none; b=DoSuQK3JjbVKJMPXTcoogy7AvmrByAyycHz7l09C2OFqpVDS/k1FNhrnY1Qy1ibnXCgPWpOXwO4ZUvR5SBv7LnQKdOZkjTTSj9jWJJSafNOo4+F5EvS5AV/7GDxwMrmNyt2nUSzNR+KwSiWj3jm8SY96qVXQuu/9wZZgiZ2Cfnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456532; c=relaxed/simple;
	bh=JVGyebwggzFLo4QTr11b83BjwjOQ4Vk1sipabHp/uaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRNSu/yoelRS/VNjp9/mf3KwclCE56WtD1lYMlx+4BeGjQlqj/Yhvc84AOUEfKmqQ16K9Fa7o0A7wDeqqx0nigieXnWYXyzIzqW8vnVb6GwhWSbVsmAjGz9oe90XieKvpNrifp3PazKg+a1Y5dnVrE5ZiIZ6xpHbsCplwQwQQeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FvFulrru; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Feb 2026 23:15:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771456528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y+3wQ5Sza20sMBTWsGhakDjJD8yCV1E+YfoSCsoquAg=;
	b=FvFulrruPqn7H4P2S5cAJrt2DGWwrMAloU2cxNob6b3WsTOK+Op52dtt+87oJCPqms3L2M
	mbtB70kmWfwkuLUiZGP8GUtvorlwQ9cdhZhT7IgSPZ2g43Xj+mhnAuWZs2U8t7HNuHVbl0
	TNRvISmDykIIrP8Po5hJRshvsOFipQQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] KVM: SVM: Explicitly mark vmcb01 dirty after
 modifying VMCB intercepts
Message-ID: <dfw3gcpk36jri774l42oseqxembnobtby7bl35uo6eawydwkto@cmlkbs3ponkb>
References: <20260218230958.2877682-1-seanjc@google.com>
 <20260218230958.2877682-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218230958.2877682-2-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71294-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim]
X-Rspamd-Queue-Id: E922F15ADDE
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 03:09:51PM -0800, Sean Christopherson wrote:
> When reacting to an intercept update, explicitly mark vmcb01's intercepts
> dirty, as KVM always initially operates on vmcb01, and nested_svm_vmexit()
> isn't guaranteed to mark VMCB_INTERCEPTS as dirty.  I.e. if L2 is active,
> KVM will modify the intercepts for L1, but might not mark them as dirty
> before the next VMRUN of L1.
> 
> Fixes: 116a0a23676e ("KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause filter count")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/nested.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd..66701106a51b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -128,11 +128,13 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	struct vmcb_ctrl_area_cached *g;
>  	unsigned int i;
>  
> -	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> +	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);
>  
>  	if (!is_guest_mode(&svm->vcpu))
>  		return;
>  
> +	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> +
>  	c = &svm->vmcb->control;
>  	h = &svm->vmcb01.ptr->control;
>  	g = &svm->nested.ctl;
> -- 
> 2.53.0.345.g96ddfc5eaa-goog
> 

