Return-Path: <kvm+bounces-4928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBDA819FFF
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 14:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 281EC1C224F2
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C8F38DE0;
	Wed, 20 Dec 2023 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QSHCo9ei"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1966338DD8
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 13:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-54744e66d27so13656a12.0
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 05:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703079606; x=1703684406; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PzhN7R1/MC7JMQD4+uPuwvzd1ldvY1sQfu70nLweY4=;
        b=QSHCo9einRL/atc+23Jh5mM8sgTznsXY08FrEdiUfEXxMmaK3DpnP/64OiW3dy1oNE
         35tfPREdIkGBM4GHh3g4Z6rcjtakIklbuM1eLu/HQfGEwHaj+0MZCvRx2soxG5GoWlHE
         vCLLbA/VYChZA1MFobEBsXcodiNH5iI2cwoQZgxrIVo8RmU7p7+K7jmLSq/9B9XFRuEr
         e9tZuCOU+exnFKkTZ2qASW6mF5tyt9lbd+qfYT6meyeEW3DrMEQ9Xf23+cr4LQYyhRrs
         JTkPUdS2Mg6UxjB2FTart5K81vk6OMYBWtRI/ctvk1owl/PlHuie9BFquqzeY89tQJBU
         w3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703079606; x=1703684406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3PzhN7R1/MC7JMQD4+uPuwvzd1ldvY1sQfu70nLweY4=;
        b=PiXRfcOWzZno2yPUGCHVx3h12UCzxNLHM/mtI/+I25Rreof7qjriV86hteZcy6Bz9V
         QJUnKh2J/lbeDeVYy314+edDMbLCbqGW2QaMSMj2w2xVvlIsLjaGXAJpEeMBIpqDlx+t
         nKwj5e+GwRzr5uuaUJX8r81SdlsdVpC/VaufSKLaw7fH52nsr24FeCVHvlp7+KOFHW20
         qS7IOtcMdQmMuk2oTks5Wln0XgQyA7+BckZ38gBfXv5SZF//jGIJegncvr9iRqZKpx6y
         fagmGZQfaAKZQWENZwNWwWsY0AggiNGKTnXf6BZBSUmBdDRFcFL/W8I2+ypuh7SkHBNj
         /OYQ==
X-Gm-Message-State: AOJu0Yz6OCGcVHnGsrK/JyavriQyj/hqEVZbyJ4HrP8wT9iTHXuPj/7I
	NT2tI0A5+AeXaTzvDVHj83phEh8c2uZVCKdtsvtEqSRzbMnv
X-Google-Smtp-Source: AGHT+IHVTkD/eAhhODqe09INUj/Ol+2fuISfy8ljhvdDNt01Kuumy3ifb9THMD5X/nM5Kk8dORgHFOZf2e1aWWs5rwE=
X-Received: by 2002:a50:d591:0:b0:553:2840:6aad with SMTP id
 v17-20020a50d591000000b0055328406aadmr179337edi.2.1703079606083; Wed, 20 Dec
 2023 05:40:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYBhl200jZpWDqpU@google.com>
 <ZYEFGQBti5DqlJiu@chao-email> <CALMp9eSJT7PajjX==L9eLKEEVuL-tvY0yN1gXmtzW5EUKHX3Yg@mail.gmail.com>
 <ZYFPsISS9K867BU5@chao-email> <ZYG2CDRFlq50siec@google.com>
