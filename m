Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40612556ED
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgH1IyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:54:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:49188 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbgH1IyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 04:54:18 -0400
IronPort-SDR: 6K6yxi1qPBxGHRxORFCfpBBUTIurq/HYENa5bm3Jp/HcQQXshHUxMoJuhLiozGR2QunhVV7viP
 kpFTT+k9uWHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136697492"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="136697492"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:54:17 -0700
IronPort-SDR: FdBPY3Wb3ZnxKgIX5+W6fCAxdji7IEmbqsARIQhx0v9wPie+7yfoF1Znfgoln/HsRTB+nbC/9d
 PibXQYMbD3+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="332483490"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2020 01:54:15 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: nVMX: Fix VMX controls MSRs setup when nested VMX enabled
Date:   Fri, 28 Aug 2020 16:56:18 +0800
Message-Id: <20200828085622.8365-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828085622.8365-1-chenyi.qiang@intel.com>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM supports the nested VM_{EXIT, ENTRY}_LOAD_IA32_PERF_GLOBAL_CTRL and
VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS, but they doesn't expose during
the setup of nested VMX controls MSR.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 23b58c28a1c9..6e0e71f4d45f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6310,7 +6310,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
-		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
+		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6329,7 +6330,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
 
-- 
2.17.1

