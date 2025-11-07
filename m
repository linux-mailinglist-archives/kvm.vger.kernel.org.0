Return-Path: <kvm+bounces-62367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B88C41D88
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 23:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C02F1896C85
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 22:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A85F310771;
	Fri,  7 Nov 2025 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q2+YlgGZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1423514F70
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762555092; cv=none; b=CSN6Cdng5klpRGNbWwq5cr863YU63fH/LBQe1Q7mOBOJ2IVriCFZfDaG+BuVIwkUyf6ZOUh/lYeb3limXKE6bEE9tFcl4vP8wAn9DbfD8QvhKIU6POpR5WSFplmUZVW3ELgriuqBSiy+HHE7+NIqA9a1lc8H0/pf+qQgDOmxZYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762555092; c=relaxed/simple;
	bh=rtZVSAacOqPDAFhwZey31w9nuqAAxwnJYwwpxH186z4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rWo17UMWaKIVXgsueE99nPfe2wmYd3lus2apBVwCXDUDmH7xstJBW8fz9bJHYKMOkbEOtYobmXF2oRB4nLCzCyLNfYfb0jPub16bTzKKJMcd3ZrdEw2I8jykb/fB6JnG+lIZ0UX+tIqJouISQx6TdikTJKO+9YuQ7GQfK+VMvEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q2+YlgGZ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a267606fe8so1112262b3a.0
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 14:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762555090; x=1763159890; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6ZWrSszRgf+OK0UMrDoILB8VEgH0P7tEZvUBb1KzcU=;
        b=q2+YlgGZ7CpdEYAzisJNRDxLQQAUBwLxVkQWMBf6UWvaH3JpRSSk2A8tvW8Ae1YKe9
         xBDdXy6HroB9/wj++BUPckKd9nUSLAp7DV+jbV0iLxaMB+Wu+/r1Euc/OrTr8U8gaosK
         RfVpR7RCXAXdqr9f61y5M9/UI2Xqfljq4Mvs8KpxDNmcn7HCYkcusE/Tk2LS9oB1Ug0M
         V/N/KsU9z3TzAydSdmL+79tmmszFZ6UV19zh9IZgzneckMAe3aV4ajAbNjq542unHwHR
         KQiHVK/0484jZLWevKELATqDScqhYiQ2YYuswMYTK14Q/j8A5vgd6ZVPn/jAfjwgzIhY
         dxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555090; x=1763159890;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6ZWrSszRgf+OK0UMrDoILB8VEgH0P7tEZvUBb1KzcU=;
        b=pUm1LF9OV5i/QYYhmZ/usWRzSpkjKdPlf4TDAkiqGHIlSjuayPBsUcMK/MagLfxWU5
         +nzBXdssmxD2dR0sjL1DP0fn7OWhr8XpGZ/FgzpflBa0490MrFwSCIYRb+fNDUQ7zS5c
         PCICQvXrlrq9tLz1av0No2PjCqNpoRS9NXt/fxZB1eybqJ0jI3l01FiAWTDVbwru6t/c
         To9BQ55ecyOZ+GxIJtIMfnYVKrY9xhnnKRZrNUfpGBhAe7AuQOcIm1UbZXqjyf3TEGBR
         tpev1NEtxBGLCjcltJMtyJSmJlcuMOEtlxDUKJW67o10xaJf0btzfJlVIgK5Z2sCO32e
         TpyQ==
X-Gm-Message-State: AOJu0Yyl1sN69rorLiC0pE2j6ia+eh2qmRZtld426WOktAAz37Uq16hy
	xZkDrQ5bNHHKHka7zzAjUS0q9hRDP0XJ2iolVDzxQjvtZ5JBolS5d32Ye/EpxdPOzIRfm7RHtK3
	Z6noM2A==
