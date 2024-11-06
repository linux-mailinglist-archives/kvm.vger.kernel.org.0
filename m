Return-Path: <kvm+bounces-31022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D4F9BF50F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E5811F21B6B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25BF20821A;
	Wed,  6 Nov 2024 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UbXwfjMt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B91A204934;
	Wed,  6 Nov 2024 18:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917046; cv=none; b=b/yq9Nb8ivw2AbMdRwKjNXkuL0rVRMGIHfm8FKlFajbEWl0wjgsAroMF/mOq+ynB4JimcchGdypYwKEPeggGC14srgjFrOQZ8pb8wxJ85VCtSrDsMR17QJYChoOrqw1rq3UCVYj0+3nbPhHgqO7XuwCJGUyLq2N4kr7ODUyB6lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917046; c=relaxed/simple;
	bh=iOz1kyK1h6dpyS+gFYdERgAcIkwyLqV7rqyjyDHqGME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJ/o1dcG0/Hq5mCIR4LwKRY/2r6nLK/ZGgmvvYFn8w+hSCPtkBfAdFlihtI2Q0Nf8Q4yTnlc5/0ifTg7RGUzx4hYjXV+kQtavrGwsYavU/R9FF8HWOlFuctIdMOzsfujFWNNOov8OPdRC7iihm7fGa7Zkwcj01s8y9OpzZogO+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UbXwfjMt; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9334640E0163;
	Wed,  6 Nov 2024 18:17:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mhpTMvEGzZ3n; Wed,  6 Nov 2024 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730917037; bh=ZCw6KZ56wNE+x3+fx0qZaa5aMg59QwoMP17Ar6mfZ0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UbXwfjMtVaJKDReZ5xCe0stdzqv3JKcqAoFkjgtD4EyXqJHonBgTUAW3ZziahTcKG
	 F5zGxxGayLyGEXocmrKfMvlgzg3uvCOwXPBHUWtF3/8Rg8k/l9XyY9gwbhErZhoizi
	 HGXIjVUViDyobGE11uYx3ubolPXUEGnn+V+czkb1OMCjrGuzDvqkWr5VlwDc5U/81G
	 uawT+mK8yLsKsrZCtQn7ky/U9oyUJH5XFB/pcsb7CcwdCZePZjOgLSv0zTXLL/3fly
	 z9OHJrtJ6cx7gRbHpjVMNwcf6a9SKPJoquK9/xVQ1BzHXHqbadCx0j0sTCp3MU8Nwz
	 DAWH+nt7NVjRt9YhJvoRXdYqAHpCy3xcBe1bxZRa+XBWLjgHMWU0E2hRSOAI7tdjV4
	 XnSFsNXrIZOJJYEdVtYsHecY47CRw66+zS+PHyrTJyKHVGqhA5MXm4TBWO2OvObJdf
	 Qj6QM6rowrjzMSdCquFsnKqEsEpqzUpcZC21iEmtBJD9ias3tPtOYWreh0/v2o408j
	 xiBiq1BEYshdlpBSnZlPkIxKj4jGt9DU1q2jcxr+3zqD0QM53AQZcKeBpZM7C8nF8Z
	 UqEsjSOubt0Lq+lVXoTuKMB8+Q0DAvn5PE9RpFwmfc6u5Un2SHp2PWGjK9XrGp02km
	 OLF/VpS2XzUKuScLsDNwnkpY=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6F91140E0169;
	Wed,  6 Nov 2024 18:17:00 +0000 (UTC)
Date: Wed, 6 Nov 2024 19:16:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
Message-ID: <20241106181655.GYZyuyl0zDTTmlMKzz@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>

On Fri, Sep 13, 2024 at 05:06:54PM +0530, Neeraj Upadhyay wrote:
> @@ -24,6 +25,108 @@ static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
>  }
>  
> +static inline u32 get_reg(char *page, int reg_off)

Just "reg" like the other APICs.

