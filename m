Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFA871F7C3
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbjFBBXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjFBBXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:23:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250C4E79
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:23:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-258b62c7a6bso1191445a91.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669005; x=1688261005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7J0QZWg6F2cc0DLXilV3bKM/pF3U54S5im29Dea9Lhs=;
        b=WDnXN6cxGejXgyZLVaMge75b8VlbpfUrlyKoWyy5hd1P7bs07/eewaNVxJXhK88tNu
         rFKYhvR11j+0Bk6ugBp7PMXRVlQjGsvThWmfATq13OXMofOMcyKgwo37EdicacWl2psD
         SBx1OdsoUMyEknZup+nfWluJPu+9FqzY7/ZqQzLrbEQaS0oNQsNf3sXIILyRp0rKtDcT
         mrWT/X1b2OQbqzQePLyccsSGYqt2GVKC7PXLOzqLMUdNw2SldYId3c9VngIG1I7v75cm
         4IULVfQJzOzYp1jHzf22i9+GV6eeoHlAG0qwXGMW3mRmobC8xIdEoJJGNprvpxBeKYE8
         HGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669005; x=1688261005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7J0QZWg6F2cc0DLXilV3bKM/pF3U54S5im29Dea9Lhs=;
        b=PWHDY/07iEcOmXRamGi6MLqcL7/1Fm/zizvjswX3oXMvWr0rpl6L5TiB8LGgwsNkHr
         Co9Y1GP7lONe8OJy2ZzSn2PoLTGFQ/+2fzAjkZoOrYhNUh+dazFx2lbUTk1EBrjcbtqa
         i+0bDp5Tdg66w3FFQAnyYxBski+FqLHGQwbMi9zQXZI8XtBJYYy9l8rKNsESbPRhCIWU
         4DfqpmkDcUAHoy8lUjpo06AMN+pgIfXpnnA161SZXOO8uX741EXcL5eTJdJoaf071fqF
         2T2m328z+5qbOhtQJXhzYWbanf8sY+g53OLOn2OR7gh7DiX11s5xuVgipySnPqLodS6C
         vILg==
X-Gm-Message-State: AC+VfDzQiup6cAse/QtuisuktqqhmGLba3K1RZVe/ZqaWrncY6Z3tHmv
        WMghIH4Kl7xw9MrEaTj31FVnK5Vdq/U=
X-Google-Smtp-Source: ACHHUZ6bWOt2Unm0Phnx3wbcX63pxnyc9rhKkz2vLj3ye1wbaOKzXLfmn7+2LuPO44tnuuVop2PRHmS9jro=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:e84:b0:256:6214:4834 with SMTP id
 fv4-20020a17090b0e8400b0025662144834mr215151pjb.4.1685669005481; Thu, 01 Jun
 2023 18:23:25 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:23:13 -0700
In-Reply-To: <20230523165635.4002711-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230523165635.4002711-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565201123.660980.11881398447176084138.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Remove TSS reloading code after VMEXIT
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Roth <Michael.Roth@amd.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 May 2023 16:56:35 +0000, Mingwei Zhang wrote:
> Remove TSS reloading code after VMEXIT since upstream KVM after [1] has
> already been using VMLOAD to load host segment state (including TSS).
> Therefore, reload_tss() becomes redundant and could have been removed in
> [1]. So fix it by removing remove reload_tss() and the relevant data field
> tss_desc in svm_cpu_data as well as its data structure definition.
> 
> [1] Check the Fixes tag.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Remove TSS reloading code after VMEXIT
      https://github.com/kvm-x86/linux/commit/0d3518d2f8c3

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
