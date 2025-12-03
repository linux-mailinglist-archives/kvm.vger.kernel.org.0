Return-Path: <kvm+bounces-65217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A69C9F54C
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 15:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 2353B3000CD4
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 14:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3CF2FFFAA;
	Wed,  3 Dec 2025 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="NxQbLcqW"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932872FFF9F
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764772936; cv=none; b=h/0GWOHfO7e1w/J8IM/Ry96zVpZh/pb/SvxbVafQgA/X9mh5mFOOH/BMfO+mih1miERU4j0xMcK+xXOLdExkfcp85lJ4EKsLTjs2oaArWSkl/B+Eq6JjVnW4d4mvn9Ug+SRsxEZRoGceRFuNo8pmVQB6LTy9TV0fkmWUUDSENf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764772936; c=relaxed/simple;
	bh=FMPqCWI15mP7EQLBfdqMJJmIJS/S//nKG+G3jQKk92Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MLVTtqxzqjep8esQEveOmxEASWJ9OWChZ7jSXmQxozE7x47Fd5ckjL6ZNyDBbfMEAoeBScubSmbFLVCUgN2bBTLt0tzYt/LinK1XDxl8GONi5a4v4GoFv8Fr1mxMEkUfxaciKEPtF9rgSTuh9s3xosuTheuywMHBldDQhOzl2v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=NxQbLcqW; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764772934; x=1796308934;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jIoQkylbocnD/J7YGfN8zI1tRIPWNbo/9VuuXCiV2Ss=;
  b=NxQbLcqWJjUb1XpYvpWMRK+a7Csj49FkAeg8CdMq4m+bNxi6dbKNKATy
   yqjIb72sBNwe5khB3h5U8JQW03wB8/XwaI7ub/kghjKYohTgCZGI/uA4Z
   bezKeJl4tf+xwxZEh/uJ6R9bjL+g8A8UXWGFqLI+v3qR/hcNQmZknq0Jn
   J7zllrnSb0SJ1Ie3fxGfy6sDvhqDMvGvaqlhE1Zv8l3MTQ+O7uwijFqBn
   OGCTgTeOloveqox82La/koFgl4t3ZH+jsFa2Hl4w4HfPrS3A5OjPKi6Fj
   g0FppwIM+ukFkdyGY5mtwiUUg+myBuuwuqtOudtcJs2WEqyOI1f1GOjYp
   A==;
X-CSE-ConnectionGUID: eG54ond8SyiY3sqD5G4cwg==
X-CSE-MsgGUID: OWgd6TVFSq2L190k/PzUzA==
X-IronPort-AV: E=Sophos;i="6.20,246,1758585600"; 
   d="scan'208";a="8118300"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 14:42:10 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:3728]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.237:2525] with esmtp (Farcaster)
 id f2a54f5b-4ea6-41ab-9769-48368ea716a4; Wed, 3 Dec 2025 14:42:10 +0000 (UTC)
X-Farcaster-Flow-ID: f2a54f5b-4ea6-41ab-9769-48368ea716a4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 3 Dec 2025 14:42:05 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 3 Dec 2025 14:42:03 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>, Brendan Jackman
	<jackmanb@google.com>, David Hildenbrand <david@kernel.org>, David Woodhouse
	<dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>, Nikita Kalyazin
	<kalyazin@amazon.com>, Patrick Roy <patrick.roy@campus.lmu.de>, "Takahiro
 Itazuri" <zulinx86@gmail.com>
Subject: [RFC PATCH 0/2] KVM: pfncache: Support guest_memfd without direct map
Date: Wed, 3 Dec 2025 14:41:45 +0000
Message-ID: <20251203144159.6131-1-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

[ based on kvm/next with [1] ]

Recent work on guest_memfd [1] is introducing support for removing guest
memory from the kernel direct map (Note that this work has not yet been
merged, which is why this patch series is labelled RFC). The feature is
useful for non-CoCo VMs to prevent the host kernel from accidentally or
speculatively accessing guest memory as a general safety improvement.
Pages for guest_memfd created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP have
their direct-map PTEs explicitly disabled, and thus cannot rely on the
direct map.

This breaks the features that use gfn_to_pfn_cache, including kvm-clock.
gfn_to_pfn_cache caches the pfn and kernel host virtual address (khva)
for a given gfn so that KVM can repeatedly access the corresponding
guest page.  The cached khva may later be dereferenced from atomic
contexts in some cases.  Such contexts cannot tolerate sleep or page
faults, and therefore cannot use the userspace mapping (uhva), as those
mappings may fault at any time.  As a result, gfn_to_pfn_cache requires
a stable, fault-free kernel virtual address for the backing pages,
independent of the userspace mapping.

This small patch series enables gfn_to_pfn_cache to work correctly when
a memslot is backed by guest_memfd with GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
The first patch teaches gfn_to_pfn_cache to obtain pfn for guest_memfd-
backed memslots via kvm_gmem_get_pfn() instead of GUP (hva_to_pfn()).
The second patch makes gfn_to_pfn_cache use vmap()/vunmap() to create a
fault-free kernel address for such pages.  We believe that establishing
such mapping for paravirtual guest/host communication is acceptable as
such pages do not contain sensitive data.

Another considered idea was to use memremap() instead of vmap(), since
gpc_map() already falls back to memremap() if pfn_valid() is false.
However, vmap() was chosen for the following reason.  memremap() with
MEMREMAP_WB first attempts to use the direct map via try_ram_remap(),
and then falls back to arch_memremap_wb(), which explicitly refuses to
map system RAM.  It would be possible to relax this restriction, but the
side effects are unclear because memremap() is widely used throughout
the kernel.  Changing memremap() to support system RAM without the
direct map solely for gfn_to_pfn_cache feels disproportionate.  If
additional users appear that need to map system RAM without the direct
map, revisiting and generalizing memremap() might make sense.  For now,
vmap()/vunmap() provides a contained and predictable solution.

A possible approach in the future is to use the "ephmap" (or proclocal)
proposed in [2], but it is not yet clear when that work will be merged.
In contrast, the changes in this patch series are small and self-
contained, yet immediately allow gfn_to_pfn_cache (including kvm-clock)
to operate correctly with direct map-removed guest_memfd.  Once ephmap
eventually is merged, gfn_to_pfn_cache can be updated to make use of it
as appropriate.

[1]: https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de/
[2]: https://lore.kernel.org/all/20250812173109.295750-1-jackmanb@google.com/

Takahiro Itazuri (2):
  KVM: pfncache: Use kvm_gmem_get_pfn() for guest_memfd-backed memslots
  KVM: pfncache: Use vmap() for guest_memfd pages without direct map

 include/linux/kvm_host.h |  7 ++++++
 virt/kvm/pfncache.c      | 52 +++++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 14 deletions(-)

--
2.50.1