X-Google-Smtp-Source: AGHT+IEV6rezXdMLPCPwuqWjMz8IR9xWFef3dr3uacIFfEdeI79wnVgSP3RuuWePVcrDflpsPEvEVN3urR0=
X-Received: from pge26.prod.google.com ([2002:a05:6a02:2d1a:b0:b85:7a45:1f8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3286:b0:34f:d380:5f2b
 with SMTP id adf61e73a8af0-353a18e5b2emr949487637.17.1762555090163; Fri, 07
 Nov 2025 14:38:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Nov 2025 14:38:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107223807.860845-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 fixes and a guest_memd fix for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a variety of fixes that fall into one of three categories:

 - Recent-ish TDX-induced bugs (VM death on SEAMCALL/TDCALL, and my
   paperbag GVA_IS_VALID goof).

 - Long-standing issues that were exposed and/or are made releavnt by
   6.18 (guest_memfd UAF race, GALog unregister and ir_list_lock from AVIC).

 - Bugs introduce in 6.18 (splat when emulating INIT for CET XSTATE).

The following changes since commit 4361f5aa8bfcecbab3fc8db987482b9e08115a6a:

  Merge tag 'kvm-x86-fixes-6.18-rc2' of https://github.com/kvm-x86/linux into HEAD (2025-10-18 10:25:43 +0200)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.18-rc5

for you to fetch changes up to d0164c161923ac303bd843e04ebe95cfd03c6e19:

  KVM: VMX: Fix check for valid GVA on an EPT violation (2025-11-06 06:06:18 -0800)

----------------------------------------------------------------
KVM x86 fixes for 6.18:

 - Inject #UD if the guest attempts to execute SEAMCALL or TDCALL as KVM
   doesn't support virtualization the instructions, but the instructions
   are gated only by VMXON, i.e. will VM-Exit instead of taking a #UD and
   thus result in KVM exiting to userspace with an emulation error.

 - Unload the "FPU" when emulating INIT of XSTATE features if and only if
   the FPU is actually loaded, instead of trying to predict when KVM will
   emulate an INIT (CET support missed the MP_STATE path).  Add sanity
   checks to detect and harden against similar bugs in the future.

 - Unregister KVM's GALog notifier (for AVIC) when kvm-amd.ko is unloaded.

 - Use a raw spinlock for svm->ir_list_lock as the lock is taken during
   schedule(), and "normal" spinlocks are sleepable locks when PREEMPT_RT=y.

 - Remove guest_memfd bindings on memslot deletion when a gmem file is dying
   to fix a use-after-free race found by syzkaller.

 - Fix a goof in the EPT Violation handler where KVM checks the wrong
   variable when determining if the reported GVA is valid.

----------------------------------------------------------------
Chao Gao (1):
      KVM: x86: Call out MSR_IA32_S_CET is not handled by XSAVES

Maxim Levitsky (1):
      KVM: SVM: switch to raw spinlock for svm->ir_list_lock

Sean Christopherson (7):
      KVM: VMX: Inject #UD if guest tries to execute SEAMCALL or TDCALL
      KVM: x86: Unload "FPU" state on INIT if and only if its currently in-use
      KVM: x86: Harden KVM against imbalanced load/put of guest FPU state
      KVM: SVM: Initialize per-CPU svm_data at the end of hardware setup
      KVM: SVM: Unregister KVM's GALog notifier on kvm-amd.ko exit
      KVM: SVM: Make avic_ga_log_notifier() local to avic.c
      KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying

Sukrit Bhatnagar (1):
      KVM: VMX: Fix check for valid GVA on an EPT violation

 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/svm/avic.c         | 24 +++++++++++++--------
 arch/x86/kvm/svm/svm.c          | 15 +++++++------
 arch/x86/kvm/svm/svm.h          |  4 ++--
 arch/x86/kvm/vmx/common.h       |  2 +-
 arch/x86/kvm/vmx/nested.c       |  8 +++++++
 arch/x86/kvm/vmx/vmx.c          |  8 +++++++
 arch/x86/kvm/x86.c              | 48 +++++++++++++++++++++++++----------------
 virt/kvm/guest_memfd.c          | 47 ++++++++++++++++++++++++++++------------
 9 files changed, 106 insertions(+), 51 deletions(-)

