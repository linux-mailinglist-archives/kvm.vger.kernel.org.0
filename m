Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46497B5887
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 18:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbjJBQpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 12:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbjJBQpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 12:45:03 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A2A9B;
        Mon,  2 Oct 2023 09:44:59 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RzmyS5506z6K6gc;
        Tue,  3 Oct 2023 00:44:48 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 2 Oct
 2023 17:44:55 +0100
Date:   Mon, 2 Oct 2023 17:44:54 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Lukas Wunner <lukas@wunner.de>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
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
Message-ID: <20231002174454.000025c5@Huawei.com>
In-Reply-To: <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023 19:32:32 +0200
Lukas Wunner <lukas@wunner.de> wrote:

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

Good find :)  I vaguely remember carrying a hack for this so
good to do something more general + save on the duplication.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


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
> +{
> +	int plen;
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

