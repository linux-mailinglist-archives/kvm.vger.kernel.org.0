Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F27BE20D
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 16:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377066AbjJIOCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 10:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376693AbjJIOCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 10:02:39 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53369D;
        Mon,  9 Oct 2023 07:02:37 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id E4D27100D943F;
        Mon,  9 Oct 2023 16:02:33 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B2D8A30D471; Mon,  9 Oct 2023 16:02:33 +0200 (CEST)
Date:   Mon, 9 Oct 2023 16:02:33 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Alexey Kardashevskiy <aik@amd.com>
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
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 12/12] PCI/CMA: Grant guests exclusive control of
 authentication
Message-ID: <20231009140233.GB7097@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
 <de5450a7-1395-490c-9767-7feee43e156a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de5450a7-1395-490c-9767-7feee43e156a@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 09:52:00PM +1100, Alexey Kardashevskiy wrote:
> On 29/9/23 03:32, Lukas Wunner wrote:
> > At any given time, only a single entity in a physical system may have
> > an SPDM connection to a device.  That's because the GET_VERSION request
> > (which begins an authentication sequence) resets "the connection and all
> > context associated with that connection" (SPDM 1.3.0 margin no 158).
> > 
> > Thus, when a device is passed through to a guest and the guest has
> > authenticated it, a subsequent authentication by the host would reset
> > the device's CMA-SPDM session behind the guest's back.
> > 
> > Prevent by letting the guest claim exclusive CMA ownership of the device
> > during passthrough.  Refuse CMA reauthentication on the host as long.
> > After passthrough has concluded, reauthenticate the device on the host.
[...]
> > --- a/drivers/pci/pci.h
> > +++ b/drivers/pci/pci.h
> > @@ -388,6 +388,7 @@ static inline bool pci_dev_is_disconnected(const struct pci_dev *dev)
> >   #define PCI_DEV_ADDED 0
> >   #define PCI_DPC_RECOVERED 1
> >   #define PCI_DPC_RECOVERING 2
> > +#define PCI_CMA_OWNED_BY_GUEST 3
> 
> In AMD SEV TIO, the PSP firmware creates an SPDM connection. What is the
> expected way of managing such ownership, a new priv_flags bit + api for it?

Right, I understand.  See this ongoing discussion in reply to the
cover letter:

https://lore.kernel.org/all/652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch/

In short, we need a spec amendment to negotiate between platform and
OS which of the two controls the DOE instance supporting CMA-SPDM.

I think the OS is free to access any Extended Capabilities in
Config Space unless the platform doesn't grant it control over
them through _OSC.  Because the _OSC definition in the PCI
Firmware Spec was not amended for CMA-SPDM, it is legal for the
OS to assume control of CMA-SPDM, which is what this patch does.

Thanks,

Lukas
