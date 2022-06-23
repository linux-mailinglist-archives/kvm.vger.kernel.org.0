Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF9557A5D
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 14:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiFWMbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 08:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiFWMa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 08:30:59 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1BA41F87
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:30:58 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3137316bb69so192049637b3.10
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4FAaAxDkft/GYKrZH8p1e5O8Z/g+GpcmXs91Mv5s28=;
        b=w/PZidQ07LR5n2YGfOx4cK5vDAtot3ycJ9M2vvnvf/oz5ZzRvdaWSE+BXZ7jBdESwQ
         nmeqNxjz8XVaem0TXV8wZO+8wR3PN0WwfA97V3e//IHNwjVyXW7ASm71/Gjxa94C5wbc
         dC6kr0uvE6l1jO73LuFVv7vB7rrGjzVowPS9o0cwFTBg3ynaZ51CTt37XY3WqCchNQzf
         npTyXNGPxP7wSQUdDtxXdFIEeGQgdOQkVPtrLeqdwndaaJBGrKrEFavDLy7KvmhofpTH
         1OpH+ApP6ejgyZoP9UzJTaMqofMlGZoMEIG7iL9LPpmLqpgZDWmCQ7MCx6rkmtWhXDXq
         dGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4FAaAxDkft/GYKrZH8p1e5O8Z/g+GpcmXs91Mv5s28=;
        b=ageH7RPxMCQBk4mAsNx7CZUNcaXGO9aaaqvHeaReHsuv1bNjnwea9/ae64WGk2wn5k
         EH47fG0/Fh43Qjc+M8Rc9MpRcHaC97IjDs6iKwY1l+xxAamwIFNYvoLIXoT7CmyApNKh
         3trBM5gJzfZJ+Y+BoEvWXYNLXZiV8qpfEFmIsFDvmkoL5l74snQJn2kYd9iHpW9mQ9MN
         cbQgQFiTVH5Abi5r8l+Vxgg4hPHnSH4yEIi6YH5OhcsXw6w6lgIwwngOKXWx/JjmuirI
         Y0YAWpVHvtWK1xJmti9nl9JLsR2/ogdSUB5HYB3sxAcF1dcMQF0Ue7NLCTOVrRkYCQWv
         9dkw==
X-Gm-Message-State: AJIora9c0hSiJefxGhnWF2Q8Hpgb8FMQNmD1WEJzism6xrBmfcydcfP2
        VsipDMg0GdniEhr2KtkgwyD6lFWO5y/axyAf3LUOuQ==
X-Google-Smtp-Source: AGRyM1vy9K/iFLl5trhp+WIivaF6gz7O/mzMR28cDbyBiwMAjJBEksTqDzrSIrfDMZqHbUruV7+BTzJY5o4dIPToknY=
X-Received: by 2002:a0d:ca0f:0:b0:317:a2cc:aa2 with SMTP id
 m15-20020a0dca0f000000b00317a2cc0aa2mr10658496ywd.347.1655987457511; Thu, 23
 Jun 2022 05:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220623095825.2038562-1-pdel@fb.com> <20220623095825.2038562-7-pdel@fb.com>
In-Reply-To: <20220623095825.2038562-7-pdel@fb.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 23 Jun 2022 13:30:46 +0100
Message-ID: <CAFEAcA-F59JEVBVYSdGX4KcS5d+EB4dNoZ2iE1aitSvo3B7Yfw@mail.gmail.com>
Subject: Re: [PATCH 06/14] aspeed: Add system-memory QOM link to SoC
To:     Peter Delevoryas <pdel@fb.com>
Cc:     clg@kaod.org, andrew@aj.id.au, joel@jms.id.au, pbonzini@redhat.com,
        berrange@redhat.com, eduardo@habkost.net,
        marcel.apfelbaum@gmail.com, richard.henderson@linaro.org,
        f4bug@amsat.org, ani@anisinha.ca, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jun 2022 at 12:31, Peter Delevoryas <pdel@fb.com> wrote:
>
> Right now it's just defined as the regular global system memory. If we
> migrate all the SoC code to use this property instead of directly calling
> get_system_memory(), then we can restrict the memory container for the SoC,
> which will be useful for multi-SoC machines.
>
> Signed-off-by: Peter Delevoryas <pdel@fb.com>

>  static Property aspeed_soc_properties[] = {
> +    DEFINE_PROP_LINK("system-memory", AspeedSoCState, system_memory,
> +                     TYPE_MEMORY_REGION, MemoryRegion *),

To the extent that we have a convention, we tend to call this
property on an SoC or CPU "memory", I think. (Better suggestions
welcome...)

-- PMM
