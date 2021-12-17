Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B56D478D01
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 15:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhLQOEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 09:04:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:3622 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231337AbhLQOEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 09:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639749852; x=1671285852;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8f+EpYdj1QZEprtvTs++0LFclKvQ7+GbPlaSA9nUkjM=;
  b=Ksg0vGROThfUenfj3tPQQK+zF2FPwAPQ+inxips1sO/psxik2V7scn34
   hE6CJBjg2GrxMzbBklpLKUcdLpkZ+R91SZTKZfpkQ9URyhALhSmISoyY7
   r9KMCUr9fF73IhWUkmY5D07IcMCgdy5AjWfn6WQObNKI9jTZ09cbMPkoW
   0lbOpSG7thoNJNeWrXf2ObU+qIMm86PGHnFQedQ2Y1na/6hkPFowa7gEG
   CSTXV4v6peGTIybXdUbV8A51P6ZO86FBuIsiHMUITIEb/JAJ7H7z+Nm6s
   e5NjOFuSjfFlZ7NlgqKcE3lPlbuc/HzQPDqLtfOMOXFGo2k7dczn3yEVp
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239709543"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239709543"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 06:04:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="519759409"
Received: from devel-wwang.sh.intel.com ([10.239.48.106])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2021 06:04:10 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Date:   Fri, 17 Dec 2021 07:49:34 -0500
Message-Id: <20211217124934.32893-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The fixed counter 3 is used for the Topdown metrics, which hasn't been
enabled for KVM guests. Userspace accessing to it will fail as it's not
included in get_fixed_pmc(). This breaks KVM selftests on ICX+ machines,
which have this counter.

To reproduce it on ICX+ machines, ./state_test reports:
==== Test Assertion Failure ====
lib/x86_64/processor.c:1078: r == nmsrs
pid=4564 tid=4564 - Argument list too long
1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
3  0x00007fbe21ed5f92: ?? ??:0
4  0x000000000040264d: _start at ??:?
 Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)

With this patch, it works well.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cf1082455df..ed55f037619f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1331,7 +1331,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
-	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
+	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
-- 
2.25.1

