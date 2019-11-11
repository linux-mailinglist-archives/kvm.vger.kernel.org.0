Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E99F73E4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKKMbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:31:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKMbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:31:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCTIRF001057;
        Mon, 11 Nov 2019 12:31:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=aKddiHHlVYayzovRuxrKfK4LF30Fl4qYwwIV3QezfQk=;
 b=ORcOgt1zFWsJ8hsl39fomvtp+oMxAWMh56vrK2yCE1h9KKwzsAjQu48iK24rcEcdxgri
 qtk+jqRMj0IFookPU4RLoHhRwaCKAeg34WSUYx9sLm+tdfC86CcT0+rqQEJ1TFba/zGR
 Tua1f2aYlZH2qwvO/NHYe8wMyWpiU2E+Tay+nFRFWze3MoAAApFUa9gczAc9ADVpmaNB
 OrWpSo9qlVp8jeBtW/PnaNlonLNa9tKIgL1NzkqGkkkSK3yHJ6uSXuncobNKVzLX4IGb
 4MCQJ9rlcqXVz3lkVA6cq7S/GINoNNd+B6DTl3COtFvCuErjd4YRyRmsqn21SjNOrdbA fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qenc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:31:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCSH3U188339;
        Mon, 11 Nov 2019 12:31:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w66wm1cyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:31:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABCV69E026854;
        Mon, 11 Nov 2019 12:31:06 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 04:31:06 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH 1/2] KVM: VMX: Refactor update_cr8_intercept()
Date:   Mon, 11 Nov 2019 14:30:54 +0200
Message-Id: <20191111123055.93270-2-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191111123055.93270-1-liran.alon@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=672
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=739 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional changes.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f53b0c74f7c8..d5742378d031 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6013,17 +6013,14 @@ static void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	int tpr_threshold;
 
 	if (is_guest_mode(vcpu) &&
 		nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
 		return;
 
-	if (irr == -1 || tpr < irr) {
-		vmcs_write32(TPR_THRESHOLD, 0);
-		return;
-	}
-
-	vmcs_write32(TPR_THRESHOLD, irr);
+	tpr_threshold = ((irr == -1) || (tpr < irr)) ? 0 : irr;
+	vmcs_write32(TPR_THRESHOLD, tpr_threshold);
 }
 
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
-- 
2.20.1

