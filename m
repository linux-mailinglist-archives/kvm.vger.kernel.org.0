Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376145A1DD9
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 02:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiHZA4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 20:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiHZAz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 20:55:57 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA759C8768
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:55:56 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id cd25so41204uab.8
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Q38MYI/tB7P48jbjK/kQHhk0xFiHLxsSEMIXEv+JO3E=;
        b=G29bWRtyZy9P6r9YlTl70KqH3ggLY3zlQqPBRcoeA0voBFlbmhd47e2ZWvohV8HbdG
         la2Uh74ZC6ob0r7IpH64PykIlZUaaiETr55+qePRw5lhUKFjYOJkCMLNNV31NnjSZTXy
         ZH1e2ErGcLkV/aAIh8ZoeWFyKExq+WlK7Isc+JRypZpraUMCVW9eEltzwXJHqR1a8uNq
         jyVMON3XmMnC570YlQSC+kLGa/PoP6k1mleG70uJLIcnsmej6R8zSv6hNdRmi4cG1iZD
         GZMsumg1aGNIMTkx/WwandlNlYS3El8MacRQTaaRArg+em172gdHXQIoE/ZgVkem1vGY
         oFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Q38MYI/tB7P48jbjK/kQHhk0xFiHLxsSEMIXEv+JO3E=;
        b=H8/LZC7r9wQ3bQOXKYs5GVDELkPwRYg4okM5Mb5zu24a8bK86WhsCikb8D5BIKUf6t
         8qDZKSmqEQ37ejUgUw86vBpCZShhLfqkqC54mArnTZ1AYpEYRUDBJqKukRmFPXV/e7lT
         qFK3zzbsiYUPp4/fQZwSmXtr2qP5d3aPnZfedfH9fuW4o3YyIzDAfFXVjdhwLVWVOvjR
         bq4fQOBfZ/45WdcImIr0NCveqvlJU3aiKuz2D+SVBElZVcOxzjb8Rt89tbKZTMWDYfzY
         ldvl88P8wxXwEvRXX8JaObaeNvHl5crVaWrND7jB1lpnhtT32onHCZZtfS8W1FQYQ67z
         DpCw==
X-Gm-Message-State: ACgBeo2W6vdFwX2o42/GwdthE931E3Vur49g1jlqUWdofgJi6CDCMMDL
        wbRAEDvqTE6phfYKz2aVN1BR/Ht/fUDIK3ZZZdeNZw==
X-Google-Smtp-Source: AA6agR5iIE3/MAgvpYVx+OGJVYtZB1InIPoWCx4I8Hf0SCLJ5xOMM0asaVq4yKS5esiQcKdpRXSN/VWSPQgHu7WnXaI=
X-Received: by 2002:ab0:23c9:0:b0:39b:52f0:810d with SMTP id
 c9-20020ab023c9000000b0039b52f0810dmr2477097uan.46.1661475356000; Thu, 25 Aug
 2022 17:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com> <20220825050846.3418868-5-reijiw@google.com>
 <YwevrW4YrHQQOyew@google.com>
In-Reply-To: <YwevrW4YrHQQOyew@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 25 Aug 2022 17:55:40 -0700
Message-ID: <CAAeT=FxcoKTtzX1SCffQTV=8XdcaU35dpP0YdjWR1G7BuRMBBA@mail.gmail.com>
Subject: Re: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug exceptions
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver,

On Thu, Aug 25, 2022 at 10:22 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:41PM -0700, Reiji Watanabe wrote:
> > Add helpers to enable breakpoint and watchpoint exceptions.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 183ee16acb7d..713c7240b680 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -128,10 +128,20 @@ static void enable_os_lock(void)
> >       GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
> >  }
> >
> > +static void enable_debug_bwp_exception(void)
>
> uber-nit: enable_monitor_debug_exceptions()
>
> (more closely matches the definition of MDSCR_EL1.MDE)

Thank you for the proposal. Sounds better!


> With that:
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thank you for the review!
Reiji
