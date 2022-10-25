Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B60D60D7BE
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 01:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiJYXMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 19:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJYXMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 19:12:41 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D5CD0CDA
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 16:12:41 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f9so8668483pgj.2
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 16:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i3mo0kixZ6m/otsAj6aTciSS2cXGwp+gHcCnQRslUJ0=;
        b=H/u3vlT0BHl5n33n1xBAxGrADDqNOKyPm0FlJRlzico2g/s7/FJs00EyMO3T27/2rq
         QZU392FQBdVkJXFTl4a+/ogmIro5Ycf9FJ9bmT6jGLuwVMuBJR0EcZRJlf8eSmYD6Yow
         0tdpq/OcFr8rGYjzrPY4oISlJVMvAZHdQ2mLKzB5IXLliFHkQU3HeymsjYxCEvyA0za3
         pg0WT+sgkzT1FPNOZy6U0S627ziXqCVpV+iZSg7jtZTsGE2pv+uS+LMR2NYWYAJG5Kvn
         gMyJcb1meZvkc4Sa7726DnsyPTdaeFB1JkCaQ3+ANGGShjOxYh/W+8j41dZhNX8xQvy/
         FnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3mo0kixZ6m/otsAj6aTciSS2cXGwp+gHcCnQRslUJ0=;
        b=pLOJTYVLjNL9sbd2Qef3Uaonf0wTtvVtC0D/kBWQaU2LRox03ydhULfEsnW2CeJZVL
         hPAszL5OuEU56PhLdC6sRfdj3uQJEynnC7aGd10g8bO2ukZxOc4i4Lx+eccmwOrxv9zJ
         IR+OIU6L8NQ/L1rb2Ld+AHXFnDE2AHdCWYwvvXw2bsFEjTLuImnOz5W++P6y8KkUCu0L
         z6w7RRB8bgYAslrsbCAL5WS0Lkni5ze49PVcjNMYqotD80+r5sVDFDYvEdk6j9dKsbuk
         Llgr8OZql7xr34NK3hTt1lviQvuAGXKVJno1AGDTet36sk6PYao0zzTL6dlakTlB/8Jt
         N54g==
X-Gm-Message-State: ACrzQf0kQRMbHtOerjCz4HTyx2dMIGKuME8GDwVZc+Hd02CHPTONAQGq
        v87tGJCwxSaG9Je3j3z4uXStbBt/U3zWmw==
X-Google-Smtp-Source: AMsMyM4POv5qWsf+eLt5JF3Vn/9Av/I9JrLqVs9TwuMtX9R/daO2F/YmHC4mwWxysO2D2LtqtXkazw==
X-Received: by 2002:a05:6a00:98b:b0:56b:d312:232e with SMTP id u11-20020a056a00098b00b0056bd312232emr12570371pfg.45.1666739560489;
        Tue, 25 Oct 2022 16:12:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903404d00b00186b9196cbesm1670061pla.249.2022.10.25.16.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 16:12:40 -0700 (PDT)
Date:   Tue, 25 Oct 2022 23:12:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Bill Wendling <isanbard@gmail.com>
Subject: Re: [PATCH] x86/pmu: Disable inlining of measure()
Message-ID: <Y1htZKmRt/+WXhIo@google.com>
References: <20220601163012.3404212-1-morbo@google.com>
 <CALMp9eRgbc624bWe6wcTqpSsdEdnj+Q_xE8L21EdCZmQXBQPsw@mail.gmail.com>
 <CAGG=3QX218AyDM6LS8oe2-PH=eq=hBf5JrGedzb48DavE-5PPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QX218AyDM6LS8oe2-PH=eq=hBf5JrGedzb48DavE-5PPA@mail.gmail.com>
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

On Tue, Oct 25, 2022, Bill Wendling wrote:
> On Wed, Jun 1, 2022 at 10:22 AM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Wed, Jun 1, 2022 at 9:30 AM Bill Wendling <morbo@google.com> wrote:
> > >
> > > From: Bill Wendling <isanbard@gmail.com>
> > >
> > > Clang can be more aggressive at inlining than GCC and will fully inline
> > > calls to measure(). This can mess with the counter overflow check. To
> > > set up the PMC overflow, check_counter_overflow() first records the
> > > number of instructions retired in an invocation of measure() and checks
> > > to see that subsequent calls to measure() retire the same number of
> > > instructions. If inlining occurs, those numbers can be different and the
> > > overflow test fails.
> > >
> > >   FAIL: overflow: cntr-0
> > >   PASS: overflow: status-0
> > >   PASS: overflow: status clear-0
> > >   PASS: overflow: irq-0
> > >   FAIL: overflow: cntr-1
> > >   PASS: overflow: status-1
> > >   PASS: overflow: status clear-1
> > >   PASS: overflow: irq-1
> > >   FAIL: overflow: cntr-2
> > >   PASS: overflow: status-2
> > >   PASS: overflow: status clear-2
> > >   PASS: overflow: irq-2
> > >   FAIL: overflow: cntr-3
> > >   PASS: overflow: status-3
> > >   PASS: overflow: status clear-3
> > >   PASS: overflow: irq-3
> > >
> > > Disabling inlining of measure() keeps the assumption that all calls to
> > > measure() retire the same number of instructions.
> > >
> > > Cc: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Bill Wendling <morbo@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> Bumping for visibility.

Heh, make sure kvm-unit-tests is in the subject, i.e. [kvm-unit-tests PATCH].
This slipped by on my end because I didn't realize at a quick glance that it was
touching KVM-unit-tests and not kernel code.
