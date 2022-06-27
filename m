Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D76255DEAD
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbiF0PdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbiF0PdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:33:01 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2CE1A072;
        Mon, 27 Jun 2022 08:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1656343980; x=1687879980;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=YclDPQ8xJyzX28733WQC4oZRwA3ZmY9Y4p4xJQQbjgQ=;
  b=UqryxeHxyVdzIVK22zNg8KUTeZEmXNLiHVpRGcEHLdix8PXJh12AthLt
   yHMZtAx1mCGIw484Z3FPBbdBlJJFD50npoMaGtN46gb2DlPTE4xsbiB1p
   a1RFlT4xY8bcu56W///BVJ0vU5e8xLHPauPqxtEZwqjNy4J1YamvS8hkK
   8=;
X-IronPort-AV: E=Sophos;i="5.92,226,1650931200"; 
   d="scan'208";a="205466353"
Subject: RE: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Thread-Topic: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 27 Jun 2022 15:32:42 +0000
Received: from EX13D32EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id D97A8816FA;
        Mon, 27 Jun 2022 15:32:37 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 15:32:36 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Mon, 27 Jun 2022 15:32:36 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Sean Christopherson <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Thread-Index: AQHYhhnGr94/Tz5Zr06wX+PVouePzq1bgNUAgAAEIQCAB+LOUA==
Date:   Mon, 27 Jun 2022 15:32:36 +0000
Message-ID: <0abf9f5de09e45ef9eb06b56bf16e3e6@EX13D32EUC003.ant.amazon.com>
References: <20220622092202.15548-1-pdurrant@amazon.com>
 <YrMqtHzNSean+qkh@google.com>
 <834f41a88e9f49b6b72d9d3672d702e5@EX13D32EUC003.ant.amazon.com>
In-Reply-To: <834f41a88e9f49b6b72d9d3672d702e5@EX13D32EUC003.ant.amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-12.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
[snip]
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 00e23dc518e0..8b45f9975e45 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3123,6 +3123,7 @@ static int kvm_guest_time_update(struct kvm_vcp=
u *v)
> > >       if (vcpu->xen.vcpu_time_info_cache.active)
> > >               kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_ca=
che, 0);
> > >       kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> > > +     kvm_xen_setup_tsc_info(v);
> >
> > This can be called inside this if statement, no?
> >
> >         if (unlikely(vcpu->hw_tsc_khz !=3D tgt_tsc_khz)) {
> >
> >         }
> >

I think it ought to be done whenever the shared copy of Xen's vcpu_info is =
updated (it will always match on real Xen) so unconditionally calling it he=
re seems reasonable.

> > >       return 0;
> > >  }
> > >
> > > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > > index 610beba35907..a016ff85264d 100644
> > > --- a/arch/x86/kvm/xen.c
> > > +++ b/arch/x86/kvm/xen.c
> > > @@ -10,6 +10,9 @@
> > >  #include "xen.h"
> > >  #include "hyperv.h"
> > >  #include "lapic.h"
> > > +#include "cpuid.h"
> > > +
> > > +#include <asm/xen/cpuid.h>
> > >
> > >  #include <linux/eventfd.h>
> > >  #include <linux/kvm_host.h>
> > > @@ -1855,3 +1858,41 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
> > >       if (kvm->arch.xen_hvm_config.msr)
> > >               static_branch_slow_dec_deferred(&kvm_xen_enabled);
> > >  }
> > > +
> > > +void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu)
> >
> > This is a very, very misleading name.  It does not "set" anything.  Giv=
en that
> > this patch adds "set" and "setup", I expected the "set" to you know, se=
t the CPUID
> > leaves and the "setup" to prepar for that, not the other way around.
> >
> > If the leaves really do need to be cached, kvm_xen_after_set_cpuid() is=
 probably
> > the least awful name.
> >

Ok I'll rename it kvm_xen_after_set_cpuid().

> > > +{
> > > +     u32 base =3D 0;
> > > +     u32 function;
> > > +
> > > +     for_each_possible_hypervisor_cpuid_base(function) {
> > > +             struct kvm_cpuid_entry2 *entry =3D kvm_find_cpuid_entry=
(vcpu, function, 0);
> > > +
> > > +             if (entry &&
> > > +                 entry->ebx =3D=3D XEN_CPUID_SIGNATURE_EBX &&
> > > +                 entry->ecx =3D=3D XEN_CPUID_SIGNATURE_ECX &&
> > > +                 entry->edx =3D=3D XEN_CPUID_SIGNATURE_EDX) {
> > > +                     base =3D function;
> > > +                     break;
> > > +             }
> > > +     }
> > > +     if (!base)
> > > +             return;
> > > +
> > > +     function =3D base | XEN_CPUID_LEAF(3);
> > > +     vcpu->arch.xen.tsc_info_1 =3D kvm_find_cpuid_entry(vcpu, functi=
on, 1);
> > > +     vcpu->arch.xen.tsc_info_2 =3D kvm_find_cpuid_entry(vcpu, functi=
on, 2);
> >
> > Is it really necessary to cache the leave?  Guest CPUID isn't optimized=
, but it's
> > not _that_ slow, and unless I'm missing something updating the TSC freq=
uency and
> > scaling info should be uncommon, i.e. not performance critical.

If we're updating the values in the leaves on every entry into the guest (a=
s with calls to kvm_setup_guest_pvclock()) then I think the cached pointers=
 are worthwhile.

  Paul

