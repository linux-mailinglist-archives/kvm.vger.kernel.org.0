Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1690D103A09
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 13:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfKTM2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 07:28:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34900 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbfKTM2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 07:28:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKC93bm048834;
        Wed, 20 Nov 2019 12:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=HcfXjW7i3DttquHo0+qv6rMXzKPvIwZKw2tsvZKypvw=;
 b=fQ0H+N8qOxUE+WEuHFgNolPD+G5hXK1pKjxW7Da8+3rczxU6fEo60DiNkN3RWzhUDkvX
 Qle8VZP/kur7C/zNuGMRrqmX1qVNK9PdDwXd88AlMNmnl1cJVpAg3SilEATddkmCsiut
 hRVAZdnJjurzxUqgbprbazUcXgFZknCRVGEBaltTVcM8Zbh/IagyGfHVUOQo0sv1N3H9
 ijjcWfRqVXRIUdfgMHWPjs1WB8kZOKaY59z7xv+HB7a1lv3UT/ReFP6kFMmueEq3WOjl
 B27hrw4fan08QSQthoneQz4tS0ok5uDOKFYbOP3jVX68jEpzRAiefCSgfAdoXioREKu+ +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wa92pw7f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 12:28:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKCCuwx026291;
        Wed, 20 Nov 2019 12:26:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wd47v37wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 12:26:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKCQ5d8005586;
        Wed, 20 Nov 2019 12:26:05 GMT
Received: from localhost.localdomain (/10.74.127.98)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 04:26:05 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH] KVM: nVMX: Assume TLB entries of L1 and L2 are tagged differently if L0 use EPT
Date:   Wed, 20 Nov 2019 14:24:52 +0200
Message-Id: <20191120122452.57462-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=655
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=733 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 1313cc2bd8f6 ("kvm: mmu: Add guest_mode to kvm_mmu_page_role"),
guest_mode was added to mmu-role and therefore if L0 use EPT, it will
always run L1 and L2 with different EPTP. i.e. EPTP01!=EPTP02.

Because TLB entries are tagged with EP4TA, KVM can assume
TLB entries populated while running L2 are tagged differently
than TLB entries populated while running L1.

Therefore, update nested_has_guest_tlb_tag() to consider if
L0 use EPT instead of if L1 use EPT.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 229ca7164318..fdcead2d4dd6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1024,7 +1024,9 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
  * populated by L2 differently than TLB entries populated
  * by L1.
  *
- * If L1 uses EPT, then TLB entries are tagged with different EPTP.
+ * If L0 uses EPT, L1 and L2 run with different EPTP because
+ * guest_mode is part of kvm_mmu_page_role. Thus, TLB entries
+ * are tagged with different EPTP.
  *
  * If L1 uses VPID and we allocated a vpid02, TLB entries are tagged
  * with different VPID (L1 entries are tagged with vmx->vpid
@@ -1034,7 +1036,7 @@ static bool nested_has_guest_tlb_tag(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
-	return nested_cpu_has_ept(vmcs12) ||
+	return enable_ept ||
 	       (nested_cpu_has_vpid(vmcs12) && to_vmx(vcpu)->nested.vpid02);
 }
 
-- 
2.20.1

