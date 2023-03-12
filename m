Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32346B6490
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCLJ73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCLJ7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604FA18B31
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615088; x=1710151088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+YdvXVUxNj9QXS7xa34gIYNx1wf4FPMK9gnOyWu91jA=;
  b=hgAMb+lMqro383CNn38n5yev6UBzKbxcVFDYbq0mlQspi9EGjuXaw4YK
   TGaenUmg4WUWBB5LkswLIn8h3MFTNg73xDgCiApFpUNti9xiSohc2LvQz
   eokajtanX43ySjbP223j1xVn60cje7mLYTLiW/J99nVlCfMgwnE7JvTcU
   e6UpAUGdwPNLGudV1shVdmmFRT5Bp6DcpksHO9NlVz2cup3cxOfJLVrrP
   HDmJLfPPbl2cK/g8Lf6NIdfseBNUqxJqjtnm4AYmoDQQ7x1hxPHNZqOvS
   CaBxTS9WdjxfsirJJrp1DRHxU4FgnUT3OOrSLPBGKzJudXPvk4xAfJ86B
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998123"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998123"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677750"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677750"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:26 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-5 16/22] pkvm: x86: Add vmcs_load/clear_track APIs
Date:   Mon, 13 Mar 2023 02:02:57 +0800
Message-Id: <20230312180303.1778492-17-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vmcs_load_track/vmcs_clear_track to track vmcs load & clear which is
prepared for the following VMPTRLD emulation.

Use these track APIs for vmcs load/clear is necessary if pKVM want to
get current_vmcs pointer for some case, for example, if pKVM handle
nmi in the root mode, it may need tmp switch vmcs to host vcpu to inject
nmi then switch back to current_vmcs.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
index 35369cc3b646..54c17e256107 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -50,6 +50,27 @@ static inline void vmx_enable_irq_window(struct vcpu_vmx *vmx)
 	exec_controls_setbit(vmx, CPU_BASED_INTR_WINDOW_EXITING);
 }
 
+static inline void vmcs_load_track(struct vcpu_vmx *vmx, struct vmcs *vmcs)
+{
+	struct pkvm_host_vcpu *pkvm_host_vcpu = vmx_to_pkvm_hvcpu(vmx);
+
+	pkvm_host_vcpu->current_vmcs = vmcs;
+	barrier();
+	vmcs_load(vmcs);
+}
+
+static inline void vmcs_clear_track(struct vcpu_vmx *vmx, struct vmcs *vmcs)
+{
+	struct pkvm_host_vcpu *pkvm_host_vcpu = vmx_to_pkvm_hvcpu(vmx);
+
+	/* vmcs_clear might clear non-current vmcs */
+	if (pkvm_host_vcpu->current_vmcs == vmcs)
+		pkvm_host_vcpu->current_vmcs = NULL;
+
+	barrier();
+	vmcs_clear(vmcs);
+}
+
 void pkvm_init_host_state_area(struct pkvm_pcpu *pcpu, int cpu);
 
 #endif
-- 
2.25.1

