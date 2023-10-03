Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40F97B6503
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 11:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjJCJKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 05:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjJCJKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 05:10:51 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B0AAC;
        Tue,  3 Oct 2023 02:10:45 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S0BpC1Mm1z6K60k;
        Tue,  3 Oct 2023 17:09:07 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 3 Oct
 2023 10:10:42 +0100
Date:   Tue, 3 Oct 2023 10:10:41 +0100
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
Subject: Re: [PATCH 04/12] certs: Create blacklist keyring earlier
Message-ID: <20231003101041.00006511@Huawei.com>
In-Reply-To: <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
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
Indeed seems like it needs to be before subsys_initcall so whilst
it feels a bit weird to do it in one named arch, I guess that's the best choice
available.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

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

