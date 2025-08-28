Return-Path: <kvm+bounces-56056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB01B39875
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6C283AF202
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951972E3715;
	Thu, 28 Aug 2025 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="BvlSmmtP"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C0207A26;
	Thu, 28 Aug 2025 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.65.3.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373968; cv=none; b=NkSp2DzLU8CVT5QZakXqZkyuBkuSJRGeVlGnDz3+AVYzGtv4AsJgVuX4CweH62bPpJfN5+ctBEqWqqIYqgTt0xRBdrt7ufpkOPtyPc7rxvUpIM5DXrkObT8yVz6L7LSa38aNC5qeX2U+k0IhO/BVRhlv1hmevWNFCEsG7G9bHfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373968; c=relaxed/simple;
	bh=kPVVOMGARmYiS9iJ8JjebyS26HPrPQGkz1ifLfM+sV8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iRhHVCMLMbSLGyu2jRadRYBS9AtY7Dj25zIOO4kwmSQdFPBkoeQ6NP1/8zGQmjyi9BuuxiRi8gNFOn0ZSRUybUSVh6xRt8Hcs2QTG1IaC8KgSu6KYjU6IU6iWZAtPx0334xMDH2S55hlUW2v+CbXNgj9kv6HqqL1yp8O7dBNzJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=BvlSmmtP; arc=none smtp.client-ip=3.65.3.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373966; x=1787909966;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=wBKMgXKBvz9IiVmaTGjG/lSyZH5eWM6lHVDXOR7WFUE=;
  b=BvlSmmtP3HrhKp/9vMwOl5irhJuKMG1v44dblOEzzr+LmXPg9Lzg9sMT
   Kx4H/WDnshhnJO+L6Zi8JtD0TiWydKl96Fh17/xkfaAPN0T8d+Vj4Zmzi
   utLA3XWQmwNoRdAZroZOII3iZKgPVPWfNxPgNZUo5yyMVeL6Ylsoi7+OE
   eBYGBZolQZbJYu2SnQvK7h4XZunVdc7qbIC45eOhqNc0fXzzjzCXvsxJn
   g2jC13ykZMGwE7MBwAD4jnPd6rGp/ZcBKFRoyNn16qaCHkNfKx75p1GnL
   n/qmrPv2/LYpmHvgPiKTJyHG/TBPN4v2hLkLHkPPkfs85o8iZqbAJjXZz
   w==;
X-CSE-ConnectionGUID: SIlh/HeRQO2Ix/T5Q4dxPg==
X-CSE-MsgGUID: GQgFOM3UQo+ArwAbAQdjTg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1303383"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:16 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:11608]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.3.140:2525] with esmtp (Farcaster)
 id b400d3fe-1f6b-4e43-a1c7-ed7157d75ef6; Thu, 28 Aug 2025 09:39:15 +0000 (UTC)
X-Farcaster-Flow-ID: b400d3fe-1f6b-4e43-a1c7-ed7157d75ef6
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:15 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:14 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:14 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 00/12] Direct Map Removal Support for guest_memfd
Thread-Topic: [PATCH v5 00/12] Direct Map Removal Support for guest_memfd
Thread-Index: AQHcF/+dcK3rIkIurEWjp/zWzGg9HQ==
Date: Thu, 28 Aug 2025 09:39:14 +0000
Message-ID: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

[ based on kvm/next ]=0A=
=0A=
Unmapping virtual machine guest memory from the host kernel's direct map is=
 a=0A=
successful mitigation against Spectre-style transient execution issues: If =
the=0A=
kernel page tables do not contain entries pointing to guest memory, then an=
y=0A=
attempted speculative read through the direct map will necessarily be block=
ed=0A=
by the MMU before any observable microarchitectural side-effects happen. Th=
is=0A=
means that Spectre-gadgets and similar cannot be used to target virtual mac=
hine=0A=
memory. Roughly 60% of speculative execution issues fall into this category=
 [1,=0A=
Table 1].=0A=
=0A=
This patch series extends guest_memfd with the ability to remove its memory=
=0A=
from the host kernel's direct map, to be able to attain the above protectio=
n=0A=
for KVM guests running inside guest_memfd.=0A=
=0A=
=3D=3D=3D Design =3D=3D=3D=0A=
=0A=
We build on top of guest_memfd's recent support for "non-confidential VMs",=
 in=0A=
