Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F8B7CB040
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbjJPQt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbjJPQi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:38:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E5ED45;
        Mon, 16 Oct 2023 09:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473221; x=1729009221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IE6cbNbn0JKTGcfnHBngX+2clwW0GTKTNqLO3PLcaX0=;
  b=YgCxSoUELvsrRPb+fREHvW1/4GN+pxULVTmj74o3QXyU66h1VTdTj9c3
   +9n2xPDPyVobYr2HRUyEgoSkwWYB+A2r9qX5O02uYcSBsLIlwIaY8dA7P
   q+aygj2ayi4WIyn2VuFE5S4umChV5B7ZvXnkOrUNSuBhf+WQ9kOzPjCYf
   6ftCaIl9CsrcCTTb9KDXHcNoLa6ngk3uvIaK8jZ+IU46A/KcENf/dWeZ7
   IdFDQSxo+UmnZJGHC00y1eU3Qlwc2pO9Jm9Oj9Lb6QbRfYUIXetvwj6aX
   xvjXuMb81K1ajuizBjzJqENdiKsoHMbTqVqHw9x8XLPlJ38uCpHwS67nk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922016"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922016"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448279"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448279"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 087/116] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI
Date:   Mon, 16 Oct 2023 09:14:39 -0700
Message-Id: <f9c047ba60eb29b49ab3756608a5e4c7333f8230.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When BIOS eMCA MCE-SMI morphing is enabled, the #MC is morphed to MSMI
(Machine Check System Management Interrupt).  Then the SMI causes TD exit
with the read reason of EXIT_REASON_OTHER_SMI with MSMI bit set in the exit
qualification to KVM instead of EXIT_REASON_EXCEPTION_NMI with MC
exception.

Handle EXIT_REASON_OTHER_SMI with MSMI bit set in the exit qualification as
MCE(Machine Check Exception) happened during TD guest running.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx_arch.h |  2 ++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6bed75c4069c..44558f1c13e4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -890,6 +890,30 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 						     tdexit_intr_info(vcpu));
 	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
+	else if (unlikely(tdx->exit_reason.non_recoverable ||
+		 tdx->exit_reason.error)) {
+		/*
+		 * The only reason it gets EXIT_REASON_OTHER_SMI is there is an
+		 * #MSMI(Machine Check System Management Interrupt) with
+		 * exit_qualification bit 0 set in TD guest.
+		 * The #MSMI is delivered right after SEAMCALL returns,
+		 * and an #MC is delivered to host kernel after SMI handler
+		 * returns.
+		 *
+		 * The #MC right after SEAMCALL is fixed up and skipped in #MC
+		 * handler because it's an #MC happens in TD guest we cannot
+		 * handle it with host's context.
+		 *
+		 * Call KVM's machine check handler explicitly here.
+		 */
+		if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
+			unsigned long exit_qual;
+
+			exit_qual = tdexit_exit_qual(vcpu);
+			if (exit_qual & TD_EXIT_OTHER_SMI_IS_MSMI)
+				kvm_machine_check();
+		}
+	}
 }
 
 static int tdx_handle_exception(struct kvm_vcpu *vcpu)
@@ -1372,6 +1396,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 			      exit_reason.full, exit_reason.basic,
 			      to_kvm_tdx(vcpu->kvm)->hkid,
 			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
+
+		/*
+		 * tdx_handle_exit_irqoff() handled EXIT_REASON_OTHER_SMI.  It
+		 * must be handled before enabling preemption because it's #MC.
+		 */
 		goto unhandled_exit;
 	}
 
@@ -1410,9 +1439,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_handle_ept_misconfig(vcpu);
 	case EXIT_REASON_OTHER_SMI:
 		/*
-		 * If reach here, it's not a Machine Check System Management
-		 * Interrupt(MSMI).  #SMI is delivered and handled right after
-		 * SEAMRET, nothing needs to be done in KVM.
+		 * Unlike VMX, all the SMI in SEAM non-root mode (i.e. when
+		 * TD guest vcpu is running) will cause TD exit to TDX module,
+		 * then SEAMRET to KVM. Once it exits to KVM, SMI is delivered
+		 * and handled right away.
+		 *
+		 * - If it's an Machine Check System Management Interrupt
+		 *   (MSMI), it's handled above due to non_recoverable bit set.
+		 * - If it's not an MSMI, don't need to do anything here.
 		 */
 		return 1;
 	default:
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index fc9a8898765c..9f93250d22b9 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -47,6 +47,8 @@
 #define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
 
+#define TD_EXIT_OTHER_SMI_IS_MSMI	BIT(1)
+
 /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
 #define TDX_NON_ARCH			BIT_ULL(63)
 #define TDX_CLASS_SHIFT			56
-- 
2.25.1

