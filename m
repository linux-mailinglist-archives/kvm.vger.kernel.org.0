Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E803EA0E7
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 10:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhHLIqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 04:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhHLIqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 04:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB6960724;
        Thu, 12 Aug 2021 08:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628757967;
        bh=bkl8tFQVs/zWYEgsZnhecDk9futAxtTTe8bCKKSsTbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z2xEWPhGXCC3hYjkoOwVu5NNCZixMYARc4Obyms3/6Sll6y15fu++5hzxXpe19DRx
         EhYSelrSgMUtSRqyyDWoF8aU53SNNBsMCsz/oE1a4Uuykg/PmfSuwKpWM4U79UjcjE
         +FBepWdxQ0UofglZOQAgBIFc0zgMNmwtCFs5QKkE1WVMSyRs6H81uDgVkBCE3TMCQT
         y2qrz0rXzvSbQ/LZ9GLhqbQZvxvyXibIhBqjF+zWrad975+NrHB7Dkuo6l4SolV8BY
         tYsvlHdHLIUVh0obkeNpkUiMjQxgXhdLk7xcfRf7X1DIiR/ZBnWyhOL0KdnJb9n2dq
         AxUNUinPIaNCg==
Date:   Thu, 12 Aug 2021 09:46:01 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
Message-ID: <20210812084600.GA5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-7-tabba@google.com>
 <20210720145258.axhqog3abdvtpqhw@gator>
 <CA+EHjTweLPu+DQ8hR9kEW0LrawtaoAoXR_+HmSEZpP-XOEm2qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTweLPu+DQ8hR9kEW0LrawtaoAoXR_+HmSEZpP-XOEm2qg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021 at 08:37:21AM +0100, Fuad Tabba wrote:
> On Tue, Jul 20, 2021 at 3:53 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> > > On deactivating traps, restore the value of mdcr_el2 from the
> > > newly created and preserved host value vcpu context, rather than
> > > directly reading the hardware register.
> > >
> > > Up until and including this patch the two values are the same,
> > > i.e., the hardware register and the vcpu one. A future patch will
> > > be changing the value of mdcr_el2 on activating traps, and this
> > > ensures that its value will be restored.
> > >
> > > No functional change intended.
> >
> > I'm probably missing something, but I can't convince myself that the host
> > will end up with the same mdcr_el2 value after deactivating traps after
> > this patch as before. We clearly now restore whatever we had when
> > activating traps (presumably whatever we configured at init_el2_state
> > time), but is that equivalent to what we had before with the masking and
> > ORing that this patch drops?
> 
> You're right. I thought that these were actually being initialized to
> the same values, but having a closer look at the code the mdcr values
> are not the same as pre-patch. I will fix this.

Can you elaborate on the issue here, please? I was just looking at this
but aren't you now relying on __init_el2_debug to configure this, which
should be fine?

Will
