Return-Path: <kvm+bounces-5661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D1A8246CB
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 18:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6174B2142F
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 17:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B53C25554;
	Thu,  4 Jan 2024 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fQbpyKSB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A47F25550
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 17:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-553e36acfbaso15397a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 09:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704387744; x=1704992544; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kv21bBfppCjNrzsws9Yt1EVRTP1/z5uxE1YTCWYfIA=;
        b=fQbpyKSBmEAmaQoa8NuTJLvWuUMkB90tVOiBsymJ8AdKBsVQ7qajvhFkTsLcMcbkWP
         2qUFl3BSdCmWE/ArrRQ1J4n6g06QlPwniedCaLbsg/uNg0I96GCWb3fJ09YgajODufzI
         Prj0r1W9L4jZSqLqL0kf8UPYzU8R8H083HMPoy7J6kRjW9ToI+sQjD3Gjd02CMwnMRfC
         dddKzrGHZBJUEGUQz5pglnKtfONNRKc6lwP/qnQ7cSoDiR9UVOmDxN/JWS+Tuq+7w1/8
         Vd9iDwLwaosyR8UC5pbkz6zL1WMM2KLrpGQhHcNfgIT3uL+8waSEBR20UFxapW+ThSFn
         n2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704387744; x=1704992544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+kv21bBfppCjNrzsws9Yt1EVRTP1/z5uxE1YTCWYfIA=;
        b=FPI9rgAfSva0xWq7Zez0QFu064A595pzqIsxZOUvYRbTiNWtE5kNH5puDt+b6aHuH9
         9knkCVST8JYUGK+h7WmgblHkY17w+aFUR70/7XipgaNwZyxy1ySXiMDAampH4kFR2qSt
         66ZR8tyIEXdVGSK+Mwtxn0EpKE7DTfDhBNN9sSZ+yPea8Gr0ysV8EenwowYpbpVYFJHW
         k6MTicp8Ev8Nd3u+jMXA+//2xOrKYskC/3Jm7WGMakY1r2e7h1tHVkPUewQfurv0kwTO
         TUuKK9+IhE36AKN6lIaGiNFn1LK2h32ZHSGjZK0aQXpkd5v+ayUnt52iN58VVx5FiCHM
         sfnQ==
X-Gm-Message-State: AOJu0YxkpeOIu0L2hQbwVkjOQQ/avzhsty7dLM7mcff1ASGkN6268My2
	H5s66RJY8OW/Wqs7nehLpnIkafIfNZ0F7FmYI73a/kciiSeb
X-Google-Smtp-Source: AGHT+IGLv7GyUAKSA2yerSYxa7iLcRnf9ANAiv1X4pDJC+7x+zEkCHMjiG6MevugNZ+LNwaLu0o75hDJeRQ4APnqlTo=
X-Received: by 2002:a50:9ece:0:b0:554:2501:cc8e with SMTP id
 a72-20020a509ece000000b005542501cc8emr366833edf.6.1704387744283; Thu, 04 Jan
 2024 09:02:24 -0800 (PST)
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
 <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com> <ZZbJxgyYoEJy+bAj@chao-email>
