Return-Path: <kvm+bounces-19726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F81D9094D6
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 01:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0B28285DE9
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 23:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D557D187575;
	Fri, 14 Jun 2024 23:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PQ6Z6dEi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88917186E52
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 23:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718408780; cv=none; b=oDz8Mdqpn/BByD4Fw1uCBl2q7niWrRJgx/VBOF/I/xMUBUWnbDRJGwwCjmrSuDD8eOtwwtmSs79EpG6Smjp1zXIYgj9VFgEd/rEljvL0wz3mqOZcSGGGgiw7TE2mDjZ952c07vM5C2c4MwPS8DETo6/BCD5AgKul66RAosnuYUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718408780; c=relaxed/simple;
	bh=ljJzkXa7ANkHoKsMp4kvwIbmepQnokgR3jDEO1hn3hQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HufhC3ehPeR/e5sBiWL18+rmtWoDiiWkSLSJsmKoh91Kv0QjVg4G8Ed58jBE9hr50csAwlkmx63urvb6qjQUdoEOGsjJ76x9R1npvL8iXqUrStimJy7g7ZKdeeY6SA/cYGkwwsrqRAW4brNyFVxWfWcVjRw9djVvbIY/jaOWVX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PQ6Z6dEi; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a080977a5so44645537b3.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 16:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718408777; x=1719013577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ihyioj1vM0TB1JZPZzaB/gYRDOE282ffuWXqLcMdCjo=;
        b=PQ6Z6dEisAI1gHfIRMbVHL5P1bD2s6e2+xRU1XvxnRkxRZijFCH6UNcKiAeLg7gN5r
         k6I98ub0lOZO+TDY3q7ZiUOqEW4msB3aD/iyygAKWtIBkSl+gVODeVpOpaY0z6ktau/i
         k1xP761R8Uf4fQeRPDXgipWFz/0e88+ctejoDg1RyMMNqeHEXHY+ItrVl9Ew4t9aA6zn
         fGrWQpZJ+AHnNQJDs+CUb8eRGzZbDERzVYZqX5txkPq7sUFjDfWYozwWnBjpVvWoi81Y
         j5oMFiySDGy84pfecLGrhr/rjCNMEcC2P+PpCt5pXE5RIpgx0Ptq0HYRUCZ6tPOrK4ES
         EZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718408777; x=1719013577;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ihyioj1vM0TB1JZPZzaB/gYRDOE282ffuWXqLcMdCjo=;
        b=C5bPoBNxIYmooeUuE9q5JrvPJNL5JZD8772EQNKF3rGfwqlz3q4l+ut28wiK9arHJ7
         1TU/Mfq936xnIBtnLmlFivPlNSoOwom4+MtgRSyqtxklf7R3FzOWc3LRVhrj/F9ArLxT
         viYiDnl3m5HirJtC6a66jXwnIDRnL86lPQpisgNG1hAmEie2e8YxTHJAUt5Lesrn20br
         qa6aDl4gsTpUM9BFDAY+A/4P8fcQpBLXGJ14W/M7W0YQdFs/TP/zD27uun8ZwL2hXnK4
         6Kcvu/n6dRdSMHsehW9ZQlr4DbvzD8wajMXf5FmzZBx50qaXhkLat9hHr7vgqJHoIPrC
         lKqw==
X-Gm-Message-State: AOJu0YzIt+k0l1GoGl5iIV7lZNqkEL/myUd/twlY7wNjFSFAlO8AzVks
	XGqJT308PyqqyXdK7WGRIlyArwRCYTpnSZcaEE+CKzZPWNEPHcZlmLZXjROS6MGtC72CfnM5q4g
	gFA==
X-Google-Smtp-Source: AGHT+IGsNIFQzvSxopjGxpBcmhg8niaT/U2KyXwPKBNT1HI7T+uzCN3yVFXnFKldTa3gvdpm7vToxU/snMo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f8e:b0:62c:c5ea:66ad with SMTP id
 00721157ae682-6322255e683mr12725577b3.4.1718408777427; Fri, 14 Jun 2024
 16:46:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Jun 2024 16:46:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <20240614234607.1405974-1-seanjc@google.com>
Subject: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a smattering of x86 changes, most of which have been sitting around
on-list for quite some time.  There are still quite a few KUT x86 series that
want attention, but they are all quite large and exceeded what little review
time I have for KUT :-/

