Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828D4605A03
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 10:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJTIgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 04:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJTIgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 04:36:53 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95852A222C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 01:36:43 -0700 (PDT)
Date:   Thu, 20 Oct 2022 11:35:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666254959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4bFmitmS0e0DfzO3u2Vz/2OAVtqGb2XuvT7fYH4csp4=;
        b=gdBGORDykXgxNOmBPdP5jxs2zgIt7+2yLsb9L5Loojh51BmO9Bhp5sbXOZYcs2wOL5nFou
        3usATUday8HjdXJBureCI2ohWaixAFeplEUvxR9+F8baHiLfoFuegG0YhtUezyXFW61Xe+
        Sy2IkrG1hDqhkDtSUxXERJ4D86HQ/20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y1EIar1OGgxMKzSf@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007233253.460257-1-oliver.upton@linux.dev>
 <Y1CJFLVnnbX4Ck85@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1CJFLVnnbX4Ck85@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 11:32:36PM +0000, Sean Christopherson wrote:
> On Fri, Oct 07, 2022, Oliver Upton wrote:
> > @@ -1534,7 +1517,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  	 */
> >  	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
> >  			       PAGE_SIZE, __pfn_to_phys(pfn),
> > -			       KVM_PGTABLE_PROT_R, NULL);
> > +			       KVM_PGTABLE_PROT_R, NULL, KVM_PGTABLE_WALK_SHARED);
> 
> All MMU notifier events acquire mmu_lock for write when invoking arch code, i.e.
> this isn't a shared walk.

Derp, didn't intend to set the flag here. I'll fix it in v3.

--
Thanks,
Oliver
