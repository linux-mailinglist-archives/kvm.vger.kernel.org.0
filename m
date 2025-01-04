Return-Path: <kvm+bounces-34560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2117A016B6
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 21:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EB521635FC
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 20:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62521D5CC4;
	Sat,  4 Jan 2025 20:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d8LzwNty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DD81C3C0A;
	Sat,  4 Jan 2025 20:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736022399; cv=none; b=curD1ykrrgp5Yp0nElOYb5k0nqUDJXgKwhFTyADH1FappZAJcJO3FXqAhW9LEXdU40cJL4QywR96sKeE3wHhaBLuamv40FVRVmhOQsMuwE/KyapagwEUTFbuxN1MjKD3hi0BItS2ReBm9Yhkot3DuIpSgQC9HAg9UWvwzB26uvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736022399; c=relaxed/simple;
	bh=zR3HPYdyLv46ny2wv6+snec8veDOZuMp1WL3O1a4ucQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=fnahmjBis6Puu76l+pCguyMu9FmfsV9bGVGCQUqxt/FFf84jAdghLyM2pZb9WQkg0K/IeMNQSv25bXx2DOQF00sqISo2XHBwQAjj5rWXm1LLAN3Ch9bjwDhBRXP9xhObXNI1i39cynQISON88DkuVUa48HGs6K/aGfH3nIOEtmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d8LzwNty; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso2740611166b.1;
        Sat, 04 Jan 2025 12:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736022395; x=1736627195; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5M6bfv4+zx0n31eSbL6DAuzeAN7hsKmrFPbohwTuXUs=;
        b=d8LzwNty2yMA+hvvT4A4GqGPQ2NfQWAS6MUgm43cjGQ3BsChsnOhGvSE9HUFYSzGwg
         FqrnAP/fskOhKOVudBzpUpUMfeUMgeT7NM4rm/tRm339emD2DeUpZCTZI5EhYbM+4GSI
         scSMOtCLjkhcbbMZPMWqE2W12R/LPsQrMbvc8Fs/VmBPXzDGNJcaDPhgaxAll9P310O0
         1N2VmVqkUNE0ij1XDPHwwyCYDek4DMY/EP1z58XtidIbdbZze2MtJLKMvBqHrqazkbNg
         5f2VYshCHxNMDAScL8BJzvpk3fb2rvzYH6itU14RAF7ZQWU6KSmaCGYpqYM9pHZOp7ET
         7gvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736022395; x=1736627195;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5M6bfv4+zx0n31eSbL6DAuzeAN7hsKmrFPbohwTuXUs=;
        b=u+5LVIXhKfuNEFA13p1XwzNlQuDVWsLLzu2ztOKcz8O2q7b+dxDERcpn9pBAZPx/yA
         ybw71BG+0XuzP/PQaeKdDduqZ/YSom4b+/Jhro00fClcIEUQfvXt2Xq04qUTA2jfn/iM
         J2VaKsrnl0lw+/Ecb3yw87nchriZ8j/CjI3oBUS9UItzwU2+hU3wc5XgOGh17gTsqfYk
         EXJEppsha07HscNPCNoehmSlKNX+LnvOmRIRJdbdYkYLNdQOZlBkndiXdQpPWuYYnBOx
         Zj48rQ1B4iJGVLf00pWGQ+Zb3xC7B2ycw8368BLXDzGHUvg/G2G6LvGVrNV/cYtv1Jlt
         NsZw==
X-Forwarded-Encrypted: i=1; AJvYcCW+bQ0xOE7iVIXkC0oigbgYd1L1dHmZZ3TGoyoEmQ204JkdJSTmyatVJbKcJL9PYj42s8YUvU6xAoIg0fE+@vger.kernel.org, AJvYcCX0D1DBsnlYBjNq8NnAM8XkhrnETqychvYh3BGrNFZNIYORYr9M6KUVlEP9SN1sr8JibH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyftOrOSlTCjzung/HtiJx+VwG6m36RgfUnU++LylHBe2fkLJTG
	TcspCR1uGhFCWWedvm9JRE2sf5iV9t2cZwLZ10iEVGljeu5AHGaU
X-Gm-Gg: ASbGnctY27dY1OZ8SjjaQj86MQSd+Kw7jJIOdWnJGaheo2uoZjGgCAMPT3AkYIP/v1/
	p+TW7sNXyoC/SDDPc8bOMmngcFA9nRdvQY+5MdG8PJVJZOSiEigXQEuBhn2pOamp/I9alV9SCKk
	NCaZvBDqs9OwneI0H9pfcm4npLEaOj8zPmq21iG9RDT7zei8ZdnyFFONcEdkYTNSEjVblEXqDc7
	Ahd00wDAKhp8G+HVj6wLYWg/+USOt4JT2+ARp7BxmE/jeeq3FcrGah1Kju65SWpBAwnv09LHj67
	9jqRnc48YGdb534NOJyGddh0AbEoyF01+ii74w==
X-Google-Smtp-Source: AGHT+IFz86oTcAk9VXHiGtQIbAqgsfTcV5iXF7oIKWvD66cWIk6ixF1X/hI6y5JFTyfpbynazea32Q==
X-Received: by 2002:a17:907:1c15:b0:aab:e07c:78b7 with SMTP id a640c23a62f3a-aac2b84a1d8mr3694771466b.23.1736022395116;
        Sat, 04 Jan 2025 12:26:35 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:5a35:63fc:d663:ba76? ([2001:b07:5d29:f42d:5a35:63fc:d663:ba76])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f06dea8sm2046950166b.192.2025.01.04.12.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 12:26:34 -0800 (PST)
