Return-Path: <kvm+bounces-21192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 743F392BAE0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29E4728741C
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854C1161902;
	Tue,  9 Jul 2024 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="abv3Rx2i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC5F158A0D;
	Tue,  9 Jul 2024 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531271; cv=none; b=Zqdzn8qJWbnyPgGvJ2Qc3hnCzNkIedpbR2UGDjSbXmVPna9S6adNHFGE3E73KJugz2rxrItwNzc1F0YNYTa2PjE+/EfbBRPGcY909WqaIi61AuOAHYpprv1tRVs6k2ChneHXfrd+/TmaC2YBHTPaKnDYFK3yXfrEQR+axa3KRH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531271; c=relaxed/simple;
	bh=PzopfNf2JLiebOgwEf8XBNTqiXpylUMyX3GeR8sb8FI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N1sQIbVfhzzx+6UcLf8klI6IbYiXLtkku4sGdOl7rbvMewlOH9sfslgZS6G7EJoWRUQMUebPihuY2z89NKhhJxxFSNoSlyvCuH+yhX1a45Klpf2pIsc+CEv+ZaMPR3ZcOFwe/Qs+1NA+Cs4hnBQADMv72Q8Q4nrF3qRhwu3wtxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=abv3Rx2i; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720531270; x=1752067270;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JvsKDQtPEpQi+6f5PZkphVAQipCdfdQA5rHBjtTGne4=;
  b=abv3Rx2iG4gaaV9m/1OT0bu5L0Lka6YI06ZkHgN6T/uejpmsBU7YhBQX
   VUIgb9erWtnDcVloEJMs/NFiMdhI6seMbOFq+Oe1oaJ+jAtKk6PESB8kL
   JaW9Phyn3edMeTFPa2GcUMSNXUHGP4nHeKu7fiUpnls1l8w1CodOnJpkr
   o=;
X-IronPort-AV: E=Sophos;i="6.09,195,1716249600"; 
   d="scan'208";a="418820814"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 13:20:55 +0000
Received: from EX19MTAUEB002.ant.amazon.com [10.0.44.209:19356]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.40.149:2525] with esmtp (Farcaster)
 id 26b0b38b-82b5-4c70-a8ce-d2f8b26566eb; Tue, 9 Jul 2024 13:20:54 +0000 (UTC)
