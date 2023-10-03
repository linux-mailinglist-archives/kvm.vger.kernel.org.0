Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFFE7B71E6
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbjJCTlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 15:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjJCTlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 15:41:17 -0400
X-Greylist: delayed 613 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Oct 2023 12:41:13 PDT
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD25293;
        Tue,  3 Oct 2023 12:41:13 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 820FB100D9414;
        Tue,  3 Oct 2023 21:30:58 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 2DF8042A4F9; Tue,  3 Oct 2023 21:30:58 +0200 (CEST)
Date:   Tue, 3 Oct 2023 21:30:58 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
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
Message-ID: <20231003193058.GA16417@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
 <20231003164048.0000148c@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003164048.0000148c@Huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023 at 04:40:48PM +0100, Jonathan Cameron wrote:
> On Thu, 28 Sep 2023 19:32:42 +0200 Lukas Wunner <lukas@wunner.de> wrote:
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
> 
> Is there anything stopping a PF presenting multiple CMA capable DOE
> instances?  I'd expect them to have their own contexts if they do..

The spec does not seem to *explicitly* forbid a PF having multiple
CMA-capable DOE instances, but PCIe r6.1 sec 6.31.3 says:
"The instance of DOE used for CMA-SPDM must support ..."

Note the singular ("The instance").  It seems to suggest that the
spec authors assumed there's only a single DOE instance for CMA-SPDM.

Could you (as an English native speaker) comment on the clarity of the
two sentences "Prevent ... as long." above, as Ilpo objected to them?

The antecedent of "Prevent" is the undesirable behaviour in the preceding
sentence (host resets guest's SPDM connection).

The antecedent of "as long" is "during passthrough" in the preceding
sentence.

Is that clear and understandable for an English native speaker or
should I rephrase?

Thanks,

Lukas
