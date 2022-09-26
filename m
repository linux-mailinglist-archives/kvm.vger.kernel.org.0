Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5866A5EB37D
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 23:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiIZVsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 17:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiIZVsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 17:48:02 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA2BA7211
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:48:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id iw17so7479297plb.0
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Qjz1Txz2iJkgxmR1f92sk6u9B8zRTWdDfNoqQXPpKYY=;
        b=IqUY+VHHoO4G/lx0vDJtByK4hJdp5MB0HvEMOa1wBb88vCRTdHWjMmcCHiq018ilPA
         HNAvSoodrjpLnp9lBoIucLKiBil+mL1pyLzIiYwZcWwL19EhJwOP+hcPm4ucL7b/VK6K
         yD3r9o3dSOdv5ADHx+An3fdPH1WMirt1HLiQdcTf5y1BWPfemxteIO/YhsgUUs13VZLT
         Rb6mQdV3lac9XVrca0GmwFgACJmdcp7ONRWCOT3GJ7o/43ShoyiJ2Iuyek8cEXNfJyr6
         4CKz3kXKMwwqTVst29E7thGSG64dQMOW6Q0X2hzadOaJKzoXwyr/dgn9YzhWPCv3wewB
         4t6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Qjz1Txz2iJkgxmR1f92sk6u9B8zRTWdDfNoqQXPpKYY=;
        b=EcQcQtdHhnLgr6Nq2bYqhk0L0BH5p/CqDPYXJYskibWnz4Ln65BnX8bXSQxHkT8BRH
         puwVjQ6l+oRi7QieAitAIIywSIDxeTLcpIKMEWv9/lnYLFnB3oQnwU3/A3wpu9XNg/PI
         9bYUdx2nqUwe+q7e1SptztHf6ABQev7EyXWdHKZ/merV5+PZDML/tZtyfzaxuyNrQBNh
         zpZGa5YNjIT4qmljsc1k6P1PrU9AjZqrSRXGayQAogDgO3VKEXX/Mwhjbbgvd1xnEP4n
         PmURMN5x6irE0+oxr8dHQHNxcFWOlTx4uuERa5tqZAxBjMUwOCIOM3u37addkqLKwBdw
         ab/w==
X-Gm-Message-State: ACrzQf2px3CAkvCid5dRACvrW0KmlcGtW40IBPAs04xR04iuMm+s10UK
        aIjLaAA0gV2prAsDRZsQPZWAfnQ6+/sKAg==
X-Google-Smtp-Source: AMsMyM5Ju5q3fCmTuYfZ7VvLUceZ7IlGaiDysaRlQcyc0kuFsBTmGeCY32S2umVAj+Gp6OoabgR3Og==
X-Received: by 2002:a17:90b:4f45:b0:203:6d82:205c with SMTP id pj5-20020a17090b4f4500b002036d82205cmr837488pjb.224.1664228880253;
        Mon, 26 Sep 2022 14:48:00 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902eccd00b0016be596c8afsm11717550plh.282.2022.09.26.14.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:47:59 -0700 (PDT)
Date:   Mon, 26 Sep 2022 14:47:55 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Gracefully handle empty stack traces
Message-ID: <YzIeCzIdffRSRbec@google.com>
References: <20220922231724.3560211-1-dmatlack@google.com>
 <CAHVum0cBvORZo1k0p2MQVZQ8tLddpjOmDrmfV19zuTLUYMjrpA@mail.gmail.com>
 <YzIRTx/f/bECYvM7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzIRTx/f/bECYvM7@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 08:53:35PM +0000, Sean Christopherson wrote:
> On Mon, Sep 26, 2022, Vipin Sharma wrote:
> > On Thu, Sep 22, 2022 at 4:17 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > Bail out of test_dump_stack() if the stack trace is empty rather than
> > > invoking addr2line with zero addresses. The problem with the latter is
> > > that addr2line will block waiting for addresses to be passed in via
> > > stdin, e.g. if running a selftest from an interactive terminal.
> 
> How does this bug occur?  Does backtrace() get inlined?

backtrace() is returning 0. I haven't debugged it further than that yet.
I figured gracefully handling an empty stack trace would be useful to
have independent of this specific issue (which I assume has something to
do with our Google-specific build process).

backtrace() is not getting inlined.

> 
> > > Opportunistically fix up the comment that mentions skipping 3 frames
> > > since only 2 are skipped in the code.
> > >
> > > Cc: Vipin Sharma <vipinsh@google.com>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/lib/assert.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
> > > index 71ade6100fd3..c1ce54a41eca 100644
> > > --- a/tools/testing/selftests/kvm/lib/assert.c
> > > +++ b/tools/testing/selftests/kvm/lib/assert.c
> > > @@ -42,12 +42,18 @@ static void test_dump_stack(void)
> > >         c = &cmd[0];
> > >         c += sprintf(c, "%s", addr2line);
> > >         /*
> > > -        * Skip the first 3 frames: backtrace, test_dump_stack, and
> > > -        * test_assert. We hope that backtrace isn't inlined and the other two
> > > -        * we've declared noinline.
> > > +        * Skip the first 2 frames, which should be test_dump_stack() and
> > > +        * test_assert(); both of which are declared noinline.  Bail if the
> > > +        * resulting stack trace would be empty. Otherwise, addr2line will block
> > > +        * waiting for addresses to be passed in via stdin.
> > >          */
> > > +       if (n <= 2) {
> > > +               fputs("  (stack trace empty)\n", stderr);
> > > +               return;
> > > +       }
> > 
> > Shouldn't this condition be put immediately after
> >         n = backtrace(stack,n)
> 
> Agreed, that would be more intuitive.

I had that at one point, but then it became confusing that the check is for
(n <= 2) and not (!n).

How about this?

diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index 71ade6100fd3..2b56bbff970c 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -38,16 +38,28 @@ static void test_dump_stack(void)
                 1];
        char *c;

-       n = backtrace(stack, n);
        c = &cmd[0];
        c += sprintf(c, "%s", addr2line);
-       /*
-        * Skip the first 3 frames: backtrace, test_dump_stack, and
-        * test_assert. We hope that backtrace isn't inlined and the other two
-        * we've declared noinline.
-        */
-       for (i = 2; i < n; i++)
-               c += sprintf(c, " %lx", ((unsigned long) stack[i]) - 1);
+
+       n = backtrace(stack, n);
+       if (n > 2) {
+               /*
+                * Skip the first 2 frames, which should be test_dump_stack()
+                * and test_assert(); both of which are declared noinline.
+                */
+               for (i = 2; i < n; i++)
+                       c += sprintf(c, " %lx", ((unsigned long) stack[i]) - 1);
+       } else {
+               /*
+                * Bail if the resulting stack trace would be empty. Otherwise,
+                * addr2line will block waiting for addresses to be passed in
+                * via stdin.
+                */
+               fputs("  (stack trace missing)\n", stderr);
+               return;
+       }
+
        c += sprintf(c, "%s", pipeline);
 #pragma GCC diagnostic push
 #pragma GCC diagnostic ignored "-Wunused-result"

