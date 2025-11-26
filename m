Return-Path: <kvm+bounces-64590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A08BC87BE5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:47:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C532D35513A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A183130E0E5;
	Wed, 26 Nov 2025 01:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LW+9i8hy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D630DD29
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121514; cv=none; b=Qkb5BzZ6HU+J5/c8wQQN3p3tynL+DVFsjglFsZ78LTuRKnC6S3joUlcaujuphtOvsuyFqJn7W79KPCWAUbkFXK2chBWNDAzKglhnNswXCCcUi1gW938y0Y5bhEACRUdjYIC5gm/UYh14MYoxh6m9IYbdNklLbUqTU9pLsgdWbi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121514; c=relaxed/simple;
	bh=a9XUd/GkdvTR+giNptkBB9B+Z54L2COVibW55dqHkkU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uwI6KJmNXrvp51Dx6gnGyLPKvrO8zyK8hSIkd+t3/S+buxcvJtf5FC4WZ0m/rLvkpf9Z/RYtaUaZaZO1U1mXQK93LYwLl2QhImK/zCHMC6dto1J0NHFqmRDNww6vmb8H2axSYR1ESCdkapmXqWlqm90gOe7+WXuEZvXM5/YRFtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LW+9i8hy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34566e62f16so6610729a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121511; x=1764726311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YLNPrunBaAgckpNETOf1HHhRezwW4CsbkffZPKO6ENw=;
        b=LW+9i8hyDmn7LwJ5mcTbIqQmSZAtvrbgGH3S/VKuxx4+ufXVMxrKPaWjo9q4XD88Ts
         +LwaXMgEc8vriZdNooLz7XR+pMS+T6TyJJgbhq+xXYHs49kU+1pCcGV5Ck65zF+TlbAg
         4bshfAzbz7JcZ4Lb4YH6OVVFaxwEEwBv3acA3HisNV7L0L/3VuTMg4LSfzDG9MeuouDk
         3WWzlqQvUmVpyb4mHwZ09+Ipic63It7PRZfqUi/yvwh9vyOKmZ7t4QfVAos7Yfq/HTkb
         bP4ISnHTEQCXeXDAOfHnXG55IwpiFZOnY1SidKOIznYuEU4uPYYMWu3yTs6ijUaFDD8q
         GeRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121511; x=1764726311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YLNPrunBaAgckpNETOf1HHhRezwW4CsbkffZPKO6ENw=;
        b=Ze2MJgmAqk1sSg4P2dQolpBCCVRWIvTU6reKrNgP11RZz6wf7XBb1uPvXWbUOMkprs
         qj8Q/XN/KzMLHVpEQfTCvkL5ugDfU0fEA2cn1FaOphmhoCK8/MvCD6BT9zVyvCVz03CF
         2xleQWbfe1I/2eStolLy76wC3Rz5VB4xqt2Aex9TUBxTqSRaBkkMUJp2HbbaF61XfDE0
         ceGm7IbNUaf48UlsvIJcQKWf5q6ovTurpGrjaHaiC+rGMtia+AX+sm1sVvXGYOTU7zKC
         lTOHhsXry7ffqoWAfBLAQg4NeLYrvGimchYmLqpphBZ+i17X8rvIjn5GpDGmbAqqd6B8
         MZnQ==
X-Gm-Message-State: AOJu0Ywat8wxv5cQ8Hdw3O6y2rcENeBcvxrYnT9LlAlr+0FitDpI0ef5
	bxzDa4FymPCcX0kYDOKc8TCpKAFQRK8WMmUHspqMle4Ym8Dmq1BBCjPEdWVs2WJ526FVtcyzd+X
	6PfzKng==
X-Google-Smtp-Source: AGHT+IGGIMTgSWSQQSFKXmS9rhHMiiAbalfKZ9R/kpmEF9drWehfXfpSUJgor+yFl42/ElvbIxC4tT7Izho=
X-Received: from pjbbb13.prod.google.com ([2002:a17:90b:8d:b0:33d:98cb:883b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a81:b0:343:684c:f8ac
 with SMTP id 98e67ed59e1d1-34733e4c8fdmr15529916a91.8.1764121511522; Tue, 25
 Nov 2025 17:45:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:55 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-9-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The highlight is EPTP construction cleanup that's worthwhile on its own, but
is also a step toward eliding the EPT flushes that KVM does on pCPU migration,
which are especially costly when running nested:

https://lore.kernel.org/all/aJKW9gTeyh0-pvcg@google.com

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.19

for you to fetch changes up to dfd1572a64c90770a2bddfab9bbb69932217b1da:

  KVM: VMX: Make loaded_vmcs_clear() static in vmx.c (2025-11-11 07:41:16 -0800)

----------------------------------------------------------------
KVM VMX changes for 6.19:

 - Use the root role from kvm_mmu_page to construct EPTPs instead of the
   current vCPU state, partly as worthwhile cleanup, but mostly to pave the
   way for tracking per-root TLB flushes so that KVM can elide EPT flushes on
   pCPU migration if KVM has flushed the root at least once.

 - Add a few missing nested consistency checks.

 - Rip out support for doing "early" consistency checks via hardware as the
   functionality hasn't been used in years and is no longer useful in general,
   and replace it with an off-by-default module param to detected missed
   consistency checks (i.e. WARN if hardware finds a check that KVM does not).

 - Fix a currently-benign bug where KVM would drop the guest's SPEC_CTRL[63:32]
   on VM-Enter.

 - Misc cleanups.

----------------------------------------------------------------
Dmytro Maluka (1):
      KVM: VMX: Remove stale vmx_set_dr6() declaration

Sean Christopherson (10):
      KVM: VMX: Hoist construct_eptp() "up" in vmx.c
      KVM: nVMX: Hardcode dummy EPTP used for early nested consistency checks
      KVM: x86/mmu: Move "dummy root" helpers to spte.h
      KVM: VMX: Use kvm_mmu_page role to construct EPTP, not current vCPU state
      KVM: nVMX: Add consistency check for TPR_THRESHOLD[31:4]!=0 without VID
      KVM: nVMX: Add consistency check for TSC_MULTIPLIER=0
      KVM: nVMX: Stuff vmcs02.TSC_MULTIPLIER early on for nested early checks
      KVM: nVMX: Remove support for "early" consistency checks via hardware
      KVM: nVMX: Add an off-by-default module param to WARN on missed consistency checks
      KVM: VMX: Make loaded_vmcs_clear() static in vmx.c

Thorsten Blum (1):
      KVM: TDX: Replace kmalloc + copy_from_user with memdup_user in tdx_td_init()

Uros Bizjak (1):
      KVM: VMX: Ensure guest's SPEC_CTRL[63:32] is loaded on VM-Enter

Xin Li (1):
      KVM: nVMX: Use vcpu instead of vmx->vcpu when vcpu is available

 arch/x86/kvm/mmu/mmu_internal.h |  10 ---
 arch/x86/kvm/mmu/spte.h         |  10 +++
 arch/x86/kvm/vmx/nested.c       | 173 ++++++++++++++--------------------------
 arch/x86/kvm/vmx/tdx.c          |  30 +++----
 arch/x86/kvm/vmx/vmenter.S      |  20 +++--
 arch/x86/kvm/vmx/vmx.c          |  59 +++++++++-----
 arch/x86/kvm/vmx/vmx.h          |   2 -
 arch/x86/kvm/vmx/x86_ops.h      |   1 -
 8 files changed, 135 insertions(+), 170 deletions(-)