Message-ID: <af92fc80484a6b1f74d8b2535f54833702b7e1f8.camel@gmail.com>
Subject: Re: [PATCH v15 03/13] x86/sev: Add Secure TSC support for SNP guests
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: nikunj@amd.com
Cc: bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
 pgonda@google.com, seanjc@google.com, tglx@linutronix.de,
 thomas.lendacky@amd.com,  x86@kernel.org
Date: Sat, 04 Jan 2025 21:26:32 +0100
In-Reply-To: <20241203090045.942078-4-nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2024-12-03 at 9:00, Nikunj A Dadhania wrote:
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index a61898c7f114..39683101b526 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
>  /* Secrets page physical address from the CC blob */
>  static u64 secrets_pa __ro_after_init;
> =20
> +/*
> + * For Secure TSC guests, the BP fetches TSC_INFO using SNP guest
> messaging and
> + * initializes snp_tsc_scale and snp_tsc_offset. These values are
> replicated
> + * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
> + */
> +static u64 snp_tsc_scale __ro_after_init;
> +static u64 snp_tsc_offset __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -1277,6 +1285,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id,
> unsigned long start_ip)
>  	vmsa->vmpl		=3D snp_vmpl;
>  	vmsa->sev_features	=3D sev_status >> 2;
> =20
> +	/* Populate AP's TSC scale/offset to get accurate TSC
> values. */
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> +		vmsa->tsc_scale =3D snp_tsc_scale;
> +		vmsa->tsc_offset =3D snp_tsc_offset;
> +	}
> +
>  	/* Switch the page over to a VMSA page now that it is
> initialized */
>  	ret =3D snp_set_vmsa(vmsa, caa, apic_id, true);
>  	if (ret) {
> @@ -3127,3 +3141,105 @@ int snp_send_guest_request(struct
> snp_msg_desc *mdesc, struct snp_guest_req *req
>  }
>  EXPORT_SYMBOL_GPL(snp_send_guest_request);
> =20
> +static int __init snp_get_tsc_info(void)
> +{
> +	struct snp_guest_request_ioctl *rio;
> +	struct snp_tsc_info_resp *tsc_resp;
> +	struct snp_tsc_info_req *tsc_req;
> +	struct snp_msg_desc *mdesc;
> +	struct snp_guest_req *req;
> +	unsigned char *buf;
> +	int rc =3D -ENOMEM;
> +
> +	tsc_req =3D kzalloc(sizeof(*tsc_req), GFP_KERNEL);
> +	if (!tsc_req)
> +		return rc;
> +
> +	tsc_resp =3D kzalloc(sizeof(*tsc_resp), GFP_KERNEL);
> +	if (!tsc_resp)
> +		goto e_free_tsc_req;
> +
> +	req =3D kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		goto e_free_tsc_resp;
> +
> +	rio =3D kzalloc(sizeof(*rio), GFP_KERNEL);
> +	if (!rio)
> +		goto e_free_req;
> +
> +	/*
> +	 * The intermediate response buffer is used while decrypting
> the
> +	 * response payload. Make sure that it has enough space to
> cover
> +	 * the authtag.
> +	 */
> +	buf =3D kzalloc(SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN,
> GFP_KERNEL);
> +	if (!buf)
> +		goto e_free_rio;
> +
> +	mdesc =3D snp_msg_alloc();
> +	if (IS_ERR_OR_NULL(mdesc))
> +		goto e_free_buf;
> +
> +	rc =3D snp_msg_init(mdesc, snp_vmpl);
> +	if (rc)
> +		goto e_free_mdesc;
> +
> +	req->msg_version =3D MSG_HDR_VER;
> +	req->msg_type =3D SNP_MSG_TSC_INFO_REQ;
> +	req->vmpck_id =3D snp_vmpl;
> +	req->req_buf =3D tsc_req;
> +	req->req_sz =3D sizeof(*tsc_req);
> +	req->resp_buf =3D buf;
> +	req->resp_sz =3D sizeof(*tsc_resp) + AUTHTAG_LEN;
> +	req->exit_code =3D SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc =3D snp_send_guest_request(mdesc, req, rio);
> +	if (rc)
> +		goto e_request;
> +
> +	memcpy(tsc_resp, buf, sizeof(*tsc_resp));
> +	pr_debug("%s: response status 0x%x scale 0x%llx offset
> 0x%llx factor 0x%x\n",
> +		 __func__, tsc_resp->status, tsc_resp->tsc_scale,
> tsc_resp->tsc_offset,
> +		 tsc_resp->tsc_factor);
> +
> +	if (tsc_resp->status =3D=3D 0) {
> +		snp_tsc_scale =3D tsc_resp->tsc_scale;
> +		snp_tsc_offset =3D tsc_resp->tsc_offset;
> +	} else {
> +		pr_err("Failed to get TSC info, response status
> 0x%x\n", tsc_resp->status);
> +		rc =3D -EIO;
> +	}
> +
> +e_request:
> +	/* The response buffer contains sensitive data, explicitly
> clear it. */
> +	memzero_explicit(buf, sizeof(buf));
> +	memzero_explicit(tsc_resp, sizeof(*tsc_resp));

buf is an unsigned char *, so by using sizeof(buf) you are not zeroing
the entire buffer.
Also, I see no point in having a separate tsc_resp buffer just to copy
the response from buf to tsc_resp, if you just use a single buffer with
size (SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN) and parse the response from
that buffer you will avoid the double buffer allocation, the memory
copying, and the double zeroing.

