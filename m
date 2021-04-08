Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94B35870C
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 16:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhDHOVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 10:21:35 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:57534 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhDHOVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 10:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617891681; x=1649427681;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=dTvu0dXT7xw3uuDTIqR63vsmGvsn9MVKfGVQJlXp8PY=;
  b=o57F5JCcsR9cgWlMc0oNe9ifrHLxQWZM9U22Ka7ueC2Jrnq0HismTQy/
   Ajt8Do6UYuBuTASMAqn41SpkgAYpX1XL03n37Mne3qOVmS06cZM0zG5zC
   L2PM7OBc/VUo61w0Ma7nVoV4aK6LD/U6LL9CDtE4bPOqAfsCTVwkIm1kP
   A=;
X-IronPort-AV: E=Sophos;i="5.82,206,1613433600"; 
   d="scan'208";a="101951940"
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 08 Apr 2021 14:21:12 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 6FB1DA03EB;
        Thu,  8 Apr 2021 14:21:06 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.48) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 8 Apr 2021 14:20:58 +0000
Date:   Thu, 8 Apr 2021 16:20:54 +0200
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
Message-ID: <20210408142053.GA10636@u366d62d47e3651.ant.amazon.com>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-5-sidcha@amazon.de>
 <87blap7zha.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87blap7zha.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D24UWA002.ant.amazon.com (10.43.160.200) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 02:05:53PM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
>
> > Now that all extant hypercalls that can use XMM registers (based on
> > spec) for input/outputs are patched to support them, we can start
> > advertising this feature to guests.
> >
> > Cc: Alexander Graf <graf@amazon.com>
> > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > ---
> >  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
> >  arch/x86/kvm/hyperv.c              | 1 +
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > index e6cd3fee562b..1f160ef60509 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -49,10 +49,10 @@
> >  /* Support for physical CPU dynamic partitioning events is available*/
> >  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE    BIT(3)
> >  /*
> > - * Support for passing hypercall input parameter block via XMM
> > + * Support for passing hypercall input and output parameter block via XMM
> >   * registers is available
> >   */
> > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
> > +#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4) | BIT(15)
>
> TLFS 6.0b states that there are two distinct bits for input and output:
>
> CPUID Leaf 0x40000003.EDX:
> Bit 4: support for passing hypercall input via XMM registers is available.
> Bit 15: support for returning hypercall output via XMM registers is available.
>
> and HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE is not currently used
> anywhere, I'd suggest we just rename
>
> HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE to HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE
> and add HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE (bit 15).

That is how I had it initially; but then noticed that we would never
need to use either of them separately. So it seemed like a reasonable
abstraction to put them together.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



