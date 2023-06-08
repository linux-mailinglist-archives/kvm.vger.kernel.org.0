Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58B7286B5
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 19:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbjFHR5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 13:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjFHR5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 13:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4B91734
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 10:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 471726500F
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 17:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14ACC433D2;
        Thu,  8 Jun 2023 17:57:09 +0000 (UTC)
Date:   Thu, 8 Jun 2023 18:57:07 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        jingzhangos@google.com, alexandru.elisei@arm.com,
        james.morse@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, oupton@google.com,
        pbonzini@redhat.com, rananta@google.com, reijiw@google.com,
        suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
        sjitindarsingh@gmail.com
Subject: Re: [PATCH 3/3] KVM: arm64: Use per guest ID register for
 ID_AA64PFR1_EL1.MTE
Message-ID: <ZIIWc5v67cpMqEMU@arm.com>
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602221447.1809849-1-surajjs@amazon.com>
 <20230602221447.1809849-4-surajjs@amazon.com>
 <873539ospa.wl-maz@kernel.org>
 <87h6rl50dl.fsf@redhat.com>
 <87legwo83z.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87legwo83z.wl-maz@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 05:42:24PM +0100, Marc Zyngier wrote:
> On Mon, 05 Jun 2023 17:39:50 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> > On Sat, Jun 03 2023, Marc Zyngier <maz@kernel.org> wrote:
> > > On Fri, 02 Jun 2023 23:14:47 +0100,
> > > Suraj Jitindar Singh <surajjs@amazon.com> wrote:
> > >> 
> > >> With per guest ID registers, MTE settings from userspace can be stored in
> > >> its corresponding ID register.
> > >> 
> > >> No functional change intended.
> > >> 
> > >> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> > >> ---
> > >>  arch/arm64/include/asm/kvm_host.h | 21 ++++++++++-----------
> > >>  arch/arm64/kvm/arm.c              | 11 ++++++++++-
> > >>  arch/arm64/kvm/sys_regs.c         |  5 +++++
> > >>  3 files changed, 25 insertions(+), 12 deletions(-)
> > >> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > >> index ca18c09ccf82..6fc4190559d1 100644
> > >> --- a/arch/arm64/kvm/arm.c
> > >> +++ b/arch/arm64/kvm/arm.c
> > >> @@ -80,8 +80,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >>  		if (!system_supports_mte() || kvm->created_vcpus) {
> > >>  			r = -EINVAL;
> > >>  		} else {
> > >> +			u64 val;
> > >> +
> > >> +			/* Protects the idregs against modification */
> > >> +			mutex_lock(&kvm->arch.config_lock);
> > >> +
> > >> +			val = IDREG(kvm, SYS_ID_AA64PFR1_EL1);
> > >> +			val |= FIELD_PREP(ID_AA64PFR1_EL1_MTE_MASK, 1);
> > >
> > > The architecture specifies 3 versions of MTE in the published ARM ARM,
> > > with a 4th coming up as part of the 2022 extensions.
> > 
> > Is that the one that adds some more MTE<foo> bits in AA64PFR1 and
> > AA64PFR2?
> 
> Yeah, that. You get ID_AA64PFR1_EL1.{MTE,MTE_frac,MTEX}, plus
> ID_AA64PFR2_EL1.{MTEFAR,MTESTOREONLY,MTEPERM}... It this sounds like a
> train wreck, then it probably is one!

I stared about an hour at that documentation and I think I got it (well,
for the next couple of hours). The disappearing of MTE_FEAT_ASYNC from
MTE2 is potentially problematic but the worst that can happen is that
async faults are simply not triggered (and TBH, those "faults" were not
that useful anyway). MTE4 without ASYM is defined in a weird way.
Basically there's no such thing as MTE4, just 2 and 3 (the latter
bringing in ASYM) with some extra features like store-only, stage 2
permission, canonical tag checking.

I don't think any of these new MTE extensions add any state that KVM
should care context-switch, so we should be fine. Does KVM limit the
maximum value of the ID field exposed to user? Some future MTE9 may add
new state, so better to be safe (I thought we handled these cases but
can't find it now).

It's also probably safe to disable MTE altogether if there's any
difference between all these fields on different CPUs (I don't think we
currently do, we just go for lower safe while ignoring MTE_frac, MTEX).

Regarding MTEX, I don't think Linux would ever make use of the canonical
tag checking. The enabling bit is unfortunately in TCR_EL1 which we
don't context-switch (and maybe cached in the TLB, I haven't checked the
latest spec).

-- 
Catalin
