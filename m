Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0484CDD96
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiCDT77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiCDT7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC580240DD5;
        Fri,  4 Mar 2022 11:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423447; x=1677959447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ehw5PiPYIt2UEyezdfSREAaWHEq37fwxUWbS0cqLXzg=;
  b=nDClTmmu0uWpja4LluNcLU832Qbiu/MYfO1tbZQz6FdvhOu0DkOVuFE+
   t+atgwXewYvTsmUHHlCBdUdAC1BdCx8JA5w62IP8sqpVqsyK3aK/xcuMF
   +ykaKIuTjbUVZX2vA4RbAVu7y6St54aW0+q/xTG8LWsgQF/ZcvUUtjDV0
   eDRuW05iDW+VJDnkFLI1aY0J6QLq7G+r6FJWHVQ5OcVPTmFOP+7oV0Vt7
   cXp+Ef+gqb53LqiNCbLLE2IoIZlaLTrRal9wdZR1OF6TaHMl3WzBMVAW+
   j46iCdeyOoZUXeLbIrcDIo7uyw11X1yepOFrVXpnvCzCqOanSsubvyexz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779662"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779662"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:47 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344606"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:46 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 098/104] KVM: TDX: Handle TDX PV report fatal error hypercall
Date:   Fri,  4 Mar 2022 11:49:54 -0800
Message-Id: <d1bc7a6123b9b2c233518a5f234df99c3c6f458d.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV report fatal error hypercall to KVM_SYSTEM_EVENT_CRASH KVM
exit event.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 123d4322da99..4d668a6c7dc9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1157,6 +1157,15 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
+{
+	/* Exit to userspace device model for teardown. */
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+	vcpu->run->system_event.flags = tdvmcall_p1_read(vcpu);
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1180,6 +1189,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

