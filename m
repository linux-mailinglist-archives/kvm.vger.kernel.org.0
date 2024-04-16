Return-Path: <kvm+bounces-14782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C53C18A6EC0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:46:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 779512846B9
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2252412FF8F;
	Tue, 16 Apr 2024 14:46:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C91112F37F;
	Tue, 16 Apr 2024 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713278772; cv=none; b=KtboLXpcW26qxlkzzt0XBwiEA4aSJvP8j2gDe5XgRaqIjcf4KvhctXH22yH17OzJbXwk3vAMP0N8O9g/Z/1kKZ+MvPJQQCwmaPzTlqkjbMrxZNJUuawGVMua29w1qOcaxNkXKo+Wr7f+hpkWxPY7cx9KEHNM/VJDqVIwL8HV9AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713278772; c=relaxed/simple;
	bh=d81gaNfPfukpzkiqCd/WpjLfADwgO0JBtLOlCm82Qr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBCgxTAlAEz6DA0TCBzM7KuykF4qMu14g55lA5YoFF3d/tqr8+gITsCMfWX+hc8SXn6lPkJOtNRuS6NojnJMWPbYrQ64OZHUAJwSxKzwTX5I1QrUVT2cSLMZipKEf7a3l9EN2ASxFIRzFCe+nWxgRiqDs7bVczogTTOSm52JFjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E527A40E0177;
	Tue, 16 Apr 2024 14:46:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id L-M63d3ZGt_4; Tue, 16 Apr 2024 14:46:00 +0000 (UTC)
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D4C9040E00B2;
	Tue, 16 Apr 2024 14:45:48 +0000 (UTC)
Date: Tue, 16 Apr 2024 16:45:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 05/16] x86/sev: Cache the secrets page address
Message-ID: <20240416144542.GFZh6PFjPNT9Zt3iUl@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-6-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-6-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:17PM +0530, Nikunj A Dadhania wrote:
> +/* Secrets page physical address from the CC blob */
> +static u64 secrets_pa __ro_after_init;

Since you're going to use this during runtime (are you?), why don't you
put in here the result of:

	ioremap_encrypted(secrets_pa, PAGE_SIZE);

so that you can have it ready and not even have to ioremap each time?

And then you iounmap on driver teardown.

> +static void __init set_secrets_pa(const struct cc_blob_sev_info *cc_info)
> +{
> +	if (cc_info && cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
> +		secrets_pa = cc_info->secrets_phys;
> +}

Why is this a separate function if it is called only once and it is
a trivial function at that?

Also, can the driver continue without secrets page?

If not, then you need to unwind.

>  bool __init snp_init(struct boot_params *bp)
>  {
>  	struct cc_blob_sev_info *cc_info;
> @@ -2099,6 +2079,8 @@ bool __init snp_init(struct boot_params *bp)
>  	if (!cc_info)
>  		return false;
>  
> +	set_secrets_pa(cc_info);
> +
>  	setup_cpuid_table(cc_info);
>  
>  	/*
> @@ -2246,16 +2228,16 @@ static struct platform_device sev_guest_device = {
>  static int __init snp_init_platform_device(void)
>  {
>  	struct sev_guest_platform_data data;
> -	u64 gpa;
>  
>  	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>  		return -ENODEV;
>  
> -	gpa = get_secrets_page();
> -	if (!gpa)
> +	if (!secrets_pa) {
> +		pr_err("SNP secrets page not found\n");
>  		return -ENODEV;
> +	}

Yeah, no, you need to error out in snp_init() and not drag it around to
snp_init_platform_device().

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

