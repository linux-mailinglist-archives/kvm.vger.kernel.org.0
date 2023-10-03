Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B5F7B642D
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbjJCIbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239298AbjJCIbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:31:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CB6AD;
        Tue,  3 Oct 2023 01:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696321891; x=1727857891;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=xvRTEJgiLM4R8J7f3Dw6MhEmiMJyQfp7liKkGIGPBHQ=;
  b=T6uvfCTCZvES4Eaz0/0jVBpbBZaJ/m8GAvwFHXlZ+TWNPCo1PI0D9Rw0
   2vzKUfccromOazCcTIHb1c1JswynfKwYP6yozSiDWYvbOeJCiIJr91IPm
   oOoacJaSmsZY9+r1CBp+3xbUYKkGLzy10BZT0CmzInWnMthVDzUxqRrTJ
   /XPpnFb9TNRe7n6Db/KgAyDvA6fzIpL2jjYTlFMQvMb18YNcbmGlvLN9c
   SY6YNqdLKLYR51p7dLWMYs87QMnTjimDLRz14x9yhGA4f0zRQVGBdnRtq
   c1W2YoNZZZccixaOvPlBWkfugDR8L3QFOKE9L63NAgPjVt6MUEWuWLAtm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1413573"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1413573"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:31:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="874639937"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="874639937"
Received: from tciutacu-mobl.ger.corp.intel.com (HELO rrabie-mobl.amr.corp.intel.com) ([10.252.40.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:31:22 -0700
Date:   Tue, 3 Oct 2023 11:31:20 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Lukas Wunner <lukas@wunner.de>
cc:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 03/12] X.509: Move certificate length retrieval into new
 helper
In-Reply-To: <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
Message-ID: <76259143-d07e-e042-73a1-677094211361@linux.intel.com>
References: <cover.1695921656.git.lukas@wunner.de> <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023, Lukas Wunner wrote:

> The upcoming in-kernel SPDM library (Security Protocol and Data Model,
> https://www.dmtf.org/dsp/DSP0274) needs to retrieve the length from
> ASN.1 DER-encoded X.509 certificates.
> 
> Such code already exists in x509_load_certificate_list(), so move it
> into a new helper for reuse by SPDM.
> 
> No functional change intended.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/asymmetric_keys/x509_loader.c | 38 +++++++++++++++++++---------
>  include/keys/asymmetric-type.h       |  2 ++
>  2 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_keys/x509_loader.c
> index a41741326998..121460a0de46 100644
> --- a/crypto/asymmetric_keys/x509_loader.c
> +++ b/crypto/asymmetric_keys/x509_loader.c
> @@ -4,28 +4,42 @@
>  #include <linux/key.h>
>  #include <keys/asymmetric-type.h>
>  
> +int x509_get_certificate_length(const u8 *p, unsigned long buflen)

Make the return type ssize_t.

unsigned long -> size_t buflen (or perhaps ssize_t if you want to compare 
below to have the same signedness).

> +{
> +	int plen;

ssize_t

> +
> +	/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
> +	 * than 256 bytes in size.
> +	 */
> +	if (buflen < 4)
> +		return -EINVAL;
> +
> +	if (p[0] != 0x30 &&
> +	    p[1] != 0x82)
> +		return -EINVAL;
> +
> +	plen = (p[2] << 8) | p[3];
> +	plen += 4;
> +	if (plen > buflen)
> +		return -EINVAL;
> +
> +	return plen;
> +}
> +EXPORT_SYMBOL_GPL(x509_get_certificate_length);
> +
>  int x509_load_certificate_list(const u8 cert_list[],
>  			       const unsigned long list_size,
>  			       const struct key *keyring)
>  {
>  	key_ref_t key;
>  	const u8 *p, *end;
> -	size_t plen;
> +	int plen;

ssize_t plen.

-- 
 i.

>  
>  	p = cert_list;
>  	end = p + list_size;
>  	while (p < end) {
> -		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
> -		 * than 256 bytes in size.
> -		 */
> -		if (end - p < 4)
> -			goto dodgy_cert;
> -		if (p[0] != 0x30 &&
> -		    p[1] != 0x82)
> -			goto dodgy_cert;
> -		plen = (p[2] << 8) | p[3];
> -		plen += 4;
> -		if (plen > end - p)
> +		plen = x509_get_certificate_length(p, end - p);
> +		if (plen < 0)
>  			goto dodgy_cert;
>  
>  		key = key_create_or_update(make_key_ref(keyring, 1),
> diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
> index 69a13e1e5b2e..6705cfde25b9 100644
> --- a/include/keys/asymmetric-type.h
> +++ b/include/keys/asymmetric-type.h
> @@ -84,6 +84,8 @@ extern struct key *find_asymmetric_key(struct key *keyring,
>  				       const struct asymmetric_key_id *id_2,
>  				       bool partial);
>  
> +int x509_get_certificate_length(const u8 *p, unsigned long buflen);
> +
>  int x509_load_certificate_list(const u8 cert_list[], const unsigned long list_size,
>  			       const struct key *keyring);
>  
> 
