Return-Path: <kvm+bounces-70540-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJPdN267hmkNQgQAu9opvQ
	(envelope-from <kvm+bounces-70540-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A3C104D69
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E8F79305DD76
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0292D5940;
	Sat,  7 Feb 2026 04:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XYrSEE+u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1312D6E4B
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437425; cv=none; b=djL49O73dNZPsoEoZ9W2r41FraCuu0Ki1DHJ1YlYYjwjGT68NKI5lfj7ZmBOLPQB51YqYokW2oN5emNmWWxBAhaxjq/476bxHvnTdHVJFnU/s9HuY7gacy0RC1nI0OjkfQHJcip+ZSH0bQWv1aMkYmtRi+/6rc6e/8gdnJ7VtCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437425; c=relaxed/simple;
	bh=9OmAfnE4eUMoRkUxKRnBZUB/qSuUSRbdNjMQwZTz6ck=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N19ftuNR8cP18kWbjLHX2JY+dtaAdpPIahIP23awrLoroTuYLVQ1XTfPStNmX13NV7KAdfNsj0v4YRWcph2vIRWvPRDjk01ZrCtDAKHaEIPXbJOc2gVkGoBXxcOci3KFH0p/6mcmkv6DH3nRbWS4SxPjJN4Ho4SF6QN2wvBj67E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XYrSEE+u; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso2860811a91.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437425; x=1771042225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8AS24BZ4VDb34aNWsAUubs8q2mDEncmFFvAa9gbeLyE=;
        b=XYrSEE+uQfJunTDctIVH9N1Nr9SoP7ji52O3XeOjpqZonyTWcXM/GPgcu61qMae9YW
         8MTyjElj2+d8wqCs65jIeLaUkyNPBleBtl+WAg9wn+f1RHpkB9FiBrS+ifCW7RwzRlGv
         m7rak0R3ECr3W0ACcxcEpxldsa7oI1wbkDfvrM7UhUhf0vAll3iEaGft4TWnG6O8CXxx
         Dwz6cfjGM1xzzwcnj625jvfnvSoGc51B1cJIu/4Z2dhIEPjC0J1EfQemghLMfW05KETx
         bgqJLYJxqVP0j6SF8IaM2p06BR0Uyb58wNwkddFVO2R23j7Hj8CO35hnnHK4sZaWTEby
         wKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437425; x=1771042225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8AS24BZ4VDb34aNWsAUubs8q2mDEncmFFvAa9gbeLyE=;
        b=mdr0klvYbA7xZVz4DGF+YuZyKFKkCH7B7Rt1yAUaQBuAIllssoEdfwozyEme3u40Zk
         iLIeDwKn8uVqOT0788J9ZFVeSSDIaMr6XwBE2UgjHhwZY61JFenfPoqMgOepqmvNrOSz
         SbEqR42L/3w+T4dNesFPq/xQSI79MOmH3DCW24yAcmYzKdq+FmIhhMpu5pxJuAhdg2sJ
         kU3j+4HhgWTNZpJwyHi8aoJ4aaCQ86DcZC3RLPHp+1fI/tXHrryDSyxgnKRdqNfrGTsi
         8pjJzfJQlq3UpWdbOcSLi3o7upktckW15zwChXGS4AsWX0ueLBrc5oMQG3n/3wxZX2me
         2QJw==
X-Gm-Message-State: AOJu0YxooOkIUd2sBoiMYJtDiY13P48PR8uBvdOaPMHRCA15NpEXyVR7
	juQGQCjxg+SOhm/GK7R5LZFrewKlta2+ZUrrMX4f9nNG0MXeIKczqDADnWYw4+44MnbjHeZbKTi
	CxUrGag==
X-Received: from pjob10.prod.google.com ([2002:a17:90a:8c8a:b0:353:3177:9547])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5252:b0:354:999f:1b22
 with SMTP id 98e67ed59e1d1-354b3e5d179mr3833420a91.32.1770437424705; Fri, 06
 Feb 2026 20:10:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:08 -0800
In-Reply-To: <20260207041011.913471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-7-seanjc@google.com>
Subject: [GIT PULL] KVM: selftests changes for 6.20
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70540-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 61A3C104D69
X-Rspamd-Action: no action

Stub in stage-2 MMU support in the core infrastructure, and extend x86's MMU
infrastructure to support EPT and NPT.  As noted in the cover letter, this
conflicts with some RISC-V changes.

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.20

for you to fetch changes up to a91cc48246605af9aeef1edd32232976d74d9502:

  KVM: selftests: Test READ=>WRITE dirty logging behavior for shadow MMU (2026-01-16 07:48:54 -0800)

----------------------------------------------------------------
KVM selftests changes for 6.20

 - Add a regression test for TPR<=>CR8 synchronization and IRQ masking.

 - Overhaul selftest's MMU infrastructure to genericize stage-2 MMU support,
   and extend x86's infrastructure to support EPT and NPT (for L2 guests).

 - Extend several nested VMX tests to also cover nested SVM.

 - Add a selftest for nested VMLOAD/VMSAVE.

 - Rework the nested dirty log test, originally added as a regression test for
   PML where KVM logged L2 GPAs instead of L1 GPAs, to improve test coverage
   and to hopefully make the test easier to understand and maintain.

----------------------------------------------------------------
MJ Pooladkhay (1):
      KVM: selftests: Fix sign extension bug in get_desc64_base()

Maciej S. Szmigiero (1):
      KVM: selftests: Test TPR / CR8 sync and interrupt masking

Sean Christopherson (7):
      KVM: selftests: Add "struct kvm_mmu" to track a given MMU instance
      KVM: selftests: Plumb "struct kvm_mmu" into x86's MMU APIs
      KVM: selftests: Add a "struct kvm_mmu_arch arch" member to kvm_mmu
      KVM: selftests: Add a stage-2 MMU instance to kvm_vm
      KVM: selftests: Move TDP mapping functions outside of vmx.c
      KVM: selftests: Rename vm_get_page_table_entry() to vm_get_pte()
      KVM: selftests: Test READ=>WRITE dirty logging behavior for shadow MMU

Yosry Ahmed (16):
      KVM: selftests: Make __vm_get_page_table_entry() static
      KVM: selftests: Stop passing a memslot to nested_map_memslot()
      KVM: selftests: Rename nested TDP mapping functions
      KVM: selftests: Kill eptPageTablePointer
      KVM: selftests: Stop setting A/D bits when creating EPT PTEs
      KVM: selftests: Move PTE bitmasks to kvm_mmu
      KVM: selftests: Use a TDP MMU to share EPT page tables between vCPUs
      KVM: selftests: Stop passing VMX metadata to TDP mapping functions
      KVM: selftests: Reuse virt mapping functions for nested EPTs
      KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
      KVM: selftests: Add support for nested NPTs
      KVM: selftests: Set the user bit on nested NPT PTEs
      KVM: selftests: Extend vmx_dirty_log_test to cover SVM
      KVM: selftests: Extend memstress to run on nested SVM
      KVM: selftests: Slightly simplify memstress_setup_nested()
      KVM: selftests: Add a selftests for nested VMLOAD/VMSAVE

 tools/testing/selftests/kvm/Makefile.kvm           |   4 +-
 .../selftests/kvm/include/arm64/kvm_util_arch.h    |   2 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  18 +-
 .../kvm/include/loongarch/kvm_util_arch.h          |   1 +
 .../selftests/kvm/include/riscv/kvm_util_arch.h    |   1 +
 .../selftests/kvm/include/s390/kvm_util_arch.h     |   1 +
 tools/testing/selftests/kvm/include/x86/apic.h     |   3 +
 .../selftests/kvm/include/x86/kvm_util_arch.h      |  22 ++
 .../testing/selftests/kvm/include/x86/processor.h  |  65 +++--
 tools/testing/selftests/kvm/include/x86/svm_util.h |   9 +
 tools/testing/selftests/kvm/include/x86/vmx.h      |  16 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |  38 +--
 tools/testing/selftests/kvm/lib/kvm_util.c         |  28 +-
 .../selftests/kvm/lib/loongarch/processor.c        |  28 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  31 +--
 tools/testing/selftests/kvm/lib/s390/processor.c   |  16 +-
 tools/testing/selftests/kvm/lib/x86/memstress.c    |  65 +++--
 tools/testing/selftests/kvm/lib/x86/processor.c    | 237 +++++++++++++----
 tools/testing/selftests/kvm/lib/x86/svm.c          |  27 ++
 tools/testing/selftests/kvm/lib/x86/vmx.c          | 251 ++++--------------
 tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c |   2 +-
 .../selftests/kvm/x86/nested_dirty_log_test.c      | 293 +++++++++++++++++++++
 .../selftests/kvm/x86/nested_vmsave_vmload_test.c  | 197 ++++++++++++++
 .../kvm/x86/smaller_maxphyaddr_emulation_test.c    |   4 +-
 .../testing/selftests/kvm/x86/vmx_dirty_log_test.c | 179 -------------
 .../selftests/kvm/x86/vmx_nested_la57_state_test.c |   2 +-
 tools/testing/selftests/kvm/x86/xapic_tpr_test.c   | 276 +++++++++++++++++++
 27 files changed, 1244 insertions(+), 572 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/xapic_tpr_test.c

