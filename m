Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA6E7BF610
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442944AbjJJIfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442904AbjJJIfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3700A9;
        Tue, 10 Oct 2023 01:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926934; x=1728462934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P/4mWGyVldhGd+8X9JavsKnqWkSdr5BRdzY15fml+QM=;
  b=TXtGdIVmyIfDzT0j0xxDxgAhXbLmgFGAG7CP7kOCvDdScSpr+yqifDdn
   G77awRNEGPB1tib+/yYoa4S/36LoYe2EIfpY98uWGrd/f/4N4rse+jgT4
   JVTvy6ZB1ktgkHc4N/CdRBd0QOK3r6/9auDfDBbJGaif73i5g3uxKDTvK
   QrfyvonDpMftCyDQrTPYCirIqyeO6pycWf0mMdI9ghOno4QcFDRDfLxc3
   JL1eiKYItbu63b7nX9yIIpJ/a72jQwRAf0O5qNt30irQBJTKIYq93jKL0
   6/+ISSEtMpfG9EzmqQXrK9iOeCQCWwQc1c151b/XyRh/Y67EJ4ChqQTvK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="387176601"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="387176601"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="730001332"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="730001332"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:32 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 02/12] X86/mce/inject: Add mcgstatus for mce-inject debugfs
Date:   Tue, 10 Oct 2023 01:35:10 -0700
Message-Id: <062049a8ebfaa7bf14fe22ddb5e48f5b660e3332.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

To test KVM x86 to inject machine check with memory failure, it wants to
to set LMCE_S (local machine check exception signaled) for memory failure
injection test.  The current code sets mcgstatus based on the other values
and can't set LMCE_S flag.

Add mcgstatus entry to allow to set mcgstatus value.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kernel/cpu/mce/inject.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 881898a1d2f4..461858ae18f9 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -72,6 +72,7 @@ static int inj_##reg##_set(void *data, u64 val)				\
 	return 0;							\
 }
 
+MCE_INJECT_SET(mcgstatus);
 MCE_INJECT_SET(status);
 MCE_INJECT_SET(misc);
 MCE_INJECT_SET(addr);
@@ -86,12 +87,14 @@ static int inj_##reg##_get(void *data, u64 *val)			\
 	return 0;							\
 }
 
+MCE_INJECT_GET(mcgstatus);
 MCE_INJECT_GET(status);
 MCE_INJECT_GET(misc);
 MCE_INJECT_GET(addr);
 MCE_INJECT_GET(synd);
 MCE_INJECT_GET(ipid);
 
+DEFINE_SIMPLE_ATTRIBUTE(mcgstatus_fops, inj_mcgstatus_get, inj_mcgstatus_set, "%llx\n");
 DEFINE_SIMPLE_ATTRIBUTE(status_fops, inj_status_get, inj_status_set, "%llx\n");
 DEFINE_SIMPLE_ATTRIBUTE(misc_fops, inj_misc_get, inj_misc_set, "%llx\n");
 DEFINE_SIMPLE_ATTRIBUTE(addr_fops, inj_addr_get, inj_addr_set, "%llx\n");
@@ -679,6 +682,9 @@ static const char readme_msg[] =
 "\t    APIC interrupt handler to handle the error. \n"
 "\n"
 "ipid:\t IPID (AMD-specific)\n"
+"\n"
+"mcgstatus:\t Set MCG_STATUS: the bits in that MSR describes the current state\n"
+"\t of the processor after the MCE.\n"
 "\n";
 
 static ssize_t
@@ -706,6 +712,8 @@ static struct dfs_node {
 	{ .name = "bank",	.fops = &bank_fops,   .perm = S_IRUSR | S_IWUSR },
 	{ .name = "flags",	.fops = &flags_fops,  .perm = S_IRUSR | S_IWUSR },
 	{ .name = "cpu",	.fops = &extcpu_fops, .perm = S_IRUSR | S_IWUSR },
+	{ .name = "mcgstatus",	.fops = &mcgstatus_fops,
+						      .perm = S_IRUSR | S_IWUSR },
 	{ .name = "README",	.fops = &readme_fops, .perm = S_IRUSR | S_IRGRP | S_IROTH },
 };
 
-- 
2.25.1

