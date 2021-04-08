Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6893D3588E6
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhDHPw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:52:57 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:1942 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbhDHPwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 11:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617897164; x=1649433164;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=tCoTjc3fhRikP8oSBfxo2xNjB8YHkIgzZXaAXT2NF00=;
  b=AQLNSHXhfCRU1ALKWiVJVNdDba1G80EOQoCsivjh8vYhzbCkQQK+HEyn
   5lWY/RwvUqWrfMFDY9rybDqgfiKPMmSakZxdh6H9M6QdyTI1qkV4o6oZY
   JVm91AcZi+xneDOuv/gaQjrFln8ehK0REJLc0E2mgRLWvoQFlhMoiWKlY
   8=;
X-IronPort-AV: E=Sophos;i="5.82,206,1613433600"; 
   d="scan'208";a="101983967"
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 08 Apr 2021 15:52:35 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 2C79BA1B50;
        Thu,  8 Apr 2021 15:52:33 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.161.29) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 8 Apr 2021 15:52:25 +0000
Date:   Thu, 8 Apr 2021 17:52:21 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>
Message-ID: <20210408155220.GB32315@u366d62d47e3651.ant.amazon.com>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-5-sidcha@amazon.de>
 <87blap7zha.fsf@vitty.brq.redhat.com>
 <20210408142053.GA10636@u366d62d47e3651.ant.amazon.com>
 <8735w096pk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8735w096pk.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.29]
X-ClientProxiedBy: EX13D01UWA001.ant.amazon.com (10.43.160.60) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 04:44:23PM +0200, Vitaly Kuznetsov wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
>
> > On Thu, Apr 08, 2021 at 02:05:53PM +0200, Vitaly Kuznetsov wrote:
> >> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> >>
> >> > Now that all extant hypercalls that can use XMM registers (based on
> >> > spec) for input/outputs are patched to support them, we can start
> >> > advertising this feature to guests.
> >> >
> >> > Cc: Alexander Graf <graf@amazon.com>
> >> > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> >> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> >> > ---
> >> >  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
> >> >  arch/x86/kvm/hyperv.c              | 1 +
> >> >  2 files changed, 3 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> >> > index e6cd3fee562b..1f160ef60509 100644
> >> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> >> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> >> > @@ -49,10 +49,10 @@
> >> >  /* Support for physical CPU dynamic partitioning events is available*/
> >> >  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE    BIT(3)
> >> >  /*
> >> > - * Support for passing hypercall input parameter block via XMM
> >> > + * Support for passing hypercall input and output parameter block via XMM
> >> >   * registers is available
> >> >   */
> >> > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
> >> > +#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4) | BIT(15)
> >>
> >> TLFS 6.0b states that there are two distinct bits for input and output:
> >>
> >> CPUID Leaf 0x40000003.EDX:
> >> Bit 4: support for passing hypercall input via XMM registers is available.
> >> Bit 15: support for returning hypercall output via XMM registers is available.
> >>
> >> and HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE is not currently used
> >> anywhere, I'd suggest we just rename
> >>
> >> HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE to HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE
> >> and add HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE (bit 15).
> >
> > That is how I had it initially; but then noticed that we would never
> > need to use either of them separately. So it seemed like a reasonable
> > abstraction to put them together.
> >
>
> Actually, we may. In theory, KVM userspace may decide to expose just
> one of these two to the guest as it is not obliged to copy everything
> from KVM_GET_SUPPORTED_HV_CPUID so we will need separate
> guest_cpuid_has() checks.

Makes sense. I'll split them and add the checks.

> (This reminds me of something I didn't see in your series:
> we need to check that XMM hypercall parameters support was actually
> exposed to the guest as it is illegal for a guest to use it otherwise --
> and we will likely need two checks, for input and output).

We observed that Windows expects Hyper-V to support XMM params even if
we don't advertise this feature but if userspace wants to hide this
feature and the guest does it anyway, then it makes sense to treat it as
an illegal OP.

> Also, (and that's what triggered my comment) all other HV_ACCESS_* in
> kvm_get_hv_cpuid() are single bits so my first impression was that you
> forgot one bit, but then I saw that you combined them together.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



