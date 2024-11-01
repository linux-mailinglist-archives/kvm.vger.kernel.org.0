Return-Path: <kvm+bounces-30319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7ED79B94D5
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AA24B21FA4
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3C21C9DD8;
	Fri,  1 Nov 2024 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KXRsgmKk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28EA7602D;
	Fri,  1 Nov 2024 16:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730476845; cv=none; b=SnBVFJl2jBnK4ulvcVrZIwgB3X/BcMbtiOjtlf82khRuzUanIPW9FpQZHcwuDC3BSYY690BJfLbF0ZdqdBVfSiEv32eSDKqiAMRIyjY9/pUjkYOEZ5pVk2gJ7ycekqct7zTGokIfex9T7j++amPO6yJ91uaoIeMWN5xzSdrhu7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730476845; c=relaxed/simple;
	bh=WTqhpuuOjdj30GpoiUur1pHYfRIGfRK0iWs/ST1iZyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSwiD9viOAG7kKUHXaFDTmSMggbFqRZmPPC/l3LQoTQEHDWD6mpuljfOZxNQvHxura7g5nerxEk175H0TVcFXfSa4lJiy0zqRSdBBiO1IB537zYb3ufa1cRGrSTq6dy9AzjxaYe9yfvMTmVSFAs4bkqpoRZJF9IMpdAvjhgdzVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=KXRsgmKk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8845440E0184;
	Fri,  1 Nov 2024 16:00:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FLuCjqzYDa9l; Fri,  1 Nov 2024 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730476831; bh=+O3lExo4DVA0Oqm0YYUylvzRIgxHp5PyzTOK8IHJVxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KXRsgmKkcbxBXP7+bo4gUxIOfsC55jh0FZm2PE1T3RDIghHL4cbdCzqGgONIBGp/t
	 D23ozTHY5pjXToU2ZIJQo0D3VuJdKGWdkqECv+xzbLzEuVOOXo+3eMVZb/V55tj+8o
	 aRMuGVYsU4Eo0kvjIgLspI91nDufIueHkRujnZE+si/pV8XjkFulyJ8TQ0rxjB5OCX
	 jAL+it+U+VGn0kO7f6sXzma2pUy+oZMdlydpGbtYrMLiInPGo/MlILbAndYIslmeDs
	 vk6JSHP28sqI8ltDAgf09vu/ASxrGw7/OTUIYAne9a2p6yFkN0rESK1SlsRJH9rEkI
	 CNrRlgPcy86oIXnmCBEOrlY9olG8aP4iB40bLSePvn9BfE/XnQoHoDaPwrJOoWDCWx
	 SYCQCdJpIziqQYYBblmvXGvKrCStr+jChuwhxS9blFJnyZJvi2k//ZKX4T/S8K5eFW
	 AQae+6dSGllxC9U/sPUR7gr8JF7fsRUGRiWjurXV75EHykv1y0YDhGazDr9y2K56ZB
	 oNYRI9WF+Nc5ETy3GnI9o71IWchm83c2KwbHI8AeabeXqM/Ejh/GR6y0DsMO6zbW/r
	 mgZLIzXHAkxSnhajROWFWatFAWuvUa4QmCqvrsD0+d4gbNHJBPLzs6Rmn3P/1IR5PM
	 +DAkE6eLlwKuV7Ih71PHCfk0=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6053040E015F;
	Fri,  1 Nov 2024 16:00:20 +0000 (UTC)
Date: Fri, 1 Nov 2024 17:00:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241028053431.3439593-4-nikunj@amd.com>

On Mon, Oct 28, 2024 at 11:04:21AM +0530, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
> used cannot be altered by the hypervisor once the guest is launched.
> 
> Secure TSC-enabled guests need to query TSC information from the AMD
> Security Processor. This communication channel is encrypted between the AMD
> Security Processor and the guest, with the hypervisor acting merely as a
> conduit to deliver the guest messages to the AMD Security Processor. Each
> message is protected with AEAD (AES-256 GCM).

Zap all that text below or shorten it to the bits only which explain why
something is done the way it is.

> Use a minimal AES GCM library
> to encrypt and decrypt SNP guest messages for communication with the PSP.
> 
> Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
> Processor and initialize snp_tsc_scale and snp_tsc_offset. During secondary
> CPU initialization, set the VMSA fields GUEST_TSC_SCALE (offset 2F0h) and
> GUEST_TSC_OFFSET (offset 2F8h) with snp_tsc_scale and snp_tsc_offset,
> respectively.
> 
> Add confidential compute platform attribute CC_ATTR_GUEST_SNP_SECURE_TSC
> that can be used by the guest to query whether the Secure TSC feature is
> active.
> 
> Since handle_guest_request() is common routine used by both the SEV guest
> driver and Secure TSC code, move it to the SEV header file.

...

> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index c96b742789c5..88cae62382c2 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -98,6 +98,10 @@ static u64 secrets_pa __ro_after_init;
>  
>  static struct snp_msg_desc *snp_mdesc;
>  
> +/* Secure TSC values read using TSC_INFO SNP Guest request */
> +static u64 snp_tsc_scale __ro_after_init;
> +static u64 snp_tsc_offset __ro_after_init;

