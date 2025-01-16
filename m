Return-Path: <kvm+bounces-35698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7680AA14480
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8E5B3A9C89
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3E51DDC33;
	Thu, 16 Jan 2025 22:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SV1EuSvs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C8A1B0F30
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737066922; cv=none; b=inTECr+woA2LxnL6qKOmwZlOPBxYthHYMYysZcDESNpvF6uepZc1j/UcofV/tYeWAfUBpJAp7dRJKKdsWckQltbd1I7+TuA5g3VI55VUFkmndc/IdJX4kTVc3ptbtF0B8/g7BG6VzBalt1gkYuSDnuEeSNOe4oajAXsP0Yw/O88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737066922; c=relaxed/simple;
	bh=GkxjblgJIwnUrl7yFh0fd+yTdpnAxSdPyEOWBe1ogGw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A0jXe5F1X0eRthujteZxHIDCVKKL3ujb8Kjvo9RbIXBBNMecO39atR7/pox3pgJWuLXjfXyXEbPngmGi6lm0jKCViYBPmdyjWwT/qyEG79gz3lCbyeppMc+NjsowTVLxpkJ/3ecMLZ7tO8Btb1utIU1mRRZBn9P+aBUPh6sFCSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SV1EuSvs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21638389f63so20321535ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 14:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737066920; x=1737671720; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v7ZSFYoL0QJz/svIjPrUJ1gwe8KhLK+3Cjm89lweI1M=;
        b=SV1EuSvswfQy9HHcKREsnyHyj61GabKtgGVmhkhflyUuO3laVEdZWcJX21iT9jE5Y+
         QMd2CROseWDnJMBQd8uWXy36vybSegttTdDnDOpFxmOjPxeydj+VyWPBBSzSaP66PpS3
         o1yppPTKojRrBLvA31JrrL4bg3CdJIw7E6CXFKPo8ppUt0U8sAfTIlaVqyQrqEF/Yiud
         J+KQbeTi3S98gcsctthvmqW/5HrLspHm/kF1xw035ZIBXIw23NQBa4PnWHolMfenHasN
         gleQv1mahlAx+sjrNdB3e1npTEkiHxgVlM7VgBwLyUKhP9EEd+55xK8dp63DW41KrTPA
         63Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737066920; x=1737671720;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v7ZSFYoL0QJz/svIjPrUJ1gwe8KhLK+3Cjm89lweI1M=;
        b=Uyv/Op/7zO4YXl2MMDIT1PD4dum/nJT8FgvkydHPVB4RoiXkDjackxCSvjSrNwSFGW
         FrnrrSWaa7pcol/haXCOyPKkdqJfsq8ZS62tkHFvqVX44HF+0dyxqIfSxOQo1fEyuQu9
         HdBeP443CBafFtKbNeVhrpCKqWfLaTau3bXE2Cl6jgnI8Or+I+Z/G5C+G0DP4gDpM8Hb
         y87z/hWP1sbU02ouw5rFdRXFh9jRV6WU5XKvbVLG2WarcFAh5KtgJ4q7S3hh7EOKSg0K
         7Drrs+c2pklWv75XTqfRCMSGBYj6RrOKI/oLsXsIf93vfRHCvRcFnKoyQkEYKDdbzJ/h
         AZIw==
X-Forwarded-Encrypted: i=1; AJvYcCWJjEm/FzzmPhVP34RgdEpu5GKXo6JEfbepvZLfJfgQzcAU/68PgGFq9WH0XSN8dtq3XTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjZt0qaAcvV4weCAPO7t5ny8j4AQrdvv4EgtRSfJm6+s5S2iuI
	SF1zIrldYxQaBpjw6LLqPBtM2ykcJ2bdnma8rulbj/eT5y2Za6AIrziXnefab6O+seEsm2l3SVF
	D5g==
