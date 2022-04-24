Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E750D10D
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239025AbiDXKTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiDXKTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:19:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FD02A70E;
        Sun, 24 Apr 2022 03:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795360; x=1682331360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1HVGt2MfbFAhIqpB5yM3pi/exzDn5R49eSSkwTGqR4=;
  b=ldOvGh1JoeHpyzGjKbU5FfQHvr2idu2De6YDxFHC+ttUivtLhLmVCevo
   mor9wdJee7/mSFkKj+UUROyqmN0jfzXuKOLaMsPPE35zmFYyTo40VHwxk
   aGcDP1tfxXzinsg1eRGj+vQ1pYFmEBFhatmCU9g38qKd6Oy2KoK16erWz
   2EMA+CPD4E8AFtkWjhzTdSl3itgvnOLVsABdXPkq0Ff5DV2F4eXzKzLQF
   sNxiv5ynbJEgeO5flI32NUdGGp1HbmuoCFddJSDkXreg3h7FU0T0F29cx
   3keybRtEd6XM/aOAaASd1jIF85H0PikgC/09SpgK1tgkP/xz8OEAosR4U
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813942"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813942"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086707"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:58 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/8] KVM: VMX: Introduce PKS VMCS fields
Date:   Sun, 24 Apr 2022 03:15:50 -0700
Message-Id: <20220424101557.134102-2-lei4.wang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220424101557.134102-1-lei4.wang@intel.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

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
2.25.1

