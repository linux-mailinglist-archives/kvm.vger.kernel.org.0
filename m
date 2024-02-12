Return-Path: <kvm+bounces-8561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 774EC851913
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 17:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C3AD1F21E90
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 16:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7AC23D3BC;
	Mon, 12 Feb 2024 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O/x9p0N4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B273D0D4
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707755245; cv=none; b=allLj8LDUfO3z4wdDOwPvhAZ6Mv5vBtbdYTZnbP86Vx4rWYo15XghNxgFh9fc918tn+7KSNR+EKFuibD4+KaGU3GHUi0y5GSkUguqMawrAUHC2+/hpHovY9fJ6KvmgdTshE8nq5LvpzAPOxGdaqbNr9uiztBGwJa+gcLGlmdIdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707755245; c=relaxed/simple;
	bh=Ldgz4EaDjAiFoWUe/b915SB6Or4QvlmL0gWc1JCpdjQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vq4FLxHMNVgqdsRISC44Ly3YmZXvNagvCE96mLI0ow/F3MW70wQNDQSV8vF++sjYJeuO3xn/LUNoD1zf0Qiv/AthLkHEfxqi2AkyKeKE2o46CjpDarS6PxNhVLTP73qVO/baLAiMGh/wLvdmW3tICdfI2JRgMxAho5WpD/pXILY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O/x9p0N4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6049520940dso60365477b3.0
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 08:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707755243; x=1708360043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jEjTcKce0fZYlWVBDi232LEPLK7jT44Dgj/oRcn95IY=;
        b=O/x9p0N4LKvhXVYOd82ekpVjqc2RNJVb3t5bVbajDYfuOW4z/+HMPdZelBpHrekri9
         9AR34o47I1Jm1ZLQkGA8nlXC05Dh4AdpKHi3kUpQ/n2I8NEIt0vloc3Yc8fqU5mtIc7v
         NeMurczZEv3nBCzow6N5d8VeB2jMz+nkJHbpiF7jBe9spgZZYwg4w52C1LeMzO4eRlke
         VdnGZCbqUPgVtz6F0Q7xw54FwH5OF6dTRFk4XQ/cABHYAb7yQpqN+ksJofVCAtNjICzq
         9VmKnsoQJPu1s7v3cziMGCbqrG0EcZsAok0Xm5CkWx4N581QhXYYLeCG9TLiURQ+SuM3
         ZUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707755243; x=1708360043;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jEjTcKce0fZYlWVBDi232LEPLK7jT44Dgj/oRcn95IY=;
        b=U36ij0L/7Zow2QwiCRw3ij/c+pfNeEuXzvICwBghEECJs1jTwgFzsnrNcwO+rmSzCK
         FyHq9Y0lH/sgI7bGYUgH4wveMJN6bINanw2RtGumBBIl4EDAkgoBeXWGcI6E4UON5Fjx
         3EkB+t9X1836JFUnvq0ep+AgGAxzVhGlSOa+AEZYoRZfAXDiAo1m25zJOX4n95iJ5v0s
         CvgLGn0qFDw/kaMJUXJOf32i0gWtQYzASaNIymAjVsAVFBWEbvI0aSZlvKmYJbtkXBHW
         McAZS84gLcOJ6nNexR1uD06I25J1icbhtFM/qgA11t0W0ezGcP/W7G/dpBP2+MulNJk3
         BxKA==
X-Gm-Message-State: AOJu0YyZJ7MT45sSosH+cXV0JGC46/eVein2TrGaH3CqUMDB1qJWi8RH
	IO3JXb1pR29ocb+lyVtFYx1DRClfxQnFF4hEZkuNmWhUMAhck/9jL1zgqK6uU1FOoxoV7k6c8nw
	5UA==
X-Google-Smtp-Source: AGHT+IEsXJBF4/bgLbVzuTLfn0V+5NyBJ3BEiCA1tlOmkNRLRYQ2dckzNx5kcO0b5SJRLl+MJVUD0K6FNQI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:b0:dcb:c2c0:b319 with SMTP id
 w5-20020a056902100500b00dcbc2c0b319mr42995ybt.9.1707755243421; Mon, 12 Feb
 2024 08:27:23 -0800 (PST)
Date: Mon, 12 Feb 2024 08:27:21 -0800
In-Reply-To: <CABgObfanrHTL429Cr8tcMGqs-Ov+6LWeQbzghvjQiGu9tz0EUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-10-michael.roth@amd.com>
 <CABgObfanrHTL429Cr8tcMGqs-Ov+6LWeQbzghvjQiGu9tz0EUA@mail.gmail.com>
Message-ID: <ZcpG6Ul4_8xAsnuy@google.com>
Subject: Re: [PATCH v11 09/35] KVM: x86: Determine shared/private faults based
 on vm_type
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 12, 2024, Paolo Bonzini wrote:
> On Sat, Dec 30, 2023 at 6:24=E2=80=AFPM Michael Roth <michael.roth@amd.co=
m> wrote:
> >
> > For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
> > determine with an #NPF is due to a private/shared access by the guest.
> > Implement that handling here. Also add handling needed to deal with
> > SNP guests which in some cases will make MMIO accesses with the
> > encryption bit.
> >
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 12 ++++++++++--
> >  arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++++++++++++-
> >  2 files changed, 29 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index d3fbfe0686a0..61213f6648a1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4331,6 +4331,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcp=
u *vcpu,
> >  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fa=
ult *fault)
> >  {
> >         struct kvm_memory_slot *slot =3D fault->slot;
> > +       bool private_fault =3D fault->is_private;
>=20
> I think it's nicer to just make the fault !is_private in
> kvm_mmu_do_page_fault().

Yeah.  I'm starting to recall more of this discussion.  This is one of the =
reasons
I suggested/requested stuffing the error code to piggy-back the new SNP bit=
; doing
so allows is_private to be computed from the get-go without needing any ven=
dor
specific hooks.

