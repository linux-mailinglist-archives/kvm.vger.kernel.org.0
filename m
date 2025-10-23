Return-Path: <kvm+bounces-60893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 55176C020EC
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 17:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 160895000BA
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 15:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E17733374C;
	Thu, 23 Oct 2025 15:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="08Yc9jXp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7158332EBD
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761232449; cv=none; b=U/G24UPYigt/1nB25hsEZRowckBa46F5FZ2/PvKYLVOVIAQ73TRyDEpl99j1QXsZHLzMOLcHuYQ27Lr3/HoFyJgiAgfE4h8AiftaHJM1RCNbBKKgHhs5gwe/hbuZju7ITqBIrWrjLZYlwCy/iNNTBZ+kzM9i2lZMgctnMGmsxr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761232449; c=relaxed/simple;
	bh=uHRCY9cQRjtJ7szhlZgEWB+vNgN2UZvp04I8fLcJxas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cum0wq4j9mjwdiijolPhH8zPNZraw1Z6A5dCQHVKcJ+GkXDkTdWV8mQvJWaLa2iW9GHd4L7sXwm/pvLCNu3zaSXkJ2oZS0FLnMTNzo+UQL/PCVLSz0op4QqwVkFtf86IPtz2PcDwMBIx2haHDEMh0ay/B2V3qubFK8Cms7YaDTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=08Yc9jXp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33ba9047881so1111322a91.1
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 08:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761232446; x=1761837246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGj/4U8Cjm7Jzuo0N797IrKS+KWnd9Al6qyj+0gj5DU=;
        b=08Yc9jXpCeupaaVxf/cVy0KseieZvS12CLVA/wtmXlwb4C6IQsSWgr8qOsnqcEOtRI
         S02ISPacnH91KiBtzr4mopy8Ng+827PR2X4NxfTzlvHeMv/LvXEPCToS/jUrCBNuMiVo
         b2EAQHpSDLmEErN9vIqFaQB/RmH+W7Tpv9xWtOAN+bXPoSoYeUYOAQVzsP6b8B4QOk2F
         WooynTNo+2MTInZCdn9gLeb4Ae6xkPx067DneYzRr5MLDfeyokx9RrDmop1HfeaRtQzU
         qmHZVNIwY4oIBbDLX9X66dWqowFi2uZv0Ae8VwR4Tf+5fwDOD/5WexlZrUzF08sqyH6h
         pm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761232446; x=1761837246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGj/4U8Cjm7Jzuo0N797IrKS+KWnd9Al6qyj+0gj5DU=;
        b=cwIvkV72pjX8Nn6vkNYHuGfFqrDaqsZBYhBNpwFJHDdQSJ2whGTZDyAPjeWnv2+yYd
         DZ+6fzmyOaYKzf86I3zvTwzpQQwGKIrsiwpOgirvPOVscv8Wu/2SQdEOHUvoJXXlsn1h
         dh0yhZRp8d2+SX+9azMLTKfvStB8OxcJLKk4HWm294/xviXPqJqm/2nHF0VNBs7QLGx3
         s9nWEVIgaCZ5qfyG0hFWCgQUpOPg1E27eOwVrWGLwIc3UQQEGE+Rn8bzWu/NwvwiJ/uY
         d7EngrM8sIC1eTX5k1O8Dt3c7U3PkqtmEyNQbjTcMM5SJDGpPthKmTUBJfK3YHmqrSGc
         /QPg==
X-Forwarded-Encrypted: i=1; AJvYcCXMAKqbIBj9IX8aoLBHmhcCW7I2o2AKeH/2Rw0ELCrCRwJ48kaMkwT/DilYEbKEUNET49c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvEtfVti3y77iUXOZ+1Oaj7lWZZqtGmE7bog47GidJ9keIuhAF
	C9OlKHwGkKWJpJQVnTTYahHYJp+zTxK5w6pBZ70O8iIrpFc6YTlXe22IL83DzeF8+SYvN0lvMJh
	7noNBvA==
