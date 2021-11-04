Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBF6445AB0
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 20:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhKDTxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 15:53:14 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:12151 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhKDTxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 15:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1636055435; x=1667591435;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=4wLNOsAXq33U8fwf0IhAua+TAfRflUq3TBWWazJCEUo=;
  b=f6+jL6OhxUgolA7SA9W6pX88izI/rKLkDIyaKIOzKnjUCLkMhfYacQX2
   kXsHyEPaOeA9t1+XYdkeG65cgzffu/9rm0X6KUSCm2hyutWZHjbqcZwUl
   oeBn6rHj4M0akl8QU48ZZkeIGsuXoSoB44H1V6T5PxKZwpqYxKFjxCGa4
   Y=;
X-IronPort-AV: E=Sophos;i="5.87,209,1631577600"; 
   d="scan'208";a="149712937"
Subject: RE: [PATCH] KVM: x86: Make sure KVM_CPUID_FEATURES really are
 KVM_CPUID_FEATURES
Thread-Topic: [PATCH] KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM_CPUID_FEATURES
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 04 Nov 2021 19:50:24 +0000
Received: from EX13D32EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com (Postfix) with ESMTPS id B0E8F4128A;
        Thu,  4 Nov 2021 19:50:22 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC003.ant.amazon.com (10.43.164.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Thu, 4 Nov 2021 19:50:21 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.024;
 Thu, 4 Nov 2021 19:50:21 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Sean Christopherson <seanjc@google.com>,
        Paul Durrant <paul@xen.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Thread-Index: AQHX0aouxkG+ioMQR0uRyvEZV2HbFKvzv2QAgAAFgKA=
Date:   Thu, 4 Nov 2021 19:50:21 +0000
Message-ID: <90c513d31a1b41daae1a642d2f5c72b0@EX13D32EUC003.ant.amazon.com>
References: <20211104183020.4341-1-paul@xen.org> <YYQzDLLE4WavR2Q6@google.com>
In-Reply-To: <YYQzDLLE4WavR2Q6@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.145]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 04 November 2021 19:23
> To: Paul Durrant <paul@xen.org>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Durrant, Paul <pdu=
rrant@amazon.co.uk>; Paolo
> Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wa=
npeng Li
> <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Joerg Roedel =
<joro@8bytes.org>
> Subject: RE: [EXTERNAL] [PATCH] KVM: x86: Make sure KVM_CPUID_FEATURES re=
ally are KVM_CPUID_FEATURES
>=20
> On Thu, Nov 04, 2021, Paul Durrant wrote:
> > From: Paul Durrant <pdurrant@amazon.com>
> >
> > Currently when kvm_update_cpuid_runtime() runs, it assumes that the
> > KVM_CPUID_FEATURES leaf is located at 0x40000001. This is not true,
> > however, if Hyper-V support is enabled. In this case the KVM leaves wil=
l
> > be offset.
> >
> > This patch introdues as new 'kvm_cpuid_base' field into struct
> > kvm_vcpu_arch to track the location of the KVM leaves and function
> > kvm_update_cpuid_base() (called from kvm_update_cpuid_runtime()) to loc=
ate
> > the leaves using the 'KVMKVMKVM\0\0\0' signature. Adjustment of
> > KVM_CPUID_FEATURES will hence now target the correct leaf.
> >
> > Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> > ---
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: Wanpeng Li <wanpengli@tencent.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
>=20
> scripts/get_maintainer.pl is your friend :-)

That's what I used, but thought it prudent to trim the list to just KVM rev=
iewers.

