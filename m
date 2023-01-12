Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C5D667B2D
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbjALQkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjALQh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:28 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307BFDF4B;
        Thu, 12 Jan 2023 08:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541229; x=1705077229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qO8e6bM3otymu5WCnXl9Um+rd7DoA2ZJ2n+Qv92VWas=;
  b=cFSFcO5lDhQvI8+R37Q+WqtyyOYdqNAYvxCu071sg+wAx0gH+zmBJtvW
   5adw9+oawugf8q1pLFiO8yOD7TuJG+XDDuHHiOUqMqAS0M7LhSunmkkHl
   qUOMBWInI3lx/Zab9LS0DvZSFMdVowC+yQSSn8JKZRyt4BiBLBs3rulUO
   8F+brBnCpviq+SR4q1onU8f/mIhVy6XuKbNDX9iNFYAKmRxSkAc16LST+
   z41DxryfyKRvN4rXp5hfFt4hOTz/SqMsBQ/PkQP8sJH1cevnHNZIl4djb
   at5bGHdNBeQAu0+xzv4n8Clug8WmAjBVyxUwXqCwZRFLdLO1CxM/p0561
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089803"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089803"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372614"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372614"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:38 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 106/113] KVM: TDX: Add methods to ignore VMX preemption timer
Date:   Thu, 12 Jan 2023 08:32:54 -0800
Message-Id: <b638aa01d9e8769b4afde34211180627e384119f.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX doesn't support VMX preemption timer.  Implement access methods for VMM
to ignore VMX preemption timer.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index cbac63170cea..2d2738e8c0b1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -738,6 +738,27 @@ static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 	vmx_update_cpu_dirty_logging(vcpu);
 }
 
+#ifdef CONFIG_X86_64
+static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+			      bool *expired)
+{
+	/* VMX-preemption timer isn't available for TDX. */
+	if (is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return vmx_set_hv_timer(vcpu, guest_deadline_tsc, expired);
+}
+
+static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
+{
+	/* VMX-preemption timer can't be set.  See vt_set_hv_timer(). */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_cancel_hv_timer(vcpu);
+}
+#endif
+
 static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
@@ -889,8 +910,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
+	.set_hv_timer = vt_set_hv_timer,
+	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
 	.setup_mce = vmx_setup_mce,
-- 
2.25.1

