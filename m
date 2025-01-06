Return-Path: <kvm+bounces-34646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BC0A03362
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 00:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF0EE1885736
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 23:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C03B1E25EA;
	Mon,  6 Jan 2025 23:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xZP47l12"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B631D95B3
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 23:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736206857; cv=none; b=X9FvukWy/nzM2g5LenoddLOhD7D+kBBeIrI5mN4g9dc9WjvgsziLVWkXY52PHERfRU5zXxjC2DeHEBMnOScFaVC7ULedXWzvnNg0WCrMHMnN5STwJ2JQJvJJe6kxykB+LKATPdcnodcLjk/QbxmRDTTAW4ofMLRH48B65HMCP/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736206857; c=relaxed/simple;
	bh=RSi/eada5ERifAIkSjtaFjfXEIsPFdBbGYyHHnPEaeY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rr3Dn4o7RCPj47HsIEyz4yDidVENh2qFikuA++MZ1eIzAPDWHw/gkiP+22e13x+P4t7+d87dPV2/WQhy+j9j0TGcVEVh9ISztolgly9zr0t5YAxDp/KmYySpLtd/HO0HgyoZhzv8jqzhEgqqf2nm00SaPYu4buGpsMx6R9bwIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xZP47l12; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166a1a5cc4so196303045ad.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 15:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736206855; x=1736811655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vuSwG3sKfNi1x4ioaTkeZg38GwW8BVOiPk2WOnNEypU=;
        b=xZP47l12e6tP/4Fq1dqARDECYGnMns6bbZp0xCl6MC3zCo9sdgo3HjvBBjV6hIRZ8C
         N+4mPP94rEdYl3qyYdrSTvGZe81TCLQLzh9kPTd702UdV4JdHXasiuuCEG0unsmT+TVq
         sptKtmLY6/JOsH4RNZxeVfKNxiWCZj0fU3GXOhj4SOQ2TzH8RG43toDokQ4Uf3b3iDpI
         lLfVhqWDTln96VqY9986GAof0IbxZOgZKqmbh+60TSwg6tsDzmHUhQKIEYFhixnjIYrA
         1igksxVSEttTPFj91zfoYpGZSpp5mVPlzx7DT8v2ZDY/SrFCfyLRAipQHI7GUYrax7fz
         RbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736206855; x=1736811655;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vuSwG3sKfNi1x4ioaTkeZg38GwW8BVOiPk2WOnNEypU=;
        b=p1eYchID/gcvmbA5bpIy2xhERCQqZORenZP0aa1zE7OOX7qJuu0oUihcicgkeQPI5Z
         VaEPUZNM53LnRllJCOJ+lgvwo/K+tJUMCmQOgzgvjlBDfqG1oEP3llP7K1i2kG5j6BfK
         NqFrFoQ+JSQGMbGVfeB4+DmCyn5fIsSlV5fI5gSE1dnZxRZkLBk/hARELOaTiGpiC/BS
         cS8eJHqb+ryz12BuxKM6V2Hn7umRSDSOvW2icwUGKw/t666Ip1hnam7+zOeZsioZYYVC
         zwcxUSHqco3DHknwsmcwr+/MwKT2pQ2OFcuz3WWbWu2EEWLU5iYFrPVtxcZWw8xUgTuj
         kMfg==
X-Forwarded-Encrypted: i=1; AJvYcCWU4rqDQath5kPlyw61YJtPbz8Zo01KM/EX/66ZDvnWBvjl0BQdOQTE9YaWSkNYKs4b5Sc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZYxdDTLpwOw6dL/E0G/Aof7cJi2kYJoC2AIqCvqJBCMGO+0cx
	EGpG3GTvd4DflLM2xebVEg22BQtmTv9z2LdaDvY8l0NKRS3ulcfig1mM3VdPv0LDmCH8wskkNoV
	9Iw==
