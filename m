Return-Path: <kvm+bounces-5486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D5B8225FF
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 01:35:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A9961C21B99
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 00:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7209615AF;
	Wed,  3 Jan 2024 00:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BkrUK8XI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CD71365
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 00:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5534180f0e9so2626a12.1
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 16:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704242090; x=1704846890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQYSMPbyBC8yrUBHrw/41iVyhb5UQnmyTFPO9vw4t7I=;
        b=BkrUK8XIXlMs+lPgf2OJKRH/uTQxs3AuH8OicXHnb2Ir3cLdsgxcufuTgr7mKalawc
         mszP5UAuqbZy57wYCqjc673sP8Grh5gi4O4RQtlQWIrQi7irYECJ8p4Hk6rHujiSLuBI
         Q19KHod+r4VbPy+CgDxwhcJTp0Z2nmTIGfXQmZLuEj6fSxP3ue+/MPANTnKuEyfMPdWS
         gKSY/g8chcYVKgYbiAsqsUeiOx0SjxSGfg3K1Jzn9JjEI+WLkrXUPbSzWlO33sAZAlgz
         jW2T7XkHQU3lDXzEEK1akuoCw8Qv6SIInmgs/618de55Sm+pkFoJ99NRiqLxKX3scX/z
         pf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704242090; x=1704846890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MQYSMPbyBC8yrUBHrw/41iVyhb5UQnmyTFPO9vw4t7I=;
        b=X4eFnbVnycS8i1xR0lcxKAGB1o4gluBCn54bpnW/6y3gmy8+Yw+Q88QtT5re9yPt1t
         zlGnYIJ5pWMr3N4ACE5Wuc1wYTXBwVdCGQnCygKsQDOndG+lkftAGSnKrVjOeMNjTkXf
         uQwJARVQxRB26+WE5tqCyIbyvu6KUPY2wUf5wW7cq1JsOiCgPNHVI1Z+P0kzg1uEgbhp
         VmJa5aoV2VhOpg8PtsHVqPTRDuElXtAdHyA3FoFt++bZf301i9I7QfOHQvso7MpNWI6D
         geWvWZS+R6ZdNVqhgLye6ZBfzmrvbR+a6KJXFOJ85AL1HWhBR7C/BL2i2LmRmbsoNsXe
         fRRQ==
X-Gm-Message-State: AOJu0YzdtN+c652i6/LBJJkdivRJfZbazeujDBtc12fVUFILxVls50dN
	xp6jQlqZ7oMatLxU6GanqRuMMphCqeN7laED5+IofhbqXXfS
X-Google-Smtp-Source: AGHT+IHox1gLASyYbSselT6JFr/7hB0/DThayseDRT1TrosPwh3p/HwqcFcAuu5xS6cWufxG0TBeapvldhRAPFp9fL8=
X-Received: by 2002:a50:c191:0:b0:553:ee95:2b4f with SMTP id
 m17-20020a50c191000000b00553ee952b4fmr22559edf.3.1704242090231; Tue, 02 Jan
 2024 16:34:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050> <ZZSbLUGNNBDjDRMB@google.com>
In-Reply-To: <ZZSbLUGNNBDjDRMB@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 2 Jan 2024 16:34:38 -0800
Message-ID: <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
To: Sean Christopherson <seanjc@google.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, Tao Su <tao1.su@linux.intel.com>, 
	kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com, 
	chao.gao@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 2, 2024 at 3:24=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Dec 21, 2023, Xu Yilun wrote:
> > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index c57e181bba21..72634d6b61b2 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(stru=
ct kvm_vcpu *vcpu,
> > > >   reset_guest_paging_metadata(vcpu, mmu);
> > > >  }
> > > >
> > > > +/* guest-physical-address bits limited by TDP */
> > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> > > > +{
> > > > + return max_tdp_level =3D=3D 5 ? 57 : 48;
> > >
> > > Using "57" is kinda sorta wrong, e.g. the SDM says:
> > >
> > >   Bits 56:52 of each guest-physical address are necessarily zero beca=
use
> > >   guest-physical addresses are architecturally limited to 52 bits.
> > >
> > > Rather than split hairs over something that doesn't matter, I think i=
t makes sense
> > > for the CPUID code to consume max_tdp_level directly (I forgot that m=
ax_tdp_level
> > > is still accurate when tdp_root_level is non-zero).
> >
> > It is still accurate for now. Only AMD SVM sets tdp_root_level the same=
 as
> > max_tdp_level:
> >
> >       kvm_configure_mmu(npt_enabled, get_npt_level(),
> >                         get_npt_level(), PG_LEVEL_1G);
> >
> > But I wanna doulbe confirm if directly using max_tdp_level is fully
> > considered.  In your last proposal, it is:
> >
> >   u8 kvm_mmu_get_max_tdp_level(void)
> >   {
> >       return tdp_root_level ? tdp_root_level : max_tdp_level;
> >   }
> >
> > and I think it makes more sense, because EPT setup follows the same
> > rule.  If any future architechture sets tdp_root_level smaller than
> > max_tdp_level, the issue will happen again.
>
> Setting tdp_root_level !=3D max_tdp_level would be a blatant bug.  max_td=
p_level
> really means "max possible TDP level KVM can use".  If an exact TDP level=
 is being
> forced by tdp_root_level, then by definition it's also the max TDP level,=
 because
> it's the _only_ TDP level KVM supports.

This is all just so broken and wrong. The only guest.MAXPHYADDR that
can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
support a smaller guest.MAXPHYADDR, then KVM is obligated to intercept
every #PF, and to emulate the faulting instruction to see if the RSVD
bit should be set in the error code. Hardware isn't going to do it.
Since some page faults may occur in CPL3, this means that KVM has to
be prepared to emulate any memory-accessing instruction. That's not
practical.

Basically, a CPU with more than 48 bits of physical address that
doesn't support 5-level EPT really doesn't support EPT at all, except
perhaps in the context of some new paravirtual pinky-swear from the
guest that it doesn't care about the RSVD bit in #PF error codes.

