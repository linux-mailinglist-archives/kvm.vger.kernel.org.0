Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1F079FBEB
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbjING2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjING2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:28:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74C7F7;
        Wed, 13 Sep 2023 23:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694672922; x=1726208922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FKJfPu7lwKGVQbgKOQaw0mIzmXpCo4IrXnEnhDUCXZg=;
  b=SnhbiDqRJSU+wg4VUdWeFQ0GwHBkJkSPlcZQRNdR43uCZRXrwU2YzmaA
   a9Ul2fYwpXN3jxbys3VEVcE9NkHZtJObmlY/Z/h16Ugl5jn9naTvWbEBy
   P7y3IpNmThZMgXh8gymZNB79iqY6kty/cOAzlBI+RQEyxGRrPmVxJDi3B
   KJMeOXGFiTzL+LEBzLrlks2bRa3uRruxyOTbr6CV9sjIPe2aC5hmFj6ez
   3TrI46/Fu0/Ca/mbo7e8Pzf8Dyckpp+J56Hw/87Qj/OTlZWsRssUV61ao
   NHq7xh6Kj3z/wW3iPK7RYKAiv8Z6C6NLeB0j9Hugo3MCs519Z5uosQHFo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382672443"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382672443"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="809937981"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="809937981"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 23:28:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, yang.zhong@intel.com, jing2.liu@intel.com,
        chao.gao@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 2/8] x86/fpu/xstate: Fix guest fpstate allocation size calculation
Date:   Wed, 13 Sep 2023 23:23:28 -0400
Message-Id: <20230914032334.75212-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914032334.75212-1-weijiang.yang@intel.com>
References: <20230914032334.75212-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix guest xsave area allocation size from fpu_user_cfg.default_size to
fpu_kernel_cfg.default_size so that the xsave area size is consistent
with fpstate->size set in __fpstate_reset().

With the fix, guest fpstate size is sufficient for KVM supported guest
xfeatures.

Fixes: 69f6ed1d14c6 ("x86/fpu: Provide infrastructure for KVM FPU cleanup");
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a86d37052a64..a42d8ad26ce6 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -220,7 +220,9 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = fpu_kernel_cfg.default_size +
+	       ALIGN(offsetof(struct fpstate, regs), 64);
+
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
-- 
2.27.0

