Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07A47C6940
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 11:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbjJLJQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 05:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbjJLJP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 05:15:59 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C274ED;
        Thu, 12 Oct 2023 02:15:45 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id DACAF100DCEF1;
        Thu, 12 Oct 2023 11:15:42 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8BED2224D1; Thu, 12 Oct 2023 11:15:42 +0200 (CEST)
Date:   Thu, 12 Oct 2023 11:15:42 +0200
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
Message-ID: <20231012091542.GA22596@wunner.de>
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
> But the way SPDM is done now is that if the user (as myself) wants to let
> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
> as CMA is not a (un)loadable module or built-in (with some "blacklist"
> parameters), and does not provide a sysfs knob to control its tentacles.
> Kinda harsh.

On AMD SEV-TIO, does the PSP perform SPDM exchanges with a device
*before* it is passed through to a guest?  If so, why does it do that?

Dan and I discussed this off-list and Dan is arguing for lazy attestation,
i.e. the TSM should only have the need to perform SPDM exchanges with
the device when it is passed through.

So the host enumerates the DOE protocols and authenticates the device.
When the device is passed through, patch 12/12 ensures that the host
keeps its hands off of the device, thus affording the TSM exclusive
SPDM control.

I agree that the commit message of 12/12 is utterly misleading in that
it says "the guest" is granted exclusive control.  It should say "the TSM"
instead.  (There might be implementations where the guest itself has
the role of the TSM and authenticates the device on its own behalf,
but PCIe r6.1 sec 11 uses the term "TSM" so that's what the commit
message needs to use.)

However apart from the necessary rewrite of the commit message and
perhaps a rename of the PCI_CMA_OWNED_BY_GUEST flag, I think patch 12/12
should already be doing exactly what you need -- provided that the
PSP doesn't perform SPDM exchanges before passthrough.  If it already
performs them, say, on boot, I'd like to understand the reason.

Thanks,

Lukas
