Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0477B6465
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 10:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbjJCIiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 04:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjJCIiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 04:38:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6DCA4;
        Tue,  3 Oct 2023 01:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696322283; x=1727858283;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=380/oSJwz+ChU1zJ9C8pcG2L+2mNW4PSQa0Sq/ZkMl0=;
  b=BSU5bmHJe4xG1Y3CLEtPhVI8J6pR/EnfYPTzxqjUV+d+Ac3lN4H067mk
   PgojpqIO00C7CfMVQ18MeFnBEuktx3rPmsBi3hrbdKK/87nVHMGLSbkrX
   cVXsNg1vChr027gek/ZjHM+pLR8nsZhXZuol3Y2SnTnDDeHlcpgxHfLQk
   cFBy5ISi0tX9xkP8Ng9RPltciJcAancBSW0jY1LkBTYJbwW38Zv3B/8MU
   JkH0dz4wSTntEnY0LSzeS5zEHr8qrfO73K1E9IJ44OgUuslhSi0eDNXXl
   DVG/AkjlTTPZmzrhH2EB+8ODCpDtGSu2nEO6XRzkXCVAKjgzxxyUOrJ1k
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="362193143"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="362193143"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:38:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="786023424"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="786023424"
Received: from tciutacu-mobl.ger.corp.intel.com ([10.252.40.114])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:37:55 -0700
Date:   Tue, 3 Oct 2023 11:37:53 +0300 (EEST)
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
Subject: Re: [PATCH 04/12] certs: Create blacklist keyring earlier
In-Reply-To: <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
Message-ID: <7e98a953-a4b-70e8-caeb-a94237e593f8@linux.intel.com>
References: <cover.1695921656.git.lukas@wunner.de> <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-242978425-1696322281=:2030"
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

--8323329-242978425-1696322281=:2030
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 28 Sep 2023, Lukas Wunner wrote:

> The upcoming support for PCI device authentication with CMA-SPDM
> (PCIe r6.1 sec 6.31) requires parsing X.509 certificates upon
> device enumeration, which happens in a subsys_initcall().
> 
> Parsing X.509 certificates accesses the blacklist keyring:
> x509_cert_parse()
>   x509_get_sig_params()
>     is_hash_blacklisted()
>       keyring_search()
> 
> So far the keyring is created much later in a device_initcall().  Avoid
> a NULL pointer dereference on access to the keyring by creating it one
> initcall level earlier than PCI device enumeration, i.e. in an
> arch_initcall().
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  certs/blacklist.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/certs/blacklist.c b/certs/blacklist.c
> index 675dd7a8f07a..34185415d451 100644
> --- a/certs/blacklist.c
> +++ b/certs/blacklist.c
> @@ -311,7 +311,7 @@ static int restrict_link_for_blacklist(struct key *dest_keyring,
>   * Initialise the blacklist
>   *
>   * The blacklist_init() function is registered as an initcall via
> - * device_initcall().  As a result if the blacklist_init() function fails for
> + * arch_initcall().  As a result if the blacklist_init() function fails for
>   * any reason the kernel continues to execute.  While cleanly returning -ENODEV
>   * could be acceptable for some non-critical kernel parts, if the blacklist
>   * keyring fails to load it defeats the certificate/key based deny list for
> @@ -356,7 +356,7 @@ static int __init blacklist_init(void)
>  /*
>   * Must be initialised before we try and load the keys into the keyring.
>   */
> -device_initcall(blacklist_init);
> +arch_initcall(blacklist_init);
>  
>  #ifdef CONFIG_SYSTEM_REVOCATION_LIST
>  /*
> 

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-242978425-1696322281=:2030--
