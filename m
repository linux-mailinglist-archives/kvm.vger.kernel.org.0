Return-Path: <kvm+bounces-59748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4FDBCB310
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD6624F11B3
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE7F288500;
	Thu,  9 Oct 2025 23:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Os0kfGXx"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D362882D6;
	Thu,  9 Oct 2025 23:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760052284; cv=none; b=I7FgIpPZOvt9rq75VPllogzkylupGuVnBoTl5Cyd+TrsTLBZgvTj0xLLRfq8mY7isu54CG02fzVh5jARasJK2RRFs5ERrJRuKoMnYBDFG2DDOZQfZoCVONwNxIyFq+WZW5UFPT9YxLWKKJ5dgLO0YzPGtSy7kI7Z7v+uTqEobTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760052284; c=relaxed/simple;
	bh=o8PdJ3n/YRXUj29SjUpYCdemP3gvUweb7laI7SlAjag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aS0mdi/8zHlyGEJklzDO0rMq/3WgMm9MuS3IiKs47T1rvBXgDCkUsaHpa8qrmjKmzstJNhyZ/IfKAEoiWKeYvt4A+aV5ZBKECo8B/XT7ATxPSNmiGHfbv2ENjwpQU+rsh3OSH0HMReCNh58fTI2MBcPu+FsauUZSV4UTZh+okaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Os0kfGXx; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 9 Oct 2025 23:24:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760052280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ekzv12FLqXXEjwVTA45Ve5RsD0RRxaYzJjsJt90hwTc=;
	b=Os0kfGXxsd/BsZZICxoOqt27qPB9SCL6CgptTs+6QWoaqMtTeQ32EFtGth9bqJeUUD3MUA
	ZwOm1alhYyTCDzVSQf6da1qBPuziQowbd5hUPS8GC8sPoFXiyB9yL9/Zzhwkwu8Cl0nCjM
	YSZk/d12JDz95pHaeiyB/Qs0SKzEPBI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF
 when SVME==0
Message-ID: <afzbx3uqqag6s4zfvpnlg7cjcev25zixkidor4xhuu7fudtdh2@tki2ahvkrttt>
References: <20251009223153.3344555-1-jmattson@google.com>
 <20251009223153.3344555-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009223153.3344555-2-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 09, 2025 at 03:31:33PM -0700, Jim Mattson wrote:
> GIF==0 together with EFER.SVME==0 is a valid architectural
> state. Don't return -EINVAL for KVM_SET_NESTED_STATE when this
> combination is specified.
> 
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/nested.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index a6443feab252..db0d4f2b128c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1798,8 +1798,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
>  	 */
>  	if (!(vcpu->arch.efer & EFER_SVME)) {
> -		/* GIF=1 and no guest mode are required if SVME=0.  */
> -		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
> +		/* GUEST_MODE must be clear when SVME==0 */
> +		if (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)
>  			return -EINVAL;
>  	}
>  
> -- 
> 2.51.0.740.g6adb054d12-goog
> 

