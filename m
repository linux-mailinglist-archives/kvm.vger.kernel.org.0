Return-Path: <kvm+bounces-56364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C928B3C3A9
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3892580845
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158EE23A562;
	Fri, 29 Aug 2025 20:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ovlTeEZM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15701238D3A
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 20:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756498301; cv=none; b=BmdzIllmtqSOEgKlJXdTFQVbGQBHntCc0l/GVGAA+wU1ocaND1mng7lKGH33w8szCoTDLZovpxjEzpUl7ROhGpMexh0IE6b0dOLx5/UbpLfRm3zcwTgbfKG0cMkgaM8vjzpA5UKNm8DSVBkrO610GAUnmjn3Xra2GAJYDdajNN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756498301; c=relaxed/simple;
	bh=07BTvyFptLXqqKkbUzumeIcHD1zFF152v1CBbtQ2iwg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZaT2qygjqbXAxcgiuGTE5cz9lWq47bNZRjvSgCcINfHmFSsKscwJp3/ZBm6LBqMM14wpVy+6nX/BCvPSAfRMqbZtWpceE7dIDQaeY8F157ztmL/HMQOLO9oK3WAq95c6lGpUSMacwT3+gvYQANzgWWI+lLiXyLGDFGDl5loC2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ovlTeEZM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-327a60cef33so2385105a91.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 13:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756498297; x=1757103097; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E1xXYEQYPm2UIzogsjF8WeKJMO+HoHkUezx1MkUo3NM=;
        b=ovlTeEZMJ8y/4VSddoCKd8ZbBZVjzcKD1zhIDqDiwxaWrXS4k492PIqeKA5d4GhS8i
         d9oInfwODrypL/+6AbzivRZOddL94afWN4kT7345wNHD0WMZNhmI/LIPBrlrvtFkinQY
         w/KJmCWfo0HxWy6KSvNGMZor1uUVtqYQlftp4m54THVNdCASlRagzGuDGt/YMYB4GG7U
         KB5YL0GGCvgTCvxHRo7hiJr9hVK0ddCm1T6fmnH61vlVIeZP1LVgHTMv3NH7v7sfoqei
         ag3KH/hVVZ3YIBHB9rrzDKRbciX4FU2v7mgvEzOOyl+QcyGlpatJsCm++iYXA1OMMQva
         VpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756498297; x=1757103097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1xXYEQYPm2UIzogsjF8WeKJMO+HoHkUezx1MkUo3NM=;
        b=Nz7bFPg7hA2ssY7TA279qTms26jfQurmYDEtD2ySQ/OuvxpyQA4ksQYCtQRiXLp5zH
         iAVSXi1zYSirpYJx881j5NlsCRTeUvfpdzXxFZgSA6oiuUMvXjnsoHRug+cG+rLYTVqm
         jEoAfrJbZfaUJrkWdKzsy9fUqLoFpo5FINpSf6EBCao0bayDLQ6S1mvpjld+jRzolelK
         i2u0K4iMEsPYF93suMIxPEdVWe56A9EkXFbt5PT1ReQvsTcIJOlAsVGyMLR/46Ujs/gK
         I26Iaa5EI2k4j3YheBBBoLHhZ53uCRQr26pNyQCPqtclAa67jxGe8ZT6IMYpj2NJydvN
         RI6w==
X-Forwarded-Encrypted: i=1; AJvYcCXQXTNXbpkItq71DPTv8rCeLC42sSSyCKeN5cvtIbpWN7vS5ZUdn/ODIE0UH7vc1b20ics=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMD5/as0JbUObEl/V3HLggwQD4tB5IwJIwFGmcvygNSzOaaORM
	ezshDNmdfTQlQ+uDfp75tmoiC8DIcP2BN1uJckSxhdJkH7C6zokLmGwB9uznmaOzj1K1YXkqvGg
	XQWxT9Q==
