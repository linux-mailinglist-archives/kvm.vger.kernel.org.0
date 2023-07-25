Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0EE76268B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbjGYWYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjGYWXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:23:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4044A55B8;
        Tue, 25 Jul 2023 15:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323521; x=1721859521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/ls1BzqS9FKY4HkJaupcxI2ZIkdzdAwcHI/XSkpQbg0=;
  b=SyqGjzF7TLfl/BvUJXcAGQCeogsNq9YkdRa/iry2rRk+9vODAQCaTS+O
   82xDaYQTiXccEj4wDDAJKdZOteTiBr6BPX+50M0MQjk/CkQj6E/pRRUBP
   bJCA8WYYGoIX2z4mhWSIPM4EvqW+n5R4fBgAiVhObHZY33aMT+KHj+REZ
   3JpcNE5ZC9uK3dxz6BePx4abE/Gzmj7RSCngY3n1kFUTAo5UI2T04YXUS
   gEKNQW0HdZyvbjKss8V75BTDweNczw6KQnr/PyvZxPBCDhzo5n1e2DJ7f
   aptoB+B9mWUWXec+aqhpJRcGyBzUoznmOO1Ayc+f8KQS9GMeY1pEpfGih
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882732"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882732"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001927"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001927"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:05 -0700
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
Subject: [PATCH v15 099/115] KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL
Date:   Tue, 25 Jul 2023 15:14:50 -0700
Message-Id: <ab4630745760a4c9b2345d70d39963c7aac452d6.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 3775db455f29..77052f49481a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1806,6 +1806,7 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 		default:
 			return true;
 		}
+	case MSR_IA32_FEAT_CTL:
 	case MSR_IA32_APICBASE:
 	case MSR_EFER:
 		return !write;
@@ -1820,6 +1821,20 @@ bool tdx_has_emulated_msr(u32 index, bool write)
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
@@ -1838,6 +1853,11 @@ int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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

