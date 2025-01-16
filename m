Return-Path: <kvm+bounces-35700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 060B8A144B1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21D2E163AC6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FDD22DF96;
	Thu, 16 Jan 2025 22:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u5egkge/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A102241681
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737067478; cv=none; b=luKrhqVKw/EDwdJpKChjir6n9AtvsfPXitVOvBYfFIWVLJGItTwJ+4Lso2GKw3dR3Vl8Bw20xNcXLhB1Txt2FKyFYBc7arplF5zl42wunsgzZoUn0HivoDoNAFalM0Sjk9d0pD554cH3yAsqFqq4F4uC7d7gGCXTxm+6/o4S7Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737067478; c=relaxed/simple;
	bh=CsoxSam1bgb4xjn+tCWAdVcMp2nnPKaLesTH747D8KY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fh5hCqZN1ueV6jkwgsuxRlXyN5UwcjsS3fp9uldWuFvLzkiPEaOgNCW8JxbLzQR4losWH/gw59O/Kp/RNCbMBz989QGaflK3ij/7O69yYaxP8UMGuTOFoltv1/8Mb/4VqH9MqogsXQslRyFDt75pGTua6Bz85q+/8V3kAQcwbCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u5egkge/; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-46defafbdafso17247571cf.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 14:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737067476; x=1737672276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DiNSFmG4xZJrihorm/HPnSNz1hcYyzCJCDaZlRdkoI=;
        b=u5egkge/iYyzF4Sknno5pniBHI3bwVkA0Tymq3ANScexpCpt/Gj3E/KgwAmB4zjTsq
         xr7J6Uwy/PYU7+IxBTl1HHVDMzsyTrUKTsJ78agRqwrUriR1yr1UKfjwhOrp29QEyW01
         vnetTFLGK6nGacj2VT0vJ2CcZE6aiN1ZdYgW3iov2apOFl7ZqCF77Mn0kcwy+2IQTIYl
         /FZkrMX29V2p7ea4Qu2Fx+045Hlb9hxzA4AUyLkToduc8AxH00SqBfwkb4otJoc+VJHB
         65D7AhEl4HWU0eUOCOTFruKmxbXlKeLfHo36y8MyjoOa6kjpRhiN3asQ8vnZeGOKCfuK
         +gdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737067476; x=1737672276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7DiNSFmG4xZJrihorm/HPnSNz1hcYyzCJCDaZlRdkoI=;
        b=O4qEInwfgtBeBh+oB1fo2LDb9afN56Nq3YruGfSwDcC3QtCFj++twhMBY6WsAn1pNx
         u0NzM0mv3JaD+jnsyHsAf+WXhFmBYOVyGskJQCcbvftEQv8t+ZFd3vzI/iEejMWzE8c6
         iG0IuJqFH7W5zbh61HDQs43WRcEOQHr7OpctTbjYVhnoHJOgPKEUCrXRkFM0IttmDy9/
         xqqblI3hwRBPHKeF2AMRq9Jh1xnaHys1HMlYwgXcQisSGFf16Yw+dg1eHhb3M8qnh8Mh
         1eza2bGlB6zS2J+Q8K0blDpIJTMIM6W/FEZ8BwG9AzeR97xoUSnfMsX8Ff4wARgAeb5U
         Gguw==
X-Forwarded-Encrypted: i=1; AJvYcCVqHZXxq8czfYA+gTTyjHoCxsy3Q5iXKgLgDurjtF+9Bz2h+AXP67KUQ8j9A/g80uNyymE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJXGaH68gCDxhwHgjkcWZEpiYmJuPMKq2y24KO2XamW2Qi6rna
	9MuB+b8Lx9Rd2UXV5uFh+rQ61DoaUHwTt56MDlZeQx2AeEFxpxb6o1WaM7/DFPOPfEqy4OU/dRy
	fC/iUPj50nQBIockXwiwz3cj8Qyue/Qs6VYlE/ITw+hVW5T1cfeWB
X-Gm-Gg: ASbGncvpscJnHmYpFqaebRJKJfLVchUFN7fjDozai0jYVsKLVu1QxOGYrjkkh16K/S+
	3Mj7c0n5HbIQ661U+Q6+5f1jrYTT5IYs24+Fz0u5/1Wriv/lIKmnsJjfDQyuMKAujvSw=
X-Google-Smtp-Source: AGHT+IEtAnu5aoQQqY5ck5Iwenj4HER+8JURzve5AgT1kLbS5bmbUtgkc1pGOf4AtuyOVodRVAch5Z4B7j/+5YAMUmk=
X-Received: by 2002:ad4:4ee8:0:b0:6df:97ea:95dd with SMTP id
 6a1803df08f44-6e1b21b8f4bmr10570196d6.17.1737067475758; Thu, 16 Jan 2025
 14:44:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
 <Z4mJpu3MvBeL4d1Q@google.com>
