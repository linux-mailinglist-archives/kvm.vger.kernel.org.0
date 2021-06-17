Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703C93AB48D
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 15:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhFQNXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 09:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhFQNX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 09:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD02A6112D;
        Thu, 17 Jun 2021 13:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623936082;
        bh=9m33aIOJbia+ShcJ940DomACgwPzr98gLkW2wr4hC0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vb3e9ZS14SiSso4EXORRrKwxfAZT20KMhCseWc54VYAc5MtG70waEtim/es9NVznb
         KZxnCTX+u/dwRN/5pESaYM3FZpZSC05Lqzsa5HbAJrOk43pEdk/krdZ10NrbEYSBzu
         HfhjoHpdabOfk6XKx0eib42VKJhHjwqmBoyD6YKubuKZB9QC7T1Ifr9yD+K3eflqBc
         uKupbuBOkbtc6w8EBmowP9qnR7esHF7xQpck+/SAfRDdi3Ub4ts1YhYRx3ohwTp1Rp
         vjynNariT2gyLgNMJbZfqpwB/XC45+n+U4u5f4GgnvMLcdI2596NypKVEF6jSxtVED
         B4DjgJJgNh+Lw==
Date:   Thu, 17 Jun 2021 14:21:16 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Yanan Wang <wangyanan55@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, wanghaibin.wang@huawei.com,
        zhukeqian1@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH v7 4/4] KVM: arm64: Move guest CMOs to the fault handlers
Message-ID: <20210617132115.GA24656@willie-the-truck>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-5-wangyanan55@huawei.com>
 <20210617124557.GB24457@willie-the-truck>
 <87k0msd4ue.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0msd4ue.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 01:59:37PM +0100, Marc Zyngier wrote:
> On Thu, 17 Jun 2021 13:45:57 +0100,
> Will Deacon <will@kernel.org> wrote:
> > On Thu, Jun 17, 2021 at 06:58:24PM +0800, Yanan Wang wrote:
> > > @@ -606,6 +618,14 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> > >  		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> > >  	}
> > >  
> > > +	/* Perform CMOs before installation of the guest stage-2 PTE */
> > > +	if (mm_ops->clean_invalidate_dcache && stage2_pte_cacheable(pgt, new))
> > > +		mm_ops->clean_invalidate_dcache(kvm_pte_follow(new, mm_ops),
> > > +						granule);
> > > +
> > > +	if (mm_ops->invalidate_icache && stage2_pte_executable(new))
> > > +		mm_ops->invalidate_icache(kvm_pte_follow(new, mm_ops), granule);
> > 
> > One thing I'm missing here is why we need the indirection via mm_ops. Are
> > there cases where we would want to pass a different function pointer for
> > invalidating the icache? If not, why not just call the function directly?
> > 
> > Same for the D side.
> 
> If we didn't do that, we'd end-up having to track whether the guest
> context requires CMOs with additional flags, which is pretty ugly (see
> v5 of this series for reference [1]).

Fair enough, although the function pointers here _are_ being used as flags,
as they only ever have one of two possible values (NULL or the CMO function),
so it's a shame to bring in the indirect branch as well.

> It also means that we would have to drag the CM functions into the EL2
> object, something that we don't need with this approach.

I think it won't be long before we end up with CMO functions at EL2 and
you'd hope we'd be able to use the same code as EL1 for something like
that. But I also wouldn't want to put money on it...

Anyway, no strong opinion on this, it just jumped out when I skimmed the
patches.

Will
