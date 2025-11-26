Return-Path: <kvm+bounces-64587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACFA3C87BD0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 677DE3B5459
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C79C30BB88;
	Wed, 26 Nov 2025 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3L2AaAgR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB18630AD11
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121509; cv=none; b=nmflgeZB9JltO+yQHW0n3JBJ5ThSxk3UMPPe6LXMzbrPogin3d7mIeT3od7WemHk0I972igY4aB/2brdeLVWzfdXl6PHyLkKt++hx2KATtUzlFnE1Clnox6YEST0vIDBmgT45l3UMr8078PrUdFsUloo/F0c5H8ptaHfj5p0ZTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121509; c=relaxed/simple;
	bh=AzMraleJ+53k5LhSGFh8jsmpITt4ELeO9gJGnd50RdU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GhpOVfO4WHrjHeowDOpC2WesmYi/FrJTIesqY+TJoXuslRO9TwNLoNVJ0uQOqGqnXFLFR05NXch+whllcr6fFNZWmT9tpGPrJrwSi4JJ17CqMFw5TGJZij0GLiLU+16w44nVpKGK7kUOrzEvW0sPSzpCx87Lb6ezpa13p8WtLKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3L2AaAgR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29557f43d56so77788405ad.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121507; x=1764726307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ3rLemZWs+TokChe5w7eM4LkWhkRpugMrVw9gqlWlU=;
        b=3L2AaAgRRiufGoTvqsJJiNBMKHEiLzXri7UtEOIF1hNLI10dcEgQ1zkSDGYGtrUxSY
         cFG19Sr4ME5aoZaSRB8lB7eLgoWrCMKNkmhTrIYIMphSgMHU75dSUQrAueCNvIfBuNJk
         hkE+osKHfB/OXimeCMmnx8cVCLmhRC8nv6KjKvCusR1klSZKjoaIHqr4ykHwD6DS3Oov
         oukq5mTjIXWPmwp1UyBHHroncFGXrZC1kU2qOEAA7qG7optLUMMiL9WQgMqwtqaGR0Kw
         cXHu/waaAw5BXAngX070ZHC/Heray7TWmLmDVfdFCbblbpGCLq0Wr/A+aZ9d3R8/SmUq
         rQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121507; x=1764726307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZ3rLemZWs+TokChe5w7eM4LkWhkRpugMrVw9gqlWlU=;
        b=e0yoUOL+wskcx+cPrTZEfktkSpLDUGYnu/cOzgSVb6oci7noACitmMKf8F16RkSUed
         3rdmk3PZSfPT4gV+NirJbVKeWXBdICh36p455PpX8fBdJKI0uKVRUKOCSHsUH9mcw+gn
         6w95VdI9xwmepB9GC0Hp6x+dbIvkWDECp7rMiaa5KE+5DdCWi68iv1ssYM5SDs4UgvxJ
         9pvqrYbh6NIEuBeDqwX12Iv6FgiTjYBiJ1ztHpxLje326EqXGpt8py24oH+Xutq6fCtS
         CTbfuj2Wg0E01SvDClBpTWX8aFz4NIBa4oX/NuN0tU/f4pTRrdHaZW247+9HZW6Q8cO4
         04Qg==
X-Gm-Message-State: AOJu0YwbdQCi0TjUXf/9y2wQZGKV1zfbg+E/d1QG/kAlNm6SOP4P6iGb
	JHX+X0+IDHHFxj7EaVGgjVHU4TJQPThdqMcxDc1MNDnKzZSbhzfPrRTsq8DTZ+VCFFBm0dJIFmk
	b6NJCVA==
