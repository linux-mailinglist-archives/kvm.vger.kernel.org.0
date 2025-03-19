Return-Path: <kvm+bounces-41519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30915A699A3
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 20:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E04A77A4EDC
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625772144C1;
	Wed, 19 Mar 2025 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u/ybkW9V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3453720AF6C
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 19:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742413374; cv=none; b=iLcZxnbjvmR0DP5vTKYYOgx5+duDmQjBrbCDMK5LiUYHv7D/z+VEnXN5iCqpIzp58smB7ym7+G2+iw4UxLDXFInSaPQaQfdyOrXmd2hbgC2GrrguIyYVnX4IRIByng2/Lp+wyz4vZRYOYiQNr68j01XxuUiBotqlWv5JkpsHyuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742413374; c=relaxed/simple;
	bh=gh62FIVPZu0EdoToosv/Zt/Zo0qJiBu+Z+qg9l46S7k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rbs8KNV9y2+HBYgqm/2YoPWPNLcTxpz3OQ33nuWidSUNnFFX4lYfKLeP84xP3qY9WIcBVgiDkUrQL9Z008Y6hLygerq0QtBvC4LkTtHs/LBE2veWfyNOqKVkFVWQ/DS1ajGFx6SJYN6K3oZy8j/cFTEyTFbf0jXQCHnGHaDpfow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u/ybkW9V; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff55176edcso60177a91.1
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 12:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742413372; x=1743018172; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dpeipgB+WntqlXZBKd/NdRZfQvA7b+Udkq1V7lwwSzc=;
        b=u/ybkW9VRbJ1jybysI2S4V1fShGyM3z5VLYp644c18i2OnlcIUE/G19Y9GLFYPXkOW
         sBnecIqw4vzD6u3QfCW1rZZgaM6slxzfRuQQtvV/JE9KulFUjFt9bRrFH5Ug6i6A2sxJ
         Xx+nVFLyFkSDP5oXTKVH+mdCACC7GVUKMui4badweAmRxkgYXWpE9AqdFpx57gm3V08V
         uIwiZc3h7shQkjK9cb7bV+39nomz6LD44J/JOcUGw1/7y49pFMK/gab5rbFYBkbsqu4i
         jbmHJExmixqiv4be72zTAwGo2kTgkiSHgKfj2AZITvjsVfyF3UWhUvYU1NA3lfumGLm1
         S+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742413372; x=1743018172;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dpeipgB+WntqlXZBKd/NdRZfQvA7b+Udkq1V7lwwSzc=;
        b=Bgnls43NgDR2oqx/2x3otijT8sQKgT8KgN/6kOInKt5qy2QQvrbLMS5gKJvjGhNU+Y
         HL8aoopIBzbIy7R6tMy3omQpPnKH0wnnWK8WqH+9mGn4HMKmIEMRZ3purmIzsL34Wpvz
         /Kh2GX0wsxePaI1kYqCKtfTUPDSqlG4FKIrBci7j3KuTdvGlUl9k+cICgqo8YAGWBLDM
         HjGj08IDPzg3iOW5naPH9ceE8uBpH7v83d0qD/R43gi+K9mlpZu2pCN3fQqZW/84r9To
         nln5KVOnjTfFldATgWqIkA7YbXVwQyHMk/E+bLTqGTu+SvcjkkB95eHTt6T6WeRLlEWA
         Tdag==
X-Gm-Message-State: AOJu0Yzac6ifLSUk1Ss5+wmN9pG23jII+BXKXEwAwqUrZoX33CiB72Mj
	TXQu4HYRtIO9NcKUK1N8i40/icakHOoaj7139iygbSKbFIA4OZ+Y0CJR+WdmzUpIl7xLyIyx4Hb
	iFw==
