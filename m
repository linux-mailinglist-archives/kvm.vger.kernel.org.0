Return-Path: <kvm+bounces-64588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5B5C87BD9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:47:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C0EE6355057
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248763081BB;
	Wed, 26 Nov 2025 01:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A0fHz4aP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129FB30C611
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121511; cv=none; b=MkarcNEvKKDL8yymrWog3nC/YzPVPW7siWbhCuTptz1u9C/f5+4tUo010HMkaFxTpXRfPvczj/PpPS22ZOtkiMRL05QbMCENrOlxorkB7+HnOmWfcJ51WTh8h8OtXfF26KbX86LvlJOrxnCyX8mLyiKCs8ZxP2YpxkmAxdC+PjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121511; c=relaxed/simple;
	bh=nYEPUwYKbmW5mhrrMXVBJvAXAe8WHFbP6znh2Px5NDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Npz/LxBgjCJHFOIfhk+GVM3yMYHxAjHg8AaW2klHwOM/2bZ0MnI7HcmfGe0LGDSH7vyZE7HjglJqprG6ooreoCEOk5KsncFr1udwzgutMmYjtVD493GUr0NTae/AVIuvWI+WZM2mN4DDpLmHMgtZrdW2a2mMjPUebFs0DZL0dfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A0fHz4aP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343806688cbso14750048a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121508; x=1764726308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=07656lNFj5BO3ugrp3q49Gq1eNlpiz3jhqhcx9bHDIo=;
        b=A0fHz4aPVSL5guCcmkW87xZp4G0HHWvL+3k66CLFrhrbq/DW0jO+d18IEq8HmvruuM
         7JIEJVL3ou9aGR3+IKfujV74SywoY01Iejwh+MDywemri7nf7zz6EDqP7CA8m+Ky4fpx
         8vuoWW6xEAiK2HAP7wJoHDAZig4eeOPMKKI+DsmWd8i5qy0PFLSHIuCDXlrV0uDq/jiP
         UzeOxhhfYduYCbTf4wpjTxQ0PkCzmThhnCxzlUZ7HVxEslbrSL2nQI15C/H/5lHEyFWs
         /lowVT2vj0h1yrMc7zExasISe1kg41VCyWLP8oye+86EdKlMziioWa5NtdyejmOwaAnZ
         PrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121508; x=1764726308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=07656lNFj5BO3ugrp3q49Gq1eNlpiz3jhqhcx9bHDIo=;
        b=vpbijPNLM8dLIXEiOAHkpEQ0I4kpKeXFs2LvJ+VKILomxJGGQP/CqEF5FfpNDhiIWz
         S/zfO2XwWhyYRaKEil/QzzbfJTKEmozTpugSVLzp71F+H73L71NmOdtiIMqVMtgyFaWL
         34AsZaR5uH+E+XqdCBUx1Sbh9qkBdo7SggWOPoYOmMDGEgHodsvIFVO4uLGkt97WyKoP
         fyoyCnr8li7myZfcMGuA4sloQFSTuI9i2A0Gjv5IYLgWeMTefYFMd1ZjxorVb927XtBU
         dVILk6zC3QGVl1I4ZYHh12YsY8+guRwUVKT1HbZ56Gr4ftIYYDcKAMVG1FJnPKNGl/R1
         8s2A==
X-Gm-Message-State: AOJu0Yy719X7mfyWT6LK9TRoiQsUwa70UYUEi0zSrg3abcpNnLJbYjPZ
	ImMYeMo/PiCBlUspJtZGOUIj5KZiEUTRGekDNJ7vjbZ37i7HLcLC2e4i9AJqfbE5i1wOfCcd3s+
	CS5Uw/A==
X-Google-Smtp-Source: AGHT+IGY5pV2285RONiSnvxkAS6NF2VyiuRamyd9V0BN6bwFCHdx9j2lFgPRRcozQQ27yIqlZagU8UjThSs=
X-Received: from pjbdw12.prod.google.com ([2002:a17:90b:94c:b0:343:4a54:8435])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2d0:b0:340:bb51:17eb
 with SMTP id 98e67ed59e1d1-34733e94f50mr17985222a91.15.1764121508388; Tue, 25
 Nov 2025 17:45:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:53 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A handful of lowish priority nSVM fixes, AVIC support for 4k vCPUs, and new
uAPI to advertise SNP policy bits to userspace.

Side topic, this pull request is finally proof that I don't just merge my own
stuff :-D

There's a minor conflict in svm.h due to the removal of the
avic_ga_log_notifier() declaration in kvm/master:

diff --cc arch/x86/kvm/svm/svm.h
index dd78e6402345,a9f6c1ece63d..9e151dbdef25
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@@ -806,7 -802,8 +803,8 @@@ extern struct kvm_x86_nested_ops svm_ne
  )
  
  bool __init avic_hardware_setup(void);
 -int avic_ga_log_notifier(u32 ga_tag);
 +void avic_hardware_unsetup(void);
