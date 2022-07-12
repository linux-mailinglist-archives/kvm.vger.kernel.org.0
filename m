Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B505714BD
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 10:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiGLIha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 04:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiGLIh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 04:37:29 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220505071A;
        Tue, 12 Jul 2022 01:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1657615047; x=1689151047;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=56fb1kGCypchDcbHSpub023hR1OiGEKMXvxgJ3v2G1M=;
  b=m6r8ikRmXmVDdYQtriq7VpH6IrKoD6NeUqp2ic91xfbcPE9yRofzGh6e
   1sfQuGrbTm5QaAN/lIyr1CR7p894TrYVHh2MZTqH+GmwEfZAgBfvNAJJB
   0Hq13FQZ7Hg40P9LXiVa6Lt0GsalDUOCq7LzuYrPEBSgZE3qNSzQzlkwm
   8=;
X-IronPort-AV: E=Sophos;i="5.92,265,1650931200"; 
   d="scan'208";a="1033119265"
Subject: RE: [PATCH v5] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Thread-Topic: [PATCH v5] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves,
 if present
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 12 Jul 2022 08:37:10 +0000
Received: from EX13D32EUC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 6D21A42D31;
        Tue, 12 Jul 2022 08:37:10 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC002.ant.amazon.com (10.43.164.94) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 08:37:09 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Tue, 12 Jul 2022 08:37:09 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Sean Christopherson <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Thread-Index: AQHYlXfZ7mCZjdwoh0Oy8SwBeicg4K16ZByA
Date:   Tue, 12 Jul 2022 08:37:09 +0000
Message-ID: <369c3e9e02f947e2a2b0c093cbddc99c@EX13D32EUC003.ant.amazon.com>
References: <20220629130514.15780-1-pdurrant@amazon.com>
 <YsynoyUb4zrMBhRU@google.com>
In-Reply-To: <YsynoyUb4zrMBhRU@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.192]
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
> Sent: 12 July 2022 00:44
> To: Durrant, Paul <pdurrant@amazon.co.uk>
> Cc: x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Da=
vid Woodhouse
> <dwmw2@infradead.org>; Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznet=
sov <vkuznets@redhat.com>;
> Wanpeng Li <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Jo=
erg Roedel <joro@8bytes.org>;
> Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Bor=
islav Petkov <bp@alien8.de>;
> Dave Hansen <dave.hansen@linux.intel.com>; H. Peter Anvin <hpa@zytor.com>
> Subject: RE: [EXTERNAL][PATCH v5] KVM: x86/xen: Update Xen CPUID Leaf 4 (=
tsc info) sub-leaves, if
> present
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open
> attachments unless you can confirm the sender and know the content is saf=
e.
>=20
>=20
>=20
> On Wed, Jun 29, 2022, Paul Durrant wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 88a3026ee163..abb0a39f60eb 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -638,6 +638,7 @@ struct kvm_vcpu_xen {
> >       struct hrtimer timer;
> >       int poll_evtchn;
> >       struct timer_list poll_timer;
> > +     u32 cpuid_tsc_info;
>=20
> I would prefer to follow vcpu->arch.kvm_cpuid_base and capture the base C=
PUID
> function.  I have a hard time believing this will be the only case where =
KVM needs
> to query XEN CPUID leafs.  And cpuid_tsc_info is a confusing name given t=
he helper
> kvm_xen_setup_tsc_info(); it's odd to see a "setup" helper immediately co=
nsume a
> variable with the same name.

Sure. It is rather shrink-to-fit at the moment... no problem with capturing=
 the base.

>=20
> It'll incur another CPUID lookup in the update path to check the limit, b=
ut again
> that should be a rare operation so it doesn't seem too onerous.
>=20

We could capture the limit leaf in the general case. It's not Xen-specific =
after all.

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 031678eff28e..29ed665c51db 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3110,6 +3110,7 @@ static int kvm_guest_time_update(struct kvm_vcpu =
*v)
> >                                  &vcpu->hv_clock.tsc_shift,
> >                                  &vcpu->hv_clock.tsc_to_system_mul);
> >               vcpu->hw_tsc_khz =3D tgt_tsc_khz;
> > +             kvm_xen_setup_tsc_info(v);
>=20
> Any objection to s/setup/update?  KVM Xen uses "setup" for things like co=
nfiguring
> the event channel using userspace input, whereas this is purely updating =
existing
> data structures.
>=20

Sure.

> >       }
> >
> >       vcpu->hv_clock.tsc_timestamp =3D tsc_timestamp;
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index 610beba35907..c84424d5c8b6 100644
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
> > @@ -1855,3 +1858,51 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
> >       if (kvm->arch.xen_hvm_config.msr)
> >               static_branch_slow_dec_deferred(&kvm_xen_enabled);
> >  }
> > +
> > +void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 base =3D 0;
> > +     u32 limit;
> > +     u32 function;
> > +
> > +     vcpu->arch.xen.cpuid_tsc_info =3D 0;
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
> > +                     limit =3D entry->eax;
> > +                     break;
> > +             }
> > +     }
> > +     if (!base)
> > +             return;
>=20
> Rather than open code a variant of kvm_update_kvm_cpuid_base(), that help=
er can
> be tweaked to take a signature.  Along with a patch to provide a #define =
for Xen's
> signature as a string, this entire function becomes a one-liner.
>=20

