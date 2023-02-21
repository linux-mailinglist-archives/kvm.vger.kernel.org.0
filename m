Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221E569D93C
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbjBUDWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjBUDWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:22:08 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B483C23D90;
        Mon, 20 Feb 2023 19:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676949727; x=1708485727;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nCueLugKj6AS1tNo11nKqAVGoXrrBxgB0PinJrUQ9SE=;
  b=d6ZCXofXA8xGVPsO5PNdyezs9v/B+jfugLaeHaKc1lNd29uoNcWaEXpO
   pOcLgSlKApT4h94x+T2DsKNafNDfn95u7G7tA9v2wbYDUgotIHtHcdbmZ
   tzIFGSw4fc0HfZYXfCTNYBYgZAi89KgfDoskHCmmnjRXU6aj9XRAJLdo8
   qN72+WYt8DrsdWxlvcEx8Lp+OIecJwpiHF0S3a2izCjdVPUqkFwexNb9I
   LNZoFMX3UI/Lw3DXCxga0lvcxfFLSuxlC7G1/+PQPc9i+vSSfRUpUsQGp
   +C9dyBB8mOE0WhQDmdLmpSs8ARROz5mxUyz/EJPbozEgpRTmNPX+rKrT7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="395012922"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="395012922"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:22:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="780841410"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="780841410"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.10.94])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:22:05 -0800
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH] KVM: x86: Remove duplicated calls of reverse_cpuid_check()
Date:   Tue, 21 Feb 2023 11:21:56 +0800
Message-Id: <20230221032156.791-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
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

Remove duplicated calls of reverse_cpuid_check() in __kvm_cpu_cap_mask()
and kvm_cpu_cap_{clear, set, get}().

reverse_cpuid_check() is directly called by:
 - feature_bit() / __feature_bit()
 - x86_feature_cpuid()
 - kvm_cpu_cap_{clear, set, get}()
 - __kvm_cpu_cap_mask()
Also __kvm_cpu_cap_mask() calls x86_feature_cpuid(),
and kvm_cpu_cap_{clear, set, get}() calls __feature_bit().
It makes the direct call of reverse_cpuid_check() duplicated.

For functions call reverse_cpuid_check() twice indirectly (e.g. cpuid_entry_get()
calls both __feature_bit() and x86_feature_cpuid()), keep them as they are.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 2 --
 arch/x86/kvm/cpuid.h | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8f8edeaf8177..f4089d7a7c4c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -545,8 +545,6 @@ static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
 	struct kvm_cpuid_entry2 entry;
 
-	reverse_cpuid_check(leaf);
-
 	cpuid_count(cpuid.function, cpuid.index,
 		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..d781372a01e8 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -192,7 +192,6 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
 }
 
@@ -200,7 +199,6 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
@@ -208,7 +206,6 @@ static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 

base-commit: e73ba25fdc241c06ab48a1f708a30305d6036e66
-- 
2.25.1

