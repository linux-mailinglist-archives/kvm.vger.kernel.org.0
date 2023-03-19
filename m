Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52C96C0027
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCSItl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCSIti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:49:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDB91A48F
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679215777; x=1710751777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qvxOPplvEv1zyAd/qa0KOc29zbye8sCt8fS0alfd2Vc=;
  b=j8fZXclDp8nQcUEHgNtALGrmGb+oKDpIFNycbbBpzk41WKEIpjMb+2It
   IQksq0o8DOw6zY9z6XyBfkWCljomnBjZ+2+uMhFmQsRegw1w2sBrLx4Hi
   fveTxTkx0lbFL1DUpWKEWxSFtGDzORWic9sq5oPE1ti14ku3tbeQU7ybZ
   6RjclXuTh0dxyIqzlHE52Sz3Z0PV3q1pjB6aFcsoHN7tQbIsDUk50g+rE
   PJirH6WxCsLCbNQof7Q3YvUWEXVLHWbhDr3/z9QocUPJY10HCOXK5dynp
   urYWeLbYSnCvSpVnDlcnrZYDKJWRX99iO5G7uif2ISXazJmcszstpKKnK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="424767836"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="424767836"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="683146235"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="683146235"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:35 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v6 1/7] KVM: x86: Explicitly cast ulong to bool in kvm_set_cr3()
Date:   Sun, 19 Mar 2023 16:49:21 +0800
Message-Id: <20230319084927.29607-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230319084927.29607-1-binbin.wu@linux.intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

kvm_read_cr4_bits() returns ulong, explicitly cast it bool when assign to a
bool variable.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 810cbe3b3ba6..410327e7eb55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1238,7 +1238,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	bool skip_tlb_flush = false;
 	unsigned long pcid = 0;
 #ifdef CONFIG_X86_64
-	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
 
 	if (pcid_enabled) {
 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
-- 
2.25.1

