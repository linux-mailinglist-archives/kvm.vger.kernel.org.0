Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E48C59CC95
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 01:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbiHVXzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 19:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiHVXza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 19:55:30 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDBE51A23
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 16:55:29 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w29so6316281pfj.3
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 16:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=DFTMwRMyUNoCzrFPNgv8ys2sausHJWIL+AVipPkABmQ=;
        b=pPXvEGUI2VVm2HNlQxfpHcnrXYcJgzeHJTf7JpKE/wdALSKlCu9YYcVhUAGsfZpScZ
         i9iP794rArn60DEO4jMtrdrUcMErGSJM446/bWhL9vi7A/UwlCkwKludVGEnXrzO87r1
         Co+7SrNFnTykekPmtGF5ZBQpC5L6GhdFwFm8aorbXnpf2EGs/l0sK2ylX/3ZXJ6gipny
         GeMoEkhxWLFEyf0Y/UvfVwCgYm4YjNYHAfsssXUXoZJpgwDp9oG/LYzLujlxpXsrvVnA
         s6bmtvrGo/bEdeoQZH/kWe28TF7znSGb1rwZCpVe/nIPI6GLm1L0/XsaGAbeW0wfwbhf
         hFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=DFTMwRMyUNoCzrFPNgv8ys2sausHJWIL+AVipPkABmQ=;
        b=1jag0NIYdEy/ogm4k2/NnYQq6tAWgPJ+S3OqeyudhifJeQWeHsqqnDzRIJ2tom9/Rv
         8V+e3YAfxmvAnzDHfKUzrY/2Z0lyy/QljJfdo8lVE9wUbsfQYT2s+9JuTrj3ER7M8nKU
         v5YkHN1L9nt1eN2nN5qD4tRFru+G35GEom5z9YRlMWWZvbnVdT7RCwThJUa3xnFTuky+
         ohTuZ5CeJlqZEk06jFLaQmtXRrnEzP6n1mZd8HjoRlr1RcU7J34tETOolCgplyXpzavy
         RqDX6YGtTWD+IdIaYQEJPuo4wgTOHbEWGdgrbuGQlQFcEbn72/4PnhNELoTPKlrXQKml
         O6zQ==
X-Gm-Message-State: ACgBeo0S5Xy00fbOElSvk8eKuSGj/VQaTxW/ro8/kbcmTC7VHZUXoXEa
        5sOMvIfFdymjyTKAvGxDYIR5CmtHHml6L+Xj0ta+oQ==
X-Google-Smtp-Source: AA6agR5XWgTreuL6vUHoqkUxeJovrT87P7dSwSTMZGZnrNAYhvm5I/5xf+Upjjd90DSd7Zt9KHx/GtqIBhIbJzerO6E=
X-Received: by 2002:a65:5941:0:b0:41d:a203:c043 with SMTP id
 g1-20020a655941000000b0041da203c043mr18451145pgu.483.1661212528790; Mon, 22
 Aug 2022 16:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com> <20220810152033.946942-11-pgonda@google.com>
 <CAGtprH-emXA_5dwwdb4noOC-cuy3BTGT8UbKRkPD8j2gjBSu+Q@mail.gmail.com> <Yv/mcxPsJGZYV2tU@google.com>
In-Reply-To: <Yv/mcxPsJGZYV2tU@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Mon, 22 Aug 2022 16:55:17 -0700
Message-ID: <CAGtprH9yKvuaF5yruh3BupQe4BxDGiBQk3ExtY2m39yP-tppsg@mail.gmail.com>
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 12:37 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 19, 2022, Vishal Annapurve wrote:
> > On Wed, Aug 10, 2022 at 8:20 AM Peter Gonda <pgonda@google.com> wrote:
> > >  void ucall(uint64_t cmd, int nargs, ...)
> > >  {
> > > -       struct ucall uc = {};
> > > +       struct ucall *uc;
> > > +       struct ucall tmp = {};
> >
> > This steps seems to result in generating instructions that need SSE
> > support on x86:
> > struct ucall tmp = {};
> >    movaps %xmm0,0x20(%rsp)
> >    movaps %xmm0,0x30(%rsp)
> >    movaps %xmm0,0x40(%rsp)
> >    movaps %xmm0,0x50(%rsp)
> >
> > This initialization will need proper compilation flags to generate
> > instructions according to VM configuration.
>
> Can you be more specific as to why generating SSE instructiions is problematic?
> The compiler emitting fancy instructions for struct initialization is not out of
> the ordinary.

When executing these instructions, I was hitting #GP in the guest VM.
CR4/CPUID settings seem to allow a VM to execute instructions that
need SSE support enabled (which I was doubting earlier). After some
more digging, it looks like the compiler is not able to ensure that
operands for such instructions are 16 byte aligned as required by the
hardware. There is a bug discussing this same issue:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=40838.

Adding -mstackrealign seems to help avoid running into #GP and things
seem to work normally. Though I am not sure if SSE instruction
execution is reliable from guest VM within selftests and so was
suggesting usage of "-mno-sse" or equivalent flags.
