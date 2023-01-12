Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D1E667B8C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbjALQnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbjALQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5DF1C905;
        Thu, 12 Jan 2023 08:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541245; x=1705077245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fDJTlB5bV3N6Gz25H1kwqBta18u/BfAiuqVVM3y2CYw=;
  b=bj2IpaQ03BIShEhZdfEQttW4dc95+5oJTEHkIKGFAoM2Cxh4jLGlXnBU
   gN1TGEdLvTIbcGwCQO+qa+xQ/UH9mf70lvIgTbLdQ+v2sI9o72YC4654L
   h9lwHHVhPfyJHFwSzcRdH9E297QE1zrSTr/Pvxf0aidk8FWHT6a/jpeIJ
   CKiVJ8jwR+IMaaXlwZMZik+gZYeVO17OKHwRQmC7WMXnYAounZwysgmPp
   DUHD6ixcWAdUr8X6dZmRATE10xr4EMZHWiPeUYBXQAmFlX9RO+4gZ6Iu0
   jxXJh8DGp3x+CSvCZZ4ai7+9mRGfvwFjU4Qp9Do37YgiCbDbr8KPzcWuu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811890"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811890"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151805"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151805"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH v11 049/113] KVM: x86/mmu: TDX: Do not enable page track for TD guest
Date:   Thu, 12 Jan 2023 08:31:57 -0800
Message-Id: <9fd3d613e0e83a8828b3529fe3954bcb4cb9f400.1673539699.git.isaku.yamahata@intel.com>
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

From: Yan Zhao <yan.y.zhao@intel.com>

TDX does not support write protection and hence page track.
Though !tdp_enabled and kvm_shadow_root_allocated(kvm) are always false
for TD guest, should also return false when external write tracking is
enabled.

Cc: Yuan Yao <yuan.yao@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 0a2ac438d647..571c2c40004a 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -22,6 +22,9 @@
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return false;
+
 	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
 	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
 }
-- 
2.25.1

