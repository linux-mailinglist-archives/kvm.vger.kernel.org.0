Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B4705646
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 20:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjEPSqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 14:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjEPSqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 14:46:49 -0400
Received: from out-59.mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4919FE4E
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 11:46:45 -0700 (PDT)
Date:   Tue, 16 May 2023 18:46:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684262803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CK/p0lkmv/Tqb9sGLpB8/chiSJ3ZIxj/h3TTrpNfdf0=;
        b=qSWvpu06QCE5s64r+PVFlGYriE800M/aXScyB5KM89Zg+oqn7rzUouemstYn358I7LD1ls
        5WoW4Zx7WP9gKceNrz60JC7iLfhmswWhHyFEygWlweByUM2sU2vgpUySPZT08qooY1NQMA
        h9lbI4NSqmSwKFYh1/3EXybhLdC436w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 7/7] KVM: arm64: Use TLBI range-based intructions for
 unmap
Message-ID: <ZGPPj1AXS0Uah2Ug@linux.dev>
References: <20230414172922.812640-1-rananta@google.com>
 <20230414172922.812640-8-rananta@google.com>
 <ZF5xLrr2tEYdLL1i@linux.dev>
 <CAJHc60wUu3xB4J8oJ+FCxerDad1TzZLCMgHYGFfv0K-hzC0qmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60wUu3xB4J8oJ+FCxerDad1TzZLCMgHYGFfv0K-hzC0qmw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023 at 10:21:33AM -0700, Raghavendra Rao Ananta wrote:
> On Fri, May 12, 2023 at 10:02 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> > >  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
> > >  {
> > > +     int ret;
> > > +     struct stage2_unmap_data unmap_data = {
> > > +             .pgt = pgt,
> > > +             /*
> > > +              * If FEAT_TLBIRANGE is implemented, defer the individial PTE
> > > +              * TLB invalidations until the entire walk is finished, and
> > > +              * then use the range-based TLBI instructions to do the
> > > +              * invalidations. Condition this upon S2FWB in order to avoid
> > > +              * a page-table walk again to perform the CMOs after TLBI.
> > > +              */
> > > +             .skip_pte_tlbis = system_supports_tlb_range() &&
> > > +                                     stage2_has_fwb(pgt),
> >
> > Why can't the underlying walker just call these two helpers directly?
> > There are static keys behind these...
> >
> I wasn't aware of that. Although, I tried to look into the
> definitions, but couldn't understand how static keys are at play here.
> By any chance are you referring to the alternative_has_feature_*()
> implementations when checking for cpu capabilities?

Ah, right, these were recently changed to rely on alternative patching
in commit 21fb26bfb01f ("arm64: alternatives: add alternative_has_feature_*()").
Even still, the significance remains as the alternative patching
completely eliminates a conditional branch on the presence of a
particular feature.

Initializing a local with the presence/absence of a feature defeats such
an optimization.

-- 
Thanks,
Oliver
