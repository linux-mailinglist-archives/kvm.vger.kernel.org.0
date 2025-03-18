Return-Path: <kvm+bounces-41337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DC3A66521
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 805703A383A
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB3385626;
	Tue, 18 Mar 2025 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVEGsyI7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1E14A1E;
	Tue, 18 Mar 2025 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261537; cv=none; b=BHu5B9UBvrJnZ6Pra0uhpIhrK6tweQWvvkgTTX/P4Id0HgvLG+6hoiOvvvXVxELqZ7PA5+wVyPwmxhiSJpuffi2nge0wZDGvr07D+gvI8i81bkogCbDrVVvTGd2cp1gImnMiMpsTymG0WCfEpP5tQ6aWTK/cP7UXN4bZcqAqxIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261537; c=relaxed/simple;
	bh=JqoOq8Gr37++ZkptHw5jlUSyMIDAfo5oUptOSpaWASc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cz1RvTAVnKp42YzBKEKhrkJvojwhMbiCE95dCeVA6bW6xxvqH3XOwhWBbzBSRJGUUDDlxPJewTTmEeDj3aryDp+9BzdUjbNJaKuR8OiMc7Qqji2naJxxi2tq+ZhIuurwZpuFd1HD1BAh91wrzSfYor22kmClB92pkF7E4RMjp+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVEGsyI7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742261536; x=1773797536;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JqoOq8Gr37++ZkptHw5jlUSyMIDAfo5oUptOSpaWASc=;
  b=mVEGsyI7MVUTCx22LxqGJxOEi0Fy+YFqIaXojHkk2xy4ZeXLQjZ59nCp
   e03+tiraZC5CeB/q4+73k9GKUIvTA7tdI012n2J8VCWAwhaUeJKceK7ah
   2Z0Fztzs9c9rFsmiixuRMXvfymUDXeDOUePExiOG6UmCLJQdPS+wNRcA4
   5+udzTb0LNONuAY0Ikm3NPltQk9iAu1T73g1wX4UBeDjEukuAMbBx/FmN
   h9c939f5VM7/pM4hrq1RvTopoXgAoh2xwBKRtKh4Bo0Ewhj6pDZ9/DBfJ
   CWwtggEUrdj/otqDUkpJ6lb/E2r4Y3gw9cQkSEUMJNH4hlaUliYg4r8jO
   A==;
X-CSE-ConnectionGUID: Hml0xSutRpq9+LCMGdM0DQ==
X-CSE-MsgGUID: 4fCmZeCFQRGGpbT4jqszHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="42627954"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="42627954"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:32:15 -0700
X-CSE-ConnectionGUID: 9QX0+Jz6STe4sAjFd6Jwjg==
X-CSE-MsgGUID: FK3WfwW2T8ajngI1rtXR3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="122052992"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:32:14 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/5] Small changes related to prefetch and spurious faults
Date: Tue, 18 Mar 2025 09:30:37 +0800
Message-ID: <20250318013038.5628-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi

This is v2 of the series for some small changes related to
prefetch/prefault and spurious faults.

Patch 1: Checks if a shadow-present old SPTE is leaf to determine a
         prefetch fault is spurious.

Patch 2: Merges the checks for prefetch and is_access_allowed() for
         spurious faults into a common path.

Patch 3: Adds a warning when the PFN changes on a spurious fault in the TDP
         MMU

Patch 4: Adds a warning when the PFN changes on a shadow-present SPTE in
         the shadow MMU. This implementation differs from the v1
         discussion. Upon reconsideration, I realized that WARN_ON_ONCE()
         in mmu_spte_update() cannot warn when the PFN changes on a
         shadow-present SPTE. Add the warning in mmu_set_spte() and have 
         the prefetch fault to leverage the warning.

Patch 5: Checks req and frees obsolete roots in each MMU reload.

With below scenario
1. add a memslot with size 4K
2. prefault GPA A in the memslot
3. delete the memslot
4. re-add the memslot with size 2M
5. prefault GPA A again.

Patch 1 is required if zap all quirk is disabled in step 3.
Patch 5 is required if zap all is performed in step 3 and if step 2/5 are
        executed before any vcpu_run().

Change log:
v2:
- Check both fault->prefetch and is_access_allowed() in patch 2. (Sean)
- Split patch 3 in v1 into patches 3 and 4.
- Only warn on PFN changes in case of spurious fault in TDP MMU in patch 3.
  (Sean).
- Add patch 4 to warn on PFN changes on shadow-present SPTE in shadow MMU.
- Move kvm_mmu_free_obsolete_roots() from kvm_arch_vcpu_pre_fault_memory()
  to kvm_mmu_reload() in patch 5. (Sean)

Thanks
Yan

v1: https://lore.kernel.org/all/20250207030640.1585-1-yan.y.zhao@intel.com

Yan Zhao (5):
  KVM: x86/mmu: Further check old SPTE is leaf for spurious prefetch
    fault
  KVM: x86/tdp_mmu: Merge prefetch and access checks for spurious faults
  KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults
  KVM: x86/mmu: Warn if PFN changes on shadow-present SPTE in shadow MMU
  KVM: x86/mmu: Check and free obsolete roots in kvm_mmu_reload()

 arch/x86/kvm/mmu.h         | 3 +++
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)

base-commit: c9ea48bb6ee6b28bbc956c1e8af98044618fed5e
-- 
2.43.2

