Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A2760CF1
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfGEVH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 17:07:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfGEVH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 17:07:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L40Y7119968;
        Fri, 5 Jul 2019 21:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=HMkjJwPA8RsubI7elVoiQ6HwDpd2t3xNOxViQul4hvM=;
 b=UWDRNAQQhedLQBnYxQDgCyjveW7efcxIg2zD1MkEVWCJPYl0bx8WiQPURPCdtwuuZQts
 C1kK68oiUMwJa36kym/uGPsTDQKnTYTuEdXJL86Y7G/gI0eWtG3/72lmrwxQliqM4U5x
 7YzQ8xoS0tELP/JvPAgPCZlVvnVQteFQ5iJw1DfotHzDA7/ICzL83Q/9Q5wkPvy8L4bs
 GpWUNBx+v9fuTT1EvWnOq7gvZAefX3pngXXHHH09ahHU+2lzTp6osMe/NbPJ+OrgpeMF
 tpcSAmppkaRIb8z61/Wy8VNvWwSS3pobU/2kd1fkq29zHCu31mmtutX3VtwsjiX5XsIh lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2te61emgfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:07:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65L2WNq175954;
        Fri, 5 Jul 2019 21:07:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2th5qmx762-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 21:07:00 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65L6wQa013862;
        Fri, 5 Jul 2019 21:06:58 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 14:06:58 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH 1/4] target/i386: kvm: Init nested-state for VMX when vCPU expose VMX
Date:   Sat,  6 Jul 2019 00:06:33 +0300
Message-Id: <20190705210636.3095-2-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190705210636.3095-1-liran.alon@oracle.com>
References: <20190705210636.3095-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=832
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050266
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=887 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050266
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index e4b4f5756a34..b57f873ec9e8 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1714,7 +1714,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
         env->nested_state->size = max_nested_state_len;
 
-        if (IS_INTEL_CPU(env)) {
+        if (cpu_has_vmx(env)) {
             struct kvm_vmx_nested_state_hdr *vmx_hdr =
                 &env->nested_state->hdr.vmx;
 
-- 
2.20.1

