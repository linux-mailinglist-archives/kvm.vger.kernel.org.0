Return-Path: <kvm+bounces-55647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFFCB34752
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 18:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 291EE7AA19D
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFEE3009E6;
	Mon, 25 Aug 2025 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EgP85DD6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E702EDD64;
	Mon, 25 Aug 2025 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756139343; cv=none; b=Yq45tL5I7jqxDXYX3yinKw/H7ZaWDQMGSqfR4g+ZrJVXr4UOknf67hGkXgMJQEMKADLLX6wvb9AZ1Y7TbZbNciS29r8fOD+p43HFlXnlmrD2SBK5lrLK8unCMtKc2W+nrFiGGyOQNqRJbLuAnDpGwsmZRzhzLUGpE/byac1QlTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756139343; c=relaxed/simple;
	bh=QPg1eQm7+d3FwWtNq14oUCU6BZDeNGKCjsgcPb8E4m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElQTvoOxmnJ/Hc2Oi9KCoOut1MbiXXi0c1iGutTXZyx3zMfxHIHUiSoY+Q10JBG8XhMD/12j+BihcwIPbWG0SGH5GJObRgLDouy5Yid9kH9xQiuPAMt1/9X9GTa1kVvCcqhicmuIKEA/J5A6FDuSg1OQo5+EjuyVtiaCX7fuX6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=EgP85DD6; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DB7E240E016C;
	Mon, 25 Aug 2025 16:28:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nab_Xuzv7lIN; Mon, 25 Aug 2025 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756139329; bh=FBgYgjhAvEXhzB7paQSxZ9R4hBpErOpDYpNpZuJo2Bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EgP85DD6rC1uZsZ4mUPdgBnR5UBeSA/sO/olRVdG2nc5OHWMbSKj0rFAPkcW9J9kP
	 G0vQge08P6XfYjHTYtwAxta2oWqyT+YK8N3UrOAN0uwIGJ9Sv8/D/m20mzoAxe/Kvi
	 c//fFLOsjIsXoECQaSJfOCuxbT8S7N2QPBY6QVI1s2+szpmnRpspYWwYMMdr+kL4l5
	 rzBVYIhsxwMSAUs9Q4oLBQj5f/STt7+n98mrmPJVOqGjRc1Gi7oNsIRKow+uk7xoYD
	 NnGz8uAbALutRWy64T8/XRHAdjDgw24Kc+39wYdFv3c0WGW9QIbI7pDzJAbnD2Jcko
	 LwDys1E+kXtv4ui0DNb0CHOXg8hHF12oGi5e7RH3g7Sh94I4WBMoym5N0cc3k9NFFk
	 Dto6PlMY9QmtNRQm5VTK9ygKEWym1z+U8Ty2NuxUv+iUOQSsixAfbEgfbsH7UN/XXu
	 kvYxFRAjPlF27NXskHPMA/pzWOKa0lanwnCerBY1nj72Q+9pgzdRnIbIHswW0/xIA8
	 rjc3CQg0YTQBoYjDkaS8dfRB9nMHaPiGiynFQNI5bsW3EuaHkxbHNZ63IhOzRnw9Hw
	 weM37hcNgjb0tr2o1Plm2xJrhR+vGpgEW+noTzt9NCO7duNx8vxzd+ChcaEhFlOIqD
	 TH4GHDWVW7/hvA1VWU4QlWOM=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3077240E01A1;
	Mon, 25 Aug 2025 16:28:28 +0000 (UTC)
Date: Mon, 25 Aug 2025 18:28:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, seanjc@google.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
	kvm@vger.kernel.org, huibo.wang@amd.com, naveen.rao@amd.com,
	francescolavra.fl@gmail.com, tiala@microsoft.com
Subject: Re: [PATCH v9 17/18] x86/sev: Prevent SECURE_AVIC_CONTROL MSR
 interception for Secure AVIC guests
Message-ID: <20250825162820.GDaKyPJLxPD-sZ8YWP@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-18-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-18-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:43PM +0530, Neeraj Upadhyay wrote:
> The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
> page and bitfields to control enablement of Secure AVIC and NMI by
> guest vCPUs. This MSR is populated by the guest and the hypervisor
> should not intercept it. A #VC exception will be generated otherwise.
> If this occurs and Secure AVIC is enabled, terminate guest execution.
> 
> Reviewed-by: Tianyu Lan <tiala@microsoft.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v8:
>  - No change.
> 
>  arch/x86/coco/sev/vc-handle.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
> index fc770cc9117d..e856a5e18670 100644
> --- a/arch/x86/coco/sev/vc-handle.c
> +++ b/arch/x86/coco/sev/vc-handle.c
> @@ -414,6 +414,15 @@ enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
>  		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>  			return __vc_handle_secure_tsc_msrs(regs, write);
>  		break;
> +	case MSR_AMD64_SECURE_AVIC_CONTROL:
> +		/*
> +		 * AMD64_SECURE_AVIC_CONTROL should not be intercepted when
> +		 * Secure AVIC is enabled. Terminate the Secure AVIC guest
> +		 * if the interception is enabled.
> +		 */
> +		if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
> +			return ES_VMM_ERROR;
> +		break;

In light of the recent secure TSC MSR discussions, let's see if Sean really
wants to do two different things for reads and writes here too...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

