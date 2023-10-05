Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177FA7BAB38
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 22:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjJEUJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 16:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjJEUJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 16:09:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBD0F2;
        Thu,  5 Oct 2023 13:09:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A5EC433C9;
        Thu,  5 Oct 2023 20:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696536559;
        bh=gviqkF5bCtrPEnmL/efrb5ugCp6oRzHfV/DcplqOK/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=mPMh/YzlW9oTh5h9AJ5aAB26BKNe2mE/3C+n+4v4/3A/CAe2k4Yecrw+PoqctpsCM
         7Rz9NE1k5UayDDxAOm9iNh49IS4NPl3z7Z1PJ9/Xk/cvDzdiK5fOzsp10llBeSnwax
         udSKrphyyopprBbpM8FEO+w5hthYv2c6Tq8BoPNW+rRfweDFkzRci8hxE+wv+wV38F
         rfaiern/5q24z3ng5ohmgFBbmvxW21IgYxkExh7y+5d/jGlf3aJ2u2PJ/ZKA9hjxaX
         SzXBqCFyHL6SDZzCYBPatbmI79HVeskhOL1mn7NDoZ6rtrvfnTF+8Lcn0dkzITIw8U
         26WOBNO0H119A==
Date:   Thu, 5 Oct 2023 15:09:17 -0500
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
Subject: Re: [PATCH 09/12] PCI/CMA: Validate Subject Alternative Name in
 certificates
Message-ID: <20231005200917.GA789502@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005140447.GA23472@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023 at 04:04:47PM +0200, Lukas Wunner wrote:
> On Tue, Oct 03, 2023 at 04:04:55PM +0100, Jonathan Cameron wrote:
> > On Thu, 28 Sep 2023 19:32:39 +0200 Lukas Wunner <lukas@wunner.de> wrote:
> > > PCIe r6.1 sec 6.31.3 stipulates requirements for X.509 Leaf Certificates

The PCIe spec does not contain "X.509", so I assume this is sort of a
transitive requirement from SPDM.

> > > presented by devices, in particular the presence of a Subject Alternative
> > > Name extension with a name that encodes the Vendor ID, Device ID, Device
> > > Serial Number, etc.
> > 
> > Lets you do any of
> > * What you have here
> > * Reference Integrity Manifest, e.g. see Trusted Computing Group
> > * A pointer to a location where such a Reference Integrity Manifest can be
> >   obtained.
> > 
> > So this text feels a little strong though I'm fine with only support the
> > Subject Alternative Name bit for now. Whoever has one of the other options
> > can add that support :)
> 
> I intend to amend the commit message as follows.  If anyone believes
> this is inaccurate, please let me know:
> 
>     Side note:  Instead of a Subject Alternative Name, Leaf Certificates may
>     include "a Reference Integrity Manifest, e.g., see Trusted Computing
>     Group" or "a pointer to a location where such a Reference Integrity
>     Manifest can be obtained" (PCIe r6.1 sec 6.31.3).
> 
>     A Reference Integrity Manifest contains "golden" measurements which can
>     be compared to actual measurements retrieved from a device.  It serves a
>     different purpose than the Subject Alternative Name, hence it is unclear
>     why the spec says only either of them is necessary.  It is also unclear
>     how a Reference Integrity Manifest shall be encoded into a certificate.
> 
>     Ignore the Reference Integrity Manifest requirement until this confusion
>     is resolved by a spec update.

Thanks for this; I was about to comment the same.

Bjorn
