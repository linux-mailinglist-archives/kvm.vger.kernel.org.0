Return-Path: <kvm+bounces-48917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAACEAD4694
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FB8A3A717B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9655286D6F;
	Tue, 10 Jun 2025 23:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ocACGQd+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4735260593
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 23:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749597615; cv=none; b=DiMEC8VBTbEI5R4D1B68MuyWRmYwArvZlswlb+gNXm0lCp7TQzf3OIMeYRBU32ATrFwfmJSRXKjxiCRa58Ih2eqZrlnx5tLmvj4i0vdrenp442vfFax/5Px2iE/h7vCWZ85aFPG1ARL8HHSKRagtSienRJJd44bdNV6rRUdhh0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749597615; c=relaxed/simple;
	bh=p9aKJqud9RPGUf6Wxhg6SVrztt6IbydiB5KcKa8G5Ro=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=m7vuDv7FvZWSHA08JlMutOoEeoj/G3c132X6HYhLvf0yTHJ9JoPuxaVVgPCayqI8/Ckl0OKpRciS1siHPyov7bsSRfm4zO0iHfZd89R0hpvvkRSg9BA8pnEUYB92HhUDK0IThQOL9LQvrPw74T9JauBaphlMgK0M9zzpKNQzveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ocACGQd+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311a6b43ed7so5146465a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749597613; x=1750202413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZPjLY2mM4L86u9ZjSVjk1YzN2wRc/83Yq2+tB5bYN0=;
        b=ocACGQd+o8OzZeG7t4Us7EiriNHs/eFftpiGR8Ej/46czzuKbFvPMgxYi8xqHV5QQk
         MtCsngFAlyZwanM9eP+gprsrXxUqoXTWSgtppT6G+pI7t+Xdg3lVxQ6LFG9KWnnB+Cd+
         JYSYoUkApffdasCqpunxO/QRrAMzxAutksNOktPm483DOU2iiNHtG1g5ASTyOw8b+DKs
         GrH44d3VwAWhEV2B6RmxeFtzue6L1GNMxmQK02xU2sT33Q7/zSf+b9If7rbDH7oXVEIi
         NjodAgD45IsvmKm48ncaiZDAb2yfZ/1ZuUNHmRIge5LC5n8cw68W/zoqS/MdKc3rRDX7
         TInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749597613; x=1750202413;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SZPjLY2mM4L86u9ZjSVjk1YzN2wRc/83Yq2+tB5bYN0=;
        b=IuK0+ynS5xRjN188BvGiJJm1MAhJhxTzQP/W/V2jsxs1u0Fjsfs+4iz0Rxl/hT836g
         u+1acEKCt+OOfshKcagid7z8xrjiL38vC+M4o0T4LAx+brFBwPrUeuj4DOFo0Pp1T6UR
         84D8m/O/3oXy1llQvrzhGVl21YrHH+L7RUCvqmCZaK912OiKqbkW4ad1sz5eFl8S8goS
         mhueRhW5GDrewKy02GTqqwpOaFapicohTae3f0sMZbR5OYPEzahr3htPWF1WiMxGyS7r
         xoU/259e+Kz/2fm1PEAhVsfeCbMQ1kKh4xxmHiQJyZJeJPMK9vy6ahJE5kuX5rUDiA5O
         xLfQ==
X-Gm-Message-State: AOJu0YwcJDH1qPA4mIrqP+kPf/RQdHSUdwCfJPdmFNFrugOSvJ2FFShJ
	+55I+WAcCUWHmPMnXxYgss9tDTCevvQ0h4ZZPR+zN+7VtkOzVEiWYzUruPG6j0/TvMVMTPHjJLn
	jZDBOmw==
X-Google-Smtp-Source: AGHT+IHMsJP22tXC45lUB8bXPeYj5teOCFoLNUprGp6l4PmXTAgs0Ik/+qVXzVGfqBDDly8tAhipWg1QI+k=
X-Received: from pjbsz14.prod.google.com ([2002:a17:90b:2d4e:b0:311:d264:6f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35d2:b0:312:e9d:4002
 with SMTP id 98e67ed59e1d1-313af1ddd30mr1583512a91.28.1749597613006; Tue, 10
 Jun 2025 16:20:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 16:20:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610232010.162191-1-seanjc@google.com>
Subject: [PATCH v6 0/8] KVM: VMX: Preserve host's DEBUGCTL.FREEZE_IN_SMM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Preserve the host's FREEZE_IN_SMM setting by stuffing GUEST_DEBUGCTL, so that
SMM activity doesn't bleed into PMU events while running the guest.

Along the way, enforce the supported set of DEBUGCTL bits when processing
vmcs12.GUEST_DEBUGCTL, as KVM can't rely on hardware to reject an MSR value
that is supported in hardware.

To minimize the probability of the nVMX fix breaking existing setups, allow
the guest to use DEBUGCTL.RTM_DEBUG if RTM is exposed to the guest.

v6:
 - WARN in tdx_vcpu_run() if KVM requests DR6 load.
 - Ignore unsupported-but-suppressed DEBUGCTL bits when doing consistency
   check on vmcs12.
 - Add support for DEBUGCTL.RTM_DEBUG.
 - Use accessors in all paths.
 - Add a dedicated vmx_reload_guest_debugctl().

v5: https://lore.kernel.org/all/20250522005555.55705-1-mlevitsk@redhat.com

Maxim Levitsky (3):
  KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter
  KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs
  KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while running the
    guest

Sean Christopherson (5):
  KVM: TDX: Use kvm_arch_vcpu.host_debugctl to restore the host's
    DEBUGCTL
  KVM: x86: Convert vcpu_run()'s immediate exit param into a generic
    bitmap
  KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag
  KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported
  KVM: VMX: Extract checking of guest's DEBUGCTL into helper

 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    | 15 ++++++--
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/kvm/svm/svm.c             | 14 ++++----
 arch/x86/kvm/vmx/common.h          |  2 --
 arch/x86/kvm/vmx/main.c            | 17 +++------
 arch/x86/kvm/vmx/nested.c          | 21 ++++++++---
 arch/x86/kvm/vmx/pmu_intel.c       |  8 ++---
 arch/x86/kvm/vmx/tdx.c             | 24 ++++++-------
 arch/x86/kvm/vmx/vmx.c             | 57 ++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h             | 26 ++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  4 +--
 arch/x86/kvm/x86.c                 | 25 ++++++++++---
 13 files changed, 140 insertions(+), 75 deletions(-)


base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
-- 
2.50.0.rc0.642.g800a2b2222-goog


