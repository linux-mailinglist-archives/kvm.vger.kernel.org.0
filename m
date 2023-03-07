Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CDC6AD587
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjCGDHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjCGDGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:06:53 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C628616F;
        Mon,  6 Mar 2023 19:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158341; x=1709694341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YTgEgmA3f1uzY8PacyZ6XmpZcGIgDW5/dB0vDrivilc=;
  b=FUGBY9IZt28gdICl5x8OojDwdF57jiWR/pySC19f6d999ZYSNrvlY7R8
   CFbmLP9eIKC2ORzU9DhpwYEvOoS+eXph+R+QE61lXMbNXZrqXKcbpbwXU
   1g4JVIzAK3nn3Q9ynoEcjZSMlbmDq8afojZYjvJEdjRU/6kh69HfHZcpQ
   GknSOepi3unuo3dGsfcRBL9mSdk4D3WJj144sg4gE0w8eUHKuslrcjVml
   yu3XcUiyi5tmUB3qA37plTvGENXR4zflVH18A8i1pGLhosxK8NKj4LTiV
   jCgK0OeWAWifz5BHzMdp7fhnsYYXKUgcr1/p/Lyc4MoZVPWsaC+pMzui3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072558"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072558"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409904"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409904"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:20 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 26/34] x86/fred: no ESPFIX needed when FRED is enabled
Date:   Mon,  6 Mar 2023 18:39:38 -0800
Message-Id: <20230307023946.14516-27-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Because FRED always restores the full value of %rsp, ESPFIX is
no longer needed when it's enabled.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/espfix_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 16f9814c9be0..48d133a54f45 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -106,6 +106,10 @@ void __init init_espfix_bsp(void)
 	pgd_t *pgd;
 	p4d_t *p4d;
 
+	/* FRED systems don't need ESPFIX */
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		return;
+
 	/* Install the espfix pud into the kernel page directory */
 	pgd = &init_top_pgt[pgd_index(ESPFIX_BASE_ADDR)];
 	p4d = p4d_alloc(&init_mm, pgd, ESPFIX_BASE_ADDR);
@@ -129,6 +133,10 @@ void init_espfix_ap(int cpu)
 	void *stack_page;
 	pteval_t ptemask;
 
+	/* FRED systems don't need ESPFIX */
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		return;
+
 	/* We only have to do this once... */
 	if (likely(per_cpu(espfix_stack, cpu)))
 		return;		/* Already initialized */
-- 
2.34.1