which all of guest_memfd is mappable to userspace (e.g. considered "shared"=
).=0A=
For such VMs, all guest page faults are routed through guest_memfd's specia=
l=0A=
page fault handler, which due to consuming fd+offset directly, can map dire=
ct=0A=
map removed memory into the guest. KVM's internal accesses to guest memory =
are=0A=
handled by providing each memslot with a userspace mapping of that memslots=
=0A=
guest_memfd via userspace_addr. Since KVM's internal accesses are almost=0A=
exclusively handled via copy_from_user() and friends, this allows KVM to ac=
cess=0A=
direct map removed guest memory for features such as MMIO instruction emula=
tion=0A=
on x86 or pvtime support on ARM64.=0A=
=0A=
=3D=3D=3D Implementation =3D=3D=3D=0A=
=0A=
The KVM_CREATE_GUEST_MEMFD ioctl gains a new flag=0A=
GUEST_MEMFD_FLAG_NO_DIRECT_MAP.  If this flag is passed, then guest_memfd=
=0A=
removes direct map entries for its folios are preparation. Upon free-ing of=
 the=0A=
memory, direct map entries are restored prior to gmem's arch specific=0A=
invalidation callback.=0A=
=0A=
Support for the flag can be discovered via the KVM_CAP_GMEM_NO_DIRECT_MAP=
=0A=
capability, which is only available if direct map modifications at 4k=0A=
granularity is architecturally possible / when KVM can successfully map dir=
ect=0A=
map removed memory into the guest.=0A=
=0A=
=3D=3D=3D Testing =3D=3D=3D=0A=
=0A=
KVM selftests are extended to cover the above-described non-CoCo workflows,=
=0A=
where guest_memfd with direct map entries removed is used to back all of gu=
est=0A=
memory, and exercising some simple MMIO paths.=0A=
=0A=
Additionally, a Firecracker branch with support for these VMs can be found =
on=0A=
GitHub [2].=0A=
=0A=
=3D=3D=3D Changes since v4 =3D=3D=3D=0A=
=0A=
- Rebase on top of kvm/next=0A=
- Stop using PG_private to track direct map removal state=0A=
- fix build or KVM-as-a-module by using new EXPORT_SYMBOL_FOR_MODULES=0A=
=0A=
=3D=3D=3D FAQ =3D=3D=3D=0A=
=0A=
--- why not reuse memfd_secret() / a bespoke guest memory solution? ---=0A=
=0A=
having guest memory be direct map removed means guest page faults cannot be=
=0A=
resolved by GUP-ing userspace mappings of guest memory, as GUP is disabled =
for=0A=
direct map removed memory (as currently GUP has no way to understand that a=
=0A=
specific GUP request will not subsequently dereference page_address()).=0A=
guest_memfd already has a special path inside KVM that instead consumed=0A=
fd+offset, so it makes sense to reuse this. Additionally, it means that=0A=
direct-map-removed VMs can benefit from active development on guest_memfd, =
such=0A=
as huge pages support.=0A=
=0A=
--- why do KVM internal accesses through userspace page tables? ---=0A=
=0A=
For traditional VMs, all KVM internal accesses are done through the=0A=
userspace_addr stored in a memslot, meaning no changes to most KVM code are=
=0A=
needed just to allow access to guest_memfd backed / direct map removed gues=
t=0A=
memory of non-confidential VMs. Previous iterations of this series tried to=
=0A=
avoid userspace mappings, instead attempting to dynamically restore direct =
map=0A=
entries for internal accesses [RFCv2], but this turned out to have a=0A=
significant performance impact, as well as additional complexity due to nee=
ding=0A=
to refcount direct map reinsertion operations and making them play nicely w=
ith=0A=
gmem truncations.=0A=
=0A=
--- what doesn't work with direct map removed VMs? ---=0A=
=0A=
The only thing I'm aware of is kvm-clock, since it tries to GUP guest memor=
y=0A=
via gfn_to_pfn_cache. Realistically, this is only a problem on AMD, as on I=
ntel=0A=
guests can use TSC as a clocksource (Intel allows discovery of TSC frequenc=
y=0A=
via CPUID, while AMD doesn't).  AMD guests fall back onto some calibration=
=0A=
routine, which fails most of the time though.=0A=
=0A=
[1]: https://download.vusec.net/papers/quarantine_raid23.pdf=0A=
[2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret=
-hiding=0A=
[RFCv1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon=
.co.uk/=0A=
[RFCv2]: https://lore.kernel.org/kvm/20240910163038.1298452-1-roypat@amazon=
.co.uk/=0A=
[RFCv3]: https://lore.kernel.org/kvm/20241030134912.515725-1-roypat@amazon.=
co.uk/=0A=
[v4]: https://lore.kernel.org/kvm/20250221160728.1584559-1-roypat@amazon.co=
.uk/=0A=
=0A=
=0A=
Elliot Berman (1):=0A=
  filemap: Pass address_space mapping to ->free_folio()=0A=
=0A=
Patrick Roy (11):=0A=
  arch: export set_direct_map_valid_noflush to KVM module=0A=
  mm: introduce AS_NO_DIRECT_MAP=0A=
  KVM: guest_memfd: Add flag to remove from direct map=0A=
  KVM: Documentation: describe GUEST_MEMFD_FLAG_NO_DIRECT_MAP=0A=
  KVM: selftests: load elf via bounce buffer=0A=
  KVM: selftests: set KVM_MEM_GUEST_MEMFD in vm_mem_add() if guest_memfd=0A=
    !=3D -1=0A=
  KVM: selftests: Add guest_memfd based vm_mem_backing_src_types=0A=
  KVM: selftests: stuff vm_mem_backing_src_type into vm_shape=0A=
  KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP in mem conversion=0A=
    tests=0A=
  KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP in=0A=
    guest_memfd_test.c=0A=
  KVM: selftests: Test guest execution from direct map removed gmem=0A=
=0A=
 Documentation/filesystems/locking.rst         |  2 +-=0A=
 Documentation/virt/kvm/api.rst                |  5 ++=0A=
 arch/arm64/include/asm/kvm_host.h             | 12 ++++=0A=
 arch/arm64/mm/pageattr.c                      |  1 +=0A=
 arch/loongarch/mm/pageattr.c                  |  1 +=0A=
 arch/riscv/mm/pageattr.c                      |  1 +=0A=
 arch/s390/mm/pageattr.c                       |  1 +=0A=
 arch/x86/mm/pat/set_memory.c                  |  1 +=0A=
 fs/nfs/dir.c                                  | 11 ++--=0A=
 fs/orangefs/inode.c                           |  3 +-=0A=
 include/linux/fs.h                            |  2 +-=0A=
 include/linux/kvm_host.h                      |  7 +++=0A=
 include/linux/pagemap.h                       | 16 +++++=0A=
 include/linux/secretmem.h                     | 18 ------=0A=
 include/uapi/linux/kvm.h                      |  2 +=0A=
 lib/buildid.c                                 |  4 +-=0A=
 mm/filemap.c                                  |  9 +--=0A=
 mm/gup.c                                      | 14 +----=0A=
 mm/mlock.c                                    |  2 +-=0A=
 mm/secretmem.c                                |  9 +--=0A=
 mm/vmscan.c                                   |  4 +-=0A=
 .../testing/selftests/kvm/guest_memfd_test.c  |  2 +=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 37 ++++++++---=0A=
 .../testing/selftests/kvm/include/test_util.h |  8 +++=0A=
 tools/testing/selftests/kvm/lib/elf.c         |  8 +--=0A=
 tools/testing/selftests/kvm/lib/io.c          | 23 +++++++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 61 +++++++++++--------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++=0A=
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +=0A=
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +=0A=
 .../selftests/kvm/set_memory_region_test.c    | 50 +++++++++++++--=0A=
 .../kvm/x86/private_mem_conversions_test.c    |  7 ++-=0A=
 virt/kvm/guest_memfd.c                        | 32 ++++++++--=0A=
 virt/kvm/kvm_main.c                           |  5 ++=0A=
 34 files changed, 264 insertions(+), 104 deletions(-)=0A=
=0A=
=0A=
base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383=0A=
-- =0A=
2.50.1=0A=
=0A=

