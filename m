Return-Path: <kvm+bounces-53201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A34B0F037
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CD823BEDCD
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292DD289837;
	Wed, 23 Jul 2025 10:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nYmoo7Ou"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE265248897
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267641; cv=none; b=hp5oHoospczzQz33mmOcTkJN0fczXQ+vbw0EHQKFAXmvMRl3kYG/Ip8vVFZlYIlhwHspPEbaYxKUzGODypV0pW9wqeIQpNJT63iw5kxAr86pWhSDy04uVDFmP+cmN1jYk0ASCdZN4Py4FCSt6GWpiFU/ZceNiWSS+NwGUA6D4qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267641; c=relaxed/simple;
	bh=c/XS5ewtaGuLKhzHP+5yEB/GdDuoY/+4kh1Qi+4FNro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MDN1u32Yrw27pAIP2n0nawQw/7BnlPbLdgPd3ObLFxjp9SPPehJquYkSiF/csyuvgGUEi5/x6wLsLQQw73tl1kuouLZar8Xmpqh76taYTMYbMHL+e7mPODgZxlIm8Y8BQkGjyJW0yc3pFlMuLJGD2meB5e8PuTxEOlX0vVJA37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nYmoo7Ou; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso5222807f8f.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267637; x=1753872437; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=irM8qZtZs2OxjIAk0ctgU1D+7CU3BEq0B4YUNMOwj2s=;
        b=nYmoo7OuW+VeOqw8i+AjTZhNOmqbrAW3NczFcBl6FokF0kq316bNP9nQ676s6aFe7Q
         aP5QMCXkl6n636trETDNQLxlb+KEU5O0YyPVU7pg5UXq5XakGyEhBoUpl6Dptl1Fw3T8
         25lDuNqvp8WIHKuwos9/ZaF1PCqQgPvkMr0wVOaot94JkIFt3oWNT/EJ8iu4equeKY2v
         pvOTdLUS/JGMAy2kxhjDGkxfS7I0nlanBqttQt1E/EigK1Sni0eAB/QZvwwfIraYghNl
         RhCsgj9inVjtjdHrxVBlZ2TAYI6XLUmCnUGgMVAw5f9wdGudB+pWz1l3PyLwylP+6osl
         hPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267637; x=1753872437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=irM8qZtZs2OxjIAk0ctgU1D+7CU3BEq0B4YUNMOwj2s=;
        b=Zv3wrQPV4IQITBCuez9mbea6EScftKkX03S9mDEzLWsE40xjK71f6ZBnnVRFsGAhV/
         CLw1Po8BiJYs2xXAdPbE7XZghHL5pZz1HDvQM5eRSar7E2mmBrKPZ3arVxHGDApb25gs
         tUBqrm0hA3XEuCTv7wrTgljOZm5nGLFXkS9JXa3Zv3xBqNsJtjYk/gUL3iPzhWU9THp4
         s19NNfPV66lQtUB1WpEDk99xqQ5kl3StnIRneEiEtUpD88AjMyOV+bcAv8qAmi/GH08U
         WeUKX9oOgIbFrJNLxtAL0oU9vcSv0jOTy0PYK8O8RMMAT1kiJ+qO2lvrwjCvBGbEX/BN
         LE7A==
X-Gm-Message-State: AOJu0YzQIew0Mu2fmMnUuvi6CqiLIonoFGSGgbz+b35DMCVQbpvNkW/b
	DvKcfCPAV9mPoNJr3rnly3nFUYaKxFkVWqS5xIf8vWiof1PJp0MdEpmHySc1dL7xmEb3BRj7BI5
	APdUGuu2G+oFwWXbK3196lPB2osF7yY2Sj/wJhNnlTsXC+NOcL5DYqLikv3bMP7P6Nios29Dgty
	HPrHpo0+Pj8XKOWmkxq0GxGX98KKU=
X-Google-Smtp-Source: AGHT+IG5Z3A6R2I6Yt40IaTyInl4VZ3bw90RL9tNJeKgjFFghyeEaG3W+L0zG4oREWZmzmC9PH6Pnqlt3w==
X-Received: from wmbjg14.prod.google.com ([2002:a05:600c:a00e:b0:456:365f:428b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2312:b0:3b4:5a9d:8323
 with SMTP id ffacd0b85a97d-3b768ee082emr1858112f8f.7.1753267636987; Wed, 23
 Jul 2025 03:47:16 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:54 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-3-tabba@google.com>
Subject: [PATCH v16 02/22] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
i.e. gate them on at least one vendor module being enabled and thus on
kvm.ko actually being built.  Depending on just KVM allows the user to
select the configs even though they won't actually take effect, and more
importantly, makes it all too easy to create unmet dependencies.  E.g.
KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.

Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
helps communicate to the user that nothing "interesting" is going on, e.g.

  --- Virtualization
  <M>   Kernel-based Virtual Machine (KVM) support
  < >   KVM for Intel (and compatible) processors support
  < >   KVM for AMD processors support

Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2c86673155c9..9895fc3cd901 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -74,7 +74,7 @@ config KVM_WERROR
 	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
 	# Building KVM with -Werror and KASAN is still doable via enabling
 	# the kernel-wide WERROR=y.
-	depends on KVM && ((EXPERT && !KASAN) || WERROR)
+	depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
 	help
 	  Add -Werror to the build flags for KVM.
 
@@ -83,7 +83,7 @@ config KVM_WERROR
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
-	depends on KVM && X86_64
+	depends on KVM_X86 && X86_64
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -169,7 +169,7 @@ config KVM_AMD_SEV
 config KVM_IOAPIC
 	bool "I/O APIC, PIC, and PIT emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
 	  for full in-kernel APIC emulation.
@@ -179,7 +179,7 @@ config KVM_IOAPIC
 config KVM_SMM
 	bool "System Management Mode emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate System Management Mode (SMM)
 	  in virtual machines.  This can be used by the virtual machine
@@ -189,7 +189,7 @@ config KVM_SMM
 
 config KVM_HYPERV
 	bool "Support for Microsoft Hyper-V emulation"
-	depends on KVM
+	depends on KVM_X86
 	default y
 	help
 	  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
@@ -203,7 +203,7 @@ config KVM_HYPERV
 
 config KVM_XEN
 	bool "Support for Xen hypercall interface"
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides KVM support for the hosting Xen HVM guests and
 	  passing Xen hypercalls to userspace.
@@ -213,7 +213,7 @@ config KVM_XEN
 config KVM_PROVE_MMU
 	bool "Prove KVM MMU correctness"
 	depends on DEBUG_KERNEL
-	depends on KVM
+	depends on KVM_X86
 	depends on EXPERT
 	help
 	  Enables runtime assertions in KVM's MMU that are too costly to enable
@@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
 
 config KVM_MAX_NR_VCPUS
 	int "Maximum number of vCPUs per KVM guest"
-	depends on KVM
+	depends on KVM_X86
 	range 1024 4096
 	default 4096 if MAXSMP
 	default 1024
-- 
2.50.1.470.g6ba607880d-goog


