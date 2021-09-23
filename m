Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1D54166F7
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 22:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243116AbhIWU4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 16:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbhIWU4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 16:56:44 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FE0C061756
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 13:55:12 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id j11-20020a4a92cb000000b002902ae8cb10so2582118ooh.7
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 13:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tuAuDbYoqWTX1qLGSlEdN/vEAB2ogbMYztyFItd+EBc=;
        b=kffc8Bs2M9fmas9cVTmc2dxOYcmX43mfJnInRmBRfKL4ci0Ra/Ed4N8E9aIVQqSA24
         y6quxScpBT1ZO+7locgf2IBsBtTWSV1MKNtI2oVT4do2OZeKdRz10YZCGL/52KyupAbV
         8aWkm3j9u3p+CMwFtEy2BYAl++cwlQPKQPEbredKllWpQDcZG0YCswdFmrI0IV65882C
         QrAs7PCAcggjX4Ld0w7WKDz9iYcyrX72CHPj2bDCzmi5ujt9pcaMq+9eQgQMIWSurH2G
         Eys/T351rHFPil0fxp9pW01KjxiNyz8ucX3AGU0NrklTz5k2qrrM1pH/hsaX+WoH5gj0
         HvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tuAuDbYoqWTX1qLGSlEdN/vEAB2ogbMYztyFItd+EBc=;
        b=AxttVcRAdRxAgo3SeD84jJk44vD/1wab5IQWYLi1mQQB7CPUcIlAZ+7nIozKuPDkb9
         YgBJN8Y4pQ4jK/ytsPBc6Dqp6LeUiAHv6Jwo7rmpRXc8FMDKnxaWq07x6Mpp1lD5UIhA
         KzDH1C2oT0vazf4kgC/aiaThMLJ+F+D/J0RaVdFEYlrGDzo1361hmTRaWAXfYPDu2Iwy
         ctJu7SBKMdhIGjCfXjGH7E9mfnqA02mF3KgfxkbAOsvMV+c/S2X9eHV8xP3+ixfRrryQ
         XEAgbdhdxXj2s7H5D/aKNdaYww3FC2960zjNjtNJcTFye2OWcTWWDq3vXHmhRHfaA2YT
         tPxA==
X-Gm-Message-State: AOAM532H3OkeQj63ZRSQFnCUn8FUXR8ys8PeZX9ayo7qIBLVhpL+lc1k
        4IJZinmjbfoZBoCHrm+vX0WfcEmWKeKKTCmR74Q0Kg==
X-Google-Smtp-Source: ABdhPJyrQCd4do4odQK5DYKgmv7IsQ+AMJhA+BxnQq44T7hGl3RRh3tzoKAYCmy4S2uMMD9KFjWXH8MfmAL80dEIdbw=
X-Received: by 2002:a4a:7452:: with SMTP id t18mr5499065ooe.20.1632430511717;
 Thu, 23 Sep 2021 13:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-22-brijesh.singh@amd.com>
 <YUt8KOiwTwwa6xZK@work-vm> <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
 <CAA03e5FTpmCXqsB9OZfkxVY4TQb8n5KfRiFAsmd6jjvbb1DdCQ@mail.gmail.com> <9f89fce8-421a-2219-91d0-73147aca4689@amd.com>
In-Reply-To: <9f89fce8-421a-2219-91d0-73147aca4689@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 23 Sep 2021 13:55:00 -0700
Message-ID: <CAA03e5EOb1=ndtroDw=mZgfCBPJ5OOEYLDLBxrBKrhZb=WtWAQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 1:44 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 9/23/21 2:17 PM, Marc Orr wrote:
>
> >>>> +
> >>>> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +    unsigned long pfn;
> >>>> +    struct page *p;
> >>>> +
> >>>> +    if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> >>>> +            return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > Continuing my other comment, above: if we introduce a
> > `snp_globally_enabled` var, we could use that here, rather than
> > `cpu_feature_enabled(X86_FEATURE_SEV_SNP)`.
>
>
> Maybe I am missing something, what is wrong with
> cpu_feature_enabled(...) check ? It's same as creating a global
> variable. The feature enabled bit is not set if the said is not
> enabled.  See the patch #3 [1] in this series.
>
> [1]
> https://lore.kernel.org/linux-mm/YUN+L0dlFMbC3bd4@zn.tnic/T/#m2ac1242b33abfcd0d9fb22a89f4c103eacf67ea7
>
> thanks

You are right. Patch #3 does exactly what I was asking for in
`snp_rmptable_init()`. Thanks!
