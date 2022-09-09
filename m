Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6C45B3B49
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 16:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiIIO5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 10:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiIIO5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 10:57:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8B213864C
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 07:57:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so1860028pjl.0
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 07:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=sJne0n/dItmJ8FdGRvyu4m07+jsgg1m7nAPE19ef1wY=;
        b=AHVdvIw1kNaGDusehlOEfHFjz5kJt2wmTST21GNKFhy400uzrzuUxd6pE+wQa+rBUJ
         jBWLvdg1b7VC1J8IrpyKNtOmv+KfbZC3H8ciFHskMxGBXwRS169LRwqtHth8X2Oertt0
         ZodcXJ5CWhpbtZAYjdQj67F5xrjuQ7kkTk3loCXMOChsTRU7XJwqqcySB3IDP6WF7x06
         4dJqbyEgn/W6mcXPkvdsqYM8o7kDtIVAotp6QLcnu+y0fnTkVi5Df72ah6QuDNJ4D98w
         g7fjrNZhRJkg6+HJVbMvXA0RXVdGUNzccPiPwb0cLMxtYSAqyyFlojg6Cm3QpGkyDsYS
         uY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sJne0n/dItmJ8FdGRvyu4m07+jsgg1m7nAPE19ef1wY=;
        b=L7BEcJ/DzDQMWDmleqwBGfZFgcyrNlb8eepPe8zy8NBHcxK0LrRbm/B3yyzR/Ysxa0
         jPP0HYpP2Sle2uySI+4muZbZI9Qv8Upidvl6qE4PR06sV+dbZmyKRQlxVf4gpvtdK+AS
         /0DZ+hmwo/rP5txo9n3tUgP/T0JIGGjtc7GQ7K8qjA0BoNjaZ8M37mq1Obe2nB7yJjDq
         RJy3nP7/mwlqL0xxoyDqMywp+G01irS4sjcGoqJLdOkc1HijtKYtFtJw6rbwHENhlJkB
         /+uvqAKFNqbINz8Y0wzMHealJN332CzPAK4OU5nbEpIwLECB5NMESUgsglfm875wsZCH
         0WJg==
X-Gm-Message-State: ACgBeo1Kndz77WIkBymjHbEunL4NunUxpbgEunCLDOLSt7Qp+14MQosN
        XXBzJJqD4dkMJAshOJVIa6wAkA==
X-Google-Smtp-Source: AA6agR4ptQYvFRKAt8ikaON84I1JqNPp2elrnTXBuPEH1pav0TaYUexSj4GIwV+e2snvobL+D9V40A==
X-Received: by 2002:a17:90b:4d0d:b0:1fb:a86d:e752 with SMTP id mw13-20020a17090b4d0d00b001fba86de752mr10065280pjb.120.1662735462930;
        Fri, 09 Sep 2022 07:57:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i127-20020a625485000000b00540ffb28da0sm667281pfb.91.2022.09.09.07.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:57:42 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:57:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH v2] KVM:x86: Clean up ModR/M "reg" initialization in reg
 op decoding
Message-ID: <YxtUYzT7XM5F9YDf@google.com>
References: <20220908141210.1375828-1-zhiguangni01@zhaoxin.com>
 <YxoPS5OCup1h8QD4@google.com>
 <CACZJ9cVSYtda7oyJnMmNDtfZotXZu+0i-c8G8onLqj4sPDkCRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACZJ9cVSYtda7oyJnMmNDtfZotXZu+0i-c8G8onLqj4sPDkCRg@mail.gmail.com>
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

On Fri, Sep 09, 2022, Liam Ni wrote:
> On Thu, 8 Sept 2022 at 23:50, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Sep 08, 2022, Liam Ni wrote:
> > > From: Liam Ni <zhiguangni01@gmail.com>
> > >
> > > Refactor decode_register_operand() to get the ModR/M register if and
> > > only if the instruction uses a ModR/M encoding to make it more obvious
> > > how the register operand is retrieved.
> > >
> > > Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> > > ---
> >
> > Pushed to branch `for_paolo/6.1` at:
> >
> >     https://github.com/sean-jc/linux.git
> >
> > with the below nit sqaushed.  Unless you hear otherwise, it will make its way to
> > kvm/queue "soon".
> >
> > Note, the commit IDs are not guaranteed to be stable.
> >
> > >  arch/x86/kvm/emulate.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index f092c54d1a2f..879b52af763a 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -1137,9 +1137,11 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
> > >  static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
> > >                                   struct operand *op)
> > >  {
> > > -     unsigned reg = ctxt->modrm_reg;
> > > +     unsigned int reg;
> > >
> > > -     if (!(ctxt->d & ModRM))
> > > +     if ((ctxt->d & ModRM))
> >
> > Only need one set of parentheses.
> 
> Sorry，  Should I prepare a new patch?

Nope, all taken care of.  Thanks!
