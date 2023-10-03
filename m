Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2677B6432
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjJCIcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjJCIb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:31:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BD897;
        Tue,  3 Oct 2023 01:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696321916; x=1727857916;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=v3fgOooQ9HUZPXlIPgbbTivNdfJyGl6aZBvlfN9Whmc=;
  b=BQ0mz7hAZ/SS+BnyFlorSe3F8utizmSup4dkIg1BklxFUA5GMAJ5Bo8R
   tfQvgHsrdQEGtUNPPW8QjHWDfTXbls/W1N9e2/iyTXagKjEHfYetxZQOH
   GpJ3PulxsWUoHokKQfLuMwnfjMp/m6C9ZxrnBKWDMKxXuj8ThzIO1HjBs
   9vZ7DWuyUTkwQkN3zVPkdLDAW7tBXh9qr2XExYKv59XIJDhmLUmx9fJk2
   H+67hasFnwah6wCUkfnjiu3sXf+eFJQ5qRGcPiRrxLv83BlO34nLwQDtj
   niSysMBo2Uue/79tqFca3Th6SBkdSy1PvYzVKEANUMCLgxjhJKVJTGUeP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="362192310"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="362192310"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:31:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="924565188"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="924565188"
Received: from tciutacu-mobl.ger.corp.intel.com ([10.252.40.114])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:31:49 -0700
Date:   Tue, 3 Oct 2023 11:31:46 +0300 (EEST)
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
Subject: Re: [PATCH 02/12] X.509: Parse Subject Alternative Name in
 certificates
In-Reply-To: <704291cbc90ca3aaaaa56b191017c1400963cf12.1695921657.git.lukas@wunner.de>
Message-ID: <1d44be7b-c078-4b3c-50c1-61e15325fe5@linux.intel.com>
References: <cover.1695921656.git.lukas@wunner.de> <704291cbc90ca3aaaaa56b191017c1400963cf12.1695921657.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-470040028-1696321915=:2030"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-470040028-1696321915=:2030
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 28 Sep 2023, Lukas Wunner wrote:

> The upcoming support for PCI device authentication with CMA-SPDM
> (PCIe r6.1 sec 6.31) requires validating the Subject Alternative Name
> in X.509 certificates.
> 
> Store a pointer to the Subject Alternative Name upon parsing for
> consumption by CMA-SPDM.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
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
> 

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-470040028-1696321915=:2030--