In-Reply-To: <ZYG2CDRFlq50siec@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 20 Dec 2023 05:39:50 -0800
Message-ID: <CALMp9eQbLjqLNbg4UAZHDuJ-wAaQAyAv24vWsW2AFKVeuOMYJw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, 
	pbonzini@redhat.com, eddie.dong@intel.com, xiaoyao.li@intel.com, 
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 7:26=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Dec 19, 2023, Chao Gao wrote:
> > On Mon, Dec 18, 2023 at 07:40:11PM -0800, Jim Mattson wrote:
> > >Honestly, I think KVM should just disable EPT if the EPT tables can't
> > >support the CPU's physical address width.
> >
> > Yes, it is an option.
> > But I prefer to allow admin to override this (i.e., admin still can ena=
ble EPT
> > via module parameter) because those issues are not new and disabling EP=
T
> > doesn't prevent QEMU from launching guests w/ smaller MAXPHYADDR.
> >
> > >> Here nothing visible to selftests or QEMU indicates that guest.MAXPH=
YADDR =3D 52
> > >> is invalid/incorrect. how can we say selftests are at fault and we s=
hould fix
> > >> them?
> > >
> > >In this case, the CPU is at fault, and you should complain to the CPU =
vendor.
> >
> > Yeah, I agree with you and will check with related team inside Intel.
>
> I agree that the CPU is being weird, but this is technically an architect=
urally
> legal configuration, and KVM has largely committed to supporting weird se=
tups.
> At some point we have to draw a line when things get too ridiculous, but =
I don't
> think this particular oddity crosses into absurd territory.
>
> > My point was just this isn't a selftest issue because not all informati=
on is
> > disclosed to the tests.
>
> Ah, right, EPT capabilities are in MSRs that userspace can't read.
>
> > And I am afraid KVM as L1 VMM may run into this situation, i.e., only 4=
-level
> > EPT is supported but MAXPHYADDR is 52. So, KVM needs a fix anyway.
>
> Yes, but forcing emulation for a funky setup is not a good fix.  KVM can =
simply
> constrain the advertised MAXPHYADDR, no?

This is essentially the same as allow_smaller_maxphyaddr, and has the
same issues:
1) MOV-to-CR3 must be intercepted in PAE mode, to check the bits above
guest.MAXPHYADDR in the PDPTRs.
2) #PF must be intercepted whenever PTEs are 64 bits, to do a software
page walk of the guest's x86 page tables and check the bits above
guest.MAXPHYADDR for a terminal page fault that might result in a
different error code than the one produced by hardware.
3) EPT violations may require instruction emulation to synthesize an
appropriate #PF, and this requires the KVM instruction emulator to be
expanded to understand *all* memory-accessing instructions, not just
the limited set it understands now.

I just don't see how this is even remotely practical.

> ---
>  arch/x86/kvm/cpuid.c   | 17 +++++++++++++----
>  arch/x86/kvm/mmu.h     |  2 ++
>  arch/x86/kvm/mmu/mmu.c |  5 +++++
>  3 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 294e5bd5f8a0..5c346e1a10bd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1233,12 +1233,21 @@ static inline int __do_cpuid_func(struct kvm_cpui=
d_array *array, u32 function)
>                  *
>                  * If TDP is enabled but an explicit guest MAXPHYADDR is =
not
>                  * provided, use the raw bare metal MAXPHYADDR as reducti=
ons to
> -                * the HPAs do not affect GPAs.
> +                * the HPAs do not affect GPAs.  Finally, if TDP is enabl=
ed and
> +                * doesn't support 5-level paging, cap guest MAXPHYADDR a=
t 48
> +                * bits as KVM can't install SPTEs for larger GPAs.
>                  */
> -               if (!tdp_enabled)
> +               if (!tdp_enabled) {
>                         g_phys_as =3D boot_cpu_data.x86_phys_bits;
> -               else if (!g_phys_as)
> -                       g_phys_as =3D phys_as;
> +               } else {
> +                       u8 max_tdp_level =3D kvm_mmu_get_max_tdp_level();
> +
> +                       if (!g_phys_as)
> +                               g_phys_as =3D phys_as;
> +
> +                       if (max_tdp_level < 5)
> +                               g_phys_as =3D min(g_phys_as, 48);
> +               }
>
>                 entry->eax =3D g_phys_as | (virt_as << 8);
>                 entry->ecx &=3D ~(GENMASK(31, 16) | GENMASK(11, 8));
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..b410a227c601 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>         return boot_cpu_data.x86_phys_bits;
>  }
>
> +u8 kvm_mmu_get_max_tdp_level(void);
> +
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 acces=
s_mask);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c844e428684..b2845f5520b3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5267,6 +5267,11 @@ static inline int kvm_mmu_get_tdp_level(struct kvm=
_vcpu *vcpu)
>         return max_tdp_level;
>  }
>
> +u8 kvm_mmu_get_max_tdp_level(void)
> +{
> +       return tdp_root_level ? tdp_root_level : max_tdp_level;
> +}
> +
>  static union kvm_mmu_page_role
>  kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>                                 union kvm_cpu_role cpu_role)
>
> base-commit: f2a3fb7234e52f72ff4a38364dbf639cf4c7d6c6
> --

