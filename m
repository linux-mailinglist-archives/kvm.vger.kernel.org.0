Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EC4712E27
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 22:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjEZUcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 16:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjEZUce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 16:32:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2D5114
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 13:32:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8337a578dso1577915276.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 13:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685133153; x=1687725153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AugYPaMxd1tjDyNG28lcz/IOKmUdTy9haNXFprNJaFY=;
        b=AOgcabgAHgxLwAoXAkJa24kKehRwCghXNMrubPJ7QJ0iyqIjKc9EmnEHC+7jKdqd7z
         lfgglrRTYI9IqCskhuN8Me0G9aSavtBZtkDqxC0z4lLSW529ncE5c061JK87UzJMA5qA
         2v6hTWVvL5D3dlombYAY7xhY0czlrqH+4A8S1gH8pDZ2wc0/YT+5MCZ92+drwOR2iWuA
         Q1TH14FR6KexnvnCOPUu2KyFBq+W2OlVWkvqh+Cik4kQaOqrmwgW5qNEDYBzoSP3AHrZ
         KBKGHba+zOTRZGofmkpwB6adRlIks2R26aVi5WYqgMF6wYk8EJPb4uki1pq7FPB8xU15
         qx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685133153; x=1687725153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AugYPaMxd1tjDyNG28lcz/IOKmUdTy9haNXFprNJaFY=;
        b=YeVM5R8Mw3r0EYKZYX7Culdecib+FrrXpRsrqC8fBJIDNqOxVwy1LAWYOWshvdp/yt
         u0SwA55NNs+EQKP/bODRHt0TUtHy6xqA1r377evW2WgLcfOX7PhVqQL7Gj+5IMdpqLS1
         L9Yyo8mIDVOwSvz5LmaKoBe4DuYrUfPXCYU8oZEMdroBokhVzcRKu5oyocv/p7/KDrYx
         EH9H8jEewv1+V9d1/NNqkcVmppjsYb28LD67p01kJjRZRQ+f6saCkg4NASp6fxxsKZV2
         9s73qPErnHUNtqFUpJC1WoqiV3L79zPVbpaoFpvk9CtncoEod4t7RDHL7NlV7dqpwxHu
         megg==
X-Gm-Message-State: AC+VfDxF51IabONeFoMYO5roCj4Q3chf3qpQj9/K549jtLBhIb0cORB5
        SmTAU8aWmm0tvdHNuAMj1aDAw5pyE0c=
X-Google-Smtp-Source: ACHHUZ5kMqhi8lubpuI51EZIz65cbHYn+4CmJsgvoxVxB+HiOp8jhOPB/+Y+uc+TVjes2OHtZKSthPw2v84=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4ef:b0:ba8:2e69:9e06 with SMTP id
 w15-20020a05690204ef00b00ba82e699e06mr1600880ybs.1.1685133153006; Fri, 26 May
 2023 13:32:33 -0700 (PDT)
Date:   Fri, 26 May 2023 13:32:31 -0700
In-Reply-To: <20230418101306.98263-1-metikaya@amazon.co.uk>
Mime-Version: 1.0
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org> <20230418101306.98263-1-metikaya@amazon.co.uk>
Message-ID: <ZHEXX/OG6suNGWPN@google.com>
Subject: Re: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
From:   Sean Christopherson <seanjc@google.com>
To:     Metin Kaya <metikaya@amazon.co.uk>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        bp@alien8.de, dwmw@amazon.co.uk, paul@xen.org, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023, Metin Kaya wrote:
> Implement in-KVM support for Xen's HVMOP_flush_tlbs hypercall, which
> allows the guest to flush all vCPU's TLBs. KVM doesn't provide an
> ioctl() to precisely flush guest TLBs, and punting to userspace would
> likely negate the performance benefits of avoiding a TLB shootdown in
> the guest.
> 
> Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
> 
> ---
> v3:
>   - Addressed comments for v2.
>   - Verified with XTF/invlpg test case.
> 
> v2:
>   - Removed an irrelevant URL from commit message.
> ---
>  arch/x86/kvm/xen.c                 | 15 +++++++++++++++
>  include/xen/interface/hvm/hvm_op.h |  3 +++
>  2 files changed, 18 insertions(+)

I still don't see a testcase.

  : This doesn't even compile.  I'll give you one guess as to how much confidence I
  : have that this was properly tested.
  : 
  : Aha!  And QEMU appears to have Xen emulation support.  That means KVM-Unit-Tests
  : is an option.  Specifically, extend the "access" test to use this hypercall instead
  : of INVLPG.  That'll verify that the flush is actually being performed as expteced.

Let me be more explicit this time: I am not applying this without a test.  I don't
care how trivial a patch may seem, I'm done taking patches without test coverage
unless there's a *really* good reason for me to do so.
