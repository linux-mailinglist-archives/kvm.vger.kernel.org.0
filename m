Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F587C715F
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379376AbjJLPZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347301AbjJLPZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:25:11 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909EEDC;
        Thu, 12 Oct 2023 08:25:08 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5tfJ0vH6z67mY4;
        Thu, 12 Oct 2023 23:22:00 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Thu, 12 Oct
 2023 16:25:05 +0100
Date:   Thu, 12 Oct 2023 16:25:04 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     Lukas Wunner <lukas@wunner.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <20231012162504.00004bee@Huawei.com>
In-Reply-To: <78322d17-1fe7-4bfd-8073-64a7f0a1b0a2@amd.com>
References: <cover.1695921656.git.lukas@wunner.de>
        <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
        <20231007100433.GA7596@wunner.de>
        <20231009123335.00006d3d@Huawei.com>
        <20231009134950.GA7097@wunner.de>
        <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
        <20231012091542.GA22596@wunner.de>
        <78322d17-1fe7-4bfd-8073-64a7f0a1b0a2@amd.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
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

On Thu, 12 Oct 2023 22:18:27 +1100
Alexey Kardashevskiy <aik@amd.com> wrote:

> On 12/10/23 20:15, Lukas Wunner wrote:
> > On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:  
> >> But the way SPDM is done now is that if the user (as myself) wants to let
> >> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
> >> as CMA is not a (un)loadable module or built-in (with some "blacklist"
> >> parameters), and does not provide a sysfs knob to control its tentacles.
> >> Kinda harsh.  
> > 
> > On AMD SEV-TIO, does the PSP perform SPDM exchanges with a device
> > *before* it is passed through to a guest?  If so, why does it do that?  
> 
> Yes, to set up IDE. SEV TIO is designed in a way that there is one 
> stream == set of keys per the PF's traffic class.
> 
> It is like this - imagine a TDISP+SRIOV device with hundreds VFs passed 
> through to hundreds VMs. The host still owns the PF, provides DOE for 
> the PSP, the PSP owns a handful of keys (one will do really, I have not 
> fully grasped the idea when one would want traffic classes but ok, up to 
> 8), and hundreds VFs work using this few (or one) keys, and the PF works 
> as well, just cannot know the IDE key (==cannot spy on VFs via something 
> like PCI bridge/retimer or logic analyzer). It is different than what 
> you are doing, DOE is the only common thing so far (or ever?).
> 
> btw the PSP is not able to initiate SPDM traffic by itself, when the 
> host decides it wants to setup IDE (via a PSP in SEV TIO), it talks to 
> the PSP which can return "I want to talk to the device, here are 
> req/resp buffers", in a loop, until the PSP returns something else.
> 
> > Dan and I discussed this off-list and Dan is arguing for lazy attestation,
> > i.e. the TSM should only have the need to perform SPDM exchanges with
> > the device when it is passed through.  
> 
> Well, I'd expect that in most cases VF is going to be passed through and 
> IDE setup is done via PF which won't be passed through in such cases as 
> it has to manage VFs.
> 
> > So the host enumerates the DOE protocols  
> 
> Yes.
> 
> > and authenticates the device.  
> 
> No objection here. But PSP will need to rerun this, but still via the 
> host's DOE.
> 
> > When the device is passed through, patch 12/12 ensures that the host
> > keeps its hands off of the device, thus affording the TSM exclusive
> > SPDM control.  
> 
> If a PF is passed through - I guess yes we could use that, but how is 
> this going to work for a VF?
> 
> > I agree that the commit message of 12/12 is utterly misleading in that
> > it says "the guest" is granted exclusive control.  It should say "the TSM"
> > instead.  (There might be implementations where the guest itself has
> > the role of the TSM and authenticates the device on its own behalf,
> > but PCIe r6.1 sec 11 uses the term "TSM" so that's what the commit
> > message needs to use.)  
> 
> This should work as long as DOE is still available (as of today).
> 
> > However apart from the necessary rewrite of the commit message and
> > perhaps a rename of the PCI_CMA_OWNED_BY_GUEST flag, I think patch 12/12
> > should already be doing exactly what you need -- provided that the
> > PSP doesn't perform SPDM exchanges before passthrough.  If it already
> > performs them, say, on boot, I'd like to understand the reason.  
> 
> In out design this does not have to happen on the host's boot. But I 
> wonder if some PF host driver authenticated some device and then we 
> create a bunch of VFs and pass the SPDM ownership of the PF to the PSP 
> to reauthentificate it again - the already running PF host driver may 
> become upset, may it? 12/12 assumes the host driver is VFIO-PCI but it 
> won't be, VFs will be bound to VFIO-PCI. Hope this all makes sense. Thanks,

Without some experiments with real drivers, will be hard to be sure, but
I'd expect it to be fine as the host driver bound after attestation (or
what's the point?)
In this patch set attestation only happens again on a reset or kicking it
because of new certs.  For reset, your PSP should be doing it all over again
anyway so that can happen after the host driver has dealt with the reset.
For the manual poking to retry attestation, if the model is we don't
load the driver until the attestation succeeds then that should be fine
(as driver not loaded).

The lock out needed for PF pass through doesn't apply given we are poking
it from the PSP via the host.

So I think patch 12 is irrelevant to your usecase rather than a problem.

May well be dragons in the corner cases.  If we need a lockout for
after the PSP gets involved, then fair enough.

Jonathan

> 
> 
> > 
> > Thanks,
> > 
> > Lukas  
> 