X-Google-Smtp-Source: AGHT+IFfulyv5+xsasTh0o5vptCFt+1BlyveHLOPxD0zksiSehNzsehsAo+ZcCPpoa6N2tkYbS8sdiPukEE=
X-Received: from pjbsl4.prod.google.com ([2002:a17:90b:2e04:b0:2f5:4762:e778])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c3:b0:216:4883:fb43
 with SMTP id d9443c01a7336-21c35594385mr6635515ad.32.1737066920414; Thu, 16
 Jan 2025 14:35:20 -0800 (PST)
Date: Thu, 16 Jan 2025 14:35:18 -0800
In-Reply-To: <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
Message-ID: <Z4mJpu3MvBeL4d1Q@google.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> On Thu, Jan 16, 2025 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > > On Wed, Jan 15, 2025 at 9:27=E2=80=AFPM Jim Mattson <jmattson@google.=
com> wrote:
> > > > On Wed, Jan 15, 2025 at 7:50=E2=80=AFPM Yosry Ahmed <yosryahmed@goo=
gle.com> wrote:
> > > > > Use KVM_REQ_TLB_FLUSH_GUEST in this case in
> > > > > nested_vmx_transition_tlb_flush() for consistency. This arguably =
makes
> > > > > more sense conceptually too -- L1 and L2 cannot share the TLB tag=
 for
> > > > > guest-physical translations, so only flushing linear and combined
> > > > > translations (i.e. guest-generated translations) is needed.
> >
> > No, using KVM_REQ_TLB_FLUSH_CURRENT is correct.  From *L1's* perspectiv=
e, VPID
> > is enabled, and so VM-Entry/VM-Exit are NOT architecturally guaranteed =
to flush
> > TLBs, and thus KVM is not required to FLUSH_GUEST.
> >
> > E.g. if KVM is using shadow paging (no EPT whatsoever), and L1 has modi=
fied the
> > PTEs used to map L2 but has not yet flushed TLBs for L2's VPID, then KV=
M is allowed
> > to retain its old, "stale" SPTEs that map L2 because architecturally th=
ey aren't
> > guaranteed to be visible to L2.
> >
> > But because L1 and L2 share TLB entries *in hardware*, KVM needs to ens=
ure the
> > hardware TLBs are flushed.  Without EPT, KVM will use different CR3s fo=
r L1 and
> > L2, but Intel's ASID tag doesn't include the CR3 address, only the PCID=
, which
> > KVM always pulls from guest CR3, i.e. could be the same for L1 and L2.
> >
> > Specifically, the synchronization of shadow roots in kvm_vcpu_flush_tlb=
_guest()
> > is not required in this scenario.
>=20
> Aha, I was examining vmx_flush_tlb_guest() not
> kvm_vcpu_flush_tlb_guest(), so I missed the synchronization. Yeah I
> think it's possible that we end up unnecessarily synchronizing the
> shadow page tables (or dropping them) in this case.
>=20
> Do you think it's worth expanding the comment in
> nested_vmx_transition_tlb_flush()?
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2ed454186e59c..43d34e413d016 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1239,6 +1239,11 @@ static void
> nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
>          * does not have a unique TLB tag (ASID), i.e. EPT is disabled an=
d
>          * KVM was unable to allocate a VPID for L2, flush the current co=
ntext
>          * as the effective ASID is common to both L1 and L2.
> +        *
> +        * Note that even though TLB_FLUSH_GUEST would be correct because=
 we
> +        * only need to flush linear mappings, it would unnecessarily
> +        * synchronize the MMU even though a TLB flush is not architectur=
ally
> +        * required from L1's perspective.

I'm open to calling out that there's no flush from L1's perspective, but th=
is
is inaccurate.  Using TLB_FLUSH_GUEST is simply not correct.  Will it cause
functional problems?  No.  But neither would blasting kvm_flush_remote_tlbs=
(),
and I think most people would consider flushing all TLBs on all vCPUs to be=
 a
bug.

How about:

	 * Note, only the hardware TLB entries need to be flushed, as VPID is
	 * fully enabled from L1's perspective, i.e. there's no architectural
	 * TLB flush from L1's perspective.

>          */
>         if (!nested_has_guest_tlb_tag(vcpu))
>                 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);

