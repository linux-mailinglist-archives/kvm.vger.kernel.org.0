Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5685C61445
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfGGHlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 03:41:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45114 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfGGHlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 03:41:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677cfAt175051;
        Sun, 7 Jul 2019 07:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=SZ0XgHuMQtIySRB39a2wiqkaSRgMfkXBK4JPQMvzqf4=;
 b=rZrj5wzfVMHfRLh7xo18nOJf3pJVHXwZCt1cJ+Zi8q1U/YBBh4TxpTsLWo1rjpyPgB05
 qK4tcey4MT4eSa1MqpvkVTC8IHfMIecu6z063WyS0L8NZiRRjbDqrWWYMADSOhMz4q7r
 X/id3QTFcP8N3l6OqUbrpsJUurBJeviu22h0+Xuyc28HEFjuPliy+l/7UicLckBLQv5V
 Hx/2/GFMWG7yhJrxi27o/z2glp8apUAgHXgqHsDaYF6WO4YV8prGTOrIto6P6HtzQR/B
 f9GQbwPtbmidgXG9V+GSBy2uevBAYR44Cph7U6mq9/UBMO7rQAN/+wKS2/v/hw8WHtbq cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tjm9qa8f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:41:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677cLQQ104909;
        Sun, 7 Jul 2019 07:39:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tjkf1swpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x677dMnb014615;
        Sun, 7 Jul 2019 07:39:22 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 07:39:22 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 3/5] KVM: nVMX: Skip VM-Entry Control checks that are necessary only if VMCS12 is dirty
Date:   Sun,  7 Jul 2019 03:11:45 -0400
Message-Id: <20190707071147.11651-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=513
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=560 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 ..so that every nested vmentry is not slowed down by those checks.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 056eba497730..ffeeeb5ff520 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2534,6 +2534,15 @@ static int nested_check_vm_exit_controls(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int nested_check_vm_entry_controls_full(struct kvm_vcpu *vcpu,
+					       struct vmcs12 *vmcs12)
+{
+	if (nested_vmx_check_entry_msr_switch_controls(vcpu, vmcs12))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Checks related to VM-Entry Control Fields
  */
@@ -2603,7 +2612,8 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (nested_vmx_check_entry_msr_switch_controls(vcpu, vmcs12))
+	if ((vmx->nested.dirty_vmcs12) &&
+	    nested_check_vm_entry_controls_full(vcpu, vmcs12))
 		return -EINVAL;
 
 	return 0;
-- 
2.20.1

