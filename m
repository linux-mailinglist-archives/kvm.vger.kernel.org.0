Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B2E62B3D6
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 08:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKPHPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 02:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKPHPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 02:15:34 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692622670
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 23:15:33 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 130so15869310pgc.5
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 23:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jyttA9l5U2zfeLkz1BoPbTHDObwZ9U09dDfAmOF59co=;
        b=WFqq62z11REleJUcpbpVLlAz/I8zQKWQ+yMcq6YOPBsK8EeIRNA9fM/ZUz9I4p3IJ0
         C8q7ZZ6YcPejwgXCZeHT8NOcQqHHgth+qZN/42XgLiPLF9g6r2oyYVmdK/pmXqIV5zp5
         oO3TzCZ9K133Y3I1ptdzoqSH85jKM5JxoUXfufR57VP8Qg4tBegBGCSZ0cFl5DuUdy+u
         ii9NfgQVVV/orMxW0MIbmHtairHx9xnJtkFym2hXGxqC4xLPF4tSaZteayNFLdfPsceJ
         e6494BhU3c7sbxuPksbIPSv7e3/nHRbIWk+JhlG+s1twJBWOAvlDtRFsD3VS32+WuS08
         k0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jyttA9l5U2zfeLkz1BoPbTHDObwZ9U09dDfAmOF59co=;
        b=X4Q+zUurDgV21srv32VctK27cMGbFlG7K2k4NLB5w1VtOJu4Wsr6xENWzgp7HbFSGQ
         3Vodu9/ttQqH70MdG97HDmNQKCLvq0TZ2oDGShEVWdHmQqQaD5tiex3/bSpuH6xfDzrp
         4RBDdNzzy25GXArfFlOk9FQsFjWdWqlObVp1AZ6kMPsWmCDf1+j2PpLsQvuGr3HiVkRN
         yiZ3cLJ5yr+/SRjOb1pva462XpMqB9NkcNYRXcgUy00xMyCLbk1vseQ4hNrSXPM+ELjs
         0HxSzM692QQDZZTyw4Xgy26g5DetrFTZDMjYN52gZFQXIiwfyPfsuXHm1ZQGMB4eDjD6
         pXhw==
X-Gm-Message-State: ANoB5pkjUwF8k7yOTc7U9b320ATrD2lDkEkMhyQhYX3SZrhBt3ad15Vy
        kcXLJDYlH/Gd61lK/lFBziARmEASDxSJEV4mpMYvpg==
X-Google-Smtp-Source: AA0mqf4qVAOrSxpdJT6zZt/NoVVD9G5rp2nauOK2/L5V//qjk/naZGSqn65Gl+5u9CTiAvh6VcZAIATmMtW/6CkBhjU=
X-Received: by 2002:a63:4a21:0:b0:46f:d9f:476 with SMTP id x33-20020a634a21000000b0046f0d9f0476mr18938299pga.468.1668582932759;
 Tue, 15 Nov 2022 23:15:32 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-3-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-3-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 15 Nov 2022 23:15:16 -0800
Message-ID: <CAAeT=FwTtzmarzq9evNoUvDXeWiBcfEpQUb-Ex4esROU8kfEsA@mail.gmail.com>
Subject: Re: [PATCH v4 02/16] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
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

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Ricardo recently pointed out that the PMU chained counter emulation
> in KVM wasn't quite behaving like the one on actual hardware, in
> the sense that a chained counter would expose an overflow on
> both halves of a chained counter, while KVM would only expose the
> overflow on the top half.
>
> The difference is subtle, but significant. What does the architecture
> say (DDI0087 H.a):
>
> - Up to PMUv3p4, all counters but the cycle counter are 32bit
>
> - A 32bit counter that overflows generates a CHAIN event on the
>   adjacent counter after exposing its own overflow status
>
> - The CHAIN event is accounted if the counter is correctly
>   configured (CHAIN event selected and counter enabled)
>
> This all means that our current implementation (which uses 64bit
> perf events) prevents us from emulating this overflow on the lower half.
>
> How to fix this? By implementing the above, to the letter.
>
> This largly results in code deletion, removing the notions of

nit: s/largly/largely ?

> "counter pair", "chained counters", and "canonical counter".
> The code is further restructured to make the CHAIN handling similar
> to SWINC, as the two are now extremely similar in behaviour.
>
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
