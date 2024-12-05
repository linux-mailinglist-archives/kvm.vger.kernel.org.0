Return-Path: <kvm+bounces-33128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C189E54AC
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED4D1281DC7
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0903D2144D2;
	Thu,  5 Dec 2024 11:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RJnDHd7k"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BFF2144B4;
	Thu,  5 Dec 2024 11:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733399735; cv=none; b=fMaLUsqGUoAUr52jnQl7wW6Vd02hMTtDr6vqc6U12QJKdzgpncmQJVxM1F5Y2AEVhXt1aJRnI7Qk474pqNwHllfYO51llBnUVJkUqcvsLS1CQxm6zauIcA+S/9xgzeuMHsWmdTtS5dEuUaXlj5epplpLq0R5Prz8Iah1nZPDVg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733399735; c=relaxed/simple;
	bh=NfsOyPvwo7r/+S4EQ6TEUevE9QLwFJxg+vHXYxcwVuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSV0hWDIaj0C2mKklSNXoCvPdH5UGQZDl8SU57z9SIeAvYrnlzINJtluZ2gKZIXp3opAmNrXetJIoAymXlMK6g8hdQobaWI4DnobpdvjEpCyvc2lY8PCzLmBmV9h5fC1tMZHivEm01b+TfAZI51+B89I7vkS8qxtkUq0kdlb4L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RJnDHd7k; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B478B40E0287;
	Thu,  5 Dec 2024 11:55:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id o4O7DtP6EmAo; Thu,  5 Dec 2024 11:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733399725; bh=GDBnJl4+Qj2fE0klOae9WTHpDkooZgSl/C7794+jx8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RJnDHd7kUPP2uknLR0P0B0FVFYqIlB/gts8kG5K4n+hq7zZ1HVO9nryS66dvRsT2M
	 sAdI0c5En6f5m/x+rLs770tnY8SzTLRIR765g2swK2V/OiwXSBFdyRsB16wG5kHMA3
	 rlSddSNBUMAGyLAAWnJaRMYilHayvVS/QjGKyTCTrCpkXV7skiGqDDedrTyEjx5OQN
	 kGtE+6FP0zcrPNZl1zC22RO8v3yjAY5QnjqH9XDHOVYP33C3xqzw9fZkPSSdkx0jIM
	 wGQ2DQjZFZWJZ8uxocRte27Ygy9kMHvkXtoobeNsCgO7+a0hig4pUC+hmJgrIQIxGS
	 ZIa06LTgpAV4qlFjjJdBj//Ob0rbnuVcevxwEF7AXWyMVEGbhwpVjaCrbRHUxpkxuc
	 NvfwlNlLK7Od80eVyMA51u0ZdPjSn98YXHed7v8jYY/1+T5FqjNRlzIr4kbqaJDJz/
	 zQ6VWE5Jzk7hr57x1a57CDbC+KSVt8N2G84LtFYzjkbCk5i4pgI1rRehjqK3trnxfu
	 jFspHpqOr73UvHv5UA/R0J9gcR4xCygslggUon94N1qH/808nQWCSY0i5qLIVmUId/
	 UdWz0W3AdfV8Q+fVp0YwG57qBxgixV3p/jOEm+pp0IBUN4MO0HOdBZS/BxMf3bEPpi
	 h/93V7is35Bckr8laS/rXZ1w=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6EB1A40E015F;
	Thu,  5 Dec 2024 11:55:14 +0000 (UTC)
Date: Thu, 5 Dec 2024 12:55:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241205110455.GCZ1GI1_vv5EIMJwXl@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-4-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-4-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:35PM +0530, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
> used cannot be altered by the hypervisor once the guest is launched.
> 
> Secure TSC-enabled guests need to query TSC information from the AMD
> Security Processor. This communication channel is encrypted between the AMD
> Security Processor and the guest, with the hypervisor acting merely as a
> conduit to deliver the guest messages to the AMD Security Processor. Each
> message is protected with AEAD (AES-256 GCM).
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>


> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

This patch changed somewhat from last time. When did Peter test it again and
Tom review it again?

> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index a61898c7f114..39683101b526 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
>  /* Secrets page physical address from the CC blob */
>  static u64 secrets_pa __ro_after_init;
>  
> +/*
> + * For Secure TSC guests, the BP fetches TSC_INFO using SNP guest messaging and

s/BP/BSP/

> + * initializes snp_tsc_scale and snp_tsc_offset. These values are replicated
> + * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
> + */
> +static u64 snp_tsc_scale __ro_after_init;
> +static u64 snp_tsc_offset __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;

...

> +	memcpy(tsc_resp, buf, sizeof(*tsc_resp));
> +	pr_debug("%s: response status 0x%x scale 0x%llx offset 0x%llx factor 0x%x\n",
> +		 __func__, tsc_resp->status, tsc_resp->tsc_scale, tsc_resp->tsc_offset,
> +		 tsc_resp->tsc_factor);
> +
> +	if (tsc_resp->status == 0) {

Like the last time:

	if (!tsc_resp->status)

> +		snp_tsc_scale = tsc_resp->tsc_scale;
> +		snp_tsc_offset = tsc_resp->tsc_offset;
> +	} else {
> +		pr_err("Failed to get TSC info, response status 0x%x\n", tsc_resp->status);
> +		rc = -EIO;
> +	}
> +
> +e_request:
> +	/* The response buffer contains sensitive data, explicitly clear it. */
> +	memzero_explicit(buf, sizeof(buf));
> +	memzero_explicit(tsc_resp, sizeof(*tsc_resp));
> +e_free_mdesc:
> +	snp_msg_free(mdesc);
> +e_free_buf:
> +	kfree(buf);
> +e_free_rio:
> +	kfree(rio);
> +e_free_req:
> +	kfree(req);
> + e_free_tsc_resp:
> +	kfree(tsc_resp);
> +e_free_tsc_req:
> +	kfree(tsc_req);
> +
> +	return rc;
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

