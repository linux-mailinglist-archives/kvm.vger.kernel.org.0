Return-Path: <kvm+bounces-34644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2A6A032EC
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 23:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8F783A5205
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 22:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669061E1C3B;
	Mon,  6 Jan 2025 22:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2uJRFXh3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7CB1DF756
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 22:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736203795; cv=none; b=F8Wn9rxe70NWOFyb0i7X6UhLnMjQVrgnmYMzmb0ge3cTgoxGVGr3EUX3wgpiqMFIKaxbFQMSvf+cFWqNVurC5R0Kxm8/Fpaal1mW800EWGXMIJeZIz8Dy44QABuh12E6xUw2THpd4Bhv3y7bRyqaODWddH9fpiKx36qdee+6jRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736203795; c=relaxed/simple;
	bh=3aXDBOYWuSJH5P+P7H3b5HfzaH6w2eMfdKAqQ081Zj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a1BsS/bib+TKXw56SDJdnROyS7hSE9liFm3J0KtTdJFaybeRKvBmBrb6RaXY0mznWbvvsnu9Kw2iHKrTrnEQVaZRzMeB52ixA0UG0Ys5gPklgTx0rsYKKZkCO4fApQnk9pAsVSWgZtj1L3P6RutR+r12MZcrnlzALgXZlbxxco0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2uJRFXh3; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53e44a42512so865e87.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 14:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736203792; x=1736808592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0St71VI5s6uJPBXeqF2pQflOBObbfuynU/QfvDDJGf4=;
        b=2uJRFXh3hBnR3ICYX+4KPrmZHs1R07whW/XT1bhkfAQIymwXRDF8ICAnl+nSLeVYuM
         VOciGRfASbL+E0WBh5cDOae7SYMQ6YwhSSHp8YWACfgyn9gBo8K/XQotkTwmHJr+YNSP
         +JCqAgsRT7q7ntcy5rGaI/wHr4PONgJL22N4wBkHRMtimlpE3jv2P8tdJc6bInNL4lon
         dEYM1CwRVErxX//qQ52nr23OnzqoBuxllXEfG5avWAFebwoUBR3Xo+t2TeIDTljbm1LI
         vBUkbNYidFRWVN2coN0URxvlkCvWWozxEHfwKkmZLLd2LX0Ezm4rtIwW0NjZ4Lemx2rv
         6zAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736203792; x=1736808592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0St71VI5s6uJPBXeqF2pQflOBObbfuynU/QfvDDJGf4=;
        b=XRjS7fZpNZPei5SXVi1BNSN6RWY5hAtFwOhf46weOOMAkQc6KOnxhBe94R92cFLfxp
         m36lE4XS2lsrsLghqwp/bgkcQ/1XqvekAhcQeN032rj3Ki43Lr9pcI/GGGpFxnvb9ZFd
         UKej4pYG7mW7TUvrkALRgXT6EJ/SrA4NpAdGpnkES+xIT9gdIwJIe3N1QFrcDsIuqNbP
         cmamC3VYM8PZ16E6wO0E4PIhNSj2Ek2ZBMaZ5ZS1DsV9r0jB0FkGAAMda0RQijNjm4FM
         9qUW7+PPwQhSOusUYeQrGkcKWmgQQjrgn8v6vxu8CpzQ9r5OifndmqMUJQAHL3Y8ti0d
         FLMA==
X-Forwarded-Encrypted: i=1; AJvYcCWtu02K1tNS808UWfWbg+ByUVkWKzvvWbdEdvJTgh4NwF3nmrjn3YU4vCJgThSZp+Wxn7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGPTSYfDZW2L6Rmw/G5Q1bVbWZxREpfnzS/S5cPc1fWkrYD/WC
	tet3v0Q6eVQJNotnSVfPArcM5IPPlQxceXariDkqenjn3XCsjXw8eLsYEwQIn/qGVGPqXBB4vB1
	F4Ma6+Sbe8MctVL/1a4QUP6nyAgD1ywXYeMKI
X-Gm-Gg: ASbGncsFpCsGwxxvWORbdh5zXJVI2pU0QYZEFof8wHzzELn7TO6gjhJqNu/wyi42vcC
	6uJXwid84nsoXk05EX8yyWBdsHKIOMPx1WbKaDFjvEjDdp3ld0MnJwVWk6ugus+n5
X-Google-Smtp-Source: AGHT+IGWgaCaJSJWbaPYgwB6f9mk5XkEK3uKrY8lJamBItNFyhs8z5g1pONTSnIHDAjzHGkTajitbEwZhd4It3O2dhk=
X-Received: by 2002:a05:6512:32c7:b0:53d:f0a2:1fe3 with SMTP id
 2adb3069b0e04-5427ee1d713mr63732e87.2.1736203791561; Mon, 06 Jan 2025
 14:49:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
 <fc6294b7-f648-4daa-842d-0b74211f8c3a@linux.intel.com>
