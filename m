Return-Path: <kvm+bounces-64096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A69BC78AFD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 5CE9E2D6F8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 11:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D5C346A1D;
	Fri, 21 Nov 2025 11:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BCmnvvct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D632D8DC4
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 11:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763723486; cv=none; b=cW1Ov0JUAGB4us1S0mkrjBN8zFuE7PAnvp1Fi6IePkge9PVs+O5QPmSAFNkPZWmOOno9qsw8w8QkV4iKT4GD0pGYIimMTnW3L0LZIQwcpjWEeBGDFYj+KTGRD4fi+Y6AxY7E/OFjya6zV+QfkXlJgnW1Z/bQ3NFTSjXhjZ4/8EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763723486; c=relaxed/simple;
	bh=ea5lE3z+X38KwIeBD+4HkrPwqhtLVx6KnsZqPdtzMDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TdkSuaMdXzZwjwY9ZA0UerH+bek0UGEw4Lq9DN44zJVLMNE2P1g0RlidEur0dEKx89UwzeQjn7V4drXLV63g0SjzbkLdBwxqNIZnqqYLFJbA8aVJJBn3ttkuLjPfFG7MesKJkI4GckDFjJc7D3YJet4JBRoXKBqPoMg0Lci8OaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BCmnvvct; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4777771ed1aso12789805e9.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 03:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763723482; x=1764328282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CrSvNsjaC/3WVr/Zsh1+adlhBYeJfG+lNGfokhPzPQQ=;
        b=BCmnvvct/I24QUGtQv4P9RMY3/oPRC0XZoGBRdbhqhwpaP1KeUDVP0ZzqSnfJR6Adv
         JQmUoGVXohGbpIA4uYjxYx3vU267O98Hs6zRACUSmFCB0/dSoYGfmcVIK7BTjqfI7UNF
         Kf+qaKe/+0QYbF8ppf9uZsiM0VLHcIYJmfIvCCIX/rdK4XmL2uUW4Lst9/RFt6ILN4+v
         ldPgjNpa2QT5jFi03sAS7lYLkrXjADYTKEFgtkA89G9QyUkYgYKxixbN7kMtPdyMeNiC
         //QbKOrSqXeTx2jenqQf5pjgCHglIZ/QF6OVHSgujGqVl99K1Ab9NUlQfYXNn2wTFiv0
         E8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763723482; x=1764328282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CrSvNsjaC/3WVr/Zsh1+adlhBYeJfG+lNGfokhPzPQQ=;
        b=WItnfyojZfJNvixrUmooJUn5vjJQJ3/6ZmwgDX/m50PC69P8AAXx86AT0hVIc0a23u
         EIBBiCmm1zNXaEyxyhZBCwOkP6NYdJAsiF1NW2m03TLZNVFsmQbxkDJFvzZdSQ9TEjqT
         kezgrBrtgUCCuJudDYiiYbFtVGScBfvI+u+2Yl66DnHx63d7Kg7WoMPaMJH1cANizP4C
         Y086vUCEC/FtUoKCP0pk3HPffVop7kE71i/X5AMW7hYeHJW/78RWNahT6XtxntBs4hhX
         Ck+4uvLDaQu0z8SCFJpPU6ZWRB8iO/Z8cF6YnlllG7uvrlU/HbL6EIiHIG+da8bil4Zf
         ZZ6g==
X-Gm-Message-State: AOJu0Yw2lm7JVwyLbINS5rsPF5M52r0hwZ+GMBAELixv5KZEoZ+VxzrG
	J/pzcAulfrzwGqIGhj5gtX6xyKoBQuRWWXYWffHbxomdno9Pjz/qBVVzw2jkFgm4yOeI9Q==
X-Gm-Gg: ASbGncvw+iTgn1uUioSJiPRSydzX5oigerdYQJ1UGokE9ynIEb9nsoKWJ6Ai6tYAnWf
	ncW96FCWQPtPPj0krDY4jnGtTA82GmvEuX48LJPYJUzwnr26IbkK6Np8vgyBTrzZ6851naRmyHO
	5l6n70aNeBDQtThLj8eE2ksOwN7BM9mHnuk0Hkl/zbQ03ddu4nDpnWVN8ufWPc5qG+q5DdNLMWd
	zC5iK9aap7QGNlHrVdeCChtSQqSYhmYmnqtJlgbFFM3gjfW1cwdpjP2p9iLajZV2AaNRl2Fhquf
	ws0s/DJRRnnDGUr3Iv2nAWMKxrKlDF5dspnheC0D1CzeqUZyS8EhOGG1Vy+mbxKAhNQnMOWjhpj
	HWsQkKrr5BtPkaDi9UjSt/RV8RDhAZwt2nhkVrrcFT7S0C/ej0HMMuvxMhi8B+UdFaG6b80gxZ3
	oxbB8gb0uscN50WKppFa3ljSDEY0YSeZ+P2uqJyUoD4I0ceC0rbD4ituq40PvM+ny5wZEy6UEg9
	N9pL9q9F83TgU1VYB0nuZMQBEFu3s3n
X-Google-Smtp-Source: AGHT+IEC7hOvqyYPygsb1D7Hq8HrYWfmnLLe9fQ2FxMgvDY1wOad9Qi6jbWaCOYLWB5h194p4b4Gyw==
X-Received: by 2002:a05:600c:468c:b0:477:79f8:daa8 with SMTP id 5b1f17b1804b1-477c01b219amr19202265e9.17.1763723481939;
        Fri, 21 Nov 2025 03:11:21 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f363e4sm10484180f8f.12.2025.11.21.03.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 03:11:21 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v3 00/10] KVM: nVMX: Improve performance for unmanaged guest memory
Date: Fri, 21 Nov 2025 11:11:03 +0000
Message-ID: <20251121111113.456628-1-griffoul@gmail.com>
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
unmanaged guest memory (this is a synthetic benchmark run on
AWS EC2 Nitro instances, and the results are not representative of
typical nested virtualization workloads):

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

v3:
  - fixed warnings reported by kernel test robot in patches 7 and 8.

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
 arch/x86/kvm/vmx/nested.c                     | 469 ++++++++++++++----
 arch/x86/kvm/vmx/vmx.c                        |   8 +
 arch/x86/kvm/vmx/vmx.h                        |  16 +-
 arch/x86/kvm/x86.c                            |  19 +-
 include/linux/kvm_host.h                      |  34 +-
 include/linux/kvm_types.h                     |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../selftests/kvm/x86/vmx_apic_update_test.c  | 302 +++++++++++
 .../selftests/kvm/x86/vmx_l2_switch_test.c    | 416 ++++++++++++++++
 virt/kvm/kvm_main.c                           |   3 +-
 virt/kvm/kvm_mm.h                             |   6 +-
 virt/kvm/pfncache.c                           |  43 +-
 18 files changed, 1469 insertions(+), 123 deletions(-)
 create mode 100644 arch/x86/kvm/nested.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_update_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_l2_switch_test.c


base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
prerequisite-patch-id: afd3db49735b65c8a642de8dab7d0160d5da4b67
--
2.43.0


