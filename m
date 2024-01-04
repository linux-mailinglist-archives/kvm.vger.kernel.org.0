Return-Path: <kvm+bounces-5648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29460824343
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 15:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4A951F25387
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 14:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C573F224FE;
	Thu,  4 Jan 2024 14:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r8b6jwPu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D578224ED
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-55679552710so10068a12.1
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 06:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704377018; x=1704981818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fz2ZaPvPegUdCS4R21laN63DmfGYtgiMCRmXD6PbvGY=;
        b=r8b6jwPuFWUDhgc1plJE6JvEVnYibJIGmR1pQAmdanU0zc897eqjgEI56Kb4/miMLh
         ETeasnt3PQYF3GW5iUM/stB5nVbG4v5PsT7yNXqYWa8QtA3GzcEVrO1NWm9jQPfYpQqB
         DZlFuNvmmr+5KKNj9hjUSRdYslT4kLBuRWjR0eX2Qzg/T2B1hH+jlC8y8K/tQ1U7VmO2
         L9G/e209jupJVrk64T09tXV78jO2nXhrZ/hFEyv4MzHBSSSjtDlk+BYxGo/6p8ySGYUC
         gleW4oqo2zCAYj7Ofbz+bekvWhk65HfKY6TNc407CZjaPgV9D+U9OCNlEl630C/IWnqa
         Uy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704377018; x=1704981818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fz2ZaPvPegUdCS4R21laN63DmfGYtgiMCRmXD6PbvGY=;
        b=c4HAOUNIPWghlc1an07F9FODBqacL5yEkatIxudifcYahabmA2eyQGeMd7Oac1vstX
         YJVGir19w7PpNveHrW8lSsQZm0K7HxMP+2Yypmt/iUTa0Inlx4kdajC+O4MQLPfh5LFo
         /5Lvf2swb3PwR2E1YWp3z6ZRT+PsHo1ki3LrCntD84oVcvhPws5YoEECSd7hYIiaXWA1
         JiXBLAA9M65zT6GddvVbulfvrvDgfi+N8Nv3noNiI7DQbmt1sNUxvygWcIRNTNnz76bT
         9A/mFxZSI94O3mE9nF5yeJgq/3eCWGUYB+rbIPdyeQV2CUAYmR574ln+eUXzAqumWQKl
         01iA==
X-Gm-Message-State: AOJu0YwV32jvHPImL/I9pIojqFIKtZTItRkJw7FBXuRPKOMibyJk+dwp
	GYNtS5xMEpiXIpry51ZqeHLIJsQCI/8xx9M17t34Y/1193Ve
X-Google-Smtp-Source: AGHT+IFUY3kCL1zWywR4LXo0jQ4pVLAkiW1jdrb3Czliju8IzhJEx8WlLDM+GjqoNvwFL3CZ12YuROTnYXS3j6nttcw=
X-Received: by 2002:a05:6402:380c:b0:557:24d:6135 with SMTP id
 es12-20020a056402380c00b00557024d6135mr88369edb.4.1704377018379; Thu, 04 Jan
 2024 06:03:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050> <ZZSbLUGNNBDjDRMB@google.com>
 <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com> <ZZYbzzDxPI8gjPu8@chao-email>
 <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
 <CALMp9eRS9o7YDDaOcjBB0QTeF_vRA2LMvQqc2Sb-7XhyDi=1LA@mail.gmail.com> <ZZac2AFdR9YTkhuZ@linux.bj.intel.com>
