Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA1503775
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 18:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiDPQGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Apr 2022 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiDPQGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Apr 2022 12:06:00 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8836EDF13
        for <kvm@vger.kernel.org>; Sat, 16 Apr 2022 09:03:24 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r17so319624iln.9
        for <kvm@vger.kernel.org>; Sat, 16 Apr 2022 09:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wEt9N3Zhz4Vmmb7sqXNK/pWIreJjgm6LVz0beu10MRM=;
        b=NvYgpTXq2m6azGeR9w4P/7TL4sXEY6B7fIf4UDvIRkvKtw0JIK1J+IidxSzbdFxSy5
         q1mdOSugjRgbVCfiBlDGhlZwCYA1ffXlpS5AX4ZIweRQ1aQo3q64medWVQ/vYBEJjcvN
         DAqBX4epYgzd3f6LmhN5uzmuf2GfSB0KVh73/FepfptUrNHen2fvG68RcYzMw6JzV99b
         yLY1W0wifkrv/2/Ob38mT18umNWV5beggdvvctMKrLs4VfKdb6qU6azx3WXFFG8XT2GK
         uEm13V9Gc0CDOO52seiIEPeqUFpstU6G8/dRys8h5EWZA/RUBcr+z6MZdWmXDh63T8mb
         ccZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wEt9N3Zhz4Vmmb7sqXNK/pWIreJjgm6LVz0beu10MRM=;
        b=hqhfeB1ys/MX8nW9A38kB65aKcpVesdp+wBp2eXMr2xzZWCczZPGhbQeMrXxvcFteM
         S7zHi1Riy3h5q/eyH+1kNSJdj/6RppSslEOe2snsoQoffkocKvT3iQMco/JA3QS/RuBI
         seE16sDKePor6mzyGCHtfEOTe7/8vHwsTx2pL2pMGgBZ+boNnsyy6/PDe0wDdkhMTZTX
         sTURM9TV85Ix/biy8ZiWg/c/F2mCr3kdlHd+RaJZ/Vm88hyLmhiUOUuMv775yCgSg3p5
         Ozd9D4PyBJUp8zvCi6shY9EpGMZ9O8PljPGCg2wij8Ijbl+5+TP0oeQ8Kw0Ee+ZwmxGu
         rRYw==
X-Gm-Message-State: AOAM532ppY3gQRgfoPFP45Yx5/f+0Q+HH/rybNdTlXNkwzEoNKXUBWqs
        5w344nwYmVcvTzdozugx60acIA==
X-Google-Smtp-Source: ABdhPJyyOEmzYK0FQivDQe0O5g3cZHm6nQaURPCa+AA+WKAFPTZsK7uW8SAGhg3mYpfM2B8pgGhfRQ==
X-Received: by 2002:a92:d7d0:0:b0:2ca:33ba:8bde with SMTP id g16-20020a92d7d0000000b002ca33ba8bdemr1596697ilq.121.1650125004003;
        Sat, 16 Apr 2022 09:03:24 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k6-20020a6b4006000000b00649d7111ebasm4865516ioa.0.2022.04.16.09.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 09:03:21 -0700 (PDT)
Date:   Sat, 16 Apr 2022 16:03:09 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 05/17] KVM: arm64: Take an argument to indicate
 parallel walk
Message-ID: <YlrovTwbgjeuxXea@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-6-oupton@google.com>
 <871qxxb700.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qxxb700.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 16, 2022 at 12:30:23PM +0100, Marc Zyngier wrote:
> Hi Oliver,
> 
> On Fri, 15 Apr 2022 22:58:49 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > It is desirable to reuse the same page walkers for serial and parallel
> > faults. Take an argument to kvm_pgtable_walk() (and throughout) to
> > indicate whether or not a walk might happen in parallel with another.
> >
> > No functional change intended.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h  |  5 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  4 +-
> >  arch/arm64/kvm/hyp/nvhe/setup.c       |  4 +-
> >  arch/arm64/kvm/hyp/pgtable.c          | 91 ++++++++++++++-------------
> >  4 files changed, 54 insertions(+), 50 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index ea818a5f7408..74955aba5918 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -194,7 +194,7 @@ enum kvm_pgtable_walk_flags {
> >  typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
> >  					kvm_pte_t *ptep, kvm_pte_t *old,
> >  					enum kvm_pgtable_walk_flags flag,
> > -					void * const arg);
> > +					void * const arg, bool shared);
> 
> Am I the only one who find this really ugly? Sprinkling this all over
> the shop makes the code rather unreadable. It seems to me that having
> some sort of more general context would make more sense.

You certainly are not. This is a bit sloppy, a previous spin of this
needed to know about parallelism in the generic page walker context and
I had picked just poking the bool through instead of hitching it to
kvm_pgtable_walker. I needed to churn either way in that scheme, but
that is no longer the case now.

> For example, I would fully expect the walk context to tell us whether
> this walker is willing to share its walk. Add a predicate to that,
> which would conveniently expand to 'false' for contexts where we don't
> have RCU (such as the pKVM HYP PT management, and you should get
> something that is more manageable.

I think the blast radius is now limited to just the stage2 visitors, so
it can probably get crammed in the callback arg now. Limiting the
changes to stage2 was intentional. The hyp walkers seem to be working
fine and I'd rather not come under fire for breaking it somehow ;)

--
Thanks,
Oliver
