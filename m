Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9287E53ABBE
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 19:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349258AbiFARWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 13:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344943AbiFARWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 13:22:34 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C9C2E9EC
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 10:22:33 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-d39f741ba0so3535713fac.13
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 10:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FWg3JZfktSSrdgFAMVaDrGMFvaq4LPYe4zYDHqOpIyI=;
        b=D3q/Y5VPJszEhP0lUrBb/uiemgtEZm/hP76FPyYurLwbbQgGKqLdr3+b8MLRY+V01I
         yZHa2xWhVgZod8kv7DC7Wg4PUNHgmsqTkgI2SokWxt1Fi3XE4qo2jfDD+bsW0E137WsK
         /fG91DZ0kIe0wqsZNLqw9joyNk5+g9i1yguN83HvnVVRjKzkPwYKDYiIe8LRqIRbND+u
         9QIlSdCZxeXbdFGHSN6DxqfxYQFH3aHwk1FTKrQYZGYHSJj4k01H6t24npyQ9ZaHgYtJ
         rGOLIHXDWSS27FkDx2Oo5eN8JyMq8kMYfkEhHx/6NB3g/PVkAE1W2rV/2OfQNfCPyHrp
         PNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FWg3JZfktSSrdgFAMVaDrGMFvaq4LPYe4zYDHqOpIyI=;
        b=QNOXbnm4Gngy1ksBYJu6TYWD7GsBEywbiN8J6tIJ72by9fYfDDJ2h+3CwThxaOAMX9
         Ijlo6UXWAIUyqcj1dpfY5yeIZMqMBCw+x04HmnPR77kB43cxXLV+OaDRr8WEAkQbv8zT
         sdGa4zBtHFUPpvViOTv6Q4cFzyHEAvlygtZCQ6ja8xE79AoUWtxXhoGx2L9SQgZQ9VDn
         LU29TRhGZQMNne4tC4nXJFhMY7I2fZT6aCPL2GM4DXk46Hb1l30N0xXwebqUxFLTbULw
         BpPoEyK/ZzjBtmlWZcNFSusQ3LjmuCQkY6ym4zJHXBLUMM+qxAa6ZIDINh8rzkTlXmUh
         M60w==
X-Gm-Message-State: AOAM532VYEb3kO97YD/Zlinm+r7dW2i9S2wSomiJ4DWqkoh42Z9CEz9h
        l2gaS+7DJkrhogI0Ocrv2HcSoeV3+cc174an6u7HTQ==
X-Google-Smtp-Source: ABdhPJyaqTTSmxMRaifJdMMn4cG4U5vHQwj0XNRqHIuUQJwpKzm/f+4C+AMm4iCaVbv/CUkS60ZIsA1CizTt03oOAFE=
X-Received: by 2002:a05:6870:d60d:b0:f3:2e4f:4907 with SMTP id
 a13-20020a056870d60d00b000f32e4f4907mr10272463oaq.13.1654104152869; Wed, 01
 Jun 2022 10:22:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220601163012.3404212-1-morbo@google.com>
In-Reply-To: <20220601163012.3404212-1-morbo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 1 Jun 2022 10:22:21 -0700
Message-ID: <CALMp9eRgbc624bWe6wcTqpSsdEdnj+Q_xE8L21EdCZmQXBQPsw@mail.gmail.com>
Subject: Re: [PATCH] x86/pmu: Disable inlining of measure()
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Bill Wendling <isanbard@gmail.com>
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

On Wed, Jun 1, 2022 at 9:30 AM Bill Wendling <morbo@google.com> wrote:
>
> From: Bill Wendling <isanbard@gmail.com>
>
> Clang can be more aggressive at inlining than GCC and will fully inline
> calls to measure(). This can mess with the counter overflow check. To
> set up the PMC overflow, check_counter_overflow() first records the
> number of instructions retired in an invocation of measure() and checks
> to see that subsequent calls to measure() retire the same number of
> instructions. If inlining occurs, those numbers can be different and the
> overflow test fails.
>
>   FAIL: overflow: cntr-0
>   PASS: overflow: status-0
>   PASS: overflow: status clear-0
>   PASS: overflow: irq-0
>   FAIL: overflow: cntr-1
>   PASS: overflow: status-1
>   PASS: overflow: status clear-1
>   PASS: overflow: irq-1
>   FAIL: overflow: cntr-2
>   PASS: overflow: status-2
>   PASS: overflow: status clear-2
>   PASS: overflow: irq-2
>   FAIL: overflow: cntr-3
>   PASS: overflow: status-3
>   PASS: overflow: status clear-3
>   PASS: overflow: irq-3
>
> Disabling inlining of measure() keeps the assumption that all calls to
> measure() retire the same number of instructions.
>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
