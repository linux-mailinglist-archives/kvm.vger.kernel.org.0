Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D9B3FD7EE
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 12:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbhIAKpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 06:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234901AbhIAKpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 06:45:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 727116101A;
        Wed,  1 Sep 2021 10:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630493096;
        bh=jSMFcOW7YmiTBur/EJKXjo5lJSsgVllFg6Ea1wGFOXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uqYMSm80L9voG5aeQ2q2EYoFmCj1x6bDDT/Y539FLq3uzkon1vwVgVL09WIRQht1F
         9xYNZUDyu7ith63A1+WEoIMQjNJm8PPBW1G3EwBq+28cdv6t1sv7qA5CflvsKtnm0v
         0ePOJya0GxawKYwUTpV+H2AUr7w3IXn0lL8bjspPm5fYQ1ITYVOw5rGR9i/VoPet0O
         lTfrND0uHVhCIX+R7BewdiGsAzgaae3EJt005d64h50HyUy0ZUI9jhog/9EdgEV6zn
         5KQsMLUlnRYLSPx+L+L3fy3w+j6MCeMng4fq8XbadWnbBI6ncO6JnuORXSBkJh/qSs
         zOmoUWRmTSexg==
Date:   Wed, 1 Sep 2021 11:44:52 +0100
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Vivek Gautam <vivek.gautam@arm.com>, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, alexandru.elisei@arm.com,
        lorenzo.pieralisi@arm.com, jean-philippe@linaro.org,
        eric.auger@redhat.com
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
Message-ID: <20210901104451.GA1023@willie-the-truck>
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <20210831145424.GA32001@willie-the-truck>
 <4f5307cf-0cea-461a-838f-85e82805c499@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f5307cf-0cea-461a-838f-85e82805c499@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 11:27:21AM +0100, Andre Przywara wrote:
> On 8/31/21 3:54 PM, Will Deacon wrote:
> 
> Hi Will,
> 
> > On Tue, Aug 10, 2021 at 11:55:14AM +0530, Vivek Gautam wrote:
> > > Add support to parse extended configuration space for vfio based
> > > assigned PCIe devices and add extended capabilities for the device
> > > in the guest. This allows the guest to see and work on extended
> > > capabilities, for example to toggle PRI extended cap to enable and
> > > disable Shared virtual addressing (SVA) support.
> > > PCIe extended capability header that is the first DWORD of all
> > > extended caps is shown below -
> > > 
> > >     31               20  19   16  15                 0
> > >     ____________________|_______|_____________________
> > >    |    Next cap off    |  1h   |     Cap ID          |
> > >    |____________________|_______|_____________________|
> > > 
> > > Out of the two upper bytes of extended cap header, the
> > > lower nibble is actually cap version - 0x1.
> > > 'next cap offset' if present at bits [31:20], should be
> > > right shifted by 4 bits to calculate the position of next
> > > capability.
> > > This change supports parsing and adding ATS, PRI and PASID caps.
> > > 
> > > Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
> > > ---
> > >   include/kvm/pci.h |   6 +++
> > >   vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++----
> > >   2 files changed, 103 insertions(+), 7 deletions(-)
> > 
> > Does this work correctly for architectures which don't define ARCH_HAS_PCI_EXP?
> 
> I think it does: the code compiles fine, and the whole functionality is
> guarded by:
> +	/* Extended cap only for PCIe devices */
> +	if (!arch_has_pci_exp())
> +		return 0;
> 
> A clever compiler might even decide to not include this code at all.
> 
> Did you see any particular problem?

The part I was worried about is that PCI_DEV_CFG_MASK (which is used by
the cfg space dispatch code) is derived from PCI_DEV_CFG_SIZE, but actually
I think this patch might _fix_ that problem because it removes the explicit
usage of PCI_DEV_CFG_SIZE_LEGACY!

Will
