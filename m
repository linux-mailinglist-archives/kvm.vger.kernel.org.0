Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FB5A1DE3
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 02:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiHZA7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 20:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiHZA7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 20:59:51 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3A755B6
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:59:49 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id d15so40521uak.11
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 17:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Nli7Lqv/iLJ91SrMgnfSlaqiEwBg1Xz1DfrVtIbRpJA=;
        b=baHVdsjMKFiRtUU6rg+ySj++qyTShUppqNX7xVpJE7BneDnKTdGiI4zae0Ht5KSeS1
         o6SvB7uMMyvng2nz81GAXOReUausBF/p9+ei4z9h31mJ1ODnZIbQtrJVifYwlZkA82AL
         qiAN/HLbA1JkUVpyA3xDJndnVK6qRNV/X7A3O5Ou6zH26MFzIFPa8L93LbIelxS4OUz6
         B/ZHk4b9f+0dk4DbQwA/J3pWvfGAqd39PdzbpFfJ/dzwkvr1OwYyNkEqj7Wh2yTHRTs4
         Id1SkCcVeUTGEJXeaoEW8WeUJTuncisDh6mpyv9VCmxwOU4ktF8ZS9Sum2qPJG85FFaf
         x08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Nli7Lqv/iLJ91SrMgnfSlaqiEwBg1Xz1DfrVtIbRpJA=;
        b=r94/P0JkipVZomM/G2Q2OTF7zPKMHWXh52Hm9SLXq4G6JeLEI+P7NvADDc9dmcUROC
         36Tuc/L3ACZjFFDiqusE8PldhnYUMexF4Jr8NFlZOoqgwgGsKLkLlCh2nEIuCf89beks
         mBe3mwbF9+Xk+L6msNV53qFgIbJQpmGqzlfp3tur4yicUJJXvftBlZ/Ls//YbpqtBPwV
         NFUdobutIZfIurstTrrrZi9ZCvIKtWdHwGyS8QFD5lCejmuXeZ2Ij6/QE4qaCCVEJILl
         ROmh7YRAeAMsUHJlrIX1nFGDsQQUuzuupgKkDsaPB3ffekVcpEaGCWXCpIKUdo55UIG5
         OQdg==
X-Gm-Message-State: ACgBeo2z9BCr+sMG7oqMhl92j3xKcXNumH7VlT/vwqfWVxStSO4q0BO2
        ZE0rPj5iGQsXk7AafeMMCroKFzxMUL5IsXgrHInxbQ==
X-Google-Smtp-Source: AA6agR7HwiDBsuw7STNcKz4WrRkm87dl2weKr4NcFWuZmrhojV0KLt2JoG7FnfoctJ7jGDiYHKvwr6nkthzrj3Ip22I=
X-Received: by 2002:ab0:13ed:0:b0:39a:2447:e4ae with SMTP id
 n42-20020ab013ed000000b0039a2447e4aemr2392200uae.37.1661475588658; Thu, 25
 Aug 2022 17:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com> <20220825050846.3418868-6-reijiw@google.com>
 <YwexdqgGpN43qYyy@google.com>
In-Reply-To: <YwexdqgGpN43qYyy@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 25 Aug 2022 17:59:33 -0700
Message-ID: <CAAeT=FzjsQ7UaRhvLRt_++PDzA5G294ze5DRON6MZx51DzCjZg@mail.gmail.com>
Subject: Re: [PATCH 5/9] KVM: arm64: selftests: Have debug_version() use
 cpuid_get_ufield() helper
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

On Thu, Aug 25, 2022 at 10:29 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:42PM -0700, Reiji Watanabe wrote:
> > Change debug_version() to use cpuid_get_ufield() to extract DebugVer
> > field from the AA64DFR0_EL1 register value.
>
> Either squash this into the patch that adds the field accessors or
> reorder it to immediately follow said patch.
>
> aarch64_get_supported_page_sizes() is also due for a cleanup, as it
> accesses the TGRANx fields of ID_AA64MMFR0_EL1.

Sure, I will fix them.

Thank you,
Reiji
