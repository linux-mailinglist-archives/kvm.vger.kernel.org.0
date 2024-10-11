Return-Path: <kvm+bounces-28641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE6D99A8A1
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 18:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AAB81C2206B
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 16:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24611990C4;
	Fri, 11 Oct 2024 16:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F08W18lJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A3519753F
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728663021; cv=none; b=MYpvU2TsWUYlXaoF+k/dit/gnOj35Z78+Pe2VCzBNmtMPZzmOh6atMOuo9kEU4bhhqwgObLE9Z8NdoZoQMGya6+ZepomOHh9pbDUtSkn0ZttX+k3hU5deFeV5EwPXTKm0/73yGqma/zNb8078l8h9K39SfceKJ5cgAX8DGWha/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728663021; c=relaxed/simple;
	bh=d5pFHwtFvdEgWUZAcnRG6GQ3fqVmE2YvgZoQxi52CO0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wyhoig9tWB8Xie8slSCnJt+FfYiJzUWEqT7kVoibiDZHciZljW+Jre3aSNZ13x7b9vECgQOoajWcf/NgxM5q6Q28qny8HHX3EeL/uGzIy3lk7gK3aTSzf2K57F0dvGNZjsMIvrvYKl+IhEDojDgOXmwoCOe5iM7jtVZHNiLSc6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F08W18lJ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e0228d71dso2109469b3a.0
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 09:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728663019; x=1729267819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HVwJLNw5Ps10RbGac9YYaUmT3BiISrVE9h+5ma8CIGM=;
        b=F08W18lJobjrwkrLZrWpss9qJIzMbjneHrzttJJ79DQBbNdhOjNHqlgd/jBH7g8pL9
         qqDXxzCk1HgD88JwHDCRBqm0qG9QK8s/TDQIDhF8pGP/MQz3q6wGeRFlj4FjARoSZirr
         JyAo/y1n77tI2ZWAJLhE68rcXPfZBFRNFPhHYu++Pn3yWP9REKP5Knkmi2tK7XOrnbwm
         VmdLAwN5OwQydx6K9crv4Rka4Agwx2d3ZUmECZVa8Z9f24xqGC3PFQyk5JoR2weUL3gl
         BtQjX/1Q+e64aWP5YWm73oxJaXjdxsNhkllEcLgboIS4qeIrVn8o0qKGjT34w7deOb9W
         Ldng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728663019; x=1729267819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HVwJLNw5Ps10RbGac9YYaUmT3BiISrVE9h+5ma8CIGM=;
        b=UURYf+BX8P+fJEoxMH+BBm/V0/zhftqmOM+GK1T3ecgrF/tVNVB17yhCgUaGt0T9R8
         J4ma6KbHpqT6FJaPyhaPdE5RNok5AyyueEasrtju3Y9GXmKKgsVmfsqXM3y1gZvCZs7w
         X2BDue1OErfvfOTW+fRJqCZRnyQodb6a3/CM2qlxeRVPQlPJrmPCCfM+PN49FJR0Fbta
         sb0Z4wIAEGGhAe5tBDk8mjmWDxsuj+a4tzszOTlBNH59LbhAK1K1UOeNWUJ8YpwJXlGd
         BMtf7PRp5L43o+jHMnEiocxGSGoPLzfhzI165qxQ2XCPk/OidJb2Rf0lYKeFQELiuv0U
         lkMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxtQGeG9oL2OlTtXndPKLcihJwa7E5ynlbrHyRpGMR/wSDAZiM1f13xGnuVMODnFqzGtg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmIb5DVcs7tyxbAXwf16dJSYGDMcarZKUbCDMdE5qRvaqMJQfc
	u1T7tSNKVp7SAGSJFg1nioB19dGNW+HT8XDHPyrvsSCYcmJjo0jyH+wgZFSIOzTrD74mzcM22gB
	iOw==
X-Google-Smtp-Source: AGHT+IGoDuPK1quyryPvVDgAPQ7itiit1nAYgQ/fI7GScyXvb9WdEI+uZk7WOGNdYtn/6ZPqBjhCnrVE/8g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:66d7:b0:717:8ab0:2439 with SMTP id
 d2e1a72fcca58-71e382709f5mr5535b3a.6.1728663018282; Fri, 11 Oct 2024 09:10:18
 -0700 (PDT)
Date: Fri, 11 Oct 2024 09:10:16 -0700
In-Reply-To: <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
Message-ID: <ZwlN6F__ls3naxJq@google.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au, 
	x86@kernel.org, john.allen@amd.com, davem@davemloft.net, 
	thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 17, 2024, Ashish Kalra wrote:
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 564daf748293..77900abb1b46 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -73,11 +73,27 @@ static bool psp_init_on_probe = true;
>  module_param(psp_init_on_probe, bool, 0444);
>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>  
> +static bool cipher_text_hiding = true;
> +module_param(cipher_text_hiding, bool, 0444);
> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");
> +
> +static int max_snp_asid;

Why is this a signed int?  '0' is used as the magic "no override" value, so there's
no reason to allow a negative value.

> +module_param(max_snp_asid, int, 0444);
> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
> +
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>  
> +/* Cipher Text Hiding Enabled */
> +bool snp_cipher_text_hiding;
> +EXPORT_SYMBOL(snp_cipher_text_hiding);
> +
> +/* MAX_SNP_ASID */
> +unsigned int snp_max_snp_asid;
> +EXPORT_SYMBOL(snp_max_snp_asid);

There is zero reason to have multiple variables.  The module param varaibles
should be the single source of true.

I'm also not entirely sure exporting individual variables is the right interface,
which is another reason why I want to see the entire "refactoring" in one series.

>  static bool psp_dead;
>  static int psp_timeout;
>  
> @@ -1064,6 +1080,38 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static void sev_snp_enable_ciphertext_hiding(struct sev_data_snp_init_ex *data, int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +	unsigned int edx;
> +
> +	sev = psp->sev_data;
> +
> +	/*
> +	 * Check if CipherTextHiding feature is supported and enabled
> +	 * in the Platform/BIOS.
> +	 */
> +	if ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +	    sev->snp_plat_status.ciphertext_hiding_cap) {

snp_cipher_text_hiding should be set to %false if CipherTextHiding is unsupported.
I.e. the module params need to reflect reality.

> +		/* Retrieve SEV CPUID information */
> +		edx = cpuid_edx(0x8000001f);
> +		/* Do sanity checks on user-defined MAX_SNP_ASID */
> +		if (max_snp_asid >= edx) {
> +			dev_info(sev->dev, "max_snp_asid module parameter is not valid, limiting to %d\n",
> +				 edx - 1);
> +			max_snp_asid = edx - 1;
> +		}
> +		snp_max_snp_asid = max_snp_asid ? : (edx - 1) / 2;
> +
> +		snp_cipher_text_hiding = 1;

s/1/true

> +		data->ciphertext_hiding_en = 1;
> +		data->max_snp_asid = snp_max_snp_asid;
> +
> +		dev_dbg(sev->dev, "SEV-SNP CipherTextHiding feature support enabled\n");
> +	}
> +}

