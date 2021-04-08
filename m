Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE33358900
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhDHP5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:57:10 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:45251 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhDHP5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 11:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617897418; x=1649433418;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=7PBS5e2WyJ69c6rfp53RALIlaSpOGlnG+OF+BW1TqaQ=;
  b=f2D5zbUqCCavbex5zny1t7OjGYnnpu9i681VvzGrMezI1eusc/HoJDKg
   VDXG5/nbaWFvLvEDmKJuThsUKdbFbP5aKUFWddT8XYZSr2ytmuxgTidks
   WRctx7hMhjPGnseH4UzWTUZd7IIOz9Q4KwKT5A078YZBu1oh8y1BEBP0y
   4=;
X-IronPort-AV: E=Sophos;i="5.82,206,1613433600"; 
   d="scan'208";a="126144841"
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 08 Apr 2021 15:56:50 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 81305A196F;
        Thu,  8 Apr 2021 15:56:43 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.161.102) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 8 Apr 2021 15:56:35 +0000
Date:   Thu, 8 Apr 2021 17:56:31 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Wei Liu <wei.liu@kernel.org>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Message-ID: <20210408155630.GD32315@u366d62d47e3651.ant.amazon.com>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-5-sidcha@amazon.de>
 <87blap7zha.fsf@vitty.brq.redhat.com>
 <20210408142053.GA10636@u366d62d47e3651.ant.amazon.com>
 <20210408154446.mtatlrheoq7hpoaq@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210408154446.mtatlrheoq7hpoaq@liuwe-devbox-debian-v2>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D29UWC001.ant.amazon.com (10.43.162.143) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 03:44:46PM +0000, Wei Liu wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Thu, Apr 08, 2021 at 04:20:54PM +0200, Siddharth Chandrasekaran wrote:
> > On Thu, Apr 08, 2021 at 02:05:53PM +0200, Vitaly Kuznetsov wrote:
> > > Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > >
> > > > Now that all extant hypercalls that can use XMM registers (based on
> > > > spec) for input/outputs are patched to support them, we can start
> > > > advertising this feature to guests.
> > > >
> > > > Cc: Alexander Graf <graf@amazon.com>
> > > > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> > > > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > > > ---
> > > >  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
> > > >  arch/x86/kvm/hyperv.c              | 1 +
> > > >  2 files changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > > > index e6cd3fee562b..1f160ef60509 100644
> > > > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > > > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > > > @@ -49,10 +49,10 @@
> > > >  /* Support for physical CPU dynamic partitioning events is available*/
> > > >  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE    BIT(3)
> > > >  /*
> > > > - * Support for passing hypercall input parameter block via XMM
> > > > + * Support for passing hypercall input and output parameter block via XMM
> > > >   * registers is available
> > > >   */
> > > > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
> > > > +#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4) | BIT(15)
> > >
> > > TLFS 6.0b states that there are two distinct bits for input and output:
> > >
> > > CPUID Leaf 0x40000003.EDX:
> > > Bit 4: support for passing hypercall input via XMM registers is available.
> > > Bit 15: support for returning hypercall output via XMM registers is available.
> > >
> > > and HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE is not currently used
> > > anywhere, I'd suggest we just rename
> > >
> > > HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE to HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE
> > > and add HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE (bit 15).
> >
> > That is how I had it initially; but then noticed that we would never
> > need to use either of them separately. So it seemed like a reasonable
> > abstraction to put them together.
> >
>
> They are two separate things in TLFS. Please use two macros here.

Ack, will split them.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



