Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9384F1BC2
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381201AbiDDVWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379923AbiDDSVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:21:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C7822B20
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:19:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ch16-20020a17090af41000b001ca867ef52bso497144pjb.0
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 11:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aiqJZ75/YWr0n8WF7lZiF1Fjak6AGRA7UVKN+yFyHrY=;
        b=k2z4OSa4+eckdOtXVxKvSW/v87vtp2H6bCdPyILueYWMdwy5RcQGTrthmlyRKI+4OI
         2sFfoLEEM3FAmnL0mNEXE3Acm9HfuUjcbpfBhScTdVTXF1zwpOR5WLjrb4esOqo8U51c
         MRO2xOQecJogFv+wHld28UDGdrS+XImpNb3ak+kjgOYgkDY5E1tJpt09k0j/w20JCFKK
         fdFRL1Qe0n5TOiOxwo1d6PTRJnMTSoAPvIXOkJHukg/0rpqorWhDxFiy+zh2v5gLZISk
         qER49CE71HkRIrMDUar5JrVHSTWu7YLHjN8YokyseXHkbtfnHjLtjLDiW4z6qlk14Hfi
         wRQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aiqJZ75/YWr0n8WF7lZiF1Fjak6AGRA7UVKN+yFyHrY=;
        b=epmHE1Wl/pMCJhMumHPd/gNDyKACdG/KudB+nl2LVNlQ+I0Q4on+U7MrvbNcqudoZp
         54YG1NvT95/9DJV2PCM2YnlEoQ0+/QcKBTN5m486Gshf0V2DKE/ONCFRTCNJtbljeAa+
         eG1nEGr7ay7WpIy4IuBIOWszHE/CLOe+FurtPRGROOL0SuzLki+SgyMnIwpo2pQjHJXQ
         lEjDxFfYW6ARIIbDrafhErkpgi30NDE/LYWwdPfOxPyO1kqtWOKvN53nEdEzDNbWbNcF
         jGN7DFQS+BFugdKOs1wGnOz29o76hUY92Arr3uhIXeAkFWcOwtN3EKdydyakYhQUUXSv
         VxMA==
X-Gm-Message-State: AOAM531lF50Rbpb0ASxSvcMcSnt1xBxIsEpbUyy+1IfGiCTHem5hR06L
        XcaTpnh7J36Uq625reCkOvMSTQ==
X-Google-Smtp-Source: ABdhPJyC0EtrClYW2oXUEDPlR/Xd8c/63XIi9S0t0BKD1jqC8/QGFTPrx8Wl2HvoxKb4M4Nha9hADA==
X-Received: by 2002:a17:90b:4a12:b0:1c7:5aa4:2a72 with SMTP id kk18-20020a17090b4a1200b001c75aa42a72mr453365pjb.201.1649096398654;
        Mon, 04 Apr 2022 11:19:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e19-20020a637453000000b003821bdb8103sm11067301pgn.83.2022.04.04.11.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 11:19:58 -0700 (PDT)
Date:   Mon, 4 Apr 2022 18:19:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 1/6] KVM: x86/mmu: Set lpage_disallowed in TDP MMU
 before setting SPTE
Message-ID: <Yks2ymJzY4S9x4zx@google.com>
References: <20220401063636.2414200-1-mizhang@google.com>
 <20220401063636.2414200-2-mizhang@google.com>
 <CANgfPd9OqV35BGfRCvJZNK_kemgqDWPx8TKKObfyGb0iiC-uxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9OqV35BGfRCvJZNK_kemgqDWPx8TKKObfyGb0iiC-uxg@mail.gmail.com>
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

On Mon, Apr 04, 2022, Ben Gardon wrote:
> On Thu, Mar 31, 2022 at 11:36 PM Mingwei Zhang <mizhang@google.com> wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 1bff453f7cbe..4a0087efa1e3 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -168,7 +168,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
> >
> >  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> >
> > -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> > +void __account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> 
> I believe we need to modify the usage of this function in
> paging_tmpl.h as well, at which point there should be no users of
> account_huge_nx_page, so we can just modify the function directly
> instead of adding a __helper.
> (Disregard if the source I was looking at was out of date. Lots of
> churn in this code recently.)

paging_tmpl.h is shadow paging only, i.e. will always handled page faults with
mmu_lock held for write and it also needs the check for sp->lpage_disallowed
already being set.  Only the TDP MMU code is special in that (a) it holds mmu_lock
for read and (b) never reuses shadow pages when inserting into the page tables.

Or did I completely misunderstand what you meant by "need to modify the usage"?
