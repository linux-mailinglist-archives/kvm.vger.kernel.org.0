Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD9A7C7108
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379127AbjJLPJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346441AbjJLPJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:09:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E150FC0;
        Thu, 12 Oct 2023 08:09:36 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5tMX1WhJz67n0t;
        Thu, 12 Oct 2023 23:09:12 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Thu, 12 Oct
 2023 16:09:34 +0100
Date:   Thu, 12 Oct 2023 16:09:33 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Lukas Wunner <lukas@wunner.de>
CC:     Alistair Francis <Alistair.Francis@wdc.com>,
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
Message-ID: <20231012160933.00007c3d@Huawei.com>
In-Reply-To: <20231012071629.GA6305@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
        <20231003153937.000034ca@Huawei.com>
        <caf11c28d21382cc1a81d84a23cbca9e70805a87.camel@wdc.com>
        <20231012071629.GA6305@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Oct 2023 09:16:29 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> On Thu, Oct 12, 2023 at 03:26:44AM +0000, Alistair Francis wrote:
> > On Tue, 2023-10-03 at 15:39 +0100, Jonathan Cameron wrote:  
> > > On Thu, 28 Sep 2023 19:32:37 +0200 Lukas Wunner <lukas@wunner.de> wrote:  
> > > > This implementation supports SPDM 1.0 through 1.3 (the latest
> > > > version).  
> > > 
> > > I've no strong objection in allowing 1.0, but I think we do need
> > > to control min version accepted somehow as I'm not that keen to get
> > > security folk analyzing old version...  
> > 
> > Agreed. I'm not sure we even need to support 1.0  
> 
> According to PCIe r6.1 page 115 ("Reference Documents"):
> 
>    "CMA requires SPDM Version 1.0 or above.  IDE requires SPDM Version 1.1
>     or above.  TDISP requires version 1.2 or above."
> 
> This could be interpreted as SPDM 1.0 support being mandatory to be
> spec-compliant.  Even if we drop support for 1.0 from the initial
> bringup patches, someone could later come along and propose a patch
> to re-add it on the grounds of the above-quoted spec section.
> So I think we can't avoid it.

I checked with some of our security folk and they didn't provide a
reason to avoid 1.0.  It's not feature complete, but for what it does
it's fine.  So given the PCI spec line you quote keep it for now.
We should be careful to require the newer versions for the additional
features though. Can address that when it's relevant.

Jonathan
> 
> Thanks,
> 
> Lukas
> 

