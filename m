Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FCC3DB892
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbhG3M1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238736AbhG3M1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 08:27:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1F66103B;
        Fri, 30 Jul 2021 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627648024;
        bh=wT4Jmfp7K7e7610QIG6UJIKHHYTDycOajWViNs/FQzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qOvuP+PZHGEQ6QFN9P+8FzxInej00GZmWtK4vwy+MZHMp1WOGMrViCMD0C4E/22gb
         MLo9g0h9j0QBO24ETL9yVk+AyNhZxKNKXxTWahTA5VCPHB65mgTEuHclGoqvxNecn5
         35Rpc2I2tuELdVK3Zmf8w431pR7IeEuLHZVO1yZ2sGEVlACBETPeYaXCT47Gy4u1ca
         do/tEe5NT7emIko7C5viwa0FRQ9Lo27DJljdYaZCHS8xYb0RglMeBNuIdFY302g55t
         llilOsUMxh7gMxsM5V2437OQA72tkzPS28rHXsx8u+qJ0OcWkMXN/UpQzpy19blt9G
         Wl4B6Bo4b/VRw==
Date:   Fri, 30 Jul 2021 13:26:59 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <20210730122658.GG23589@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <20210727181107.GC19173@willie-the-truck>
 <8735ryep6d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735ryep6d.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 10:57:30AM +0100, Marc Zyngier wrote:
> On Tue, 27 Jul 2021 19:11:08 +0100,
> Will Deacon <will@kernel.org> wrote:
> > On Thu, Jul 15, 2021 at 05:31:47PM +0100, Marc Zyngier wrote:
> > > +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> > > +{
> > > +	struct kvm_mmu_memory_cache *memcache;
> > > +	struct kvm_memory_slot *memslot;
> > > +	int ret, idx;
> > > +
> > > +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> > > +		return false;
> > > +
> > > +	/* Must be page-aligned */
> > > +	if (ipa & ~PAGE_MASK)
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * The page cannot be in a memslot. At some point, this will
> > > +	 * have to deal with device mappings though.
> > > +	 */
> > > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > +	memslot = gfn_to_memslot(vcpu->kvm, ipa >> PAGE_SHIFT);
> > > +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > 
> > What does this memslot check achieve? A new memslot could be added after
> > you've checked, no?
> 
> If you start allowing S2 annotations to coexist with potential memory
> mappings, you're in for trouble. The faulting logic will happily
> overwrite the annotation, and that's probably not what you want.

I don't disagree, but the check above appears to be racy.

> As for new (or moving) memslots, I guess they should be checked
> against existing annotations.

Something like that, but the devil is in the details as it will need to
synchronize with this check somehow.

Will
