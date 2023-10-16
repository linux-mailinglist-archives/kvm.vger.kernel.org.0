Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1CA7CAFB2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbjJPQg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbjJPQf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:35:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8096A57;
        Mon, 16 Oct 2023 09:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473316; x=1729009316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CKuSpPInfTsyQSZPtZYPThCgg90sYoCDCtZz1uDkXfI=;
  b=eKQ8Zm4/hLswAPWQwMAOnvxQSMWd4JUvqBh7iKECM/DDls/xDS7pfZPt
   pNhaZlVqVQUuwkG+guajHy2tQhv79kQGPVMFEo0mVmkrV4zAqAvM1Y2MT
   YWxUrnjNgyp3Z6TkTyVE8ZdHZnMlRTnGNpL/Ks0Y4NANw8Hp7gg/5LBEY
   zyK70h82iSn/MDM87yfwdGqAN1M5TKFyGnofovu0s1O1AFsVqPmlihAAR
   g/PqrANMSqfprjCVDXJFuOpJDtmPhoZ9a82NVKkLNfxp+03Uic9EEmaG2
   T17J+FDoeB1z/Sjusvilu8Es2+mrE8Hd3JPUmKUKTiTmK2hcJg56yOAeB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922084"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922084"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448332"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448332"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:07 -0700
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
Subject: [PATCH v16 098/116] KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL
Date:   Mon, 16 Oct 2023 09:14:50 -0700
Message-Id: <eec33adef4bb65636e96a3298dfe2af3e052bb3f.1697471314.git.isaku.yamahata@intel.com>
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

MCE and MCA is advertised via cpuid based on the TDX module spec.  Guest
kernel can access IA32_FEAT_CTL for checking if LMCE is enabled by platform
and IA32_MCG_EXT_CTL to enable LMCE.  Make TDX KVM handle them.  Otherwise
guest MSR access to them with TDG.VP.VMCALL<MSR> on VE results in GP in
guest.

Because LMCE is disabled with qemu by default, "-cpu lmce=on" to qemu
command line is needed to reproduce it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 726e28f30354..7f8c89fd556a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1950,6 +1950,7 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 		default:
 			return true;
 		}
+	case MSR_IA32_FEAT_CTL:
 	case MSR_IA32_APICBASE:
 	case MSR_EFER:
 		return !write;
@@ -1964,6 +1965,20 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_FEAT_CTL:
+		/*
+		 * MCE and MCA are advertised via cpuid. guest kernel could
+		 * check if LMCE is enabled or not.
+		 */
+		msr->data = FEAT_CTL_LOCKED;
+		if (vcpu->arch.mcg_cap & MCG_LMCE_P)
+			msr->data |= FEAT_CTL_LMCE_ENABLED;
+		return 0;
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		msr->data = vcpu->arch.mcg_ext_ctl;
+		return 0;
 	case MSR_MTRRcap:
 		/*
 		 * Override kvm_mtrr_get_msr() which hardcodes the value.
@@ -1982,6 +1997,11 @@ int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		vcpu->arch.mcg_ext_ctl = msr->data;
+		return 0;
 	case MSR_MTRRdefType:
 		/*
 		 * Allow writeback only for all memory.
-- 
2.25.1

