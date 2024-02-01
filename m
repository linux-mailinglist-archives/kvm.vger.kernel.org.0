Return-Path: <kvm+bounces-7668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765A984513C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 07:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0DE5B29F09
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 06:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025E285C5A;
	Thu,  1 Feb 2024 06:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nzqp2sYE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC2784A2B;
	Thu,  1 Feb 2024 06:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706767664; cv=none; b=M75LZ2BGxFxOgy22iVCXPA/OdG6WxQ28iWyNEVdPmR/skhd2HuzKNXptTYWPrVB5tb7lC+19ZAwXouvlOhl+pQRZwV3jOIHQ64n8FNplJbJL9zS6L/nuWrf0nWle7vEgRgRk07lKK1u3blopbQMKscZ8813l/M2l03I08fdQ53M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706767664; c=relaxed/simple;
	bh=2Mh1AT0f2dbPt4JXsiALccjzvLIfnSSqSxigb7iI0+0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PabyGuUW3ASnOuRM+OWCLfZGNEPxA2z+mWt2qc6mZFFhbloRKzvrKaiTHbR0JJLK5HWtckhePWrP9W604kUmMXgS+Bj4ZOqQxdRkwIu6mVdkgdTW8rh1J58k6S86n27YxSxK36F6uaSK9Mkkcu8CdRnoniDw6c9smVblGq3u1yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nzqp2sYE; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706767663; x=1738303663;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2Mh1AT0f2dbPt4JXsiALccjzvLIfnSSqSxigb7iI0+0=;
  b=nzqp2sYEPWOnwkw6Fu6zI8vhn0lElEF4LmYPGHoXnJxAiWrTREJFVOkJ
   84ie2zE9xxZZzSXlIMQk5oNtXBobFUkpFhMhWRtIOsvZ7Mg7JQG+MzEhD
   glpBB9WpUY2O/Iu0p30nLGleOMXPyt8tlHE01R2CNdO/0pg3PAnGsSx6m
   dmt9aTjg4vZ8x/6VC2Swg49KVmPD+ZsfWJIO7sr3V1HKI/SFF/M9VExZe
   XhEyVCm/tsEvxStk2yr6PYDsakvx53fZx+JCyyFWItTK3pGQMXNViFp2r
   nSEtn4rhI2EL9rV/TMlnax0SQh/1ZegP4OdlCG3qQK6K35BSc1H2For+G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10574908"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="10574908"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 22:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="30776298"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 31 Jan 2024 22:07:39 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kan Liang <kan.liang@linux.intel.com>,
	Jim Mattson <jmattson@google.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH] KVM: selftests: Test top-down slots event
Date: Thu,  1 Feb 2024 14:15:05 +0800
Message-Id: <20240201061505.2027804-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although the fixed counter 3 and the exclusive pseudo slots events is
not supported by KVM yet, the architectural slots event is supported by
KVM and can be programed on any GP counter. Thus add validation for this
architectural slots event.

Top-down slots event "counts the total number of available slots for an
unhalted logical processor, and increments by machine-width of the
narrowest pipeline as employed by the Top-down Microarchitecture
Analysis method." So suppose the measured count of slots event would be
always larger than 0.

pmu_counters_test passed with this patch on Intel Sapphire Rapids.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index ae5f6042f1e8..99bcb619b861 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -117,6 +117,7 @@ static void guest_assert_event_count(uint8_t idx,
 		fallthrough;
 	case INTEL_ARCH_CPU_CYCLES_INDEX:
 	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
+	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
 		GUEST_ASSERT_NE(count, 0);
 		break;
 	default:

base-commit: f0f3b810edda57f317d79f452056786257089667
-- 
2.40.1


