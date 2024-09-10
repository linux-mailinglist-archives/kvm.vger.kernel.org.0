Return-Path: <kvm+bounces-26305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8687973D40
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD0B81C21548
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA1813A3E8;
	Tue, 10 Sep 2024 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="efA73Bnf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD90714F12C;
	Tue, 10 Sep 2024 16:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985867; cv=none; b=AodxMpRxZG4n++sUv0kEYqiMY6XWDVqLpRz/tzulMnhP63ORJ98cRVPZsiPupn5XstIQgNZUyIBFR59PO4G1paA7X3ehp/M5DXrDV42BsTFTUB+KIbCJ3Z2mLqQmZTy1XFUWRPczr09A5LCbAyiHouQO7GwUeBTNskVD0nm5vwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985867; c=relaxed/simple;
	bh=TV8vcvnHLn5OwjldWbCQCoozcxHtMnUg6qc3eFh1ivE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bjGjRFTpyjyLGDXQy7LJQu2eER+aiSejUM4vIFASy7ydulm+17Rxd6ObbCOyVkBkDeonL0WABAnnfJM2JmrDv6nRiwl52lhK1nis1qhMLSkJSEhqfvh+wtcBLRhMbzPU0LhrRwI+cnmMHeJSa8gQKsqPhFLjaGBQRZGw9sQ4seQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=efA73Bnf; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985866; x=1757521866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pg7ptibreX/x3/r6fh4gvZhhtdRZTe0WITSJkltiTvM=;
  b=efA73BnfcA2J2H7e7ehZvn/tC/OhSESNycGUQ0nqTPGGoUTBzCGDgIK/
   gtVTgxwq4lQLmbgSl8PhEiCm4onoRI2LuKAOuzJ5P3lcbMpGCCYcOlHhO
   KNIS6MTiS8fWPkpUKQSMJJwG3/0pfDq+Vr2IJgymbvBV2CVCC8/4YkvAf
   s=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="367280292"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:30:59 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.44.209:7503]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.42.209:2525] with esmtp (Farcaster)
 id a1e9aa06-afd3-4fab-a6da-6c43322de62d; Tue, 10 Sep 2024 16:30:57 +0000 (UTC)
