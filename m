Return-Path: <kvm+bounces-70536-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 5nhmDU67hmkNQgQAu9opvQ
	(envelope-from <kvm+bounces-70536-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:10:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BF361104D44
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4260F3048084
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589F02C11D3;
	Sat,  7 Feb 2026 04:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JtRNnDA1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C92E2D7804
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437415; cv=none; b=aR1LC89q331vlpBBjXfSg4qlxT4BEZ6DX+z4gpALv5mrMEYmDErM+UQp5NyG9Jli4UNb0RBR8fKYyiRL7qsSDvoEotVvHpg88uiTcZlLxQJGzdXtchgZMSkhYynMIDSuJk3KoMIIZJE4GWV5xtO4QWM01VdMNRkVlALI4LnoJLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437415; c=relaxed/simple;
	bh=5qfnrj3G1xNYE98CkRPRtOxsLzJem6iX9oFznGPRF+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nifc6Wewcwv9evDVH9lU4PhPYmXRpZUVsyY9Kjo3q+HVoKe8fwpllRXPiWco8pAVQaj8/TDcmjVBKUFvW0dQK3QX+FnmR+ASPmh93r5AOpfc03xhV0mmnEEv8OhDZDUdqnhpCnfrtKuYffYYR4CNbtkTEZ2xyqPGer6Q5P3V5Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JtRNnDA1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a79164b686so34329715ad.0
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437415; x=1771042215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X9ehPSc+/m11r/Lpb5VMOSkPuQY5TIHayM+j3lFOULU=;
        b=JtRNnDA1VS0WC/f9V78mzMMPTGxjdS6IMPvTLyJt+izCv1682xCFY7aCzM+sUxqFu0
         A2SrkO3Br4UX733AfJgn54l1ktp0cDKRG7RLCTieFLRSKLvkFyRThWWoOrB5x3mtXgUh
         CBytYrjIl8sTggcVpwlLgRcJ7wb9M7y9al03HePNFul7QsMMNbHWq6CRnnGoQMK7Iml/
         bKlwYx8DPZnR0EFXjidJK3lydckXkMHpf5yUVETbBWosT/Cueqj7NkCMjAxZAVCFuXhA
         f5oW1oMDEc7w7h2wJVAiROsr7eQDKk96tC+EOwe3IW8InWdPa2s+5YWnhtHOmI3cQjqB
         2lhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437415; x=1771042215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X9ehPSc+/m11r/Lpb5VMOSkPuQY5TIHayM+j3lFOULU=;
        b=LnywGsfITMg3buOjLTCb99kjgQCGpskFiFKuKuM2TTr15EFUM7QcmZ1TsO81d5Ao6X
         +XgenQbz9303cDiGcZRtFfSiCjeXdpaa+Sfd2Q7Fbf5Otawa2d45hpgrMzoLl4Yyo836
         SsAfY6PNumlYrbkplxzmtr3fgo/yHbqIKTBJMXuKh5Jto0A6uNC+OZWc5tgOAjVviVNG
         mzuqJzfiuK6pfsNXtwEqHSOElGlaLBYnCTWX8esk9ubjtdZ3jUGbUZOOxA1jk9saM2dm
         RX69Pd0Oz3cj5/84UTSyOUQpFSmDPP3UPZSSZ8FypaRM/Xu5IB3YERdcIBFgEOCNOQ+m
         SJsw==
X-Gm-Message-State: AOJu0YxVzWVvB4PTLcPyxfBMkdLyLYHJWhHhtmOjjrcjTf/lTn967BAB
	KQ/D4+sOEZ28nbOZKvXTEYenKXGy3KzD/qoSXCbcmnT1he1hJbQQyyccVHYCLcjOxoLiWzuffFX
	mOsSkwA==
X-Received: from plzt8.prod.google.com ([2002:a17:902:bc48:b0:2a9:5b22:145a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b4e:b0:2a8:ac0f:9ae9
 with SMTP id d9443c01a7336-2a951709c40mr45532335ad.41.1770437414890; Fri, 06
 Feb 2026 20:10:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:03 -0800
In-Reply-To: <20260207041011.913471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: APIC related changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70536-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: BF361104D44
X-Rspamd-Action: no action

A variety of cleanups and minor fixes, mostly related to APIC and APICv.

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-apic-6.20

for you to fetch changes up to ac4f869c56301831a60706a84acbf13b4f0f9886:

  KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty() (2026-01-14 06:01:03 -0800)

----------------------------------------------------------------
KVM x86 APIC-ish changes for 6.20

 - Fix a benign bug where KVM could use the wrong memslots (ignored SMM) when
   creating a vCPU-specific mapping of guest memory.

 - Clean up KVM's handling of marking mapped vCPU pages dirty.

 - Drop a pile of *ancient* sanity checks hidden behind in KVM's unused
   ASSERT() macro, most of which could be trivially triggered by the guest
   and/or user, and all of which were useless.

 - Fold "struct dest_map" into its sole user, "struct rtc_status", to make it
   more obvious what the weird parameter is used for, and to allow burying the
   RTC shenanigans behind CONFIG_KVM_IOAPIC=y.

 - Bury all of ioapic.h and KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=y.

 - Add a regression test for recent APICv update fixes.

 - Rework KVM's handling of VMCS updates while L2 is active to temporarily
   switch to vmcs01 instead of deferring the update until the next nested
   VM-Exit.  The deferred updates approach directly contributed to several
   bugs, was proving to be a maintenance burden due to the difficulty in
   auditing the correctness of deferred updates, and was polluting
   "struct nested_vmx" with a growing pile of booleans.

 - Handle "hardware APIC ISR", a.k.a. SVI, updates in kvm_apic_update_apicv()
   to consolidate the updates, and to co-locate SVI updates with the updates
   for KVM's own cache of ISR information.

 - Drop a dead function declaration.

----------------------------------------------------------------
Binbin Wu (1):
      KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty()

Fred Griffoul (1):
      KVM: nVMX: Mark APIC access page dirty when syncing vmcs12 pages

Sean Christopherson (21):
      KVM: Use vCPU specific memslots in __kvm_vcpu_map()
      KVM: x86: Mark vmcs12 pages as dirty if and only if they're mapped
      KVM: nVMX: Precisely mark vAPIC and PID maps dirty when delivering nested PI
      KVM: VMX: Move nested_mark_vmcs12_pages_dirty() to vmx.c, and rename
      KVM: x86: Drop ASSERT()s on APIC/vCPU being non-NULL
      KVM: x86: Drop guest/user-triggerable asserts on IRR/ISR vectors
      KVM: x86: Drop ASSERT() on I/O APIC EOIs being only for LEVEL_to WARN_ON_ONCE
      KVM: x86: Drop guest-triggerable ASSERT()s on I/O APIC access alignment
      KVM: x86: Drop MAX_NR_RESERVED_IOAPIC_PINS, use KVM_MAX_IRQ_ROUTES directly
      KVM: x86: Add a wrapper to handle common case of IRQ delivery without dest_map
      KVM: x86: Fold "struct dest_map" into "struct rtc_status"
      KVM: x86: Bury ioapic.h definitions behind CONFIG_KVM_IOAPIC
      KVM: x86: Hide KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=y
      KVM: selftests: Add a test to verify APICv updates (while L2 is active)
      KVM: nVMX: Switch to vmcs01 to update PML controls on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to update TPR threshold on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to update SVI on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to refresh APICv controls on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to update APIC page on-demand if L2 is active
      KVM: nVMX: Switch to vmcs01 to set virtual APICv mode on-demand if L2 is active
      KVM: x86: Update APICv ISR (a.k.a. SVI) as part of kvm_apic_update_apicv()

 arch/x86/include/asm/kvm_host.h                    |   2 +
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/ioapic.c                              |  43 +++---
 arch/x86/kvm/ioapic.h                              |  38 ++---
 arch/x86/kvm/irq.c                                 |   4 +-
 arch/x86/kvm/lapic.c                               |  97 ++++++-------
 arch/x86/kvm/lapic.h                               |  21 ++-
 arch/x86/kvm/vmx/nested.c                          |  54 +------
 arch/x86/kvm/vmx/nested.h                          |   1 -
 arch/x86/kvm/vmx/vmx.c                             | 106 +++++++++-----
 arch/x86/kvm/vmx/vmx.h                             |   9 --
 arch/x86/kvm/x86.c                                 |  11 +-
 arch/x86/kvm/xen.c                                 |   2 +-
 include/linux/kvm_host.h                           |   9 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/include/x86/apic.h     |   4 +
 .../selftests/kvm/x86/vmx_apicv_updates_test.c     | 155 +++++++++++++++++++++
 virt/kvm/kvm_main.c                                |   2 +-
 18 files changed, 334 insertions(+), 227 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c

