Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194627C662E
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 09:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347073AbjJLHQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 03:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343607AbjJLHQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 03:16:34 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEC29D;
        Thu, 12 Oct 2023 00:16:31 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 904BD2800B1AF;
        Thu, 12 Oct 2023 09:16:29 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 821D9224D1; Thu, 12 Oct 2023 09:16:29 +0200 (CEST)
Date:   Thu, 12 Oct 2023 09:16:29 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Alistair Francis <Alistair.Francis@wdc.com>
Cc:     "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ming4.li@intel.com" <ming4.li@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "aik@amd.com" <aik@amd.com>,
        "david.e.box@intel.com" <david.e.box@intel.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH 07/12] spdm: Introduce library to authenticate devices
Message-ID: <20231012071629.GA6305@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
 <20231003153937.000034ca@Huawei.com>
 <caf11c28d21382cc1a81d84a23cbca9e70805a87.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caf11c28d21382cc1a81d84a23cbca9e70805a87.camel@wdc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 03:26:44AM +0000, Alistair Francis wrote:
> On Tue, 2023-10-03 at 15:39 +0100, Jonathan Cameron wrote:
> > On Thu, 28 Sep 2023 19:32:37 +0200 Lukas Wunner <lukas@wunner.de> wrote:
> > > This implementation supports SPDM 1.0 through 1.3 (the latest
> > > version).
> > 
> > I've no strong objection in allowing 1.0, but I think we do need
> > to control min version accepted somehow as I'm not that keen to get
> > security folk analyzing old version...
> 
> Agreed. I'm not sure we even need to support 1.0

According to PCIe r6.1 page 115 ("Reference Documents"):

   "CMA requires SPDM Version 1.0 or above.  IDE requires SPDM Version 1.1
    or above.  TDISP requires version 1.2 or above."

This could be interpreted as SPDM 1.0 support being mandatory to be
spec-compliant.  Even if we drop support for 1.0 from the initial
bringup patches, someone could later come along and propose a patch
to re-add it on the grounds of the above-quoted spec section.
So I think we can't avoid it.

Thanks,

Lukas
