Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E96238F5C2
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 00:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhEXWp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 18:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXWp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 18:45:56 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7291C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:44:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d16so22030548pfn.12
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=moS6oggcxprsPW7Vp6d1rxzceuGswLolHPrUHPRtQoE=;
        b=oh2uiXOdqhEKSOEolu5a8GzBcl8el+8zQzTE8McxvCRCcY6pmZpWRvSM5QxFQRcuXv
         mD1pMEu13vUg+qn+X2iQXaEdfShgTQ17886vh1ONinU9JW2yrJq6i6+bH3j8KpoM1Zr+
         EWYBFnQW9dLTyCvpNEAwPzsI8FRlg3AJ0lBIw1c7AA1kpEV1u4BwMPoN7SwOuGo80DIX
         d3x4WArgQdBaoffF2NConzqpRkVCNQ69RyyVM1ptFGgLZZ2A/CX7tkNdfCJerSN9VBuM
         PMl0gxTgnNNfO0lk7r9+odLmNk3xeawNts1DFJQGrYbMM4DYdYbCjt78bMYmkaDhMNa8
         r1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=moS6oggcxprsPW7Vp6d1rxzceuGswLolHPrUHPRtQoE=;
        b=aXCcsjQ5NoUjP9feukVP2b3Ou0SKFZCVklcfvjDXsMVHnvZmP8TxOnUIi19FJmpypT
         7B0iQ87Z9CcvKRJmIwK/VzHbvYlKnHSmAFzdpNSytjslU06Sv3j0xVad9yvhtO/A7c3c
         DjDkcS+Pd1rJ7RclpieV3Wr0TLCOmFuY3Y/sYBvrBRlNvMDmCTur3Ndy56EhZpSRwj7j
         XQy07gg4dMjrpspgB9sj7da2DtO0JRMDllmCqujaRhW8PYpVkD8MbiM5FMbhT4sVLVPC
         Zl9YCBzwv8B2JOfLU24BaSZHrDQF3KaBLZsZOarkCnHJp9N45XzhKhsJfyIJnMhBjBnp
         RQ9w==
X-Gm-Message-State: AOAM532pCRjRUBEObTmLc57xrvVHIjYgTa2p1Cn3er4mnA/KVrKKpR10
        BKVk+jMgwPhwQnMvIhfAQFbmEA==
X-Google-Smtp-Source: ABdhPJxSh18GawCsjpGGc8gjOk8Vp48a3+k4tw5NRMvMkH4EZvvHo8CAwnSHf8a0mOw2fnr0cnPyvg==
X-Received: by 2002:a63:79c3:: with SMTP id u186mr15844970pgc.203.1621896267147;
        Mon, 24 May 2021 15:44:27 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 66sm12793435pgj.9.2021.05.24.15.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 15:44:26 -0700 (PDT)
Date:   Mon, 24 May 2021 22:44:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [kvm PATCH v6 0/2] shrink vcpu_vmx down to order 2
Message-ID: <YKwsRhDWi3LZNSai@google.com>
References: <20181031234928.144206-1-marcorr@google.com>
 <CALMp9eT-tKmt2nFy4eQ0bfLqHrZd9EruQ45p=AsR2aPWnj97gA@mail.gmail.com>
 <34bf7026-4f83-067e-f3d8-aad76f9cf624@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34bf7026-4f83-067e-f3d8-aad76f9cf624@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Paolo Bonzini wrote:
> On 21/05/21 22:58, Jim Mattson wrote:
> > On Wed, Oct 31, 2018 at 4:49 PM Marc Orr <marcorr@google.com> wrote:
> > > 
> > > Compared to the last version, I've:
> > > (1) dropped the vmalloc patches
> > > (2) updated the kmem cache for the guest_fpu field in the kvm_vcpu_arch
> > >      struct to be sized according to fpu_kernel_xstate_size
> > > (3) Added minimum FPU checks in KVM's x86 init logic to avoid memory
> > >      corruption issues.
> > > 
> > > Marc Orr (2):
> > >    kvm: x86: Use task structs fpu field for user
> > >    kvm: x86: Dynamically allocate guest_fpu
> > > 
> > >   arch/x86/include/asm/kvm_host.h | 10 +++---
> > >   arch/x86/kvm/svm.c              | 10 ++++++
> > >   arch/x86/kvm/vmx.c              | 10 ++++++
> > >   arch/x86/kvm/x86.c              | 55 ++++++++++++++++++++++++---------
> > >   4 files changed, 65 insertions(+), 20 deletions(-)
> > > 
> > > --
> > 
> > Whatever happened to this series?
> 
> There was a question about the usage of kmem_cache_create_usercopy, and a v7
> was never sent.

What's that go to do with anything? :-D

  b666a4b69739 ("kvm: x86: Dynamically allocate guest_fpu")
  240c35a3783a ("kvm: x86: Use task structs fpu field for user")
