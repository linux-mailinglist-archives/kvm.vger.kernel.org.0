Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8007B4CDE
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 09:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbjJBHw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 03:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbjJBHwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 03:52:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B87C9
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 00:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696233172; x=1727769172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ne8O60ozJokQr2WgOKMMWCA/CTrneWREah0s6x/I350=;
  b=eo31yzEYCMcSCBQwXcQqmqHeVkHEUiiBykotBd4R0cNhsx07fcEFEv9w
   Mli35Yj54fIo7CT7crLefhdSL4EAyl8a8qeVhwzXrOvVGtdP4Kxz7psib
   azWCxrA5qhh739zjXh5G6jZX+SF2RMepDuScyX6YyjbCM3peHdLYhO8c/
   i2lpe1Apky4RIERFEnRjSPGtp4zVmQ3vMmHxz2vzmegs30SpuTgT3dVZT
   yiaGTJ7ZN1YRzTYR9Dx9feviazjPKks4BiAu4mbqg4AkziLkwvz93fQ3z
   z+aehF+dHbtdu1atIHCtB3nldfVE36a4Znxc5p6fkYTg9/sRFBLHmAofD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="361975576"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="361975576"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 00:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="750511630"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="750511630"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 02 Oct 2023 00:52:49 -0700
From:   Xin Li <xin3.li@intel.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, richard.henderson@linaro.org,
        pbonzini@redhat.com, eduardo@habkost.net, seanjc@google.com,
        chao.gao@intel.com, hpa@zytor.com, xiaoyao.li@intel.com,
        weijiang.yang@intel.com
Subject: [PATCH v2 3/4] target/i386: enumerate VMX nested-exception support
Date:   Mon,  2 Oct 2023 00:23:12 -0700
Message-Id: <20231002072313.17603-4-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231002072313.17603-1-xin3.li@intel.com>
References: <20231002072313.17603-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow VMX nested-exception support to be exposed in KVM guests, thus
nested KVM guests can enumerate it.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 scripts/kvm/vmxcap | 1 +
 target/i386/cpu.c  | 1 +
 target/i386/cpu.h  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/scripts/kvm/vmxcap b/scripts/kvm/vmxcap
index 3fb4d5b342..97097518a8 100755
--- a/scripts/kvm/vmxcap
+++ b/scripts/kvm/vmxcap
@@ -116,6 +116,7 @@ controls = [
             54: 'INS/OUTS instruction information',
             55: 'IA32_VMX_TRUE_*_CTLS support',
             56: 'Skip checks on event error code',
+            58: 'VMX nested exception support',
             },
         msr = MSR_IA32_VMX_BASIC,
         ),
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 59fdb2a01a..da0876842f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1341,6 +1341,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             [54] = "vmx-ins-outs",
             [55] = "vmx-true-ctls",
             [56] = "vmx-any-errcode",
+            [58] = "vmx-nested-exception",
         },
         .msr = {
             .index = MSR_IA32_VMX_BASIC,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 322547aa49..f4f0c57574 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1051,6 +1051,7 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define MSR_VMX_BASIC_INS_OUTS                       (1ULL << 54)
 #define MSR_VMX_BASIC_TRUE_CTLS                      (1ULL << 55)
 #define MSR_VMX_BASIC_ANY_ERRCODE                    (1ULL << 56)
+#define MSR_VMX_BASIC_NESTED_EXCEPTION               (1ULL << 58)
 
 #define MSR_VMX_MISC_PREEMPTION_TIMER_SHIFT_MASK     0x1Full
 #define MSR_VMX_MISC_STORE_LMA                       (1ULL << 5)
-- 
2.34.1

