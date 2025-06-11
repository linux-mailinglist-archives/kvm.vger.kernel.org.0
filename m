Return-Path: <kvm+bounces-49111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B46AD60EE
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 253113AA345
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81916242D6C;
	Wed, 11 Jun 2025 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYGZKaX5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408E9221294
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676617; cv=none; b=oUgI5OCNWWFfVPL5rXP7ccAxaua6Y1ek0VDY35bRQkgvmCM5iFMGY4XptJABYmUpq76lOPh6YRZN+C5sQjl16H99gWL6N0aw+C7/Hu9qxnhyV4mDnnArk7KXBcKrnz9kYyzHJqr3Uwe2Dk3jhPIBLqpmPGM0IvY631M1I2IfF7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676617; c=relaxed/simple;
	bh=NECYWsPH7RKAtQbRL0XnwHUNxi8qMBhhQIcgYAF72FU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AqefCtaYxc1nf0F2E5VbUIisRhwHxmdCoM5SRgMkH8tDcaao/C5LpC6MKw9dZKu99UwN7MdOttuThJQA8rCv/vbe8ELn7WC3Q/BkOrW8cz/XHStoKtEnAbyQNlbWO9s4bRtVLcoBlrgPjs8Oj/dy3gXh1PzoNmgimiR7+DUDV0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYGZKaX5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31171a736b2so354714a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749676615; x=1750281415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LOsJ8fO8l9KNsBrYZMTXVSP3wn3/FZjJX+dB1opvLg8=;
        b=jYGZKaX5LNUxWcMqgpTV2NUUw6oUIKcSxTfToAFaivjmEn8d7CqwqEVOwVR/R/rhn1
         K4O+xQB+eY7biq1mo2zqTQjrh2Ww5R7Qp02ZR5bNwIv1aiJSegQYQFr+O9aUZqoY30QH
         PIb1glceS0V9B9lFOsQOH/5V6dq3EyjhmKJ3SVDhHCL6Aa3NC9zdzKBwPCJpjQTedVBo
         ZbTASs9ovX0+7C9PGI8Ki7xkYDxsX78bactpJCM05alqcsAaDmi+yo/aCRZc8AZg8MRm
         2jqMJA7FO0f3xcs432+eMtmQJbhzRCV/+lGhNgNDLXmeXjB8dbmF3RQoqrjG/lEGXGHO
         8sOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749676615; x=1750281415;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LOsJ8fO8l9KNsBrYZMTXVSP3wn3/FZjJX+dB1opvLg8=;
        b=E90js8uGOv9Wc8AftWsWR//oqOW9yJdrpOPyiQNTpfApUVx2s0SjaX1eo760yISKQy
         jfBBEX1jl4LAMIlsFe4keK88vg5kh4pI6cIXM0VYTtmeNl7CGUBybWGn7ozwOUKhy/Mz
         e/s1d7lL78eKpSMB5qxMF3tVAOz8o8hHizkR+F9UwqxdcXWY8nJS+cBLQbMT21gkItkS
         40KH3F6ZAGFKrVhk+1F3evtgHXlGgK6T3QHpl6ieKXp6+CR930PdIqSWobjRIVlFMl5V
         FrDQO9+Bxl1zQ9yZ2BsOiNf8+jhyZ/wHGF3h0DiyM/v3BFijRqjnsLPNM2LlWQw0U45B
         EI9Q==
X-Gm-Message-State: AOJu0Yw1xxQNT2s37pATzVN145UZp+gfZihO/zz1lvn3XvX5AOShc3Ef
	Cv2OFzxcQ3v/ZQf8tpQDg6aoV7mT86xkb+/DxoMuV/u3ZX7QxKxfvy49gT31eIMNqYnFxtrmFVI
	bERXn4ZU9D7ezZm29R6n5Sq3OyhcEgxMphtKZ1sSibrlBPKx4HHO4O2WoMABJpJco4Ga3FY+veD
	v74khnYK24t+Zz/YdXjoTZad7hGB9Mqnn47NXPJw==
