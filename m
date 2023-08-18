Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FD0780289
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356564AbjHRAJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356627AbjHRAJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:09:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8BD3A87
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:09:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d71f505d21dso426588276.3
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317333; x=1692922133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mE3f+VMf8SgNE6cCbkcfMUP8Hiy9b4N5xYpI+7a+l+E=;
        b=2oU9BIaw0ILeiNHyHsZk7TDIJto4bfSl6FpDcbZRzJHFWDHvsw1Tpz4Q9Z++SpwVVm
         JmUyxEgAq2LjZzc+OkhyeF0ADm+bu03vFWElhLKmVcXuodsBknHK0n2IWaJQr+FjH/Z4
         ly63wavRjg8vLggYRlwWHybAT9gNxWq5j3pZ0p0w2xXzXTZlhASOY+NoRS2/AtMtjhTQ
         nTZWu9PlR/5rleTIvIDNYwbMF6iZSL/aHkUyyZqrHDOanbSxez20kKr5PC6Ct3iYGtdC
         ypG1bXEpsnYr9lf8V1DpKfNV0BYeA2in/OciIOL0bd/uD0xPHtdS27L3UXNyt2X2G1Wi
         /49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317333; x=1692922133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mE3f+VMf8SgNE6cCbkcfMUP8Hiy9b4N5xYpI+7a+l+E=;
        b=Hlkr4vKO4C6cbnhFofj2sFOE9sBu5kAp1pMv97DEVqulwxNsT3vHO/G2+nylqghGn7
         VyOVYHUvFvRvnZ/FvzmRkgTbksDUQM4/e/GUatO6i9/mlwYmsQyXpZVh6TJScIqhy3Y3
         TH6pHTp9sNk4SJpLmWBkQVebKC/Ta2DKnWh8DyUz2vW96dmslLT2sGLD6t/dgryBxSYy
         0F7xPGcy069DMXneI2Mka68Nd/PeSmRwvJzmUbmukKS09vZpBn2lDp0E7wVqTfNCXzqy
         7BrRAsFXb8/qYbm+6cqRJasqE1P6so5rs38QCdbIr2mdBuC61ZmHYah3Ph9a2R5pGnuZ
         MNRQ==
X-Gm-Message-State: AOJu0YxafoJuNOTjo9dEE3lyStgsv0kV8rn9zRzeM41oscCwb8iD7yf8
        YsQB54nyZafF7pQYFB8AIPoKgBZC+yE=
X-Google-Smtp-Source: AGHT+IGvQyAfQmNzh/hNJU4kHU1VAazzXRBOVugeRSHej1YWD5+faOfCNQeeq5lvAq2y2Br8ZKMaZLXhQjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4113:0:b0:d4b:99ce:5e51 with SMTP id
 o19-20020a254113000000b00d4b99ce5e51mr13582yba.6.1692317333678; Thu, 17 Aug
 2023 17:08:53 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:08:36 -0700
In-Reply-To: <20230729004144.1054885-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004144.1054885-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229683179.1234886.15097906251075154792.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 17:41:44 -0700, Sean Christopherson wrote:
> Wrap kvm_{gfn,hva}_range.pte in a union so that future notifier events can
> pass event specific information up and down the stack without needing to
> constantly expand and churn the APIs.  Lockless aging of SPTEs will pass
> around a bitmap, and support for memory attributes will pass around the
> new attributes for the range.
> 
> Add a "KVM_NO_ARG" placeholder to simplify handling events without an
> argument (creating a dummy union variable is midly annoying).
> 
> [...]

Applied to kvm-x86 generic, with KVM_MMU_NOTIFIER_NO_ARG as suggested by Oliver.

[1/1] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
      https://github.com/kvm-x86/linux/commit/3e1efe2b67d3

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