In-Reply-To: <ZZbJxgyYoEJy+bAj@chao-email>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 4 Jan 2024 09:02:09 -0800
Message-ID: <CALMp9eTf=9VqM=xutOXmgRr+aFz-YhOz6h4B+uLgtFBXtHefPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
To: Chao Gao <chao.gao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 7:08=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrote:
>
> On Wed, Jan 03, 2024 at 07:40:02PM -0800, Jim Mattson wrote:
> >On Wed, Jan 3, 2024 at 6:45=E2=80=AFPM Chao Gao <chao.gao@intel.com> wro=
te:
> >>
> >> On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
> >> >On Tue, Jan 02, 2024, Jim Mattson wrote:
> >> >> On Tue, Jan 2, 2024 at 3:24=E2=80=AFPM Sean Christopherson <seanjc@=
google.com> wrote:
> >> >> >
> >> >> > On Thu, Dec 21, 2023, Xu Yilun wrote:
> >> >> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson w=
rote:
> >> >> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.=
c
> >> >> > > > > index c57e181bba21..72634d6b61b2 100644
> >> >> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> >> >> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> >> >> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_b=
its(struct kvm_vcpu *vcpu,
> >> >> > > > >   reset_guest_paging_metadata(vcpu, mmu);
> >> >> > > > >  }
> >> >> > > > >
> >> >> > > > > +/* guest-physical-address bits limited by TDP */
> >> >> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> >> >> > > > > +{
> >> >> > > > > + return max_tdp_level =3D=3D 5 ? 57 : 48;
> >> >> > > >
> >> >> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
> >> >> > > >
> >> >> > > >   Bits 56:52 of each guest-physical address are necessarily z=
ero because
> >> >> > > >   guest-physical addresses are architecturally limited to 52 =
bits.
> >> >> > > >
> >> >> > > > Rather than split hairs over something that doesn't matter, I=
 think it makes sense
> >> >> > > > for the CPUID code to consume max_tdp_level directly (I forgo=
t that max_tdp_level
> >> >> > > > is still accurate when tdp_root_level is non-zero).
> >> >> > >
> >> >> > > It is still accurate for now. Only AMD SVM sets tdp_root_level =
the same as
> >> >> > > max_tdp_level:
> >> >> > >
> >> >> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
> >> >> > >                         get_npt_level(), PG_LEVEL_1G);
> >> >> > >
> >> >> > > But I wanna doulbe confirm if directly using max_tdp_level is f=
ully
> >> >> > > considered.  In your last proposal, it is:
> >> >> > >
> >> >> > >   u8 kvm_mmu_get_max_tdp_level(void)
> >> >> > >   {
> >> >> > >       return tdp_root_level ? tdp_root_level : max_tdp_level;
> >> >> > >   }
> >> >> > >
> >> >> > > and I think it makes more sense, because EPT setup follows the =
same
> >> >> > > rule.  If any future architechture sets tdp_root_level smaller =
than
> >> >> > > max_tdp_level, the issue will happen again.
> >> >> >
> >> >> > Setting tdp_root_level !=3D max_tdp_level would be a blatant bug.=
  max_tdp_level
> >> >> > really means "max possible TDP level KVM can use".  If an exact T=
DP level is being
> >> >> > forced by tdp_root_level, then by definition it's also the max TD=
P level, because
> >> >> > it's the _only_ TDP level KVM supports.
> >> >>
> >> >> This is all just so broken and wrong. The only guest.MAXPHYADDR tha=
t
> >> >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
> >> >> support a smaller guest.MAXPHYADDR, then KVM is obligated to interc=
ept
> >> >> every #PF,
> >>
> >> in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU suppor=
ts only
> >> 4-level EPT), KVM has no need to intercept #PF because accessing a GPA=
 with
> >> RSVD bits 51-48 set leads to EPT violation.
> >
> >At the completion of the page table walk, if there is a permission
> >fault, the data address should not be accessed, so there should not be
> >an EPT violation. Remember Meltdown?
>
> You are right. I missed this case. KVM needs to intercept #PF to set RSVD=
 bit
> in PFEC.

I have no problem with a user deliberately choosing an unsupported
configuration, but I do have a problem with KVM_GET_SUPPORTED_CPUID
returning an unsupported configuration.

guest MAXPHYADDR < host MAXPHYADDR has the following issues:

1. In PAE mode, MOV to CR3 will not raise #GP for guest-reserved bits
in PDPTRs that are not host-reserved.
2. #PF for permission violations will not set the RSVD bit in the
error code for guest-reserved bits in the final data address PFN that
are not host-reserved.
3. #PF for other PFNs with guest-reserved bits that are not
host-reserved may not accurately set the non-RSVD bits (e.g. U/S, R/W)
in the error code.

Fix these three issues, and I will happily withdraw my objection.

