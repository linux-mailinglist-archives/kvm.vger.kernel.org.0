Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D667A3E9
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 21:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbjAXU3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 15:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjAXU3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 15:29:00 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73983C24
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:28:58 -0800 (PST)
Date:   Tue, 24 Jan 2023 12:28:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674592137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/73jyguC+09XrXALkeeQcLu9/HGBWgVwVY/mjTKders=;
        b=woDgSpregoLNsOVwUQdBXD0Vl+FpzkusPWIX5UQqTUW4HffQhV9MLoWH3z5cmC6vBFuyxl
        9hcF052WTTUoXEFRSZPvwV6QSKQqGuPDEXgE1X0LwhJZZcbV8HNm+YkLURlZXgXaQOlIDT
        2eHjfRN1VFHKZ9+Q1NE6CSyveAbmj30=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y9A/gk0uAdNbbmbE@thinky-boi>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
 <Y9ALgtnd+h9ivn90@google.com>
 <Y9ARN5hWlAYVFBoK@google.com>
 <CAOHnOrxGu2sU2+-M8+-nMiRc01BQvRug+S2rnBbK6HiCP_BMVw@mail.gmail.com>
 <Y9AZ7ORdmIPQ1YGL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9AZ7ORdmIPQ1YGL@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 09:48:28AM -0800, David Matlack wrote:
> On Tue, Jan 24, 2023 at 09:18:33AM -0800, Ricardo Koller wrote:
> > On Tue, Jan 24, 2023 at 9:11 AM Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > > The numbering we use in the page table walkers is deliberate, as it
> > > directly matches the Arm ARM. While we can certainly use either scheme
> > > I'd prefer we keep aligned with the architecture.
> > 
> > hehe, I was actually subtly suggesting our x86 friends to change their side.
> 
> Yeah KVM/x86 and KVM/ARM use basically opposite numbering schemes for
> page table levels.
> 
> Level | KVM/ARM | KVM/x86
> ----- | ------- | ---------------
> pte   | 3       | 1 (PG_LEVEL_4K)
> pmd   | 2       | 2 (PG_LEVEL_2M)
> pud   | 1       | 3 (PG_LEVEL_1G)
> p4d   | 0       | 4
>       | -1      | 5
> 
> The ARM levels come from the architecture, whereas the x86 levels are
> arbitrary.
> 
> I do think it would be valuable to standardize on one leveling scheme at
> some point. Otherwise, mixing level schemes is bound to be a source of
> bugs if and when we are sharing more MMU code across architectures.

That could work, so long as the respective ISAs don't depend on any
specific numbering scheme. For arm64 the level hints encoded in TLBIs
match our numbering scheme, which is quite valuable. We are definitely
at odds with RISC-V's numbering scheme (descending order, starting from
root), but AFAICT there doesn't appear to be any portion of the ISA that
depends on it (yet).

Sure, we could add some glue code to transform KVM's common leveling
scheme into an architecture-specific one for these use cases, but I
worry that'll be incredibly error-prone.

In any case I'd prefer we not make any changes at this point, as they'd
be purely cosmetic.

--
Thanks,
Oliver
