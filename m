Return-Path: <kvm+bounces-7001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F0683BF02
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 11:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC8521F237BB
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 10:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492981CD28;
	Thu, 25 Jan 2024 10:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KUHDkxL6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88711CAB8;
	Thu, 25 Jan 2024 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706179035; cv=none; b=ZHoexcTM+vv8WcnuXmWKbiUzLnUpESFxPPSAtgPDPlbrwDIb4v3YlIToQQ3Aj4V4UPIMzFnPcShqtVOkRINchcPPsBStYN3gSyYrQnpK7RXx5PBgv8FBRqe0EacOgTOk+IQ0R6cnepvZ6rv8OnB+WTEM2maJ6d31ROnwUgmkW2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706179035; c=relaxed/simple;
	bh=ZlYvv8VvaTXPy+ic2KeWQNqOlCrhdJS2ZA/RSJF2EUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTYPe8dwk7Qq99ckqwnwHtjNOPIcm6ynoT0ZvJkynB2zZNL9DlD/CKIzN9qEwzhQXwCTVTO/lb2VfhKs9UqbTKKIFeGsWwkxX5H8t1ZY7xzwieIXW/36cEAvK6ccaeST7QkXSjDFxOxMbS0qySUijvpdJWx4dWzOJFCCSfk8q/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=KUHDkxL6; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 385D840E01AE;
	Thu, 25 Jan 2024 10:37:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pkI2RJqmYEto; Thu, 25 Jan 2024 10:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706179022; bh=e1AgACS1Lgeh8epXX9BecIRIHm0i/0eLmdc7kVvPXZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KUHDkxL6WGhmwrrgkO5uejUh5BWk0Mx7D4NK2mpxOfmmuvNmLMx3ov5BYNBEqUEf1
	 TvQyY4pmYCxeVQt/WJoaXMt8IgR8QG4y+9UPegziARYD50Gl8Bd6zVy0PC3p6bPUpg
	 OdWZSSlbILQHakgxO/34lqd0mjQ0880UkMrVVOEIyyOerpq0kVC5lHH3dWoprf94Cq
	 2fJPPQS3T1kH75MqmfqlRCI9IgPrmy0W5TMpdVe8wX+JRohGukyfnRNrGpGW1Tk0R+
	 pUc+8NOCGN2qSK7+vFwU+Xlcmh2S+Cszf3fdHa5ZdWqrCY0zO3re8DD2pcDdsQHi+T
	 LQX4Kv9ENU2QeVVOv/jQLWaAj+aSOFSy5x50sGkuE5nrxi2Frl92r5KKWByR/Hsw84
	 ebdjynbr9+S7993i8RXJADdcfJoTW0Zm2nnTdMOX/pVK6VSu4niKZl0K9Re/hR+WDj
	 aDilcO6WfrwIqCR0gbBRVMzweP8oK8b6SA2EhlS7m0F+LGwLIRk1YjeP8PQw+sYPRw
	 CC8fDFXJti4DH53x7auy8RSCjv4UmXotrkxD2+fZOdTj5za2N0FIXKbgofb4j0u39K
	 q9KTynuMs1Hl6CrlSZbXS82FWE4B8lVgVEgQRFcyE2kmwTbCq2OiI+9JNhY152W5CV
	 YWkJCrcOUZigQ1ZXJRWI5wz8=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3D02140E00C5;
	Thu, 25 Jan 2024 10:36:50 +0000 (UTC)
Date: Thu, 25 Jan 2024 11:36:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v7 01/16] virt: sev-guest: Use AES GCM crypto library
Message-ID: <20240125103643.GWZbI5u88U341ORBq1@fat_crate.local>
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231220151358.2147066-2-nikunj@amd.com>

On Wed, Dec 20, 2023 at 08:43:43PM +0530, Nikunj A Dadhania wrote:
> @@ -307,11 +197,16 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
>  	 * If the message size is greater than our buffer length then return
>  	 * an error.
>  	 */
> -	if (unlikely((resp_hdr->msg_sz + crypto->a_len) > sz))
> +	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
>  		return -EBADMSG;
>  
>  	/* Decrypt the payload */
> -	return dec_payload(snp_dev, resp, payload, resp_hdr->msg_sz + crypto->a_len);
> +	memcpy(iv, &resp_hdr->msg_seqno, sizeof(resp_hdr->msg_seqno));

sizeof(iv) != sizeof(resp_hdr->msg_seqno) and it fits now.

However, for protection against future bugs, this should be:

	memcpy(iv, &resp_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_hdr->msg_seqno)));

> +	if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
> +			    &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
> +		return -EBADMSG;
> +
> +	return 0;
>  }
>  
>  static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
> @@ -319,6 +214,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>  {
>  	struct snp_guest_msg *req = &snp_dev->secret_request;
>  	struct snp_guest_msg_hdr *hdr = &req->hdr;
> +	struct aesgcm_ctx *ctx = snp_dev->ctx;
> +	u8 iv[GCM_AES_IV_SIZE] = {};
>  
>  	memset(req, 0, sizeof(*req));
>  
> @@ -338,7 +235,14 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>  	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
>  		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
>  
> -	return __enc_payload(snp_dev, req, payload, sz);
> +	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
> +		return -EBADMSG;
> +
> +	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));

Ditto.

> +	aesgcm_encrypt(ctx, req->payload, payload, sz, &hdr->algo, AAD_LEN,
> +		       iv, hdr->authtag);
> +
> +	return 0;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

