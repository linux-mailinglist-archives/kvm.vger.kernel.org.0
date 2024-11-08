Return-Path: <kvm+bounces-31224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D4A9C15C0
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 05:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59EA7284B5B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 04:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9908F1CF7B1;
	Fri,  8 Nov 2024 04:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cmYh+Ftz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFFA29CEF
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 04:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731041698; cv=none; b=bPOPlMdq+QOjG+ifOVBQ91AmSL/A2iGd5ugUlAPoBq8Ao41p4MV1FmRpUSeo7Hz8sda4/YUDz5HddhkwGZ/RvHxM6+UWdktOPOMlJ2DbM5QqMdhmUsgHiXb6dgYrgfXsLkgqR1/e49CeHpsXlibn9mZGMlNkOyHnFIMhntZdKMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731041698; c=relaxed/simple;
	bh=2xQmX4s0JykS7A/Tc6c/t/SLBjSG0+FumPRaKt9camw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=My/skOIi6imStw/n016GrU2lbJADQTZai/XIhdwQry/5nRAzqx0l7sChXOr6Igj5rrsEeupKgkwu7ElF0eRLAFAxvYnO+ZgMT4aZGwmIEDnDP04l0NNNjhMlmHA8Vm39g/dk5H4Q3HRYQfsERHgVuJ6stmmsWPGdVbJ7Rg46aR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cmYh+Ftz; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539e617ef81so6460e87.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 20:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731041695; x=1731646495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSKJzjh5rurwLh+xIWMq383kU498LySuuCRBu3PfCQM=;
        b=cmYh+FtzgXQX4eMouSB983xQwa0FwYFl0kvEzgk+aebyKRcWP1PWVNUTJzS7eHueb3
         PIS+cQrq1vlbil/uRrQjR6f//Cd0e4m7Edizs3MvKtAS3K1za4hex1FWO8W+vQTK1EgO
         MPjrOe0VMbWmYNp3pQBiUsG18HWbcgFniYDw9F63/CbwLQxyJg2P5zmeOD0vRL/6Igpl
         H0oGpgeEn1luyIrdcWm1Z3qc5D7AXXGFGgaoj4YTQ3++HLnYsBRuBpRsBdLB4OlLim9M
         eH0RkwmcqeNHYoh7jiXEH4MNIhvuimxrrz0LvIOPFECAkqMC98TNPvbwvN+obrp9ZftF
         NiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731041695; x=1731646495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bSKJzjh5rurwLh+xIWMq383kU498LySuuCRBu3PfCQM=;
        b=o4+lyUYL29sT//G4V2Rp9m6Knvj+6YVgnyGLimTxNtn6Od3xFlDMLAblT+xYM6p+1v
         FfsoEF0l6Ha0y8BZrBXfBsjnUzZDW4s42Y7wLjc2eQvZqWcFxc74m+Q/j3sMRtl4CRU0
         iP3Lv5hHKOOMClyk3sPj44C6I1d8X34bKmK5NZOzzIFrNsV6Jws7kGBiiybryBhbWZIW
         rqUKBOgjFB17F3Qzow+CynFlp0vcYEVADgnaOOLHqi6yXXqxJzE2Ejd37F0USdp+ep14
         3fHcj2a0tyZghKX7ptBgFayB4TFGTpmc/AaJQAYbcDuxtxLNMvsvYjcMaiqzSxV0FTQL
         bgSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVht56bQGAW2oAEekjofgER/EvGXo9y1vIO8EGq+LNMvXViAvrOBBFPznEaqs6igwkGqzo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5IJatCyWWYYfdH0BbOmXiv++0gHlVD9xN0G/6p/8igqupZ9lP
	+7ARIyrSLnLu9WNVJRL1yfQwxpsb8Xfxg/EcM0Y3oKn6k/Ptpm9v/18H13ID8towpavBGuMBRj3
	ABCWdbDq5p/m4eV4yKDh3+EkzC7MxL6c/CGDt
X-Gm-Gg: ASbGncvt038VGokSo+jH3FGKCdhep9bJvEqQMztmmF9SxGu+FO+CoWNFX5Hjg88ijww
	MNKX//DkZihdeqSpXU04Cl72wsmLve9NTtJgsjm8oY/JzF0ooW8CA7y81r2GEw0ed
X-Google-Smtp-Source: AGHT+IGKIXIuAP01ZsVM+BlzRdxZ0Zhznc/LCRKvW3Ub125dSvD8M1+JFH8FKnICGQVhmKF54W/LE3eK5eVmHfeVlwM=
X-Received: by 2002:ac2:4e44:0:b0:53c:7652:6c97 with SMTP id
 2adb3069b0e04-53d811f1d2cmr527773e87.2.1731041694586; Thu, 07 Nov 2024
 20:54:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031212104.1429609-1-jiaqiyan@google.com> <ZyP6whdv4bmsI13x@linux.dev>
In-Reply-To: <ZyP6whdv4bmsI13x@linux.dev>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 7 Nov 2024 20:54:43 -0800
Message-ID: <CACw3F53Mz_5pqFRyZtQBuF2Qq9314ANnOc360SNM5DtkCNweaw@mail.gmail.com>
Subject: Re: [RFC PATCH v1] KVM: arm64: Introduce KVM_CAP_ARM_SIGBUS_ON_SEA
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, duenwen@google.com, 
	rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

Sorry for getting back to you late...

