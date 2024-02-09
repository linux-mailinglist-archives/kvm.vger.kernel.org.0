Return-Path: <kvm+bounces-8483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E137384FD9C
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 21:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4550EB290B6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 20:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7535363A7;
	Fri,  9 Feb 2024 20:32:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED1023B1;
	Fri,  9 Feb 2024 20:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707510731; cv=none; b=mr0mV2Thy90uzXwhmGLtG/GXiYACATOlmTKiqFbvbBWZ4y0XTxwRfSrdUx2wqBsmpDNPerLKhKg0Jpsi6f66liVzzjfrjft4mSBauEDXIXsk8xJBGDRWL3yuwKiGI6Yg9jGCW1c6cIiH4I6WLvKmMJ0YTOlD24P0UTqS8aY97U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707510731; c=relaxed/simple;
	bh=W4hX4Fr27kDfOqCWn6zXDk0H9YB1rKxtALyMNKxVk4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=by9URIP60WTQrCWub5K32hvG3K43Xv7yJlU4QT+TfazPQ9lHlq/4P/1w7BJdxS4Z9+njgFzxKsQ7Q1HStGHC5IFHKag9kfbR4I9CgQy9a1e4IwilVQ8JdvZPcPFl7pb5cSSnT8e9X93vt1Fkt78+QSriscI7CbGppoAFQxXQyRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 9FB682800B767;
	Fri,  9 Feb 2024 21:32:04 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 808144D3896; Fri,  9 Feb 2024 21:32:04 +0100 (CET)
Date: Fri, 9 Feb 2024 21:32:04 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, linuxarm@huawei.com,
	David Box <david.e.box@intel.com>,
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
Message-ID: <20240209203204.GA5850@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
 <5d0e75-993c-3978-8ccf-60bfb7cac10@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d0e75-993c-3978-8ccf-60bfb7cac10@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Oct 03, 2023 at 01:35:26PM +0300, Ilpo Järvinen wrote:
> On Thu, 28 Sep 2023, Lukas Wunner wrote:
> > +typedef int (spdm_transport)(void *priv, struct device *dev,
> > +                          const void *request, size_t request_sz,
> > +                          void *response, size_t response_sz);
> 
> This returns a length or an error, right? If so return ssize_t instead.
> 
> If you make this change, alter the caller types too.

Alright, I've changed the types in __spdm_exchange() and spdm_exchange().

However the callers of those functions assign the result to an "rc" variable
which is also used to receive an "int" return value.
E.g. spdm_get_digests() assigns the ssize_t result of spdm_exchange() to rc
but also the int result of crypto_shash_update().

It feels awkward to change the type of "rc" to "ssize_t" in those
functions, so I kept "int".


> > +} __packed;
> > +
> > +#define SPDM_GET_CAPABILITIES 0xE1
> 
> There's non-capital hex later in the file, please try to be consistent.

The spec uses capital hex characters, so this was done to ease
connecting the implementation to the spec.

OTOH I don't want to capitalize all the hex codes in enum spdm_error_code.

So I guess consistency takes precedence and I've amended the
patch to downcase all hex characters, as you've requested.


> > +struct spdm_error_rsp {
> > +	u8 version;
> > +	u8 code;
> > +	enum spdm_error_code error_code:8;
> > +	u8 error_data;
> > +
> > +	u8 extended_error_data[];
> > +} __packed;
> 
> Is this always going to produce the layout you want given the alignment 
> requirements for the storage unit for u8 and enum are probably different?

Yes, the __packed attribute forces the compiler to avoid padding.


> > +	spdm_state->responder_caps = le32_to_cpu(rsp->flags);
> 
> Earlier, unaligned accessors where used with the version_number_entries.
> Is it intentional they're not used here (I cannot see what would be 
> reason for this difference)?

Thanks, good catch.  Indeed this is not necessarily naturally aligned
because the GET_CAPABILITIES request and response succeeds the
GET_VERSION response in the same allocation.  And the GET_VERSION
response size is a multiple of 2, but not always a multiple of 4.

So I've amended the patch to use a separate allocation for the
GET_CAPABILITIES request and response.  The spec-defined struct layout
of those messages is such that the 32-bit accesses are indeed always
naturally aligned.

The existing unaligned accessor in spdm_get_version() turned out
to be unnecessary after taking a closer look, so I dropped that one.


> > +static int spdm_negotiate_algs(struct spdm_state *spdm_state,
> > +			       void *transcript, size_t transcript_sz)
> > +{
> > +	struct spdm_req_alg_struct *req_alg_struct;
> > +	struct spdm_negotiate_algs_req *req;
> > +	struct spdm_negotiate_algs_rsp *rsp;
> > +	size_t req_sz = sizeof(*req);
> > +	size_t rsp_sz = sizeof(*rsp);
> > +	int rc, length;
> > +
> > +	/* Request length shall be <= 128 bytes (SPDM 1.1.0 margin no 185) */
> > +	BUILD_BUG_ON(req_sz > 128);
> 
> I don't know why this really has to be here? This could be static_assert()
> below the struct declaration.

A follow-on patch to add key exchange support increases req_sz based on
an SPDM_MAX_REQ_ALG_STRUCT macro defined here in front of the function
where it's used.  That's the reason why the size is checked here as well.


> > +static int spdm_get_certificate(struct spdm_state *spdm_state, u8 slot)
> > +{
> > +	struct spdm_get_certificate_req req = {
> > +		.code = SPDM_GET_CERTIFICATE,
> > +		.param1 = slot,
> > +	};
> > +	struct spdm_get_certificate_rsp *rsp;
> > +	struct spdm_cert_chain *certs = NULL;
> > +	size_t rsp_sz, total_length, header_length;
> > +	u16 remainder_length = 0xffff;
> 
> 0xffff in this function should use either U16_MAX or SZ_64K - 1.

The SPDM spec uses 0xffff so I'm deliberately using that as well
to make the connection to the spec obvious.


> > +static void spdm_create_combined_prefix(struct spdm_state *spdm_state,
> > +					const char *spdm_context, void *buf)
> > +{
> > +	u8 minor = spdm_state->version & 0xf;
> > +	u8 major = spdm_state->version >> 4;
> > +	size_t len = strlen(spdm_context);
> > +	int rc, zero_pad;
> > +
> > +	rc = snprintf(buf, SPDM_PREFIX_SZ + 1,
> > +		      "dmtf-spdm-v%hhx.%hhx.*dmtf-spdm-v%hhx.%hhx.*"
> > +		      "dmtf-spdm-v%hhx.%hhx.*dmtf-spdm-v%hhx.%hhx.*",
> > +		      major, minor, major, minor, major, minor, major, minor);
> 
> Why are these using s8 formatting specifier %hhx ??

I don't quite follow, "%hhx" is an unsigned char, not a signed char.

spdm_state->version may contain e.g. 0x12 which is converted to
"dmtf-spdm-v1.2.*" here.

The question is what happens if the major or minor version goes beyond 9.
The total length of the prefix is hard-coded by the spec, hence my
expectation is that 1.10 will be represented as "dmtf-spdm-v1.a.*"
to not exceed the length.  The code follows that expectation.

Thanks for taking a look!   I've amended the patch to take all your
other feedback into account.

Lukas

