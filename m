Return-Path: <kvm+bounces-7117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F23C483D6B9
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88F74B282A1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945EE14C5B8;
	Fri, 26 Jan 2024 08:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="arF9yBdW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F80314C5AE;
	Fri, 26 Jan 2024 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259489; cv=none; b=dlZbobPNs7K1iXg4awUad2LsQKXSRW3kaFY9H/RZGdNcGwnv72ih94aV1otvxNS+79qkvYAVLlLUboSdOgwBm8xJqKY/BxK4ls1Sn4ReI0necVhJb8XPwnWONpLmefXkV0t9SOn+187zSKSwA7FrOidU2JjORWHrNegqdUUKO0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259489; c=relaxed/simple;
	bh=dZmLN5UYCYxIGYOqBositsmrRXgoPvhOsIu6Doq4lJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TGNpkxEc900wNM8J6srGmwqbNMCbx438wSHVC/CXqqR5I3YavDcbXjmPVZ6v1TRXD9ZmpWUS8n4HH48yAsnH0E+YOw7Mnw5AHFjyBE9INnhn3DyltphTo6QZj6CXbWuckI0dowR4JDSchWjvAkfHNmJPLo4390NfryhuDhsLrN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=arF9yBdW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259489; x=1737795489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dZmLN5UYCYxIGYOqBositsmrRXgoPvhOsIu6Doq4lJ8=;
  b=arF9yBdWQrHNJQrm1nwROUZbUzWc1/lCIJ63tkS5RCnB6nY33do0Rmag
   i4Vup6YWUdd+Fbsg+TffDl9D+f9oa1Pxy4rNIv3699oH6ftlb9WpX+NOD
   fueQu2YXcaU7MIiO5jFtBtm93XLhDIbM7KCTqIXS1Z2i+oHtsq/LRKFZ9
   x551anbiXXZznWAqQaSog1b/B6gZXlxI5vLBmBI69RHNBWv03dAKJv99J
   hf1wTCXi0ZH28FkZ77DHgCv367snAXfC3JqhIe3GfMshi+TKxapvFySNH
   6e3eOAoNv0TUTFvc5YcrNRzJYLpoBE+n62qA2lhET8xxESJgvm5de9/Ve
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792821"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792821"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310377"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310377"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:03 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 30/41] KVM: x86/pmu: Switch PMI handler at KVM context switch boundary
Date: Fri, 26 Jan 2024 16:54:33 +0800
Message-Id: <20240126085444.324918-31-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiong Zhang <xiong.y.zhang@intel.com>

Switch PMI handler at KVM context switch boundary because KVM uses a
separate maskable interrupt vector other than the NMI handler for the host
PMU to process its own PMIs.  So invoke the perf API that allows
registration of the PMI handler.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9d737f5b96bf..cd559fd74f65 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -904,11 +904,15 @@ void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
 	lockdep_assert_irqs_disabled();
 
 	static_call_cond(kvm_x86_pmu_save_pmu_context)(vcpu);
+
+	perf_guest_switch_to_host_pmi_vector();
 }
 
 void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
 {
 	lockdep_assert_irqs_disabled();
 
+	perf_guest_switch_to_kvm_pmi_vector(kvm_lapic_get_lvtpc_mask(vcpu));
+
 	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
 }
-- 
2.34.1


