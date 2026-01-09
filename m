Return-Path: <kvm+bounces-67504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D0AD0704E
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B200730141F9
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D10270EAB;
	Fri,  9 Jan 2026 03:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vQNAg0O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1422701B6
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930336; cv=none; b=NtHNo3swOc7iZDUvDNdE2SBw4pgQHQyqNV5T4QBoq47efRV3ih40fZA7jTk0OS6RboJ2gKsdIssDqzgxCjXFjQEP3Gi77mZh1rWqSAjt4vt5cj3m9BUiVJPiDAk7BEO3c7hRluai/e+WYzdpsySwML8C9LAlA/J9eJMsN7Z+Ofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930336; c=relaxed/simple;
	bh=44NLMQg7b0qPekFfq0rXAqzfW6KbwOTNoHdMKnldv+w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qIsTy+JjG5ylQ6tjSCk4kIA1FXVGM+lPPl4ItmGQeInhwiRcwIO+3o0ZQCrYAtzS3qZ09nhu9/Zq3w8k0OYJHPUGZRjbJvmxXn89fzQCCnIiTDFm+04pZv0dZ0l1clc9Rj99RG5GZ+2W9VL83vg3DECPjJUf7sagMOFbrAy+b9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4vQNAg0O; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a089575ab3so46101225ad.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930334; x=1768535134; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Usyyv3vbn9Zs1dHefvSjaFrxGu3puMMI3CZOd1kdzpo=;
        b=4vQNAg0OIJyWITVZpi1/I/8qYVteot8e4zR3+3EGWqJI2IR1+B9TfOWkKYcvWXoOAl
         DTd5b8e4BON5Yjleoyt+cwF/djInxkLTa6lKYp4A8hiYx4HSt2xkej4UFMHJ01HDDsYf
         GR3pZKncbW6PeUqQwcz3x9NXx44RVRQFWCAVu1IegnIa5EARqqTpocw/RjveOCNMBtNG
         pvinT4B9AKFJli+ZcTPEPseqUGgfG93y9jz32EBrSFBnQpgqsWSVOdwHz35/Zov9hkqU
         phi4BL0Nu08+sS9JWxz5leed1M7RX9KzETBOQR1AUUry9xL8nqwuRtRqeKRQuuZ6LV08
         h7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930334; x=1768535134;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Usyyv3vbn9Zs1dHefvSjaFrxGu3puMMI3CZOd1kdzpo=;
        b=ag7GW5Md2o5B5cAXEmRQGipJ0RsrbZ/iXSVQkArinLnx1FGbe7IAYT1WO+PF4URLLC
         ZHHrvnDmBXCDLClkLRJv5WqTvgL3Zy+vHyzwpgrbxmpglnA8QSo2/8/BJQaJHpayIrxy
         b2KIjozH0vfR7064YjA+EjhA54jfguibfsVsDo5UIhPOWjYDn1CVJEB93LI5wgXdpkXD
         YYWNvkcWHQ9AsiX61DhOkQkhgN0S4sW2cACjtQshU5Jcox6hGy4FbXT/U5b6WYB1bLJo
         mS09AKcECRTMfjuOoAFFlGWTrBBoW7E+aPb0bMmrlRiF5iPL7OgnKG2+GJqtPPqof3UF
         RmPg==
X-Gm-Message-State: AOJu0Yyc8H0RHjQnJURhlF1hBK6fQgTL3FF/WYZ3wF4YpTW9CCSxYr6u
	TEB1ZpVnRBLpMFwFQGZa9vwz+dWekPDkygBC9Nzk12RzgW9YcalASzjvX+yGSEkwIdZ7kPXq+O8
	V3SURzw==
X-Google-Smtp-Source: AGHT+IFfD/dUdsnoh7snkCHevc54ELReyloloUGxnk/RwpEyG/V7WAfylfRUmjo47S/SD8YVDoXIuxgoETs=
X-Received: from plma18.prod.google.com ([2002:a17:902:7d92:b0:2a0:9ab8:a28d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b84:b0:29e:c283:39fb
 with SMTP id d9443c01a7336-2a3ee4d9e3dmr77961705ad.52.1767930334263; Thu, 08
 Jan 2026 19:45:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-1-seanjc@google.com>
Subject: [PATCH v4 0/8] KVM: VMX: Rip out "deferred nested VM-Exit updates"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

v4 of what was "KVM: VMX: Fix APICv activation bugs", but the two bug fixes
were already merged and so that name doesn't fit.

Rip out the "defer updates until nested VM-Exit" that contributed to the
APICv bugs and made them harder to fix.

v4:
 - Collect reviews. [Chao]
 - Use the existing vmcall() in the selftest. [Chao]
 - Use GUEST_FAIL() instead of TEST_FAIL() in the guest. [Chao]
 - Correct the number of args passed to the guest in the test. [Chao]
 - Remove the redundant hwapic_isr_update() call in kvm_lapic_reset()
 - Use the local "vmx" variable in vmx_set_virtual_apic_mode(). [Chao]
 - Relocate the "update SVI" comment from __kvm_vcpu_update_apicv()
   to kvm_apic_update_apicv().

v3:
 - https://lore.kernel.org/all/20251205231913.441872-1-seanjc@google.com
 - Add a selftest.
 - Rip out the deferred updates stuff.
 - Collect Chao's review.
 - Add Dongli's fix for bug #2. [Chao]

v2:
 - https://lore.kernel.org/all/20251110063212.34902-1-dongli.zhang@oracle.com
 - Add support for guest mode (suggested by Chao Gao).
 - Add comments in the code (suggested by Chao Gao).
 - Remove WARN_ON_ONCE from vmx_hwapic_isr_update().
 - Edit commit message "AMD SVM APICv" to "AMD SVM AVIC"
   (suggested by Alejandro Jimenez).


Sean Christopherson (8):
  KVM: selftests: Add a test to verify APICv updates (while L2 is
    active)
  KVM: nVMX: Switch to vmcs01 to update PML controls on-demand if L2 is
    active
  KVM: nVMX: Switch to vmcs01 to update TPR threshold on-demand if L2 is
    active
  KVM: nVMX: Switch to vmcs01 to update SVI on-demand if L2 is active
  KVM: nVMX: Switch to vmcs01 to refresh APICv controls on-demand if L2
    is active
  KVM: nVMX: Switch to vmcs01 to update APIC page on-demand if L2 is
    active
  KVM: nVMX: Switch to vmcs01 to set virtual APICv mode on-demand if L2
    is active
  KVM: x86: Update APICv ISR (a.k.a. SVI) as part of
    kvm_apic_update_apicv()

 arch/x86/kvm/lapic.c                          |  31 ++--
 arch/x86/kvm/lapic.h                          |   1 -
 arch/x86/kvm/vmx/nested.c                     |  29 ----
 arch/x86/kvm/vmx/vmx.c                        |  95 +++++++----
 arch/x86/kvm/vmx/vmx.h                        |   9 -
 arch/x86/kvm/x86.c                            |   7 -
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/x86/apic.h  |   4 +
 .../kvm/x86/vmx_apicv_updates_test.c          | 155 ++++++++++++++++++
 9 files changed, 232 insertions(+), 100 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.457.g6b5491de43-goog


