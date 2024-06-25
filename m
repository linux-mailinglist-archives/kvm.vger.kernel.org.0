Return-Path: <kvm+bounces-20467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDAE916770
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 14:20:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F20EB1C24C96
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 12:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45912155305;
	Tue, 25 Jun 2024 12:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FDAu1hKA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844D413A25D;
	Tue, 25 Jun 2024 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719317993; cv=none; b=URSdIGslUoV2C+rogyhZ8sr1gXAM9My4/XaIe2W1ZNdoE5LPLE4s/iOT73fru8ta2Bftdl9e3r9XAUhX6+7McCOLz4nXTsHhRPBgOCu9rYOrHp1VMLJ4srZvhgRw4M2q1TgG71pM4nYtDuVKIkoH4OGwYsuB6Dmw3OhDgpzrdNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719317993; c=relaxed/simple;
	bh=0RVpCwdAgU0NJ55CoYDbC8R4ss3D2p4MWleGyhuaeOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AT5oYbpcJ06yEHjM6hVmJ86JXDc6GwHEHMoMQ/dsuOKtZI+NTPjyluSDG7+y/RQM8ey9CvUD9tRJHyBORNDHIwr7P0lWLv3vSLoeF//ytBL1PrxG1ajSLlA2r4SoGFun2Sdb0q2NbaU6LHR/RmE3cH5ilKbSGFiWPM0EOzvURvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FDAu1hKA; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8853F40E0219;
	Tue, 25 Jun 2024 12:19:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id VmN9FvopND9d; Tue, 25 Jun 2024 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719317983; bh=/27yZpePdJa5hqawOHey5vKXK7F/oPFDOaioyOFjvnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FDAu1hKAVlWi6E1V3f6yN1E9sBYMECMN0qNuv3SMQrC/uDqS1Fpc54Al42o+SpNpR
	 qdnjWTftsbQZwikhljtchgIpL0rtor1ylSAV0L1/pki27SMRg8P/nzk35MOD2sHNyv
	 sgAQqRWk5tYDUdM3l7sWEmHim2FsMyD1L5X69wJpDCAt/S1HRKgc3UFISujr/HA36u
	 hATSfUG3pOVWX4Uo/7VgthViFhIUplHILDBSi0ZFtmdldvbwGVX/mXqs+uCKpHSHwi
	 +vwqFfsJkP0C58/301cAQ7d2ukk+YAVU31Jkan6cqMVdklAfU+pS7RmdMUM0zoBWFY
	 kJRbmwfEd4LKJGUUu6GmUk053u+RqhH/66sFa+5MnSgmfXHAI6M4frybsh9MbeLXfk
	 E47u9GV68z4nQx6uiVbnB5stVyjOnGmv/1t5bUODHBMFRLo6brQj6Lpu/14fgKhXaC
	 D0dRFjmx/gGf2D+NOefJHS1Ugf7E0KeIxR0KjJ7L8ZpZ4y3TbxLbGLiqelexPczNIy
	 NnjncDhqjoYV56mxEKOosLHVV/xpY0KpouPXL5hfkWpj7TPaCCr4tHy8GXBBzyFrML
	 PKMYCBbCUB0zdA1Q7nQpP8FZTr1b8+phfwjxj+21imLZoTGGlFOo0yh30+3WGFTWDt
	 9TxyczAhIapTgCa/9cYe3JpM=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6137A40E0185;
	Tue, 25 Jun 2024 12:19:32 +0000 (UTC)
Date: Tue, 25 Jun 2024 14:19:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
Message-ID: <20240625121927.GEZnq1z90yeZFFvaM-@fat_crate.local>
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
 <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
 <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
 <fe74fd23-5a5f-9539-ba1e-fb22f4fa5fc1@amd.com>
 <20240624133951.GDZnl3JxlKXaIvrrJ3@fat_crate.local>
 <4fbcdcaa-3238-8dca-4d91-cb645187671e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4fbcdcaa-3238-8dca-4d91-cb645187671e@amd.com>

On Mon, Jun 24, 2024 at 11:42:44PM +0530, Nikunj A. Dadhania wrote:
> Sure, here is the new patch. I have separated the variable name changes to a new patch.

Right, please next time you send your set, sort the cleanups to sev-guest
first so that I can pick them up separately.

> 
> Subject: [PATCH] virt: sev-guest: Ensure the SNP guest messages do not exceed
>  a page
> 
> Currently, snp_guest_msg includes a message header (96 bytes) and a
> payload (4000 bytes). There is an implicit assumption here that the SNP
> message header will always be 96 bytes, and with that assumption the
> payload array size has been set to 4000 bytes magic number. If any new
> member is added to the SNP message header, the SNP guest message will span
> more than a page.
> 
> Instead of using magic number '4000' for the payload, declare the
> snp_guest_msg in a way that payload plus the message header do not exceed a
> page.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/virt/coco/sev-guest/sev-guest.h | 2 +-
>  drivers/virt/coco/sev-guest/sev-guest.c | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
> index ceb798a404d6..de14a4f01b9d 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.h
> +++ b/drivers/virt/coco/sev-guest/sev-guest.h
> @@ -60,7 +60,7 @@ struct snp_guest_msg_hdr {
>  
>  struct snp_guest_msg {
>  	struct snp_guest_msg_hdr hdr;
> -	u8 payload[4000];
> +	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>  } __packed;
>  
>  #endif /* __VIRT_SEVGUEST_H__ */
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 427571a2d1a2..c4aae5d4308e 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -1033,6 +1033,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	snp_dev->dev = dev;
>  	snp_dev->secrets = secrets;
>  
> +	/* Ensure SNP guest messages do not span more than a page */
> +	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
> +
>  	/* Allocate the shared page used for the request and response message. */
>  	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
>  	if (!snp_dev->request)
> -- 

Yap, that's exactly how stuff like that should be done:

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

