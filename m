Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4488D37273E
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhEDIbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 04:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhEDIbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 04:31:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CEF2613BA;
        Tue,  4 May 2021 08:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620117011;
        bh=SA0MPq08S4sIbEu0S/YkhVbAPJQkRS5WeyPcEthMjx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MFnRDdSddwFqD0o+BFnn3MH3YKem6HT//4u8RH8EXkPAcQT9SkeWZNklQFzo7wOQB
         HXvNwJWmMvA1IcwoMACcnxUpimVDq6op2UIEj0NHPacUaNQpBw4mLOKutdV8VHhdzQ
         tbi/EeK3qbxUA7dPh3UIZZ41LtqvbZG/8B4D6uoz253eQgtYCUPk0Er3JjRnbL04eL
         H4oTHVChbT7vJKYa+ihaC6dHWLnbIyTxgnUu3h/aBLrSSszNynVwXEeUB1DT7sLR5w
         jPgVoOqjKc10n+KxOyuvx83dQRxSLi4+E7XR72yx+Z7H4KUyYX+ZtQgT5vCjlgR+J7
         RPZjLwKCg+RsA==
Date:   Tue, 4 May 2021 09:30:05 +0100
From:   Will Deacon <will@kernel.org>
To:     Vikram Sethi <vsethi@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Mark Kettenis <mark.kettenis@xs4all.nl>,
        Marc Zyngier <maz@kernel.org>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210504083005.GA12290@willie-the-truck>
References: <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org>
 <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
 <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
 <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 03, 2021 at 10:03:59PM +0000, Vikram Sethi wrote:
> Will/Catalin, perhaps you could explain your thought process on why you chose
> Normal NC for ioremap_wc on the armv8 linux port instead of Device GRE or other
> Device Gxx. 

I think a combination of: compatibility with 32-bit Arm, the need to
support unaligned accesses and the potential for higher performance.

Furthermore, ioremap() already gives you a Device memory type, and we're
tight on MAIR space.

Will
