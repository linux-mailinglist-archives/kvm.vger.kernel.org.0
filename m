Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B67AC052
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjIWKMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjIWKL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:11:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7771BD;
        Sat, 23 Sep 2023 03:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463908; x=1726999908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=daicXFK30tmpTUp95RTD2ZQAe5K9xY8zuW1WSEbSaqA=;
  b=RF50qkSpXHkHvKH70GYJdehu6SU3Tclu7ny+agEjlzZReORO8M5gsxbV
   8jDchmx4WmEn33UhCqsX4CjoBXYgdfBdjAmS+HMFbfDBCFPV7eWDoMkGv
   q/7eEWUDKWJdYTRbV8hzQ2Iz+5sDgKxf+Wv6rMjHbYhdZUa5fWmNndX4Q
   eXYORjBSws+aAHGQOyrCwmPQ+0yRqv4Rifm2RXtDgJT+SBBlUF4BrgT9f
   68LAUNQbSN9Kiu5LqsIlG8OLU6bawp61JmyjAoGzoX/VMBSsWIzUgyZSf
   WVba+/zSdaJoJcfXH3TAgiA8+siEh/zsn4Rc1T2qwfGaMtmo+rsOhFdBP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492326"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492326"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388176"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388176"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:46 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 21/37] x86/fred: No ESPFIX needed when FRED is enabled
Date:   Sat, 23 Sep 2023 02:41:56 -0700
Message-Id: <20230923094212.26520-22-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
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
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/kernel/espfix_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 16f9814c9be0..6726e0473d0b 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -106,6 +106,10 @@ void __init init_espfix_bsp(void)
 	pgd_t *pgd;
 	p4d_t *p4d;
 
+	/* FRED systems always restore the full value of %rsp */
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		return;
+
 	/* Install the espfix pud into the kernel page directory */
 	pgd = &init_top_pgt[pgd_index(ESPFIX_BASE_ADDR)];
 	p4d = p4d_alloc(&init_mm, pgd, ESPFIX_BASE_ADDR);
@@ -129,6 +133,10 @@ void init_espfix_ap(int cpu)
 	void *stack_page;
 	pteval_t ptemask;
 
+	/* FRED systems always restore the full value of %rsp */
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		return;
+
 	/* We only have to do this once... */
 	if (likely(per_cpu(espfix_stack, cpu)))
 		return;		/* Already initialized */
-- 
2.34.1

