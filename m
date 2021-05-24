Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443E938F5FE
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhEXXCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhEXXCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:02:44 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884F6C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:01:14 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id d21so28522604oic.11
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PSD9aky6k9bGsVcfR0vPvHg999974ELdRM/Fh4rT3ZQ=;
        b=sv0PW37FhOwUmoDWupNNXFctJcn5NfGmvJvyli82uR0RUuDCsX3TpjoezawKD9lrl3
         DSt/1hori90crTHqt6/dUe1jT4wCcB8yUtbvXAIrF14T0nTZpYgKKXnq9NTvtTstzPpT
         S3zRsK85tJM0zgIULolt9mnj5axhjsFapb2MshaniD1en9OFVmt2iNyGpL0wz0zBV/XW
         S2WQCxXhIGqyl+0FzRzLgBIRp6GHdm3ZEiwBZG0UIEuRHh28U9zhKdcHUf5U8/26dbZR
         QRf2rWZlF4tPXPpSMtZKRQKBFvhFCn1cGwnoA2mpLgoQlym7FzEfIi6pTsPyhK3QcB2L
         pHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PSD9aky6k9bGsVcfR0vPvHg999974ELdRM/Fh4rT3ZQ=;
        b=C/9tKG1EpjeUU8n9lJg2uXtaZ3YhYZ4rRRTvPtBYnek7n1ANGxr4VsjIhqxhp8S+IO
         kvF6A3uf57AzV6864YutjNTZ6ngy2Qi3pnqkJ4iw0TOtLW9Twuo/HJHdpMeV25NSga9v
         8JokFYYy5Nz7chAffCdOodhonydSMrYtckx2B9mr51pFiAKGzK98bMScLnhhkZn52MHq
         UC1iHLYVYYSDzDqH/vs+sLOylXsMbuCq7gKC9QjbgiRaYA1SoegcZbLnhEhb7EEPS0HD
         MtOhlKETrcRa7UlMy7g0KDmGrfamk1cxlkym2vIiyhXNwiRdywF/W0mIh1XM3cwI26ym
         HlEw==
X-Gm-Message-State: AOAM532UHLqL6DPxUZp5eujsJFoef9ENMopmLKDKc0GPStPAYxTQNHHV
        8EZsr0zm8OH+eSeV+X8SgA5ysi4s8WUXg5ZtL0DD0Isx21c=
X-Google-Smtp-Source: ABdhPJzLOTEM8GLQe2KOR6TqCC2ZByezgmTfICW31/mQ5eoe92rVuDG/yXEf5P6jJxiWgYKVbom/HKB9DnfrVu4YTG8=
X-Received: by 2002:aca:280a:: with SMTP id 10mr943354oix.13.1621897273701;
 Mon, 24 May 2021 16:01:13 -0700 (PDT)
MIME-Version: 1.0
References: <20181031234928.144206-1-marcorr@google.com> <CALMp9eT-tKmt2nFy4eQ0bfLqHrZd9EruQ45p=AsR2aPWnj97gA@mail.gmail.com>
 <34bf7026-4f83-067e-f3d8-aad76f9cf624@redhat.com> <YKwsRhDWi3LZNSai@google.com>
In-Reply-To: <YKwsRhDWi3LZNSai@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 16:01:02 -0700
Message-ID: <CALMp9eQsTBp8D_Vtv4CFPzhb+QODDHjTH2aG8s-YSM_cgCEtVQ@mail.gmail.com>
Subject: Re: [kvm PATCH v6 0/2] shrink vcpu_vmx down to order 2
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Orr <marcorr@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 3:44 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 24, 2021, Paolo Bonzini wrote:
> > On 21/05/21 22:58, Jim Mattson wrote:
> > > On Wed, Oct 31, 2018 at 4:49 PM Marc Orr <marcorr@google.com> wrote:
> > > >
> > > > Compared to the last version, I've:
> > > > (1) dropped the vmalloc patches
> > > > (2) updated the kmem cache for the guest_fpu field in the kvm_vcpu_arch
> > > >      struct to be sized according to fpu_kernel_xstate_size
> > > > (3) Added minimum FPU checks in KVM's x86 init logic to avoid memory
> > > >      corruption issues.
> > > >
> > > > Marc Orr (2):
> > > >    kvm: x86: Use task structs fpu field for user
> > > >    kvm: x86: Dynamically allocate guest_fpu
> > > >
> > > >   arch/x86/include/asm/kvm_host.h | 10 +++---
> > > >   arch/x86/kvm/svm.c              | 10 ++++++
> > > >   arch/x86/kvm/vmx.c              | 10 ++++++
> > > >   arch/x86/kvm/x86.c              | 55 ++++++++++++++++++++++++---------
> > > >   4 files changed, 65 insertions(+), 20 deletions(-)
> > > >
> > > > --
> > >
> > > Whatever happened to this series?
> >
> > There was a question about the usage of kmem_cache_create_usercopy, and a v7
> > was never sent.
>
> What's that go to do with anything? :-D
>
>   b666a4b69739 ("kvm: x86: Dynamically allocate guest_fpu")
>   240c35a3783a ("kvm: x86: Use task structs fpu field for user")

So, that's what the series was trimmed down to. Thanks!

Did we still manage to get down to order 2?
