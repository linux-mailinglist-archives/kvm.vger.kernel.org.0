Return-Path: <kvm+bounces-3142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89592800FF2
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAADE1C20FB4
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44C54C62B;
	Fri,  1 Dec 2023 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="czkyhh3Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6A293;
	Fri,  1 Dec 2023 08:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1701447596; x=1732983596;
  h=mime-version:content-transfer-encoding:date:message-id:
   to:cc:from:references:in-reply-to:subject;
  bh=eFQq5aTAxzGc0xKmRmPh5Xds7eBuvGK1sft5MSj7h90=;
  b=czkyhh3ZFKKdMxlOvrMIEwDUMAJlJvhhMURmRO4xIRDvmxdwDkhUoNu1
   4p4ULKyVPxnD6sF4upC03MoNmK4smAK0+3AEN4u0kiXlVooznvXUifpUr
   LwJR/xmO/AQOCBAUTYpVgnFIDKsRo+Fd3ywys6C6i76OXRxpn0WpTy30W
   M=;
X-IronPort-AV: E=Sophos;i="6.04,242,1695686400"; 
   d="scan'208";a="47758603"
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return prologues in
 hypercall page
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-617e30c2.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 16:19:53 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-617e30c2.us-east-1.amazon.com (Postfix) with ESMTPS id D179B608B8;
	Fri,  1 Dec 2023 16:19:49 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:13113]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.47.241:2525] with esmtp (Farcaster)
 id c0229cfe-6763-422b-be04-2f801e93bcc4; Fri, 1 Dec 2023 16:19:48 +0000 (UTC)
X-Farcaster-Flow-ID: c0229cfe-6763-422b-be04-2f801e93bcc4
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 1 Dec 2023 16:19:48 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 1 Dec
 2023 16:19:43 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 1 Dec 2023 16:19:40 +0000
Message-ID: <CXD4TVV5QWUK.3SH495QSBTTUF@amazon.com>
To: Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-6-nsaenz@amazon.com>
 <f4495d1f697cf9a7ddfb786eaeeac90f554fc6db.camel@redhat.com>
In-Reply-To: <f4495d1f697cf9a7ddfb786eaeeac90f554fc6db.camel@redhat.com>
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Tue Nov 28, 2023 at 7:08 AM UTC, Maxim Levitsky wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you can confirm the sender and know t=
he content is safe.
>
>
>
> On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> > VTL call/return hypercalls have their own entry points in the hypercall
> > page because they don't follow normal hyper-v hypercall conventions.
> > Move the VTL call/return control input into ECX/RAX and set the
> > hypercall code into EAX/RCX before calling the hypercall instruction in
> > order to be able to use the Hyper-V hypercall entry function.
> >
> > Guests can read an emulated code page offsets register to know the
> > offsets into the hypercall page for the VTL call/return entries.
> >
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> >
> > ---
> >
> > My tree has the additional patch, we're still trying to understand unde=
r
> > what conditions Windows expects the offset to be fixed.
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 54f7f36a89bf..9f2ea8c34447 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -294,6 +294,7 @@ static int patch_hypercall_page(struct kvm_vcpu *vc=
pu, u64 data)
> >
> >         /* VTL call/return entries */
> >         if (!kvm_xen_hypercall_enabled(kvm) && kvm_hv_vsm_enabled(kvm))=
 {
> > +               i =3D 22;
> >  #ifdef CONFIG_X86_64
> >                 if (is_64_bit_mode(vcpu)) {
> >                         /*
> > ---
> >  arch/x86/include/asm/kvm_host.h   |  2 +
> >  arch/x86/kvm/hyperv.c             | 78 ++++++++++++++++++++++++++++++-
> >  include/asm-generic/hyperv-tlfs.h | 11 +++++
> >  3 files changed, 90 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index a2f224f95404..00cd21b09f8c 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1105,6 +1105,8 @@ struct kvm_hv {
> >       u64 hv_tsc_emulation_status;
> >       u64 hv_invtsc_control;
> >
> > +     union hv_register_vsm_code_page_offsets vsm_code_page_offsets;
> > +
> >       /* How many vCPUs have VP index !=3D vCPU index */
> >       atomic_t num_mismatched_vp_indexes;
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 78d053042667..d4b1b53ea63d 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -259,7 +259,8 @@ static void synic_exit(struct kvm_vcpu_hv_synic *sy=
nic, u32 msr)
> >  static int patch_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
> >  {
> >       struct kvm *kvm =3D vcpu->kvm;
> > -     u8 instructions[9];
> > +     struct kvm_hv *hv =3D to_kvm_hv(kvm);
> > +     u8 instructions[0x30];
> >       int i =3D 0;
> >       u64 addr;
> >
> > @@ -285,6 +286,81 @@ static int patch_hypercall_page(struct kvm_vcpu *v=
cpu, u64 data)
> >       /* ret */
> >       ((unsigned char *)instructions)[i++] =3D 0xc3;
> >
> > +     /* VTL call/return entries */
> > +     if (!kvm_xen_hypercall_enabled(kvm) && kvm_hv_vsm_enabled(kvm)) {
> > +#ifdef CONFIG_X86_64
> > +             if (is_64_bit_mode(vcpu)) {
> > +                     /*
> > +                      * VTL call 64-bit entry prologue:
> > +                      *      mov %rcx, %rax
> > +                      *      mov $0x11, %ecx
> > +                      *      jmp 0:
>
> This isn't really 'jmp 0' as I first wondered but actually backward jump =
32 bytes back (if I did the calculation correctly).
> This is very dangerous because code that was before can change and in fac=
t I don't think that this
> offset is even correct now, and on top of that it depends on support for =
xen hypercalls as well.

You're absolutely right. The offset is wrong as is, and the overall
approach might break in the future.

Another solution is to explicitly do the vmcall and avoid any jumps.
This seems to be what Hyper-V does:
https://hal.science/hal-03117362/document (Figure 8).

> This can be fixed by calculating the offset in runtime, however I am thin=
king:
>
>
> Since userspace will have to be aware of the offsets in this page, and si=
nce
> pretty much everything else is done in userspace, it might make sense to =
create
> the hypercall page in the userspace.
>
> In fact, the fact that KVM currently overwrites the guest page, is a viol=
ation of
> the HV spec.
>
> It's more correct regardless of VTL to do userspace vm exit and let the u=
serspace put a memslot ("overlay")
> over the address, and put whatever userspace wants there, including the a=
bove code.

I agree we should be on the safe side and fully implement overlays. That
said, I suspect they are not actually necessary in practice (with or
without VSM support).

> Then we won't need the new ioctl as well.
>
> To support this I think that we can add a userspace msr filter on the HV_=
X64_MSR_HYPERCALL,
> although I am not 100% sure if a userspace msr filter overrides the in-ke=
rnel msr handling.

I thought about it at the time. It's not that simple though, we should
still let KVM set the hypercall bytecode, and other quirks like the Xen
one. Additionally, we have no way of knowing where they are going to be
located. We could do something like this, but it's not pretty:

  - Exit to user-space on HV_X64_MSR_HYPERCALL (it overrides the msr
    handling).
  - Setup the overlay.
  - Call HV_X64_MSR_HYPERCALL from user-space so KVM writes its share of
    the hypercall page.
  - Copy the VSM parts from user-space in an area we know to be safe.

We could maybe introduce and extension CAP that provides a safe offset
in the hypercall page for user-space to use?

Nicolas

