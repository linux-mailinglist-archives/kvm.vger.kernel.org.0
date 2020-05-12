Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF321CFB70
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 18:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgELQ6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 12:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728485AbgELQ6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 12:58:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61260C061A0C
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 09:58:31 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s10so14760334iog.7
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 09:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mi+7tCnacK5Jy7mKSoTkTKMPF4P1Yw/xhRvgr46sMlM=;
        b=jIfCDoTCAH5GwV1mXMIJOCVzQltbxfLSL2kwDM+VFo2O6YeTQGFH2BU78YfEwjsvrb
         4rxQt2D+glH318nmIpf+5vcd2zwN545v0cLgOLi6VS0b/3fdjse1e1eetBOUlNitFvMg
         6/33/8kPY0dpWTHlZDuto+NTZ+fBEp6yUvMImxkedmb163IhZUQyiQU34uGx/nKMtLFb
         siNc0lCKAih382PVnwaTZQ2vQs3wx2ZpMxm0dAwZ3mY5WOraEYSw5IeNRpBV4dsChUef
         lhJIz+VzlU/sapXsBVC1xkcTCaWjXf7bvNqFkP9mCToh5p+GVUeJMlyOE8huIHTdGXIy
         Gzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mi+7tCnacK5Jy7mKSoTkTKMPF4P1Yw/xhRvgr46sMlM=;
        b=tvuxIPkDhi/SfXh1mMqjQHRNtVOHyZKVOq1j9smFxcgVzXx1MjRNGnNw6LTNGS+5gn
         5EzBihrP2v5FPPiUlcfx9FULmSLxthGxZ5CuotNYtWIwJbZwZhIai3V6UrLvENQb0tgQ
         ti9VwQmvJLP0oHvDfHsKBTZfsM1+eS8oVAMbsuNRXF38Y+A+UWY18ek1of48o/cO2AOA
         67fsCiwgvlJWdK1XOFTnH/hfxWej1q0/ia/Zm+2bl7c6npRRwcLJZ9xyUG29gpshbzMd
         BI1LEhjx+P8uAbdwCT2hTPHFFyvww3nUI38fYjllMEVFxEiaOE46pP/S/kdKv4f+LCNS
         ye7A==
X-Gm-Message-State: AGi0PubyGUhBtbcehay8JF9DNWINLklo76QPAebEpVSjlLF9CRjijMWt
        nZLfNEDnTAOjqY0BPlLBQXDScKHyVxtUn5AvHVgydA==
X-Google-Smtp-Source: APiQypKx5qJnwBpmI84ld8f5gXdVE2PTGwixpadOnUEFMdACgzu6Lq+nVSrPX/5KZQX86XCMmGCR6S8ABb1ycIYUz6A=
X-Received: by 2002:a02:a60f:: with SMTP id c15mr11263022jam.24.1589302710267;
 Tue, 12 May 2020 09:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923999440.20128.4859351750654993810.stgit@naples-babu.amd.com>
 <CALMp9eTs4hYpDK+KzXEzaAptcfor+9f7cM9Yd9kvd5v27sdFRw@mail.gmail.com> <2fb5fd86-5202-f61b-fd55-b3554c5826da@amd.com>
In-Reply-To: <2fb5fd86-5202-f61b-fd55-b3554c5826da@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 12 May 2020 09:58:19 -0700
Message-ID: <CALMp9eRT69LWGE8dZVuLv2mxgc_R3W1SnPswHkhS8K0ZUX_B-Q@mail.gmail.com>
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

On Tue, May 12, 2020 at 8:12 AM Babu Moger <babu.moger@amd.com> wrote:
>
>
>
> On 5/11/20 6:51 PM, Jim Mattson wrote:
> > On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
> >>
> >> Both Intel and AMD support (MPK) Memory Protection Key feature.
> >> Move the feature detection from VMX to the common code. It should
> >> work for both the platforms now.
> >>
> >> Signed-off-by: Babu Moger <babu.moger@amd.com>
> >> ---
> >>  arch/x86/kvm/cpuid.c   |    4 +++-
> >>  arch/x86/kvm/vmx/vmx.c |    4 ----
> >>  2 files changed, 3 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >> index 901cd1fdecd9..3da7d6ea7574 100644
> >> --- a/arch/x86/kvm/cpuid.c
> >> +++ b/arch/x86/kvm/cpuid.c
> >> @@ -278,6 +278,8 @@ void kvm_set_cpu_caps(void)
> >>  #ifdef CONFIG_X86_64
> >>         unsigned int f_gbpages = F(GBPAGES);
> >>         unsigned int f_lm = F(LM);
> >> +       /* PKU is not yet implemented for shadow paging. */
> >> +       unsigned int f_pku = tdp_enabled ? F(PKU) : 0;
> >
> > I think we still want to require that OSPKE be set on the host before
> > exposing PKU to the guest.
> >
>
> Ok I can add this check.
>
> +       unsigned int f_pku = tdp_enabled && F(OSPKE)? F(PKU) : 0;

That doesn't do what you think it does. F(OSPKE) is a non-zero
constant, so that conjunct is always true.
