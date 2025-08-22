Return-Path: <kvm+bounces-55488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A5AB31110
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 10:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D343560719E
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 08:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5A82EA48B;
	Fri, 22 Aug 2025 08:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pr2Ni+pF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE3C17BA3;
	Fri, 22 Aug 2025 08:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849732; cv=none; b=UvvBVgWHSdsSu+3Hn3rFxks04tS26ZhoManJOB46mSVKLAKzPsQVh6jvVkoS5lTRoMLoV3obMTv3M/p5A83u6tNYqzinzTX0iZtuMAl+hTX6boXzA56XLMT3LI0rWZm6oTm8u0hd0QliGTDUEv3v64keWFdtbNK1eZ2jwkLleNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849732; c=relaxed/simple;
	bh=Mz8tUStcgjbbl3K6GnMgZXqnsGG9VQy723c9+S7cXKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hl2IY8V7dkTBNoQ3SnT3nxmP+SUazM1CTVk6lZ75sbf+z4HICCPVcgnc8fO4VSB1mrY2mN6NRasoXAi9WK6vFrXAmOkLBI7rvHeBvTibkJTJUbOXqrI4dqo1U3mTfDdNBRQNCIpNdQ97VUmjk0HMTwvsbAFNK/fWhs3qaUC9dnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pr2Ni+pF; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755849731; x=1787385731;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Mz8tUStcgjbbl3K6GnMgZXqnsGG9VQy723c9+S7cXKY=;
  b=Pr2Ni+pFhj7Psv9OK9ugT1fFibmSicrqpy5HJZ4gbens/UaBAnfpEyIf
   WDDJvfBqpSsxRhwdhaqk2bIPefmZXUbruzi/g6UHFCaYwF0flHbBzZQUy
   WU3v53PrGXm3dgpzgv/U4okZTtql6BjJ7pvkRiEDJLzrx3no8rBC8uWc0
   Qpio4tsRk4QoP4EamFrWMWjWu+0VCXJ6fRmyBlfspqYmxbMHbJjSp+u9V
   iT0KtG/q8AOat/vnHOF/pZh4v6kerstZ5y/rNamIROen0QTfL1WjNwimK
   PHEDFr74G2cFFSWY7NE52rUXJPeYhxcx8sz2yBJh0YMnajP8SCnP8coax
   g==;
X-CSE-ConnectionGUID: /hEH82SrQUKd6lmG3sZZOw==
X-CSE-MsgGUID: NyUCGl7kTOmrh36+b7a3Rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69592260"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="69592260"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:02:10 -0700
X-CSE-ConnectionGUID: wSNCe5crQT2F9fzcHP6ZuA==
X-CSE-MsgGUID: s4Cd5KeDR0my/RRWS5lnLA==
X-ExtLoop1: 1
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:02:07 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 0/3] KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
Date: Fri, 22 Aug 2025 16:01:00 +0800
Message-ID: <20250822080100.27218-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
This series addresses a bug where userspace can request KVM to reset dirty
GFNs in memslots that do not have dirty tracking enabled.

Patch 1 provides the fix.
Patch 2 is an optimization to avoid unnecessary invoking of handlers in
        kvm_handle_hva_range() when a GFN range is entirely private.

        Patch 2 is not directly related to the issue in this series, but
        was found while implementing the selftest in patch 3. It also
        enhance reliability of the selftest results in patch 3 by ruling
        out the zap-related changes to private mappings of the test slot.

Patch 3 converts the TDX-specific selftest in v2 to test
        KVM_X86_SW_PROTECTED_VM VMs.

        Unlike TDX cases which would generate KVM_BUG_ON() when GFNs are
        incorrectly reset in memslots not enabling dirty tracking, there
        are not obvious errors for KVM_X86_SW_PROTECTED_VMs. So, patch 3
        detects the event kvm_tdp_mmu_spte_changed instead.

        Will provide TDX cases once the TDX selftest framework is
        finalized.

v3:
- Rebased patch 1.
- Added patch 2.
- Converted patch 3 to test KVM_X86_SW_PROTECTED_VM VMs.
- code base: kvm-x86-next-2025.08.21

v2: https://lore.kernel.org/all/20241223070427.29583-1-yan.y.zhao@intel.com
- Added a comment in patch 1, explaining that it's possible to try to
  update a memslot that isn't being dirty-logged if userspace is
  misbehaving. Specifically, userspace can write arbitrary data into the
  ring. (Sean)

v1: https://lore.kernel.org/all/20241220082027.15851-1-yan.y.zhao@intel.com


Yan Zhao (3):
  KVM: Do not reset dirty GFNs in a memslot not enabling dirty tracking
  KVM: Skip invoking shared memory handler for entirely private GFN
    ranges
  KVM: selftests: Test resetting dirty ring in gmem slots in protected
    VMs

 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/x86/reset_dirty_ring_on_gmem_test.c   | 392 ++++++++++++++++++
 virt/kvm/dirty_ring.c                         |   8 +-
 virt/kvm/kvm_main.c                           |  11 +
 4 files changed, 411 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86/reset_dirty_ring_on_gmem_test.c

-- 
2.43.2


