Return-Path: <kvm+bounces-35717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A557FA14761
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CFB8188A840
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38F617555;
	Fri, 17 Jan 2025 01:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M5CDvF4f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B115515FD01
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076056; cv=none; b=gc6udO/nb3WkTigUji1LGsyKfcC6WmiRqvu5xPnFV16uAIssO6dW7+NDdagGWgTVHD+2dhxQglvb9A1K7CC/Gs5NtjYQUbOfs4xcoodiaOkAVeb4GlOZ/vRyiTQ9xGmEdqUkltrCSez3qD2a6N4uY/4WzJBhYLyBvMU+ll/T+hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076056; c=relaxed/simple;
	bh=cnUcN3lkFPLfe0UVCiHE/CS9EnzheWp5w1nG8tqzlzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JmL1gKgl2XkDkMdV0TPo3ganN3ZyvWNb6iSdD/h+ktcOc4Iv7Nsu+DblhBKUhQJlD+hyr49FwXR4N37sN2La2puMz58MLhNDzFugg10Bxn2RvlWQPhqQrrBkD3AKUAOZEp/icxUP2YZvXgKyL6KvQSEDMeXlYG5uFiGMe3YALiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M5CDvF4f; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso3129324a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076054; x=1737680854; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QcYxczR0tvkXhhtjh3QEWO3iRdccgPPVshgvC2xXtIM=;
        b=M5CDvF4f2GnRU8qmO3c/75MKaOHwCqdw4/L1gKupJBZW3KHHrIPxmEYCAXMOW5PE/O
         Q4w/0y4WNM+9zIdMSzNUCbGSFDZ59uXlNQJfs9o3UZoRDQug32b/DAzP4zYEylEvfvDk
         t4HAcNpBYukLk7P0+okTdBD8XjvvcXnphWrZHF8JRBcRKF5RHSWeTEJiQsGcgpropC1O
         8zN/H5FqmbqDOejcDwHkaESHCiYCEAH6mSshq7GbIJGAkvZGU0GTJ7sKs/wzrwNsiERO
         1qS2y218nYqIGkCwGm7cSkranmOYT1jCUOzA/PreGlDJjuAiN14+aP7rRNDLkvqlUniH
         65Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076054; x=1737680854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QcYxczR0tvkXhhtjh3QEWO3iRdccgPPVshgvC2xXtIM=;
        b=SZKGZFnj8/OK5qGFLmLGjU/e/fapdjSxmnodFWdOiCjQ6cgzl9MBEaiD79lNLG0v9B
         QiBKLch9vmb+1kyutNjxEc2UsGSnNKGvXzrJhvOJIe8Gpiv1AByqrclE2KC7L4sFM/jA
         BGTL8CuqdqR10T//ZpCrQpFGcIju+6Yb/vLiabnxUsYcK/yRYoCaz0h06KJLkm8qHJTl
         Q1BpY8X7LFJ7JUVExuiuXMoCEgGrVtlqMf8BP5d2IhGz6rRD7gp0RkxsPdqYXpVGwNB7
         F5yrTnwL2oOuDhjXxUUUVZ5/MKKSm9Jp1erLfr+cClJo2C7iiVslYJ5H8VxQvU5GzVCN
         fhxw==
X-Gm-Message-State: AOJu0YzN+I9Ftl6i8ms9eb49iqDPE6/FEur2jpxLgoanq2WO+0IvYPOU
	xxtYzpHwUmODYYvTEkJ7/DnXAKyvP6wX7aKw0fH3EJeQ2UFcfVeWIxJc0xGC8IN2MHSYSPksNV0
	VxA==
X-Google-Smtp-Source: AGHT+IGUIHuN/oPKGCYO3+FW7cDtyj68lojRfHJCr7/KhobmdI4O5lzDG6ATPvYnmoEO8716xXSETQsj4Dw=
X-Received: from pjbsj7.prod.google.com ([2002:a17:90b:2d87:b0:2da:ac73:93e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:7141:b0:2ee:dd9b:e402
 with SMTP id 98e67ed59e1d1-2f782c70237mr1210675a91.12.1737076054056; Thu, 16
 Jan 2025 17:07:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:18 -0800
In-Reply-To: <20250117010718.2328467-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX change for 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A few fixes and cleanups.  The most notable change is Chao's fix for a nasty
bug where L1's SVI didn't get updated and result in the interrupt being left
in-service forever (though only uncommon use cases are affected, e.g. running
pKVM x86 in L1).

The following changes since commit 3522c419758ee8dca5a0e8753ee0070a22157bc1:

  Merge tag 'kvm-riscv-fixes-6.13-1' of https://github.com/kvm-riscv/linux into HEAD (2024-12-13 13:59:20 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.14

for you to fetch changes up to 37c3ddfe5238d88b6ec091ecdf967848bce067c2:

  KVM: VMX: read the PML log in the same order as it was written (2025-01-08 14:31:25 -0800)

----------------------------------------------------------------
KVM VMX changes for 6.14:

 - Fix a bug where KVM updates hardware's APICv cache of the highest ISR bit
   while L2 is active, while ultimately results in a hardware-accelerated L1
   EOI effectively being lost.

 - Honor event priority when emulating Posted Interrupt delivery during nested
   VM-Enter by queueing KVM_REQ_EVENT instead of immediately handling the
   interrupt.

 - Drop kvm_x86_ops.hwapic_irr_update() as KVM updates hardware's APICv cache
   prior to every VM-Enter.

 - Rework KVM's processing of the Page-Modification Logging buffer to reap
   entries in the same order they were created, i.e. to mark gfns dirty in the
   same order that hardware marked the page/PTE dirty.

 - Misc cleanups.

----------------------------------------------------------------
Adrian Hunter (1):
      KVM: VMX: Allow toggling bits in MSR_IA32_RTIT_CTL when enable bit is cleared

Chao Gao (2):
      KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID
      KVM: x86: Remove hwapic_irr_update() from kvm_x86_ops

Costas Argyris (1):
      KVM: VMX: Reinstate __exit attribute for vmx_exit()

Gao Shiyuan (1):
      KVM: VMX: Fix comment of handle_vmx_instruction()

Maxim Levitsky (2):
      KVM: VMX: refactor PML terminology
      KVM: VMX: read the PML log in the same order as it was written

Sean Christopherson (6):
      KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
      KVM: nVMX: Explicitly update vPPR on successful nested VM-Enter
      KVM: nVMX: Check for pending INIT/SIPI after entering non-root mode
      KVM: nVMX: Drop manual vmcs01.GUEST_INTERRUPT_STATUS.RVI check at VM-Enter
      KVM: nVMX: Use vmcs01's controls shadow to check for IRQ/NMI windows at VM-Enter
      KVM: nVMX: Honor event priority when emulating PI delivery during VM-Enter

 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  3 +-
 arch/x86/kvm/lapic.c               | 25 +++++++-----
 arch/x86/kvm/lapic.h               |  1 +
 arch/x86/kvm/vmx/main.c            |  3 +-
 arch/x86/kvm/vmx/nested.c          | 84 +++++++++++++++++++++++---------------
 arch/x86/kvm/vmx/vmx.c             | 76 ++++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h             |  6 ++-
 arch/x86/kvm/vmx/x86_ops.h         |  3 +-
 9 files changed, 120 insertions(+), 82 deletions(-)

