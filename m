Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9C23747BD
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 20:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbhEESDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 14:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235665AbhEESDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 14:03:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB46861176;
        Wed,  5 May 2021 18:02:33 +0000 (UTC)
Date:   Wed, 5 May 2021 19:02:31 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Vikram Sethi <vsethi@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Kettenis <mark.kettenis@xs4all.nl>,
        Marc Zyngier <maz@kernel.org>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210505180228.GA3874@arm.com>
References: <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org>
 <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
 <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
 <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210504083005.GA12290@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504083005.GA12290@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021 at 09:30:05AM +0100, Will Deacon wrote:
> On Mon, May 03, 2021 at 10:03:59PM +0000, Vikram Sethi wrote:
> > Will/Catalin, perhaps you could explain your thought process on why you chose
> > Normal NC for ioremap_wc on the armv8 linux port instead of Device GRE or other
> > Device Gxx. 
> 
> I think a combination of: compatibility with 32-bit Arm, the need to
> support unaligned accesses and the potential for higher performance.

IIRC the _wc suffix also matches the pgprot_writecombine() used by some
drivers to map a video framebuffer into user space. Accesses to the
framebuffer are not guaranteed to be aligned (memset/memcpy don't ensure
alignment on arm64 and the user doesn't have a memset_io or memcpy_toio).

> Furthermore, ioremap() already gives you a Device memory type, and we're
> tight on MAIR space.

We have MT_DEVICE_GRE currently reserved though no in-kernel user, we
might as well remove it.

-- 
Catalin
