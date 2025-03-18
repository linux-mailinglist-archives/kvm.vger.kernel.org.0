Return-Path: <kvm+bounces-41425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E997FA67B91
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E690B3A6B06
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACAEB213E79;
	Tue, 18 Mar 2025 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mf1SzFW3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275FC212D66
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320996; cv=none; b=K7sHF2ncbqQRTWr8Z+41LRIciuCXVYft55kaubmWCOv/xZr5nVaHV7LYocPgkBt3eVXNZfAz7zfeX2aKei3yD4pwM/5FYRrD/AXusG21S516zEnFUxYbwChIaSXxxY0WRcXjbWzbo+EuTgmm41NxDWUhAnloYHOM11fz9kszqiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320996; c=relaxed/simple;
	bh=UEZ0ztEUB+LxJ0UwDmSI/Udync8+AbF2c47ImLXJgt4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p4GX6yGXN8Sj+4Cy1wqGEcUw8XRKLOrVYuGiWWVeJxNJbWe8C6joxxhEvA5Wf7GMjsPosPoTIMF+l5WcjMnzpjKnS8QhK3wvJ4A7dLsOFk+6FXdOSLoUrTkFGBWEA8w+KU9UoaRxwMd91HHZ1lY9sMPEJx9JvAQdl5aTSLLVsVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mf1SzFW3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-224364f2492so92600485ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742320994; x=1742925794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KEyP1LOrk3ivrX2K+h6VXZSJpoDzKzqBoFjkCI1tbG4=;
        b=Mf1SzFW3UXl4IZZY1GHESkHo0ghHpUuCPZDDY8482Ii4i7RG7iTB5RlA22ON4eLRNB
         hHOThjDAH6FtdcZXD7mPJdSvTB04yslY6bRM5VgaV+mah2rsOOTUcCR3y8xKwOLexB2T
         TgNKeQeaq4TxY13gk5O8ImYIgFX6AZMTMzMegggr3EQrZLb3dhHLZvweefpvsAY37g7J
         UD+0CCXbdm/dVshmCvB3/LsRyk9X/lZoJ2Jp7M3CEHv7Z99K5nciUWsUaUa/4zJR7dUN
         SSWwD+A0uG8i2KKqNjRl4ukNQAL4zJx/3fHmhPvrY4s2FIMXrVsG0v2ZJQw8+wkYQ/GZ
         bw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320994; x=1742925794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KEyP1LOrk3ivrX2K+h6VXZSJpoDzKzqBoFjkCI1tbG4=;
        b=DZuhEqgipLxXB/0/qzktPpLwk5+7wxS5PHp28x8eELAPXqiM/b4IEWMZ10YQ5nQuXW
         CCcb9MxeB3OLnO5+tNjtG2dsD7cX8XnM5GkGEpav6KvQMr8r8wJhi6Y9iADi9hSB0zCk
         Z1WoB73moIoNrduOl7LYi2lH5RLsdLzrkuOH6qBE95YIT8l78ZbUnkPRzuptTSxV2rad
         mfWBogJ1fswQGLSKLKadv6iZt04QbNEczLflZlEiV/jBq2ILXbXXMHdd1qfKj2O0JUZm
         kXeB3AbHki9BtfAq8L39UXj3XMBAeaJGUx9Bp2piYI3qkwoGw4YAwwxgNoKJ08Q24qFr
         KteA==
X-Gm-Message-State: AOJu0YyBfeesSwVCFRTuua2g5dy6ILc1aldvRNYR+SknQeX5mmkdkaGt
	MLSGUruobsjSw5TExC4P6+ExezJYp8wM6JxhB0aFxMNIC7ThgfiTuBW5z4bpOmsGEGUCqVXD0ii
	cWQ==
X-Google-Smtp-Source: AGHT+IGsVYnsWSeyUIF3BRzWcbGtpN1OvknxIEHRgwDafozo1ifTgLT0e20SWQIY5ucyx7yoCwEdDWlCG5k=
X-Received: from pfbcb11.prod.google.com ([2002:a05:6a00:430b:b0:730:96d1:c213])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4fca:b0:736:a682:deb8
 with SMTP id d2e1a72fcca58-7376c11de11mr150667b3a.8.1742320994339; Tue, 18
 Mar 2025 11:03:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:02:59 -0700