X-Google-Smtp-Source: AGHT+IGSOPc6o4JSGGHoO36hCGquhvo4o0JarnFng6xm9rce2skvNtUYCYUsGoS/Ign29q+P53jI+h1Up7E=
X-Received: from pjbqa14.prod.google.com ([2002:a17:90b:4fce:b0:327:5941:b2fd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8b:b0:312:f0d0:bc4
 with SMTP id 98e67ed59e1d1-32515e12aedmr33737966a91.5.1756498297411; Fri, 29
 Aug 2025 13:11:37 -0700 (PDT)
Date: Fri, 29 Aug 2025 13:11:35 -0700
In-Reply-To: <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-13-seanjc@google.com>
 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com> <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
Message-ID: <aLIJd7xpNfJvdMeT@google.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="PWFjyiMo08ArJL/7"


--PWFjyiMo08ArJL/7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-08-29 at 16:18 +0800, Yan Zhao wrote:
> > > +	/*
> > > +	 * Note, MR.EXTEND can fail if the S-EPT mapping is somehow removed
> > > +	 * between mapping the pfn and now, but slots_lock prevents memslot
> > > +	 * updates, filemap_invalidate_lock() prevents guest_memfd updates,
> > > +	 * mmu_notifier events can't reach S-EPT entries, and KVM's
> > > internal
> > > +	 * zapping flows are mutually exclusive with S-EPT mappings.
> > > +	 */
> > > +	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> > > +		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
> > > &level_state);
> > > +		if (KVM_BUG_ON(err, kvm)) {
> > I suspect tdh_mr_extend() running on one vCPU may contend with
> > tdh_vp_create()/tdh_vp_addcx()/tdh_vp_init*()/tdh_vp_rd()/tdh_vp_wr()/
> > tdh_mng_rd()/tdh_vp_flush() on other vCPUs, if userspace invokes ioctl
> > KVM_TDX_INIT_MEM_REGION on one vCPU while initializing other vCPUs.
> > 
> > It's similar to the analysis of contention of tdh_mem_page_add() [1], as
> > both tdh_mr_extend() and tdh_mem_page_add() acquire exclusive lock on
> > resource TDR.
> > 
> > I'll try to write a test to verify it and come back to you.
> 
> I'm seeing the same thing in the TDX module. It could fail because of contention
> controllable from userspace. So the KVM_BUG_ON() is not appropriate.
> 
> Today though if tdh_mr_extend() fails because of contention then the TD is
> essentially dead anyway. Trying to redo KVM_TDX_INIT_MEM_REGION will fail. The
> M-EPT fault could be spurious but the second tdh_mem_page_add() would return an
> error and never get back to the tdh_mr_extend().
> 
> The version in this patch can't recover for a different reason. That is 
> kvm_tdp_mmu_map_private_pfn() doesn't handle spurious faults, so I'd say just
> drop the KVM_BUG_ON(), and try to handle the contention in a separate effort.
> 
> I guess the two approaches could be to make KVM_TDX_INIT_MEM_REGION more robust,

This.  First and foremost, KVM's ordering and locking rules need to be explicit
(ideally documented, but at the very least apparent in the code), *especially*
when the locking (or lack thereof) impacts userspace.  Even if effectively relying
on the TDX-module to provide ordering "works", it's all but impossible to follow.

And it doesn't truly work, as everything in the TDX-Module is a trylock, and that
in turn prevents KVM from asserting success.  Sometimes KVM has better option than
to rely on hardware to detect failure, but it really should be a last resort,
because not being able to expect success makes debugging no fun.  Even worse, it
bleeds hard-to-document, specific ordering requirements into userspace, e.g. in
this case, it sounds like userspace can't do _anything_ on vCPUs while doing
KVM_TDX_INIT_MEM_REGION.  Which might not be a burden for userspace, but oof is
it nasty from an ABI perspective.

> or prevent the contention. For the latter case:
> tdh_vp_create()/tdh_vp_addcx()/tdh_vp_init*()/tdh_vp_rd()/tdh_vp_wr()
> ...I think we could just take slots_lock during KVM_TDX_INIT_VCPU and
> KVM_TDX_GET_CPUID.
> 
> For tdh_vp_flush() the vcpu_load() in kvm_arch_vcpu_ioctl() could be hard to
> handle.
> 
> So I'd think maybe to look towards making KVM_TDX_INIT_MEM_REGION more robust,
> which would mean the eventual solution wouldn't have ABI concerns by later
> blocking things that used to be allowed.
> 
> Maybe having kvm_tdp_mmu_map_private_pfn() return success for spurious faults is
> enough. But this is all for a case that userspace isn't expected to actually
> hit, so seems like something that could be kicked down the road easily.

You're trying to be too "nice", just smack 'em with a big hammer.  For all intents
and purposes, the paths in question are fully serialized, there's no reason to try
and allow anything remotely interesting to happen.

Acquire kvm->lock to prevent VM-wide things from happening, slots_lock to prevent
kvm_mmu_zap_all_fast(), and _all_ vCPU mutexes to prevent vCPUs from interefering.

Doing that for a vCPU ioctl is a bit awkward, but not awful.  E.g. we can abuse
kvm_arch_vcpu_async_ioctl().  In hindsight, a more clever approach would have
been to make KVM_TDX_INIT_MEM_REGION a VM-scoped ioctl that takes a vCPU fd.  Oh
well.

Anyways, I think we need to avoid the "synchronous" ioctl path anyways, because
taking kvm->slots_lock inside vcpu->mutex is gross.  AFAICT it's not actively
problematic today, but it feels like a deadlock waiting to happen.

The other oddity I see is the handling of kvm_tdx->state.  I don't see how this
check in tdx_vcpu_create() is safe:

	if (kvm_tdx->state != TD_STATE_INITIALIZED)
		return -EIO;

kvm_arch_vcpu_create() runs without any locks held, and so TDX effectively has
the same bug that SEV intra-host migration had, where an in-flight vCPU creation
could race with a VM-wide state transition (see commit ecf371f8b02d ("KVM: SVM:
Reject SEV{-ES} intra host migration if vCPU creation is in-flight").  To fix
that, kvm->lock needs to be taken and KVM needs to verify there's no in-flight
vCPU creation, e.g. so that a vCPU doesn't pop up and contend a TDX-Module lock.

We an even define a fancy new CLASS to handle the lock+check => unlock logic
with guard()-like syntax:

	CLASS(tdx_vm_state_guard, guard)(kvm);
	if (IS_ERR(guard))
		return PTR_ERR(guard);

IIUC, with all of those locks, KVM can KVM_BUG_ON() both TDH_MEM_PAGE_ADD and
TDH_MR_EXTEND, with no exceptions given for -EBUSY.  Attached patches are very
lightly tested as usual and need to be chunked up, but seem do to what I want.

--PWFjyiMo08ArJL/7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-Make-support-for-kvm_arch_vcpu_async_ioctl-manda.patch"

From 44a96a0db69d9cd56e77813125aa1e318b11d718 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 29 Aug 2025 07:28:44 -0700
Subject: [PATCH 1/2] KVM: Make support for kvm_arch_vcpu_async_ioctl()
 mandatory

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/Kconfig |  1 -
 arch/mips/kvm/Kconfig      |  1 -
 arch/powerpc/kvm/Kconfig   |  1 -
 arch/riscv/kvm/Kconfig     |  1 -
 arch/s390/kvm/Kconfig      |  1 -
 arch/x86/kvm/x86.c         |  6 ++++++
 include/linux/kvm_host.h   | 10 ----------
 virt/kvm/Kconfig           |  3 ---
 8 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index 40eea6da7c25..e53948ec978a 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -25,7 +25,6 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_MSI
 	select HAVE_KVM_READONLY_MEM
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index ab57221fa4dd..cc13cc35f208 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select EXPORT_UASM
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_GENERIC_HARDWARE_ENABLING
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 2f2702c867f7..c9a2d50ff1b0 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM
 	bool
 	select KVM_COMMON
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_VFIO
 	select HAVE_KVM_IRQ_BYPASS
 
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 5a62091b0809..de67bfabebc8 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -23,7 +23,6 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select KVM_COMMON
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index cae908d64550..96d16028e8b7 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -20,7 +20,6 @@ config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_ASYNC_PF
 	select KVM_ASYNC_PF_SYNC
 	select KVM_COMMON
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ba2cdfdac44..92e916eba6a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6943,6 +6943,12 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
+long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
+			       unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..a1840aaf80d4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2421,18 +2421,8 @@ static inline bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_NO_POLL */
 
-#ifdef CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg);
-#else
-static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
-					     unsigned int ioctl,
-					     unsigned long arg)
-{
-	return -ENOIOCTLCMD;
-}
-#endif /* CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL */
-
 void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 727b542074e7..661a4b998875 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -78,9 +78,6 @@ config HAVE_KVM_IRQ_BYPASS
        tristate
        select IRQ_BYPASS_MANAGER
 
-config HAVE_KVM_VCPU_ASYNC_IOCTL
-       bool
-
 config HAVE_KVM_VCPU_RUN_PID_CHANGE
        bool
 

base-commit: f4b88d6c85871847340a86daf838e11986a97348
-- 
2.51.0.318.gd7df087d1a-goog


--PWFjyiMo08ArJL/7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-TDX-Guard-VM-state-transitions.patch"

From 7277396033c21569dbed0a52fa92804307db111e Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 29 Aug 2025 09:19:11 -0700
Subject: [PATCH 2/2] KVM: TDX: Guard VM state transitions

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/kvm/vmx/main.c            |   9 +++
 arch/x86/kvm/vmx/tdx.c             | 112 ++++++++++++++++++++++-------
 arch/x86/kvm/vmx/x86_ops.h         |   1 +
 arch/x86/kvm/x86.c                 |   7 ++
 6 files changed, 105 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 18a5c3119e1a..fe2bb2e2ebc8 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -128,6 +128,7 @@ KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_OPTIONAL(dev_get_attr)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_async_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d0a8404a6b8f..ac5d3b8fa49f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1911,6 +1911,7 @@ struct kvm_x86_ops {
 	int (*dev_get_attr)(u32 group, u64 attr, u64 *val);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
+	int (*vcpu_mem_enc_async_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dbab1c15b0cd..e0e35ceec9b1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -831,6 +831,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
+static int vt_vcpu_mem_enc_async_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	if (!is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return tdx_vcpu_async_ioctl(vcpu, argp);
+}
+
 static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	if (is_td(kvm))
@@ -1004,6 +1012,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
+	.vcpu_mem_enc_async_ioctl = vt_op_tdx_only(vcpu_mem_enc_async_ioctl),
 
 	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d6c9defad9cd..c595d9cb6dcd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2624,6 +2624,44 @@ static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
 	return -EIO;
 }
 
+typedef void * tdx_vm_state_guard_t;
+
+static tdx_vm_state_guard_t tdx_acquire_vm_state_locks(struct kvm *kvm)
+{
+	int r;
+
+	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->slots_lock);
+
+	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus)) {
+		r = -EBUSY;
+		goto out_err;
+	}
+
+	r = kvm_lock_all_vcpus(kvm);
+	if (r)
+		goto out_err;
+
+	return kvm;
+
+out_err:
+	mutex_unlock(&kvm->slots_lock);
+	mutex_unlock(&kvm->lock);
+
+	return ERR_PTR(r);
+}
+
+static void tdx_release_vm_state_locks(struct kvm *kvm)
+{
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->slots_lock);
+	mutex_unlock(&kvm->lock);
+}
+
+DEFINE_CLASS(tdx_vm_state_guard, tdx_vm_state_guard_t,
+	     if (!IS_ERR(_T)) tdx_release_vm_state_locks(_T),
+	     tdx_acquire_vm_state_locks(kvm), struct kvm *kvm);
+
 static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -2634,6 +2672,10 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
 	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
 
