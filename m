Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1825EB2B7
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiIZUyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 16:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiIZUxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 16:53:47 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D87AF484
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 13:53:40 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d10so6765546pfh.6
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 13:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=DpuxZjPdf2l/EbzTRJ/K5eWkj0c7C9MsHnR/3VYq1Ig=;
        b=HnrJe9RTIj+rGaYr0fXsyuZrpffKhICHee6VYvIZ7YV7JsoYBgYfFy72XkeCqCLpay
         fZXqlpQA/rP4Ut3bW3yGmeyloMLWLO4Ke6gi/T+3NYnhfMEJzkOoRe0tNEYT2oz4Y+tJ
         heIW9y5yV2zm6wNTF9yqVizjlM5vPRLG84ThHH9QjVNG4ragKe1BP/vZx3QQuxoe5Qhb
         Fn3gshdZ1KGXFnRhb1N/tNr1pyrreCtHwnY2/rXWp4KW/q9rPQra2oqOaB8uMPrkSepF
         xMA+B60GkmPCBLYAfxUU33R5FTJhKUkzQisRLlLcCZz9BqT0SE9o2RKitFpYw63VU4Uf
         5kwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=DpuxZjPdf2l/EbzTRJ/K5eWkj0c7C9MsHnR/3VYq1Ig=;
        b=lqvG7cuFkVzSgMYP4FZ5z5zv4IajVg7l+fJaoAEQzlVCINw4BuSuWLOPjzOJ6ZMrdN
         t9wEM0wQBcQVQDfFPg/BMlOW+BoNsTwrKRCORrTRqa1XR8hw/ezTR3v+wRw1iPw+XeXs
         bsFr1AiGFcuPVX/jpfqingHfYK6jAP/mkjPgQLU5SAfBQr7MzcUNl0Ce3OqnjOnwAXbJ
         n3XVQAVz+H9sZ0lWrZZONr+qDyZZUVK+O0vUeIeMykuQSgGCLNIIhiBJAzeN9GdSIB5u
         sVwqRgkR6bRS56FGG7/+83nGUNpLZZIiy9Sc8UDyobaFFt6kmV18m+uGqipDxdXWrUyG
         RN3Q==
X-Gm-Message-State: ACrzQf1cfSycWXPvcww2JnErhTyrywpVhLNFXeHDpa3mx8JHxisbiLMh
        BplGjMK4AQjq2kp345uo2GEX5A==
X-Google-Smtp-Source: AMsMyM6ga1lQydbST5CaIX7umznMX2N0l71/3Y/o/cMemXx3ebHQroCDzyiJmrIFuzii+CqKSdia7Q==
X-Received: by 2002:a63:5243:0:b0:43c:96a:8528 with SMTP id s3-20020a635243000000b0043c096a8528mr21254052pgl.47.1664225619671;
        Mon, 26 Sep 2022 13:53:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm11628037plk.143.2022.09.26.13.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 13:53:39 -0700 (PDT)
Date:   Mon, 26 Sep 2022 20:53:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Gracefully handle empty stack traces
Message-ID: <YzIRTx/f/bECYvM7@google.com>
References: <20220922231724.3560211-1-dmatlack@google.com>
 <CAHVum0cBvORZo1k0p2MQVZQ8tLddpjOmDrmfV19zuTLUYMjrpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0cBvORZo1k0p2MQVZQ8tLddpjOmDrmfV19zuTLUYMjrpA@mail.gmail.com>
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

On Mon, Sep 26, 2022, Vipin Sharma wrote:
> On Thu, Sep 22, 2022 at 4:17 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Bail out of test_dump_stack() if the stack trace is empty rather than
> > invoking addr2line with zero addresses. The problem with the latter is
> > that addr2line will block waiting for addresses to be passed in via
> > stdin, e.g. if running a selftest from an interactive terminal.

How does this bug occur?  Does backtrace() get inlined?

> > Opportunistically fix up the comment that mentions skipping 3 frames
> > since only 2 are skipped in the code.
> >
> > Cc: Vipin Sharma <vipinsh@google.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/assert.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
> > index 71ade6100fd3..c1ce54a41eca 100644
> > --- a/tools/testing/selftests/kvm/lib/assert.c
> > +++ b/tools/testing/selftests/kvm/lib/assert.c
> > @@ -42,12 +42,18 @@ static void test_dump_stack(void)
> >         c = &cmd[0];
> >         c += sprintf(c, "%s", addr2line);
> >         /*
> > -        * Skip the first 3 frames: backtrace, test_dump_stack, and
> > -        * test_assert. We hope that backtrace isn't inlined and the other two
> > -        * we've declared noinline.
> > +        * Skip the first 2 frames, which should be test_dump_stack() and
> > +        * test_assert(); both of which are declared noinline.  Bail if the
> > +        * resulting stack trace would be empty. Otherwise, addr2line will block
> > +        * waiting for addresses to be passed in via stdin.
> >          */
> > +       if (n <= 2) {
> > +               fputs("  (stack trace empty)\n", stderr);
> > +               return;
> > +       }
> 
> Shouldn't this condition be put immediately after
>         n = backtrace(stack,n)

Agreed, that would be more intuitive.
