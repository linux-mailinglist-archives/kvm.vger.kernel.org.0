Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E170B7BB440
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjJFJaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjJFJa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:30:27 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614CDC6;
        Fri,  6 Oct 2023 02:30:25 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S23462Dsgz6HJbf;
        Fri,  6 Oct 2023 17:27:34 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 6 Oct
 2023 10:30:22 +0100
Date:   Fri, 6 Oct 2023 10:30:20 +0100
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
Subject: Re: [PATCH 12/12] PCI/CMA: Grant guests exclusive control of
 authentication
Message-ID: <20231006103020.0000174f@Huawei.com>
In-Reply-To: <20231003193058.GA16417@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
        <20231003164048.0000148c@Huawei.com>
        <20231003193058.GA16417@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
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

On Tue, 3 Oct 2023 21:30:58 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> On Tue, Oct 03, 2023 at 04:40:48PM +0100, Jonathan Cameron wrote:
> > On Thu, 28 Sep 2023 19:32:42 +0200 Lukas Wunner <lukas@wunner.de> wrote:  
> > > At any given time, only a single entity in a physical system may have
> > > an SPDM connection to a device.  That's because the GET_VERSION request
> > > (which begins an authentication sequence) resets "the connection and all
> > > context associated with that connection" (SPDM 1.3.0 margin no 158).
> > > 
> > > Thus, when a device is passed through to a guest and the guest has
> > > authenticated it, a subsequent authentication by the host would reset
> > > the device's CMA-SPDM session behind the guest's back.
> > > 
> > > Prevent by letting the guest claim exclusive CMA ownership of the device
> > > during passthrough.  Refuse CMA reauthentication on the host as long.
> > > After passthrough has concluded, reauthenticate the device on the host.  
> > 
> > Is there anything stopping a PF presenting multiple CMA capable DOE
> > instances?  I'd expect them to have their own contexts if they do..  
> 
> The spec does not seem to *explicitly* forbid a PF having multiple
> CMA-capable DOE instances, but PCIe r6.1 sec 6.31.3 says:
> "The instance of DOE used for CMA-SPDM must support ..."
> 
> Note the singular ("The instance").  It seems to suggest that the
> spec authors assumed there's only a single DOE instance for CMA-SPDM.

It's a little messy and a bit of American vs British English I think.
If it said
"The instance of DOE used for a specific CMA-SPDM must support..." 
then it would clearly allow multiple instances.  However, conversely,
I don't read that sentence as blocking multiple instances (even though
I suspect you are right and the author was thinking of there being one).

> 
> Could you (as an English native speaker) comment on the clarity of the
> two sentences "Prevent ... as long." above, as Ilpo objected to them?
> 
> The antecedent of "Prevent" is the undesirable behaviour in the preceding
> sentence (host resets guest's SPDM connection).
> 
> The antecedent of "as long" is "during passthrough" in the preceding
> sentence.
> 
> Is that clear and understandable for an English native speaker or
> should I rephrase?

Not clear enough to me as it stands.  That "as long" definitely feels
like there is more to follow it as Ilpo noted.

Maybe reword as something like 

Prevent this by letting the guest claim exclusive ownership of the device
during passthrough ensuring problematic CMA reauthentication by the host
is blocked.

Also combine this with previous paragraph to make the 'this' more obvious
refer to the problem described in that paragraph.

Jonathan

> 
> Thanks,
> 
> Lukas
> 

