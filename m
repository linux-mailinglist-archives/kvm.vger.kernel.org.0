Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC407BAB78
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 22:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjJEUeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 16:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjJEUep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 16:34:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA48793;
        Thu,  5 Oct 2023 13:34:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C61C433C8;
        Thu,  5 Oct 2023 20:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696538084;
        bh=32IWGcl/GhLZ3tegbGVzkBqng/XbsFXjV2W9sDN1IaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=YxLYOc8GFP90I4Qy7piJ2uW3Mydkjmt+GKzOfIJP1dMkj9hSr6to2W9muxd7RukI/
         wdHdVqAG61HQqdffBx/9Oz3g4NJDpzaLH63to74WjxZLPEOfo5HrLH3nYB2DviFL49
         n7JcH3a9NerZVzzBZCNX2LtR/kMHhAzwXqwcmw3QFC39pNzy07rp7NlhuwT9cUQ0iZ
         U1UhM3GGv+Oh1hCmfMrIDCK3dvC4nEz3iT5cxpulGSRle9wzR0q/yTMnSQUWi8LQLS
         YYLQe2P3wp5k482GvCK6BW7PqkWC5nMaBdMVm9EVXC9PGyD+IRRpTiSiWVUlaQKQjZ
         XEy4QwveN7JyQ==
Date:   Thu, 5 Oct 2023 15:34:42 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
Message-ID: <20231005203442.GA790578@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003193058.GA16417@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023 at 09:30:58PM +0200, Lukas Wunner wrote:
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

> Could you (as an English native speaker) comment on the clarity of the
> two sentences "Prevent ... as long." above, as Ilpo objected to them?
> 
> The antecedent of "Prevent" is the undesirable behaviour in the preceding
> sentence (host resets guest's SPDM connection).

I think this means "prevent a reauthentication by the host behind the
guest's back" (which seems to match the first diff hunk), but I agree
it would be helpful to make the connection clearer, e.g.,

  When passing a device through to a guest, mark it as "CMA owned
  exclusively by the guest" for the duration of the passthrough to
  prevent the host from reauthenticating and resetting the device's
  CMA-SPDM session.

> The antecedent of "as long" is "during passthrough" in the preceding
> sentence.

"as long" definitely needs something to connect it with the
passthrough.

Bjorn