X-Google-Smtp-Source: AGHT+IH04eUXQ/g6fDZpkb12mVYLQ4RIWFpoBwEaUlK2DwBjLlmq72LWHCxfidUBjIBVishW5r438HAvt1Y=
X-Received: from pgbl34.prod.google.com ([2002:a63:5722:0:b0:bc4:233b:be04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc84:b0:295:f508:9d32
 with SMTP id d9443c01a7336-29bab149b90mr56928645ad.37.1764121506889; Tue, 25
 Nov 2025 17:45:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:52 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The highlights are Jim's LA57 nested VMX test, and Yosry's many changes to
extend nested VMX tests to also cover nested SVM.

The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.19

for you to fetch changes up to d2e50389ab44acfa05e72604d701a70b234f9938:

  KVM: selftests: Make sure vm->vpages_mapped is always up-to-date (2025-11-21 10:17:05 -0800)

----------------------------------------------------------------
KVM selftests changes for 6.19:

 - Fix a math goof in mmu_stress_test when running on a single-CPU system/VM.

 - Forcefully override ARCH from x86_64 to x86 to play nice with specifying
   ARCH=x86_64 on the command line.

 - Extend a bunch of nested VMX to validate nested SVM as well.

 - Add support for LA57 in the core VM_MODE_xxx macro, and add a test to
   verify KVM can save/restore nested VMX state when L1 is using 5-level
   paging, but L2 is not.

 - Clean up the guest paging code in anticipation of sharing the core logic for
   nested EPT and nested NPT.

----------------------------------------------------------------
Brendan Jackman (1):
      KVM: selftests: Don't fall over in mmu_stress_test when only one CPU is present

Jim Mattson (4):
      KVM: selftests: Use a loop to create guest page tables
      KVM: selftests: Use a loop to walk guest page tables
      KVM: selftests: Change VM_MODE_PXXV48_4K to VM_MODE_PXXVYY_4K
      KVM: selftests: Add a VMX test for LA57 nested state

Sean Christopherson (2):
      KVM: selftests: Forcefully override ARCH from x86_64 to x86
      KVM: selftests: Use "gpa" and "gva" for local variable names in pre-fault test

Yosry Ahmed (9):
      KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
      KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
      KVM: selftests: Move nested invalid CR3 check to its own test
      KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
      KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
      KVM: selftests: Stop hardcoding PAGE_SIZE in x86 selftests
      KVM: selftests: Remove the unused argument to prepare_eptp()
      KVM: selftests: Stop using __virt_pg_map() directly in tests
      KVM: selftests: Make sure vm->vpages_mapped is always up-to-date

 tools/testing/selftests/kvm/Makefile               |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   8 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   5 +-
 .../testing/selftests/kvm/include/x86/processor.h  |   2 +-
 tools/testing/selftests/kvm/include/x86/vmx.h      |   3 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  33 +++---
 tools/testing/selftests/kvm/lib/x86/memstress.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86/processor.c    |  84 ++++++-------
 tools/testing/selftests/kvm/lib/x86/vmx.c          |   9 +-
 tools/testing/selftests/kvm/mmu_stress_test.c      |  10 +-
 .../testing/selftests/kvm/pre_fault_memory_test.c  |  32 +++--
 tools/testing/selftests/kvm/x86/hyperv_features.c  |   2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c       |  18 +--
 tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c |   2 +-
 ...while_nested_test.c => nested_close_kvm_test.c} |  42 +++++--
 .../selftests/kvm/x86/nested_invalid_cr3_test.c    | 116 ++++++++++++++++++
 ..._tsc_adjust_test.c => nested_tsc_adjust_test.c} |  73 +++++++-----
 ...sc_scaling_test.c => nested_tsc_scaling_test.c} |  48 +++++++-
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |   2 +-
 tools/testing/selftests/kvm/x86/state_test.c       |   2 +-
 .../testing/selftests/kvm/x86/userspace_io_test.c  |   2 +-
 .../testing/selftests/kvm/x86/vmx_dirty_log_test.c |  12 +-
 .../selftests/kvm/x86/vmx_nested_la57_state_test.c | 132 +++++++++++++++++++++
 24 files changed, 479 insertions(+), 164 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => nested_close_kvm_test.c} (64%)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
 rename tools/testing/selftests/kvm/x86/{vmx_tsc_adjust_test.c => nested_tsc_adjust_test.c} (61%)
 rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c => nested_tsc_scaling_test.c} (83%)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c

