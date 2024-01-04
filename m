Return-Path: <kvm+bounces-5616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 730C8823B73
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 05:34:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0670F2881E6
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 04:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADC51944E;
	Thu,  4 Jan 2024 04:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="evBABDZT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE1F18EBD
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 04:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-54744e66d27so7873a12.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 20:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704342872; x=1704947672; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WiduSvz2qwF5XFSa8IPogiKWFeLiNjhMyhNSncPk3c=;
        b=evBABDZTXvdBVU0yIoLwk1IXMbsjKCYlJjBafOzwDwr+oSbDVFqfZCLeYkpyfsojKG
         AZlZMXID4NlRhQg1rcHoiMrL516AUuyj2G+gmyr7JPOW3KduW72TQo38E1n0bv5JLQZo
         0RJVSz6/1AjLE0rlQgW/tM9Y6m3zwo04sXo2PEb3QrIAr7f0/CVipGEyveoTIwGtggtl
         WEnj0SjamZCIq2Hjd02Lu6hZ1cwH9fXATP9afyLq9dDA8rIN7Aivz4brOwUsUV0iXUtz
         djQT0mbWidvmfYKrEBWE+uG/YxlF5x3YG1adBiEP3aGj11CZoXepo93LNOzfaZEw+tKQ
         4qOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704342872; x=1704947672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+WiduSvz2qwF5XFSa8IPogiKWFeLiNjhMyhNSncPk3c=;
        b=R4coEWdCXfXMTaFGFr0jWbmrqLj9coGD5quaiwohaU+U1eQQkkiMhheQWmG/cKT+9m
         0j9f3P5s3XUXtc1gtQoOt76Mhle6bd8CHXnKxuSlKN78pzf0DCZs7dICOmL3JSmEk2DL
         O7E1D9jqS3I6cFGt1rbgZCQfbQqNy4zcSWdRdrzg+N9RCjjBckosxwJLCjKdDWY5reTU
         zwndTLoUyx6st2dw83Q8Dhf9nTUJnx0z8632rDJBVNXIfCjSJvNZ8P87hoHUjlsuMTbN
         upTXjZIqVIWijt0/KF8Cl1UYLw8Fs52UihSLG1vPh0wvCqk+ohrpvajh+8SJIeBRxvKs
         hXXQ==
X-Gm-Message-State: AOJu0YzrOWATFaWKllBGJP8eyZlDgJZHYUvPjhl4PYt/DNHVBSOk57z9
	2+gcN2xyTwfFA61etxVLSrQX6+VsrovvM0r2oFrBk/tof4xs
X-Google-Smtp-Source: AGHT+IHjt+NAeLCTCeEt3O4NCeJAa0EZ21ZtVO4/E9M9pFJJWIyMdd1N8j6RuPV8B0vgrGRoTWdOOFHdbOmrg45V/XQ=
X-Received: by 2002:a05:6402:380c:b0:557:24d:6135 with SMTP id
 es12-20020a056402380c00b00557024d6135mr26327edb.4.1704342871868; Wed, 03 Jan
 2024 20:34:31 -0800 (PST)
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
 <ZZWhuW_hfpwAAgzX@google.com> <ZZYbzzDxPI8gjPu8@chao-email> <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
