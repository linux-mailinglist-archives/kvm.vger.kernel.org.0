Return-Path: <kvm+bounces-10112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA44869F1A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:28:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A0731C25992
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B11149DEA;
	Tue, 27 Feb 2024 18:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hEkp1CnO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C0814901E;
	Tue, 27 Feb 2024 18:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709058508; cv=none; b=SuxH3yPIJNXX7UFYWFlwGBtGkxAZF9gNWe8mgalcZNBnYkSkMPr+WX9P08EjNrSfcxLX72uspQ9ISaBvDBDtcFdWXBm0whbc+Q+drHIGbwtGvx28blFE5ouhMUOygm5/d7rktSD3KIPKnrxJ4OvIwRXDGSn3PHw1hh2SZOVnTco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709058508; c=relaxed/simple;
	bh=Gllm63nxyBI3ZC+/D8P6Ovlw/bqeVYV1s7lFr0Y0K8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEe+FFape2WhG+mvn1sRJMwuLb5xRAuVPB18DwqItXE9VdUAKB1ruMm7ct0QXrnlGRcZVN1+1+Pu/kTBijYOm6qehBbyNf9489IjnxKWdyfbK6KWTeh94H6zbH1HxcVz4slG79J31jJDfT+nn8sGBMBN6LNWxoPVojwq98nNGNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hEkp1CnO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BA66C40E01A0;
	Tue, 27 Feb 2024 18:28:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gVd8RvbRjaPe; Tue, 27 Feb 2024 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1709058502; bh=nKj19hj9182bcWAUnfPmqwyk5Bo85nx0dFtBH5COmrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hEkp1CnOCkw1Qo7squJ0K6F1Y64x8xxlj1HiT8gWmaJwIA681v8a3+DWjMIFzl5Th
	 NbyBwhVQhiAD+TxsuozX6k9fXKnHJbziMe16HRbp6sS6fUbGU/8JK3lU/vrrW0o98c
	 UDmpdHUkkdH+mAxTFvrpTnvPfZ8Z9OHCq2/UOMJ2Y5NmbCmK9WgJqnofo1qxeyDx9y
	 y5qBHzikI+aYqZXwIfPud+rEtmqCFiGwBJlaUpH8k6F3BEzleDermPDrkF4OIHTCGR
	 2XIt95LcPt9GM5gJ9HIgVHiX4WlAEJzkIwsiLSIDjM7i/K6sam6WW9PEXO6cdEJfk/
	 ReOhYnfbXgZab80sFweouaNdWZ98qv2fyoV9nTLsxX4Fk8LHp7PKjSyuaulPdevlRK
	 kcnXrjJ3ZAJaN/7A8JFJMu92wRzVGEwZboAPESRcHe4+CG3TvifFQ7ZoAGbeAoEk11
	 C2BChAFnfRIduHDfy9E4N4WIgv7gSKvnbaJLoWW/pue1bkIsg0uE8Hp8o3hWHySSLC
	 KfZN8ny0ONKaEFcK6mMXDt8rwVTyRHd4/rKMK64zFHmq4Sd7qKm7srbo9uUucQ74/B
	 0LinadEjubAr57+/iAjyw3j4vaj/MpMRE9aN8WEajIEp0ypXY1PC3iZe0ceBoo5rbN
	 aCw5EOBJuIXnwDwiDfGpBIDk=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E70A140E0196;
	Tue, 27 Feb 2024 18:28:10 +0000 (UTC)
Date: Tue, 27 Feb 2024 19:28:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 02/16] virt: sev-guest: Replace dev_dbg with pr_debug
Message-ID: <20240227182810.GFZd4punypY3-FqKwH@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-3-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-3-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:14PM +0530, Nikunj A Dadhania wrote:
> In preparation of moving code to arch/x86/kernel/sev.c,
> replace dev_dbg with pr_debug.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index af35259bc584..01b565170729 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -178,8 +178,9 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
>  	struct aesgcm_ctx *ctx = snp_dev->ctx;
>  	u8 iv[GCM_AES_IV_SIZE] = {};
>  
> -	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
> -		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
> +	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
> +		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
> +		 resp_hdr->msg_sz);
>  
>  	/* Copy response from shared memory to encrypted memory. */
>  	memcpy(resp, snp_dev->response, sizeof(*resp));
> @@ -232,8 +233,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>  	if (!hdr->msg_seqno)
>  		return -ENOSR;
>  
> -	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
> -		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
> +	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
> +		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
>  
>  	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
>  		return -EBADMSG;
> -- 

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

