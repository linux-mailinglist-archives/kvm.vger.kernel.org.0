Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA38860E6EC
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 20:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiJZSCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 14:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiJZSCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 14:02:37 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F6AA0333
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 11:02:36 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id t26so7771142uaj.9
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hqXoWCvNjrq1UqWjaa40wlpVBb3QIw0PR/zNAYeTPwk=;
        b=OOzG5ne28YQ1n9zP40aKeOFgEuMvmc09/P3vbBBcOUs1255+xTRN7eESHn9xPdcb6j
         Dz1NIgEy6hOmCJR2SDycFCc4KSIlTI3UFkKrsXxT7K8S+PP5J3/1+9u80KjpFZC1UI5+
         fCyfa7pw2rlBLj0tYWv6pGMFWG1JNNjBcWgrJ3lGL2TVz24hP1cCHGUfiha48oBWsaws
         BKCFVr8jelIxUNmjYfW3DMXjmcQEjATpbDcEGBZCB05183WHrJmPHnXuObMcnyq9g5WO
         W7kloADthMGe+RRp3yxQcL+CeRsyZO6xra7MLtFTE+RBbu8TC9REh0Vl9goLxUOHyVAm
         Uxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hqXoWCvNjrq1UqWjaa40wlpVBb3QIw0PR/zNAYeTPwk=;
        b=YamiMDztwP+qzmt8pberFvWfp0qOet/s4s6zbxnm9EbJANCu0BFwthRUQ8deOh4/uz
         BrsuyHidYXKbaynWK4O1qyuuUEKNbaBfq5hziXNZ/QapwDGlaynsryko5/lrku74AfF3
         FDAKnBm6AXHBPOrT64/4+f4xrIE7AYf+ebXcKuyww4I0541UnQoW3XUfLzjm9go8veGh
         nkVF++bNkAxnyYAA9uzHrgUXUUdVO6eu6HoAg78bci+tbXs26aJkc/NVQXazG4xHpz2f
         XtYnAwyXI5kJjsYvQqpk1fQ4e0iYyfaV8ssRerrZXsVUjyUXBC3c+vGmqVhj09H6VKk4
         3CSQ==
X-Gm-Message-State: ACrzQf2ZznR95OBWjuF+ub+XTl713n2dxrz2fw6Mef9PrlO0R5mItXtR
        LmjMFejTon2VP6R92WLCGMfBn67rjddpSdOoH8c=
X-Google-Smtp-Source: AMsMyM6m3IPibIuEdgZq6OB9RY8co71udk+kglmo42hFh8QSZN6WbC2w9Q7c3I/hwzW1IdibUDDYmjYidg83fxpWyrc=
X-Received: by 2002:ab0:6451:0:b0:3b8:7f95:f20e with SMTP id
 j17-20020ab06451000000b003b87f95f20emr26283444uap.31.1666807355899; Wed, 26
 Oct 2022 11:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220601163012.3404212-1-morbo@google.com> <CALMp9eRgbc624bWe6wcTqpSsdEdnj+Q_xE8L21EdCZmQXBQPsw@mail.gmail.com>
 <CAGG=3QX218AyDM6LS8oe2-PH=eq=hBf5JrGedzb48DavE-5PPA@mail.gmail.com> <Y1htZKmRt/+WXhIo@google.com>
In-Reply-To: <Y1htZKmRt/+WXhIo@google.com>
From:   Bill Wendling <isanbard@gmail.com>
Date:   Wed, 26 Oct 2022 11:02:25 -0700
Message-ID: <CAEzuVAetwLSaP2gt00Y0i0xdrj59TVT9ngB1iHXOa-mZ1fOqAA@mail.gmail.com>
Subject: [kvm-unit-tests PATCH] x86/pmu: Disable inlining of measure()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Bill Wendling <morbo@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022 at 4:12 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Oct 25, 2022, Bill Wendling wrote:
> > On Wed, Jun 1, 2022 at 10:22 AM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Wed, Jun 1, 2022 at 9:30 AM Bill Wendling <morbo@google.com> wrote:
> > > >
> > > > From: Bill Wendling <isanbard@gmail.com>
> > > >
> > > > Clang can be more aggressive at inlining than GCC and will fully inline
> > > > calls to measure(). This can mess with the counter overflow check. To
> > > > set up the PMC overflow, check_counter_overflow() first records the
> > > > number of instructions retired in an invocation of measure() and checks
> > > > to see that subsequent calls to measure() retire the same number of
> > > > instructions. If inlining occurs, those numbers can be different and the
> > > > overflow test fails.
> > > >
> > > >   FAIL: overflow: cntr-0
> > > >   PASS: overflow: status-0
> > > >   PASS: overflow: status clear-0
> > > >   PASS: overflow: irq-0
> > > >   FAIL: overflow: cntr-1
> > > >   PASS: overflow: status-1
> > > >   PASS: overflow: status clear-1
> > > >   PASS: overflow: irq-1
> > > >   FAIL: overflow: cntr-2
> > > >   PASS: overflow: status-2
> > > >   PASS: overflow: status clear-2
> > > >   PASS: overflow: irq-2
> > > >   FAIL: overflow: cntr-3
> > > >   PASS: overflow: status-3
> > > >   PASS: overflow: status clear-3
> > > >   PASS: overflow: irq-3
> > > >
> > > > Disabling inlining of measure() keeps the assumption that all calls to
> > > > measure() retire the same number of instructions.
> > > >
> > > > Cc: Jim Mattson <jmattson@google.com>
> > > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> >
> > Bumping for visibility.
>
> Heh, make sure kvm-unit-tests is in the subject, i.e. [kvm-unit-tests PATCH].
> This slipped by on my end because I didn't realize at a quick glance that it was
> touching KVM-unit-tests and not kernel code.

Doh! I'm not sure why I forgot that. Added. Thanks. :)

-bw
