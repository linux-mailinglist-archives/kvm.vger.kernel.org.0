Return-Path: <kvm+bounces-67833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2DDD15462
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 21:38:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9E807300922D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 20:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7043346FCB;
	Mon, 12 Jan 2026 20:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zs9Q/67I"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A288B33C50F
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 20:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768250293; cv=none; b=FyuyH12gKdSUUnXC/tHduipmmc4VQrIBfF4/ABcgTyDJvJSz3lqkaCC/78jOwzwsDJVczVnEziGcBfoV9k8dSesDpbXU/fVrSowqWX6CrVqZedvmnweK2k5d1dKTD0guK6d4bggF0XJDhcjCRbgVpp8TrJ2OIqcNt9Emg01D1qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768250293; c=relaxed/simple;
	bh=FiXHPBKhDIza5x3fMQ97MfU9RF4aXWIygIKilka/yyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QBqy7plSJUlUf8Ol2G/tOXiu1lh5MR/MkyfXjTKjxpktc3iqAkeaaFnjfZqwGDR/eNbLlzHu7AURtifKUoHkh2EUpFAWvD5PjsAmqEvWDzWCnkC4oU8p7TNWiykZxT+Jn6nWC/D499P79sq2zg00swICJgfiXK4YPz07v7JmBx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zs9Q/67I; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Jan 2026 20:37:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768250279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GSVBvecJh0Nsi33g4yzcMUnFbNTjBU1EnIBix3eMCDw=;
	b=Zs9Q/67IKNM/iKQ65aQd2H+OcmwGlWPLov8ngHVi2bzx4r6Honwv+/gkz/JfrGk+oGsUwG
	rTOyYHsuS8kc912cwnNTtLro9+QU/d/Deov9FoRbDSZAWL7spHlCPPX1DbaqFNc2qKcRtq
	T9u9GvIyEMilOi4r7bj2sLq0HsfaYrM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
Message-ID: <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
References: <20260112174535.3132800-1-chengkev@google.com>
 <20260112174535.3132800-2-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112174535.3132800-2-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 12, 2026 at 05:45:31PM +0000, Kevin Cheng wrote:
> Similar to VMLOAD/VMSAVE intercept handling, move the STGI/CLGI
> intercept handling to svm_recalc_instruction_intercepts().
> ---
>  arch/x86/kvm/svm/svm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 24d59ccfa40d9..6373a25d85479 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1010,6 +1010,11 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
>  			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
>  			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>  		}
> +
> +		if (vgif) {
> +			svm_clr_intercept(svm, INTERCEPT_STGI);

Could this cause a problem with NMI window tracking?

svm_enable_nmi_window() sets INTERCEPT_STGI to detect when NMIs are
enabled, and it's later cleared by svm_set_gif(). If we recalc
intercepts in between we will clear the intercept here and miss NMI
enablement.

We could move the logic to set/clear INTERCEPT_STGI for NMI window
tracking here as well, but then we'll need to recalc intercepts in
svm_enable_nmi_window() and svm_set_gif(), which could be expensive.

The alternative is perhaps setting a flag when INTERCEPT_STGI is set in
svm_enable_nmi_window() and avoid clearing the intercept here if the
flag is set.

Not sure what's the best way forward here.

> +			svm_clr_intercept(svm, INTERCEPT_CLGI);
> +		}
>  	}
>  }
>  
> @@ -1147,11 +1152,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
>  	if (vnmi)
>  		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
>  
> -	if (vgif) {
> -		svm_clr_intercept(svm, INTERCEPT_STGI);
> -		svm_clr_intercept(svm, INTERCEPT_CLGI);
> +	if (vgif)
>  		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
> -	}
>  
>  	if (vcpu->kvm->arch.bus_lock_detection_enabled)
>  		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

