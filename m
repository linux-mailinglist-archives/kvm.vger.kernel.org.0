Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279231CE957
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 01:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgEKXwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 19:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgEKXwH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 19:52:07 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0862AC061A0C
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 16:52:07 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id x5so2830089ioh.6
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 16:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E0ufWGYomYJh/CRjPmWsKjyHaGblzMVR+WH0oCRkU7E=;
        b=f/iY0vx2TUE477Mbf6Hol0ZEB/geLQUWTBNLPH99rC4gbt8DEL0wyNqLPFi7DoGFZr
         7ilzXRx1RjxnU4M6u/agvEQzIfHZW6rcOaLec7iRZfgdIs5es+hT/nY8/8XCkUuiSJCX
         1/Xo/s8W0u9nQcPmXTW+yClHZJpEfzP09WjThC38iJaPtMInIRKGDIW64VPwup1usYnG
         AKTAxx1ZlgIGoPscs5F0u5camKL1ghBq3FWoUTRWNGwRUydM7qXX5aa3q2mQfCE2lQvm
         QvM7wHQRSeTAI/OwdDkvYruA7jQMIm50ltwqi7LpJEkvov6e9xGs54dTSluoov5M6i7F
         Kggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0ufWGYomYJh/CRjPmWsKjyHaGblzMVR+WH0oCRkU7E=;
        b=ayTjsFL1CDYNTOoNW9hVFfbPm21aLnivJisPeqvIV+G2hDhtqsAJx/E3exjLRiN+iR
         eKlrXeu5JUqtOUZ8pWZYHhrPmkFaBtd/pob7RSnk7GK0UFXuS+BQ6/m1au/vqy1kVpRd
         1N/UlYydA0Pgvcm1ts9NLNTzYd/Th/i8RfeL1zGVcSnJZ+MPyhWFTkkke52fU2URH2sa
         mc+THmYT8zNBMu+k67Ns3lXwOBlmjw/Qpoipa1PUj0l8DEg9wHcMiiFml4OJXoYyoqVv
         BB6CYihaE2u4cS2fBsdoKglXJ4zlQNa9IFq71SPfoUOPNtxMrIQatRXdkZOC6zqsw89Z
         EJgg==
X-Gm-Message-State: AGi0PuYU3HTjxskkgccQc2LtkMNGJHSTZ+vD6lzEax7iOM11sVeHAyAK
        HzxUGSUY6c4on9uLU7znMPjLnAAoxkr8uNdb8ApsIg==
X-Google-Smtp-Source: APiQypIE6swexZI94wnqzlV1sfe5g/6LxPhc7dA+0DPciSA53MnNiKcoJyfwwEW85sZRfHbRaVKSPPW19M6MPYvWcsY=
X-Received: by 2002:a02:a60f:: with SMTP id c15mr7562634jam.24.1589241125957;
 Mon, 11 May 2020 16:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923999440.20128.4859351750654993810.stgit@naples-babu.amd.com>
In-Reply-To: <158923999440.20128.4859351750654993810.stgit@naples-babu.amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 11 May 2020 16:51:54 -0700
Message-ID: <CALMp9eTs4hYpDK+KzXEzaAptcfor+9f7cM9Yd9kvd5v27sdFRw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: x86: Move MPK feature detection to common code
To:     Babu Moger <babu.moger@amd.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mchehab+samsung@kernel.org, changbin.du@intel.com,
        Nadav Amit <namit@vmware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        yang.shi@linux.alibaba.com,
        Anthony Steinhauser <asteinhauser@google.com>,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>,
        Arjun Roy <arjunroy@google.com>, logang@deltatee.com,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        pawan.kumar.gupta@linux.intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Both Intel and AMD support (MPK) Memory Protection Key feature.
> Move the feature detection from VMX to the common code. It should
> work for both the platforms now.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/cpuid.c   |    4 +++-
>  arch/x86/kvm/vmx/vmx.c |    4 ----
>  2 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 901cd1fdecd9..3da7d6ea7574 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -278,6 +278,8 @@ void kvm_set_cpu_caps(void)
>  #ifdef CONFIG_X86_64
>         unsigned int f_gbpages = F(GBPAGES);
>         unsigned int f_lm = F(LM);
> +       /* PKU is not yet implemented for shadow paging. */
> +       unsigned int f_pku = tdp_enabled ? F(PKU) : 0;

I think we still want to require that OSPKE be set on the host before
exposing PKU to the guest.
