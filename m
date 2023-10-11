Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6F67C5962
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 18:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjJKQmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 12:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjJKQmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 12:42:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADA994;
        Wed, 11 Oct 2023 09:42:44 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5JQL37Nlz6JB49;
        Thu, 12 Oct 2023 00:39:38 +0800 (CST)
Received: from localhost (10.126.175.8) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 11 Oct
 2023 17:42:41 +0100
Date:   Wed, 11 Oct 2023 17:42:40 +0100
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
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <20231011174240.00006c22@Huawei.com>
In-Reply-To: <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
References: <cover.1695921656.git.lukas@wunner.de>
        <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
        <20231007100433.GA7596@wunner.de>
        <20231009123335.00006d3d@Huawei.com>
        <20231009134950.GA7097@wunner.de>
        <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.175.8]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
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

On Tue, 10 Oct 2023 15:07:41 +1100
Alexey Kardashevskiy <aik@amd.com> wrote:

> On 10/10/23 00:49, Lukas Wunner wrote:
> > On Mon, Oct 09, 2023 at 12:33:35PM +0100, Jonathan Cameron wrote:  
> >> On Sat, 7 Oct 2023 12:04:33 +0200 Lukas Wunner <lukas@wunner.de> wrote:  
> >>> On Fri, Oct 06, 2023 at 09:06:13AM -0700, Dan Williams wrote:  
> >>>> Linux also has an interest in accommodating opt-in to using platform
> >>>> managed keys, so the design requires that key management and session
> >>>> ownership is a system owner policy choice.  
> >>>
> >>> You're pointing out a gap in the specification:
> >>>
> >>> There's an existing mechanism to negotiate which PCI features are
> >>> handled natively by the OS and which by platform firmware and that's
> >>> the _OSC Control Field (PCI Firmware Spec r3.3 table 4-5 and 4-6).
> >>>
> >>> There are currently 10 features whose ownership is negotiated with _OSC,
> >>> examples are Hotplug control and DPC configuration control.
> >>>
> >>> I propose adding an 11th bit to negotiate ownership of the CMA-SPDM
> >>> session.
> >>>
> >>> Once that's added to the PCI Firmware Spec, amending the implementation
> >>> to honor it is trivial:  Just check for platform ownership at the top
> >>> of pci_cma_init() and return.  
> >>
> >> This might want to be a control over the specific DOE instance instead
> >> of a general purpose CMA control (or maybe we want both).
> >>
> >> There is no safe way to access a DOE to find out if it supports CMA
> >> that doesn't potentially break another entity using the mailbox.
> >> Given the DOE instances might be for something entirely different we
> >> can't just decide not to use them at all based on a global control.  
> > 
> > Per PCIe r6.1 sec 6.31.3, the DOE instance used for CMA-SPDM must support
> > "no other data object protocol(s)" besides DOE discovery, CMA-SPDM and
> > Secured CMA-SPDM.
> > 
> > So if the platform doesn't grant the OS control over that DOE instance,
> > unrelated DOE instances and protocols (such as CDAT retrieval) are not
> > affected.
> > 
> > E.g. PCI Firmware Spec r3.3 table 4-5 could be amended with something
> > along the lines of:
> > 
> >    Control Field Bit Offset: 11
> > 
> >    Interpretation: PCI Express Component Measurement and Authentication control
> > 
> >    The operating system sets this bit to 1 to request control over the
> >    DOE instance supporting the CMA-SPDM feature.
> > 
> > You're right that to discover the DOE instance for CMA-SPDM in the
> > first place, it needs to be accessed, which might interfere with the
> > firmware using it.  Perhaps this can be solved with the DOE Busy bit.
> > 
> >   
> >> Any such control becomes messy when hotplug is taken into account.
> >> I suppose we could do a _DSM based on BDF / path to device (to remain
> >> stable across reenumeration) and config space offset to allow the OS
> >> to say 'Hi other entity / firmware are you using this DOE instance?"
> >> Kind of an OSC with parameters.  Also includes the other way around that
> >> the question tells the firmware that if it says "no you can't" the OS
> >> will leave it alone until a reboot or similar - that potentially avoids
> >> the problem that we access DOE instances already without taking care
> >> about this  
> > 
> > PCI Firmware Spec r3.3 table 4-7 lists a number of _DSM Definitions for
> > PCI.  Indeed that could be another solution.  E.g. a newly defined _DSM
> > might return the offset in config space of DOE instance(s) which the OS
> > is not permitted to use.
> > 
> >   
> >> (I dropped ball on this having raised it way back near start
> >> of us adding DOE support.)  
> > 
> > Not your fault.  I think the industry got a bit ahead of itself in
> > its "confidential computing" frenzy and forgot to specify these very
> > basic things.
> > 
> >   
> >> If we do want to do any of these, which spec is appropriate?  Link it to PCI
> >> and propose a PCI firmware spec update? (not sure they have a code
> >> first process available) or make it somewhat generic and propose an
> >> ACPI Code first change?  
> > 
> > PCI Firmware Spec would seem to be appropriate.  However this can't
> > be solved by the kernel community.  
> 
> How so? It is up to the user to decide whether it is SPDM/CMA in the 
> kernel   or   the firmware + coco, both are quite possible (it is IDE 
> which is not possible without the firmware on AMD but we are not there yet).
> 
> But the way SPDM is done now is that if the user (as myself) wants to 
> let the firmware run SPDM - the only choice is disabling CONFIG_CMA 
> completely as CMA is not a (un)loadable module or built-in (with some 
> "blacklist" parameters), and does not provide a sysfs knob to control 
> its tentacles. Kinda harsh.

Not necessarily sufficient unfortunately - if you have a CXL type3 device,
we will run the discovery protocol on the DOE to find out what it supports
(looking for table access protocol used for CDAT). If that hits at wrong point it
will likely break your CMA usage unless you have some hardware lockout of
the relevant PCI config space (in which case that will work with CONFIG_CMA
enabled).

Now you might not care about CXL type 3 devices today, but pretty sure someone
will at somepoint.  Or one of the other uses of DOEs will be relevant.
You might be fine assuming only drivers you've bound ever access the devices
config space, but much nicer to have something standard to ensure that if
we can (and driver specific stuff will deal with it in the short term).

Jonathan

> 
> Note, this PSP firmware is not BIOS (which runs on the same core and has 
> same access to PCI as the host OS), it is a separate platform processor 
> which only programs IDE keys to the PCI RC (via some some internal bus 
> mechanism) but does not do anything on the bus itself and relies on the 
> host OS proxying DOE, and there is no APCI between the core and the psp.
> 
> 
> >  We need to talk to our confidential
> > computing architects and our representatives at the PCISIG to get the
> > spec amended.
> > 
> > Thanks,
> > 
> > Lukas  
> 

