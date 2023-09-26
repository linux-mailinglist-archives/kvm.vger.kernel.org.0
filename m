Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21E27AF052
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbjIZQKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 12:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbjIZQKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 12:10:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A9911D
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:10:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D0DC433C7;
        Tue, 26 Sep 2023 16:10:07 +0000 (UTC)
Date:   Tue, 26 Sep 2023 17:10:05 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, zhukeqian1@huawei.com,
        jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 6/8] KVM: arm64: Only write protect selected PTE
Message-ID: <ZRMCXcf+RoHBEpLS@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>
 <ZQ26KE2bzEFYUpMc@arm.com>
 <ZQ3H3JZHnxIVCIF6@linux.dev>
 <ZRL/izqkzWy/lKXM@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRL/izqkzWy/lKXM@arm.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 04:58:03PM +0100, Catalin Marinas wrote:
> On Fri, Sep 22, 2023 at 04:59:08PM +0000, Oliver Upton wrote:
> > On Fri, Sep 22, 2023 at 05:00:40PM +0100, Catalin Marinas wrote:
> > > On Fri, Aug 25, 2023 at 10:35:26AM +0100, Shameer Kolothum wrote:
> > > > From: Keqian Zhu <zhukeqian1@huawei.com>
> > > > 
> > > > This function write protects all PTEs between the ffs and fls of mask.
> > > > There may be unset bits between this range. It works well under pure
> > > > software dirty log, as software dirty log is not working during this
> > > > process.
> > > > 
> > > > But it will unexpectly clear dirty status of PTE when hardware dirty
> > > > log is enabled. So change it to only write protect selected PTE.
> > > 
> > > Ah, I did wonder about losing the dirty status. The equivalent to S1
> > > would be for kvm_pgtable_stage2_wrprotect() to set a software dirty bit.
> > > 
> > > I'm only superficially familiar with how KVM does dirty tracking for
> > > live migration. Does it need to first write-protect the pages and
> > > disable DBM? Is DBM re-enabled later? Or does stage2_wp_range() with
> > > your patches leave the DBM on? If the latter, the 'wp' aspect is a bit
> > > confusing since DBM basically means writeable (and maybe clean). So
> > > better to have something like stage2_clean_range().
> > 
> > KVM has never enabled DBM and we solely rely on write-protection faults
> > for dirty tracking. IOW, we do not have a writable-clean state for
> > stage-2 PTEs (yet).
> 
> When I did the stage 2 AF support I left out DBM as it was unlikely
> to be of any use in the real world. Now with dirty tracking for
> migration, we may have a better use for this feature.
> 
> What I find confusing with these patches is that stage2_wp_range() is
> supposed to make a stage 2 pte read-only, as the name implies. However,
> if the pte was writeable, it leaves it writeable, clean with DBM
> enabled. Doesn't the change to kvm_pgtable_stage2_wrprotect() in patch 4
> break other uses of stage2_wp_range()? E.g. kvm_mmu_wp_memory_region()?

Ah, that's also used for dirty tracking, so maybe it's ok.

AFAICT KVM doesn't do any form of stage 2 pte change from writeable to
read-only other than dirty tracking (all other cases triggered via MMU
notifier end up unmapping at stage 2).

> Unless I misunderstood, I'd rather change
> kvm_arch_mmu_enable_log_dirty_pt_masked() to call a new function,
> stage2_clean_range(), which clears S2AP[1] together with setting DBM if
> previously writeable. But we should not confuse this with
> write-protecting or change the write-protecting functions to mark a pte
> writeable+clean.

I think it's still good to rename stage2_wp_range() to make it clear
that it's about clean ptes rather than read-only.

-- 
Catalin
