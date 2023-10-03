Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC78B7B6CBD
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 17:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240257AbjJCPN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 11:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbjJCPN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 11:13:56 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F0AAD;
        Tue,  3 Oct 2023 08:13:51 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S0Lqx0FGnz67Rgg;
        Tue,  3 Oct 2023 23:11:09 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 3 Oct
 2023 16:13:48 +0100
Date:   Tue, 3 Oct 2023 16:13:48 +0100
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
Subject: Re: [PATCH 01/12] X.509: Make certificate parser public
Message-ID: <20231003161348.00002135@Huawei.com>
In-Reply-To: <e3d7c94d89e09a6985ac2bf0a6d192b007f454bf.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <e3d7c94d89e09a6985ac2bf0a6d192b007f454bf.1695921657.git.lukas@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
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

> The upcoming support for PCI device authentication with CMA-SPDM
> (PCIe r6.1 sec 6.31) requires validating the Subject Alternative Name
> in X.509 certificates.
> 
> High-level functions for X.509 parsing such as key_create_or_update()
> throw away the internal, low-level struct x509_certificate after
> extracting the struct public_key and public_key_signature from it.
> The Subject Alternative Name is thus inaccessible when using those
> functions.
> 
> Afford CMA-SPDM access to the Subject Alternative Name by making struct
> x509_certificate public, together with the functions for parsing an
> X.509 certificate into such a struct and freeing such a struct.
> 
> The private header file x509_parser.h previously included <linux/time.h>
> for the definition of time64_t.  That definition was since moved to
> <linux/time64.h> by commit 361a3bf00582 ("time64: Add time64.h header
> and define struct timespec64"), so adjust the #include directive as part
> of the move to the new public header file <keys/x509-parser.h>.
> 
> No functional change intended.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
Got to where this is used now in my review and it makes sense there.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  crypto/asymmetric_keys/x509_parser.h | 37 +----------------------
>  include/keys/x509-parser.h           | 44 ++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 36 deletions(-)
>  create mode 100644 include/keys/x509-parser.h
> 
> diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
> index a299c9c56f40..a7ef43c39002 100644
> --- a/crypto/asymmetric_keys/x509_parser.h
> +++ b/crypto/asymmetric_keys/x509_parser.h
> @@ -5,40 +5,7 @@
>   * Written by David Howells (dhowells@redhat.com)
>   */
>  
> -#include <linux/time.h>
> -#include <crypto/public_key.h>
> -#include <keys/asymmetric-type.h>
> -
> -struct x509_certificate {
> -	struct x509_certificate *next;
> -	struct x509_certificate *signer;	/* Certificate that signed this one */
> -	struct public_key *pub;			/* Public key details */
> -	struct public_key_signature *sig;	/* Signature parameters */
> -	char		*issuer;		/* Name of certificate issuer */
> -	char		*subject;		/* Name of certificate subject */
> -	struct asymmetric_key_id *id;		/* Issuer + Serial number */
> -	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
> -	time64_t	valid_from;
> -	time64_t	valid_to;
> -	const void	*tbs;			/* Signed data */
> -	unsigned	tbs_size;		/* Size of signed data */
> -	unsigned	raw_sig_size;		/* Size of signature */
> -	const void	*raw_sig;		/* Signature data */
> -	const void	*raw_serial;		/* Raw serial number in ASN.1 */
> -	unsigned	raw_serial_size;
> -	unsigned	raw_issuer_size;
> -	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
> -	const void	*raw_subject;		/* Raw subject name in ASN.1 */
> -	unsigned	raw_subject_size;
> -	unsigned	raw_skid_size;
> -	const void	*raw_skid;		/* Raw subjectKeyId in ASN.1 */
> -	unsigned	index;
> -	bool		seen;			/* Infinite recursion prevention */
> -	bool		verified;
> -	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
> -	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
> -	bool		blacklisted;
> -};
> +#include <keys/x509-parser.h>
>  
>  /*
>   * selftest.c
> @@ -52,8 +19,6 @@ static inline int fips_signature_selftest(void) { return 0; }
>  /*
>   * x509_cert_parser.c
>   */
> -extern void x509_free_certificate(struct x509_certificate *cert);
> -extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen);
>  extern int x509_decode_time(time64_t *_t,  size_t hdrlen,
>  			    unsigned char tag,
>  			    const unsigned char *value, size_t vlen);
> diff --git a/include/keys/x509-parser.h b/include/keys/x509-parser.h
> new file mode 100644
> index 000000000000..7c2ebc84791f
> --- /dev/null
> +++ b/include/keys/x509-parser.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* X.509 certificate parser
> + *
> + * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + */
> +
> +#include <crypto/public_key.h>
> +#include <keys/asymmetric-type.h>
> +#include <linux/time64.h>
> +
> +struct x509_certificate {
> +	struct x509_certificate *next;
> +	struct x509_certificate *signer;	/* Certificate that signed this one */
> +	struct public_key *pub;			/* Public key details */
> +	struct public_key_signature *sig;	/* Signature parameters */
> +	char		*issuer;		/* Name of certificate issuer */
> +	char		*subject;		/* Name of certificate subject */
> +	struct asymmetric_key_id *id;		/* Issuer + Serial number */
> +	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
> +	time64_t	valid_from;
> +	time64_t	valid_to;
> +	const void	*tbs;			/* Signed data */
> +	unsigned	tbs_size;		/* Size of signed data */
> +	unsigned	raw_sig_size;		/* Size of signature */
> +	const void	*raw_sig;		/* Signature data */
> +	const void	*raw_serial;		/* Raw serial number in ASN.1 */
> +	unsigned	raw_serial_size;
> +	unsigned	raw_issuer_size;
> +	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
> +	const void	*raw_subject;		/* Raw subject name in ASN.1 */
> +	unsigned	raw_subject_size;
> +	unsigned	raw_skid_size;
> +	const void	*raw_skid;		/* Raw subjectKeyId in ASN.1 */
> +	unsigned	index;
> +	bool		seen;			/* Infinite recursion prevention */
> +	bool		verified;
> +	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
> +	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
> +	bool		blacklisted;
> +};
> +
> +struct x509_certificate *x509_cert_parse(const void *data, size_t datalen);
> +void x509_free_certificate(struct x509_certificate *cert);

