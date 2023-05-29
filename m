Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B771434F
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjE2Edj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjE2E3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:29:09 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D75213D;
        Sun, 28 May 2023 21:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334327; x=1716870327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8gj5om2vXb982qRmgkUVx7Nw72HGXWlHSE4tH7SDwSw=;
  b=eEj/RIoFQi6HfYU/+PdeYUK/SFAxIOveuwjbvVnWYna/g0nU9XVR7rfa
   wNY7isCeK9UH5jUR2byCEh6dDDYR2f9bo3BBEljABVquOmnX16koCI8hx
   L1/b8epe7KmOBdt8J2F6QPO2fDlM6OUnLlCKVnajxLRCKiDyNyj+nyoCu
   kP/qUPo6+GPVY815Lv3S7mo2zNzLB1U5H9xAGhS0NFReZelz+IzaZ3OU0
   DJ1EroaBj44N4H5X95g+c5cebr/qb9VO3kUwjSu9oU8PhG3H9r1rDRas7
   zQiC5M34uWSTGVr55oxnA968xXgq07UA//8sfbFqaz0/IuQzSNnrJCz67
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966202"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966202"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784484"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784484"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:31 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 078/113] KVM: TDX: Implements vcpu request_immediate_exit
Date:   Sun, 28 May 2023 21:20:00 -0700
Message-Id: <1a31b3559ea5ad320b03aaf82a7af8bf1bad74da.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
unblock on pending events, request immediate exit methods is also needed.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c86c5e3f9ea3..7b815e56c65d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -381,6 +381,16 @@ static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
 	vmx_enable_irq_window(vcpu);
 }
 
+static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		__kvm_request_immediate_exit(vcpu);
+		return;
+	}
+
+	vmx_request_immediate_exit(vcpu);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -528,7 +538,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
+	.request_immediate_exit = vt_request_immediate_exit,
 
 	.sched_in = vt_sched_in,
 
-- 
2.25.1

