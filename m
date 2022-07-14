Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E5F5757EA
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 01:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240867AbiGNXPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 19:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240811AbiGNXPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 19:15:49 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576D070E57
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 16:15:48 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 5so1736264plk.9
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 16:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1uA4mMpLpcRR07bw1byaro66HK9+gzc14ZtiPZ8jfjA=;
        b=As7pQ8CUT32Bd1LIq4AKb1ELuwXk+Tg1MdC1AUysMK9njWTOlc0OAsXlYWtrr15WJk
         t5DF7RJsJdX2IR1vzbg0HicaP5A2owgtHNkeSnINSoyTDbi8Ql5QDPkxKyD4dfoUrGJo
         tRetXkr7kWDTsVcYinNmDFQ39nrnuRrxNd5E4wCVyv1itFi0ABg2+6qKEqwMEprgc893
         TSEFRiVf74mGYfN6ZZqIzL20etl7QHWiX4IciOkajGrieYbSwPZ+5UYHPMkPzIMhAkbL
         PcIKqJiZwDSy4YkQnQ7E94tuNJCizdBQWm0M7qr2DoUzRPC9iCHDUTY0QU51B8YEZlMw
         S2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1uA4mMpLpcRR07bw1byaro66HK9+gzc14ZtiPZ8jfjA=;
        b=FSpOLccrsxAuo73SqF6GARTZdyhUXphgVn2o9WHbH5etQ2mUIWo2spR9z+iCaOnmCr
         d6VeLuM+kkZ4sYq7eVpwYi0B1p2R4Xwo6vn3oemvoxTu7jTVBl1/MQZNoEd/ZLXCjmM6
         VRODKdJiZUqcI3pqPs7dyjPa4kKQddoUqvXh3+6mgdbIElYgsRXgjTNI5I6as6E6eDFA
         i48v8fhWDdrw1FwQeOJjCwpiPhCNzWkT0w2pHzWIWUAY5Cok6278QXlmBW3Wvnz07viM
         v+XkWdl/QeFBQnBXsX6qUnzCR3JVRS5i8VM2tKrePuWSWI268RJ1ySFvAR+PVwCXLcSo
         NhXg==
X-Gm-Message-State: AJIora/OpxmG79XM/GtVl9bAiV+HDd/5k620YXXVpRp7BwKkkFtqzS13
        Er+ps+Rfm4W5mz5fzyrAbw48fA==
X-Google-Smtp-Source: AGRyM1uZbC7z2IBVQIZHYd+INOO841VeEdfsy+WMFnXkM1+47oPPD8//WDi92rKva1HNS7Gb3v0yVQ==
X-Received: by 2002:a17:90a:c4f:b0:1df:a178:897f with SMTP id u15-20020a17090a0c4f00b001dfa178897fmr12107587pje.19.1657840547725;
        Thu, 14 Jul 2022 16:15:47 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b001677d4a9654sm2016703plx.265.2022.07.14.16.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 16:15:47 -0700 (PDT)
Date:   Thu, 14 Jul 2022 23:15:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 04/12] KVM: X86/MMU: Remove mmu_pages_clear_parents()
Message-ID: <YtCjnvTkx1wtsuLn@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-5-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-5-jiangshanlai@gmail.com>
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

For the shortlog, I really want to capture the net effect.  It took me a lot of
staring and reading (and hopefully not misreading) to figure out that this is a
glorified nop.

  KVM: x86/mmu: Update unsync children metadata via recursion, not bottom-up walk

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> mmu_unsync_walk() is designed to be workable in a pagetable which has
> unsync child bits set in the shadow pages in the pagetable but without
> any unsync shadow pages.
> 
> This can be resulted when the unsync shadow pages of a pagetable
> can be walked from other pagetables and have been synced or zapped
> when other pagetables are synced or zapped.
>
> So mmu_pages_clear_parents() is not required even when the callers of
> mmu_unsync_walk() zap or sync the pagetable.

There's one other critical piece that it took me a quite some time to suss out
from the code: the @parent passed to mmu_sync_children() _is_ updated because
mmu_sync_children() loops on mmu_unsync_walk().  It's only the parents of @parent
that are not updated, but they weren't updated anyways because mmu_pages_clear_parents()
doesn't operate on the parents of @parent.

> So remove mmu_pages_clear_parents() and the child bits can be cleared in
> the next call of mmu_unsync_walk() in one go.

Ah, I missed (over and over) that the "next call" is the one right mmu_sync_children()
and mmu_unsync_walk(), not a future call.

Because I kept losing track of which pagetable was which, how about this for
a changelog?

  When syncing a shadow page with unsync children, do not update the
  "unsync children" metadata from the bottom up, and instead defer the
  update to the next "iteration" of mmu_unsync_walk() (all users of
  mmu_unsync_walk() loop until it returns "no unsync children").

  mmu_unsync_walk() is designed to handle the scenario where a shadow page
  has a false positive on having unsync children, i.e. unsync_children can
  be elevated without any child shadow pages actually being unsync.

  Such a scenario already occurs when a child is synced or zapped by a
  different walk of the page tables, i.e. with a different set of parents,
  as unmarking parents is done only for the current walk.

  Note, mmu_pages_clear_parents() doesn't update parents of @parent, so
  there's no change in functionality from that perspective.

  Removing mmu_pages_clear_parents() allows for further simplifying
  mmu_unsync_walk(), including removing the struct mmu_page_path since
  mmu_pages_clear_parents() was the only the function is the only user of it.

With a cleaned up shortlog+changelog, and assuming I didn't misread everything...

Reviewed-by: Sean Christopherson <seanjc@google.com>

> 
> Removing mmu_pages_clear_parents() allows for further simplifying
> mmu_unsync_walk() including removing the struct mmu_page_path since
> the function is the only user of it.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
