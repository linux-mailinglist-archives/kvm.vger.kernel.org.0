Return-Path: <kvm+bounces-29575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AB29AD11C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 18:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2D7C1C215F4
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744C01CBEAA;
	Wed, 23 Oct 2024 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QldgTxo3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3183055C29;
	Wed, 23 Oct 2024 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729701412; cv=none; b=AXL1MCuIC8n6D9nt35HBhdM5Jgr/EoE1FYq1IMlYuhiTt26QzYSD9AkE3VwaK3JX14L4xO6ZQ+u0v7hkOCiRbkCTDL2YmbYU3SdP+kgkvs/zpNRRqtkQgAkwJ020ms1MDLfb3CmSzGs0Fs9jjd2pzCtH6mK7SA0Sti/Iy11EvU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729701412; c=relaxed/simple;
	bh=lcQqnPRwBbySYqVbc4NvyiNATFNLotniwalM4Qll9sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aN0+V5tZPdYgr3aPJy7Yh8rrd7y5++p1gceSOIpVcTSmQkN+dJapWh4UhphRAPluU8XSn9FUp2+C7S4THzIjBaR2sAYNyY+eQnlFbBTqDF1rQ/EVxo7IEVNsiuRvvtiSihcMF4GG5qnU9cvFBOWfN2oTbjuvrmRZ3bB+/mWmQ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QldgTxo3; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F162A40E0284;
	Wed, 23 Oct 2024 16:36:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wPqrMK0mrn0d; Wed, 23 Oct 2024 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1729701404; bh=ziKteH5nfXbarEbCPwq6+vnEM5k9YyOPuCeee59ZCT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QldgTxo3AsGrUKc97C4GT3QMF4DDxWYg/0YUCQ84OZd+A2scAyIkEq+m/wDLah9rZ
	 HAPXLZFBbgcT4v8O5m/vHV5SLheOe1+45fctHHEDIm7Mi4fhXXz889yZHefHD1sxkK
	 tu4QK5kwy4vuohoOn3VS0VQlHTL2EaxzgLl7Ug5dKz8HR1xQAYnm/MQBIuUPq5dOh1
	 LsCCOSa0Rsfb0rlbJA2qxrlIcZ/qc4ClcFYwbDClCOmeC0hZf56RMfWn1HaUsKkZr2
	 E/6pA/KTHcBAQR3ru2saP41WxcOhGYMMe2MdSCb1VNTo1eaQMo4gtSSYa6F7fHasON
	 WNeuYGNVzbUM4ai/P8YmBwzvODVJDCvRAnOLxhAS4WMUFvL8uNHRO3cA4EoaxQZIu9
	 PAdAYetcfj8SYWvHE4Gr/cOKdBl+i9AdqFGxii3nxxJxMahjbk8ee2T/BnPLQ6pUoK
	 VTfO503IRaW6APe5CvOnZcl4cqs7DtW21nANuOW7zfTshOGiXtoW7mwUObdMRzRyzd
	 AwsV8/Ega4Ei2Ub2wJ7B5LeiibbzosYPqh85TdPivD4+K5IRedf/1zBME4RUOPuDL0
	 wFlAfRH5v75ZTOe91RZHLEjSeqkTDhfg+Ao8Q0Za984j2ZkK2rkRPtOGOtMa7SCiYg
	 /Z4ODK0h8W9HNs6+5nuee4Q8=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7A28640E0198;
	Wed, 23 Oct 2024 16:36:27 +0000 (UTC)
Date: Wed, 23 Oct 2024 18:36:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
Message-ID: <20241023163626.GKZxkmCi8ZyyCZlkrX@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>

On Fri, Sep 13, 2024 at 05:06:53PM +0530, Neeraj Upadhyay wrote:
> @@ -61,8 +65,30 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>  	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>  }
>  
> +static void x2apic_savic_setup(void)
> +{
> +	void *backing_page;
> +	enum es_result ret;
> +	unsigned long gpa;
> +
> +	if (this_cpu_read(savic_setup_done))

I'm sure you can get rid of that silly bool. Like check the apic_backing_page
pointer instead and use that pointer to verify whether the per-CPU setup has
been done successfully.

> +		return;
> +
> +	backing_page = this_cpu_read(apic_backing_page);
> +	gpa = __pa(backing_page);
> +	ret = sev_notify_savic_gpa(gpa);
> +	if (ret != ES_OK)
> +		snp_abort();
> +	this_cpu_write(savic_setup_done, true);
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

