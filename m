Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33837CAEC4
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbjJPQRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbjJPQRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:17:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA48D115;
        Mon, 16 Oct 2023 09:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473012; x=1729009012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4SCW6Dkj/Vj+qX6sWycKS9/fk9MJ8AKVtZUkBL10lrs=;
  b=CIw7q5Rh6u0MQ9gB0IFhK2UZwP1R1RiG260gw7Nh4p//ErWML9HcI3Cc
   +bdx/nH+NDa6jpNKaaQ0IGoOBBbB/kiIKbqNoi4V1T0t0v+Uw0ODN0+cZ
   ZKcirKYXV+qv4dapZsQjLCLAaVJpZpM0+AqTjNmVSBRFldNTdXq36AlLj
   gDOzyrJUzcC/G1gZ5i6XyI55UR1sXA0EKCVY322VKvZrFLiIPK5rhVlbQ
   sTGmWb63rmZwoNE/SPjMpROxDSgMxip3b/2eeihZ9bJBPCrhQm6BKQO1h
   qvgoNOwh2dz5A4y+hIRmv+jZFnKT+Rst2O0gez7vCBmxjTLTO7RkV7vGt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921779"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921779"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448122"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448122"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:43 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH v16 048/116] KVM: x86/mmu: TDX: Do not enable page track for TD guest
Date:   Mon, 16 Oct 2023 09:14:00 -0700
Message-Id: <e2304d60cc597cf91ad26d481aa4b56396386892.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index c87da11f3a04..ce698ab213c1 100644
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