In-Reply-To: <ZZac2AFdR9YTkhuZ@linux.bj.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 4 Jan 2024 06:03:21 -0800
Message-ID: <CALMp9eQsEUFGJ6G2BMxOuHkFuDRp6LEqSAhmae5d3gA9LpmiQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
To: Tao Su <tao1.su@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Sean Christopherson <seanjc@google.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 3:59=E2=80=AFAM Tao Su <tao1.su@linux.intel.com> wro=
te:
>
> On Wed, Jan 03, 2024 at 08:34:16PM -0800, Jim Mattson wrote:
> > On Wed, Jan 3, 2024 at 7:40=E2=80=AFPM Jim Mattson <jmattson@google.com=
> wrote:
> > >
> > > On Wed, Jan 3, 2024 at 6:45=E2=80=AFPM Chao Gao <chao.gao@intel.com> =
wrote:
> > > >
> > > > On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote=
:
> > > > >On Tue, Jan 02, 2024, Jim Mattson wrote:
> > > > >> On Tue, Jan 2, 2024 at 3:24=E2=80=AFPM Sean Christopherson <sean=
jc@google.com> wrote:
> > > > >> >
> > > > >> > On Thu, Dec 21, 2023, Xu Yilun wrote:
> > > > >> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherso=
n wrote:
> > > > >> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/m=
mu.c
> > > > >> > > > > index c57e181bba21..72634d6b61b2 100644
> > > > >> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > >> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > >> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthroug=
h_bits(struct kvm_vcpu *vcpu,
> > > > >> > > > >   reset_guest_paging_metadata(vcpu, mmu);
> > > > >> > > > >  }
> > > > >> > > > >
> > > > >> > > > > +/* guest-physical-address bits limited by TDP */
> > > > >> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> > > > >> > > > > +{
> > > > >> > > > > + return max_tdp_level =3D=3D 5 ? 57 : 48;
> > > > >> > > >
> > > > >> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
> > > > >> > > >
> > > > >> > > >   Bits 56:52 of each guest-physical address are necessaril=
y zero because
> > > > >> > > >   guest-physical addresses are architecturally limited to =
52 bits.
> > > > >> > > >
> > > > >> > > > Rather than split hairs over something that doesn't matter=
, I think it makes sense
> > > > >> > > > for the CPUID code to consume max_tdp_level directly (I fo=
rgot that max_tdp_level
> > > > >> > > > is still accurate when tdp_root_level is non-zero).
> > > > >> > >
> > > > >> > > It is still accurate for now. Only AMD SVM sets tdp_root_lev=
el the same as
> > > > >> > > max_tdp_level:
> > > > >> > >
> > > > >> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
> > > > >> > >                         get_npt_level(), PG_LEVEL_1G);
> > > > >> > >
> > > > >> > > But I wanna doulbe confirm if directly using max_tdp_level i=
s fully
> > > > >> > > considered.  In your last proposal, it is:
> > > > >> > >
> > > > >> > >   u8 kvm_mmu_get_max_tdp_level(void)
> > > > >> > >   {
> > > > >> > >       return tdp_root_level ? tdp_root_level : max_tdp_level=
;
> > > > >> > >   }
> > > > >> > >
> > > > >> > > and I think it makes more sense, because EPT setup follows t=
he same
> > > > >> > > rule.  If any future architechture sets tdp_root_level small=
er than
> > > > >> > > max_tdp_level, the issue will happen again.
> > > > >> >
> > > > >> > Setting tdp_root_level !=3D max_tdp_level would be a blatant b=
ug.  max_tdp_level
> > > > >> > really means "max possible TDP level KVM can use".  If an exac=
t TDP level is being
> > > > >> > forced by tdp_root_level, then by definition it's also the max=
 TDP level, because
> > > > >> > it's the _only_ TDP level KVM supports.
> > > > >>
> > > > >> This is all just so broken and wrong. The only guest.MAXPHYADDR =
that
> > > > >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims=
 to
> > > > >> support a smaller guest.MAXPHYADDR, then KVM is obligated to int=
ercept
> > > > >> every #PF,
> > > >
> > > > in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU sup=
ports only
> > > > 4-level EPT), KVM has no need to intercept #PF because accessing a =
GPA with
> > > > RSVD bits 51-48 set leads to EPT violation.
> > >
> > > At the completion of the page table walk, if there is a permission
> > > fault, the data address should not be accessed, so there should not b=
e
> > > an EPT violation. Remember Meltdown?
> > >
> > > > >> and to emulate the faulting instruction to see if the RSVD
> > > > >> bit should be set in the error code. Hardware isn't going to do =
it.
> > > >
> > > > Note for EPT violation VM exits, the CPU stores the GPA that caused=
 this exit
> > > > in "guest-physical address" field of VMCS. so, it is not necessary =
to emulate
> > > > the faulting instruction to determine if any RSVD bit is set.
> > >
> > > There should not be an EPT violation in the case discussed.
> >
> > For intercepted #PF, we can use CR2 to determine the necessary page
> > walk, and presumably the rest of the bits in the error code are
> > already set, so emulation is not necessary.
> >
> > However, emulation is necessary when synthesizing a #PF from an EPT
> > violation, and bit 8 of the exit qualification is clear. See
> > https://lore.kernel.org/kvm/4463f391-0a25-017e-f913-69c297e13c5e@redhat=
.com/.
>
> Although not all memory-accessing instructions are emulated, it covers mo=
st common
> cases and is always better than KVM hangs anyway. We may probably continu=
e to
> improve allow_smaller_maxphyaddr, but KVM should report the maximum physi=
cal width
> it supports.

KVM can only support the host MAXPHYADDR. If EPT on the CPU doesn't
support host MAXPHYADDR, it should be disabled. Shadow paging can
handle host MAXPHYADDR just fine.

KVM simply does not work when guest MAXPHYADDR < host MAXPHYADDR.
Without additional hardware support, no hypervisor can. I asked Intel
to add hardware support for such configurations about 15 years ago. I
have yet to see it.

> Thanks,
> Tao
>

