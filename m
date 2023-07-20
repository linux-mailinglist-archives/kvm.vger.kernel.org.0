Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76E75BB40
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 01:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjGTXdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 19:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjGTXdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 19:33:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA449273A;
        Thu, 20 Jul 2023 16:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689895996; x=1721431996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=54f6oGhMQOvzfr4uV0Pwhmi/Poh/uRJMyo79eGxiezU=;
  b=BlOfBC6SMptz3gZ5eLCSfnFKDivgO+dvCKtAsnh9cRZkEvuBs1un6czK
   dRbmCIBhAD6mlRv97G0MTCprlutpq9qsO9dOVIcnVo8aUPBC74g/xFn++
   Wq9OYi7qzHCJKxQPfoAXaT63kaWlHA9B8yl2FFM70W+iunVANMh5rByvM
   VBd0d2g48j6WIDowFGjtE4xMXXqMhclGtPDlHr3SoK4qMbS4G1Fx1saZs
   96i7qcvdgz3svzO5fWT/1wK1BBChLcaaLl6PJYCDorx9RW6rdERtkf7OS
   Tc0mbb7oabIFUD2cu60+4Pm7wfI9HZC2L5KqOz6Mas0uF46crJ616gMud
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364355976"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="364355976"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="727891811"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="727891811"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v4 10/10] KVM: X86: KVM_MEM_ENC_OP check if unused field (flags, error) is zero
Date:   Thu, 20 Jul 2023 16:32:56 -0700
Message-Id: <cf4e12dbe7d8d759ff87e088ade54bd710926d1e.1689893403.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1689893403.git.isaku.yamahata@intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This breaks uABI as the current code doesn't check padding and sev_fd
when unused.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v3 -> v4:
- newly added
---
 arch/x86/kvm/x86.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab36e8940f1b..1d6085af6a00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7055,6 +7055,22 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			r = -EFAULT;
 			goto out;
 		}
+		/* No sub-command uses flags at the moment. */
+		if (cmd.flags) {
+			r = -EINVAL;
+			goto out;
+		}
+		if (cmd.id != KVM_SEV_LAUNCH_START &&
+		    cmd.id != KVM_SEV_RECEIVE_START && cmd.error64) {
+			r = -EINVAL;
+			goto out;
+		}
+		if ((cmd.id == KVM_SEV_LAUNCH_START ||
+		     cmd.id == KVM_SEV_RECEIVE_START) && cmd.error) {
+			r = -EINVAL;
+			goto out;
+		}
+
 		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, &cmd);
 		if (copy_to_user(argp, &cmd, sizeof(cmd)))
 			r = -EFAULT;
-- 
2.25.1