X-Farcaster-Flow-ID: 26b0b38b-82b5-4c70-a8ce-d2f8b26566eb
Received: from EX19D008UEA002.ant.amazon.com (10.252.134.125) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:20:53 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA002.ant.amazon.com (10.252.134.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:20:53 +0000
Received: from ua2d7e1a6107c5b.ant.amazon.com (172.19.88.180) by
 mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Tue, 9 Jul 2024 13:20:50 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <david@redhat.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
Subject: [RFC PATCH 0/8] Unmapping guest_memfd from Direct Map
Date: Tue, 9 Jul 2024 14:20:28 +0100
Message-ID: <20240709132041.3625501-1-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Hey all,

This RFC series is a rough draft adding support for running
non-confidential compute VMs in guest_memfd, based on prior discussions
with Sean [1]. Our specific usecase for this is the ability to unmap
guest memory from the host kernel's direct map, as a mitigation against
a large class of speculative execution issues.

=== Implementation ===

This patch series introduces a new flag to the `KVM_CREATE_GUEST_MEMFD`
to remove its pages from the direct map when they are allocated. When
trying to run a guest from such a VM, we now face the problem that
without either userspace or kernelspace mappings of guest_memfd, KVM
cannot access guest memory to, for example, do MMIO emulation of access
memory used to guest/host communication. We have multiple options for
solving this when running non-CoCo VMs: (1) implement a TDX-light
solution, where the guest shares memory that KVM needs to access, and
relies on paravirtual solutions where this is not possible (e.g. MMIO),
(2) have KVM use userspace mappings of guest_memfd (e.g. a
memfd_secret-style solution), or (3) dynamically reinsert pages into the
direct map whenever KVM wants to access them.

This RFC goes for option (3). Option (1) is a lot of overhead for very
little gain, since we are not actually constrained by a physical
inability to access guest memory (e.g. we are not in a TDX context where
accesses to guest memory cause a #MC). Option (2) has previously been
rejected [1].

In this patch series, we make sufficient parts of KVM gmem-aware to be
able to boot a Linux initrd from private memory on x86. These include
KVM's MMIO emulation (including guest page table walking) and kvm-clock.
For VM types which do not allow accessing gmem, we return -EFAULT and
attempt to prepare a KVM_EXIT_MEMORY_FAULT.

Additionally, this patch series adds support for "restricted" userspace
mappings of guest_memfd, which work similar to memfd_secret (e.g.
disallow get_user_pages), which allows handling I/O and loading the
guest kernel in a simple way. Support for this is completely independent
of the rest of the functionality introduced in this patch series.
However, it is required to build a minimal hypervisor PoC that actually
allows booting a VM from a disk.

=== Performance ===

We have run some preliminary performance benchmarks to assess the impact
of on-the-fly direct map manipulations. We were mainly interested in the
impact of manipulating the direct map for MMIO emulation on virtio-mmio.
Particularly, we were worried about the impact of the TLB and L1/2/3
Cache flushes that set_memory_[n]p entails.

In our setup, we have taken a modified Firecracker VMM, spawned a Linux
guest with 1 vCPU, and used fio to stress a virtio_blk device. We found
that the cache flushes caused throughput to drop from around 600MB/s to
~50MB/s (~90%) for both reads and writes (on a Intel(R) Xeon(R) Platinum
8375C CPU with 64 cores). We then converted our prototype to use
set_direct_map_{invalid,default}_noflush instead of set_memory_[n]p and
found that without cache flushes the pure impact of the direct map
manipulation is indistinguishable from noise. This is why we use
set_direct_map_{invalid,default}_noflush instead of set_memory_[n]p in
this RFC.

Note that in this comparison, both the baseline, as well as the
guest_memfd-supporting version of Firecracker were made to bounce I/O
buffers in VMM userspace. As GUP is disabled for the guest_memfd VMAs,
the virtio stack cannot directly pass guest buffers to read/write
syscalls.

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

Patches 1-4 are about hot-patching various points inside of KVM that
access guest memory to correctly handle the case where memory happens to
be guest-private. This means either handling the access as a memory
error, or simply accessing the memslot's guest_memfd instead of looking
at the userspace provided VMA if the VM type allows these kind of
accesses. Patches 5-6 add a flag to KVM_CREATE_GUEST_MEMFD that will
make it remove its pages from the kernel's direct map. Whenever KVM
wants to access guest-private memory, it will temporarily re-insert the
relevant pages. Patches 7-8 allow for restricted userspace mappings
(e.g. get_user_pages paths are disabled like for memfd_secret) of
guest_memfd, so that userspace has an easy path for loading the guest
kernel and handling I/O-buffers.

=== ToDos / Limitations ===

There are still a few rough edges that need to be addressed before
dropping the "RFC" tag, e.g.

* Handle errors of set_direct_map_default_not_flush in
  kvm_gmem_invalidate_folio instead of calling BUG_ON
* Lift the limitation of "at most one gfn_to_pfn_cache for each
  gfn/pfn" in e1c61f0a7963 ("kvm: gmem: Temporarily restore direct map
  entries when needed"). It currently means that guests with more than 1
  vcpu fail to boot, because multiple vcpus can put their kvm-clock PV
  structures into the same page (gfn)
* Write selftests, particularly around hole punching, direct map removal,
  and mmap.

Lastly, there's the question of nested virtualization which Sean brought
up in previous discussions, which runs into similar problems as MMIO. I
have looked at it very briefly. On Intel, KVM uses various gfn->uhva
caches, which run in similar problems as the gfn_to_hva_caches dealt
with in 200834b15dda ("kvm: use slowpath in gfn_to_hva_cache if memory
is private"). However, previous attempts at just converting this to
gfn_to_pfn_cache (which would make them work with guest_memfd) proved
complicated [2]. I suppose initially, we should probably disallow nested
virtualization in VMs that have their memory removed from the direct
map.

Best,
Patrick

[1]: https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com/
[2]: https://lore.kernel.org/kvm/ZBEEQtmtNPaEqU1i@google.com/

Patrick Roy (8):
  kvm: Allow reading/writing gmem using kvm_{read,write}_guest
  kvm: use slowpath in gfn_to_hva_cache if memory is private
  kvm: pfncache: enlighten about gmem
  kvm: x86: support walking guest page tables in gmem
  kvm: gmem: add option to remove guest private memory from direct map
  kvm: gmem: Temporarily restore direct map entries when needed
  mm: secretmem: use AS_INACCESSIBLE to prohibit GUP
  kvm: gmem: Allow restricted userspace mappings

 arch/x86/kvm/mmu/paging_tmpl.h |  94 +++++++++++++++++++-----
 include/linux/kvm_host.h       |   5 ++
 include/linux/kvm_types.h      |   1 +
 include/linux/secretmem.h      |  13 +++-
 include/uapi/linux/kvm.h       |   2 +
 mm/secretmem.c                 |   6 +-
 virt/kvm/guest_memfd.c         |  83 +++++++++++++++++++--
 virt/kvm/kvm_main.c            | 112 +++++++++++++++++++++++++++-
 virt/kvm/pfncache.c            | 130 +++++++++++++++++++++++++++++----
 9 files changed, 399 insertions(+), 47 deletions(-)


base-commit: 890a64810d59b1a58ed26efc28cfd821fc068e84
-- 
2.45.2


