Return-Path: <kvm+bounces-56070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C86B398A5
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04EF5606F2
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9CF2F28F6;
	Thu, 28 Aug 2025 09:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCSsRWuQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3492EFD89;
	Thu, 28 Aug 2025 09:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756374054; cv=none; b=lBMLAIJ7mOpmkThKOBNOV17VbH4Xgo0FddAZOdp0lWS+Qj83wlmJbCFVrFspqMEeMjnATnJh3CgWHKdugUQ5k4dh0rktO3Mut4ouKs8SUlpUvPk4oOd3yJl+vvq7+NeuzFnLH/cS+FhzEXdQdjdD686zD2MJkvk3suvZI2rBolo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756374054; c=relaxed/simple;
	bh=S2nIO2fia4nOcAJAA4aJ1nbI0P53UKr+YGx1SqV+WGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IjSY7Jvh5HVhr+F2Skwtv5RpCpRgDMjHOx4dOcC2DGKs0YU+nOk3Y7eaIbF5hA01eXT7cECZ9VWTkii6sYZs6wh4jLlxHG4HVGFV5nw4rl7U62ag9Ux+Nvx76GRytF3N49raEhQDI2NxqAftnPnpleihj75hWKBD+tPJVhXMoN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCSsRWuQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC28C4CEEB;
	Thu, 28 Aug 2025 09:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756374054;
	bh=S2nIO2fia4nOcAJAA4aJ1nbI0P53UKr+YGx1SqV+WGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCSsRWuQKASTLR4YFpzIu94EZzHJOcjmc4itX5E7G+6KxauXQb0DI+fEechvxFALn
	 2GA5VFQU0CKNa5NgK84A0cFJxLOpaVAmqS4FPRRuO2MByFbGDkaHVelgplb/csDbsu
	 f/Q+8PsyU2vrFgswG0Jevr8OpylJUyKIXcRTMSPlCqbUunKPaVdxE5ziUrxwH8ZdYV
	 lneQLNSp1apqBA6tr5BFzo4TvxqbYCFwpUmEN+fOUw40NCje95PnIBhdL7qMmK2O8g
	 jI4wrTMNd0lqWKag2ghBX/XIwuf9A1X7lEGZRi23VKJfbb4hhE+gO6JRoCUSkCi1YW
	 ErQUrWlf6YLJA==
Date: Thu, 28 Aug 2025 11:40:51 +0200
From: Amit Shah <amit@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: Re: [PATCH v5 1/1] x86: kvm: svm: set up ERAPS support for guests
Message-ID: <aLAkI1PosfK0wDKZ@mun-amitshah-l>
References: <20250515152621.50648-1-amit@kernel.org>
 <20250515152621.50648-2-amit@kernel.org>
 <aKYBeIokyVC8AKHe@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKYBeIokyVC8AKHe@google.com>

On (Wed) 20 Aug 2025 [10:10:16], Sean Christopherson wrote:

[...]

> > +	if (tdp_enabled)
> > +		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);
> 
> _If_ ERAPS is conditionally enabled, then it probably makes sense to do this in
> svm_set_cpu_caps().  But I think we can just support ERAPS unconditionally.

[...]

> @@ -2560,6 +2563,8 @@ static int cr_interception(struct kvm_vcpu *vcpu)
>  			break;
>  		case 3:
>  			err = kvm_set_cr3(vcpu, val);
> +			if (!err && nested && kvm_cpu_cap_has(X86_FEATURE_ERAPS))
> +				svm->vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;

I missed this part in my reply earlier.

Enabling ERAPS for a guest is trickier in the no-NPT case: *if* the guest is
enlightened, notices the CPUID for ERAPS, and drops the mitigations, KVM needs
to ensure the FLUSH_RAP bit is set in the VMCB on guest CR3 changes all the
time.  Your change adds it - but only for the nested case.  It needs to do it
for the non-nested case as well.

I steered away from enabling it in the !npt case in the first place because it
was such a niche configuration that wasn't worth bothering and getting right
-- but since you've added it here, I'll go with it and drop the '&& nested'
part of the hunk above.

     	Amit

