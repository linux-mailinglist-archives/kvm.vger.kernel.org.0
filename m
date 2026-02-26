Return-Path: <kvm+bounces-71972-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2MHKEwpXoGn4iQQAu9opvQ
	(envelope-from <kvm+bounces-71972-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:22:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 623B91A76BC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8653030E15D4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281D43D34A5;
	Thu, 26 Feb 2026 13:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="OnoUrsKS"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30E73BFE3F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114004; cv=none; b=g0mMchRurOfuZ4XayiuiRJsyR9CswK2RExTF2tIaEaCIyg490VSdJgvn6b0RCXX63AulOzuCs5Ny1sWZ42lV+dZaybTb/OofMzrI5kFyNyQFMkqjaDZXV7M9MVZoPwNd6xCN26BNEMFPR1E9D1JvBz4wo37vuPFu02tqjiBke3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114004; c=relaxed/simple;
	bh=V/ecV38XRCknm2TsQfiajIIe/T5oTvfftTK0C2cdAKs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DngiGvXf4O3ifOTJt8VWKL5DLoV6k5AeDAH1++PE6Nnnbl2tR8NiRl3OcGAiT0MxOzJ1qCk3GLqChpGMFvKvBQymWFyLVsm6N/0d+TSSKHEERgl6cbPUToeD8hk3zBEIrwC61Na/V2Tyh9zGafMwxOd5QD022Zr9B8G1u4wcJlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=OnoUrsKS; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772113998; x=1803649998;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/QNB2dXPqy1YPmXhJW3qMGsbKw/SnbTXx4Vhs6ewyzo=;
  b=OnoUrsKS/Jrsoq7C64lQUxdAnCFDcRCD1l/tI9behDPA2JdIB3WUEFsS
   5Xjc5gE3ZsXRLhSgQN2W+/o4dFg4ns5//aHHqc3s5TRDc3R9jTydtFcvW
   47TDL9exiQn+Mqac9wzP5lPka/u3tYVgyFj4e4rMWr/H+ChShUt/Ok96G
   rqkZZHrbHxeuQinu4yZifdqmBZxf4Mb87mUn69Gf2SGIFFel4rT6CYVP6
   MLDAlYPn+1JhLYcvabZptCjuFPDXjj3vrnU+If7MIsr5XWSh9yMRXutLW
   KsxrIi2nCiq1d5Rdd9pKuKfsPgyeXomvgHyR8PduhJhCdTSFKl5vGB05U
   Q==;
X-CSE-ConnectionGUID: gA4+wClBSvi74HwIk7T++Q==
X-CSE-MsgGUID: zloy7dDlTz2Omu8WZuNXJA==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13683928"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:53:16 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:27455]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.153:2525] with esmtp (Farcaster)
 id 684e611e-85c1-4f92-8d54-dd10cbc0505a; Thu, 26 Feb 2026 13:53:16 +0000 (UTC)
X-Farcaster-Flow-ID: 684e611e-85c1-4f92-8d54-dd10cbc0505a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:14 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:12 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 0/7] KVM: pfncache: Add guest_memfd support to pfncache
Date: Thu, 26 Feb 2026 13:53:01 +0000
Message-ID: <20260226135309.29493-1-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-71972-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 623B91A76BC
X-Rspamd-Action: no action

[ based on v6.18 with [1] ]

This patch series is a follow-up to RFC v1.  (This is still labelled RFC
since its dependency [1]  has not yet been merged.)

=3D=3D=3D Problem Statement =3D=3D=3D

gfn_to_pfn_cache (a.k.a. pfncache) does not work with guest_memfd.  As
of today, pfncaches resolve PFNs via hva_to_pfn(), which requires a
userspace mapping and relies on GUP.  This does not work for guest_memfd
in the following two ways:

  * guest_memfd created with GUEST_MEMFD_FLAP_MMAP does not have a
    userspace mapping due to the nature of private memory.

  * guest_memfd created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP uses an
    AS_NO_DIRECT_MAP mapping, which is rejected by GUP.

In addition, pfncaches map RAM pages via kmap(), which typically returns
an address derived from the direct map.  So kmap() cannot be used for
NO_DIRECT_MAP guest_memfd.  pfncaches require fault-free KHVAs since
they can be used from atomic context.  Thus, it cannot fall back to
access via a userspace mapping like KVM does for other accesses to
NO_DIRECT_MAP guest_memfd.

The introduction of guest_memfd support necessitates additional
invalidation paths in addition to the existing MMU notifier path: one
from guest_memfd invalidation and another from memory attribute updates.

=3D=3D=3D Core Approach =3D=3D=3D

