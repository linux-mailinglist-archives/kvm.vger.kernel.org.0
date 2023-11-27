Return-Path: <kvm+bounces-2465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D63417F97FA
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 106811C208EB
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 03:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA10046AC;
	Mon, 27 Nov 2023 03:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5029EB
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 19:43:32 -0800 (PST)
X-ASG-Debug-ID: 1701056607-086e236fef27ff0001-HEqcsx
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx1.zhaoxin.com with ESMTP id NrY4m6C8f7h764DS (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 27 Nov 2023 11:43:27 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 27 Nov
 2023 11:43:27 +0800
Received: from ewan-server.zhaoxin.com (10.28.66.55) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 27 Nov
 2023 11:43:26 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
From: EwanHai <ewanhai-oc@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.163
To: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<zhao1.liu@intel.com>
CC: <qemu-devel@nongnu.org>, <cobechen@zhaoxin.com>, <ewanhai@zhaoxin.com>
Subject: [PATCH v2] target/i386/kvm: Refine VMX controls setting for backward compatibility
Date: Sun, 26 Nov 2023 22:43:26 -0500
X-ASG-Orig-Subj: [PATCH v2] target/i386/kvm: Refine VMX controls setting for backward compatibility
Message-ID: <20231127034326.257596-1-ewanhai-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1701056607
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2739
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.117308
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
execution controls") implemented a workaround for hosts that have
specific CPUID features but do not support the corresponding VMX
controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.

In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
use KVM's settings, avoiding any modifications to this MSR.

However, this commit (4a910e1) didn't account for cases in older Linux
kernels(<5.3) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
`kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
on `kvm_msr_list` alone, even though KVM maintains the value of this MSR.

This patch supplements the above logic, ensuring that
`has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
lists, thus maintaining compatibility with older kernels.

Signed-off-by: EwanHai <ewanhai-oc@zhaoxin.com>
---
In response to the suggestions from ZhaoLiu(zhao1.liu@intel.com),
the following changes have been implemented in v2:
- Adjusted some punctuation in the commit message as per the
  suggestions.
- Added comments to the newly added code to indicate that it is a
  compatibility fix.

v1 link:
https://lore.kernel.org/all/20230925071453.14908-1-ewanhai-oc@zhaoxin.com/
---
 target/i386/kvm/kvm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11b8177eff..c8f6c0b531 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2296,6 +2296,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
 static int kvm_get_supported_feature_msrs(KVMState *s)
 {
     int ret = 0;
+    int i;
 
     if (kvm_feature_msrs != NULL) {
         return 0;
@@ -2330,6 +2331,19 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
         return ret;
     }
 
+    /*
+     * Compatibility fix:
+     * Older Linux kernels(<5.3) include the MSR_IA32_VMX_PROCBASED_CTLS2
+     * only in feature msr list, but not in regular msr list. This lead to
+     * an issue in older kernel versions where QEMU, through the regular
+     * MSR list check, assumes the kernel doesn't maintain this msr,
+     * resulting in incorrect settings by QEMU for this msr.
+     */
+    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
+        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
+            has_msr_vmx_procbased_ctls2 = true;
+        }
+    }
     return 0;
 }
 
-- 
2.34.1