+ int avic_alloc_physical_id_table(struct kvm *kvm);
  void avic_vm_destroy(struct kvm *kvm);
  int avic_vm_init(struct kvm *kvm);
  void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);

And a conflict in cpufeatures.h with the "misc" pull request.  This (and the
change from "misc") will also conflict with new features being added via the
tip-tree.  Boris is aware and presumably will give Linus a heads up.  Merging
on top of "misc":

diff --cc arch/x86/include/asm/cpufeatures.h
index fc5698844a0b,7129eb44adad..646d2a77a2e2
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@@ -499,11 -500,7 +500,12 @@@
  #define X86_FEATURE_IBPB_EXIT_TO_USER (21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
  #define X86_FEATURE_ABMC              (21*32+15) /* Assignable Bandwidth Monitoring Counters */
  #define X86_FEATURE_MSR_IMM           (21*32+16) /* MSR immediate form instructions */
- #define X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO (21*32+17) /*
+ #define X86_FEATURE_X2AVIC_EXT                (21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
++#define X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO (21*32+18) /*
 +                                                    * Clear CPU buffers before VM-Enter if the vCPU
 +                                                    * can access host MMIO (ignored for all intents
 +                                                    * and purposes if CLEAR_CPU_BUF_VM is set).
 +                                                    */
  
  /*
   * BUG word(s)


The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.19

for you to fetch changes up to 275d6d1189e6d5f8e7c1da43ffd4b09d7089f174:

  KVM: SEV: Add known supported SEV-SNP policy bits (2025-11-14 10:30:12 -0800)

----------------------------------------------------------------
KVM SVM changes for 6.19:

 - Fix a few missing "VMCB dirty" bugs.

 - Fix the worst of KVM's lack of EFER.LMSLE emulation.

 - Add AVIC support for addressing 4k vCPUs in x2AVIC mode.

 - Fix incorrect handling of selective CR0 writes when checking intercepts
   during emulation of L2 instructions.

 - Fix a currently-benign bug where KVM would clobber SPEC_CTRL[63:32] on
   VMRUN and #VMEXIT.

 - Fix a bug where KVM corrupt the guest code stream when re-injecting a soft
   interrupt if the guest patched the underlying code after the VM-Exit, e.g.
   when Linux patches code with a temporary INT3.

 - Add KVM_X86_SNP_POLICY_BITS to advertise supported SNP policy bits to
   userspace, and extend KVM "support" to all policy bits that don't require
   any actual support from KVM.

----------------------------------------------------------------
Jim Mattson (4):
      KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
      KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN
      KVM: x86: Advertise EferLmsleUnsupported to userspace
      KVM: SVM: Disallow EFER.LMSLE when not supported by hardware

Naveen N Rao (7):
      KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
      KVM: SVM: Add a helper to look up the max physical ID for AVIC
      KVM: SVM: Replace hard-coded value 0x1FF with the corresponding macro
      KVM: SVM: Expand AVIC_PHYSICAL_MAX_INDEX_MASK to be a 12-bit field
      KVM: SVM: Move AVIC Physical ID table allocation to vcpu_precreate()
      x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
      KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode

Omar Sandoval (1):
      KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced

Tom Lendacky (4):
      KVM: SEV: Consolidate the SEV policy bits in a single header file
      crypto: ccp - Add an API to return the supported SEV-SNP policy bits
      KVM: SEV: Publish supported SEV-SNP policy bits
      KVM: SEV: Add known supported SEV-SNP policy bits

Uros Bizjak (1):
      KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched between guest and host

Yosry Ahmed (4):
      KVM: nSVM: Remove redundant cases in nested_svm_intercept()
      KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation
      KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
      KVM: x86: Document a virtualization gap for GIF on AMD CPUs

 Documentation/virt/kvm/x86/errata.rst |  9 +++-
 arch/x86/include/asm/cpufeatures.h    |  2 +
 arch/x86/include/asm/kvm_host.h       |  9 ++++
 arch/x86/include/asm/svm.h            |  5 +-
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kernel/cpu/scattered.c       |  1 +
 arch/x86/kvm/cpuid.c                  |  1 +
 arch/x86/kvm/svm/avic.c               | 86 ++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/nested.c             | 12 +----
 arch/x86/kvm/svm/sev.c                | 45 +++++++++++-------
 arch/x86/kvm/svm/svm.c                | 78 ++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h                |  4 +-
 arch/x86/kvm/svm/vmenter.S            | 47 +++++++++++++++----
 arch/x86/kvm/x86.c                    | 21 +++++++++
 drivers/crypto/ccp/sev-dev.c          | 37 +++++++++++++++
 include/linux/psp-sev.h               | 37 +++++++++++++++
 16 files changed, 310 insertions(+), 85 deletions(-)

