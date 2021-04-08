Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660B13588C8
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhDHPpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:45:03 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:50889 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhDHPpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 11:45:01 -0400
Received: by mail-wm1-f47.google.com with SMTP id a76so1462564wme.0;
        Thu, 08 Apr 2021 08:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gOL3sTNX0RwE6pH2lJFzbMjnBq2QDb8tnzvHvFcdpy4=;
        b=W1MvREWKix4lsduPy5Hw6cjgFcIEk6YfOXc9fWT0fj3mVWr1+Tt1B7TWHI1myJbfho
         n+M/iZLgZ5EnbVi7t5bV9qb446HBzEs3sTvwlV2w1v0WAAxklex1JivckLqywDT9mMNn
         JCZMO3jYQkEkRYnfpacXA4P4lTPErZgZjub+cZjH4HDuBF88V2x4nRJ2Ap5BCPiC5ozZ
         ihE3CqK36cqd54FEjZy6qaAqhwlza6wuFNT1si/HPyeIe0h+PyHTCj4mroEBHIroUYFI
         6AsQfRQhwESvB8t638TpecpI7P1/3rmBcBynnSwttY6I6wmGIoqdqaoQYHGIGsXKU7cT
         rHnw==
X-Gm-Message-State: AOAM530rX2qCwfQM+ysgzk8kXQPKDYrVn2Wx29pYbdQ9Wan5cWG288/v
        e58L5wt8w2sMjmBbeDfNhJs=
X-Google-Smtp-Source: ABdhPJwSpb5Stp3amI2L7Io5ucL56hT0ZnW8d2a3faPDA5PjlUX6ZhbOnkBbhPE1ciDMRe6iK9ZU9A==
X-Received: by 2002:a1c:b007:: with SMTP id z7mr9268464wme.14.1617896688085;
        Thu, 08 Apr 2021 08:44:48 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id v7sm1285626wrs.2.2021.04.08.08.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 08:44:47 -0700 (PDT)
Date:   Thu, 8 Apr 2021 15:44:46 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM
 hypercalls
Message-ID: <20210408154446.mtatlrheoq7hpoaq@liuwe-devbox-debian-v2>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-5-sidcha@amazon.de>
 <87blap7zha.fsf@vitty.brq.redhat.com>
 <20210408142053.GA10636@u366d62d47e3651.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408142053.GA10636@u366d62d47e3651.ant.amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 04:20:54PM +0200, Siddharth Chandrasekaran wrote:
> On Thu, Apr 08, 2021 at 02:05:53PM +0200, Vitaly Kuznetsov wrote:
> > Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> >
> > > Now that all extant hypercalls that can use XMM registers (based on
> > > spec) for input/outputs are patched to support them, we can start
> > > advertising this feature to guests.
> > >
> > > Cc: Alexander Graf <graf@amazon.com>
> > > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> > > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > > ---
> > >  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
> > >  arch/x86/kvm/hyperv.c              | 1 +
> > >  2 files changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > > index e6cd3fee562b..1f160ef60509 100644
> > > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > > @@ -49,10 +49,10 @@
> > >  /* Support for physical CPU dynamic partitioning events is available*/
> > >  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE    BIT(3)
> > >  /*
> > > - * Support for passing hypercall input parameter block via XMM
> > > + * Support for passing hypercall input and output parameter block via XMM
> > >   * registers is available
> > >   */
> > > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
> > > +#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4) | BIT(15)
> >
> > TLFS 6.0b states that there are two distinct bits for input and output:
> >
> > CPUID Leaf 0x40000003.EDX:
> > Bit 4: support for passing hypercall input via XMM registers is available.
> > Bit 15: support for returning hypercall output via XMM registers is available.
> >
> > and HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE is not currently used
> > anywhere, I'd suggest we just rename
> >
> > HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE to HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE
> > and add HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE (bit 15).
> 
> That is how I had it initially; but then noticed that we would never
> need to use either of them separately. So it seemed like a reasonable
> abstraction to put them together.
> 

They are two separate things in TLFS. Please use two macros here.

Wei.
