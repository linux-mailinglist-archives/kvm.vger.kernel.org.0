Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDC97BC69F
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 12:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343741AbjJGKEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 06:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbjJGKEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 06:04:40 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BED6CE;
        Sat,  7 Oct 2023 03:04:39 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 593B6100D587B;
        Sat,  7 Oct 2023 12:04:33 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 22C151C0227; Sat,  7 Oct 2023 12:04:33 +0200 (CEST)
Date:   Sat, 7 Oct 2023 12:04:33 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
Message-ID: <20231007100433.GA7596@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 06, 2023 at 09:06:13AM -0700, Dan Williams wrote:
> Lukas Wunner wrote:
> > The root of trust is initially an in-kernel key ring of certificates.
> > We can discuss linking the system key ring into it, thereby allowing
> > EFI to pass trusted certificates to the kernel for CMA.  Alternatively,
> > a bundle of trusted certificates could be loaded from the initrd.
> > I envision that we'll add TPMs or remote attestation services such as
> > https://keylime.dev/ to create an ecosystem of various trust sources.
> 
> Linux also has an interest in accommodating opt-in to using platform
> managed keys, so the design requires that key management and session
> ownership is a system owner policy choice.

You're pointing out a gap in the specification:

There's an existing mechanism to negotiate which PCI features are
handled natively by the OS and which by platform firmware and that's
the _OSC Control Field (PCI Firmware Spec r3.3 table 4-5 and 4-6).

There are currently 10 features whose ownership is negotiated with _OSC,
examples are Hotplug control and DPC configuration control.

I propose adding an 11th bit to negotiate ownership of the CMA-SPDM
session.

Once that's added to the PCI Firmware Spec, amending the implementation
to honor it is trivial:  Just check for platform ownership at the top
of pci_cma_init() and return.

Thanks,

Lukas
