Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB0C7BD9F6
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346315AbjJILdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346227AbjJILdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:33:41 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4848594;
        Mon,  9 Oct 2023 04:33:40 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S3xjq4l38z6K918;
        Mon,  9 Oct 2023 19:33:19 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 9 Oct
 2023 12:33:36 +0100
Date:   Mon, 9 Oct 2023 12:33:35 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Lukas Wunner <lukas@wunner.de>
CC:     Dan Williams <dan.j.williams@intel.com>,
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
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <20231009123335.00006d3d@Huawei.com>
In-Reply-To: <20231007100433.GA7596@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
        <20231007100433.GA7596@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
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

On Sat, 7 Oct 2023 12:04:33 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> On Fri, Oct 06, 2023 at 09:06:13AM -0700, Dan Williams wrote:
> > Lukas Wunner wrote:  
> > > The root of trust is initially an in-kernel key ring of certificates.
> > > We can discuss linking the system key ring into it, thereby allowing
> > > EFI to pass trusted certificates to the kernel for CMA.  Alternatively,
> > > a bundle of trusted certificates could be loaded from the initrd.
> > > I envision that we'll add TPMs or remote attestation services such as
> > > https://keylime.dev/ to create an ecosystem of various trust sources.  
> > 
> > Linux also has an interest in accommodating opt-in to using platform
> > managed keys, so the design requires that key management and session
> > ownership is a system owner policy choice.  
> 
> You're pointing out a gap in the specification:
> 
> There's an existing mechanism to negotiate which PCI features are
> handled natively by the OS and which by platform firmware and that's
> the _OSC Control Field (PCI Firmware Spec r3.3 table 4-5 and 4-6).
> 
> There are currently 10 features whose ownership is negotiated with _OSC,
> examples are Hotplug control and DPC configuration control.
> 
> I propose adding an 11th bit to negotiate ownership of the CMA-SPDM
> session.
> 
> Once that's added to the PCI Firmware Spec, amending the implementation
> to honor it is trivial:  Just check for platform ownership at the top
> of pci_cma_init() and return.

This might want to be a control over the specific DOE instance instead
of a general purpose CMA control (or maybe we want both).

There is no safe way to access a DOE to find out if it supports CMA
that doesn't potentially break another entity using the mailbox.
Given the DOE instances might be for something entirely different we
can't just decide not to use them at all based on a global control.

Any such control becomes messy when hotplug is taken into account.
I suppose we could do a _DSM based on BDF / path to device (to remain
stable across reenumeration) and config space offset to allow the OS
to say 'Hi other entity / firmware are you using this DOE instance?"
Kind of an OSC with parameters.  Also includes the other way around that
the question tells the firmware that if it says "no you can't" the OS
will leave it alone until a reboot or similar - that potentially avoids
the problem that we access DOE instances already without taking care
about this (I dropped ball on this having raised it way back near start
of us adding DOE support.)

If we do want to do any of these, which spec is appropriate?  Link it to PCI
and propose a PCI firmware spec update? (not sure they have a code
first process available) or make it somewhat generic and propose an
ACPI Code first change?

Jonathan

> 
> Thanks,
> 
> Lukas
> 
> 

