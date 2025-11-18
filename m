Return-Path: <kvm+bounces-63560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F289AC6AE5B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 52C114ED513
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF0B3A79BA;
	Tue, 18 Nov 2025 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gzMe8S1e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340DC3A5E99
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485883; cv=none; b=aRts4X1zU+e2ja4B97PkwQ2yUT/VJ4C9WLKtcEYbyxeRtXfvXd0X33Y+icfjFpUP8TBZc+6UW2BH3cgtlc3b+UIXmteBz2FFqyzw7FTGTX5HzIygLceDYMgXDjJIpOJru73OHkCDbw5jStFuhBBd82Tz4IflXfmsUgbgHN82y8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485883; c=relaxed/simple;
	bh=sGFjzNSUP3iKmiMpSYgzBv7rK8Cov3HbhYOyp14idfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yat2pfOjEZ35KgO3ptfSljcaDOi918ta6yMPHQ09v1+4MBT49PgquubRDEzjOzr7hN4FipIBvddlgrv0igwpgN7g/ZXnWQu2PcVXDvzTe/ROOD74AAl6BukvKo8qn+WeqKx3bhLSrZxeVDkTPYwfh4FxcgsiaefWSDzsqk3d478=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gzMe8S1e; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4775638d819so33505385e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485878; x=1764090678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TBe9IiuweoW+3W7c6RGD7+9IjhQceFzz7qTeC4zbtq4=;
        b=gzMe8S1e0EPP2+9p51FkD/e1HbUoZ5e3t1ZxHXKciNd3oHDUKNdebpQOIy3xR2Vlfm
         7RFcWkDGBlQNQb04ZEj0uNBeYJ/9BqTCVIDWz8SGxJa7EiAMUXqtjM9ncOln7upk4Ngr
         necciN2hZRVHQRUWr2rgsySs2mEuVIfoGZbxiygipbM4bCW1znVEQ2b4M2B/ApRdnPyk
         KcT42+LPYRQNN96ycTFBbJdb9G6Wy8/KlsW0O46BmyICvgLZGhl4Zz9sHm9iODVLnCbi
         h5TC7RMiSAbxlyhC48n7IIKN1IyLHQ56X+RDRmJg4dQovXbJBVyVtzvHKampc33thKCs
         FIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485878; x=1764090678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBe9IiuweoW+3W7c6RGD7+9IjhQceFzz7qTeC4zbtq4=;
        b=oQLj+kRVoShVDJ6ggh20MrH4MLKIxeVMknlKDpNW3Bqii6tuDd3XjL/w+1oE6QaYlS
         4f7eFbijfa5RhUEL6ceEny6UZ3S/L/adDr6jpl5oJ2uPd8C03OXCkXs7x+ymn3WtXt2H
         QMwmJbWbOefJxweBZJqlo+6XXlNCJJk92T6Mnn4L7Vm00CB41ntPjnj/ajjQ8b8Ujq4a
         7eqKlbv6tN51YdrN7sUWDwLx1I7jBQRmnS12yXXK5WFjxJcVzrzIBwogPlxCQhUyQFdG
         ruN1pYSE11eQnJviSHSTYxjTLxvUr3h++N8NP61hU822IEWD/HzgQ25PJygxBVTNt4//
         mFZQ==
X-Gm-Message-State: AOJu0YxMPpyZMPEG3bmi7tr2WeqFN1lScm8jA/nW1rZaH81e+z1v4VHS
	8D+tmvSdwc00WyEZQPBIn3vsyNcs1TO5Y1vkvB+fwfVGHw0hcPlYq5Q3RUkBFnaPpAeqqA==
X-Gm-Gg: ASbGncuD+g2ixtq32zzLeTpEUUbs5m6NqshP3m/AhKz+R5i8QcXeh5RxSBfw1nCz9pd
	nEx4ESoLtc/4SgAI/e2a/ewDr5uupOaxFXicp60j9iujL6Mtqdd7SSRUwX6mYW/O+RvmreE7eCc
	P21QdGnuxSowdHfCgSKKRkZBg6KiCzMGB8thJtCbFjeAHHl8Ff13MDo5Qg+1xle8Q/2m0qFeUiw
	TrlqDR9ukWalnTfTpPuhoK2wUQEreUp+EdcdI6IXTvEtlwE8OJyCnMoKqSXhfYA9W/ma6azBswl
	v98C3CHfdsst97ybGK+zyFWU1OpwL9MEpFt4KeCe4cbdtCs0YIMg/sz78Mu/ENasuk5T1mONb/i
	BHfkjJPx3S1ZnvQZWr+vjZYEmLVppxiJZPluvzQd3JjjioChEs1QY3wTz3gxbjGG03v0BqQXEQB
	IV3+o27o0qUmoKbLa2VaaZnOYT6jZqSnfkEbjlSZJYdQme8oRbyMjS3koQvWFMMkzpLye5Eles+
	2xTDVqNSurah0X+Rzx79nUAPUHxRSYX
X-Google-Smtp-Source: AGHT+IHAVcd0D2l8vGUA9g49D1aKsIZ/sD6QLBYmCPWxLP3aBw/DLAQPHYPULLtdRj037Az96qsRzg==
X-Received: by 2002:a05:600c:1d19:b0:46e:5100:326e with SMTP id 5b1f17b1804b1-4778fea835dmr152713665e9.23.1763485878063;
        Tue, 18 Nov 2025 09:11:18 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:17 -0800 (PST)