Sure, but as said above, we could make capturing the limit part of the gene=
ral function too. It could even be extended to capture the Hyper-V base/lim=
it too.
As for defining the sig as a string... I guess it would be neater to use th=
e values from the Xen header, but it'll probably make the code more ugly so=
 a secondary definition is reasonable.

> If the below looks ok (won't compile, needs prep patches), I'll test and =
post a
> proper mini-series.

Ok. Thanks,

  Paul

>=20
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            |  2 ++
>  arch/x86/kvm/x86.c              |  1 +
>  arch/x86/kvm/xen.c              | 30 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/xen.h              | 22 +++++++++++++++++++++-
>  5 files changed, 55 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index de5a149d0971..b2565d05fc86 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -638,6 +638,7 @@ struct kvm_vcpu_xen {
>         struct hrtimer timer;
>         int poll_evtchn;
>         struct timer_list poll_timer;
> +       u32 cpuid_base;
>  };
>=20
>  struct kvm_vcpu_arch {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0abe3adc9ae3..54ed51799b8d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -25,6 +25,7 @@
>  #include "mmu.h"
>  #include "trace.h"
>  #include "pmu.h"
> +#include "xen.h"
>=20
>  /*
>   * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need=
 to be
> @@ -309,6 +310,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu =
*vcpu)
>             __cr4_reserved_bits(guest_cpuid_has, vcpu);
>=20
>         kvm_hv_set_cpuid(vcpu);
> +       kvm_xen_after_set_cpuid(vcpu);
>=20
>         /* Invoke the vendor callback only after the above state is updat=
ed. */
>         static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 567d13405445..a624293c66c8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3110,6 +3110,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v=
)
>                                    &vcpu->hv_clock.tsc_shift,
>                                    &vcpu->hv_clock.tsc_to_system_mul);
>                 vcpu->hw_tsc_khz =3D tgt_tsc_khz;
> +               kvm_xen_update_tsc_info(v);
>         }
>=20
>         vcpu->hv_clock.tsc_timestamp =3D tsc_timestamp;
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 610beba35907..3fc0c194b813 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -10,6 +10,9 @@
>  #include "xen.h"
>  #include "hyperv.h"
>  #include "lapic.h"
> +#include "cpuid.h"
> +
> +#include <asm/xen/cpuid.h>
>=20
>  #include <linux/eventfd.h>
>  #include <linux/kvm_host.h>
> @@ -1855,3 +1858,30 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
>         if (kvm->arch.xen_hvm_config.msr)
>                 static_branch_slow_dec_deferred(&kvm_xen_enabled);
>  }
> +
> +void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_cpuid_entry2 *entry;
> +       u32 function;
> +
> +       if (!vcpu->arch.xen.cpuid_base)
> +               return;
> +
> +       entry =3D kvm_find_cpuid_entry(vcpu, vcpu->arch.xen.cpuid_base, 0=
);
> +       if (WARN_ON_ONCE(!entry))
> +               return;
> +
> +       function =3D vcpu->arch.xen.cpuid_base | XEN_CPUID_LEAF(3);
> +       if (function > entry->eax)
> +               return;
> +
> +       entry =3D kvm_find_cpuid_entry(vcpu, function, 1);
> +       if (entry) {
> +               entry->ecx =3D vcpu->arch.hv_clock.tsc_to_system_mul;
> +               entry->edx =3D vcpu->arch.hv_clock.tsc_shift;
> +       }
> +
> +       entry =3D kvm_find_cpuid_entry(vcpu, function, 2);
> +       if (entry)
> +               entry->eax =3D vcpu->arch.hw_tsc_khz;
> +}
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index 532a535a9e99..b8161b99b82a 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -9,9 +9,14 @@
>  #ifndef __ARCH_X86_KVM_XEN_H__
>  #define __ARCH_X86_KVM_XEN_H__
>=20
> -#ifdef CONFIG_KVM_XEN
>  #include <linux/jump_label_ratelimit.h>
>=20
> +#include <asm/xen/cpuid.h>
> +
> +#include "cpuid.h"
> +
> +#ifdef CONFIG_KVM_XEN
> +
>  extern struct static_key_false_deferred kvm_xen_enabled;
>=20
>  int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
> @@ -32,6 +37,13 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
>  int kvm_xen_setup_evtchn(struct kvm *kvm,
>                          struct kvm_kernel_irq_routing_entry *e,
>                          const struct kvm_irq_routing_entry *ue);
> +void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
> +
> +static inline void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.xen.cpuid_base =3D
> +               kvm_get_hypervisor_cpuid_base(vcpu, XEN_CPUID_SIGNATURE);
> +}
>=20
>  static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
>  {
> @@ -135,6 +147,14 @@ static inline bool kvm_xen_timer_enabled(struct kvm_=
vcpu *vcpu)
>  {
>         return false;
>  }
> +
> +static inline void kvm_xen_after_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
> +{
> +}
>  #endif
>=20
>  int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
>=20
> base-commit: b08b2f54c49d8f96a22107c444d500dff73ec2a6
> --