In-Reply-To: <fc6294b7-f648-4daa-842d-0b74211f8c3a@linux.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 6 Jan 2025 14:49:40 -0800
X-Gm-Features: AbW1kvYeRWXDm0Da_yDDUxEvOXPo7K8kDW91gpCzPY8pqwH9QXotLqTOMOuY70Q
Message-ID: <CAGtprH_JYQvBimSLkb3qgshPbrUE+Z2dTz8vEvEwV1v+OMD6Mg@mail.gmail.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 5, 2025 at 5:46=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel.com=
> wrote:
>
>
>
>
> On 1/4/2025 5:59 AM, Vishal Annapurve wrote:
> > On Sun, Dec 8, 2024 at 5:11=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel=
.com> wrote:
> >> From: Isaku Yamahata <isaku.yamahata@intel.com>
> >>
> >> Inhibit APICv for TDX guest in KVM since TDX doesn't support APICv acc=
esses
> >> from host VMM.
> >>
> >> Follow how SEV inhibits APICv.  I.e, define a new inhibit reason for T=
DX, set
> >> it on TD initialization, and add the flag to kvm_x86_ops.required_apic=
v_inhibits.
> >>
> >> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> >> ---
> >> TDX interrupts breakout:
> >> - Removed WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm)) in
> >>    tdx_td_vcpu_init(). (Rick)
> >> - Change APICV -> APICv in changelog for consistency.
> >> - Split the changelog to 2 paragraphs.
> >> ---
> >>   arch/x86/include/asm/kvm_host.h | 12 +++++++++++-
> >>   arch/x86/kvm/vmx/main.c         |  3 ++-
> >>   arch/x86/kvm/vmx/tdx.c          |  3 +++
> >>   3 files changed, 16 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kv=
m_host.h
> >> index 32c7d58a5d68..df535f08e004 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -1281,6 +1281,15 @@ enum kvm_apicv_inhibit {
> >>           */
> >>          APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
> >>
> >> +       /*********************************************************/
> >> +       /* INHIBITs that are relevant only to the Intel's APICv. */
> >> +       /*********************************************************/
> >> +
> >> +       /*
> >> +        * APICv is disabled because TDX doesn't support it.
> >> +        */
> >> +       APICV_INHIBIT_REASON_TDX,
> >> +
> >>          NR_APICV_INHIBIT_REASONS,
> >>   };
> >>
> >> @@ -1299,7 +1308,8 @@ enum kvm_apicv_inhibit {
> >>          __APICV_INHIBIT_REASON(IRQWIN),                 \
> >>          __APICV_INHIBIT_REASON(PIT_REINJ),              \
> >>          __APICV_INHIBIT_REASON(SEV),                    \
> >> -       __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
> >> +       __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),     \
> >> +       __APICV_INHIBIT_REASON(TDX)
> >>
> >>   struct kvm_arch {
> >>          unsigned long n_used_mmu_pages;
> >> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> >> index 7f933f821188..13a0ab0a520c 100644
> >> --- a/arch/x86/kvm/vmx/main.c
> >> +++ b/arch/x86/kvm/vmx/main.c
> >> @@ -445,7 +445,8 @@ static int vt_gmem_private_max_mapping_level(struc=
t kvm *kvm, kvm_pfn_t pfn)
> >>           BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |                   \
> >>           BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |        \
> >>           BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |           \
> >> -        BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
> >> +        BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |         \
> >> +        BIT(APICV_INHIBIT_REASON_TDX))
> >>
> >>   struct kvm_x86_ops vt_x86_ops __initdata =3D {
> >>          .name =3D KBUILD_MODNAME,
> >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >> index b0f525069ebd..b51d2416acfb 100644
> >> --- a/arch/x86/kvm/vmx/tdx.c
> >> +++ b/arch/x86/kvm/vmx/tdx.c
> >> @@ -2143,6 +2143,8 @@ static int __tdx_td_init(struct kvm *kvm, struct=
 td_params *td_params,
> >>                  goto teardown;
> >>          }
> >>
> >> +       kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
> >> +
> >>          return 0;
> >>
> >>          /*
> >> @@ -2528,6 +2530,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcp=
u, u64 vcpu_rcx)
> >>                  return -EIO;
> >>          }
> >>
> >> +       vcpu->arch.apic->apicv_active =3D false;
> > With this setting, apic_timer_expired[1] will always cause timer
> > interrupts to be pending without injecting them right away. Injecting
> > it after VM exit [2] could cause unbounded delays to timer interrupt
> > injection.
>
> When apic->apicv_active is false, it will fallback to increasing the
> apic->lapic_timer.pending and request KVM_REQ_UNBLOCK.
> If apic_timer_expired() is called from timer function, the target vCPU
> will be kicked out immediately.
> So there is no unbounded delay to timer interrupt injection.

Ack. Though, wouldn't it be faster to just post timer interrupts right
away without causing vcpu exit?

Another scenario I was thinking of was hrtimer expiry during vcpu exit
being handled in KVM/userspace, which will cause timer interrupt
injection after the next exit [1] delaying timer interrupt to guest.
This scenario is not specific to TDX VMs though.

[1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/x86.c=
?h=3Dkvm-coco-queue#n11263

>
> In a previous PUCK session, Sean suggested apic->apicv_active should be
> set to true to align with the hardware setting because TDX module always
> enables apicv for TDX guests.
> Will send a write up about changing apicv to active later.
>
> >
> > [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/l=
apic.c?h=3Dkvm-coco-queue#n1922
> > [2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/x=
86.c?h=3Dkvm-coco-queue#n11263
> >
> >>          vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
> >>
> >>          return 0;
> >> --
> >> 2.46.0
> >>
> >>
>

