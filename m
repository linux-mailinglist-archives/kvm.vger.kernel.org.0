Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D96560D4A4
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 21:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiJYTXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 15:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJYTXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 15:23:03 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCDEB3B05
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 12:23:02 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bj12so15200082ejb.13
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 12:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ROtwCRewKiP3rabVgxjCbzMqDpz7AcDsP/4IX2sTzCg=;
        b=l6jNcA6gHspkLOQkp87i8koPMCNd7/lRBHxXJPnVbRvRoHfkD6ygl4j2Kt9ZUSkl1u
         0VwNep+473rN1jS1fWKwZrgNbTXkr4QzpJ4T+SlKJST9ZtgAN30LfABWS7XK0QSLM6LR
         sZ+jr3pByWZjegCUlntHdu6DZ8QJFQoZk1Z94KghptePISOSaVuc9otCf4GJWbza6fYM
         FB/1857h1/ZIRn6mWoW2bxKA+oTme7AMKiQJ8Qoeab45iUeH71H0+GM2J5zUOb2X3H3n
         kSSkLYY6Trfi3V64z4XcNSqm9bSNGR54iVEQ6cjR0UDy7I5kSaekn6tzlTGUi+nXr4Uf
         M57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ROtwCRewKiP3rabVgxjCbzMqDpz7AcDsP/4IX2sTzCg=;
        b=Kiij+QI+tDxK8Lq0W98j1LP68i7/9ZbbLLMST2wU8fhLKvswE3NOToam3skWXQytiW
         R10PQoM/2ld8CDjHv94cf4Z/dUccje+75n7RBhPJy9UqQ3L9lU6PlR+9auKbyJsaW31d
         vVsSraDMSiiT8R7pWqPVvwGWOb248gpIO8j1/X8xjvsFmBmpiEhwGBRIPSOTqsnCnHER
         nwRhC5zuWZT82k/glDsJ5r7uotj1Cz+ihr1nRGIEtYZ/8SQroP/z/VqqvUbqzq0p+Z3N
         CYXWk2Lg1mARbjXW2nUFdep+9nPJbvh5TXy0EvfNw4Xp36nw35XWy1p2TlzuhGhR1+gf
         1+Gw==
X-Gm-Message-State: ACrzQf0yxpRA7x5sb6MJAjbIAVyveI6p8P0SCjtLc4LeTotQ+I3JhxYI
        5Yh6JY6/Q2Pvmflf3Rr2kvdTTc6N4ebDCcE3xYzz
X-Google-Smtp-Source: AMsMyM6rGCUtNfrnmgK0VsUu0Lt4DxCMAQrW+M+iqVNJf/NLj5UBWntwLlhhpnRnvVOcbq60HaXjID4g3XpYnucXSRw=
X-Received: by 2002:a17:907:94c6:b0:796:f9ed:ceb3 with SMTP id
 dn6-20020a17090794c600b00796f9edceb3mr26782358ejc.197.1666725780977; Tue, 25
 Oct 2022 12:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220601163012.3404212-1-morbo@google.com> <CALMp9eRgbc624bWe6wcTqpSsdEdnj+Q_xE8L21EdCZmQXBQPsw@mail.gmail.com>
In-Reply-To: <CALMp9eRgbc624bWe6wcTqpSsdEdnj+Q_xE8L21EdCZmQXBQPsw@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 25 Oct 2022 12:22:44 -0700
Message-ID: <CAGG=3QX218AyDM6LS8oe2-PH=eq=hBf5JrGedzb48DavE-5PPA@mail.gmail.com>
Subject: Re: [PATCH] x86/pmu: Disable inlining of measure()
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Bill Wendling <isanbard@gmail.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jun 1, 2022 at 10:22 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Jun 1, 2022 at 9:30 AM Bill Wendling <morbo@google.com> wrote:
> >
> > From: Bill Wendling <isanbard@gmail.com>
> >
> > Clang can be more aggressive at inlining than GCC and will fully inline
> > calls to measure(). This can mess with the counter overflow check. To
> > set up the PMC overflow, check_counter_overflow() first records the
> > number of instructions retired in an invocation of measure() and checks
> > to see that subsequent calls to measure() retire the same number of
> > instructions. If inlining occurs, those numbers can be different and the
> > overflow test fails.
> >
> >   FAIL: overflow: cntr-0
> >   PASS: overflow: status-0
> >   PASS: overflow: status clear-0
> >   PASS: overflow: irq-0
> >   FAIL: overflow: cntr-1
> >   PASS: overflow: status-1
> >   PASS: overflow: status clear-1
> >   PASS: overflow: irq-1
> >   FAIL: overflow: cntr-2
> >   PASS: overflow: status-2
> >   PASS: overflow: status clear-2
> >   PASS: overflow: irq-2
> >   FAIL: overflow: cntr-3
> >   PASS: overflow: status-3
> >   PASS: overflow: status clear-3
> >   PASS: overflow: irq-3
> >
> > Disabling inlining of measure() keeps the assumption that all calls to
> > measure() retire the same number of instructions.
> >
> > Cc: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Bill Wendling <morbo@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Bumping for visibility.

-bw