X-Google-Smtp-Source: AGHT+IGpIAGyX5YN2f8y3UKY+kE9dnb8TQCtlkupB6sPMBGWNMRT7YCFSm+lM+QG9IgF+GNTBkn858Y0JJQ=
X-Received: from pfbeg12.prod.google.com ([2002:a05:6a00:800c:b0:725:ed29:3cf5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12d5:b0:1e1:a6a6:848
 with SMTP id adf61e73a8af0-1e5e04a2ea0mr103630509637.25.1736206855569; Mon,
 06 Jan 2025 15:40:55 -0800 (PST)
Date: Mon, 6 Jan 2025 15:40:54 -0800
In-Reply-To: <CAGtprH_JYQvBimSLkb3qgshPbrUE+Z2dTz8vEvEwV1v+OMD6Mg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
 <fc6294b7-f648-4daa-842d-0b74211f8c3a@linux.intel.com> <CAGtprH_JYQvBimSLkb3qgshPbrUE+Z2dTz8vEvEwV1v+OMD6Mg@mail.gmail.com>
Message-ID: <Z3xqBpIgU6-OGWaj@google.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2025, Vishal Annapurve wrote:
> On Sun, Jan 5, 2025 at 5:46=E2=80=AFPM Binbin Wu <binbin.wu@linux.intel.c=
om> wrote:
> > On 1/4/2025 5:59 AM, Vishal Annapurve wrote:
> > > On Sun, Dec 8, 2024 at 5:11=E2=80=AFPM Binbin Wu <binbin.wu@linux.int=
el.com> wrote:
> > >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > >> index b0f525069ebd..b51d2416acfb 100644
> > >> --- a/arch/x86/kvm/vmx/tdx.c
> > >> +++ b/arch/x86/kvm/vmx/tdx.c
> > >> @@ -2143,6 +2143,8 @@ static int __tdx_td_init(struct kvm *kvm, stru=
ct td_params *td_params,
> > >>                  goto teardown;
> > >>          }
> > >>
> > >> +       kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
> > >> +
> > >>          return 0;
> > >>
> > >>          /*
> > >> @@ -2528,6 +2530,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *v=
cpu, u64 vcpu_rcx)
> > >>                  return -EIO;
> > >>          }
> > >>
> > >> +       vcpu->arch.apic->apicv_active =3D false;
> > > With this setting, apic_timer_expired[1] will always cause timer
> > > interrupts to be pending without injecting them right away. Injecting
> > > it after VM exit [2] could cause unbounded delays to timer interrupt
> > > injection.
> >
> > When apic->apicv_active is false, it will fallback to increasing the
> > apic->lapic_timer.pending and request KVM_REQ_UNBLOCK.
> > If apic_timer_expired() is called from timer function, the target vCPU
> > will be kicked out immediately.
> > So there is no unbounded delay to timer interrupt injection.
>=20
> Ack. Though, wouldn't it be faster to just post timer interrupts right
> away without causing vcpu exit?

Yes, but if and only if hrtimers are offloaded to dedicated "housekeeping" =
CPUs.
If the hrtimer is running on the same pCPU that the vCPU is running on, the=
n the
expiration of the underlying hardware timer (in practice, the "real" APIC t=
imer)
will generate a host IRQ and thus a VM-Exit.  I.e. the vCPU will already be=
 kicked
into the host, and the virtual timer IRQ will be delivered prior to re-ente=
ring
the guest.

Note, kvm_use_posted_timer_interrupt() uses a heuristic of HLT/MWAIT interc=
eption
being disabled to detect that it's worth trying to post a timer interrupt, =
but off
the top of my head I'm pretty sure that's unnecessary and pointless.  The
"vcpu->mode =3D=3D IN_GUEST_MODE" is super cheap, and I can't think of any =
harm in
posting the time interrupt if the target vCPU happens to be in guest mode e=
ven
if the host wasn't configured just so.

> Another scenario I was thinking of was hrtimer expiry during vcpu exit
> being handled in KVM/userspace, which will cause timer interrupt
> injection after the next exit [1] delaying timer interrupt to guest.

No, the IRQ won't be delayed.  Expiration from the hrtimer callback will se=
t
KVM_REQ_UNBLOCK, which will prevent actually entering the guest (see the ca=
ll
to kvm_request_pending() in kvm_vcpu_exit_request()).

> This scenario is not specific to TDX VMs though.
>=20
> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/x86=
.c?h=3Dkvm-coco-queue#n11263

