Return-Path: <kvm+bounces-7901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0488484A3
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7689828D1B1
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE535D738;
	Sat,  3 Feb 2024 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJh6d7hv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D7E5C61F;
	Sat,  3 Feb 2024 09:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950829; cv=none; b=WV9LJdm+Byfpc7XIRQJjZle0XtYGTyrLvEvzAm37+dnSG4gU3NCuIxvcLTiwkktY9Vm/5bWe0Uc+gexQg7XEKgeiW3oGQk6PWWRpXJtPMNhyO8UfdRvIgrskdD/uEW+A1EGkSbd0LijAX29Xa9YRbJYPDlgz/EhLRyAtLxKZ7TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950829; c=relaxed/simple;
	bh=SCjjaAWB7G5busdQtgw95kBzyDRKHqtVEz1Bv3Q2lXo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qC0ybgDqc6+0ucFY0DJtTvRlLGxheCAbWlh10XWYUaYpJXIO1MoDeonMAADHCJexyjqLrAAhbypU/tDW/Q5q2yrLKJka7Prz6T+L3xvTOiqmWqGSZ04lT6ErQcAVH+qc9h5jBV0ZAq88h5wmUTqiNBp6snyn12ZWoxg0rhSxN1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJh6d7hv; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950828; x=1738486828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SCjjaAWB7G5busdQtgw95kBzyDRKHqtVEz1Bv3Q2lXo=;
  b=kJh6d7hv6OGZ80CVV+AFZZcrJ/XlBPL7M38Z1rj8bYO4bj5FRjjCQFRE
   OPxmDuCxCDUt7/BWpaJt0NocHZ27wKTdXGfNZ/LPcBizK87UXkBKs52gy
   MSG03aLL0plHfAvJF4KnEsEigtDB3WWmzKo0LDVsXpAL5qax2LdtV14JZ
   vMSM/+zUsi3/sWoMaYeWuuiC2aHgLt2V+eoQxO8kDR8BBXT1hc9AiekQq
   9E+PVq6Kp9XHNEAGjxI62QHedLrqv7fZffQXNCWyRN4kRAsm5mSSCbozD
   bOSyTuyHf/0q5ItWyivr7hEPHfp6jy61sz+5bAWjhEUronu/v55NqnzDt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131903"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131903"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291244"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:09 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 05/26] KVM: x86: Reset hardware history at vCPU's sched_in/out
Date: Sat,  3 Feb 2024 17:11:53 +0800
Message-Id: <20240203091214.411862-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Reset the classification history of the vCPU thread when it's scheduled
in and scheduled out. Hardware will start the classification of the vCPU
thread from scratch.

This helps protect Host/VM history information from leaking Host history
to VMs or leaking VM history to sibling VMs.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 arch/x86/kvm/x86.c              | 8 ++++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2be78549bec8..b5b2d0fde579 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2280,8 +2280,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
-static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu) {}
-
 #define KVM_CLOCK_VALID_FLAGS						\
 	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 363b1c080205..cd9a7251c768 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -79,6 +79,7 @@
 #include <asm/div64.h>
 #include <asm/irq_remapping.h>
 #include <asm/mshyperv.h>
+#include <asm/hreset.h>
 #include <asm/hypervisor.h>
 #include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
@@ -12491,9 +12492,16 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		pmu->need_cleanup = true;
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
+
+	reset_hardware_history();
 	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
+void kvm_arch_sched_out(struct kvm_vcpu *vcpu)
+{
+	reset_hardware_history();
+}
+
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
-- 
2.34.1


