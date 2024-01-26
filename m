Return-Path: <kvm+bounces-7118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD3A83D6B7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:45:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 881391C2A9D5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB7944387;
	Fri, 26 Jan 2024 08:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BVADkwOz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED5D14C5AE;
	Fri, 26 Jan 2024 08:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259494; cv=none; b=S7+Wedwg5/txyCBRC/Mc+LV0Fwf+dN0gfBZC2azIzhlxe/93OrBI3woV3yQDCIqbXGYixj369GFs9REgO/QKs9LQJT5N42pC931JthalTT1FcDytux1qQQLlUvoav/U8YVfBR1YxhfINV6XwZA5Hs+D5NnJGEjbEhapuj+zsHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259494; c=relaxed/simple;
	bh=LCLMFfglJdBAlQ+bO08mPrCWqyX9JhAyfb9lgPMTV8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A+mgtlWqg8cV1lnVOQqKvAZvTWeUiOU78PUEwFiu/LTQw7xyH8abqgVoJqBYIlEMzCUqVjbVBpqB8C0f6LyViTnhszNcdblLrt4mOBTJ5uhhowxq/YL5VHG8/Do8Ag7+Uv6dwyvL9fsLjyYpwE+dOJXwya/WochfVkrXGVAnRW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BVADkwOz; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259494; x=1737795494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LCLMFfglJdBAlQ+bO08mPrCWqyX9JhAyfb9lgPMTV8w=;
  b=BVADkwOzbWObRoh2JHCaGaw/q8w8iY0ASsfaS2iPrfBHStWAJa+mMaiE
   wIpyqdhQHX/rGDvOW5rws3ZqoNxkqJJWgHSwA6SZX92hVtnUBm1opcJVv
   PNggp7ZJAlkSJyS8R9mtTXv33NXtt0CLYeqMFijuOIRPNVZUNANurYqy2
   oAR/EGK94ekErGvhiJcDIlAIGLW1XwfrE/8HAdrjr8hvmxCRajggXEHO0
   WCHeAzArpwgt2GHGiGEtMA1QmYmY4hQWidDmBJ+4FFHBi0Hm+LMtrxVbk
   p11pqqur3aj1v3/vMqWKMuZFoKajcxI9bpfTndvAjKWLusowdKM3IfrHi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792859"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792859"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310401"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310401"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:08 -0800
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
Subject: [RFC PATCH 31/41] KVM: x86/pmu: Call perf_guest_enter() at PMU context switch
Date: Fri, 26 Jan 2024 16:54:34 +0800
Message-Id: <20240126085444.324918-32-xiong.y.zhang@linux.intel.com>
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

perf subsystem should stop and restart all the perf events at the host
level when entering and leaving the passthrough PMU respectively. So invoke
the perf API at PMU context switch functions.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cd559fd74f65..afc9f7eb3a6b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -906,12 +906,16 @@ void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
 	static_call_cond(kvm_x86_pmu_save_pmu_context)(vcpu);
 
 	perf_guest_switch_to_host_pmi_vector();
+
+	perf_guest_exit();
 }
 
 void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
 {
 	lockdep_assert_irqs_disabled();
 
+	perf_guest_enter();
+
 	perf_guest_switch_to_kvm_pmi_vector(kvm_lapic_get_lvtpc_mask(vcpu));
 
 	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
-- 
2.34.1


