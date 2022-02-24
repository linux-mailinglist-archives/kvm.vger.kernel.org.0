Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF27E4C2CF0
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 14:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiBXN0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 08:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiBXNZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 08:25:59 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0F715F615
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 05:25:30 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id d21so3742318yba.11
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 05:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyDGyW/NXfqLIjC1WzN0Ar/TYLrZ09tcsez/yWwu874=;
        b=CEnyKn0gygVuk2jLKONBs8a122NU2vu3Rl1cNd/9pRLD/04312NIGfwb19lxBCK/iM
         YtK40cD02Dqyb/y0wvLpMKOJGMvk3akGnUComBdcvIC0SEXkRaIsZKVC/ce61pNE1XcS
         qYft+XGbTBaJzPb4lbT0bbJPR+LoITgtzQSfNxviHb/lajxnz2k+wOlaMy7eJHhUV21k
         rKhLZheZsKBkSE9e1dZPz9iGCfN4Kw0ohLuaL0ZNaitBF8CkFyoxLCIU+l7sosUxMzc0
         fymv+5cdpcOX9dzTDhFxMQ7ObzRwNcVwFPEJFCdApqBGAutRrFvxyIQVyqqlCbFfgoN2
         2MZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyDGyW/NXfqLIjC1WzN0Ar/TYLrZ09tcsez/yWwu874=;
        b=m7cqHlAOMsvrajjh1HlCk4E6LnzPuwJ4Ab4P2y3st2bwnIIuMIa+Zcgb9h+WJ0aWaO
         heEogizTK4EG8i7ipG0I7f/BfhDKBYgn6XpLaYBEqSajZyKx/RivckH70mlN5R87GDoe
         hqMnCQDOeEcje1GidTkZw65xUyF8L4bjpocwAaFEj+FTtfbK8/gGxkV9JMphoiFbYlBp
         yrSDotdPeUiAOrSBPiXKxXYXfhY9/Byb9xdNpyBPgFqEUqILVvvNZ3eyhFXDroPM0bZI
         nqQRVVqTvEsJ4qZMnkeRBzMhA2zCNv9V1Tf69OpTANMKYO/9qNHBkj/gjZ6SSOlnR7RL
         JTTw==
X-Gm-Message-State: AOAM53194uolX+iKmAdaG0IqiHS/9BcKXLvMbuQ0+lN90ogqid7i/aZi
        AJdQd6urADHCiWhrlSiey8BbYJ/5RTyIj2ley5H5sQ==
X-Google-Smtp-Source: ABdhPJzClNRy/p3/eLApnIlqfaVmI0yhCRD9iKpsCqmeX+B4Ny45TU7JsETqrdlDLgzBvj8QuZsjUpseoVgo4lEr3os=
X-Received: by 2002:a25:69c4:0:b0:624:4ee4:a142 with SMTP id
 e187-20020a2569c4000000b006244ee4a142mr2429006ybc.85.1645709129260; Thu, 24
 Feb 2022 05:25:29 -0800 (PST)
MIME-Version: 1.0
References: <20220213035753.34577-1-akihiko.odaki@gmail.com>
In-Reply-To: <20220213035753.34577-1-akihiko.odaki@gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 24 Feb 2022 13:25:18 +0000
Message-ID: <CAFEAcA8_VgsR=Bcn1wxxaLotxQH3sumYMt1=3NxwHcdQFLPYqA@mail.gmail.com>
Subject: Re: [PATCH v2] target/arm: Support PSCI 1.1 and SMCCC 1.0
To:     Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@csgraf.de>
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

On Sun, 13 Feb 2022 at 03:58, Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
>
> Support the latest PSCI on TCG and HVF. A 64-bit function called from
> AArch32 now returns NOT_SUPPORTED, which is necessary to adhere to SMC
> Calling Convention 1.0. It is still not compliant with SMCCC 1.3 since
> they do not implement mandatory functions.

>  /* PSCI v0.2 return values used by TCG emulation of PSCI */
>
>  /* No Trusted OS migration to worry about when offlining CPUs */
>  #define QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED        2
>
> -/* We implement version 0.2 only */
> -#define QEMU_PSCI_0_2_RET_VERSION_0_2                       2
> +#define QEMU_PSCI_VERSION_0_1                     0x00001
> +#define QEMU_PSCI_VERSION_0_2                     0x00002
> +#define QEMU_PSCI_VERSION_1_1                     0x10001

Just noticed that there's a minor issue with this change -- it
deletes the definition of QEMU_PSCI_0_2_RET_VERSION_0_2, but
it is still used below:

>
>  MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
>  MISMATCH_CHECK(QEMU_PSCI_0_2_RET_VERSION_0_2,

here ^^  which means that this breaks compilation on Arm hosts.

I'll squash in the fix:

--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -98,8 +98,11 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES,
PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_1_1                     0x10001

 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
-MISMATCH_CHECK(QEMU_PSCI_0_2_RET_VERSION_0_2,
+/* We don't bother to check every possible version value */
+MISMATCH_CHECK(QEMU_PSCI_VERSION_0_2,
                (PSCI_VERSION_MAJOR(0) | PSCI_VERSION_MINOR(2)));
+MISMATCH_CHECK(QEMU_PSCI_VERSION_1_1,
+               (PSCI_VERSION_MAJOR(1) | PSCI_VERSION_MINOR(1)));

 /* PSCI return values (inclusive of all PSCI versions) */
 #define QEMU_PSCI_RET_SUCCESS                     0

thanks
-- PMM
