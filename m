Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48F9623846
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 01:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiKJAmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 19:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKJAmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 19:42:47 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746831A074
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 16:42:43 -0800 (PST)
Date:   Thu, 10 Nov 2022 00:42:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668040957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eRsf0Yc4TqMwAER5aigpmti9/PEPuMa0WpzYqXNDuZQ=;
        b=UuU4JWtH6hrysbqKc1ioxoB5HBtTUJyV8uJwQFyFfhNihzi9THDz32XiDMeZv+yHDKPUG6
        I0cv2eH5ozct40aebDkeJeN7KPcNmqNEz735Joj7pb37DJ/jdukf63ug93Av4unMBLwuwp
        AkkC9TIiQNoU+AHi4kx4af5ehX0lP1o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 01/14] KVM: arm64: Combine visitor arguments into a
 context structure
Message-ID: <Y2xI+bw8i2iboHxL@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-2-oliver.upton@linux.dev>
 <190fd3d3-bf86-23cf-0424-336577655e8f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <190fd3d3-bf86-23cf-0424-336577655e8f@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On Thu, Nov 10, 2022 at 08:23:36AM +0800, Gavin Shan wrote:
> On 11/8/22 5:56 AM, Oliver Upton wrote:
> > Passing new arguments by value to the visitor callbacks is extremely
> > inflexible for stuffing new parameters used by only some of the
> > visitors. Use a context structure instead and pass the pointer through
> > to the visitor callback.
> > 
> > While at it, redefine the 'flags' parameter to the visitor to contain
> > the bit indicating the phase of the walk. Pass the entire set of flags
> > through the context structure such that the walker can communicate
> > additional state to the visitor callback.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h  |  15 +-
> >   arch/arm64/kvm/hyp/nvhe/mem_protect.c |  10 +-
> >   arch/arm64/kvm/hyp/nvhe/setup.c       |  16 +-
> >   arch/arm64/kvm/hyp/pgtable.c          | 269 +++++++++++++-------------
> >   4 files changed, 154 insertions(+), 156 deletions(-)
> > 
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> One nit below.
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 3252eb50ecfe..607f9bb8aab4 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -199,10 +199,17 @@ enum kvm_pgtable_walk_flags {
> >   	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
> >   };
> > -typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
> > -					kvm_pte_t *ptep,
> > -					enum kvm_pgtable_walk_flags flag,
> > -					void * const arg);
> > +struct kvm_pgtable_visit_ctx {
> > +	kvm_pte_t				*ptep;
> > +	void					*arg;
> > +	u64					addr;
> > +	u64					end;
> > +	u32					level;
> > +	enum kvm_pgtable_walk_flags		flags;
> > +};
> > +
> > +typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
> > +					enum kvm_pgtable_walk_flags visit);
> 
> Does it make sense to reorder these fields in the context struct based on
> their properties.

The ordering was a deliberate optimization for space. Your suggestion
has 8 bytes of implicit padding:

>     struct kvm_pgtable_visit_ctx {
>            enum kvm_pgtable_walk_flags     flags;

here

>            u64                             addr;
>            u64                             end;
>            u32                             level;

and here.

>            kvm_pte_t                       *ptep;
>            void                            *arg;
>     };

--
Thanks,
Oliver
