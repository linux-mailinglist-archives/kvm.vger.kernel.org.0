Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7091C560A27
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 21:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiF2TPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 15:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiF2TPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 15:15:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A283DA44
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 12:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A237EB82652
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 19:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E06C34114;
        Wed, 29 Jun 2022 19:15:11 +0000 (UTC)
Date:   Wed, 29 Jun 2022 20:15:07 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <Yryku0/XU2GkcjvY@arm.com>
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com>
 <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com>
 <YrmXzHXv4babwbNZ@arm.com>
 <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
 <YrtBIX0/0jyAdgnz@arm.com>
 <CAMn1gO7aC1zqWDt1bAk_ds8ejuhx2obo-LE-2UwFXch=uNFoAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO7aC1zqWDt1bAk_ds8ejuhx2obo-LE-2UwFXch=uNFoAA@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 11:54:51AM -0700, Peter Collingbourne wrote:
> On Tue, Jun 28, 2022 at 10:58 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > That's why it would be interesting to see
> > the effect of using DC GZVA instead of DC ZVA for page zeroing.
> >
> > I suspect on Android you'd notice the fork() penalty a bit more with all
> > the copy-on-write having to copy tags. But we can't tell until we do
> > some benchmarks. If the penalty is indeed significant, we'll go back to
> > assessing the races here.
> 
> Okay, I can try to measure it. I do feel rather strongly though that
> we should try to avoid tagging pages as much as possible even ignoring
> the potential performance implications.
> 
> Here's one more idea: we can tag pages eagerly as you propose, but
> introduce an opt-out. For example, we introduce a MAP_NOMTE flag,
> which would prevent tag initialization as well as causing any future
> attempt to mprotect(PROT_MTE) to fail. Allocators that know that the
> memory will not be used for MTE in the future can set this flag. For
> example, Scudo can start setting this flag once MTE has been disabled
> as it has no mechanism for turning MTE back on once disabled. And that
> way we will end up with no tags on the heap in the processes with MTE
> disabled. Mappings with MAP_NOMTE would not be permitted in the guest
> memory space of MTE enabled guests. For executables mapped by the
> kernel we may consider adding a bit to the ELF program headers to
> enable MAP_NOMTE.

I don't like such negative flags and we should aim for minimal changes
to code that doesn't care about MTE. If there's a performance penalty
with zeroing the tags, we'll keep looking at the lazy tag
initialisation.

In the meantime, I'll think some more about the lazy stuff. We need at
least mte_sync_tags() fixed to set the PG_mte_tagged after the tags have
been updated (fixes the CoW + mprotect() race but probably breaks
concurrent MAP_SHARED mprotect()). We'd have to add some barriers (maybe
in a new function, set_page_tagged()). Some cases like restoring from
swap (both private and shared) have the page lock held. KVM doesn't seem
to take any page lock, so it can race with the VMM.

Anyway, I doubt we can get away with a single bit. We can't make use of
PG_locked either since set_pte_at() is called with the page either
locked or unlocked.

-- 
Catalin
