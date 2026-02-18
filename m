Return-Path: <kvm+bounces-71296-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJrPGpVJlmngdQIAu9opvQ
	(envelope-from <kvm+bounces-71296-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:21:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE1515AE4E
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB58E3047062
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C8333AD99;
	Wed, 18 Feb 2026 23:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KADION3x"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB5E3321D7
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456853; cv=none; b=ias/6wP1rFBMX7u23sP/J3kn1Onzae/DhqHBxymg3g5qKSTAObTMynm453AM0hxes91Q2yLlEFUY01kbqj3joXqoCCCVRQKuFbFf31c+sG4mSdc0OtV/kaLIHfixX4Ck3yVdgOJTzY2RH9AHHwkweCV65R2vU7i1Y/lgXauJA4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456853; c=relaxed/simple;
	bh=CiTkcfT/A7jfY/vtJdT9AeDrK79BsKBNxB43Johegi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2a1nPT2mDBbh5YKyfo8ap7dfnueWH/pc6PIwF+tB11Vqyr6ATu1rreA0vTYEuinTRv9MC3oNrqWsEWs4q9OxjhPM4WSMDTnpRpw8vLIaxHpe3ZU/Iq7mzNWDbgp04NB8Pr77sJZ6jhx5W6YRLwfkyJRH/+4nw+h6zoNF9zLvvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KADION3x; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Feb 2026 23:20:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771456850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hj4EoZvWjCOrI+zVN2c5HXER/YVO+cBgMAeopkIJJmg=;
	b=KADION3x78V1wLiqg9/tgZNlYqvJScAnruSNa67lKQg2hYXle2pUI9bbuIV8XcPkdq2PyV
	EGAUEPm4RQAXhmGy9Bgy/buahPs7ay29h7R8H9DMmXmggaW1yyW8sVQzfGwlfocMjvQqaV
	k9WEqqaKusbhECJmoUw+0XIfWb1ZQdo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] KVM: nSVM: Directly (re)calc vmcb02 intercepts
 from nested_vmcb02_prepare_control()
Message-ID: <vpfyqn2ygw7xvzqz46wmb6kv6hs3mgvrsastehqw7gssqoakr7@7dir7jigcdvz>
References: <20260218230958.2877682-1-seanjc@google.com>
 <20260218230958.2877682-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218230958.2877682-5-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71296-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: CBE1515AE4E
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 03:09:54PM -0800, Sean Christopherson wrote:
> Now that nested_vmcb02_recalc_intercepts() provides guardrails against it
> being incorrectly called without vmcb02 active, invoke it directly from
> nested_vmcb02_recalc_intercepts() instead of bouncing through
> svm_mark_intercepts_dirty(), which unnecessarily marks vmcb01 as dirty.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 793f5d2eed3a..e8512de5aef7 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -916,7 +916,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	 * Merge guest and host intercepts - must be called with vcpu in
>  	 * guest-mode to take effect.
>  	 */
> -	svm_mark_intercepts_dirty(svm);
> +	nested_vmcb02_recalc_intercepts(svm);
>  }
>  
>  static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> -- 
> 2.53.0.345.g96ddfc5eaa-goog
> 