Note, the posted interrupt test fails due to KVM bugs, patches posted:
https://lore.kernel.org/all/20240607172609.3205077-1-seanjc@google.com

The following changes since commit a68956b3fb6f5f308822b20ce0ff8e02db1f7375:

  gitlab-ci: Always save artifacts (2024-06-05 12:49:58 +0200)

are available in the Git repository at:

  https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2024.06.14

for you to fetch changes up to ee1d79c3f0f871bf78f20930cb1a2441f28ac027:

  nVMX: Verify KVM actually loads the value in HOST_PAT into the PAT MSR (2024-06-11 06:41:23 -0700)

----------------------------------------------------------------
x86 fixes, cleanups, and new testcases:

 - Add a testcase to verify that KVM doesn't inject a triple fault (or any
   other "error") if a nested VM is run with an EP4TA pointing MMIO.

 - Play nice with CR4.CET in test_vmxon_bad_cr()

 - Force emulation when testing MSR_IA32_FLUSH_CMD to workaround an issue where
   Skylake CPUs don't follow the architecturally defined behavior, and so that
   the test doesn't break if/when new bits are supported by future CPUs.

 - Rework the async #PF test to support IRQ-based page-ready notifications.

 - Fix a variety of issues related to adaptive PEBS.

 - Add several nested VMX tests for virtual interrupt delivery and posted
   interrupts.

 - Ensure PAT is loaded with the default value after the nVMX PAT tests
   (failure to do so was causing tests to fail due to all memory being UC).

 - Misc cleanups.

----------------------------------------------------------------
Alejandro Jimenez (1):
      x86: vmexit: Allow IPI test to be accelerated by SVM AVIC

Dan Wu (1):
      x86/asyncpf: Update async page fault test for IRQ-based "page ready"

Jack Wang (1):
      x86/msr: Fix typo in output SMR

Jim Mattson (1):
      nVMX: Enable x2APIC mode for virtual-interrupt delivery tests

Marc Orr (3):
      nVMX: test nested "virtual-interrupt delivery"
      nVMX: test nested EOI virtualization
      nVMX: add self-IPI tests to vmx_basic_vid_test

Mingwei Zhang (3):
      x86: Add FEP support on read/write register instructions
      x86: msr: testing MSR_IA32_FLUSH_CMD reserved bits only in KVM emulation
      x86/pmu: Clear mask in PMI handler to allow delivering subsequent PMIs

Oliver Upton (1):
      nVMX: add test for posted interrupts

Sean Christopherson (9):
      nVMX: Use helpers to check for WB memtype and 4-level EPT support
      nVMX: Use setup_dummy_ept() to configure EPT for test_ept_eptp() test
      nVMX: Add a testcase for running L2 with EP4TA that points at MMIO
      x86/pmu: Enable PEBS on fixed counters iff baseline PEBS is support
      x86/pmu: Iterate over adaptive PEBS flag combinations
      x86/pmu: Test adaptive PEBS without any adaptive counters
      x86/pmu: Add a PEBS test to verify the host LBRs aren't leaked to the guest
      nVMX: Ensure host's PAT is loaded at the end of all VMX tests
      nVMX: Verify KVM actually loads the value in HOST_PAT into the PAT MSR

Yang Weijiang (3):
      nVMX: Exclude CR4.CET from the test_vmxon_bad_cr()
      nVMX: Rename union vmx_basic and related global variable
      nVMX: Introduce new vmx_basic MSR feature bit for vmx tests

 lib/x86/apic.h       |   5 +
 lib/x86/asm/bitops.h |   8 +
 lib/x86/desc.h       |  30 +++-
 lib/x86/pmu.h        |   6 +-
 lib/x86/processor.h  |  24 ++-
 x86/asyncpf.c        | 154 ++++++++++------
 x86/msr.c            |  23 ++-
 x86/pmu.c            |   1 +
 x86/pmu_pebs.c       | 110 +++++++-----
 x86/unittests.cfg    |  19 +-
 x86/vmx.c            |  50 +++---
 x86/vmx.h            |   7 +-
 x86/vmx_tests.c      | 497 ++++++++++++++++++++++++++++++++++++++++++++++++---
 13 files changed, 755 insertions(+), 179 deletions(-)

