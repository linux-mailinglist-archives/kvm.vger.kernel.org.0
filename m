Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34352292D29
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgJSRx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:53:28 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:51958 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgJSRx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 13:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1603130007; x=1634666007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=t1VzdQy2NBR4DKX4hGEZc6mXqEZFpQga7kkpLT4rmc8=;
  b=TCg8FOzew02DO5a13rWdSKO9NZtRrKoRi2GGGTmJvVkWStJneIQOUy3O
   37CM/nP0UZtYQYEMJ6gluV+L1evw+meBp0AFkRi9Lm9aPPwdLowh/UKKI
   5ZMeVkCNzKIlVL/8mHlc1R1EE510MZQexFjttQViAd1rGCYrJpRcL+I8j
   w=;
X-IronPort-AV: E=Sophos;i="5.77,395,1596499200"; 
   d="scan'208";a="60609562"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-76e0922c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Oct 2020 17:45:59 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with ESMTPS id 2ED3EA86EB;
        Mon, 19 Oct 2020 17:45:55 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Oct 2020 17:45:54 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 19 Oct 2020 17:45:54 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1497.006;
 Mon, 19 Oct 2020 17:45:54 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
Thread-Topic: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
Thread-Index: AQHWpj+x3+JT+Cl9gkCqCDyMCFO5/w==
Date:   Mon, 19 Oct 2020 17:45:54 +0000
Message-ID: <618E2129-7AB5-4F0D-A6C9-E782937FE935@amazon.de>
References: <20201019170519.1855564-1-pbonzini@redhat.com>
In-Reply-To: <20201019170519.1855564-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 19.10.2020 um 19:08 schrieb Paolo Bonzini <pbonzini@redhat.com>:
> =

> Allowing userspace to intercept reads to x2APIC MSRs when APICV is
> fully enabled for the guest simply can't work.   But more in general,
> if the LAPIC is in-kernel, allowing accessed by userspace would be very
> confusing.  If userspace wants to intercept x2APIC MSRs, then it should
> first disable in-kernel APIC.
> =

> We could in principle allow userspace to intercept reads and writes to TP=
R,
> and writes to EOI and SELF_IPI, but while that could be made it work, it
> would still be silly.
> =

> Cc: Alexander Graf <graf@amazon.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> arch/x86/kvm/x86.c | 17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
> =

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c4015a43cc8a..0faf733538f4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5246,6 +5246,13 @@ static int kvm_add_msr_filter(struct kvm *kvm, str=
uct kvm_msr_filter_range *user
>        return r;
> }
> =

> +static bool range_overlaps_x2apic(struct kvm_msr_filter_range *range)
> +{
> +       u32 start =3D range->base;
> +       u32 end =3D start + range->nmsrs;
> +       return start <=3D 0x8ff && end > 0x800;
> +}
> +
> static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
> {
>        struct kvm_msr_filter __user *user_msr_filter =3D argp;
> @@ -5257,6 +5264,16 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm =
*kvm, void __user *argp)
>        if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
>                return -EFAULT;
> =

> +       /*
> +        * In principle it would be possible to trap x2apic ranges
> +        * if !lapic_in_kernel.  This however would be complicated
> +        * because KVM_X86_SET_MSR_FILTER can be called before
> +        * KVM_CREATE_IRQCHIP or KVM_ENABLE_CAP.
> +        */
> +       for (i =3D 0; i < ARRAY_SIZE(filter.ranges); i++)
> +               if (range_overlaps_x2apic(&filter.ranges[i]))
> +                       return -EINVAL;

What if the default action of the filter is to "deny"? Then only an MSR fil=
ter to allow access to x2apic MSRs would make the full filtering logic adhe=
re to the constraints, no?

Also, this really deserves a comment in the API documentation :).

In fact, I think a pure comment in documentation is enough. Just make x2api=
c && filter on them "undefined behavior".


Alex

> +
>        kvm_clear_msr_filter(kvm);
> =

>        default_allow =3D !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
> --
> 2.26.2
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



