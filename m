Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAAF42D05
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731879AbfFLRI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:08:57 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:20806 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731461AbfFLRI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359334; x=1591895334;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fPeaXeipXyI0A+eKQSQDQfcK52xXXH3ZvhYN21vIRx0=;
  b=t9XR9SNungKP5c95j703FzqXPYVjCkiBDiNfjFVsxSIWNNN3aZbsPx3T
   6RziH13XMenVIFxASrnpdB0/meESsvap9U/vF9O4S2afY7zcIa+iLLxCM
   SnNea+/PaG0elQ2zKlThmxRJrZmFGdSrNsjOZVM5nMtyZaM5DxMGVV4f9
   s=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="679555407"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Jun 2019 17:08:52 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (iad7-ws-svc-lb50-vlan2.amazon.com [10.0.93.210])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 0BA54A2896;
        Wed, 12 Jun 2019 17:08:50 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CH8mwU016469;
        Wed, 12 Jun 2019 19:08:48 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CH8l1v016468;
        Wed, 12 Jun 2019 19:08:47 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
Date:   Wed, 12 Jun 2019 19:08:24 +0200
Message-Id: <20190612170834.14855-1-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Linux kernel has a global address space that is the same for any
kernel code. This address space becomes a liability in a world with
processor information leak vulnerabilities, such as L1TF. With the right
cache load gadget, an attacker-controlled hyperthread pair can leak
arbitrary data via L1TF. Disabling hyperthreading is one recommended
mitigation, but it comes with a large performance hit for a wide range
of workloads.

An alternative mitigation is to not make certain data in the kernel
globally visible, but only when the kernel executes in the context of
the process where this data belongs to.

This patch series proposes to introduce a region for what we call
process-local memory into the kernel's virtual address space. Page
tables and mappings in that region will be exclusive to one address
space, instead of implicitly shared between all kernel address spaces.
Any data placed in that region will be out of reach of cache load
gadgets that execute in different address spaces. To implement
process-local memory, we introduce a new interface kmalloc_proclocal() /
kfree_proclocal() that allocates and maps pages exclusively into the
current kernel address space. As a first use case, we move architectural
state of guest CPUs in KVM out of reach of other kernel address spaces.

The patch set is a prototype for x86-64 that we have developed on top of
kernel 4.20.17 (with cherry-picked commit d253ca0c3865 "x86/mm/cpa: Add
set_direct_map_*() functions"). I am aware that the integration with KVM
will see some changes while rebasing to 5.x. Patches 7 and 8, in
particular, help make patch 9 more readable, but will be dropped in
rebasing. We have tested the code on both Intel and AMDs, launching VMs
in a loop. So far, we have not done in-depth performance evaluation.
Impact on starting VMs was within measurement noise.

---

Julian Stecklina (2):
  kvm, vmx: move CR2 context switch out of assembly path
  kvm, vmx: move register clearing out of assembly path

Marius Hillenbrand (8):
  x86/mm/kaslr: refactor to use enum indices for regions
  x86/speculation, mm: add process local virtual memory region
  x86/mm, mm,kernel: add teardown for process-local memory to mm cleanup
  mm: allocate virtual space for process-local memory
  mm: allocate/release physical pages for process-local memory
  kvm/x86: add support for storing vCPU state in process-local memory
  kvm, vmx: move gprs to process local memory
  kvm, x86: move guest FPU state into process local memory

 Documentation/x86/x86_64/mm.txt         |  11 +-
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/kvm_host.h         |  40 ++-
 arch/x86/include/asm/page_64.h          |   4 +
 arch/x86/include/asm/pgtable_64_types.h |  12 +
 arch/x86/include/asm/proclocal.h        |  11 +
 arch/x86/kernel/head64.c                |   8 +
 arch/x86/kvm/Kconfig                    |  10 +
 arch/x86/kvm/kvm_cache_regs.h           |   4 +-
 arch/x86/kvm/svm.c                      | 104 +++++--
 arch/x86/kvm/vmx.c                      | 213 ++++++++++-----
 arch/x86/kvm/x86.c                      |  31 ++-
 arch/x86/mm/Makefile                    |   1 +
 arch/x86/mm/dump_pagetables.c           |   9 +
 arch/x86/mm/fault.c                     |  19 ++
 arch/x86/mm/kaslr.c                     |  63 ++++-
 arch/x86/mm/proclocal.c                 | 136 +++++++++
 include/linux/mm_types.h                |  13 +
 include/linux/proclocal.h               |  35 +++
 kernel/fork.c                           |   6 +
 mm/Makefile                             |   1 +
 mm/proclocal.c                          | 348 ++++++++++++++++++++++++
 security/Kconfig                        |  18 ++
 23 files changed, 978 insertions(+), 120 deletions(-)
 create mode 100644 arch/x86/include/asm/proclocal.h
 create mode 100644 arch/x86/mm/proclocal.c
 create mode 100644 include/linux/proclocal.h
 create mode 100644 mm/proclocal.c

-- 
2.21.0

