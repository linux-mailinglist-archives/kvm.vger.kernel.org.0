Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C692E6A3D90
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjB0I4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjB0Izx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:55:53 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6797B1713
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 00:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677487671; x=1709023671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KDJQsv8v8pA0Pa5ghjuA3PzGLpKYZKTlr2UU2oYWW58=;
  b=CsDN2bTG3vw3jPnLhGCrFFYf5rJv3JPB1qAiM2V3H2qC8JuEJgRBEAMx
   gmZDhQWVjYIKEoum+G4rXIvYPatGkv5dnmYJIrK2KiXMyBtyp2wUexRQ2
   SPXIiWtF7kLv9t6h6gJ1ttQo8dvMH+bD4lSLwLU7wLVX+FpcVBluEg9zb
   ob2sWshvpgmmYReNH+vt1zgWB+opMf2elfMgzkzgUGeYHWJFoJ9B4H9Lo
   gQrIDrn7OEhycKYlFZN99udKAepQDoQ0rvIbPrxl7nWwe2+ORTsJb+HNO
   h43qzLVLrA+AUZkORbnFrGBsqNlsvBthv6VrRM7ZtkFojMRIssEuMQUql
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="322057690"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="322057690"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="651127080"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="651127080"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 27 Feb 2023 00:46:13 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Cc:     kvm@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 2/5] [Trivial]KVM: x86: Explicitly cast ulong to bool in kvm_set_cr3()
Date:   Mon, 27 Feb 2023 16:45:44 +0800
Message-Id: <20230227084547.404871-3-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230227084547.404871-1-robert.hu@linux.intel.com>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_read_cr4_bits() returns ulong, explicitly cast it bool when assign to a
bool variable.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 312aea1854ae..b9611690561d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1236,7 +1236,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	bool skip_tlb_flush = false;
 	unsigned long pcid = 0;
 #ifdef CONFIG_X86_64
-	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
 
 	if (pcid_enabled) {
 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
-- 
2.31.1

