Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9660535BBCE
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 10:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbhDLIME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 04:12:04 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:1123 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbhDLIMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 04:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618215106; x=1649751106;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=Ag0UTwjEcsAkBUOr08LFu5cgXurDxKREvmhQ+cYG28Q=;
  b=J0irtF7w0kTufWJ9MT2Y3JIxzpN3NIC75GvIVwJ2FddpKMpyHnph1zXh
   +hanShNJE86f1/JwmeT5CVIVBwEEr2l89VgbvRAc9prLJQpB6p/uq+QAC
   yoiuZc9C1zvpEKUKhah815ShvUX/CV2kZqMOhy0Igl3uy6jZWR4FPIIFf
   s=;
X-IronPort-AV: E=Sophos;i="5.82,214,1613433600"; 
   d="scan'208";a="925220198"
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 12 Apr 2021 08:11:25 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 1623E1A07F2;
        Mon, 12 Apr 2021 08:11:23 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.207) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 12 Apr 2021 08:11:15 +0000
Date:   Mon, 12 Apr 2021 10:11:11 +0200
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
Message-ID: <20210412081110.GA16796@uc8bbc9586ea454.ant.amazon.com>
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
X-Originating-IP: [10.43.162.207]
X-ClientProxiedBy: EX13D20UWA001.ant.amazon.com (10.43.160.34) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 04:44:23PM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > On Thu, Apr 08, 2021 at 02:05:53PM +0200, Vitaly Kuznetsov wrote:
> >> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
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

Looks like guest_cpuid_has() check is for x86 CPU features only (if I'm
not mistaken) and I don't see a suitable alternative that looks into
vcpu->arch.cpuid_entries[]. So I plan to add a new method
hv_guest_cpuid_has() in hyperv.c to have this check; does that sound
right to you?

If you can give a quick go-ahead, I'll make the changes requested so
far and send v2 this series.

Thanks.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



