Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6782E623734
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 00:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiKIXBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 18:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiKIXA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 18:00:58 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82B831DF4
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 15:00:51 -0800 (PST)
Date:   Wed, 9 Nov 2022 23:00:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668034845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OAL3R3TEKZCss1R/iPyj1G2fURtMnDVaBxLRl/VPrsA=;
        b=vhUPHWUBXtfmpqLpsM84/OLlBTCq9M8Uf/LpS1LM+w+HDLUEHKKf+Cgmc8whr/XLEJ77qV
        OWYRu6RjKo1hKaOnTiT9M5Jj+L412Cz5b0pi1zQSzL2BC85JmGgitQo9fXiyjEoJ1EYAV0
        M45hAyalGoHztvrdpdPiMXbwvkA6N9Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ben Gardon <bgardon@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 10/14] KVM: arm64: Split init and set for table PTE
Message-ID: <Y2wxGS+Y9EquPVQY@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-11-oliver.upton@linux.dev>
 <CANgfPd_XyTuXa6T01tL9v0tdaG7OUp=Mtikvo0tVNtoBW5stAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_XyTuXa6T01tL9v0tdaG7OUp=Mtikvo0tVNtoBW5stAg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 02:26:26PM -0800, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Create a helper to initialize a table and directly call
> > smp_store_release() to install it (for now). Prepare for a subsequent
> > change that generalizes PTE writes with a helper.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index a34e2050f931..f4dd77c6c97d 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -136,16 +136,13 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
> >         WRITE_ONCE(*ptep, 0);
> >  }
> >
> > -static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> > -                             struct kvm_pgtable_mm_ops *mm_ops)
> > +static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > -       kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
> > +       kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
> >
> >         pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
> >         pte |= KVM_PTE_VALID;
> > -
> > -       WARN_ON(kvm_pte_valid(old));
> 
> Is there any reason to drop this warning?

It is (eventually) superseded by a WARN() when a PTE isn't locked in
stage2_make_pte(), but that isn't obvious in this patch alone.

--
Thanks,
Oliver
