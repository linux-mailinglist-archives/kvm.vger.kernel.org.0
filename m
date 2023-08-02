Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477FD76C2E5
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 04:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjHBCaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 22:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjHBC37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 22:29:59 -0400
Received: from mgamail.intel.com (unknown [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839D2268E
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 19:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690943398; x=1722479398;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iSV7thf8IkI5bKZ9PEb4JBIRysgr6h+W6DeVzihmXpY=;
  b=VXkGHtJJMsdhl+uAwlwDvPK+sCoUMjzu83K8WRjRG9wkC8uvO4H9+hfk
   ChI/q3Tq1/sV5VYEbkNRZc3UHUq9deIvovA282A/bZdh7pY8xo8MzVnU9
   WWF56GD5tmXmTnC9bkTE3lGm7ZwB50z2kfNrrcryTOBSzpDpXv5B/1/dA
   zot/x9hxUxPC4tqE9TDRkko3JgfQAf6N4njkjq1Gt3iYsMuHFuaXVknNV
   Xa8NzufghVz/v26OHSIKelMGlqO5NIduxxF4eDh68nYUy8vYe1HVHnEwC
   SZD9BQvg/mgsZJnIsYJlDpDJw+pH21zA3E8MuNiasgiLNhJ+X9NqW/5DK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="369459832"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="369459832"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 19:29:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="872290749"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga001.fm.intel.com with ESMTP; 01 Aug 2023 19:29:58 -0700
From:   Tao Su <tao1.su@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, xiaoyao.li@intel.com,
        tao1.su@linux.intel.com
Subject: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
Date:   Wed,  2 Aug 2023 10:29:54 +0800
Message-Id: <20230802022954.193843-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Latest Intel platform GraniteRapids-D introduces AMX-COMPLEX, which adds
two instructions to perform matrix multiplication of two tiles containing
complex elements and accumulate the results into a packed single precision
tile.

AMX-COMPLEX is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 8]

Since there are no new VMX controls or additional host enabling required
for guests to use this feature, advertise the CPUID to userspace.

Signed-off-by: Tao Su <tao1.su@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 3 ++-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7f4d13383cf2..883ec8d5a77f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -647,7 +647,8 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
+		F(AMX_COMPLEX)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 56cbdb24400a..b81650678375 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -43,6 +43,7 @@ enum kvm_only_cpuid_leafs {
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
+#define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 
 /* CPUID level 0x80000007 (EDX). */

base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
-- 
2.34.1

