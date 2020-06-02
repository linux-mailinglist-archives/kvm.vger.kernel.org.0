Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32711EC378
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 22:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgFBUJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 16:09:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBUJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 16:09:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JulYa168523;
        Tue, 2 Jun 2020 20:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=u/fCzrRFXKu5OAm9GMeH7Ay3Emb8+njH7NIt5wH2t7s=;
 b=XxzlY4sx0sWv3jxz/jxMxRKHZbtYjTb4uPOXU6PqmOUn1rrF8AWxyLpzLb5NsBW8Bgdo
 fA4ldu1DD/ctT2BLahOqOvdaZ39DBwyrCyoEXtRkaWLlQQ6TJKHxp9EjJGpzs9qfDHtV
 wf4RgX3WbfUHm2SLSEc1oATP34jBAPj1ZmqeRbyU8xNV50qps5/GKfuhKLp3zU3RSkNU
 AuOpo/SDe7PJisvroC4QOLKJld8rCZmqmP8OaX/9bo2X1hJ9EJitun2meX/mpzHVc7+w
 bpGVYYeYj6pkUCA4OY1SjjJgOi3BpXer8h9HSn9+H/KxUw88Prj9l597+o/5xnHLXzyW wA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31bfem5uch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 20:07:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JxHrQ135232;
        Tue, 2 Jun 2020 20:07:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dxtrmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 20:07:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052K7cb2022814;
        Tue, 2 Jun 2020 20:07:38 GMT
Received: from ayz-linux.us.oracle.com (/10.154.185.88)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 13:07:38 -0700
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        steven.sistare@oracle.com, anthony.yznaga@oracle.com
Subject: [PATCH 1/3] KVM: x86: remove unnecessary rmap walk of read-only memslots
Date:   Tue,  2 Jun 2020 13:07:28 -0700
Message-Id: <1591128450-11977-2-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
References: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no write access to remove.  An existing memslot cannot be updated
to set or clear KVM_MEM_READONLY, and any mappings established in a newly
created or moved read-only memslot will already be read-only.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 arch/x86/kvm/x86.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..23fd888e52ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10038,11 +10038,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     struct kvm_memory_slot *new)
 {
-	/* Still write protect RO slot */
-	if (new->flags & KVM_MEM_READONLY) {
-		kvm_mmu_slot_remove_write_access(kvm, new, PT_PAGE_TABLE_LEVEL);
+	/* Nothing to do for RO slots */
+	if (new->flags & KVM_MEM_READONLY)
 		return;
-	}
 
 	/*
 	 * Call kvm_x86_ops dirty logging hooks when they are valid.
-- 
2.13.3