In-Reply-To: <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 3 Jan 2024 20:34:16 -0800
Message-ID: <CALMp9eRS9o7YDDaOcjBB0QTeF_vRA2LMvQqc2Sb-7XhyDi=1LA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
To: Chao Gao <chao.gao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 7:40=E2=80=AFPM Jim Mattson <jmattson@google.com> wr=
ote:
>
> On Wed, Jan 3, 2024 at 6:45=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrot=
e:
> >
> > On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
> > >On Tue, Jan 02, 2024, Jim Mattson wrote:
> > >> On Tue, Jan 2, 2024 at 3:24=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > >> >
> > >> > On Thu, Dec 21, 2023, Xu Yilun wrote:
> > >> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wr=
ote:
> > >> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > >> > > > > index c57e181bba21..72634d6b61b2 100644
> > >> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > >> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > >> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bi=
ts(struct kvm_vcpu *vcpu,
> > >> > > > >   reset_guest_paging_metadata(vcpu, mmu);
> > >> > > > >  }
> > >> > > > >
> > >> > > > > +/* guest-physical-address bits limited by TDP */
> > >> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> > >> > > > > +{
> > >> > > > > + return max_tdp_level =3D=3D 5 ? 57 : 48;
> > >> > > >
> > >> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
> > >> > > >
> > >> > > >   Bits 56:52 of each guest-physical address are necessarily ze=
ro because
> > >> > > >   guest-physical addresses are architecturally limited to 52 b=
its.
> > >> > > >
> > >> > > > Rather than split hairs over something that doesn't matter, I =
think it makes sense
> > >> > > > for the CPUID code to consume max_tdp_level directly (I forgot=
 that max_tdp_level
> > >> > > > is still accurate when tdp_root_level is non-zero).
> > >> > >
> > >> > > It is still accurate for now. Only AMD SVM sets tdp_root_level t=
he same as
> > >> > > max_tdp_level:
> > >> > >
> > >> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
> > >> > >                         get_npt_level(), PG_LEVEL_1G);
> > >> > >
> > >> > > But I wanna doulbe confirm if directly using max_tdp_level is fu=
lly
> > >> > > considered.  In your last proposal, it is:
> > >> > >
> > >> > >   u8 kvm_mmu_get_max_tdp_level(void)
> > >> > >   {
> > >> > >       return tdp_root_level ? tdp_root_level : max_tdp_level;
> > >> > >   }
> > >> > >
> > >> > > and I think it makes more sense, because EPT setup follows the s=
ame
> > >> > > rule.  If any future architechture sets tdp_root_level smaller t=
han
> > >> > > max_tdp_level, the issue will happen again.
> > >> >
> > >> > Setting tdp_root_level !=3D max_tdp_level would be a blatant bug. =
 max_tdp_level
> > >> > really means "max possible TDP level KVM can use".  If an exact TD=
P level is being
> > >> > forced by tdp_root_level, then by definition it's also the max TDP=
 level, because
> > >> > it's the _only_ TDP level KVM supports.
> > >>
> > >> This is all just so broken and wrong. The only guest.MAXPHYADDR that
> > >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
> > >> support a smaller guest.MAXPHYADDR, then KVM is obligated to interce=
pt
> > >> every #PF,
> >
> > in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU support=
s only
> > 4-level EPT), KVM has no need to intercept #PF because accessing a GPA =
with
> > RSVD bits 51-48 set leads to EPT violation.
>
> At the completion of the page table walk, if there is a permission
> fault, the data address should not be accessed, so there should not be
> an EPT violation. Remember Meltdown?
>
> > >> and to emulate the faulting instruction to see if the RSVD
> > >> bit should be set in the error code. Hardware isn't going to do it.
> >
> > Note for EPT violation VM exits, the CPU stores the GPA that caused thi=
s exit
> > in "guest-physical address" field of VMCS. so, it is not necessary to e=
mulate
> > the faulting instruction to determine if any RSVD bit is set.
>
> There should not be an EPT violation in the case discussed.

For intercepted #PF, we can use CR2 to determine the necessary page
walk, and presumably the rest of the bits in the error code are
already set, so emulation is not necessary.

However, emulation is necessary when synthesizing a #PF from an EPT
violation, and bit 8 of the exit qualification is clear. See
https://lore.kernel.org/kvm/4463f391-0a25-017e-f913-69c297e13c5e@redhat.com=
/.

> > >> Since some page faults may occur in CPL3, this means that KVM has to
> > >> be prepared to emulate any memory-accessing instruction. That's not
> > >> practical.
> >
> > as said above, no need to intercept #PF for this specific case.
>
> I disagree. See above.

