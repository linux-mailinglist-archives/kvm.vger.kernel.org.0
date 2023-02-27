Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4296D6A3CBE
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjB0I04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjB0I0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:26:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7951A494;
        Mon, 27 Feb 2023 00:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486274; x=1709022274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bAyBc4s3tiQ/01jXFwZRD2ovwWFrfG+pQJPt5k9h7e8=;
  b=ksm94Tzgna+Ram9a/aL4ZZ9uNiW+5dYXvxxSPywzF5PGBboiH0b3jZhV
   6PCPGwhSYd0LfcaxUCZJJ+JzX29A+PwEDfdJlHwepYVCE5tQgZ+lEy76+
   iHW4SkSROS6576it/hg5kWrOVo1Re6dE+ZmOqom3Z+VuufsXU5U5MY5KZ
   g4C3rS4ezNchQebUiwBd5jW4HpXTqVXiRbq1YSPn4nXAtcij/l6ljo00P
   tXR1kIuadLP59iZ4RaiqY697DpErhfcFc0uOpD1pmK8wCCmF6wS8AiDp/
   xosFFzS+USolOhbwUk015944siqedhvwlp6VJO7S1Y+Q0B64GReRaTCd7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608853"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608853"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242199"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242199"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:08 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH v12 043/106] KVM: x86/mmu: TDX: Do not enable page track for TD guest
Date:   Mon, 27 Feb 2023 00:22:42 -0800
Message-Id: <29d0cc81c60c2d48c47c2a8fd9243ac9b6bc0e63.1677484918.git.isaku.yamahata@intel.com>
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

From: Yan Zhao <yan.y.zhao@intel.com>

TDX does not support write protection and hence page track.
Though !tdp_enabled and kvm_shadow_root_allocated(kvm) are always false
for TD guest, should also return false when external write tracking is
enabled.

Cc: Yuan Yao <yuan.yao@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 0a2ac438d647..d738d318ce17 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -22,6 +22,9 @@
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
+	if (kvm->arch.vm_type == KVM_X86_PROTECTED_VM)
+		return false;
+
 	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
 	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
 }
-- 
2.25.1