X-Google-Smtp-Source: AGHT+IGyk+8DKCi3tYCJowX0kgLUyc4PpyLVM16G5qza1KYeH4GEBaOP8pzea9wQFWKumE2t1taaAoPvn3M=
X-Received: from pjbrm7.prod.google.com ([2002:a17:90b:3ec7:b0:330:6c04:207])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:570e:b0:32e:7ff6:6dbd
 with SMTP id 98e67ed59e1d1-33e21dedc9fmr9424992a91.0.1761232446100; Thu, 23
 Oct 2025 08:14:06 -0700 (PDT)
Date: Thu, 23 Oct 2025 08:14:04 -0700
In-Reply-To: <aPnbIDxGlcAyI9vy@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-20-seanjc@google.com>
 <aPnbIDxGlcAyI9vy@yzhao56-desk.sh.intel.com>
Message-ID: <aPpGPF8McvI3-OO7@google.com>
Subject: Re: [PATCH v3 19/25] KVM: TDX: Assert that mmu_lock is held for write
 when removing S-EPT entries
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 23, 2025, Yan Zhao wrote:
> On Thu, Oct 16, 2025 at 05:32:37PM -0700, Sean Christopherson wrote:
> > Unconditionally assert that mmu_lock is held for write when removing S-EPT
> > entries, not just when removing S-EPT entries triggers certain conditions,
> > e.g. needs to do TDH_MEM_TRACK or kick vCPUs out of the guest.
> > Conditionally asserting implies that it's safe to hold mmu_lock for read
> > when those paths aren't hit, which is simply not true, as KVM doesn't
> > support removing S-EPT entries under read-lock.
> > 
> > Only two paths lead to remove_external_spte(), and both paths asserts that
> > mmu_lock is held for write (tdp_mmu_set_spte() via lockdep, and
> > handle_removed_pt() via KVM_BUG_ON()).
> > 
> > Deliberately leave lockdep assertions in the "no vCPUs" helpers to document
> > that wait_for_sept_zap is guarded by holding mmu_lock for write.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index e517ad3d5f4f..f6782b0ffa98 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1711,8 +1711,6 @@ static void tdx_track(struct kvm *kvm)
> >  	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
> >  		return;
> >  
> > -	lockdep_assert_held_write(&kvm->mmu_lock);
> Could we also deliberately leave lockdep assertion for tdx_track()?

Can do.

> This is because if we allow removing S-EPT entries while holding mmu_lock for
> read in future, tdx_track() needs to be protected by a separate spinlock to
> ensure serialization of tdh_mem_track() and vCPUs kick-off (kicking off vCPUs
> must follow each tdh_mem_track() to unblock the next tdh_mem_track()).

Does this look/sound right?

From: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:17 -0700
Subject: [PATCH] KVM: TDX: Assert that mmu_lock is held for write when
 removing S-EPT entries

Unconditionally assert that mmu_lock is held for write when removing S-EPT
entries, not just when removing S-EPT entries triggers certain conditions,
e.g. needs to do TDH_MEM_TRACK or kick vCPUs out of the guest.
Conditionally asserting implies that it's safe to hold mmu_lock for read
when those paths aren't hit, which is simply not true, as KVM doesn't
support removing S-EPT entries under read-lock.

Only two paths lead to remove_external_spte(), and both paths asserts that
mmu_lock is held for write (tdp_mmu_set_spte() via lockdep, and
handle_removed_pt() via KVM_BUG_ON()).

Deliberately leave lockdep assertions in the "no vCPUs" helpers to document
that wait_for_sept_zap is guarded by holding mmu_lock for write, and keep
the conditional assert in tdx_track() as well, but with a comment to help
explain why holding mmu_lock for write matters (above and beyond why
tdx_sept_remove_private_spte()'s requirements).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dca9e2561270..899051c64faa 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1715,6 +1715,11 @@ static void tdx_track(struct kvm *kvm)
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
 		return;
 
+	/*
+	 * The full sequence of TDH.MEM.TRACK and forcing vCPUs out of guest
+	 * mode must be serialized, as TDH.MEM.TRACK will fail if the previous
+	 * tracking epoch hasn't completed.
+	*/
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	err = tdh_mem_track(&kvm_tdx->td);
@@ -1762,6 +1767,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	/*
 	 * HKID is released after all private pages have been removed, and set
 	 * before any might be populated. Warn if zapping is attempted when

base-commit: 69564844a116861ebea4396894005c8b4e48f870
--

