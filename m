Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2396455485F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347349AbiFVJuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 05:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238999AbiFVJuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 05:50:32 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89D6396BB;
        Wed, 22 Jun 2022 02:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1655891432; x=1687427432;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=9Tz0zIdZgsf0C9SLOFrBkPQ8E0+eB/2/PYBqn7l5078=;
  b=JOwxrYcKWvKsT+wriIUa3xvmAmUo7U+QIaMNt45bXmwSvm/D82MBYerW
   H3gE2mDyetYaubpXqaZDjRD6Bj66f/V53YJ2g2/2aRsd/wdlsXutvcvYA
   z2fkflSy1wyBAbPK9U4alDYL4tp3fuFaV3CSMtUJ4Qo+ou4bkImqDwF/h
   4=;
X-IronPort-AV: E=Sophos;i="5.92,212,1650931200"; 
   d="scan'208";a="204236924"
Subject: RE: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Thread-Topic: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 22 Jun 2022 09:50:13 +0000
Received: from EX13D32EUC004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-a264e6fe.us-west-2.amazon.com (Postfix) with ESMTPS id AA59F42EA5;
        Wed, 22 Jun 2022 09:50:11 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC004.ant.amazon.com (10.43.164.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 22 Jun 2022 09:50:10 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Wed, 22 Jun 2022 09:50:10 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHYhhnGr94/Tz5Zr06wX+PVouePzq1bK84AgAACmFA=
Date:   Wed, 22 Jun 2022 09:50:10 +0000
Message-ID: <e32174b183584904925f8217736acebb@EX13D32EUC003.ant.amazon.com>
References: <20220622092202.15548-1-pdurrant@amazon.com>
 <87wnd9xcin.fsf@redhat.com>
In-Reply-To: <87wnd9xcin.fsf@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: 22 June 2022 10:40
> To: Durrant, Paul <pdurrant@amazon.co.uk>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Sean Christopherson <seanjc@goog=
le.com>; Wanpeng Li
> <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Joerg Roedel =
<joro@8bytes.org>; Thomas
> Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav P=
etkov <bp@alien8.de>; Dave
> Hansen <dave.hansen@linux.intel.com>; H. Peter Anvin <hpa@zytor.com>; x86=
@kernel.org;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [EXTERNAL][PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc=
 info) sub-leaves, if present
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open
> attachments unless you can confirm the sender and know the content is saf=
e.
>=20
>=20
>=20
> Paul Durrant <pdurrant@amazon.com> writes:
>=20
> > The scaling information in sub-leaf 1 should match the values in the
> > 'vcpu_info' sub-structure 'time_info' (a.k.a. pvclock_vcpu_time_info) w=
hich
> > is shared with the guest. The offset values are not set since a TSC off=
set
> > is already applied.
> > The host TSC frequency should also be set in sub-leaf 2.
> >
> > This patch adds a new kvm_xen_set_cpuid() function that scans for the
> > relevant CPUID leaf when the CPUID information is updated by the VMM an=
d
> > stashes pointers to the sub-leaves in the kvm_vcpu_xen structure.
> > The values are then updated by a call to the, also new,
> > kvm_xen_setup_tsc_info() function made at the end of
> > kvm_guest_time_update() just before entering the guest.
> >
> > Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/cpuid.c            |  2 ++
> >  arch/x86/kvm/x86.c              |  1 +
> >  arch/x86/kvm/xen.c              | 41 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/xen.h              | 10 ++++++++
> >  5 files changed, 56 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 1038ccb7056a..f77a4940542f 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -638,6 +638,8 @@ struct kvm_vcpu_xen {
> >       struct hrtimer timer;
> >       int poll_evtchn;
> >       struct timer_list poll_timer;
> > +     struct kvm_cpuid_entry2 *tsc_info_1;
> > +     struct kvm_cpuid_entry2 *tsc_info_2;
> >  };
> >
> >  struct kvm_vcpu_arch {
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index d47222ab8e6e..eb6cd88c974a 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -25,6 +25,7 @@
> >  #include "mmu.h"
> >  #include "trace.h"
> >  #include "pmu.h"
> > +#include "xen.h"
> >
> >  /*
> >   * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't ne=
ed to be
> > @@ -310,6 +311,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcp=
u *vcpu)
> >           __cr4_reserved_bits(guest_cpuid_has, vcpu);
> >
> >       kvm_hv_set_cpuid(vcpu);
> > +     kvm_xen_set_cpuid(vcpu);
> >
> >       /* Invoke the vendor callback only after the above state is updat=
ed. */
> >       static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 00e23dc518e0..8b45f9975e45 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3123,6 +3123,7 @@ static int kvm_guest_time_update(struct kvm_vcpu =
*v)
> >       if (vcpu->xen.vcpu_time_info_cache.active)
> >               kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cach=
e, 0);
> >       kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> > +     kvm_xen_setup_tsc_info(v);
> >       return 0;
> >  }
> >
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index 610beba35907..a016ff85264d 100644
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -10,6 +10,9 @@
> >  #include "xen.h"
> >  #include "hyperv.h"
> >  #include "lapic.h"
> > +#include "cpuid.h"
> > +
> > +#include <asm/xen/cpuid.h>
> >
> >  #include <linux/eventfd.h>
> >  #include <linux/kvm_host.h>
> > @@ -1855,3 +1858,41 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
> >       if (kvm->arch.xen_hvm_config.msr)
> >               static_branch_slow_dec_deferred(&kvm_xen_enabled);
> >  }
> > +
> > +void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 base =3D 0;
> > +     u32 function;
> > +
> > +     for_each_possible_hypervisor_cpuid_base(function) {
> > +             struct kvm_cpuid_entry2 *entry =3D kvm_find_cpuid_entry(v=
cpu, function, 0);
> > +
> > +             if (entry &&
> > +                 entry->ebx =3D=3D XEN_CPUID_SIGNATURE_EBX &&
> > +                 entry->ecx =3D=3D XEN_CPUID_SIGNATURE_ECX &&
> > +                 entry->edx =3D=3D XEN_CPUID_SIGNATURE_EDX) {
> > +                     base =3D function;
> > +                     break;
> > +             }
> > +     }
> > +     if (!base)
> > +             return;
> > +
> > +     function =3D base | XEN_CPUID_LEAF(3);
> > +     vcpu->arch.xen.tsc_info_1 =3D kvm_find_cpuid_entry(vcpu, function=
, 1);
> > +     vcpu->arch.xen.tsc_info_2 =3D kvm_find_cpuid_entry(vcpu, function=
, 2);
> > +}
>=20
> Imagine the following scenario: CPUID data was supplied with Xen CPUID
> leaves first and then got updated with new information which doesn't
> have Xen CPUID info (e.g. has Hyper-V signature instead of Xen in the
> same 0x40000000 leaf). Won't arch.xen.tsc_info_1/arch.xen.tsc_info_2
> pointers become dangling here after we free the old CPUID data ...
>=20
> > +
> > +void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_cpuid_entry2 *entry =3D vcpu->arch.xen.tsc_info_1;
> > +
> > +     if (entry) {
> > +             entry->ecx =3D vcpu->arch.hv_clock.tsc_to_system_mul;
> > +             entry->edx =3D vcpu->arch.hv_clock.tsc_shift;
>=20
> ... just to crash everything here?

Yes, you are indeed correct. I'd never considered the leaves being removed =
from the set but the code should cope with this. V2 shortly.

  Paul

>=20
> > +     }
> > +
> > +     entry =3D vcpu->arch.xen.tsc_info_2;
> > +     if (entry)
> > +             entry->eax =3D vcpu->arch.hw_tsc_khz;
> > +}
> > diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> > index 532a535a9e99..1afb663318a9 100644
> > --- a/arch/x86/kvm/xen.h
> > +++ b/arch/x86/kvm/xen.h
> > @@ -32,6 +32,8 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe=
,
> >  int kvm_xen_setup_evtchn(struct kvm *kvm,
> >                        struct kvm_kernel_irq_routing_entry *e,
> >                        const struct kvm_irq_routing_entry *ue);
> > +void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu);
> > +void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu);
> >
> >  static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
> >  {
> > @@ -135,6 +137,14 @@ static inline bool kvm_xen_timer_enabled(struct kv=
m_vcpu *vcpu)
> >  {
> >       return false;
> >  }
> > +
> > +static inline void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +}
> > +
> > +static inline void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu)
> > +{
> > +}
> >  #endif
> >
> >  int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
>=20
> --
> Vitaly

