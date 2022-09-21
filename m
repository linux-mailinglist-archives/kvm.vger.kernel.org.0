Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115D75C04A6
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiIUQus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiIUQuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:50:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355755301C;
        Wed, 21 Sep 2022 09:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663778738; x=1695314738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cp1pNg+16opBPY1j2Ba8kIc+eTwZIbA4gQJJdqATjn0=;
  b=YducHbOjYHA/w9+s+pFGMNEiT9h/1SKuqy7H0VhF1z7tpILKknYo3r5h
   0ZjNyKtV9C2OleJnQr+pJ+ywKC55KMkHWbOEyrQX+klO6ZSmOgDkWDwUv
   Y6bHfjDtc8pxVhLgnL0uYGxFRpxjY+RdfjT0PZ1QRPwg07wOG7SORcLEa
   B43LXQN8DjXuEXo2BP/EygmqhQI2NUmpJk9Th14CtJcgSwvitDCHf9GSc
   P9pn6WJ0dfvReH13iHK6UFHR2Dxw0mweuMD+zmLe5hb4e73R3XLzpghmt
   v5qzRdG+xozhXhx0C88ZjkHF0AN8ARYttPA+XjuHwIcN+7qq+4C/Dhqh5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300044986"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="300044986"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 09:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="948227970"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 21 Sep 2022 09:45:33 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, wei.w.wang@intel.com,
        kan.liang@linux.intel.com
Cc:     xiaoyao.li@intel.com, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC PATCH v2 3/3] KVM: VMX: Stop/resume host PT before/after VMX transition when PT_MODE_HOST_GUEST
Date:   Thu, 22 Sep 2022 00:45:21 +0800
Message-Id: <20220921164521.2858932-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220921164521.2858932-1-xiaoyao.li@intel.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementation in pt_guest_enter() has two issues when pt mode
is PT_MODE_HOST_GUEST.

1. It relies on VM_ENTRY_LOAD_IA32_RTIT_CTL to disable host's Intel PT
   for the case that host enables PT while guest not.

   However, it causes VM entry failure due to violating the requirement
   stated in SDM "VM-Execution Control Fields"

     If the logical processor is operating with Intel PT enabled (if
     IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
     IA32_RTIT_CTL" VM-entry control must be 0.

2. In the case both host and guest enable Intel PT, it disables host's
   Intel PT by manually clearing MSR_IA32_RTIT_CTL for the purpose to
   context switch host and guest's PT configurations.

   However, PT PMI can be delivered later and before VM entry. In the PT
   PMI handler, it will a) update the host PT MSRs which leads to what KVM
   stores in vmx->pt_desc.host becomes stale, and b) re-enable Intel PT
   which leads to VM entry failure as #1.

To fix the above two issues, 1) grab and store host PT perf event and
disable/enable host PT before vm-enter/ after vm-exit. 2) drop host
pt_ctx and the logic to save/restore host PT MSRs since host PT driver
doesn't rely on the previous value of PT MSR, i.e., the re-enabling of PT
event after VM-exit re-initializes all the PT MSRs that it cares.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 31 +++++++++++++------------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..df1a16264bb6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1124,37 +1124,32 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
 
 static void pt_guest_enter(struct vcpu_vmx *vmx)
 {
+	struct perf_event *event;
+
 	if (vmx_pt_mode_is_system())
 		return;
 
-	/*
-	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
-	 * Save host state before VM entry.
-	 */
-	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
-	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
-		wrmsrl(MSR_IA32_RTIT_CTL, 0);
-		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
+	event = pt_get_curr_event();
+	if (event)
+		perf_event_disable_local(event);
+	vmx->pt_desc.host_event = event;
+
+	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN)
 		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
-	}
 }
 
 static void pt_guest_exit(struct vcpu_vmx *vmx)
 {
+	struct perf_event *event = vmx->pt_desc.host_event;
+
 	if (vmx_pt_mode_is_system())
 		return;
 
-	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
+	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN)
 		pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
-		pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
-	}
 
-	/*
-	 * KVM requires VM_EXIT_CLEAR_IA32_RTIT_CTL to expose PT to the guest,
-	 * i.e. RTIT_CTL is always cleared on VM-Exit.  Restore it if necessary.
-	 */
-	if (vmx->pt_desc.host.ctl)
-		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
+	if (event)
+		perf_event_enable_local(event);
 }
 
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 24d58c2ffaa3..4c20bdabc85b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -66,7 +66,7 @@ struct pt_desc {
 	u64 ctl_bitmask;
 	u32 num_address_ranges;
 	u32 caps[PT_CPUID_REGS_NUM * PT_CPUID_LEAVES];
-	struct pt_ctx host;
+	struct perf_event *host_event;
 	struct pt_ctx guest;
 };
 
-- 
2.27.0

