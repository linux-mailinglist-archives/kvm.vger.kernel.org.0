Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D02F98B0
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 19:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKLSdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 13:33:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLSdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 13:33:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACIT7mx051885;
        Tue, 12 Nov 2019 18:33:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=wWQ+XXCF5YgQMrnaRY3fZBO2NMN3YdL3c3lbS2dt2/c=;
 b=TuKPxAdaxFY/A/1EKvGJ7enR9fp9iOLKjMPyLhyoX7SngmG6fpGNXtIqTyNNQ4+L0Fo2
 m8JcGXNvO28nuvvdMby+3omhKBd61dMV0wPWnrRXa1rGuLPK8DhDBx4m5BBiPKmI0kLa
 Ha6hedZPynXVgkgZvwSg56aS6NvWx91mIxSwcRGAIL9D+AivzuHB22tmI1p263FsrEzH
 /OXVkjS3+d/hQFNBmtEeSLVtQa9jYZo1/QsMIdspyFSOVcYPIh+5K7G4u6EKDNMAttNF
 YB/rjvT5SzI+oRyQEt1QEwbMrZt5UeaYgOTqdMa4b7mWjoO63t4rnLRoDOIOmF9WtB5D QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3qpq6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 18:33:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACINJTc091336;
        Tue, 12 Nov 2019 18:33:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w7vbb94k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 18:33:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xACIX6oZ005435;
        Tue, 12 Nov 2019 18:33:06 GMT
Received: from Lirans-MBP.Home (/109.64.228.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 10:33:06 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Bhavesh Davda <bhavesh.davda@oracle.com>
Subject: [PATCH] KVM: x86: Optimization: Requst TLB flush in fast_cr3_switch() instead of do it directly
Date:   Tue, 12 Nov 2019 20:33:00 +0200
Message-Id: <20191112183300.6959-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM emulates a nested VMEntry (L1->L2 VMEntry), it switches mmu root
page. If nEPT is used, this will happen from
kvm_init_shadow_ept_mmu()->__kvm_mmu_new_cr3() and otherwise it will
happpen from nested_vmx_load_cr3()->kvm_mmu_new_cr3(). Either case,
__kvm_mmu_new_cr3() will use fast_cr3_switch() in attempt to switch to a
previously cached root page.

In case fast_cr3_switch() finds a matching cached root page, it will
set it in mmu->root_hpa and request KVM_REQ_LOAD_CR3 such that on
next entry to guest, KVM will set root HPA in appropriate hardware
fields (e.g. vmcs->eptp). In addition, fast_cr3_switch() calls
kvm_x86_ops->tlb_flush() in order to flush TLB as MMU root page
was replaced.

This works as mmu->root_hpa, which vmx_flush_tlb() use, was
already replaced in cached_root_available(). However, this may
result in unnecessary INVEPT execution because a KVM_REQ_TLB_FLUSH
may have already been requested. For example, by prepare_vmcs02()
in case L1 don't use VPID.

Therefore, change fast_cr3_switch() to just request TLB flush on
next entry to guest.

Reviewed-by: Bhavesh Davda <bhavesh.davda@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24c23c66b226..150d982ec1d2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4295,7 +4295,7 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
 			if (!skip_tlb_flush) {
 				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-				kvm_x86_ops->tlb_flush(vcpu, true);
+				kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 			}
 
 			/*
-- 
2.20.1

