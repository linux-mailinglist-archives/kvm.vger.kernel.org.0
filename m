Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712F27CCDE0
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 22:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344423AbjJQUZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 16:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344034AbjJQUZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 16:25:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4EF9F;
        Tue, 17 Oct 2023 13:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697574332; x=1729110332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DtMYE8N1kmDVdDJrac2n6n5keisOitJwN0pOUvbjeOE=;
  b=Wq1ZyfzEba+OjXqg5BUFD446IdXA5Zo16113OlkK1lkCSZuskG0VZb7p
   FFKFsUWVlcYh0KC312FWOHmQodtrnM59Ie6dYMDNWDr9DZOoPyq6qZ5et
   YLsHtvDUOO0HRResMWMztKqonRYi4hsxmrIBNvgeoK4Ej4szGnaFgjRgB
   7aTI4EAVxGSD3cXbRX/en6zZdBfLrLHQKuN1b3GR7Wk8wcS/oBLUBUo+g
   WYYfGjZ43vuuQ1Pj5e/MLGVb/9BZkn+iiWMIbGb7BuPwAa3D3ONYqW0Wb
   Fk/BKCVQiDLNtAbInvgJ+kjAMwJB6H2w8aMZIK8cuVUAC7sOudBlzBnLM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="7429511"
X-IronPort-AV: E=Sophos;i="6.03,233,1694761200"; 
   d="scan'208";a="7429511"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 13:25:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="900040443"
X-IronPort-AV: E=Sophos;i="6.03,233,1694761200"; 
   d="scan'208";a="900040443"
Received: from rtdinh-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.212.150.155])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 13:23:28 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        elena.reshetova@intel.com, isaku.yamahata@intel.com,
        seanjc@google.com, Michael Kelley <mikelley@microsoft.com>,
        thomas.lendacky@amd.com, decui@microsoft.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 03/10] kvmclock: Use free_decrypted_pages()
Date:   Tue, 17 Oct 2023 13:24:58 -0700
Message-Id: <20231017202505.340906-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231017202505.340906-1-rick.p.edgecombe@intel.com>
References: <20231017202505.340906-1-rick.p.edgecombe@intel.com>
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

On TDX it is possible for the untrusted host to cause
set_memory_encrypted() or set_memory_decrypted() to fail such that an
error is returned and the resulting memory is shared. Callers need to take
care to handle these errors to avoid returning decrypted (shared) memory to
the page allocator, which could lead to functional or security issues.

Kvmclock could free decrypted/shared pages if set_memory_decrypted() fails.
Use the recently added free_decrypted_pages() to avoid this.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f52149be9..587b159c4e53 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -227,7 +227,7 @@ static void __init kvmclock_init_mem(void)
 		r = set_memory_decrypted((unsigned long) hvclock_mem,
 					 1UL << order);
 		if (r) {
-			__free_pages(p, order);
+			free_decrypted_pages((unsigned long)hvclock_mem, order);
 			hvclock_mem = NULL;
 			pr_warn("kvmclock: set_memory_decrypted() failed. Disabling\n");
 			return;
-- 
2.34.1