The core part keeps the original approach in RFC v1:

  * Resolve PFNs for guest_memfd-backed GPAs via kvm_gmem_get_pfn()

  * Obtain a fault-free KHVA for NO_DIRECT_MAP pages via vmap()

=3D=3D=3D Changes since RFC v1 =3D=3D=3D

  * Hook pfncache invalidation into guest_memfd invalidation (punch hole
    / release / error handling) as well as into memory attribute updates
    (switch between shared and private memories).

=3D=3D=3D  Design Considerations (Feedback Appreciated) =3D=3D=3D

To implement the above change, this series tries to reuse as much of the
existing invalidation and retry infrastructure as possible.  The
following points are potential design trade-offs where feedback is
especially welcome:

  * Generalize and reuse the existing mn_active_invalidate_count
    (renamed to active_invalidate_count).  This allows reusing the
    existing pfncache retry logic as-is and enables invalidating
    pfncaches without holding mmu_lock from guest_memfd invalidation
    context.  As a side effect, active memslots swap is blocked while
    active_invalidate_count > 0.  To avoid this block, it would be
    possible to introduce a dedicated gmem_active_invalidate_count in
    struct kvm instead.

  * Although both guest_memfd invalidation and memory attribute update
    are driven by GFN ranges, pfncache invalidation is performed using
    HVA ranges and reuses the existing function.  This is because
    GPA-based pfncaches translate GPA->UHVA->PFN and therefore have
    memslot/GPA info, whereas HVA-based pfncaches resolve PFN directly
    from UHVA and do not store memslot/GPA info.  Using GFN-based
    invalidation would therefore miss HVA-based pfncaches.  Technically,
    it would be possible to refactor HVA-based pfncaches to search for
    and retain the corresponding memslot/GPA at activation / refresh
    time instead of at invalidation time.

  * pfncaches are not dynamically allocated but are statically allocated
    on a per-VM and per-vCPU basis.  For a normal VM (i.e. non-Xen),
    there is one pfncache per vCPU.  For a Xen VM, there is one per-VM
    pfncache and five per-vCPU pfncaches.  Given the maximum of 1024
    vCPUs, a normal VM can have up to 1024 pfncaches, consuming 4 MB of
    virtual address space.  A Xen VM can have up to 5121 pfncaches,
    consuming approximately 20 MB of virtual address space.  Although
    the vmalloc area is limited on 32-bit systems, it should be large
    enough and typically tens of TB on 64-bit systems (e.g. 32 TB for
    4-level paging and 12800 TB for 5-level paging on x86_64).  If
    virtual address space exhaustion became a concern, migration to
    mm-local region (forthcoming mermap?) could be considered in the
    future.  Note that vmap() only creates virtual mappings to existing
    pages; they do not allocate new physical pages.

  * With this patch series, HVA-based pfncaches always resolve PFNs
    via hva_to_pfn(), and thus activation for NO_DIRECT_MAP guest_memfd
    fails.  It is technically possible to support this scenario, but it
    would require searching the corresponding memslot and GPA from the
    given UHVA in order to determine whether it is backed by
    guest_memfd.  Doing so would add overhead to the HVA-based pfncache
    activation / refresh paths, to a greater or lesser extent,
    regardless of guest_memfd-backed or not.  At the time of writing,
    only Xen uses HVA-based pfncaches.

RFC v1: https://lore.kernel.org/all/20251203144159.6131-1-itazur@amazon.com/

[1]: https://lore.kernel.org/all/20260126164445.11867-1-kalyazin@amazon.com/

Takahiro Itazuri (7):
  KVM: x86: Avoid silent kvm-clock activation failures
  KVM: pfncache: Resolve PFNs via kvm_gmem_get_pfn() for gmem-backed GPAs
  KVM: pfncache: Obtain KHVA via vmap() for gmem with NO_DIRECT_MAP
  KVM: Rename invalidate_begin to invalidate_start for consistency
  KVM: pfncache: Rename invalidate_start() helper
  KVM: Rename mn_* invalidate-related fields to generic ones
  KVM: pfncache: Invalidate on gmem invalidation and memattr updates

 Documentation/virt/kvm/locking.rst |   8 +--
 arch/x86/kvm/mmu/mmu.c             |   2 +-
 arch/x86/kvm/x86.c                 |  18 ++---
 include/linux/kvm_host.h           |  13 ++--
 include/linux/mmu_notifier.h       |   4 +-
 virt/kvm/guest_memfd.c             |  64 +++++++++++++++--
 virt/kvm/kvm_main.c                |  99 +++++++++++++++++++-------
 virt/kvm/kvm_mm.h                  |  12 ++--
 virt/kvm/pfncache.c                | 110 ++++++++++++++++++++---------
 9 files changed, 235 insertions(+), 95 deletions(-)

--=20
2.50.1


