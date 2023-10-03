Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902657B6C98
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbjJCPFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 11:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjJCPFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 11:05:04 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A15A7;
        Tue,  3 Oct 2023 08:05:01 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S0Ldj6N6Bz6HJcm;
        Tue,  3 Oct 2023 23:02:17 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 3 Oct
 2023 16:04:56 +0100
Date:   Tue, 3 Oct 2023 16:04:55 +0100
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
Subject: Re: [PATCH 09/12] PCI/CMA: Validate Subject Alternative Name in
 certificates
Message-ID: <20231003160455.00001a4f@Huawei.com>
In-Reply-To: <bc1efd945f5d76587787f8351199e1ea45eaf2ef.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <bc1efd945f5d76587787f8351199e1ea45eaf2ef.1695921657.git.lukas@wunner.de>
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

On Thu, 28 Sep 2023 19:32:39 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> PCIe r6.1 sec 6.31.3 stipulates requirements for X.509 Leaf Certificates
> presented by devices, in particular the presence of a Subject Alternative
> Name extension with a name that encodes the Vendor ID, Device ID, Device
> Serial Number, etc.

Lets you do any of
* What you have here
* Reference Integrity Manifest, e.g. see Trusted Computing Group
* A pointer to a location where such a Reference Integrity Manifest can be
  obtained.

So this text feels a little strong though I'm fine with only support the
Subject Alternative Name bit for now. Whoever has one of the other options
can add that support :)

> 
> This prevents a mismatch between the device identity in Config Space and
> the certificate.  A device cannot misappropriate a certificate from a
> different device without also spoofing Config Space.  As a corollary,
> it cannot dupe an arbitrary driver into binding to it.  (Only those
> which bind to the device identity in the Subject Alternative Name work.)
> 
> Parse the Subject Alternative Name using a small ASN.1 module and
> validate its contents.  The theory of operation is explained in a code
> comment at the top of the newly added cma-x509.c.
> 
> This functionality is introduced in a separate commit on top of basic
> CMA-SPDM support to split the code into digestible, reviewable chunks.
> 
> The CMA OID added here is taken from the official OID Repository
> (it's not documented in the PCIe Base Spec):
> https://oid-rep.orange-labs.fr/get/2.23.147
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

I haven't looked asn.1 recently enough to have any confidence on
a review of that bit...
So, for everything except the asn.1
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


