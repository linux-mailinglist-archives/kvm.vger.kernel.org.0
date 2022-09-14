Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0485B8EDB
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 20:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiINSZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 14:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiINSZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 14:25:14 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7844D2B181
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:25:13 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1225219ee46so43328489fac.2
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=q71i9knIehKxFrXSNKEJylvVFNdxOdO2KjImDYesNjk=;
        b=YadMSDP6HIXBk8vnow0zVS9H6xK7ey/QKbzqwGUlF+97LyAI/1bzBiuR2FIxEy5A1g
         xrONcaNEeBbfBUe/o0d4r2tMSF5G05mszWksnedu2tUEL7+qw1U7Fu1yIWbkojb7HxTY
         DTuur2/s5XxTwTJdXRWvadmD4s13JoIBt2g/Dif3VCQM8E77PIEsaMlbAZtUvBHZ+HpK
         PeX2yHMRv8f9g8OFolL6Ust37eJ1mPlp4yYYl/l7m9CdqRZP8omY3R8JSnxY1cnRYShc
         sbVG7fMXCQImQ8qEJ6iusPO/muqPOPfB4ygzbmBqsfxPbkTYtPOmRoox9UQNQSC8SWoi
         NIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=q71i9knIehKxFrXSNKEJylvVFNdxOdO2KjImDYesNjk=;
        b=wMAe0KW1HpNCmlQjvhdyatZmWpxoxCi94xue7iXEMzyrDCXZvTkPz1VphH1ZpRy6ol
         G3Xtv+hpnrOr3L8rrdhcf2ejQ68bR7Gx5rsTScBU0R5h+ZAQHdh8Lou7B5MTcapoKKRl
         6JCXPz3ZjAyUBT13VThiCD7EyfAN0GL0jBuKloZC2/Ar0NonN8fPnzGMJi2j2oJEgOJt
         G3+17F2bteF6Cfm9uKXUCFpW3SpwyYJ/nKzo8tJm1YnjYigky6JFWPN5HxOmW3dlXbXs
         QAJyUHv6HbRot+c/PCYmWgsD46mRONYzdEbGvWK0Wg+VUGS6l8XkD9UUrTHA+9b3wJNp
         yKOg==
X-Gm-Message-State: ACgBeo1QF1qnJdKQl4RXVJoCw/wjX/Rta9446hsdvIpC6zvh3JSrWM4a
        XaLSna9QOBqjEOTPPsO+2KK/V9XnUiq0KezjuGfaNA==
X-Google-Smtp-Source: AA6agR5d7sJpWfAMTa5xbtOSOfTfAsdjHD3+69Y2BrBhPdI1/9pYoRiU/J/or6Daw1Pvedm12R8oFz5isbMza7387Yo=
X-Received: by 2002:a05:6870:a78e:b0:12b:542b:e5b2 with SMTP id
 x14-20020a056870a78e00b0012b542be5b2mr3104287oao.112.1663179912513; Wed, 14
 Sep 2022 11:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com> <20220831162124.947028-4-aaronlewis@google.com>
In-Reply-To: <20220831162124.947028-4-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 11:25:01 -0700
Message-ID: <CALMp9eTjVEcay1hYLys=dR5pO+Huhmpr8JjpiEmdng3zp7_5tg@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] kvm: x86/pmu: prepare the pmu event filter for
 masked events
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 9:21 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Create an internal representation for filter events to abstract the
> events userspace uses from the events the kernel uses.  That will allow
> the kernel to use a common event and a common code path between the
> different types of filter events used in userspace once masked events
> are introduced.
>
> No functional changes intended
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/pmu.c | 118 ++++++++++++++++++++++++++++++++-------------
>  arch/x86/kvm/pmu.h |  16 ++++++
>  2 files changed, 100 insertions(+), 34 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index e7d94e6b7f28..50a36cc5bfd0 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -239,6 +239,19 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>         return true;
>  }
>
> +static inline u16 get_event_select(u64 eventsel)
> +{
> +       u64 e = eventsel &
> +               static_call(kvm_x86_pmu_get_eventsel_event_mask)();
> +
> +       return (e & ARCH_PERFMON_EVENTSEL_EVENT) | ((e >> 24) & 0xF00ULL);
> +}
> +
> +static inline u8 get_unit_mask(u64 eventsel)
> +{
> +       return (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> +}
> +
>  static int cmp_u64(const void *pa, const void *pb)
>  {
>         u64 a = *(u64 *)pa;
> @@ -247,53 +260,63 @@ static int cmp_u64(const void *pa, const void *pb)
>         return (a > b) - (a < b);
>  }
>
> -static inline u64 get_event_select(u64 eventsel)
> +static u64 *find_filter_entry(struct kvm_pmu_event_filter *filter, u64 key)
> +{
> +       return bsearch(&key, filter->events, filter->nevents,
> +                         sizeof(filter->events[0]), cmp_u64);
> +}
> +
> +static bool filter_contains_match(struct kvm_pmu_event_filter *filter,
> +                                 u64 eventsel)
> +{
> +       u16 event_select = get_event_select(eventsel);
> +       u8 unit_mask = get_unit_mask(eventsel);
> +       u64 key;
> +
> +       key = KVM_PMU_ENCODE_FILTER_ENTRY(event_select, unit_mask);
> +       if (find_filter_entry(filter, key))
> +               return true;
> +       return false;

Perhaps just:
        return find_filter_entry(filter, key);

Reviewed-by: Jim Mattson <jmattson@google.com>
