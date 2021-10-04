Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3FA4208A7
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhJDJtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232117AbhJDJtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 05:49:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01FF961181;
        Mon,  4 Oct 2021 09:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633340838;
        bh=15jCOMDdwQB2RNCaL6998lZwo66iTosw6ZnWJH00Jek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ec4+LOmcTTL235Vn9dCoKh3IS06X5E4ZY1Hyb9G0b+qKXsgU2/bfvIbEVQw8+qDvG
         XLSs7INCzJdpsnmhIdQbYNn2NRAc3YdpRvUAKz7iSBUWiUQHp+KFsnZn9S3elRx4eq
         ongA+o9P2UEbAbv/xubesUQkKyvL2qK6e2y0C/cL8M4USqfQ2g8vBGwg3A7sNHIYWL
         QyhjBKWTC6FfKflWMsoQie4YzHoSIh13wNI9uA3nrA9to8LiZVHQsIgjELuD6GFM21
         HgdzFaWJXXL6GW57E3rNsOZcAyCUd9beHfnGEWBnxN3Bsv1aCnNN91ezXJ7WDm+Y5S
         jcpS2A0fgY7FQ==
Date:   Mon, 4 Oct 2021 10:47:13 +0100
From:   Will Deacon <will@kernel.org>
To:     Vivek Kumar Gautam <vivek.gautam@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        andre.przywara@arm.com, lorenzo.pieralisi@arm.com,
        jean-philippe@linaro.org, eric.auger@redhat.com
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
Message-ID: <20211004094713.GB27173@willie-the-truck>
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <af1ae6fe-176b-8016-3815-faa9651b0aba@arm.com>
 <51cc78f5-6841-5e83-3b28-bef7fbf68937@arm.com>
 <ae4bdd18-29c8-5871-5242-95d5c5d8a6a6@arm.com>
 <867e8db7-c173-5ad2-dca4-69085c89d956@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867e8db7-c173-5ad2-dca4-69085c89d956@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021 at 03:02:20PM +0530, Vivek Kumar Gautam wrote:
> On 9/3/21 8:45 PM, Alexandru Elisei wrote:
> > On 9/2/21 11:48 AM, Vivek Kumar Gautam wrote:
> > > On 9/2/21 3:29 PM, Alexandru Elisei wrote:
> > I think I found the card that doesn't work when overwriting the extended device
> > configuration space. I tried device assignment with a Realtek 8168 Gigabit
> > Ethernet card on a Seattle machine, and the host freezes when I try to start a VM.
> > Even after reset, the machine doesn't boot anymore and it gets stuck during the
> > boot process at this message:
> > 
> > NewPackageList status: EFI_SUCCESS
> > BDS.SignalConnectDriversEvent(feeb6d60)
> > BDS.ConnectRootBridgeHandles(feeb6db0)
> > 
> > It doesn't go away no matter how many times I reset the machine, to get it booting
> > again I have to pull the plug and plug it again. I tried assigning the device to a
> > VM several times, and this happened every time. The card doesn't have the caps
> > that you added, this is caused entirely by the config space write (tried it with
> > only the config space change).
> > 
> > It could be a problem kvmtool, with Linux or with the machine, but this is the
> > only machine where device assignment works and I would like to keep it working
> > with this NIC.

There is at least a problem with the machine/firmware if you can get it
into this state.

> Sorry for the delay in responding. I took sometime off work.
> Sure, we will try to keep your machine working :)
> 
> > 
> > One solution I see is to add a field to vfio_pci_device (something like has_pcie),
> > and based on that, vfio_pci_fixup_cfg_space() could overwrite only the first 256
> > bytes or the entire device configuration space.
> 
> Does the card support PCI extended caps (as seen from the PCI spec v5.0
> section-7.5)?
> If no, then I guess the check that I am planning to add - to check if
> the device supports extended Caps - can help here. Since we would add
> extended caps based on the mentioned check, it seems only valid to have
> that check before overwriting the configuration space.
> 
> > 
> > It's also not clear to me what you are trying to achieve with this patch. Is there
> > a particular device that you want to get working? Or an entire class of devices
> > which have those features? If it's the former, you could have the size of the
> > config space write depend on the vendor + device id. If it's the latter, we could
> > key the size of the config space write based on the presence of those particular
> > PCIE caps and try and fix other devices if they break.
> 
> Absolutely, we can check for the presence of PCI extended capabilities
> and based on that write the configuration space. If the device has issue
> with only a specific extended capability we can try to fix that by
> keying the DevID-VendorID pair? What do you think?
> 
> > 
> > Will, Andre, do you see other solutions? Do you have a preference?
> 
> Will, Andre, please let me know as well if you have any preferences.

If it's straightforward to keep this working on Seattle, then let's do it,
but I don't think we should bend over backwards to support device assignment
on a dead platform (and I say that as a regular user of one of these
things!)

Will