X-Google-Smtp-Source: AGHT+IF6qbV42OSMgEB/L2JOEi7E6FqjbgD2fsncm8r6Nqy7IPKImoaTuEIAXwkZoxK9ENk1RCq0tlxAz2mg
X-Received: from pjh5.prod.google.com ([2002:a17:90b:3f85:b0:311:485b:d057])
 (user=afranji job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b8b:b0:311:e9ac:f5ce
 with SMTP id 98e67ed59e1d1-313c08bbb9dmr724334a91.21.1749676615444; Wed, 11
 Jun 2025 14:16:55 -0700 (PDT)
Date: Wed, 11 Jun 2025 21:16:27 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <cover.1749672978.git.afranji@google.com>
Subject: [RFC PATCH v2 00/10] Add TDX intra-host migration support
From: Ryan Afranji <afranji@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: sagis@google.com, bp@alien8.de, chao.p.peng@linux.intel.com, 
	dave.hansen@linux.intel.com, dmatlack@google.com, erdemaktas@google.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, 
	zhi.wang.linux@gmail.com, ackerleytng@google.com, andrew.jones@linux.dev, 
	david@redhat.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, 
	linux-kselftest@vger.kernel.org, tabba@google.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, rick.p.edgecombe@intel.com, 
	Ryan Afranji <afranji@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This is RFC v2 for the TDX intra-host migration patch series. It
addresses comments in RFC v1 [1] and is rebased onto the latest kvm/next
(v6.16-rc1).

This patchset was built on top of the latest TDX selftests [2] and gmem
linking [3] RFC patch series.

Here is the series stitched together for your convenience:
https://github.com/googleprodkernel/linux-cc/tree/tdx-copyless-rfc-v2

Changes from RFC v1:
+ Added patch to prevent deadlock warnings by re-ordering locking order.
+ Added patch to allow vCPUs to be created for uninitialized VMs.
+ Minor optimizations to TDX intra-host migration core logic.
+ Moved lapic state transfer into TDX intra-host migration core logic.
+ Added logic to handle posted interrupts that are injected during
migration.
+ Added selftests.
+ Addressed comments from RFC v1.
+ Various small changes to make patchset compatible with latest version
of kvm/next.

[1] https://lore.kernel.org/lkml/20230407201921.2703758-2-sagis@google.com
[2] https://lore.kernel.org/lkml/20250414214801.2693294-2-sagis@google.com
[3] https://lore.kernel.org/all/cover.1747368092.git.afranji@google.com

Ackerley Tng (2):
  KVM: selftests: Add TDX support for ucalls
  KVM: selftests: Add irqfd/interrupts test for TDX with migration

Ryan Afranji (3):
  KVM: x86: Adjust locking order in move_enc_context_from
  KVM: TDX: Allow vCPUs to be created for migration
  KVM: selftests: Refactor userspace_mem_region creation out of
    vm_mem_add

Sagi Shahar (5):
  KVM: Split tdp_mmu_pages to mirror and direct counters
  KVM: TDX: Add base implementation for tdx_vm_move_enc_context_from
  KVM: TDX: Implement moving mirror pages between 2 TDs
  KVM: TDX: Add core logic for TDX intra-host migration
  KVM: selftests: TDX: Add tests for TDX in-place migration

 arch/x86/include/asm/kvm_host.h               |   7 +-
 arch/x86/kvm/mmu.h                            |   2 +
 arch/x86/kvm/mmu/mmu.c                        |  66 ++++
 arch/x86/kvm/mmu/tdp_mmu.c                    |  72 +++-
 arch/x86/kvm/mmu/tdp_mmu.h                    |   6 +
 arch/x86/kvm/svm/sev.c                        |  13 +-
 arch/x86/kvm/vmx/main.c                       |  12 +-
 arch/x86/kvm/vmx/tdx.c                        | 236 +++++++++++-
 arch/x86/kvm/vmx/x86_ops.h                    |   1 +
 arch/x86/kvm/x86.c                            |  14 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../testing/selftests/kvm/include/kvm_util.h  |  25 ++
 .../selftests/kvm/include/x86/tdx/tdx_util.h  |   3 +
 .../selftests/kvm/include/x86/tdx/test_util.h |   5 +
 .../testing/selftests/kvm/include/x86/ucall.h |   4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 222 ++++++++----
 .../testing/selftests/kvm/lib/ucall_common.c  |   2 +-
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      |  63 +++-
 .../selftests/kvm/lib/x86/tdx/test_util.c     |  17 +
 tools/testing/selftests/kvm/lib/x86/ucall.c   | 108 ++++--
 .../kvm/x86/tdx_irqfd_migrate_test.c          | 264 ++++++++++++++
 .../selftests/kvm/x86/tdx_migrate_tests.c     | 337 ++++++++++++++++++
 22 files changed, 1349 insertions(+), 132 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/tdx_irqfd_migrate_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/tdx_migrate_tests.c

-- 
2.50.0.rc1.591.g9c95f17f64-goog


