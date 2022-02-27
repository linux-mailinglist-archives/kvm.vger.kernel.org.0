Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8934C5949
	for <lists+kvm@lfdr.de>; Sun, 27 Feb 2022 05:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiB0EzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Feb 2022 23:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiB0EzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Feb 2022 23:55:16 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23045230
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 20:54:41 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c18-20020a7bc852000000b003806ce86c6dso3940040wml.5
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 20:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eI+mKvUVdsWWy2tojyl37gSGkcPXsm07X7D/cSqPS50=;
        b=X7ywlX7XMPA+uT2M6kuTLGQR25WOU6W0+VGx2aqQ6ln4EqQeCeYl6/B7mStQa1ejV+
         qGtJ0Ypo5Td54JvizzgiIHfHZxa0V7RBuByNkwQOg21UEZv+gFWjl0V+TKOAweWwnIfy
         fZGqRETCrhcFLwXp5zAyngauRxDl4FOWBoaqGpPJjNgWhi3fzKUKTEOJXEDZ5PTSVsFo
         VYfNjYiZcyU3PmJMxJ870W40tjiY9jo2B9WhVF6eRSJPvB4lHGzcFcF2TKZlQRRqvayR
         /7Crejg2DSi0vc3s6feACNiwCpb1oAsdvbatcr1T67Esvz3R5YE9sJOc4nmBIV0GnZ0h
         4ptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eI+mKvUVdsWWy2tojyl37gSGkcPXsm07X7D/cSqPS50=;
        b=XvQ7+J9IGi4u78w7eU9icLTQVBitLFGSLPxQ1f92F9GN0aFV2p6EKdkjNiBw1BPP/u
         5hSLgIkFT2kv310bs/+XPSOQCm000rDmXO7olUJHmz4U49AhgOidiDg51VqwdLv42g3U
         AdCLLauiV9c+qKCyqa0C8Kxx/XWPpQSoaqtnrXNXp45oZfOhZA0CvLfMXO6PrqD7HtLm
         8CBAfBo6qjS1bjGwh3OCJkP7vhCVZEwmy1FYCEYd/DrDFx80muw8rRgq7BKJoLi/Kese
         rzn72ODGMt4ZGPNybLc0Ebo/SDBzEl130nMClfVrPsfZfGOZMhXxanRmUOJSvvAnrNdT
         vpAQ==
X-Gm-Message-State: AOAM533sx8AkZwCcmT6sHbGR1DiSPbv85pvDKk2XTrpfswneBVEYjj+b
        Xh1U+tncsoTQYQ4eT9smyl+sIQJvVTeGwklDVP+rWpOIT90=
X-Google-Smtp-Source: ABdhPJwCEJ3edh7rdo5d2GIzPlQX6DqR00iw3wccLMhLvHowiPOgIK7w+lfrD+dXYSpy5DYhZxqNZdD8YK8m2ItlDMo=
X-Received: by 2002:a05:600c:a51:b0:381:3dc6:c724 with SMTP id
 c17-20020a05600c0a5100b003813dc6c724mr7186982wmq.106.1645937679184; Sat, 26
 Feb 2022 20:54:39 -0800 (PST)
MIME-Version: 1.0
References: <20220226234131.2167175-1-jmattson@google.com>
In-Reply-To: <20220226234131.2167175-1-jmattson@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Sat, 26 Feb 2022 20:54:28 -0800
Message-ID: <CABOYuva10sQbxkLPQax7egLyq2Ho-fFS0Xp7XR18NN=e-VOjNQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Lotus Fenn <lotusf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FROM_FMBLA_NEWDOM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: David Dunn <daviddunn@google.com>

On Sat, Feb 26, 2022 at 3:41 PM Jim Mattson <jmattson@google.com> wrote:

> +               data &= ~pmu->reserved_bits;
> +               if (data != pmc->eventsel)
>                         reprogram_gp_counter(pmc, data);
> +               return 0;
