Return-Path: <kvm+bounces-34669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 491E0A03CB4
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 11:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E51F16101C
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 10:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911831E500C;
	Tue,  7 Jan 2025 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GLh4nNbj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117074C9D;
	Tue,  7 Jan 2025 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736246578; cv=none; b=Kkn/UtGJ+i6By5EP4N4egqn6IqkJt9PpkK1KKZEGUSYqi3jwYZ5RxvgikGuz9OAFDUQTHCVaU6E5fD5nCoZOK+UISjlV//raPm5iZlqoCraOA3OAMoHRbxUpxEEjwedGqGr3/ANife/Hz14Qnunvv/Ln0YmeFiOvRzssJxiYS5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736246578; c=relaxed/simple;
	bh=ToQSwTQShmPorM8Uvs5zDG/uK4jQ2rSTdK3g7WMF9vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYIS1fLhA5GUG9ol8APCIEET9BkfswcRDIQmjfDDqqRFfypFUsacbvGh22PYmGWpG/Qf+5TvJ6wxytuGr1epOVrpTXC5kGPD00+90wP7C7pQ1+QtC3mN3GRp4TnrsNdW+7JZ+tmdMfa38abX0NnxModh7yZ5NczDt6FcAlpp4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GLh4nNbj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ACFDA40E0266;
	Tue,  7 Jan 2025 10:42:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id W45F-y7Nlb7p; Tue,  7 Jan 2025 10:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736246565; bh=OhFg4vgi2p2BTMdB2hA5Ldsw3l33CNvIWxuc+0XlQDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GLh4nNbjTKruo3pRaAOXNJlcADaBosHY4g7ndTLQTQkzUzfkHIUZYWzLuUO6uPOnS
	 nVQVejYQEBVBgcyWLwd2F6GR5T1aRi7UkW1ROVRfVelJnQGW4JJ/b3+SMytlUy+QUB
	 Q4veydIqz53/KV0EvgdcD/UAwu0Ju29QlpaWLGs33f2SVGW3+/7Bv3a90iXTd6ohp/
	 jpBtnyDUSed4bSb62txt4BenMYo0Cz3QNZY1tvugRHoQlALQustQG+hmOmMREo2yuY
	 1+fbmtSNWJ++QFx+7q6jBBeBkljY+5x51fu+SowOTQ7DvfFe7M+9x7yOVGQx3tlROw
	 rb0rp32sSWdXNCK2lwo097Jrbkqy34U1mpVOW3uXl4GbT5iEdQx6gjnO6lG3w7jYF+
	 FBrp3jwnD5YBo4Fru3uAVPyQ59nS5XtC/oftjHTM40pjrxnHaEdMFRry0xzyz29BEj
	 cWCXPslCl4QtzIuVUu+hcoWcWaRp519E10iosDbepGAwtneA3sA5UNfdDpBeYLHPcw
	 P/HZuLbsWYxB53DvFXnyMXNcF0zFR7ZKuitd47bjSMX1d+vBlDxWwruKxHDkayuWcO
	 zM9fxzGXC16D7N3HRUkJEEjGRIvTHqbh6nlG+/9TpHObObnvaLA9hVJAtHPXn2E2P0
	 vOnHR0KSlgiP1g3AvQ0sQfVI=
Received: from zn.tnic (p200300ea971F93E8329c23ffFEa6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93e8:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 963D440E0163;
	Tue,  7 Jan 2025 10:42:33 +0000 (UTC)
Date: Tue, 7 Jan 2025 11:42:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250106124633.1418972-6-nikunj@amd.com>

On Mon, Jan 06, 2025 at 06:16:25PM +0530, Nikunj A Dadhania wrote:
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 0f81f70aca82..715c2c09582f 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -97,6 +97,10 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>  	case CC_ATTR_GUEST_SEV_SNP:
>  		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
>  
> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
> +		return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&

This is new here?

> +			(sev_status & MSR_AMD64_SNP_SECURE_TSC);
> +

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

