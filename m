Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2E97B6CC1
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbjJCPOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 11:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbjJCPOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 11:14:17 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BA0A1;
        Tue,  3 Oct 2023 08:14:14 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S0LvG41k7z6K7KY;
        Tue,  3 Oct 2023 23:14:02 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 3 Oct
 2023 16:14:11 +0100
Date:   Tue, 3 Oct 2023 16:14:10 +0100
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
Subject: Re: [PATCH 02/12] X.509: Parse Subject Alternative Name in
 certificates
Message-ID: <20231003161410.00000d2c@Huawei.com>
In-Reply-To: <704291cbc90ca3aaaaa56b191017c1400963cf12.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <704291cbc90ca3aaaaa56b191017c1400963cf12.1695921657.git.lukas@wunner.de>
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
> Store a pointer to the Subject Alternative Name upon parsing for
> consumption by CMA-SPDM.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  crypto/asymmetric_keys/x509_cert_parser.c | 15 +++++++++++++++
>  include/keys/x509-parser.h                |  2 ++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
> index 0a7049b470c1..18dfd564740b 100644
> --- a/crypto/asymmetric_keys/x509_cert_parser.c
> +++ b/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -579,6 +579,21 @@ int x509_process_extension(void *context, size_t hdrlen,
>  		return 0;
>  	}
>  
> +	if (ctx->last_oid == OID_subjectAltName) {
> +		/*
> +		 * A certificate MUST NOT include more than one instance
> +		 * of a particular extension (RFC 5280 sec 4.2).
> +		 */
> +		if (ctx->cert->raw_san) {
> +			pr_err("Duplicate Subject Alternative Name\n");
> +			return -EINVAL;
> +		}
> +
> +		ctx->cert->raw_san = v;
> +		ctx->cert->raw_san_size = vlen;
> +		return 0;
> +	}
> +
>  	if (ctx->last_oid == OID_keyUsage) {
>  		/*
>  		 * Get hold of the keyUsage bit string
> diff --git a/include/keys/x509-parser.h b/include/keys/x509-parser.h
> index 7c2ebc84791f..9c6e7cdf4870 100644
> --- a/include/keys/x509-parser.h
> +++ b/include/keys/x509-parser.h
> @@ -32,6 +32,8 @@ struct x509_certificate {
>  	unsigned	raw_subject_size;
>  	unsigned	raw_skid_size;
>  	const void	*raw_skid;		/* Raw subjectKeyId in ASN.1 */
> +	const void	*raw_san;		/* Raw subjectAltName in ASN.1 */
> +	unsigned	raw_san_size;
>  	unsigned	index;
>  	bool		seen;			/* Infinite recursion prevention */
>  	bool		verified;