On Thu, Oct 31, 2024 at 2:46=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Jiaqi,
>
> Thank you for sending this out.
>
> On Thu, Oct 31, 2024 at 09:21:04PM +0000, Jiaqi Yan wrote:
> > Currently KVM handles SEA in guest by injecting async SError into
> > guest directly, bypassing VMM, usually results in guest kernel panic.
> >
> > One major situation of guest SEA is when vCPU consumes uncorrectable
> > memory error on the physical memory. Although SError and guest kernel
> > panic effectively stops the propagation of corrupted memory, it is not
> > easy for VMM and guest to recover from memory error in a more graceful
> > manner.
> >
> > Alternatively KVM can send a SIGBUS BUS_OBJERR to VMM/vCPU, just like
> > how core kernel signals SIGBUS BUS_OBJERR to the poison consuming
> > thread.
> > In addition to the benifit that KVM's handling for SEA becomes aligned
> > with core kernel behavior
> > - The blast radius in VM can be limited to only the consuming thread
> >   in guest, instead of entire guest kernel, unless the consumption is
> >   from guest kernel.
> > - VMM now has the chance to do its duties to stop the VM from repeatedl=
y
> >   consuming corrupted data. For example, VMM can unmap the guest page
> >   from stage-2 table to intercept forseen memory poison consumption,
> >   and for every consumption injects SEA to EL1 with synthetic memory
> >   error CPER.
> >
> > Introduce a new KVM ARM capability KVM_CAP_ARM_SIGBUS_ON_SEA. VMM
> > can opt in this new capability if it prefers SIGBUS than SError
> > injection during VM init. Now SEA handling in KVM works as follows:
>
> I'm somewhat tempted to force the new behavior on userspace
> unconditionally. Working back from an unexpected SError in the VM to the
> KVM SEA handler is a bit of a mess, and can be annoying if the operator
> can't access console logs of the VM.

Ack, I also think involving VMM is preferable than injecting SError
directly to guest.

>
> As it stands today, UAPI expectations around SEAs are platform
> dependent. If APEI claims the SEA and decides to offline a page, the
> user will get a SIGBUS.
>
> So sending a SIGBUS for the case that firmware _doesn't_ claim the SEA
> seems like a good move from a consistency PoV. But it is a decently-sized
> change to do without explicit buy-in from userspace so let's see what
> others think.

Sounds good, I will wait for a couple of more days, and if the opt-in
part isn't necessary to anyone else, I will remove it from the next
revision.

>
> > 1. Delegate to APEI/GHES to see if SEA can be claimed by them.
> > 2. If APEI failed to claim the SEA and KVM_CAP_ARM_SIGBUS_ON_SEA is
> >    enabled for the VM, and the SEA is NOT about translation table,
> >    send SIGBUS BUS_OBJERR signal with host virtual address.
> > 3. Otherwise directly inject async SError to guest.
>
> The other reason I'm a bit lukewarm on user buy in is the UAPI suffers
> from the same issue we do today: it depends on the platform. If the SEA
> is claimed by APEI/GHES then the cap does nothing.

Good point, yeah, the path of KVM handling SEA and sending SIGBUS
should be treated as fallback code to APEI/GHES.

>
> > +static int kvm_delegate_guest_sea(phys_addr_t addr, u64 esr)
> > +{
> > +     /* apei_claim_sea(NULL) expects to mask interrupts itself */
> > +     lockdep_assert_irqs_enabled();
> > +     return apei_claim_sea(NULL);
> > +}
>
> Consider dropping parameters from this since they're unused.

Ack, will do in the next revision.

>
> > +void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > +{
> > +     bool sigbus_on_sea;
> > +     int idx;
> > +     u64 vcpu_esr =3D kvm_vcpu_get_esr(vcpu);
> > +     u8 fsc =3D kvm_vcpu_trap_get_fault(vcpu);
> > +     phys_addr_t fault_ipa =3D kvm_vcpu_get_fault_ipa(vcpu);
> > +     gfn_t gfn =3D fault_ipa >> PAGE_SHIFT;
> > +     /* When FnV is set, send 0 as si_addr like what do_sea() does. */
> > +     unsigned long hva =3D 0UL;
> > +
> > +     /*
> > +      * For RAS the host kernel may handle this abort.
> > +      * There is no need to SIGBUS VMM, or pass the error into the gue=
st.
> > +      */
> > +     if (kvm_delegate_guest_sea(fault_ipa, vcpu_esr) =3D=3D 0)
> > +             return;
> > +
> > +     sigbus_on_sea =3D test_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA,
> > +                              &(vcpu->kvm->arch.flags));
> > +
> > +     /*
> > +      * In addition to userspace opt-in, SIGBUS only makes sense if th=
e
> > +      * abort is NOT about translation table walk and NOT about hardwa=
re
> > +      * update of translation table.
> > +      */
> > +     sigbus_on_sea &=3D (fsc =3D=3D ESR_ELx_FSC_EXTABT || fsc =3D=3D E=
SR_ELx_FSC_SECC);
>
> Is this because we potentially can't determine a valid HVA for the
> fault? Maybe these should go out to userspace still with si_addr =3D 0.

No, it is not related to the availability of a valid HVA. In this
patch, as long as it decides to sigbus_on_sea, si_addr can be 0 if a
valid HVA isn't available when !kvm_vcpu_sea_far_valid (OR when
HPFAR_EL2 cannot be translated from a valid FAR_EL2, which I think
requires some improvement).

The code here wants to limit SIGBUS _BUS_OBJERR_ to only SEA and
parity+ECC error, similar to the code here (for SEA)
https://elixir.bootlin.com/linux/v6.11.6/source/arch/arm64/mm/fault.c#L771
and here (for synchronous parity or ECC error)
https://elixir.bootlin.com/linux/v6.11.6/source/arch/arm64/mm/fault.c#L779.

>
> --
> Thanks,
> Oliver

