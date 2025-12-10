Return-Path: <kvm+bounces-65662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2033CB38E9
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9FE1E300FA1E
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49714326D5D;
	Wed, 10 Dec 2025 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H3uQQhHS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE5125743D
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765386359; cv=none; b=mcQckvP8og5UMbgBSf3pY8yyOS0+eX5lOLrim/u+sQO7SdAnSHIf9q6+pmAGjU5wlLjOuq+yq5I+5k5v4d2f7sL6TDikcFF7ZZHqtPhmhgk2AHs8XXwoCfkxOoe7LD6zOWzISgLmHLjJMiA4GPDs6d08JQB95gfa50ZgMEUvhag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765386359; c=relaxed/simple;
	bh=vAAT6phali9DoymfQdxFQtlRPS0kjAH4hmsBNkNONAg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Bu+oCSMIIgpQEIG1PGokhOcwubO+F393b0qQ19rhmFeZYdeIzUH+uvcmJq12kUemyf5OAo8NpkRVHdqhnFZyiHoiApIcWokPMLIvho+uxjyy/dI5JBaPftQ3eTxip+WX/KxXfzYvpWS3KjXRAAjalm3X5fpa+mr6EKXZLbdnqQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H3uQQhHS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34943cc3221so86622a91.2
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 09:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765386357; x=1765991157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzybRIPF90F7ziogcfrarL3+wOBmsOMoOfKqvq/+vDo=;
        b=H3uQQhHSdcXX1sCS0mUn8Ze+ASYW/uUW7Xe4GsI6QgYAGZJ0iC6zgujpEy1zS326Wn
         aTJ6VPreWAXamDp+EaFtIwXyZmnRb89WiOuDCW84wETPxc523RjClZbbTWXR+jKKv5fo
         ojjgYafseB4uhE1FqQ1WwoZYtQIfhd9jBPL2MggeKit2aObT2f3UtAO8SOeqfEgVz/cn
         vn4559YoNCri8gFFJvOcBCikbFANhIb0f7fKo2y/XPsARTRC7+oeMc61EuPCs8Up+Pjk
         IZ9V9tYMl5hxILSPh8U59JqGVItsOl9aScrs0qEsVWOguV/ZRgghdUWI8Hl9LTrtx0c5
         17CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765386357; x=1765991157;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vzybRIPF90F7ziogcfrarL3+wOBmsOMoOfKqvq/+vDo=;
        b=khKMAkGIxI0P1HUV6qREnkWWjHJgAL0KTwxcKLZXwesFeHlvdKn0FTJ7YAZFZHjWVi
         C1UTv4swS44Om3ydBXkcH1K9X4dKomSXk5FF9yc7C4K+7UzMtyCx/EpAhIIW3RhK7/wb
         XT1M0uEJ4JmhEnaw65P6val5qNGQ23XiJ+BfeV/du4ZqhVHC60SsOsP4Li8jJbHF8E4C
         MNGRu2EQ6pzcg0C09gtfCL2fdaCSbn6umxKvrR4IG/zOFVyqMr+ON2L4lDTVInul4jQp
         apiMz9lelsfH+FPG/w1LuHPgwgO9K6gHdKXJavplRV4KxJSTIhq4lQ4RAYEB3h8+A191
         c7ww==
X-Gm-Message-State: AOJu0YzLGP37LKl0vR96ZYy4FV6DfX9r3VtqwR3Pp8bGIGfRdyD5cq/c
	ZsVvKiMnRS6LTe0PCZKH5W84D94gtSr90p9e9PgvkWn33dZ+5hD3kp4vKzn8BauHcYbeutz5uXr
	UiGUl9Q==
X-Google-Smtp-Source: AGHT+IFC8VlH/bUvrsWX+PGaQjX1i+3I3/TYLylgI1ShrOGQLBM6pyVAEA2I8MJRGRScpdnsG2QBe0eb0Fg=
X-Received: from pjbgp1.prod.google.com ([2002:a17:90a:df01:b0:33b:51fe:1a75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388a:b0:340:ec6f:5ad0
 with SMTP id 98e67ed59e1d1-34a728097dcmr2789630a91.1.1765386357153; Wed, 10
 Dec 2025 09:05:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Dec 2025 09:05:52 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251210170552.970155-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 and guest_memfd fixes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a variety of fixes for 6.19, all for pre-existing bugs.  Note,
the KVM_MEM_GUEST_MEMFD fix changes KVM's ABI, but I don't see any way that
userspace could successfully use the broken behavior, and the intent and
documentation was always that KVM_MEM_GUEST_MEMFD memslots would be immutable.

The following changes since commit 32bd348be3fa07b26c5ea6b818a161c142dcc2f2:

  KVM: Fix last_boosted_vcpu index assignment bug (2025-11-25 09:15:38 +0100)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.19-rc1

for you to fetch changes up to 29763138830916f46daaa50e83e7f4f907a3236b:

  KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit (2025-12-08 06:56:29 -0800)

----------------------------------------------------------------
KVM fixes for 6.19-rc1

 - Add a missing "break" to fix param parsing in the rseq selftest.

 - Apply runtime updates to the _current_ CPUID when userspace is setting
   CPUID, e.g. as part of vCPU hotplug, to fix a false positive and to avoid
   dropping the pending update.

 - Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot, as it's not
   supported by KVM and leads to a use-after-free due to KVM failing to unbind
   the memslot from the previously-associated guest_memfd instance.

 - Harden against similar KVM_MEM_GUEST_MEMFD goofs, and prepare for supporting
   flags-only changes on KVM_MEM_GUEST_MEMFD memlslots, e.g. for dirty logging.

 - Set exit_code[63:32] to -1 (all 0xffs) when synthesizing a nested
   SVM_EXIT_ERR (a.k.a. VMEXIT_INVALID) #VMEXIT, as VMEXIT_INVALID is defined
   as -1ull (a 64-bit value).

 - Update SVI when activating APICv to fix a bug where a post-activation EOI
   for an in-service IRQ would effective be lost due to SVI being stale.

 - Immediately refresh APICv controls (if necessary) on a nested VM-Exit
   instead of deferring the update via KVM_REQ_APICV_UPDATE, as the request is
   effectively ignored because KVM thinks the vCPU already has the correct
   APICv settings.

----------------------------------------------------------------
Dongli Zhang (2):
      KVM: VMX: Update SVI during runtime APICv activation
      KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit

Gavin Shan (1):
      KVM: selftests: Add missing "break" in rseq_test's param parsing

Sean Christopherson (6):
      KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPUID{,2}
      KVM: selftests: Add a CPUID testcase for KVM_SET_CPUID2 with runtime updates
      KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
      KVM: Harden and prepare for modifying existing guest_memfd memslots
      KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
      KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)

 arch/x86/kvm/cpuid.c                         | 11 +++++++++--
 arch/x86/kvm/svm/nested.c                    |  4 ++--
 arch/x86/kvm/svm/svm.c                       |  2 ++
 arch/x86/kvm/svm/svm.h                       |  7 ++++---
 arch/x86/kvm/vmx/nested.c                    |  3 ++-
 arch/x86/kvm/vmx/vmx.c                       |  9 ---------
 arch/x86/kvm/x86.c                           |  7 +++++++
 tools/testing/selftests/kvm/rseq_test.c      |  1 +
 tools/testing/selftests/kvm/x86/cpuid_test.c | 15 +++++++++++++++
 virt/kvm/kvm_main.c                          | 17 ++++++++++++++++-
 10 files changed, 58 insertions(+), 18 deletions(-)

