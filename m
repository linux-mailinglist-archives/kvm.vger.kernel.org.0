Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62435B0A16
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiIGQ3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 12:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiIGQ3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 12:29:44 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763226351
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 09:29:41 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id q39-20020a056830442700b0063889adc0ddso10642886otv.1
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=WjwdWxOWRjfQGqAqpcnj4pX2zdc5HoKExq2c695W4a8=;
        b=Wfub1DCPZNR7R9EN206ywv+e0F5aZjPNKrGchA3lDYiSZpytW4G5WbKw0oho4pVavI
         QdWIxFUGv6r4Gb44syKGmg9p0mRwjzAhmmw0YzWNYWUUfTzxBQPOXT/SEt19rFkPYbtL
         ScbR3CH/ohuxUF6Auh17ODk6cI4gZuyUfThlbuW6zPRRaH0FhrYXHwIdcAQJdciXOCpR
         p9gkidxuPfnLHTOzIx47aZziWoQ66xgalL7X6Y+6ruJgIJm6XzxKLf094JiyJzzKSnD6
         Unu5k//45ofyctD+y9kE19LTqxeNJJanYlFoJi8oXXPGy9CNvWi0Bsj3EkhasTNrvgNQ
         4yqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=WjwdWxOWRjfQGqAqpcnj4pX2zdc5HoKExq2c695W4a8=;
        b=Jmkwu3f2AxBYzWk+6R514UNfth9iU6x61z/qbmyMghKBoBMdkV+hd2OQ46iL0HVSca
         sAViDVK8hwKGQGQXQ4F/0R8aiWps/fExIZaZvP1BUbILCsbW1HYo0VYup5DLjR7ieVdB
         oB6W+ezT3m1aPOg8rLH5IoFDf3LR3emnM2iv32o296/wav8XZRK6z42Ebh2kmoxEz7x7
         WRemuZThndzWB8Ek2hOoSh/ynzYNtzVx+8KlbnVW+ZuClcEQYi3+Nldkq9p9ow5Otxz2
         T9mt47s9uXiSWLtd08bsX7pTLbGIzJ4ldQEuT00tr6on98yYuignPV9ooxpICV53k5l4
         5zBw==
X-Gm-Message-State: ACgBeo3WMZzNsiWF65tMCu07BPwMRUMdssL97O8MCypvpjU7K2dAZKlC
        c0j71Sy5TpHIF7lyqYPjnYQFz2tHbu17gyDZjkNNbBJj6xw=
X-Google-Smtp-Source: AA6agR4e7h9mwhkVcXUQ0zJTayfYABVbgQEn1AaGs5Y+5rpa31E7kDI3hDfchQP/hsws/JupffSf3HpzxTfCGAli3wE=
X-Received: by 2002:a05:6830:14d4:b0:63f:3cce:ff5e with SMTP id
 t20-20020a05683014d400b0063f3cceff5emr1862874otq.367.1662568180813; Wed, 07
 Sep 2022 09:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220907104838.8424-1-likexu@tencent.com> <20220907104838.8424-2-likexu@tencent.com>
In-Reply-To: <20220907104838.8424-2-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 7 Sep 2022 09:29:29 -0700
Message-ID: <CALMp9eQ_zk=H=q9A8qu_7TUEBjnKXPWtXygmdDpyQCrRDkLF9w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/pmu: Limit the maximum number of
 supported Intel GP counters
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
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

On Wed, Sep 7, 2022 at 3:49 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> The Intel Architectural IA32_PMCx MSRs addresses range allows for
> a maximum of 8 GP counters. A local macro (named KVM_INTEL_PMC_MAX_GENERIC)
> is introduced to take back control of this virtual capability to avoid
> errors introduced by the out-of-bound counter emulations.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>

Reviewed-by: Jim Mattson <jmattson@google.com>
