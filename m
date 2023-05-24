Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9745870EDC2
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 08:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbjEXGRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 02:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239434AbjEXGRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 02:17:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BCD184;
        Tue, 23 May 2023 23:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684909022; x=1716445022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7vaTJBMgJbDhDFplct7qOkwK8w6awR4n+tSruHTzGdk=;
  b=PTtxsesT9hL38AB1F84P7+QNFte/WksGlj1EwlM8VWWuGIFdez++WOwf
   Aqgn1gk2DjIoLPJdo5cpG27yF+8vzvzs/cBUSc9f4KsYPu8NunqMtUyGH
   5gynR2/o6oXgrAel46gJwih8uv57Et8boJHD7z5FdCErFJt1jtLnoOyvu
   bAXNkkLsE8E5sKTa0DIDsiKX3a1MWLq6X3MFIRR2llhbSvmrgfGl3KU2P
   KAhtKFu0wMmJNM7jf1h0ERBzV5eibmJOi2IJByD6YOxUiluiTNd1SkijK
   5oGuW0g+IdAswixhbUNnEJNIuh9GwGSEqexZ7nmRalm3RKBqim/5qArl3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="356695083"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="356695083"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:17:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="704212397"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="704212397"
Received: from spr.sh.intel.com ([10.239.53.106])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:16:57 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     xiaoyao.li@intel.com, Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: x86: Correct the name for skipping VMENTER l1d flush
Date:   Wed, 24 May 2023 14:16:32 +0800
Message-Id: <20230524061634.54141-3-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230524061634.54141-1-chao.gao@intel.com>
References: <20230524061634.54141-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no VMENTER_L1D_FLUSH_NESTED_VM. It should be
ARCH_CAP_SKIP_VMENTRY_L1DFLUSH.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2408b5f554b7..f7838260c183 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1631,7 +1631,7 @@ static u64 kvm_get_arch_capabilities(void)
 	 * If we're doing cache flushes (either "always" or "cond")
 	 * we will do one whenever the guest does a vmlaunch/vmresume.
 	 * If an outer hypervisor is doing the cache flush for us
-	 * (VMENTER_L1D_FLUSH_NESTED_VM), we can safely pass that
+	 * (ARCH_CAP_SKIP_VMENTRY_L1DFLUSH), we can safely pass that
 	 * capability to the guest too, and if EPT is disabled we're not
 	 * vulnerable.  Overall, only VMENTER_L1D_FLUSH_NEVER will
 	 * require a nested hypervisor to do a flush of its own.
-- 
2.40.0

