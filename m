Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC0667B22
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbjALQju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbjALQh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:27 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9FC12771;
        Thu, 12 Jan 2023 08:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541227; x=1705077227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hmZOmmDPZfznqubXfeRRdJI9Kyf8KoOoN+Zdo+unsC0=;
  b=Dlj+Ua9ooBJ96NVJXGlMIPXxdfNyEZqGHQJMc4CFB7gBuXI5gy2pKe5C
   VdZuXq/XDJlmHsFcxiK424bDYDI7OyCMs9vx0jpSbYM71HI17ZE84tCuJ
   1NsaTqlJ0BfOhmwDEkSnii/qKDlCjwJ/4c3ZG6SgcVl/Oqj2IDyLap/wn
   UuGRc1eIabK8dH/LwPeb245BW0BQ2nJ8ndcvIQoBE7JKFnS5Upbuof8ED
   sn3RNI1lhgQNfHlSaBZ/EqsoxUaDpnd2iokDPoC9Zpr/83bJO10vkArSt
   ZA4fUj3a4k9lXe3EUkTJ4yw47g5FqLJknHZpAzXeuZArA6cNsmZIBOreM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089757"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089757"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372582"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372582"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:37 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 098/113] KVM: TDX: Handle TDX PV report fatal error hypercall
Date:   Thu, 12 Jan 2023 08:32:46 -0800
Message-Id: <1b4b247e8a374e1b8c2d7c2bee948f8e50a9ea5b.1673539699.git.isaku.yamahata@intel.com>
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

Wire up TDX PV report fatal error hypercall to exit to device model so that
it can gracefully handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5dc7dae55c57..4bbde58510a4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1199,6 +1199,13 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

