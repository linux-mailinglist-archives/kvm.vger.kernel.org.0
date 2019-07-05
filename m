Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99EF60CF0
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 23:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfGEVHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 17:07:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfGEVHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 17:07:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L3vH1025588;
        Fri, 5 Jul 2019 21:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=sSX5aIb6pbrZni5vNE5EzSGZsrAPvnkvicgxxh+1deg=;
 b=2H2Sg3VC4gyG44Hc9EYoACCOWiSas3tNxNak7pFM/GjtmLcn4NaP+lF7Gi5gUUiRpFcV
 BNgFRxOz3dMuDHW9u9ov6E3HeBKMakwGHIMY+aPXNZY8jZMutGv5QS60V8TfLeWC10wM
 OiG4jCx0h8+wu8Xgz0U4SlUF0rz74fpq+tF8jUk/T1RIa5dkBr80v2PD7Du/FPeJRiSL
 9NsjjvSnY2brUcu+pO0qy7NT71quMm15aofCwtqzyK3tlgqD0QXW5AxLc3zIFhFVFlzt
 CGF/xzHtIs0LjhCv4nSyIYdD+B6PTJiiqcxt09Bqr9ecAW/kmZgoa1Nt9lC/k4vtg5ST bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tc4j6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:07:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L2ULs175825;
        Fri, 5 Jul 2019 21:07:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2th5qmx76h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:07:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65L70ax030850;
        Fri, 5 Jul 2019 21:07:00 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 14:07:00 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH 2/4] target/i386: kvm: Init nested-state for vCPU exposed with SVM
Date:   Sat,  6 Jul 2019 00:06:34 +0300
Message-Id: <20190705210636.3095-3-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190705210636.3095-1-liran.alon@oracle.com>
References: <20190705210636.3095-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=827
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050266
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=871 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050266
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/cpu.h | 5 +++++
 target/i386/kvm.c | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 93345792f4cb..cdb0e43676a9 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1867,6 +1867,11 @@ static inline bool cpu_has_vmx(CPUX86State *env)
     return env->features[FEAT_1_ECX] & CPUID_EXT_VMX;
 }
 
+static inline bool cpu_has_svm(CPUX86State *env)
+{
+    return env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM;
+}
+
 /* fpu_helper.c */
 void update_fp_status(CPUX86State *env);
 void update_mxcsr_status(CPUX86State *env);
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index b57f873ec9e8..4e2c8652168f 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1721,6 +1721,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
             env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
             vmx_hdr->vmxon_pa = -1ull;
             vmx_hdr->vmcs12_pa = -1ull;
+        } else if (cpu_has_svm(env)) {
+            env->nested_state->format = KVM_STATE_NESTED_FORMAT_SVM;
         }
     }
 
-- 
2.20.1

