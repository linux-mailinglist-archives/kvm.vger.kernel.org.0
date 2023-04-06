Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE06D9D93
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 18:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbjDFQbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 12:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236627AbjDFQbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 12:31:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8CA59CF
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 09:31:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54c0b8ca2d1so29108267b3.17
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680798706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YuNYSPXJfqifR9aEUh0OmPm6EMtA7Km2ZTdZkvo/Q6w=;
        b=PPO3FOLpzeesLv6U3pR/0j1aFbDUKLpIXSBYMe+/L0gK4tmndW2ckklpXTIynXZFgN
         crmtj7iVoVhw8j3Grk+JjfXCmi3OOh5IlsmleYihf6LdfZlJqO50CeQlHFucDP37eVp0
         wLVmNcT0d97d6DGqsi3ucAhsCg9GskCRxRxhMI4h+dNtGOHfmS3T17rAFsBOrjZvKA0O
         2hh+LFOWpkeSgQoOmXSzaicxDT6NrWeuK2lhSeWKuK0REEQVrXdv09vhgMWm4bCBo6wg
         SGxxesqWm6O7ka69Tkf4ZddfN/QFK8/4uONDHeSUm5RcaNPM3/oeSEct98uFkmW19gNM
         aCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680798706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YuNYSPXJfqifR9aEUh0OmPm6EMtA7Km2ZTdZkvo/Q6w=;
        b=KtXnWWTj/yGL2e3q7Nl5vsIbdc77OLeurUd9TxCujBIboxwDBSNwb/7bWhm/lBKuau
         86eM7n7SsIrk6ujBLx7zccgG7dHT5G5K/mocbFyMKUjycP2PvR3Bz990sIR4nR8PtLRX
         hyCoN/MERukN6lxZGLlgsbbRE0k/yWqjKzd9rBhFnc4DpY6xaTQNccG5aEKPFNPhBWm/
         eDyxeQp3jGdQ/8LNLSahedwJvcVdnyTob/pqRE7Y/Hj/JMlva9Hn3EMwNp0LQUHzJfUK
         FlCDsd+JDbCTogG4ATHKR3g8dnF0F17VTEiy9s8xgs20ALUqeGBcGlN45Qm9rAJCi5/a
         M6OA==
X-Gm-Message-State: AAQBX9da1pa9lBMf9JLloyK3d+bsRc786gXuZeQz5Yf54x7YsT2oD/nL
        miq7oC27cfc+TBW8h7wfd5AmExb1Yzg=
X-Google-Smtp-Source: AKy350b8Yd2s5s/tN8Ahe/jwv9s95Zq7/xBeqjYl9vakRGO922FuWiibaj2cIu30uJpMqNpo7EHuFbZ5lZU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:50d1:0:b0:b6b:d3f3:45af with SMTP id
 e200-20020a2550d1000000b00b6bd3f345afmr2468203ybb.1.1680798706212; Thu, 06
 Apr 2023 09:31:46 -0700 (PDT)
Date:   Thu, 6 Apr 2023 09:31:44 -0700
In-Reply-To: <a2ff46e7-748a-0cd2-d973-8ce1cdbfa004@grsecurity.net>
Mime-Version: 1.0
References: <20230405205138.525310-1-seanjc@google.com> <20230405205138.525310-2-seanjc@google.com>
 <a2ff46e7-748a-0cd2-d973-8ce1cdbfa004@grsecurity.net>
Message-ID: <ZC7z8F4PlwMcmkpL@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 1/2] nSVM: Add helper to report fatal
 errors in guest
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Mathias Krause wrote:
> On 05.04.23 22:51, Sean Christopherson wrote:
> > Add a helper macro to dedup nSVM test code that handles fatal errors
> > by reporting the failure, setting the test stage to a magic number, and
> > invoking VMMCALL to bail to the host and terminate.
> > 
> > Note, the V_TPR fails if report() is invoked.  Punt on the issue for
> > now as most users already report only failures, but leave a TODO for
> > future developers.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  x86/svm_tests.c | 127 ++++++++++++++++--------------------------------
> >  1 file changed, 42 insertions(+), 85 deletions(-)
> > 
> > diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> > index 27ce47b4..e87db3fa 100644
> > --- a/x86/svm_tests.c
> > +++ b/x86/svm_tests.c
> > @@ -947,6 +947,21 @@ static bool lat_svm_insn_check(struct svm_test *test)
> >  	return true;
> >  }
> >  
> > +/*
> > + * Report failures from SVM guest code, and on failure, set the stage to -1 and
> > + * do VMMCALL to terminate the test (host side must treat -1 as "finished").
> > + * TODO: fix the tests that don't play nice with a straight report, e.g. the
> > + * V_TPR test fails if report() is invoked.
> > + */
> > +#define report_svm_guest(cond, test, fmt, args...)	\
> > +do {							\
> > +	if (!(cond)) {					\
> 
> > +		report_fail("why didn't my format '" fmt "' format?", ##args);\
>                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> Debug artifact? Should probably be this instead (making use of C99):

Yes.  I'm just glad I posted the PG version and not the rated R version.
