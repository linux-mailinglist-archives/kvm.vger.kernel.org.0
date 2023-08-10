Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F134B77817B
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 21:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbjHJTZz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Aug 2023 15:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjHJTZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 15:25:53 -0400
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE8D8E;
        Thu, 10 Aug 2023 12:25:53 -0700 (PDT)
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-56d75fb64a6so250985eaf.0;
        Thu, 10 Aug 2023 12:25:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691695552; x=1692300352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9aw8ml9S42yayFsNX9J8Gl5QyxONrFNazFikw4Q0CI=;
        b=Dsj8ksJbbMophrxmQYDNNQ8rcPhINO+Q4UKIWDNs+NrgE6ZpxQMXS+9ahp/nF+KL11
         9ZCpxfIddqpJ0kB42faISXAkwJIyMuKumbsYbsVgdvycctg5S6E+JLYDwRcIe26do5yo
         N2AAJUBLY5Y1tqxys1KHXAAdtpqgE+DW8Un7ybINzgSu7kw1f0+DW/Sh+h1oktbXVcG3
         0HRwdmi7mOQGbCNL2UYyuR47hxAMdpatbjuKktLQJxcDrQheKbsd0j6521DNerTkxTSI
         J2FoZ3DVcE/MLrbQWxQbMVs53/SHF8cDfzylqRyGiqr/q3zQr/Q6pstlCopk9Bd8VoGq
         V0Tw==
X-Gm-Message-State: AOJu0YzAb+Sda/ojG+OQIR0SEgIoZJn/iswVV4oifb4ntPJAVmhRd5dv
        RN7ARXh4psF+f8Shpvm67OVyqPNNzMdm294v/fM=
X-Google-Smtp-Source: AGHT+IG2cm+yFBL6Gm3PnOc7PilM+sSgiisdu+I91RIoQacBMk/bvXnaHA/3Jxc2YgdvNNng7jFFfyELmldrjhSwdc8=
X-Received: by 2002:a4a:de86:0:b0:560:b01a:653d with SMTP id
 v6-20020a4ade86000000b00560b01a653dmr2736487oou.0.1691695552381; Thu, 10 Aug
 2023 12:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com> <1691581193-8416-5-git-send-email-mihai.carabas@oracle.com>
In-Reply-To: <1691581193-8416-5-git-send-email-mihai.carabas@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Aug 2023 21:25:41 +0200
Message-ID: <CAJZ5v0jB0Vk_JTxi026PmQfOSKoTxdQn+veHqTQKhbdffbMrdw@mail.gmail.com>
Subject: Re: [PATCH 4/7] governors/haltpoll: Drop kvm_para_available() check
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

On Wed, Aug 9, 2023 at 2:54 PM Mihai Carabas <mihai.carabas@oracle.com> wrote:
>
> From: Joao Martins <joao.m.martins@oracle.com>
>
> This is duplicated already in the haltpoll idle driver,
> and there's no need to re-check KVM guest availability in
> the governor.
>
> Either guests uses the module which explicitly selects this
> governor, and given that it has the lowest rating of all governors
> (menu=20,teo=19,ladder=10/25,haltpoll=9) means that unless it's
> the only one compiled in, it won't be selected.
>
> Dropping such check also allows to test haltpoll in baremetal.

Fair enough.

> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>  drivers/cpuidle/governors/haltpoll.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
> index 1dff3a52917d..c9b69651d377 100644
> --- a/drivers/cpuidle/governors/haltpoll.c
> +++ b/drivers/cpuidle/governors/haltpoll.c
> @@ -143,10 +143,7 @@ static int haltpoll_enable_device(struct cpuidle_driver *drv,
>
>  static int __init init_haltpoll(void)
>  {
> -       if (kvm_para_available())
> -               return cpuidle_register_governor(&haltpoll_governor);
> -
> -       return 0;
> +       return cpuidle_register_governor(&haltpoll_governor);
>  }
>
>  postcore_initcall(init_haltpoll);
> --
> 1.8.3.1
>
