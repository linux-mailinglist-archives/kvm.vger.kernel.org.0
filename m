Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B254EEEC6
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 16:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346480AbiDAOH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 10:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239154AbiDAOH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 10:07:26 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97721F957A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 07:05:36 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id y16so1995492ilc.7
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 07:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uXCsVFWD0w4UXVh3Fm9w12+K/OXplZUFIZtiYekvHOc=;
        b=OnRuDW1exu8WenVX/hdv7SauOsLKx9F7IbXLwA5bW1DRWnwcvgCQCLyRK1ri6iZlDi
         eQwsmB8XJ8egNj7UM1643Rt0PfDFFSRhMpNflrh8tRDOYw6w+dbSh0ScSRu95tYOQIq4
         bmbc6oZtQEMLODJE0iaSN4Pt0Ge1WcXAPwLVQixNil046ixreKkN1UYI4Er2jeeuqCR8
         Zwwa4zVlf/bV4mnY+T+kqNbNrMvcb2ypeFTOvoqNLWzy8Q9+6OWMxG+rES6zex+cdNnR
         6e9Zx1ZUkAv9JoJbA7FERY8waWfpDlCcjWjSs2EoCq12eG0deRpR5Vnc/j6AbcPiAhvl
         F4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uXCsVFWD0w4UXVh3Fm9w12+K/OXplZUFIZtiYekvHOc=;
        b=zmKahNkfiui+vCyACM/YpJRnYuqkIS2LnJtDFKfos5Iyw8Ydk/W3gBQ+x0Y8HnBAMl
         eGDaoaUtzQS+fWvM7VLQ3VsJh60xA2b7aWZ5649j0a51yzAj0ok5Euiq/jNYIEQ9Ukpm
         Ikv/mTDEpybP+IgvwZCBREtePTPO4x2sQlZtvKhfTtTII0Nc07XB3jvzD+a0GSSR0hkm
         gOyOpncxhKjjBZHD4de6ml0WPuTf1xFqKOhHh22rHrV54Bi88NYbeXE3sEHe7R6neQrQ
         dIo8ERo0t3NokTlHQggavIkVFxurCZV+WbKzHyZqN//Ka0fLo2/shnLjrOrshTTYlK28
         v3FA==
X-Gm-Message-State: AOAM530AOfazNVXhOHhnj9iF9jmBPclZxSZ8W5dUhiX4J3LFBq9NNLCk
        pa4XJLiAA5M6UkgQhyYLNkqKIA==
X-Google-Smtp-Source: ABdhPJwE8ilKQ9QfD3xy/86HeFqHu2rPR9sYvkA0605Z0iQcRtHcmIDbU/M+ee2N5iC+wi8KuITDFA==
X-Received: by 2002:a05:6e02:1b0f:b0:2c7:9ec2:1503 with SMTP id i15-20020a056e021b0f00b002c79ec21503mr15653859ilv.209.1648821935764;
        Fri, 01 Apr 2022 07:05:35 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id h5-20020a92c085000000b002c9fcc469c8sm1342037ile.81.2022.04.01.07.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 07:05:34 -0700 (PDT)
Date:   Fri, 1 Apr 2022 14:05:31 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't split hugepages outside of MMU write
 lock
Message-ID: <YkcGq5IHx5HUodGd@google.com>
References: <20220331213844.2894006-1-oupton@google.com>
 <CAAeT=FzmvwmXoxn41xqYJByNgGMwCRViCUP9yZ0cun13nJ43PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FzmvwmXoxn41xqYJByNgGMwCRViCUP9yZ0cun13nJ43PQ@mail.gmail.com>
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

Hi Reiji,

Thanks for the review!

On Thu, Mar 31, 2022 at 11:07:23PM -0700, Reiji Watanabe wrote:
> > @@ -1267,10 +1268,24 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >          */
> >         if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
> >                 ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> 
> When use_read_lock is set to true, it appears the above condition will
> become always true (since fault_granule is PAGE_SIZE and force_pte
> is true in this case).  So, I don't think the following "else" changes
> really make any difference.  (Or am I overlooking something?)
> Looking at the code, I doubt that even the original (before the regression)
> code detects the case that is described in the comment below in the
> first place.

Yes, you are right.

I liked the explicit check against !use_read_lock (even if it is dead)
to make it abundantly clear what is guarded by the write lock.
Personally, I'm not a big fan of the conditional locking because it is
hard to tell exactly what is protected by the read or write lock.

Maybe instead a WARN() could suffice. That way we bark at anyone who
changes MMU locking again and breaks it. I found the bug with the splat
above, but warning about replacing an already present PTE is rather far
removed from the smoking gun in this situation.

Outside of the regression, I believe there are some subtle races where
stage-2 is modified before taking the MMU lock. I'm going to think
further about the implications of these, but perhaps we should pass
through a page level argument to kvm_pagetable_stage2_relax_perms() and
only do the operation if the paging structures match what is reported in
the FSC. If the IPA is not in fact mapped at the specified page level,
retry the faulting instruction.

I'll get a patch up that addresses your comment and crams a WARN() in to
assert the write lock is held.

--
Thanks,
Oliver
