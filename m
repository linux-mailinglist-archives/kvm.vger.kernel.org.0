Return-Path: <kvm+bounces-21612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CBF930D39
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB26F1C20E2F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985B4139D05;
	Mon, 15 Jul 2024 04:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gcE19d4g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12921843
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018061; cv=none; b=enM1eilm6ILIaPUvYvGWXa5vUUxP9H55Gzrz043QOB1oGKF4vh5dgiCzYswLMCKoA+iyPjPLO/G/yLbsuegWBf7Km1UIMrQlN3WX2Tukg5HHZtYnRKtoVtbiefGKZ20FR1+n8n0yn41xUXbI9PE+FAKrxsBL4BMDoa2HfcYQ4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018061; c=relaxed/simple;
	bh=+kWBSksCjwdQpHlmtbr87XOClMos7SBe4fOvnuHZMAU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F2ISv+s2blaZZineD49EdxGF9e6RzNKE5mYME2obl1grdrZl8mBklFLx/b8+DGl/pWMQcwSxde37OC51sWac4f5P7l0b4EVIs4T2MU49AKBXjpmDGoPCVhTpooPWaBML4AxSgftieBoYnyu5+nz7rCEf7poo/zkxEEsJd9hhSHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gcE19d4g; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018060; x=1752554060;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+kWBSksCjwdQpHlmtbr87XOClMos7SBe4fOvnuHZMAU=;
  b=gcE19d4ghVlGbiKV6pzvoE/mkbN3SB6VMoq+WZvzehujg1gNO53Dz08C
   EsMp7FXw3JfhFXG6b04FHZCaHjWZsFMSHd6ALaLAVon/qfIR852apukuP
   qMNJRpBSTspHziMYt9CNvJdTpkW+M9OH4dpgHiBUoAiILnGYKzfq2Mqkd
   wYNOx1172NrCvFkuu0X8NG+jG/q8D82AuZ0xWZSMeiD+XNRQz+QaQYbp5
   dj/JbFTRHenFAqbd/knOx0xmU1Gd810mK9pQT9XnL+fsfo8x0JKFQwBfX
   r78YtoP3FHgb/FN5AXfRawyCPZm1uWYgu5cChphTINokVFZrJMPtVjU0R
   g==;
X-CSE-ConnectionGUID: AuEPRbAXTXG5emdN/iuILA==
X-CSE-MsgGUID: UfigbOk4SjWBbpIQIdSqEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809792"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809792"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:20 -0700
X-CSE-ConnectionGUID: bC8wDrE7S1Onq3QSDONJhA==
X-CSE-MsgGUID: XKOiyfdTRqCpV/EAIU1onA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043024"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:16 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 0/8] [PATCH v3 0/8] target/i386: Misc cleanup on KVM PV defs, outdated comments and error handling
Date: Mon, 15 Jul 2024 12:49:47 +0800
Message-Id: <20240715044955.3954304-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is my v3 cleanup series. Compared with v2 [1],
 * v3 resolved the rebasing conflict (now based on 37fbfda8f414).
 * Added 2 more patches (patch 7&8) to clean up error handling in
   kvm_arch_init().


Background and Introduction
===========================

This series picks cleanup from my previous kvmclock [2] (as other
renaming attempts were temporarily put on hold).

In addition, this series also include the cleanup on a historically
workaround, recent comment of coco interface [3] and error handling
corner cases in kvm_arch_init().

Avoiding the fragmentation of these misc cleanups, I consolidated them
all in one series and was able to tackle them in one go!

[1]: https://lore.kernel.org/qemu-devel/20240506085153.2834841-1-zhao1.liu@intel.com/
[2]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
[3]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (8):
  target/i386/kvm: Add feature bit definitions for KVM CPUID
  target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
    MSR_KVM_SYSTEM_TIME definitions
  target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
  target/i386/kvm: Save/load MSRs of kvmclock2
    (KVM_FEATURE_CLOCKSOURCE2)
  target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
  target/i386/confidential-guest: Fix comment of
    x86_confidential_guest_kvm_type()
  target/i386/kvm: Clean up return values of MSR filter related
    functions
  target/i386/kvm: Clean up error handling in kvm_arch_init()

 hw/i386/kvm/clock.c              |   5 +-
 target/i386/confidential-guest.h |   2 +-
 target/i386/cpu.h                |  25 +++++++
 target/i386/kvm/kvm.c            | 108 ++++++++++++++++++-------------
 target/i386/kvm/kvm_i386.h       |   4 +-
 5 files changed, 92 insertions(+), 52 deletions(-)

-- 
2.34.1


