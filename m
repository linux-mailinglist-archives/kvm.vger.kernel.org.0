Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D947BE169
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 15:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377096AbjJINuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 09:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377093AbjJINuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 09:50:00 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6976694;
        Mon,  9 Oct 2023 06:49:58 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 88AF430001EC2;
        Mon,  9 Oct 2023 15:49:50 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 77C5D30D471; Mon,  9 Oct 2023 15:49:50 +0200 (CEST)
Date:   Mon, 9 Oct 2023 15:49:50 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <20231009134950.GA7097@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
 <20231007100433.GA7596@wunner.de>
 <20231009123335.00006d3d@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009123335.00006d3d@Huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 12:33:35PM +0100, Jonathan Cameron wrote:
> On Sat, 7 Oct 2023 12:04:33 +0200 Lukas Wunner <lukas@wunner.de> wrote:
> > On Fri, Oct 06, 2023 at 09:06:13AM -0700, Dan Williams wrote:
> > > Linux also has an interest in accommodating opt-in to using platform
> > > managed keys, so the design requires that key management and session
> > > ownership is a system owner policy choice.  
> > 
> > You're pointing out a gap in the specification:
> > 
> > There's an existing mechanism to negotiate which PCI features are
> > handled natively by the OS and which by platform firmware and that's
> > the _OSC Control Field (PCI Firmware Spec r3.3 table 4-5 and 4-6).
> > 
> > There are currently 10 features whose ownership is negotiated with _OSC,
> > examples are Hotplug control and DPC configuration control.
> > 
> > I propose adding an 11th bit to negotiate ownership of the CMA-SPDM
> > session.
> > 
> > Once that's added to the PCI Firmware Spec, amending the implementation
> > to honor it is trivial:  Just check for platform ownership at the top
> > of pci_cma_init() and return.
> 
> This might want to be a control over the specific DOE instance instead
> of a general purpose CMA control (or maybe we want both).
> 
> There is no safe way to access a DOE to find out if it supports CMA
> that doesn't potentially break another entity using the mailbox.
> Given the DOE instances might be for something entirely different we
> can't just decide not to use them at all based on a global control.

Per PCIe r6.1 sec 6.31.3, the DOE instance used for CMA-SPDM must support
"no other data object protocol(s)" besides DOE discovery, CMA-SPDM and
Secured CMA-SPDM.

So if the platform doesn't grant the OS control over that DOE instance,
unrelated DOE instances and protocols (such as CDAT retrieval) are not
affected.

E.g. PCI Firmware Spec r3.3 table 4-5 could be amended with something
along the lines of:

  Control Field Bit Offset: 11

  Interpretation: PCI Express Component Measurement and Authentication control

  The operating system sets this bit to 1 to request control over the
  DOE instance supporting the CMA-SPDM feature.

You're right that to discover the DOE instance for CMA-SPDM in the
first place, it needs to be accessed, which might interfere with the
firmware using it.  Perhaps this can be solved with the DOE Busy bit.


> Any such control becomes messy when hotplug is taken into account.
> I suppose we could do a _DSM based on BDF / path to device (to remain
> stable across reenumeration) and config space offset to allow the OS
> to say 'Hi other entity / firmware are you using this DOE instance?"
> Kind of an OSC with parameters.  Also includes the other way around that
> the question tells the firmware that if it says "no you can't" the OS
> will leave it alone until a reboot or similar - that potentially avoids
> the problem that we access DOE instances already without taking care
> about this

PCI Firmware Spec r3.3 table 4-7 lists a number of _DSM Definitions for
PCI.  Indeed that could be another solution.  E.g. a newly defined _DSM
might return the offset in config space of DOE instance(s) which the OS
is not permitted to use.


> (I dropped ball on this having raised it way back near start
> of us adding DOE support.)

Not your fault.  I think the industry got a bit ahead of itself in
its "confidential computing" frenzy and forgot to specify these very
basic things.


> If we do want to do any of these, which spec is appropriate?  Link it to PCI
> and propose a PCI firmware spec update? (not sure they have a code
> first process available) or make it somewhat generic and propose an
> ACPI Code first change?

PCI Firmware Spec would seem to be appropriate.  However this can't
be solved by the kernel community.  We need to talk to our confidential
computing architects and our representatives at the PCISIG to get the
spec amended.

Thanks,

Lukas
