Return-Path: <kvm+bounces-59617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A536FBC2F71
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 01:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B259319A2311
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 23:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BD025C6F1;
	Tue,  7 Oct 2025 23:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kg4Z9XQi"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57C834BA35
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759880376; cv=none; b=XSvG7vyw4xZYd2KIYUXrnBC8RaDT3yX1bKkCOL1d7kg367+9LhMwBNndB85254WVebJs4jrYZ/szaG4zQRsBPlf8C4wcOk0i1OSfdX7bSvLAROJrnBUGsVsH+3SOGPZSp6e1ChoTwPAFRr7wOIE6B6vjki1mQmoCsDOSOx6mBn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759880376; c=relaxed/simple;
	bh=24rb9Du4342rlQ2DBh2B/QYsb4JodsZ5giDqXYHbIxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=InkqzalyZCCEV+EOwgnWptEKXiEBz/Vf1MSL+x0ZG1yy+dlvFW5lzoSNYab+ws1SqxcDSlBD/4eJqwxKijxvX5WYKEnUStNJDxx9e+89IFDo7qzVpWbwpiH4cYBKLavXzHq3PYBaVIFwvTR43j42qWyWdpw3QEDMdNv3eLshQiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kg4Z9XQi; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 7 Oct 2025 23:39:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759880371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lvcrei5rVeXQumVhk4cdRDTeWrEI/k9+lyKjbUq/Cs0=;
	b=Kg4Z9XQixOl2AS4Kzsp3BfnDmLN/mN+HpWmXX1lNt8y5nJg8D7t8KcKan9mpMrQdT+2zGk
	Cavgor87rC+Qtq1psPR2logvLKot4s46NlPgdzNngZiR6Rw9CaEVOybCnItUIrEyv+tpPI
	1CL5AgS66zZiqelVgvBhzkOzBi8XMiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Don't set GIF when clearing EFER.SVME
Message-ID: <lliivrmxbgxhovwdp7lg3dglyig7ql6fhs2ekufoxmvhfthd7m@3elodo2keern>
References: <20251007224405.1914008-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007224405.1914008-1-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 07, 2025 at 03:44:00PM -0700, Jim Mattson wrote:
> Clearing EFER.SVME is not architected to set GIF. Don't set GIF when
> emulating a change to EFER that clears EFER.SVME.
> 
> This is covered in the discussion at
> https://lore.kernel.org/all/5b8787b8-16e9-13dc-7fca-0dc441d673f9@citrix.com/.
> 
> Fixes: c513f484c558 ("KVM: nSVM: leave guest mode when clearing EFER.SVME")
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/svm.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3a9fe0a8b78c..5387851a96da 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -223,7 +223,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
>  		if (!(efer & EFER_SVME)) {
>  			svm_leave_nested(vcpu);
> -			svm_set_gif(svm, true);
>  			/* #GP intercept is still needed for vmware backdoor */
>  			if (!enable_vmware_backdoor)
>  				clr_exception_intercept(svm, GP_VECTOR);
> -- 
> 2.51.0.710.ga91ca5db03-goog
> 