I don't understand the point of this: this is supposed to be per VMSA so
everytime you create a guest, that guest is supposed to query the PSP. What
are those for?

Or are those the guest's TSC values which you're supposed to replicate across
the APs?

If so, put that info in the comment above it - it is much more important than
what you have there now.

>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -1148,6 +1152,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
>  	vmsa->vmpl		= snp_vmpl;
>  	vmsa->sev_features	= sev_status >> 2;
>  
> +	/* Set Secure TSC parameters */

That's obvious. Why are you setting them, is more important.

> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> +		vmsa->tsc_scale = snp_tsc_scale;
> +		vmsa->tsc_offset = snp_tsc_offset;
> +	}
> +
>  	/* Switch the page over to a VMSA page now that it is initialized */
>  	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
>  	if (ret) {
> @@ -2942,3 +2952,83 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(snp_send_guest_request);
> +
> +static int __init snp_get_tsc_info(void)
> +{
> +	static u8 buf[SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN];

You're allocating stuff below dynamically. Why is this buffer allocated on the
stack?

> +	struct snp_guest_request_ioctl rio;
> +	struct snp_tsc_info_resp tsc_resp;

Ditto.

> +	struct snp_tsc_info_req *tsc_req;
> +	struct snp_msg_desc *mdesc;
> +	struct snp_guest_req req;
> +	int rc;
> +
> +	/*
> +	 * The intermediate response buffer is used while decrypting the
> +	 * response payload. Make sure that it has enough space to cover the
> +	 * authtag.
> +	 */

Yes, this is how you do comments - you comment stuff which is non-obvious.

> +	BUILD_BUG_ON(sizeof(buf) < (sizeof(tsc_resp) + AUTHTAG_LEN));
> +
> +	mdesc = snp_msg_alloc();
> +	if (IS_ERR_OR_NULL(mdesc))
> +		return -ENOMEM;
> +
> +	rc = snp_msg_init(mdesc, snp_vmpl);
> +	if (rc)
> +		return rc;
> +
> +	tsc_req = kzalloc(sizeof(struct snp_tsc_info_req), GFP_KERNEL);
> +	if (!tsc_req)
> +		return -ENOMEM;

You return here and you leak mdesc. Where are those mdesc things even freed?
I see snp_msg_alloc() but not a "free" counterpart...

> +	memset(&req, 0, sizeof(req));
> +	memset(&rio, 0, sizeof(rio));
> +	memset(buf, 0, sizeof(buf));
> +
> +	req.msg_version = MSG_HDR_VER;
> +	req.msg_type = SNP_MSG_TSC_INFO_REQ;
> +	req.vmpck_id = snp_vmpl;
> +	req.req_buf = tsc_req;
> +	req.req_sz = sizeof(*tsc_req);
> +	req.resp_buf = buf;
> +	req.resp_sz = sizeof(tsc_resp) + AUTHTAG_LEN;
> +	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc = snp_send_guest_request(mdesc, &req, &rio);
> +	if (rc)
> +		goto err_req;
> +
> +	memcpy(&tsc_resp, buf, sizeof(tsc_resp));
> +	pr_debug("%s: response status %x scale %llx offset %llx factor %x\n",

Prefix all hex values with "0x" so that it is unambiguous.

> +		 __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
> +		 tsc_resp.tsc_factor);
> +

	if (!tsc_resp.status)

> +	if (tsc_resp.status == 0) {
> +		snp_tsc_scale = tsc_resp.tsc_scale;
> +		snp_tsc_offset = tsc_resp.tsc_offset;
> +	} else {
> +		pr_err("Failed to get TSC info, response status %x\n", tsc_resp.status);

								Ox

> +		rc = -EIO;
> +	}
> +
> +err_req:
> +	/* The response buffer contains the sensitive data, explicitly clear it. */

s/the //

> +	memzero_explicit(buf, sizeof(buf));
> +	memzero_explicit(&tsc_resp, sizeof(tsc_resp));
> +
> +	return rc;
> +}
> +
> +void __init snp_secure_tsc_prepare(void)
> +{
> +	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		return;
> +
> +	if (snp_get_tsc_info()) {
> +		pr_alert("Unable to retrieve Secure TSC info from ASP\n");
> +		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC);
> +	}
> +
> +	pr_debug("SecureTSC enabled");
> +}
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 0a120d85d7bb..996ca27f0b72 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -94,6 +94,10 @@ void __init mem_encrypt_init(void)
>  	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>  	swiotlb_update_mem_attributes();
>  
> +	/* Initialize SNP Secure TSC */

Useless comment.

> +	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
> +		snp_secure_tsc_prepare();

Why don't you call this one in the same if-condition in
mem_encrypt_setup_arch() ?

> +
>  	print_mem_encrypt_feature_info();
>  }
>  
> -- 
> 2.34.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

