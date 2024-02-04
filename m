Return-Path: <kvm+bounces-7954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FF7848FAD
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 18:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149442831DC
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 17:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6122B24A00;
	Sun,  4 Feb 2024 17:25:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2D824215;
	Sun,  4 Feb 2024 17:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707067521; cv=none; b=GM1kqxvichtTG0GoZZ4cNM7S4FUxVaBp41QrXgstMIbRoG7MbskpnEscNjV1MIHKpGkEt9rg1JHpPj2j2uRdmOOOtrCy7kmClVs2mEs7vRim/4Ol0oT7RUtri1tEoeWhKW7tw+hFo1ztumsfvgMLfHWwf4j1C1poJWXBEQ/PzcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707067521; c=relaxed/simple;
	bh=o6XgZklQg99ao472cPaHWFZkdLc8gXrmjSvTwRxHuxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TN1avc3WT/XHGYEkLHNFOWH4ajWnHA1mlu09SaaoYq3nTErMNinLTVO++B90QFMD5Hq/AoVYu1VgnV2DW1mmEXMPe97840OoD1kF3sWZ2ySKwLTJSptf57J7FWI6quGfO5rjUEOQckHsywGb/SAd0UNS3rrJquwSyaI7tcUyxOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 5E0872800B3C2;
	Sun,  4 Feb 2024 18:25:10 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 463422F90E5; Sun,  4 Feb 2024 18:25:10 +0100 (CET)
Date: Sun, 4 Feb 2024 18:25:10 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linuxarm@huawei.com, David Box <david.e.box@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, "Li, Ming" <ming4.li@intel.com>,
	Zhi Wang <zhi.a.wang@intel.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 07/12] spdm: Introduce library to authenticate devices
Message-ID: <20240204172510.GA19805@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
 <20231003153937.000034ca@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003153937.000034ca@Huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Oct 03, 2023 at 03:39:37PM +0100, Jonathan Cameron wrote:
> On Thu, 28 Sep 2023 19:32:37 +0200 Lukas Wunner <lukas@wunner.de> wrote:
> > +/**
> > + * spdm_challenge_rsp_sz() - Calculate CHALLENGE_AUTH response size
> > + *
> > + * @spdm_state: SPDM session state
> > + * @rsp: CHALLENGE_AUTH response (optional)
> > + *
> > + * A CHALLENGE_AUTH response contains multiple variable-length fields
> > + * as well as optional fields.  This helper eases calculating its size.
> > + *
> > + * If @rsp is %NULL, assume the maximum OpaqueDataLength of 1024 bytes
> > + * (SPDM 1.0.0 table 21).  Otherwise read OpaqueDataLength from @rsp.
> > + * OpaqueDataLength can only be > 0 for SPDM 1.0 and 1.1, as they lack
> > + * the OtherParamsSupport field in the NEGOTIATE_ALGORITHMS request.
> > + * For SPDM 1.2+, we do not offer any Opaque Data Formats in that field,
> > + * which forces OpaqueDataLength to 0 (SPDM 1.2.0 margin no 261).
> > + */
> > +static size_t spdm_challenge_rsp_sz(struct spdm_state *spdm_state,
> > +				    struct spdm_challenge_rsp *rsp)
> > +{
> > +	size_t  size  = sizeof(*rsp)		/* Header */
> 
> Double spaces look a bit strange...
> 
> > +		      + spdm_state->h		/* CertChainHash */
> > +		      + 32;			/* Nonce */
> > +
> > +	if (rsp)
> > +		/* May be unaligned if hash algorithm has unusual length. */
> > +		size += get_unaligned_le16((u8 *)rsp + size);
> > +	else
> > +		size += SPDM_MAX_OPAQUE_DATA;	/* OpaqueData */
> > +
> > +	size += 2;				/* OpaqueDataLength */
> > +
> > +	if (spdm_state->version >= 0x13)
> > +		size += 8;			/* RequesterContext */
> > +
> > +	return  size  + spdm_state->s;		/* Signature */
> 
> Double space here as well looks odd to me.

This was criticized by Ilpo as well, but the double spaces are
intentional to vertically align "size" on each line for neatness.

How strongly do you guys feel about it? ;)


> > +int spdm_authenticate(struct spdm_state *spdm_state)
> > +{
> > +	size_t transcript_sz;
> > +	void *transcript;
> > +	int rc = -ENOMEM;
> > +	u8 slot;
> > +
> > +	mutex_lock(&spdm_state->lock);
> > +	spdm_reset(spdm_state);
[...]
> > +	rc = spdm_challenge(spdm_state, slot);
> > +
> > +unlock:
> > +	if (rc)
> > +		spdm_reset(spdm_state);
> 
> I'd expect reset to also clear authenticated. Seems odd to do it separately
> and relies on reset only being called here. If that were the case and you
> were handling locking and freeing using cleanup.h magic, then
> 
> 	rc = spdm_challenge(spdm_state);
> 	if (rc)
> 		goto reset;
> 	return 0;
> 
> reset:
> 	spdm_reset(spdm_state);

Unfortunately clearing "authenticated" in spdm_reset() is not an
option:

Note that spdm_reset() is also called at the top of spdm_authenticate().

If the device was previously successfully authenticated and is now
re-authenticated successfully, clearing "authenticated" in spdm_reset()
would cause the flag to be briefly set to false, which may irritate
user space inspecting the sysfs attribute at just the wrong moment.

If the device was previously successfully authenticated and is
re-authenticated successfully, I want the "authenticated" attribute
to show "true" without any gaps.  Hence it's only cleared at the end
of spdm_authenticate() if there was an error.

I agree with all your other review feedback and have amended the
patch accordingly.  Thanks a lot!

Lukas