+	CLASS(tdx_vm_state_guard, guard)(kvm);
+	if (IS_ERR(guard))
+		return PTR_ERR(guard);
+
 	if (kvm_tdx->state != TD_STATE_UNINITIALIZED)
 		return -EINVAL;
 
@@ -2745,7 +2787,9 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
-	guard(mutex)(&kvm->slots_lock);
+	CLASS(tdx_vm_state_guard, guard)(kvm);
+	if (IS_ERR(guard))
+		return PTR_ERR(guard);
 
 	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
 		return -EINVAL;
@@ -2763,22 +2807,25 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_get_cmd(void __user *argp, struct kvm_tdx_cmd *cmd)
+{
+	if (copy_from_user(cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd->hw_error)
+		return -EINVAL;
+
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
 	int r;
 
-	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
-		return -EFAULT;
-
-	/*
-	 * Userspace should never set hw_error. It is used to fill
-	 * hardware-defined error by the kernel.
-	 */
-	if (tdx_cmd.hw_error)
-		return -EINVAL;
-
-	mutex_lock(&kvm->lock);
+	r = tdx_get_cmd(argp, &tdx_cmd);
+	if (r)
+		return r;
 
 	switch (tdx_cmd.id) {
 	case KVM_TDX_CAPABILITIES:
@@ -2791,15 +2838,12 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 		r = tdx_td_finalize(kvm, &tdx_cmd);
 		break;
 	default:
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
 		r = -EFAULT;
 
-out:
-	mutex_unlock(&kvm->lock);
 	return r;
 }
 
@@ -3079,11 +3123,13 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	long gmem_ret;
 	int ret;
 
+	CLASS(tdx_vm_state_guard, guard)(kvm);
+	if (IS_ERR(guard))
+		return PTR_ERR(guard);
+
 	if (tdx->state != VCPU_TD_STATE_INITIALIZED)
 		return -EINVAL;
 
-	guard(mutex)(&kvm->slots_lock);
-
 	/* Once TD is finalized, the initial guest memory is fixed. */
 	if (kvm_tdx->state == TD_STATE_RUNNABLE)
 		return -EINVAL;
@@ -3101,6 +3147,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
 		return -EINVAL;
 
+	vcpu_load(vcpu);
+
 	ret = 0;
 	while (region.nr_pages) {
 		if (signal_pending(current)) {
@@ -3132,11 +3180,28 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 		cond_resched();
 	}
 
+	vcpu_put(vcpu);
+
 	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
 		ret = -EFAULT;
 	return ret;
 }
 
+int tdx_vcpu_async_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx_cmd cmd;
+	int r;
+
+	r = tdx_get_cmd(argp, &cmd);
+	if (r)
+		return r;
+
+	if (cmd.id != KVM_TDX_INIT_MEM_REGION)
+		return -ENOIOCTLCMD;
+
+	return tdx_vcpu_init_mem_region(vcpu, &cmd);
+}
+
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -3146,19 +3211,14 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
 		return -EINVAL;
 
-	if (copy_from_user(&cmd, argp, sizeof(cmd)))
-		return -EFAULT;
-
-	if (cmd.hw_error)
-		return -EINVAL;
+	ret = tdx_get_cmd(argp, &cmd);
+	if (ret)
+		return ret;
 
 	switch (cmd.id) {
 	case KVM_TDX_INIT_VCPU:
 		ret = tdx_vcpu_init(vcpu, &cmd);
 		break;
-	case KVM_TDX_INIT_MEM_REGION:
-		ret = tdx_vcpu_init_mem_region(vcpu, &cmd);
-		break;
 	case KVM_TDX_GET_CPUID:
 		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
 		break;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2b3424f638db..a797101a2150 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -149,6 +149,7 @@ int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+int tdx_vcpu_async_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92e916eba6a9..281cd0980245 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6946,6 +6946,13 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
 			       unsigned long arg)
 {
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+
+	if (ioctl == KVM_MEMORY_ENCRYPT_OP &&
+	    kvm_x86_ops.vcpu_mem_enc_async_ioctl)
+		return kvm_x86_call(vcpu_mem_enc_async_ioctl)(vcpu, argp);
+
 	return -ENOIOCTLCMD;
 }
 
-- 
2.51.0.318.gd7df087d1a-goog


--PWFjyiMo08ArJL/7--

