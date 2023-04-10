Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3186DCE19
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 01:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDJXan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 19:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDJXal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 19:30:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A46926AB
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:30:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 82-20020a250355000000b00b7411408308so7073637ybd.1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681169437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NEJjGhEklh175OeP8/Q76NV27eAb8+1mk5/dnEHppbY=;
        b=FsuXazcrHJKZvu6g1nSDIuc3/gmgb4O7h/UZ3ppdemgARatJqjZUYAyQ7ArpDcQjGg
         NNksngyx5safom93YGHnZ4pHfIdvagOTlwG4e6mPTdqA0m/I0/j5XO4g7RC/yDXqUUnE
         0kjgYDaAtcYR2UnK8LAYL4ueJjpjL+vmDuetHHIkGmUvzU5np9agexCj8KgH5xtyRJeI
         FyqIkXZtem2//4UMqGFNuqp0CNKcQ9ZL1bFMk4hx5pUdYkb8i+8Z88/cg75hfZAtHBlG
         8wpSWZnhFB907WN/1gf7dSSmW89DpoYb4f1pI94YGNd9pvs3aIqLJHpBOUNElFegdCXf
         Jb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681169437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NEJjGhEklh175OeP8/Q76NV27eAb8+1mk5/dnEHppbY=;
        b=M0E30QTqcg0N8CqnZBIonVEzOCWfQhtPq5ZfkluJ5a4Zu42mivkr/4Uf/ZqugmXBxk
         EL89mxgIt8Gk2DjPXtoEPJtRVp/Z3QV1qELLpIZfNmfsCHH31Ox93lyWMHKH4q8HelGR
         DsArpFIA95zJyQTU/1aFn1gGAtnXQJaS4Zx3DHzVQdJivm9T2eCpDyC0sr9GZQGGXNZ5
         9cdj20x3pboDOfhsG190b1Ie9HuAyrTwXqZ3aq/5tXJQMPYHtti5y3uHvAwXEi+HaFXl
         LtidWUwAjpNaR1UG+1LyY7N3tDUuPguGa9mzFNZ/IRqEXdRVhXc5zjDXcA0JIkZ29Edi
         YuqQ==
X-Gm-Message-State: AAQBX9f0jM8diVUnjUV2E9qRQmTp/NRHo0XUJpctm9SIai5/Sik41o6n
        b8fdLTImCtBN8ceQBDkQVEEBZQZ8f+A=
X-Google-Smtp-Source: AKy350aTFgm3kLlfiqX/31P/rtLap6T3RPMivnN0w+GwPDldj9gU7Bx0Rw1DYwrMVkwIJ/cdQaYc3ikaDJI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c905:0:b0:b77:81f:42dc with SMTP id
 z5-20020a25c905000000b00b77081f42dcmr8185978ybf.1.1681169437488; Mon, 10 Apr
 2023 16:30:37 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:30:33 -0700
In-Reply-To: <20230405003133.419177-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405003133.419177-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <168116506851.1036283.16135858065837035509.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: More cleanups for Hyper-V range flushing
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Apr 2023 17:31:31 -0700, Sean Christopherson wrote:
> More cleanups of the code related to Hyper-V's range-based TLB flushing.
> David's series got most of the names, but there are a few more that can
> be converted (patch 1).  On top of that, having Hyper-V fill its struct
> provides a decent improvement to code generation, and IMO yields a better
> API (patch 2).
> 
> Sean Christopherson (2):
>   KVM: x86: Rename Hyper-V remote TLB hooks to match established scheme
>   KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V
>     code
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/2] KVM: x86: Rename Hyper-V remote TLB hooks to match established scheme
      https://github.com/kvm-x86/linux/commit/8a1300ff9518
[2/2] KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V code
      https://github.com/kvm-x86/linux/commit/9ed3bf411226

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
