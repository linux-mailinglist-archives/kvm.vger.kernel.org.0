Return-Path: <kvm+bounces-17402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 836778C5E8C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A56C31C20FE0
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669672D054;
	Wed, 15 May 2024 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nOy4ugC1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BAB1EB26;
	Wed, 15 May 2024 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734810; cv=none; b=kKAiCysAczkc2spuOD3iynWvWjFgYPQUFMb+PDB36FyHQ90jt2tZQV1sb3KpqnKfS2fWlBZ4xNe2B8TW0nY0kTp/8tMtpR7LfO2upXRu1tCfj85zhvw1nNgrSz2HltM0WXjSiLi1VQiDcotfFK7VfrZgHZAU5yXCBFoj3dfl9Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734810; c=relaxed/simple;
	bh=+6tj0kEKZAuUZugRM5HgXHgBCG9pzGLg+BLWoV5ezpM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bOPRQNbGqCOkFEdgsuK712/Vb7sdAfkucoMH8hFOSIXtyj3I9W2a70SVogjyw/cFnSnHBZj7K/1bpJ1gqGv6BO1Ctfiu4hJJW2nm2wdzoDTu9wUUTgKfAZVV6TrloKwIEk6E0nMpR9TmrU612Bb4KLNVlQFEvBs5w01ZJAfyK2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nOy4ugC1; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734809; x=1747270809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+6tj0kEKZAuUZugRM5HgXHgBCG9pzGLg+BLWoV5ezpM=;
  b=nOy4ugC1lSOA3L5juhZaKHEFM0JrooZMkKrefZuLDxx/7bP/NKmDih6q
   93xuDPn9SZcKy7UijJwZqlMzdeLKBDNqflMyXn2RbKzXoErfdq+Z7ud8t
   pRoS3+L7WH9jNXqAUC2LTezh+joU1MXsmQxLi6+GCuiwfwVbmcT4yes6T
   zb8dHEHTCsGSl/ThrD3FQXuhv+RYG7z+gKfYE2AsJoj19g12ZvDax/gHN
   lLfYKDgWBA6pYaIgGAn+rAD+cv79z3p0ip6agFLdBCQorprUI7pFcau3k
   k3tBofCh3557UhYOzkUQUz3NDAYxbcu2M6gLbs2umEotX2dImd1octJfv
   A==;
X-CSE-ConnectionGUID: wODc1ON9TVCTOF3fHbs+lg==
X-CSE-MsgGUID: LUCFnbToQb6dY0cP9D6wBw==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613963"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613963"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:05 -0700
X-CSE-ConnectionGUID: bbyX+Y9bRnCQGjviptusEw==
X-CSE-MsgGUID: GMk516bPQ/inx3OLKItl4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942765"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:04 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is called for TDX
Date: Tue, 14 May 2024 17:59:44 -0700
Message-Id: <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When virtualizing some CPU features, KVM uses kvm_zap_gfn_range() to zap
guest mappings so they can be faulted in with different PTE properties.

For TDX private memory this technique is fundamentally not possible.
Remapping private memory requires the guest to "accept" it, and also the
needed PTE properties are not currently supported by TDX for private
memory.

These CPU features are:
1) MTRR update
2) CR0.CD update
3) Non-coherent DMA status update
4) APICV update

Since they cannot be supported, they should be blocked from being
exercised by a TD. In the case of CRO.CD, the feature is fundamentally not
supported for TDX as it cannot see the guest registers. For APICV
inhibit it in future changes.

Guest MTRR support is more of an interesting case. Supported versions of
the TDX module fix the MTRR CPUID bit to 1, but as previously discussed,
it is not possible to fully support the feature. This leaves KVM with a
few options:
 - Support a modified version of the architecture where the caching
   attributes are ignored for private memory.
 - Don't support MTRRs and treat the set MTRR CPUID bit as a TDX Module
   bug.

With the additional consideration that likely guest MTRR support in KVM
will be going away, the later option is the best. Prevent MTRR MSR writes
from calling kvm_zap_gfn_range() in future changes.

Lastly, the most interesting case is non-coherent DMA status updates.
There isn't a way to reject the call. KVM is just notified that there is a
non-coherent DMA device attached, and expected to act accordingly. For
normal VMs today, that means to start respecting guest PAT. However,
recently there has been a proposal to avoid doing this on selfsnoop CPUs
(see link). On such CPUs it should not be problematic to simply always
configure the EPT to honor guest PAT. In future changes TDX can enforce
this behavior for shared memory, resulting in shared memory always
respecting guest PAT for TDX. So kvm_zap_gfn_range() will not need to be
called in this case either.

Unfortunately, this will result in different cache attributes between
private and shared memory, as private memory is always WB and cannot be
changed by the VMM on current TDX modules. But it can't really be helped
while also supporting non-coherent DMA devices.

Since all callers will be prevented from calling kvm_zap_gfn_range() in
future changes, report a bug and terminate the guest if other future
changes to KVM result in triggering kvm_zap_gfn_range() for a TD.

For lack of a better method currently, use kvm_gfn_shared_mask() to
determine if private memory cannot be zapped (as in TDX, the only VM type
that sets it).

Link: https://lore.kernel.org/all/20240309010929.1403984-6-seanjc@google.com/
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - Remove support from "KVM: x86/tdp_mmu: Zap leafs only for private memory"
 - Add this KVM_BUG_ON() instead
---
 arch/x86/kvm/mmu/mmu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d5cf5b15a10e..808805b3478d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6528,8 +6528,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
-	if (tdp_mmu_enabled)
+	if (tdp_mmu_enabled) {
+		/*
+		 * kvm_zap_gfn_range() is used when MTRR or PAT memory
+		 * type was changed.  TDX can't handle zapping the private
+		 * mapping, but it's ok because KVM doesn't support either of
+		 * those features for TDX. In case a new caller appears, BUG
+		 * the VM if it's called for solutions with private aliases.
+		 */
+		KVM_BUG_ON(kvm_gfn_shared_mask(kvm), kvm);
 		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
+	}
 
 	if (flush)
 		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
-- 
2.34.1


