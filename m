Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EAD554EAD
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 17:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358182AbiFVPHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 11:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343920AbiFVPHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 11:07:03 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0E53EA8C;
        Wed, 22 Jun 2022 08:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1655910424; x=1687446424;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=6G8WM8QiGLd5SwFwWo6GYeAz8Aw25bmCmGy/37elBWs=;
  b=veZEm3AfW5+t615Ei3vJpI3TTW88KYnmSWyEErrs9Qk44p806trI/jxg
   xihCqhSI3Tl0D8lTGa5xxLtTdDofJMD5CGE2HUNJr+3tBG5dco+m31Sc7
   FsuwXpNzTdRHXm1MNmQHUQhV0MHgQX84ZiHlo4D08K9yI29r5G+mASWPG
   o=;
X-IronPort-AV: E=Sophos;i="5.92,212,1650931200"; 
   d="scan'208";a="100716768"
Subject: RE: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Thread-Topic: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 22 Jun 2022 15:01:55 +0000
Received: from EX13D32EUC004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-f20e0c8b.us-east-1.amazon.com (Postfix) with ESMTPS id 46C6C816F7;
        Wed, 22 Jun 2022 15:01:50 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC004.ant.amazon.com (10.43.164.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 22 Jun 2022 15:01:48 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Wed, 22 Jun 2022 15:01:49 +0000
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
Thread-Index: AQHYhhnGr94/Tz5Zr06wX+PVouePzq1bgNUAgAAEIQA=
Date:   Wed, 22 Jun 2022 15:01:49 +0000
Message-ID: <834f41a88e9f49b6b72d9d3672d702e5@EX13D32EUC003.ant.amazon.com>
References: <20220622092202.15548-1-pdurrant@amazon.com>
 <YrMqtHzNSean+qkh@google.com>
In-Reply-To: <YrMqtHzNSean+qkh@google.com>
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
> From: Sean Christopherson <seanjc@google.com>
> Sent: 22 June 2022 15:44
> To: Durrant, Paul <pdurrant@amazon.co.uk>
> Cc: x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Pa=
olo Bonzini
> <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li=
 <wanpengli@tencent.com>; Jim
> Mattson <jmattson@google.com>; Joerg Roedel <joro@8bytes.org>; Thomas Gle=
ixner <tglx@linutronix.de>;
> Ingo Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hans=
en
> <dave.hansen@linux.intel.com>; H. Peter Anvin <hpa@zytor.com>
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
> On Wed, Jun 22, 2022, Paul Durrant wrote:
> > The scaling information in sub-leaf 1 should match the values in the
> > 'vcpu_info' sub-structure 'time_info' (a.k.a. pvclock_vcpu_time_info) w=
hich
> > is shared with the guest. The offset values are not set since a TSC off=
set
> > is already applied.
> > The host TSC frequency should also be set in sub-leaf 2.
>=20
> Explain why this is KVM's problem, i.e. why userspace is unable to set th=
e correct
> values.

Ok, I'll explain that there is no interface for the VMM to acquire the time=
_info.

>=20
> > This patch adds a new kvm_xen_set_cpuid() function that scans for the
>=20
> Please avoid "This patch".
>=20
> > relevant CPUID leaf when the CPUID information is updated by the VMM an=
d
> > stashes pointers to the sub-leaves in the kvm_vcpu_xen structure.
> > The values are then updated by a call to the, also new,
> > kvm_xen_setup_tsc_info() function made at the end of
> > kvm_guest_time_update() just before entering the guest.
>=20
> This is not a helpful paragraph, it provides zero information that isn't =
obvious
> from the code.
>=20
> The changelog should read something like:
>=20
>   Update Xen CPUID leaves that expose TSC frequency and scaling informati=
on
>   to the guest <blah blah blah>.  Cache the leaves <blah blah blah>.
>=20

Ok, sure.

  Paul

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
>=20
> This can be called inside this if statement, no?
>=20
>         if (unlikely(vcpu->hw_tsc_khz !=3D tgt_tsc_khz)) {
>=20
>         }
>=20
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
>=20
> This is a very, very misleading name.  It does not "set" anything.  Given=
 that
> this patch adds "set" and "setup", I expected the "set" to you know, set =
the CPUID
> leaves and the "setup" to prepar for that, not the other way around.
>=20
> If the leaves really do need to be cached, kvm_xen_after_set_cpuid() is p=
robably
> the least awful name.
>=20
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
>=20
> Is it really necessary to cache the leave?  Guest CPUID isn't optimized, =
but it's
> not _that_ slow, and unless I'm missing something updating the TSC freque=
ncy and
> scaling info should be uncommon, i.e. not performance critical.
