Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468C97BF57B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442713AbjJJITR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379439AbjJJITQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:19:16 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A0C97;
        Tue, 10 Oct 2023 01:19:14 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 3F1AE2800A273;
        Tue, 10 Oct 2023 10:19:13 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 3176D58BE4D; Tue, 10 Oct 2023 10:19:13 +0200 (CEST)
Date:   Tue, 10 Oct 2023 10:19:13 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
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
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <20231010081913.GA24050@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
 <20231007100433.GA7596@wunner.de>
 <20231009123335.00006d3d@Huawei.com>
 <20231009134950.GA7097@wunner.de>
 <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:
> On 10/10/23 00:49, Lukas Wunner wrote:
> > PCI Firmware Spec would seem to be appropriate.  However this can't
> > be solved by the kernel community.
> 
> How so? It is up to the user to decide whether it is SPDM/CMA in the kernel
> or   the firmware + coco, both are quite possible (it is IDE which is not
> possible without the firmware on AMD but we are not there yet).

The user can control ownership of CMA-SPDM e.g. through a BIOS knob.
And that BIOS knob then influences the outcome of the _OSC negotiation
between platform and OS.


> But the way SPDM is done now is that if the user (as myself) wants to let
> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
> as CMA is not a (un)loadable module or built-in (with some "blacklist"
> parameters), and does not provide a sysfs knob to control its tentacles.

The problem is every single vendor thinks they can come up with
their own idea of who owns the SPDM session:

I've looked at the Nvidia driver and they've hacked libspdm into it,
so their idea is that the device driver owns the SPDM session.

AMD wants the host to proxy DOE but not own the SPDM session.

We have *standards* for a reason.  So that products are interoperable.

If the kernel tries to accommodate to every vendor's idea of SPDM ownership
we'll end up with an unmaintainable mess of quirks, plus sysfs knobs
which were once intended as a stopgap but can never be removed because
they're userspace ABI.

This needs to be solved in the *specification*.

And the existing solution for who owns a particular PCI feature is _OSC.
Hence this needs to be taken up with the Firmware Working Group at the
PCISIG.


> Note, this PSP firmware is not BIOS (which runs on the same core and has
> same access to PCI as the host OS), it is a separate platform processor
> which only programs IDE keys to the PCI RC (via some some internal bus
> mechanism) but does not do anything on the bus itself and relies on the host
> OS proxying DOE, and there is no APCI between the core and the psp.

Somewhat tangentially, would it be possible in your architecture
that the host or guest asks PSP to program IDE keys into the Root Port?
Or alternatively, access the key registers directly without PSP involvement?

Thanks,

Lukas
