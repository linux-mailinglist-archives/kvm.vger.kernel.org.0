Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B664A77815C
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 21:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbjHJTWo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Aug 2023 15:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbjHJTWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 15:22:43 -0400
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8CC10D;
        Thu, 10 Aug 2023 12:22:42 -0700 (PDT)
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-563393b63dbso208803eaf.1;
        Thu, 10 Aug 2023 12:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691695362; x=1692300162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V3f/l0R5xil5slGV+XOGNMmiW0lc9Xb/pv7UJWmkgUk=;
        b=jABmPlD+vi2hrLdlLukMK9zt4ZcEgEJY0CI9gLfeIigscq4x7RoroCvb26aawcinSK
         AdILQCQWgtVJ9nlX+uhad+U5rsF1nc38Ou/HSnmtO8tXR5Uz/A8PktXr/Jku9ZYeDDxy
         cqZ9TKKzvP58uox65U328btDMy6mQlSDQO+6iLgBtXjd4R4u1xVF0a46HFfeqyMpZXri
         gDOCDSe8GP5mMyHQ01oBH/+nq92ALUepyj6DNaynkSmAms5/PgIWxJ1jC9Hh7Te4HFWf
         suwXjM/K0tkNQ2pA6EFtLzUnNrIImb1/+EOoD3+aAQFaaNObq1Y/DYD6Dxtgrh1RqWqF
         fsEQ==
X-Gm-Message-State: AOJu0YwnMBmRVaQFmMyXRs6NyhwBydgyXhSc9qAxPAZIAIKpqPxct+2Y
        ZpfzV0aZ7TAMshnUsfelGQG5AqFImg+FEvXJo3A=
X-Google-Smtp-Source: AGHT+IEvqJu69Bm43e9mId2dDkkqRV44o/TlZVy0V8pb/AjZqGTu5tVmVcnXmUBNuRkccMD9B0lc+UIjjAiLGvDZZ/U=
X-Received: by 2002:a4a:d689:0:b0:56c:484a:923d with SMTP id
 i9-20020a4ad689000000b0056c484a923dmr2814522oot.1.1691695362058; Thu, 10 Aug
 2023 12:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com> <1691581193-8416-2-git-send-email-mihai.carabas@oracle.com>
In-Reply-To: <1691581193-8416-2-git-send-email-mihai.carabas@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Aug 2023 21:22:30 +0200
Message-ID: <CAJZ5v0gK2dGPYEMKaKayUGuXpGns-w3V7RBpJwYc3=h-JLDdNg@mail.gmail.com>
Subject: Re: [PATCH 1/7] cpuidle-haltpoll: Make boot_option_idle_override
 check X86 specific
To:     Mihai Carabas <mihai.carabas@oracle.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 9, 2023 at 2:52 PM Mihai Carabas <mihai.carabas@oracle.com> wrote:
>
> From: Joao Martins <joao.m.martins@oracle.com>
>
> In the pursuit of letting it build on ARM let's not include what is x86
> specific.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> ---
>  drivers/cpuidle/cpuidle-haltpoll.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> index e66df22f9695..0ca3c8422eb6 100644
> --- a/drivers/cpuidle/cpuidle-haltpoll.c
> +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -104,9 +104,11 @@ static int __init haltpoll_init(void)
>         int ret;
>         struct cpuidle_driver *drv = &haltpoll_driver;
>
> +#ifdef CONFIG_X86
>         /* Do not load haltpoll if idle= is passed */
>         if (boot_option_idle_override != IDLE_NO_OVERRIDE)
>                 return -ENODEV;
> +#endif

I'm sure that adding this #ifdef to the function body is avoidable.

>         if (!kvm_para_available() || !haltpoll_want())
>                 return -ENODEV;
> --