In-Reply-To: <Z4mJpu3MvBeL4d1Q@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 16 Jan 2025 14:43:58 -0800
X-Gm-Features: AbW1kvYG8fvFsPDWm81JtKNrETpl0wo0E3i7AICL4JS8WtL2dVK36qDp9xw8hz4
Message-ID: <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 2:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > On Thu, Jan 16, 2025 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > > > On Wed, Jan 15, 2025 at 9:27=E2=80=AFPM Jim Mattson <jmattson@googl=
e.com> wrote:
> > > > > On Wed, Jan 15, 2025 at 7:50=E2=80=AFPM Yosry Ahmed <yosryahmed@g=
oogle.com> wrote:
> > > > > > Use KVM_REQ_TLB_FLUSH_GUEST in this case in
> > > > > > nested_vmx_transition_tlb_flush() for consistency. This arguabl=
y makes
> > > > > > more sense conceptually too -- L1 and L2 cannot share the TLB t=
ag for
> > > > > > guest-physical translations, so only flushing linear and combin=
ed
> > > > > > translations (i.e. guest-generated translations) is needed.
> > >
> > > No, using KVM_REQ_TLB_FLUSH_CURRENT is correct.  From *L1's* perspect=
ive, VPID
> > > is enabled, and so VM-Entry/VM-Exit are NOT architecturally guarantee=
d to flush
> > > TLBs, and thus KVM is not required to FLUSH_GUEST.
> > >
> > > E.g. if KVM is using shadow paging (no EPT whatsoever), and L1 has mo=
dified the
> > > PTEs used to map L2 but has not yet flushed TLBs for L2's VPID, then =
KVM is allowed
> > > to retain its old, "stale" SPTEs that map L2 because architecturally =
they aren't
> > > guaranteed to be visible to L2.
> > >
> > > But because L1 and L2 share TLB entries *in hardware*, KVM needs to e=
nsure the
> > > hardware TLBs are flushed.  Without EPT, KVM will use different CR3s =
for L1 and
> > > L2, but Intel's ASID tag doesn't include the CR3 address, only the PC=
ID, which
> > > KVM always pulls from guest CR3, i.e. could be the same for L1 and L2=
.
> > >
> > > Specifically, the synchronization of shadow roots in kvm_vcpu_flush_t=
lb_guest()
> > > is not required in this scenario.
> >
> > Aha, I was examining vmx_flush_tlb_guest() not
> > kvm_vcpu_flush_tlb_guest(), so I missed the synchronization. Yeah I
> > think it's possible that we end up unnecessarily synchronizing the
> > shadow page tables (or dropping them) in this case.
> >
> > Do you think it's worth expanding the comment in
> > nested_vmx_transition_tlb_flush()?
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 2ed454186e59c..43d34e413d016 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1239,6 +1239,11 @@ static void
> > nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
> >          * does not have a unique TLB tag (ASID), i.e. EPT is disabled =
and
> >          * KVM was unable to allocate a VPID for L2, flush the current =
context
> >          * as the effective ASID is common to both L1 and L2.
> > +        *
> > +        * Note that even though TLB_FLUSH_GUEST would be correct becau=
se we
> > +        * only need to flush linear mappings, it would unnecessarily
> > +        * synchronize the MMU even though a TLB flush is not architect=
urally
> > +        * required from L1's perspective.
>
> I'm open to calling out that there's no flush from L1's perspective, but =
this
> is inaccurate.  Using TLB_FLUSH_GUEST is simply not correct.  Will it cau=
se
> functional problems?  No.  But neither would blasting kvm_flush_remote_tl=
bs(),
> and I think most people would consider flushing all TLBs on all vCPUs to =
be a
> bug.

Yeah I meant functionally correct as it does not cause correctness
issues, but definitely a problem.

>
> How about:
>
>          * Note, only the hardware TLB entries need to be flushed, as VPI=
D is
>          * fully enabled from L1's perspective, i.e. there's no architect=
ural
>          * TLB flush from L1's perspective.

I hate to bikeshed, but I want to explicitly call out that we do not
need to synchronize the MMU. Maybe this?

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2ed454186e59c..a9171909de63d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1239,6 +1239,11 @@ static void
nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
         * does not have a unique TLB tag (ASID), i.e. EPT is disabled and
         * KVM was unable to allocate a VPID for L2, flush the current cont=
ext
         * as the effective ASID is common to both L1 and L2.
+        *
+        * Note, only the hardware TLB entries need to be flushed, as VPID =
is
+        * fully enabled from L1's perspective, i.e. there's no
+        * architectural TLB flush from L1's perspective. Hence, synchroniz=
ing
+        * the MMU is not required as the mappings are still valid.
         */
        if (!nested_has_guest_tlb_tag(vcpu))
                kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);

