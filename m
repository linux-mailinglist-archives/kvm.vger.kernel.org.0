Return-Path: <kvm+bounces-7010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4953183C18E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 13:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBA76B298E8
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 12:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3425546447;
	Thu, 25 Jan 2024 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bSGKjvtM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAC445951;
	Thu, 25 Jan 2024 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706184018; cv=none; b=G6/UjPKMihPBcq8RSdWvSSzsjEAohP+bqCC5hr+jF2PqOLjDvYkYnQFHZbtNHxzUjbjzpjxBIENOnfPflfBOSTp9OLbqg8Dgm/BI3PrUDDmG6H2Dg6dK14BnIERr2DHUfYc/Tck9HPi1NySeeII4lDs7oV/m+NGdnXqOdsXthuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706184018; c=relaxed/simple;
	bh=UrXCzano3LnAmkB3wjF8eARyW/4Ah8WO7K5ZPp7D7zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTIzYqZnjzBuzZT3DrF9GrIgbP97J59rMu5VlnbdZyXCf6v7Hyrzb4GJTgmvq0sRLcbIWR3HayYFbrCUgk/RoEpERbWN6Kjo77DQsTcbDMsbMeRgh3mn9N+Z8Y24bElAdlF6viECTbEzdTx6RWMy/7Z7/kOUOLw3IPYOmtGG/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bSGKjvtM; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0414540E01AE;
	Thu, 25 Jan 2024 12:00:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bE7QAEOdOj5V; Thu, 25 Jan 2024 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706184011; bh=Vv4ePJnj649No3QYHO2JSUq/fMCA6NiRC9M5fwJmQ/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bSGKjvtMaPbEa7Pu9wiOY/zX2h3SPeXxXdghAcsZQ9N7vyOukagYlmn9ynw8xnQPd
	 lJcuhapwAi8W0Y3q9NWHIIeNvGdinA2piuwLnz6qbl7jrJ643fspGi2kQxZEvntKqX
	 1GoZu42cHdshl+aQ48ECdDhg31gEWKuNRR6s6ownftZSG6sijv2xm2YNXTXzVG4NS2
	 Im2lGPPLyRKF07+DVSilZ4ysoglzFO8lQSzOL856viuay23Y4Kl9BrjZoO8rtVMuBY
	 Iel/ek56zrGg99RCk7bpbYGEnPW9mRfR8fzX9riNdEHeptvrFEWMyj5BIBFRz7pJLD
	 t3GKzN808v0557WfHTATrdIi3z/uRIZNpK4ZYj/si5OwWjFVCjXpHHzNu/hPJ5hvWh
	 lGm6sz1Te21+g1snKtPf/zqFf3RVRSfYxnXuEneAQn3tWLJZjfsk4sEkn2+qSWxu0a
	 bojFmkUDocfGNvOlEkw17Tss5igqY5IAVtOitREKd2aoMy3gA2pYLpVaFHmofgNNch
	 hUcPpsbRLGGUKnIs73N4qBFMZCYtdiByieNDJ8UlQ2C1DJwIN/kfqadIHOrhVWUzzT
	 jWEiP3w+/I13uTY34tw15sR+Gud/h+rqbLTrxxrqRn4Kej+KY6mHBqQzlVKC5klwMR
	 I/COqTJ5VISlhJmxOHAC/f4g=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CBC2F40E0177;
	Thu, 25 Jan 2024 11:59:58 +0000 (UTC)
Date: Thu, 25 Jan 2024 12:59:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Message-ID: <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231220151358.2147066-4-nikunj@amd.com>

On Wed, Dec 20, 2023 at 08:43:45PM +0530, Nikunj A Dadhania wrote:
> -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
> +			    struct snp_guest_request_ioctl *rio)
>  {
>  	struct ghcb_state state;
>  	struct es_em_ctxt ctxt;
>  	unsigned long flags;
>  	struct ghcb *ghcb;
> +	u64 exit_code;

Silly local vars. Just use req->exit_code everywhere instead.

>  	int ret;
>  
>  	rio->exitinfo2 = SEV_RET_NO_FW_CALL;
> +	if (!req)
> +		return -EINVAL;

Such tests are done under the variable which is assigned, not randomly.

Also, what's the point in testing req? Will that ever be NULL? What are
you actually protecting against here?

> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 469e10d9bf35..5cafbd1c42cb 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -27,8 +27,7 @@
>  
>  #include <asm/svm.h>
>  #include <asm/sev.h>
> -
> -#include "sev-guest.h"
> +#include <asm/sev-guest.h>
>  
>  #define DEVICE_NAME	"sev-guest"
>  
> @@ -169,7 +168,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>  	return ctx;
>  }
>  
> -static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
> +static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req)

So we call the request everywhere "req". But you've called it
"guest_req" here because...

>  {
>  	struct snp_guest_msg *resp = &snp_dev->secret_response;
>  	struct snp_guest_msg *req = &snp_dev->secret_request;

... there already is a "req" variable which is not a guest request thing
but a guest message. So why don't you call it "req_msg" instead and the
"resp" "resp_msg" so that it is clear what is what?

And then you can call the actual request var "req" and then the code
becomes more readable...

...

>  static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>  {
>  	struct snp_report_req *req = &snp_dev->req.report;
> +	struct snp_guest_req guest_req = {0};

You have the same issue here.

If we aim at calling the local vars in every function the same, the code
becomes automatically much more readable.

And so on...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

