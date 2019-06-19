Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143F44BDF0
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfFSQXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 12:23:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49576 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfFSQXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 12:23:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGDhOF030766;
        Wed, 19 Jun 2019 16:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=L4C5DBKuJWcIqdSV5rV5f253I/cdGNQGbqVgYGJvinQ=;
 b=OUpZCnQHLkeSSEwhQmRgYD9qhhXAn64dgooovuQLAn9Wlhq4MbhABk8E2g1Q5NvzrKWS
 cXba/t1D6RJmfwyCZq1GA/u8NtLSMJa6qv5GLGz/1W7edvo3bGgBKVg2QRaZM9BMFtgS
 yaxgv4QCoA1YCdSt+dwQb6UlO7rhtdFZrLUmP64idqPx/G6aWieh2/qxxmVEMTkrNwTi
 w+XpdhvYm/wVCS1bccDdDVIgx5e0hKoxWe7SaBPZzifg/mWQbdlhbabDmNIxsE68+90n
 aWOWdu2hd4BMoY7wAo0Ut8P86Br6geLNIdGakiutM65tAnZKSozCtjjhc0E2+Rrwvib5 Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t7809cek0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JGLE4q187184;
        Wed, 19 Jun 2019 16:22:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t77yn6nu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 16:22:04 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JGM2Zg028417;
        Wed, 19 Jun 2019 16:22:02 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 09:22:02 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com, dgilbert@redhat.com,
        Liran Alon <liran.alon@oracle.com>
Subject: [QEMU PATCH v4 01/10] target/i386: kvm: Delete VMX migration blocker on vCPU init failure
Date:   Wed, 19 Jun 2019 19:21:31 +0300
Message-Id: <20190619162140.133674-2-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619162140.133674-1-liran.alon@oracle.com>
References: <20190619162140.133674-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=905
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=948 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit d98f26073beb ("target/i386: kvm: add VMX migration blocker")
added migration blocker for vCPU exposed with Intel VMX because QEMU
doesn't yet contain code to support migration of nested virtualization
workloads.

However, that commit missed adding deletion of the migration blocker in
case init of vCPU failed. Similar to invtsc_mig_blocker. This commit fix
that issue.

Fixes: d98f26073beb ("target/i386: kvm: add VMX migration blocker")
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 target/i386/kvm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 3b29ce5c0d08..7aa7914a498c 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -940,7 +940,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     r = kvm_arch_set_tsc_khz(cs);
     if (r < 0) {
-        goto fail;
+        return r;
     }
 
     /* vcpu's TSC frequency is either specified by user, or following
@@ -1295,7 +1295,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             if (local_err) {
                 error_report_err(local_err);
                 error_free(invtsc_mig_blocker);
-                return r;
+                goto fail2;
             }
         }
     }
@@ -1346,6 +1346,9 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
  fail:
     migrate_del_blocker(invtsc_mig_blocker);
+ fail2:
+    migrate_del_blocker(vmx_mig_blocker);
+
     return r;
 }
 
-- 
2.20.1