From: griffoul@gmail.com
X-Google-Original-From: griffoul@gmail.org
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v2 00/10] KVM: nVMX: Improve performance for unmanaged guest memory
Date: Tue, 18 Nov 2025 17:11:03 +0000
Message-ID: <20251118171113.363528-1-griffoul@gmail.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

This patch series addresses both performance and correctness issues in
nested VMX when handling guest memory.

During nested VMX operations, L0 (KVM) accesses specific L1 guest pages
to manage L2 execution. These pages fall into two categories: pages
accessed only by L0 (such as the L1 MSR bitmap page or the eVMCS page),
and pages passed to the L2 guest via vmcs02 (such as APIC access,
virtual APIC, and posted interrupt descriptor pages).

The current implementation uses kvm_vcpu_map/unmap, which causes two
issues.

First, the current approach is missing proper invalidation handling in
critical scenarios. Enlightened VMCS (eVMCS) pages can become stale when
memslots are modified, as there is no mechanism to invalidate the cached
mappings. Similarly, APIC access and virtual APIC pages can be migrated
by the host, but without proper notification through mmu_notifier
callbacks, the mappings become invalid and can lead to incorrect
behavior.

Second, for unmanaged guest memory (memory not directly mapped by the
kernel, such as memory passed with the mem= parameter or guest_memfd for
non-CoCo VMs), this workflow invokes expensive memremap/memunmap
operations on every L2 VM entry/exit cycle. This creates significant
overhead that impacts nested virtualization performance.

This series replaces kvm_host_map with gfn_to_pfn_cache in nested VMX.
The pfncache infrastructure maintains persistent mappings as long as the
page GPA does not change, eliminating the memremap/memunmap overhead on
every VM entry/exit cycle. Additionally, pfncache provides proper
invalidation handling via mmu_notifier callbacks and memslots generation
check, ensuring that mappings are correctly updated during both memslot
updates and page migration events.

As an example, a microbenchmark using memslot_perf_test with 8192
memslots demonstrates huge improvements in nested VMX operations with
unmanaged guest memory:

                        Before          After           Improvement
  map:                  26.12s          1.54s           ~17x faster
  unmap:                40.00s          0.017s          ~2353x faster
  unmap chunked:        10.07s          0.005s          ~2014x faster

The series is organized as follows:

Patches 1-5 handle the L1 MSR bitmap page and system pages (APIC access,
virtual APIC, and posted interrupt descriptor). Patch 1 converts the MSR
bitmap to use gfn_to_pfn_cache. Patches 2-3 restore and complete
"guest-uses-pfn" support in pfncache. Patch 4 converts the system pages
to use gfn_to_pfn_cache. Patch 5 adds a selftest for cache invalidation
and memslot updates.

Patches 6-7 add enlightened VMCS support. Patch 6 avoids accessing eVMCS
fields after they are copied into the cached vmcs12 structure. Patch 7
converts eVMCS page mapping to use gfn_to_pfn_cache.

Patches 8-10 implement persistent nested context to handle L2 vCPU
multiplexing and migration between L1 vCPUs. Patch 8 introduces the
nested context management infrastructure. Patch 9 integrates pfncache
with persistent nested context. Patch 10 adds a selftest for this L2
vCPU context switching.

v2:
  - Extended series to support enlightened VMCS (eVMCS).
  - Added persistent nested context for improved L2 vCPU handling.
  - Added additional selftests.

Suggested-by: dwmw@amazon.co.uk


Fred Griffoul (10):
  KVM: nVMX: Implement cache for L1 MSR bitmap
  KVM: pfncache: Restore guest-uses-pfn support
  KVM: x86: Add nested state validation for pfncache support
  KVM: nVMX: Implement cache for L1 APIC pages
  KVM: selftests: Add nested VMX APIC cache invalidation test
  KVM: nVMX: Cache evmcs fields to ensure consistency during VM-entry
  KVM: nVMX: Replace evmcs kvm_host_map with pfncache
  KVM: x86: Add nested context management
  KVM: nVMX: Use nested context for pfncache persistence
  KVM: selftests: Add L2 vcpu context switch test

 arch/x86/include/asm/kvm_host.h               |  32 ++
 arch/x86/include/uapi/asm/kvm.h               |   2 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/nested.c                         | 199 ++++++++
 arch/x86/kvm/vmx/hyperv.c                     |   5 +-
 arch/x86/kvm/vmx/hyperv.h                     |  33 +-
 arch/x86/kvm/vmx/nested.c                     | 463 ++++++++++++++----
 arch/x86/kvm/vmx/vmx.c                        |   8 +
 arch/x86/kvm/vmx/vmx.h                        |  16 +-
 arch/x86/kvm/x86.c                            |  19 +-
 include/linux/kvm_host.h                      |  34 +-
 include/linux/kvm_types.h                     |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../selftests/kvm/x86/vmx_apic_update_test.c  | 302 ++++++++++++
 .../selftests/kvm/x86/vmx_l2_switch_test.c    | 416 ++++++++++++++++
 virt/kvm/kvm_main.c                           |   3 +-
 virt/kvm/kvm_mm.h                             |   6 +-
 virt/kvm/pfncache.c                           |  43 +-
 18 files changed, 1467 insertions(+), 119 deletions(-)
 create mode 100644 arch/x86/kvm/nested.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_update_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_l2_switch_test.c

--
2.43.0


