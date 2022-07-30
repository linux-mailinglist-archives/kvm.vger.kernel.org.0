Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F926585869
	for <lists+kvm@lfdr.de>; Sat, 30 Jul 2022 06:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiG3EQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jul 2022 00:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiG3EQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jul 2022 00:16:06 -0400
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494C7255BD;
        Fri, 29 Jul 2022 21:16:03 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-31f443e276fso67866417b3.1;
        Fri, 29 Jul 2022 21:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fFgeLGDEXPjOLoUZJYNTF+ABbc7/QLMmmIBC+Ua0eXw=;
        b=mRVQ1C2qSFk38q8RHRGoly5s1xIrOa9l7Ae/vdguNp5Yme5JTZ2fnftV8/Rxp7aFP5
         sA82Agx5h0BETSUyESNj7E3F7TsEfIcdYCEf0nGEm0/H/RTpWDocEpyoeLyG5yjbHjQb
         WfLlgiadDQQx/+7ytlBxecyl2JkImTUx7DKUGjH2K9aFOmzSJ5wEw0jYA2DLVkEiquYD
         cYcx/ngwPEjUw8N847RjlOTSeFvVhNMpKZQOPUTGfGSF2H3wmmMBZUXljZgqJ9QqcT53
         DVfMkLFDZfrPqXzZhAakPZPK4lU62p4nyS/6zgVTU1BY4GMRTK044V5/LxyRiMeYd1d8
         i7xw==
X-Gm-Message-State: ACgBeo1OiycMSEH7ksAP6sME3iXNpiCH9gpOY1/m2iehGmfqa01m57p9
        Gr7WqpjG1bqkWIAI5qTalYIPFcFFwvd2i66K4y4=
X-Google-Smtp-Source: AA6agR5t6rI3A3K9sYbRqGT/vLTbTLQr/bzKrf5x7JfThTPsrmentR3RUNcsQOJ+3Ksbu1oMQT/d1tmHbkGkZvvKWyo=
X-Received: by 2002:a0d:e682:0:b0:322:b5e1:5ed4 with SMTP id
 p124-20020a0de682000000b00322b5e15ed4mr5561178ywe.220.1659154562409; Fri, 29
 Jul 2022 21:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220729084533.54500-1-mailhol.vincent@wanadoo.fr> <YuQdhaUi0ur4l/zb@google.com>
In-Reply-To: <YuQdhaUi0ur4l/zb@google.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 30 Jul 2022 13:15:51 +0900
Message-ID: <CAMZ6RqJUtFDKZj9Wo8EjG3nefwM3RztW00FRwXct-KgFo-HSLw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: do not shadow apic global definition
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat. 30 Jul. 2022 at 02:48, Sean Christopherson <seanjc@google.com> wrote:
> On Fri, Jul 29, 2022, Vincent Mailhol wrote:
> > arch/x86/include/asm/apic.h declares a global variable named `apic'.
> >
> > Many function arguments from arch/x86/kvm/lapic.h also uses the same
> > name and thus shadow the global declaration. For each case of
> > shadowing, rename the function argument from `apic' to `lapic'.
> >
> > This patch silences below -Wshadow warnings:
>
> This is just the tip of the iceberg, nearly every KVM x86 .c file has at least one
> "apic" variable.  arch/x86/kvm/lapic.c alone has nearly 100.  If this were the very
> last step before a kernel-wide (or even KVM-wide) enabling of -Wshadow then maybe
> it would be worth doing, but as it stands IMO it's unnecesary churn.

I would say the opposite: in terms of *volume*, warnings from apic.c
would be the tip of the iceberg and apic.h is the submerged part.

When the warning occurs in a header from the include directory, it
will spam some random files which include such header. This is
annoying when trying to triage W=2 warnings because you get totally
unrelated warning (and W=2 has some useful flags such as
-Wmaybe-uninitialized so there are some insensitive to check it).

My intent is only to silence the headers. I do not really care about
the -Wshadow on *.c files because it is local.

> What I would really love is to not have the global (and exported!) "apic", but
> properly solving that, i.e. not just a rename, would require a significant rework.

I double agree. I would also like to rename the global "apic" but I do
not think this is easily feasible.


Yours sincerely,
Vincent Mailhol
