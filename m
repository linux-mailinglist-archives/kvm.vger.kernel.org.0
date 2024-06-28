Return-Path: <kvm+bounces-20628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9393B91B59A
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 05:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B084283582
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 03:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68760224D2;
	Fri, 28 Jun 2024 03:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IuHhMlTZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2131CAA2;
	Fri, 28 Jun 2024 03:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719546765; cv=none; b=fy5b9Cfa5cF6CGBOOkSwZouMJFGcLCL+KXgw9AvV6cDlPSmd43nNah7yOKUFQaPMcY1W/Law8VO6TUlBFVmlnDHmL15ElCJcyq3vV2yZlVb0tUOIW/RKCImQUAPj91XLEIctQYStv1S+ax1McRO8zjMfer3Bl5wHngVjklwPBVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719546765; c=relaxed/simple;
	bh=8jD4cOobXcm+/H4yDXHO7QwI3+XbZcZhIqYdMwDDK0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZo+tzas53yYmrdb8U7pxBXHPLttxV5A15hQ0y6NFpp/C2Nj4FjtMbUEYfxcGZZuOqK6T9oCiCF840GdpK6JAcUyGLsdHXk8mXCKKloovUP7nKoaTYAjg12vVCCbCTxqg4U9vVPMW6/XuuARJDBnC62RV467xUjOsw2CSscSLMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IuHhMlTZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B87FB40E0194;
	Fri, 28 Jun 2024 03:52:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fmL6Lq6c0wLz; Fri, 28 Jun 2024 03:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719546755; bh=HmPUn1KTX13hXMNtZOsiZL1UCOVmOMvqRxVnbVqEKGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IuHhMlTZzQDDnRTtlF8xzFUiHfjHxBvwTq7eAK6B/ultaI239YFnMdUP2u9aLyBRi
	 di1B2L9F3UWENbeqCNKm7duWW2raC8G/n0GD2GCVMG2gT07H7rOpoiEl/gKQYMcjG0
	 niYA2hxVVQetMCQJ+NWBZd/Qnxi9Y758IqM3CMDtMO4ah9Yh8iX9ZFFU5gy5vaHsMZ
	 qfZQecvubfIYc1zPU53My7ma6xe7nR8kDikQ+sAbgevpTPODSGBXlELVt/e1DkrVp8
	 FAbbtqFO7Hfue4sRby7WldrFu2+QjN7wZ5xWKm6piJfi4xRXUSC0juIOIbsk0R9igg
	 +3pqMB+RCX5gseZpLrOzYKcVrnWehetHzjatYlL9a8R4Y8XXI7ShV6fwMeN6+H/iNM
	 Jxtxe8GdCx/zHrN9+ND8/RxYB0VuD82VB0ebVXwr/Jl0QW85Dk+gefORlxAul84hw8
	 +8qV/XntsDjt9Gtn7YUT7cqnf3JFGEiXBmdV8SXLI21XSvyzRFqAM48Vjtq/uQrq+/
	 6j0dp5EP5qFJkR7DxMHkCaocaLokZbZ4H8PHZqH9/xiMVRvbQZQRpRTfLwFimqpaWI
	 OXgrZlM0XImladLufDaWNUAknuGAWPqkZnlmTaNYdxVbm11nv9Qq/Sr4ej2giVkdQm
	 CzJyGIAOSnyD+s82Khdhim4Q=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1DDFE40E0192;
	Fri, 28 Jun 2024 03:52:24 +0000 (UTC)
Date: Fri, 28 Jun 2024 05:52:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v10 07/24] virt: sev-guest: Store VMPCK index to SNP
 guest device structure
Message-ID: <20240628035217.GAZn4zcWMZy3mgCKky@fat_crate.local>
References: <20240621123903.2411843-1-nikunj@amd.com>
 <20240621123903.2411843-8-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240621123903.2411843-8-nikunj@amd.com>

On Fri, Jun 21, 2024 at 06:08:46PM +0530, Nikunj A Dadhania wrote:
> Currently, SEV guest driver retrieves the pointers to VMPCK and
> os_area_msg_seqno from the secrets page. In order to get rid of this
> dependency,

And we do this because...?

> use vmpck_id to index the appropriate key and the corresponding
> message sequence number.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 74 ++++++++++++-------------
>  1 file changed, 37 insertions(+), 37 deletions(-)

...

>  static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>  {
>  	char zero_key[VMPCK_KEY_LEN] = {0};
> +	u8 *key = get_vmpck(snp_dev);
>  
> -	if (snp_dev->vmpck)
> -		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
> -
> -	return true;
> +	return !memcmp(key, zero_key, VMPCK_KEY_LEN);

There's a count_nonzero_bytes() function which you can export and use here
instead of expanding the stack unnecessarily.

In any case, there are multiple methods how to check whether a buffer is
zeroes, which are cheaper than this.

> -static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
> +static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>  {
> -	if (!(id < VMPCK_MAX_NUM))
> -		return NULL;
> +	if (!(vmpck_id < VMPCK_MAX_NUM))

Yeah, flip that logic.

> +		return false;
> +
> +	dev->vmpck_id = vmpck_id;
>  
> -	*seqno = &secrets->os_area.msg_seqno[id];
> -	return secrets->vmpck[id];
> +	return true;
>  }

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