>=20
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/cpuid.c            | 50 +++++++++++++++++++++++++++++----
> >  2 files changed, 46 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 88fce6ab4bbd..21133ffa23e9 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -725,6 +725,7 @@ struct kvm_vcpu_arch {
> >
> >       int cpuid_nent;
> >       struct kvm_cpuid_entry2 *cpuid_entries;
> > +     u32 kvm_cpuid_base;
> >
> >       u64 reserved_gpa_bits;
> >       int maxphyaddr;
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 2d70edb0f323..2cfb8ec4f570 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -99,11 +99,46 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 =
*entries, int nent)
> >       return 0;
> >  }
> >
> > +static void kvm_update_cpuid_base(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 function;
> > +
> > +     for (function =3D 0x40000000; function < 0x40010000; function +=
=3D 0x100) {
>=20
> No small part of me wants to turn hypervisor_cpuid_base() into a macro, b=
ut that's
> probably more pain than gain.  But I do think it would be worth providing=
 a macro
> to iterate over possible bases and share that with the guest-side code.
>=20

Ok.

> > +             struct kvm_cpuid_entry2 *best =3D kvm_find_cpuid_entry(vc=
pu, function, 0);
>=20
> Declare "struct kvm_cpuid_entry2 *best" outside of the loop to shorten th=
is line.
> I'd also vote to rename "best" to "entry".  KVM's "best" terminology is a=
 remnant
> of misguided logic that applied Intel's bizarre out-of-range behavior to =
internal
> KVM lookups.
>=20

Sure.

> > +
> > +             if (best) {
> > +                     char signature[12];
> > +
> > +                     *(u32 *)&signature[0] =3D best->ebx;
>=20
> Just make signature a u32[3], then the casting craziness goes away.
>=20

True.

> > +                     *(u32 *)&signature[4] =3D best->ecx;
> > +                     *(u32 *)&signature[8] =3D best->edx;
> > +
> > +                     if (!memcmp(signature, "KVMKVMKVM\0\0\0", 12))
>=20
> The "KVMKVMKVM\0\0\0" magic string belongs in a #define that's shared wit=
h the
> guest-side code.  I
>=20

It's in a few places, so yes a #define is a good idea.

> > +                             break;
> > +             }
> > +     }
> > +     vcpu->arch.kvm_cpuid_base =3D function;
>=20
> Unconditionally setting kvm_cpuid_base is silly because then kvm_get_cpui=
d_base()
> needs to check multiple "error" values.
>=20
> E.g. all of the above can be done as:
>=20
>         struct kvm_cpuid_entry2 *entry;
>         u32 base, signature[3];
>=20
>         vcpu->arch.kvm_cpuid_base =3D 0;
>=20
>         virt_for_each_possible_hypervisor_base(base) {
>                 entry =3D kvm_find_cpuid_entry(vcpu, base, 0);
>                 if (!entry)
>                         continue;
>=20
>                 signature[0] =3D entry->ebx;
>                 signature[1] =3D entry->ecx;
>                 signature[2] =3D entry->edx;
>=20
>                 if (!memcmp(signature, KVM_CPUID_SIG, sizeof(signature)))=
 {
>                         vcpu->arch.kvm_cpuid_base =3D base;
>                         break;
>                 }
>         }
>=20
> > +}
> > +
> > +static inline bool kvm_get_cpuid_base(struct kvm_vcpu *vcpu, u32 *func=
tion)
> > +{
> > +     if (vcpu->arch.kvm_cpuid_base < 0x40000000 ||
> > +         vcpu->arch.kvm_cpuid_base >=3D 0x40010000)
> > +             return false;
> > +
> > +     *function =3D vcpu->arch.kvm_cpuid_base;
> > +     return true;
>=20
> If '0' is the "doesn't exist" value, then this helper goes away.
>=20
> > +}
> > +
> >  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
> >  {
> > +     u32 base;
> >       struct kvm_cpuid_entry2 *best;
> >
> > -     best =3D kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > +     if (!kvm_get_cpuid_base(vcpu, &base))
> > +             return;
>=20
> ... and then this becomes:
>=20
>         if (!vcpu->arch.kvm_cpuid_base)
>                 return;
>=20

Ok.

> Actually, since this is a repated pattern and is likely going to be limit=
ed to
> getting KVM_CPUID_FEATURES, just add:
>=20
> struct kvm_find_cpuid_entry kvm_find_kvm_cpuid_features(void)
> {
>         u32 base =3D vcpu->arch.kvm_cpuid_base;
>=20
>         if (!base)
>                 return NULL;
>=20
>         return kvm_find_cpuid_entry(vcpu, base | KVM_CPUID_FEATURES, 0);
> }
>=20
> and then all of the indentation churn goes away.
>=20

Yeah, probably neater.

> > +
> > +     best =3D kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEATURES, 0)=
;
> >
> >       /*
> >        * save the feature bitmap to avoid cpuid lookup for every PV
> > @@ -116,6 +151,7 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
> >  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_cpuid_entry2 *best;
> > +     u32 base;
> >
> >       best =3D kvm_find_cpuid_entry(vcpu, 1, 0);
> >       if (best) {
> > @@ -142,10 +178,14 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vc=
pu)
> >                    cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> >               best->ebx =3D xstate_required_size(vcpu->arch.xcr0, true)=
;
> >
> > -     best =3D kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > -     if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > -             (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> > -             best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT);
> > +     kvm_update_cpuid_base(vcpu);
>=20
> The KVM base doesn't need to be rechecked for runtime updates.  Runtime u=
pdates
> are to handle changes in guest state, e.g. reported XSAVE size in respons=
e to a
> CR4.OSXSAVE change.  The raw CPUID entries themselves cannot change at ru=
ntime.
> I suspect you did this here because kvm_update_cpuid_runtime() is called =
before
> kvm_vcpu_after_set_cpuid(), but that has the very bad side effect of doin=
g an
> _expensive_ lookup on every runtime update, which can get very painful if=
 there's
> no KVM_CPUID_FEATURES to be found.
>=20
> If you include the prep patch (pasted at the bottom), then this can simpl=
y be
> (note the somewhat silly name; I think it's worth clarifying that it's th=
e
> KVM_CPUID_* base that's being updated):
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0c99d2731076..5dd8c26e9f86 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -245,6 +245,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struc=
t kvm_cpuid_entry2 *e2,
>         vcpu->arch.cpuid_entries =3D e2;
>         vcpu->arch.cpuid_nent =3D nent;
>=20
> +       kvm_update_kvm_cpuid_base(vcpu);
>         kvm_update_cpuid_runtime(vcpu);
>         kvm_vcpu_after_set_cpuid(vcpu);
>=20
> > +
> > +     if (kvm_get_cpuid_base(vcpu, &base)) {
> > +             best =3D kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEAT=
URES, 0);
>=20
> This is wrong.  base will be >0x40000000 and <0x40010000, and KVM_CPUID_F=
EATURES
> is 0x40000001, i.e. this will lookup 0x80000001 for the default base.  Th=
e '+'
> needs to be an '|'.
>=20

Yes, it does.

> > +             if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > +                 (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
> > +                     best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT);
> > +     }
> >
> >       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_=
MWAIT)) {
> >               best =3D kvm_find_cpuid_entry(vcpu, 0x1, 0);
> > --
> > 2.20.1
>=20

Thanks,

  Paul

>=20
> From 02d58c124f5aab1b0ef28cfc8a6ff6b6c58df969 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 4 Nov 2021 12:17:23 -0700
> Subject: [PATCH] KVM: x86: Add helper to consolidate core logic of
>  SET_CPUID{2} flows
>=20
> Move the core logic of SET_CPUID and SET_CPUID2 to a common helper, the
> only difference between the two ioctls() is the format of the userspace
> struct.  A future fix will add yet more code to the core logic.
>=20
> No functional change intended.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 47 ++++++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 751aa85a3001..0c99d2731076 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -232,6 +232,25 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *=
vcpu)
>         return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
>  }
>=20
> +static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 =
*e2,
> +                        int nent)
> +{
> +       int r;
> +
> +       r =3D kvm_check_cpuid(e2, nent);
> +       if (r)
> +               return r;
> +
> +       kvfree(vcpu->arch.cpuid_entries);
> +       vcpu->arch.cpuid_entries =3D e2;
> +       vcpu->arch.cpuid_nent =3D nent;
> +
> +       kvm_update_cpuid_runtime(vcpu);
> +       kvm_vcpu_after_set_cpuid(vcpu);
> +
> +       return 0;
> +}
> +
>  /* when an old userspace process fills a new kernel module */
>  int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>                              struct kvm_cpuid *cpuid,
> @@ -268,18 +287,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>                 e2[i].padding[2] =3D 0;
>         }
>=20
> -       r =3D kvm_check_cpuid(e2, cpuid->nent);
> -       if (r) {
> +       r =3D kvm_set_cpuid(vcpu, e2, cpuid->nent);
> +       if (r)
>                 kvfree(e2);
> -               goto out_free_cpuid;
> -       }
> -
> -       kvfree(vcpu->arch.cpuid_entries);
> -       vcpu->arch.cpuid_entries =3D e2;
> -       vcpu->arch.cpuid_nent =3D cpuid->nent;
> -
> -       kvm_update_cpuid_runtime(vcpu);
> -       kvm_vcpu_after_set_cpuid(vcpu);
>=20
>  out_free_cpuid:
>         kvfree(e);
> @@ -303,20 +313,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu=
,
>                         return PTR_ERR(e2);
>         }
>=20
> -       r =3D kvm_check_cpuid(e2, cpuid->nent);
> -       if (r) {
> +       r =3D kvm_set_cpuid(vcpu, e2, cpuid->nent);
> +       if (r)
>                 kvfree(e2);
> -               return r;
> -       }
>=20
> -       kvfree(vcpu->arch.cpuid_entries);
> -       vcpu->arch.cpuid_entries =3D e2;
> -       vcpu->arch.cpuid_nent =3D cpuid->nent;
> -
> -       kvm_update_cpuid_runtime(vcpu);
> -       kvm_vcpu_after_set_cpuid(vcpu);
> -
> -       return 0;
> +       return r;
>  }
>=20
>  int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
> --