X-Farcaster-Flow-ID: a1e9aa06-afd3-4fab-a6da-6c43322de62d
Received: from EX19D008UEC004.ant.amazon.com (10.252.135.170) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:30:45 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEC004.ant.amazon.com (10.252.135.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:30:44 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:30:40 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <quic_eberman@quicinc.com>,
	<dwmw@amazon.com>, <david@redhat.com>, <tabba@google.com>, <rppt@kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <graf@amazon.com>,
	<jgowans@amazon.com>, <derekmn@amazon.com>, <kalyazin@amazon.com>,
	<xmarcalx@amazon.com>
Subject: [RFC PATCH v2 00/10] Unmapping guest_memfd from Direct Map
Date: Tue, 10 Sep 2024 17:30:26 +0100
Message-ID: <20240910163038.1298452-1-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Hey all,

This is an overhaul of my RFC [1] for removing guest_memfd folios from
the direct map. The goal of this is to back non-confidential VMs using
guest_memfd and protect their memory from a large class of speculative
execution issues [1, Table 1]. This RFC series is also the basis of my
LPC submission [3].

=== Changes to v1 ===

- Drop patches related to userspace mappings to only focus on direct map
  removal.
- Use a refcount to track temporary direct map reinsertions
  (Paolo/Elliot)
- Implement invalidation of gfn_to_pfn_caches holding gmem pfns (David
  W.)
- Do not assume folios have only a single page (Mike R.)

=== Implementation ===

This patch series extends guest_memfd to run "non-confidential" VMs that
still have their guest memory removed from the host's direct map.
"non-confidential" here means that we wish to treat the VM pretty much
the same as a VM with traditional, non-guest_memfd memslots: KVM should
be able to access non sensitive parts of guest memory such as page
tables and MMIO instructions for MMIO emulation, or things like the
kvm-clock page, without requiring the guest collaboration. 

This patch series thus does two things: First introduce a new
`KVM_GMEM_NO_DIRECT_MAP` flag to the `KVM_CREATE_GUEST_MEMFD` ioctl that
causes guest_memfd to remove its folios from the direct map immediately
after allocation. Then, teach key parts of KVM about how to access
guest_memfd memory (if the vm type allows it) via temporary restoration
of direct map entries. The parts of KVM which we enlighten like this are

- kvm_{read,write}_guest and friends (needed for instruction fetch
  during MMIO emulation)
- paging64_walk_addr_generic (needed to resolve GPAs during MMIO
  emulation)
- pfncache.c (needed for kvm-clock)

These are a minimal set needed to boot a non-confidential initrd from
guest_memfd (provided one finds a way to load such a thing into
guest_memfd. My testing was done with an additional commit on this of
this series that allows unconditional userspace mappings of
guest_memfd).

Instruction fetch for MMIO emulation is special here in the sense that
it cannot be solved by having the guest explicitly share memory ahead of
time, since such conversions in guest_memfd are destructive, and the
guest cannot know which instructions will trigger MMIO ahead of time
(TDX for example has a special paravirtual solution for this case). It
is thus the original motivation for the approach in this patch series.

In terms of the proposed framework for allowing both "shared" and
"private" memory inside guest_memfd (with in-place conversions
supported) [4], memory with its direct map entries removed can be
considered "private", while gmem memory with direct map entries can be
considered "shared" (I'm afraid this patch series also hasn't found
better names than the horribly overloaded "shared" and "private" for
this). 

Implementing support for accessing guest_memfd in kvm_{read,write}_guest
is fairly straight forward, as the operation is a simple
"remap->access->unmap" sequence that can be completely done while
holding the folio lock. However, "long term" accesses such a
gfn_to_pfn_caches, which reinsert parts of gmem into the direct map for
long periods of time, proved to be tricky to implement, due to the need
to respond to gmem invalidation events (to, for example, avoid modifying
direct map entries after a folio has been fallocated away and freed).
This part is why this series is still an RFC, because my confidence in
getting those patches right is fairly low. For what's implemented here,
an alternative would be to just have the guest share page tables the
kvm-clock pages ahead of time (while keeping the changes to
kvm_{read,write}_guest to handle instruction emulation), however I'm not
sure this would work for potential future usecases such as nested
virtualization (where the L1 guest cannot know ahead of time where the
L2 will place page tables, and thus cannot mark them as shared).

=== Security ===

We want to use unmapping guest memory from the host kernel as a security
mitigation against transient execution attacks. Temporarily restoring
direct map entries whenever KVM requires access to guest memory leaves a
gap in this mitigation. We believe this to be acceptable for the above
cases, since pages used for paravirtual guest/host communication (e.g.
kvm-clock) and guest page tables do not contain sensitive data. MMIO
emulation will only end up reading pages containing privileged
instructions (e.g. guest kernel code).

=== Summary ===

Patches 1-3 are about adding the KVM_GMEM_NO_DIRECT_MAP flag, and
providing the basic functions needed to on-demand remap guest_memfd
folios. Patch 4 deals with kvm_{read,write}_guest. Patches 4 and 5 are
about adding the "sharing refcount" framework for supporting long-term
direct map restoration of gmem folios. Patches 7-9 integrate guest_memfd
with the pfncache machinery. Patch 10 teaches the guest page table
walker about guest_memfd.

The first few patches are very similar to parts of Elliot's "mm:
Introduce guest_memfd library" RFC series [5]. This series focuses on
the non-confidential usecase, while Elliot's series focuses more on
userspace mappings for confidential VMs. We've had some discussions on
how to marry these two in [6].

=== ToDos / Limitations ===

The main question I am looking for feedback on is whether I am on the
right path with the "sharing refcount" idea for long-term, KVM-initiated
sharing of gmem folios at all, or whether the last few patches look so
horrendous that a completely different solution is needed. Other than
that, the patches are of course still missing selftests.

Best, 
Patrick

[1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/T/#mf6eb2d36bab802da411505f46ba154885cb207e6
[2]: https://download.vusec.net/papers/quarantine_raid23.pdf
[3]: https://lpc.events/event/18/contributions/1763/
[4]: https://lore.kernel.org/linux-mm/BN9PR11MB5276D7FAC258CFC02F75D0648CB32@BN9PR11MB5276.namprd11.prod.outlook.com/T/#mc944a6fdcd20a35f654c2be99f9c91a117c1bed4
[5]: https://lore.kernel.org/kvm/20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com/T/#mbcf942dcccc3726921743251d07b1a3a7e711d3f
[6]: https://lore.kernel.org/kvm/20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com/T/#m785c2c1731be216fd0f6aa4c22d8b4aab146f3c1

Patrick Roy (10):
  kvm: gmem: Add option to remove gmem from direct map
  kvm: gmem: Add KVM_GMEM_GET_PFN_SHARED
  kvm: gmem: Add KVM_GMEM_GET_PFN_LOCKED
  kvm: Allow reading/writing gmem using kvm_{read,write}_guest
  kvm: gmem: Refcount internal accesses to gmem
  kvm: gmem: add tracepoints for gmem share/unshare
  kvm: pfncache: invalidate when memory attributes change
  kvm: pfncache: Support caching gmem pfns
  kvm: pfncache: hook up to gmem invalidation
  kvm: x86: support walking guest page tables in gmem

 arch/x86/kvm/mmu/mmu.c         |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h |  95 ++++++++++++---
 include/linux/kvm_host.h       |  17 ++-
 include/linux/kvm_types.h      |   2 +
 include/trace/events/kvm.h     |  43 +++++++
 include/uapi/linux/kvm.h       |   2 +
 virt/kvm/guest_memfd.c         | 216 ++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c            |  91 ++++++++++++++
 virt/kvm/kvm_mm.h              |  12 ++
 virt/kvm/pfncache.c            | 144 ++++++++++++++++++++--
 10 files changed, 579 insertions(+), 45 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0


