Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9BB7BF612
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442977AbjJJIgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442921AbjJJIfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51691B6;
        Tue, 10 Oct 2023 01:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926936; x=1728462936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ltSCu5LbcZQkZ8VDt/3RcMj+M7LqTSv2OY7y3BW7maY=;
  b=ZpEJeiiZhtjBxR1u8J/utaagfBKDuvkDbH/JKu3uwKNDCmRFTSia2G86
   OUEOCnUU5DZbD+/l7R/5rOJJL+PaUX8xk4MNK1trPsv9oL8XsBbqqIHlW
   hI1HcbSYAdgfk8hfUhsgKsPOKOponaOX+zaVPKJxLED6WT+V0+frtD5Oa
   JDp1bajZrg4ffHJxVlY+TC0YbKHr9TDlg4TZszvFcHFgDzau+iBns2JOO
   U7bNiJDi9JahWusrxBHhKlXbEEopQBw2g/hjSY1F5aJ2Kth4k2iMtUcL0
   UUVPooM+4x78FA5Ibj+04dw8xLg6sMMhnwFfGyyfKZPkn+BjFColkCytO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689820"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689820"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687197"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687197"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:34 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 07/12] x86/mce/inject: Wire up the x86 MCE injector to FADV_MCE_INJECT
Date:   Tue, 10 Oct 2023 01:35:15 -0700
Message-Id: <d78363e1419de5552ac527ac7a23189d6f960c10.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

To inject machine check based on FADV_MCE_INJECT, wire up the x86 MCE
injector to register its handler to get notified physical address on
FADV_MCE_INJECT.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kernel/cpu/mce/inject.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index ae3efbeb78bd..43d896a89648 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -294,6 +294,17 @@ static struct notifier_block inject_nb = {
 	.notifier_call  = mce_inject_raise,
 };
 
+static int fadvise_inject_addr(struct notifier_block *nb, unsigned long val,
+				void *data)
+{
+	inj_addr_set(&i_mce, val);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block fadvise_nb = {
+	.notifier_call	= fadvise_inject_addr,
+}
+
 /*
  * Caller needs to be make sure this cpu doesn't disappear
  * from under us, i.e.: get_cpu/put_cpu.
@@ -784,6 +795,7 @@ static int __init inject_init(void)
 
 	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify");
 	mce_register_injector_chain(&inject_nb);
+	fadvise_register_mce_injector_chain(&fadvise_nb);
 
 	setup_inj_struct(&i_mce);
 
@@ -795,6 +807,7 @@ static int __init inject_init(void)
 static void __exit inject_exit(void)
 {
 
+	fadvise_unregister_mce_injector_chain(&fadvise_nb);
 	mce_unregister_injector_chain(&inject_nb);
 	unregister_nmi_handler(NMI_LOCAL, "mce_notify");
 
-- 
2.25.1