In-Reply-To: <20250318180303.283401-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-5-seanjc@google.com>
Subject: [GIT PULL] KVM: Selftests changes for 6.15, part 2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Second selftests pull requests, i.e. the "real" 6.15 selftest pull request :-)

The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.15

for you to fetch changes up to 62838fa5eade1b23d546e81e7aab6d4c92ec12f2:

  KVM: selftests: Relax assertion on HLT exits if CPU supports Idle HLT (2025-02-28 15:42:28 -0800)

----------------------------------------------------------------
KVM selftests changes for 6.15, part 2

 - Fix a variety of flaws, bugs, and false failures/passes dirty_log_test, and
   improve its coverage by collecting all dirty entries on each iteration.

 - Fix a few minor bugs related to handling of stats FDs.

 - Add infrastructure to make vCPU and VM stats FDs available to tests by
   default (open the FDs during VM/vCPU creation).

 - Relax an assertion on the number of HLT exits in the xAPIC IPI test when
   running on a CPU that supports AMD's Idle HLT (which elides interception of
   HLT if a virtual IRQ is pending and unmasked).

 - Misc cleanups and fixes.

----------------------------------------------------------------
Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "UFFDIO_CONINUE" -> "UFFDIO_CONTINUE"

Maxim Levitsky (2):
      KVM: selftests: Support multiple write retires in dirty_log_test
      KVM: selftests: Limit dirty_log_test's s390x workaround to s390x

Sean Christopherson (28):
      KVM: selftests: Actually emit forced emulation prefix for kvm_asm_safe_fep()
      KVM: selftests: Sync dirty_log_test iteration to guest *before* resuming
      KVM: selftests: Drop signal/kick from dirty ring testcase
      KVM: selftests: Drop stale srandom() initialization from dirty_log_test
      KVM: selftests: Precisely track number of dirty/clear pages for each iteration
      KVM: selftests: Read per-page value into local var when verifying dirty_log_test
      KVM: selftests: Continuously reap dirty ring while vCPU is running
      KVM: selftests: Honor "stop" request in dirty ring test
      KVM: selftests: Keep dirty_log_test vCPU in guest until it needs to stop
      KVM: selftests: Post to sem_vcpu_stop if and only if vcpu_stop is true
      KVM: selftests: Use continue to handle all "pass" scenarios in dirty_log_test
      KVM: selftests: Print (previous) last_page on dirty page value mismatch
      KVM: selftests: Collect *all* dirty entries in each dirty_log_test iteration
      KVM: sefltests: Verify value of dirty_log_test last page isn't bogus
      KVM: selftests: Ensure guest writes min number of pages in dirty_log_test
      KVM: selftests: Tighten checks around prev iter's last dirty page in ring
      KVM: selftests: Set per-iteration variables at the start of each iteration
      KVM: selftests: Fix an off-by-one in the number of dirty_log_test iterations
      KVM: selftests: Allow running a single iteration of dirty_log_test
      KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
      KVM: selftests: Close VM's binary stats FD when releasing VM
      KVM: selftests: Assert that __vm_get_stat() actually finds a stat
      KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name string
      KVM: selftests: Add struct and helpers to wrap binary stats cache
      KVM: selftests: Get VM's binary stats FD when opening VM
      KVM: selftests: Adjust number of files rlimit for all "standard" VMs
      KVM: selftests: Add infrastructure for getting vCPU binary stats
      KVM: selftests: Relax assertion on HLT exits if CPU supports Idle HLT

 tools/testing/selftests/kvm/dirty_log_test.c       | 521 ++++++++++-----------
 tools/testing/selftests/kvm/include/kvm_util.h     |  33 +-
 .../testing/selftests/kvm/include/x86/processor.h  |   3 +-
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c |  28 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 114 +++--
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |   2 +-
 .../kvm/x86/dirty_log_page_splitting_test.c        |   6 +-
 .../testing/selftests/kvm/x86/nx_huge_pages_test.c |   4 +-
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c   |  13 +
 9 files changed, 369 insertions(+), 355 deletions(-)

