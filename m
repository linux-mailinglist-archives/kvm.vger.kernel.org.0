Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364187BF603
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442919AbjJJIfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442898AbjJJIfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1450DA4;
        Tue, 10 Oct 2023 01:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926934; x=1728462934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7pCDbhKS6+u2jcznAubfaRxlAgJtSYbB0zCkXhtCcE=;
  b=keJcEqYFaOJEYzUkdJs8Jft5Ct6gYDwV5Lf18cWLvqtj64Kif8BUg2r2
   1dEaf9aaXoipwdTjWVzuXgdfobvcwluduObiJeCQoLSk3p151Kd0C2iMg
   6vzMDb+Rh+CBdKeE0F0d6RfRqxJ08xEYm9VFMmGFj2zxcV9MPdrskqYoU
   2srdz334BLAsk0fpy1PBsE1A+1OwIfVGqsg8Wr3Is1gaV4/Gbeg0h5eTY
   Q3NA/BDiabkx5f0HO6/ec9HBbokMe3edoknx9tN4qEi1Vie1f+64QI7hw
   SLKBWbUSf4IbLRsfWduakHttw1NZtQWtgKyBdiy8mhzx9lBm8/9t9ymJh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689792"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689792"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687182"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687182"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:33 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 03/12] x86/mce/inject: Add notrigger entry to suppress MCE injection
Date:   Tue, 10 Oct 2023 01:35:11 -0700
Message-Id: <97809b68e427922948044e33599c2fc7c9f6134c.1696926843.git.isaku.yamahata@intel.com>
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

The current x86 MCE injection framework injects MCE when writing to
/sys/kernel/debug/mce-inject/bank.  KVM wants to inject machine check on
behalf of vcpu context instead of the context of writing to the bank file.

Because ACPI APEI has a similar requirement and it adds
/sys/kernel/debug/apei/notrigger to suppress immediate injection.
By Following it, add /sys/kernel/debug/mce-inject/notrigger to suppress
MCE injection.

The alternative is add new value "notrigger" to
/sys/kernel/debug/mce-inject/flags in addition to "sw", "hw", "df", and
"th".  Because it may break user space ABI, this option follow ACPI APEI
error injection.

Supposed usage flow:
$ echo 1 > notrigger
  ... setup MCE values
$ echo 0 > bank
  The last step to setup mce value to inject with MC bank 0.
  Originally this step injects mce.  With noijnect=1, don't inject.

$ echo 1 > /sys/kernel/debug/kvm/<pid>-<fd>/vcpu<N>/mce-inject
  tell KVM to inject MCE in the context of vcpu.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kernel/cpu/mce/inject.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 461858ae18f9..88603a6c0afe 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -34,6 +34,7 @@
 #include "internal.h"
 
 static bool hw_injection_possible;
+static u64 notrigger;
 
 /*
  * Collect all the MCi_XXX settings
@@ -598,6 +599,8 @@ static int inj_bank_set(void *data, u64 val)
 	}
 
 	m->bank = val;
+	if (notrigger)
+		return 0;
 
 	/*
 	 * sw-only injection allows to write arbitrary values into the MCA
@@ -637,6 +640,21 @@ MCE_INJECT_GET(bank);
 
 DEFINE_SIMPLE_ATTRIBUTE(bank_fops, inj_bank_get, inj_bank_set, "%llu\n");
 
+static int inj_notrigger_get(void *data, u64 *val)
+{
+	*val = notrigger;
+	return 0;
+}
+
+static int inj_notrigger_set(void *data, u64 val)
+{
+	notrigger = val;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(notrigger_fops, inj_notrigger_get, inj_notrigger_set,
+			"%llx\n");
+
 static const char readme_msg[] =
 "Description of the files and their usages:\n"
 "\n"
@@ -685,6 +703,9 @@ static const char readme_msg[] =
 "\n"
 "mcgstatus:\t Set MCG_STATUS: the bits in that MSR describes the current state\n"
 "\t of the processor after the MCE.\n"
+"\n"
+"notrigger:\t Suppress triggering the injection when set to non-zero\n"
+"\t The injection is triggered by other way.\n"
 "\n";
 
 static ssize_t
@@ -714,6 +735,8 @@ static struct dfs_node {
 	{ .name = "cpu",	.fops = &extcpu_fops, .perm = S_IRUSR | S_IWUSR },
 	{ .name = "mcgstatus",	.fops = &mcgstatus_fops,
 						      .perm = S_IRUSR | S_IWUSR },
+	{ .name = "notrigger",	.fops = &notrigger_fops,
+						      .perm = S_IRUSR | S_IWUSR },
 	{ .name = "README",	.fops = &readme_fops, .perm = S_IRUSR | S_IRGRP | S_IROTH },
 };
 
-- 
2.25.1

