Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252B04BD7F7
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346822AbiBUIGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:06:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346810AbiBUIGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:06:20 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF38635E;
        Mon, 21 Feb 2022 00:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645430757; x=1676966757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=5VNRZNN7CqeqZx9FxLdMANtkHPO8VyZj8Jmc3XU1Ow8=;
  b=XBhYrprlixfhGhRHwrWnanH2TWfv739m3W7WZtk+/ZeWFAZc1DaUBvIx
   qkE5GoE5UdH064IsllWXjG4oHNUOO0nOFT2gGEBAV2gLIZ8Av0Q5ria0D
   KtZ3Dbd3zNXzhtk+8kPddjo3U/6VEWa/ZXXgYDCw6SpATdB7RgBUuoqrN
   Q6BLS3z4BIni5dID3xcCD8r6lC4+GXlWrB0dr8OwR36gHprouj3QDqlsO
   gSWIXJsjxEdURy2iXtTZv4vjWTPEcc3JOfJtwFq+MFJGs3h15lPbP+DU0
   Yg5g4WZpafPVdQeAGlcD2e/NYLi47xafqyUgw93WH9bQSNvyaZr0xhonm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="250277843"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="250277843"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:41 -0800
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="638472239"
Received: from unknown (HELO chenyi-pc.sh.intel.com) ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:38 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/7] KVM: VMX: Introduce PKS VMCS fields
Date:   Mon, 21 Feb 2022 16:08:34 +0800
Message-Id: <20220221080840.7369-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221080840.7369-1-chenyi.qiang@intel.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKS(Protection Keys for Supervisor Pages) is a feature that extends the
Protection Key architecture to support thread-specific permission
restrictions on supervisor pages.

A new PKS MSR(PKRS) is defined in kernel to support PKS, which holds a
set of permissions associated with each protection domain.

Two VMCS fields {HOST,GUEST}_IA32_PKRS are introduced in
{host,guest}-state area to store the respective values of PKRS.

Every VM exit saves PKRS into guest-state area.
If VM_EXIT_LOAD_IA32_PKRS = 1, VM exit loads PKRS from the host-state
area.
If VM_ENTRY_LOAD_IA32_PKRS = 1, VM entry loads PKRS from the guest-state
area.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/vmx.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..7962d506ba91 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -95,6 +95,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_IA32_PKRS			0x20000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -108,6 +109,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_PKRS			0x00400000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -245,12 +247,16 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_PKRS			= 0x00002818,
+	GUEST_IA32_PKRS_HIGH		= 0x00002819,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
 	HOST_IA32_EFER_HIGH		= 0x00002c03,
 	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
 	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
+	HOST_IA32_PKRS			= 0x00002c06,
+	HOST_IA32_PKRS_HIGH		= 0x00002c07,
 	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
 	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
 	EXCEPTION_BITMAP                = 0x00004004,
-- 
2.17.1

