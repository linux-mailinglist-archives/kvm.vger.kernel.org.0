Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DA93B871F
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 18:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhF3QgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 12:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhF3QgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 12:36:05 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63331C061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:33:36 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id w15so2791932pgk.13
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hfx5UH1QNeMIT1lwqqkYcSf9Aw2ymYStyRD2Spjzp0o=;
        b=Fpbl77mM5zyzxMf+eqFQGz3orfQ5wo37mHkNMxfZrJF1W8yf+gdu/ESRpMAhrjxmfK
         uN9vOb9vSvMJtmlWQ58t7u44px7s6IXM+0nL4SVmYERpkTcHAqbtkpBmCpmBUgDsGzPR
         KZ5Rui0/WVm8YpUe+e6Xf8hZ1NDjgw2ZfIaeJ85XQIJ/YwiKoj4xIlHC58poZCEL/Sh2
         wUHeV9U+hfs1A+jf+nL4UOAuTYDntdwVva3wTIYpsUgrgvKrqoBhT/RcQK1CJM38u+oh
         aNiYtW+XO3Q3JA5CrnaOj4DfvdTR+e+dNpSQ0Jldw7/LLYlzH1SB75P10XWR6k1PokS5
         BSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hfx5UH1QNeMIT1lwqqkYcSf9Aw2ymYStyRD2Spjzp0o=;
        b=MLtXtojHe4tFL/AY1u9EDw6pvp5pyepZGlxsFqpHQqFkhzcXQsIQNQdjU96v47PRll
         GDmZBvaWx7Lk6QwCdsIloQ15K00WI95DGjfmFmoh3T5WKQkTPJdIsfZQRZs6rny7ROYd
         glXHKwQV+Kll/haImDJ9fUy63rVJtuIlfF0fBgjAZJnJn71rXAVHkCM8ywXJei2L4Zla
         6PZYNYJtEYZkzvMVBzKNBkVHUV7oefzWlAVWug/w2IdJW86FTBBpeXMXHH63XL0dN7T0
         DlX38RjyQoc56ynQbBB11XEgcgIqNTKkZADisbQSV3bpdmPGhym7JY2P7PqipzRacr8q
         /ayA==
X-Gm-Message-State: AOAM53046oYtpjBatI1yDb5TkF3mu+wdHK0w4isjSRNd90ISLRLF9HXh
        iewGVte2hFydvTaJIgVDxabEJA==
X-Google-Smtp-Source: ABdhPJxFwQ6+CwhR5+qOTQIDEK8Uq/+LANX6/g6d9qF91Bo5AxNVA/EEcrCvfY9m+ALZicyc6hDxhQ==
X-Received: by 2002:aa7:828f:0:b029:200:6e27:8c8f with SMTP id s15-20020aa7828f0000b02902006e278c8fmr36638442pfm.44.1625070815750;
        Wed, 30 Jun 2021 09:33:35 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id d207sm16891900pfd.118.2021.06.30.09.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:33:34 -0700 (PDT)
Date:   Wed, 30 Jun 2021 16:33:31 +0000
From:   David Matlack <dmatlack@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: Convey the exit reason to user-space on
 emulation failure
Message-ID: <YNyc26bXNg4bEAlG@google.com>
References: <20210628173152.2062988-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628173152.2062988-1-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 06:31:50PM +0100, David Edmondson wrote:
> To aid in debugging failures in the field, when instruction emulation

What do you mean by a "debugging failure"?

> fails, report the VM exit reason to userspace in order that it can be
> recorded.

What is the benefit of seeing the VM-exit reason that led to an
emulation failure?

> 
> The changes are on top of Aaron's patches from
> https://lore.kernel.org/r/20210510144834.658457-1-aaronlewis@google.com
> which are in the KVM queue, but not yet upstream.
> 
> David Edmondson (2):
>   KVM: x86: Add kvm_x86_ops.get_exit_reason
>   KVM: x86: On emulation failure, convey the exit reason to userspace
> 
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/svm/svm.c             |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c             |  6 ++++++
>  arch/x86/kvm/x86.c                 | 23 +++++++++++++++++------
>  include/uapi/linux/kvm.h           |  2 ++
>  6 files changed, 33 insertions(+), 6 deletions(-)
> 
> -- 
> 2.30.2
> 