> +{
> +	return READ_ONCE(*((u32 *)(page + reg_off)));
> +}
> +
> +static inline void set_reg(char *page, int reg_off, u32 val)
> +{
> +	WRITE_ONCE(*((u32 *)(page + reg_off)), val);
> +}
> +
> +#define SAVIC_ALLOWED_IRR_OFFSET	0x204
> +
> +static u32 x2apic_savic_read(u32 reg)
> +{
> +	void *backing_page = this_cpu_read(apic_backing_page);
> +
> +	switch (reg) {
> +	case APIC_LVTT:
> +	case APIC_TMICT:
> +	case APIC_TMCCT:
> +	case APIC_TDCR:
> +	case APIC_ID:
> +	case APIC_LVR:
> +	case APIC_TASKPRI:
> +	case APIC_ARBPRI:
> +	case APIC_PROCPRI:
> +	case APIC_LDR:
> +	case APIC_SPIV:
> +	case APIC_ESR:
> +	case APIC_ICR:
> +	case APIC_LVTTHMR:
> +	case APIC_LVTPC:
> +	case APIC_LVT0:
> +	case APIC_LVT1:
> +	case APIC_LVTERR:
> +	case APIC_EFEAT:
> +	case APIC_ECTRL:
> +	case APIC_SEOI:
> +	case APIC_IER:

I'm sure those can be turned into ranges instead of enumerating every single
APIC register...

> +	case APIC_EILVTn(0) ... APIC_EILVTn(3):

Like here.

> +		return get_reg(backing_page, reg);
> +	case APIC_ISR ... APIC_ISR + 0x70:
> +	case APIC_TMR ... APIC_TMR + 0x70:
> +		WARN_ONCE(!IS_ALIGNED(reg, 16), "Reg offset %#x not aligned at 16 bytes", reg);

What's the point of a WARN...

> +		return get_reg(backing_page, reg);

... and then allowing the register access anyway?

> +	/* IRR and ALLOWED_IRR offset range */
> +	case APIC_IRR ... APIC_IRR + 0x74:
> +		/*
> +		 * Either aligned at 16 bytes for valid IRR reg offset or a
> +		 * valid Secure AVIC ALLOWED_IRR offset.
> +		 */
> +		WARN_ONCE(!(IS_ALIGNED(reg, 16) || IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)),
> +			  "Misaligned IRR/ALLOWED_IRR reg offset %#x", reg);
> +		return get_reg(backing_page, reg);

Ditto.

And below too.

> +	default:
> +		pr_err("Permission denied: read of Secure AVIC reg offset %#x\n", reg);
> +		return 0;
> +	}
> +}
> +
> +#define SAVIC_NMI_REQ_OFFSET		0x278
> +
> +static void x2apic_savic_write(u32 reg, u32 data)
> +{
> +	void *backing_page = this_cpu_read(apic_backing_page);
> +
> +	switch (reg) {
> +	case APIC_LVTT:
> +	case APIC_LVT0:
> +	case APIC_LVT1:
> +	case APIC_TMICT:
> +	case APIC_TDCR:
> +	case APIC_SELF_IPI:
> +	/* APIC_ID is writable and configured by guest for Secure AVIC */
> +	case APIC_ID:
> +	case APIC_TASKPRI:
> +	case APIC_EOI:
> +	case APIC_SPIV:
> +	case SAVIC_NMI_REQ_OFFSET:
> +	case APIC_ESR:
> +	case APIC_ICR:
> +	case APIC_LVTTHMR:
> +	case APIC_LVTPC:
> +	case APIC_LVTERR:
> +	case APIC_ECTRL:
> +	case APIC_SEOI:
> +	case APIC_IER:
> +	case APIC_EILVTn(0) ... APIC_EILVTn(3):
> +		set_reg(backing_page, reg, data);
> +		break;
> +	/* ALLOWED_IRR offsets are writable */
> +	case SAVIC_ALLOWED_IRR_OFFSET ... SAVIC_ALLOWED_IRR_OFFSET + 0x70:
> +		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)) {
> +			set_reg(backing_page, reg, data);
> +			break;
> +		}
> +		fallthrough;
> +	default:
> +		pr_err("Permission denied: write to Secure AVIC reg offset %#x\n", reg);
> +	}
> +}
> +
>  static void x2apic_savic_send_IPI(int cpu, int vector)
>  {
>  	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
> @@ -140,8 +243,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
>  	.send_IPI_self			= x2apic_send_IPI_self,
>  	.nmi_to_offline_cpu		= true,
>  
> -	.read				= native_apic_msr_read,
> -	.write				= native_apic_msr_write,
> +	.read				= x2apic_savic_read,
> +	.write				= x2apic_savic_write,
>  	.eoi				= native_apic_msr_eoi,
>  	.icr_read			= native_x2apic_icr_read,
>  	.icr_write			= native_x2apic_icr_write,
> -- 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

