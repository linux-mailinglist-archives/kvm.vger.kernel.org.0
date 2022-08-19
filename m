Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13D659A800
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 23:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiHSVyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 17:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiHSVyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 17:54:53 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F13958E
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 14:54:52 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id m21-20020a9d6ad5000000b00638df677850so3908451otq.5
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 14:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jp2q8+wHvNQOixYx4PKbIaPjNkYkkJRhsagfB6IVqbE=;
        b=PPmhQwtBns0UgyOPryIOLzd4HAKVCFqN2ePPjyg7KUrvexio/mO780s7hYZIdav8VA
         ofv2yYu2kRM+d/fARgdaREQW7gT9+hs6/1Us91wLeLXSq+JlkqFNbn9LhJMcAqIAm7iQ
         ZglsA+78ZnGHsi+8z0ttBhHa5hOMdyYde/NX3WbqBrQHGODkF1XkeiQ12wY2kPembcvs
         SGgtXPK7Hh7JuEeoYMChxK6LpZKvHsTgLvwW73cWebWTSZKtIgZL7oMi3hYS2K0PEYLM
         AeZDsZbGMcfy7iEXTGjiNJ4HJKs7Z/Adt6IJAj6CagE1KCbiVRYrHT229QRx5Z5dTeGh
         YNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jp2q8+wHvNQOixYx4PKbIaPjNkYkkJRhsagfB6IVqbE=;
        b=r6liUNZXICNzTx/5VdLmlzXUZq9i1J8Y3guOp3134kp3oWXoHcO3KdiyxFKydxS2jt
         n97xvxYJmbH65qz/hVcB2h4Zy3I9Xw6Q4s8iLksBGrr5udyXdpXc+zeZU9Z67cbSMCLY
         aBYSX1BUkppscvIcdcVcWiFVU4loSHUI8t74sD8AOrvZPAzZyl0MksTz/K5xjM/az3lf
         47d6gHgWcJ7uoTwxoEZWl88pR0/sEUeZleFmdjcvWDXLoMgHWFbO2TNR7QGaahSFJvS6
         i3vKI2hhl7jggkd/sVWnmg8SBeZ0Q/zSvyY/4xh8nD1OxXvzE9paby2UXjlfW6adX/bu
         4d4Q==
X-Gm-Message-State: ACgBeo3/1VL+fmTIhsuEy8ka90w1zFae3lcz9dFRv4e5WpTTM++5xkI7
        vAustgPHj5IGyHW36uannY56DxakLwD1r5Qw38nszId43rQ=
X-Google-Smtp-Source: AA6agR4rsEZSBZHJ576KM0RJSQEpFJQ4IgGAUraiyLdVIuJPldc8K5JN4kYfaEyq0cRE7jjJz84VRGu2osNPD6CKYRw=
X-Received: by 2002:a05:6830:2a8e:b0:638:c41c:d5a1 with SMTP id
 s14-20020a0568302a8e00b00638c41cd5a1mr3877418otu.367.1660946091212; Fri, 19
 Aug 2022 14:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220819182258.588335-1-vipinsh@google.com>
In-Reply-To: <20220819182258.588335-1-vipinsh@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 19 Aug 2022 14:54:40 -0700
Message-ID: <CALMp9eR1HYE6vWcqz3q=fAJnghdehpkaTuxhU8YjeQ8C6JofoA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix mce_banks memory leak on mci_ctl2_banks
 allocation failure
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, Aug 19, 2022 at 11:23 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> If mci_ctl2_banks allocation fails, kvm goes to fail_free_pio_data and
> forgets about freeing mce_banks memory causing memory leak.
>
> Individually check memory allocation status and free memory in the correct
> order.
>
> Fixes: 281b52780b57 ("KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.")
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
Reviewed-by: Jim Mattson <jmattson@google.com>
