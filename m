Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF266A3D43
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjB0IcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjB0I35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:29:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE30206B6;
        Mon, 27 Feb 2023 00:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486385; x=1709022385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+e/THgQuzy9HKQWdHmsvCjGEpKAbWN26lu2fjw0xxh8=;
  b=M9t5L9PQ9sverzjKxV65vMAH2nXx5xryonvM0n51i2GyLojb/MBOu8uU
   OrAVJj71b6O4Smk6J/oSfH9wRigvivcE0r/Mw6EZ8nS124YfE5JMrOjaU
   66tc7a/HEC45xjfRBIuw1kogZVEu/YJoq26EdJG2QAOKyXBr1j4RqDren
   GITNHf9Gjh9kcxul4PhSS7EkjyUBru7vHIeWSVdsAgG+JuGC/eP/Jmn43
   ok7dQjTcByM3wKVnBgylYSiT1ZPhBZl/BBd8EZzBrAaBHafEIyQTLQIux
   JmqkRH87TpChUpkt/GfojPARfQklRpL+fVXWBdJYFb/14Auz/29HFzRLO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609067"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609067"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242408"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242408"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:19 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 090/106] KVM: TDX: Handle TDX PV report fatal error hypercall
Date:   Mon, 27 Feb 2023 00:23:29 -0800
Message-Id: <f25f451c6b5b61a46df2ff2f8e389d5a8bdc9d3b.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV report fatal error hypercall to exit to device model so that
it can gracefully handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f4c0f715a36f..f20fcf8325aa 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1243,6 +1243,13 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+		/*
+		 * Exit to userspace device model for tear down.
+		 * Because guest TD is already panicking, returning an error to
+		 * guest TD doesn't make sense.  No argument check is done.
+		 */
+		return tdx_vp_vmcall_to_user(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

