Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE9A54E617
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377891AbiFPPal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbiFPPak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:30:40 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557962E9CF
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:30:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d5so1538384plo.12
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xyQA3i9LnHHRPtVIgpzT7gUhIahjzWNFcSvLeE3NzXM=;
        b=m8zeYkKW1u4euayYAVyXDBaR9zlZbRLD9hLN82f7yubbRQj413prV28w+UiWa+pdmO
         KfQU5sqy4lxAVxLWqvxNJ+R0X1Cg49NLh+9dqRacje4S+bLKHChZGLn5cCY9qVldylWv
         BThfklbuxOqytrmtLCTcgu6672q0ulAJh/DmRwjEMqmbseJmnzoSpyL3Re5y11oA/Pdf
         ene2w0/s2/w8UiMku30v+m6LUnIoyJEEw1zTmk4fXijS4O9ZxAzsgd8cwtwv5imNpYnA
         96g8TJtI50rX4BZPGwQ1loluMHVGomrK3kyaqqHN+iXQKU9L12RDbql4lPWX3FeB8+lo
         J93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xyQA3i9LnHHRPtVIgpzT7gUhIahjzWNFcSvLeE3NzXM=;
        b=O9MU76F7CR0pG2KvvmfzeormPBubg9z8yiPIgT7T1Erg3ZKKRQVwSDzZyxKHI20+Dw
         FZ9h1LIZqFzQTWXf9jqgOncPGkmMXlL/VgSUYPRDMeEnqzhwolWHZi3V5sq/VNEdNhLM
         Z0yWhVX8YFolDjQ9l4FAynnVs2edlxVo+fjjAyOY4gvoOF22Knir5H0VvxhTByc96KAR
         SDywS0lJocC/Q6DNh+qkREvFfhyuRhqBfq0bC7Xm5/QRAG7j3+xVQPJ5Y7rGXfTxr7uS
         VyBsTFS6eF0ZWOfZjRWX11g4wiSAkUVjgV+Sx/23Y1+ynyY/DB+S8+7Ur+trOq+nLvu8
         9L9A==
X-Gm-Message-State: AJIora8JcVEdmkwCgnS/N+FAW2R9QwweSpxZqEBSRSevTssXX1KtphWl
        J9cntbEL3Xi4DulSXIc4KRubOg==
X-Google-Smtp-Source: AGRyM1vJ6B9gtYuMINf2l7lRLtW7qllBMCm1snr4t0uqnQGiA2z/c3Ik3BuauG2Z1RHrpJXEIU4ngg==
X-Received: by 2002:a17:90b:4b02:b0:1e2:ff51:272a with SMTP id lx2-20020a17090b4b0200b001e2ff51272amr5616373pjb.56.1655393437532;
        Thu, 16 Jun 2022 08:30:37 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709028eca00b0016368840c41sm179880plo.14.2022.06.16.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 08:30:36 -0700 (PDT)
Date:   Thu, 16 Jun 2022 15:30:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
Message-ID: <YqtMmAiOvJbmHCaP@google.com>
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com>
 <YpZgU+vfjkRuHZZR@google.com>
 <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
 <YpeWPAHNhQQ/lRKF@google.com>
 <cbb9a8b5-f31f-dd3b-3278-01f12d935ebe@gmail.com>
 <YqoqZjH+yjYJTxmT@google.com>
 <69fac460-ff29-ca76-d9a8-d2529cf02fa2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69fac460-ff29-ca76-d9a8-d2529cf02fa2@redhat.com>
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

On Thu, Jun 16, 2022, Paolo Bonzini wrote:
> On 6/15/22 20:52, Sean Christopherson wrote:
> > I completely agree on needing better transparency for the lifecycle of patches
> > going through the KVM tree.  First and foremost, there need to be formal, documented
> > rules for the "official" kvm/* branches, e.g. everything in kvm/queue passes ABC
> > tests, everything in kvm/next also passes XYZ tests.  That would also be a good
> > place to document expectations, how things works, etc...
> 
> Agreed.  I think this is a more general problem with Linux development and I
> will propose this for maintainer summit.

I believe the documentation side of things is an acknowledged gap, people just need
to actually write the documentation, e.g. Boris and Thomas documented the tip-tree
under Documentation/process/maintainer-tip.rst and stubbed in maintainer-handbooks.rst.

As for patch lifecycle, I would love to have something like tip-bot (can we just
steal whatever scripts they use?) that explicitly calls out the branch, commit,
committer, date, etc...  IMO that'd pair nicely with adding kvm/pending, as the
bot/script could provide updates when a patch is first added to kvm/pending, then
again when it got moved to kvm/queue or dropped because it was broken, etc...
