Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBFD714359
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjE2Eej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjE2E27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:28:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108132130;
        Sun, 28 May 2023 21:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334322; x=1716870322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KmVaeJcJiI0A3X/f88ZmhdCGHs9unPup0tYXi6aBhRQ=;
  b=FUxEsEd0jFHvmdpV+W8ZcNXpwAMCV9eFBkI6uAmWf6IxLpIspCKAL9Vm
   ZNEUnFrlTWizxqARPa+a3Q5hsdATpqWgMFAeGl3KuhafoWafVQb8S2bOe
   7QTufWF7WVCVdKsIqCa6SskiL64+asGOTDTg2YOYofZT/ExiKFF+G5U8H
   AAnoDmT9OAWLoVS/j9Z1KOTGMPR0QoI0wwIRjE77irz0ZCDinp9mmUh9c
   DYHbdZZRy3HZmTj+nQRYQVzx/pXJq5lrd4Y3cD2CGbebR4xU/0ANF8m6j
   UXwh53BWXireOBv8QaCraG9L4rMHm7tn0GcciQ2mnIFtn8TZDr8IfqM0i
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="356993515"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="356993515"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="830223562"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="830223562"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 103/113] KVM: TDX: Add a method to ignore dirty logging
Date:   Sun, 28 May 2023 21:20:25 -0700
Message-Id: <6a117c07f01fd1f4fe1727a93f533d381a651e79.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Currently TDX KVM doesn't support tracking dirty pages (yet).  Implement a
method to ignore it.  Because the flag for kvm memory slot to enable dirty
logging isn't accepted for TDX, warn on the method is called for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9c854b5c856b..12872225af18 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -827,6 +827,14 @@ static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
+static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_update_cpu_dirty_logging(vcpu);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -971,7 +979,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sched_in = vt_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
-	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
+	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
 
 	.nested_ops = &vmx_nested_ops,
 
-- 
2.25.1

