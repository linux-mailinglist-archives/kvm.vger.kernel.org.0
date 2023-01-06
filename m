Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B103C65FDB1
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbjAFJWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbjAFJU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B316B5DC;
        Fri,  6 Jan 2023 01:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996825; x=1704532825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JKAIJtKpEV0pDtyUyzmPScPoDyIj7KB0n/KR4J5yOTE=;
  b=WEjkMrGRc5yajhWiq9Ff9gw8SaZcl5rWoOZdzEPCa9y3R3ZODp+zVVen
   F8eWafIChqGd4FBBAkg9SGEbdRCf6l0f65WiOc6mAaVQSaq3Jfa6aOwZM
   kAp1FRi+sTl75DJNSVPa3kCWqNLJrxgGrEwdqHQwbULOkwYHPvlJIl1yb
   LtCW6NVacIb36v2aQx5kVu1thZCxo4SRG1phaSLshFSiPaCwbdsGpjINo
   /fVXJPxktMxjchO9la2h1m7aeWEe469gNGWbsIuAQocN0yO8sEHvX8nz9
   ftQ9hWl2iLEsyEHySoHQqvAFLCSujaEanmKghoGWWU7mEdw6vlwetHFyr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511611"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511611"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139444"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139444"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:17 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 26/32] x86/fred: no ESPFIX needed when FRED is enabled
Date:   Fri,  6 Jan 2023 00:56:11 -0800
Message-Id: <20230106085617.17248-27-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Because FRED always restores the full value of %rsp, ESPFIX is
no longer needed when it's enabled.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/espfix_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 9417d5aa7305..b594fcc0a4b7 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -116,6 +116,10 @@ void __init init_espfix_bsp(void)
 	pgd_t *pgd;
 	p4d_t *p4d;
 
+	/* FRED systems don't need ESPFIX */
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		return;
+
 	/* Install the espfix pud into the kernel page directory */
 	pgd = &init_top_pgt[pgd_index(ESPFIX_BASE_ADDR)];
 	p4d = p4d_alloc(&init_mm, pgd, ESPFIX_BASE_ADDR);
@@ -139,6 +143,10 @@ void init_espfix_ap(int cpu)
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

