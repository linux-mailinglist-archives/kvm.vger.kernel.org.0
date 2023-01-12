Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3144E667B41
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbjALQko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjALQha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:30 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F96BDEC4;
        Thu, 12 Jan 2023 08:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541230; x=1705077230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DSap38ow2p9M39iZdLN9RDM/2L7UhJz9YKLjOI/nQcs=;
  b=jUPj4vrdu/+o8JoI2WvoBycUzykE3yJI3DBBU577raKL186JJCXReHnI
   i74+2RT/En4c3y/UvdVf3q5sn6kaLE6uSAv2di5zlTxH7mPGO4ISSg8BZ
   OwSoZfCcboNDbgOEyfpv2xTtbjRU+lBzYEFGKTDwbdj3aKeTYauZztYsO
   qloGzIgSf/oi7H1k229f28PIOkXdul+oXXgBHha4jLloKIAetgt1N0A+5
   +kiH5JOHJoxPRMRNqbmPW0LpAnXZNZufcrLJPyPE21eAFy1JWpcH6Q/Vq
   jchP0nxosAou20c8Yi9DDaRbUuJFp3fi/utx/Ebzzu+lLfYBmizK+QYYr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089814"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089814"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372623"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372623"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:39 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 108/113] KVM: TDX: Ignore setting up mce
Date:   Thu, 12 Jan 2023 08:32:56 -0800
Message-Id: <73966c5979f2d44e5df6604a7ee4c5544d8cbc8b.1673539699.git.isaku.yamahata@intel.com>
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

Because vmx_set_mce function is VMX specific and it cannot be used for TDX.
Add vt stub to ignore setting up mce for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index bb9fac604ea7..b4d1cc3736a6 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -795,6 +795,14 @@ static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static void vt_setup_mce(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_setup_mce(vcpu);
+}
+
 static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
@@ -950,7 +958,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
-	.setup_mce = vmx_setup_mce,
+	.setup_mce = vt_setup_mce,
 
 #ifdef CONFIG_KVM_SMM
 	.smi_allowed = vt_smi_allowed,
-- 
2.25.1

