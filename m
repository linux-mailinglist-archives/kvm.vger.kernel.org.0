Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC817BA39B
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 17:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbjJEP6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 11:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbjJEP4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 11:56:46 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5782E9ED4;
        Thu,  5 Oct 2023 07:04:49 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 7B1A62800BBF3;
        Thu,  5 Oct 2023 16:04:47 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 662DD4DD3BE; Thu,  5 Oct 2023 16:04:47 +0200 (CEST)
Date:   Thu, 5 Oct 2023 16:04:47 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
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
Subject: Re: [PATCH 09/12] PCI/CMA: Validate Subject Alternative Name in
 certificates
Message-ID: <20231005140447.GA23472@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <bc1efd945f5d76587787f8351199e1ea45eaf2ef.1695921657.git.lukas@wunner.de>
 <20231003160455.00001a4f@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003160455.00001a4f@Huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023 at 04:04:55PM +0100, Jonathan Cameron wrote:
> On Thu, 28 Sep 2023 19:32:39 +0200 Lukas Wunner <lukas@wunner.de> wrote:
> > PCIe r6.1 sec 6.31.3 stipulates requirements for X.509 Leaf Certificates
> > presented by devices, in particular the presence of a Subject Alternative
> > Name extension with a name that encodes the Vendor ID, Device ID, Device
> > Serial Number, etc.
> 
> Lets you do any of
> * What you have here
> * Reference Integrity Manifest, e.g. see Trusted Computing Group
> * A pointer to a location where such a Reference Integrity Manifest can be
>   obtained.
> 
> So this text feels a little strong though I'm fine with only support the
> Subject Alternative Name bit for now. Whoever has one of the other options
> can add that support :)

I intend to amend the commit message as follows.  If anyone believes
this is inaccurate, please let me know:

    Side note:  Instead of a Subject Alternative Name, Leaf Certificates may
    include "a Reference Integrity Manifest, e.g., see Trusted Computing
    Group" or "a pointer to a location where such a Reference Integrity
    Manifest can be obtained" (PCIe r6.1 sec 6.31.3).

    A Reference Integrity Manifest contains "golden" measurements which can
    be compared to actual measurements retrieved from a device.  It serves a
    different purpose than the Subject Alternative Name, hence it is unclear
    why the spec says only either of them is necessary.  It is also unclear
    how a Reference Integrity Manifest shall be encoded into a certificate.

    Ignore the Reference Integrity Manifest requirement until this confusion
    is resolved by a spec update.


> I haven't looked asn.1 recently enough to have any confidence on
> a review of that bit...
> So, for everything except the asn.1
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

In case it raises the confidence in that portion of the patch,
I have tested it successfully not just with certificates containing
a single CMA otherName, but also:

- a single otherName with a different OID
- multiple otherNames with a mix of CMA and other OIDs
- multiple otherNames plus additional unrelated dNSNames
- no Subject Alternative Name

Getting the IMPLICIT annotations right was a bit nontrivial.
It turned out that the existing crypto/asymmetric_keys/x509_akid.asn1
got that wrong as well, so I fixed it up as a byproduct of this series:

https://git.kernel.org/herbert/cryptodev-2.6/c/a1e452026e6d

The debug experience made me appreciate the kernel's ASN.1 compiler
and parser though:  Their code is surprisingly small, the generated
output of the compiler is quite readable and the split architecture
with a compiler+parser feels much safer than what openssl does.

Thanks,

Lukas
