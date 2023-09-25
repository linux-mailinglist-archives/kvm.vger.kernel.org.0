Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D937AD137
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjIYHPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjIYHPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:15:05 -0400
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DD0B8
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 00:14:58 -0700 (PDT)
X-ASG-Debug-ID: 1695626094-1eb14e75133b550001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id MSxhqgC9b91u0ZgS (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 25 Sep 2023 15:14:54 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 25 Sep
 2023 15:14:54 +0800
Received: from ewan-server.zhaoxin.com (10.28.66.44) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 25 Sep
 2023 15:14:53 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
From:   EwanHai <ewanhai-oc@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.163
To:     <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>
CC:     <qemu-devel@nongnu.org>
Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for backward compatibility
Date:   Mon, 25 Sep 2023 03:14:53 -0400
X-ASG-Orig-Subj: [PATCH] target/i386/kvm: Refine VMX controls setting for backward compatibility
Message-ID: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.28.66.44]
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1695626094
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1962
X-Barracuda-BRTS-Status: 0
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.114571
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
execution controls") implemented a workaround for hosts that have
specific CPUID features but do not support the corresponding VMX
controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.

In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
use KVM's settings, avoiding any modifications to this MSR.

However, this commit (4a910e1) didn’t account for cases in older Linux
kernels(e.g., linux-4.19.90) where `MSR_IA32_VMX_PROCBASED_CTLS2` is
in `kvm_feature_msrs`—obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
but not in `kvm_msr_list`—obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
on `kvm_msr_list` alone, even though KVM maintains the value of this MSR.

This patch supplements the above logic, ensuring that
`has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
lists, thus maintaining compatibility with older kernels.

Signed-off-by: EwanHai <ewanhai-oc@zhaoxin.com>
---
 target/i386/kvm/kvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index af101fcdf6..6299284de4 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
 static int kvm_get_supported_feature_msrs(KVMState *s)
 {
     int ret = 0;
+    int i;
 
     if (kvm_feature_msrs != NULL) {
         return 0;
@@ -2377,6 +2378,11 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
         return ret;
     }
 
+    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
+        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
+            has_msr_vmx_procbased_ctls2 = true;
+        }
+    }
     return 0;
 }
 
-- 
2.34.1