X-Google-Smtp-Source: AGHT+IE2vRTB7erCr3jsjMDXJZ7+JqiiqoN8wO65xq7TB4CwgXYDX0KR80dvLN7T/IwZtUw6I1og/OdJS3A=
X-Received: from pjbsi9.prod.google.com ([2002:a17:90b:5289:b0:2fc:aac:e580])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2809:b0:2ef:114d:7bf8
 with SMTP id 98e67ed59e1d1-301d5080149mr701882a91.6.1742413372336; Wed, 19
 Mar 2025 12:42:52 -0700 (PDT)
Date: Wed, 19 Mar 2025 12:42:50 -0700
In-Reply-To: <CABgObfbMDAtaLvaLrDA7ptU+9kjej_LVArp3dCNao8+qtiEDww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com> <CABgObfbMDAtaLvaLrDA7ptU+9kjej_LVArp3dCNao8+qtiEDww@mail.gmail.com>
Message-ID: <Z9seOpLCVfAqHife@google.com>
Subject: Re: [GIT PULL] KVM: x86: Changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2025, Paolo Bonzini wrote:
> On Tue, Mar 18, 2025 at 7:03=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > There are two conflicts between the PV clock pull request and the Xen
> > pull request.
> >
> > 1. The Xen branch moves Xen TSC leaf updates to CPUID emulation, and th=
e PV
> >    clock branch renames the fields in kvm_vcpu_arch that are used to up=
date
> >    the Xen leafs.  After the dust settles, kvm_cpuid() should look like=
:
> >
> >                 } else if (IS_ENABLED(CONFIG_KVM_XEN) &&
> >                            kvm_xen_is_tsc_leaf(vcpu, function)) {
> >                         /*
> >                          * Update guest TSC frequency information if ne=
cessary.
> >                          * Ignore failures, there is no sane value that=
 can be
> >                          * provided if KVM can't get the TSC frequency.
> >                          */
> >                         if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcp=
u))
> >                                 kvm_guest_time_update(vcpu);
> >
> >                         if (index =3D=3D 1) {
> >                                 *ecx =3D vcpu->arch.pvclock_tsc_mul;
> >                                 *edx =3D vcpu->arch.pvclock_tsc_shift;
> >                         } else if (index =3D=3D 2) {
> >                                 *eax =3D vcpu->arch.hw_tsc_khz;
> >                         }
> >                 }
> >
> > 2. The Xen branch moves and renames xen_hvm_config so that its xen.hvm_=
config,
> >    while PV clock branch shuffles use of xen_hvm_config/xen.hvm_config =
flags.
> >    The resulting code in kvm_guest_time_update() should look like:
> >
> > #ifdef CONFIG_KVM_XEN
> >         /*
> >          * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BI=
T as unless
> >          * explicitly told to use TSC as its clocksource Xen will not s=
et this bit.
> >          * This default behaviour led to bugs in some guest kernels whi=
ch cause
> >          * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclo=
ck flags.
> >          *
> >          * Note!  Clear TSC_STABLE only for Xen clocks, i.e. the order =
matters!
> >          */
> >         if (ka->xen.hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_U=
NSTABLE)
> >                 hv_clock.flags &=3D ~PVCLOCK_TSC_STABLE_BIT;
> >
> >         if (vcpu->xen.vcpu_info_cache.active)
> >                 kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_i=
nfo_cache,
> >                                         offsetof(struct compat_vcpu_inf=
o, time));
> >         if (vcpu->xen.vcpu_time_info_cache.active)
> >                 kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_t=
ime_info_cache, 0);
> > #endif
>=20
> Thanks, pulled everything to kvm/queue. I assume you want me to put
> the following on top:
>=20
> * KVM: Drop kvm_arch_sync_events() now that all implementations are nops
> * KVM: x86: Fold guts of kvm_arch_sync_events() into kvm_arch_pre_destroy=
_vm()
> * KVM: x86: Unload MMUs during vCPU destruction, not before
> * KVM: Assert that a destroyed/freed vCPU is no longer visible
> * KVM: x86: Don't load/put vCPU when unloading its MMU during teardown

Sure, or wait until 6.16.  The urgent changes in that series already got in=
to
6.14.  AFAIK there's no need to get the rest into 6.15 (not sure if waiting=
 would
make TDX enabling more annoying).

