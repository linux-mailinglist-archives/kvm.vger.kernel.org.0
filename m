Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D0C6E9927
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 18:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbjDTQGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 12:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbjDTQGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 12:06:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC08035B5;
        Thu, 20 Apr 2023 09:06:14 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KFvETd010195;
        Thu, 20 Apr 2023 16:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=EbpI/971aKQfwoUvmM1GD9ss9LDLGXJ1/0UKFtBMPZA=;
 b=kspLhK0uP2SBy197aYvkKMzoaVnYrb0WZU4Trd3hhyOGBXWObCrqkzV+wuPDMOf3Qa4R
 o4ux8SscLOumjAbjRlcpLFJ3Kr5YDe5SDb9b/FfAgvWP/VLfpPWFCR0MeSMcs1SuLvT5
 WESEh/SSQq64Mevly/BFu2F4p9tg5KXX46rHULqZWO+tZsQv4CPiVlFlGGQSQ0F3PnS4
 ODIGszcSQdmcBqSwzkfaeQm13PzIBoHyjYUVsjJeABUWnUKURjZCfMM3QwMYNm/0ScIv
 cqxw++B77C6FIJuyumCf2WGjN5ndoWbWSls77SKMKRrxd6yaOBxGBh0wN1VmYWE839SZ cw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q37p2ttpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 16:06:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33K7hBGc018922;
        Thu, 20 Apr 2023 16:01:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6kh6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 16:01:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33KG1nd132178582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 16:01:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D19CB20049;
        Thu, 20 Apr 2023 16:01:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EF6120040;
        Thu, 20 Apr 2023 16:01:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 20 Apr 2023 16:01:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com,
        kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v1 1/1] KVM: s390: pv: fix asynchronous teardown for small VMs
Date:   Thu, 20 Apr 2023 18:01:49 +0200
Message-Id: <20230420160149.51728-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -O1gnL8R0qLXRgSVmcYpN8tpJ853b4mk
X-Proofpoint-ORIG-GUID: -O1gnL8R0qLXRgSVmcYpN8tpJ853b4mk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_12,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 mlxscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304200132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On machines without the Destroy Secure Configuration Fast UVC, the
topmost level of page tables is set aside and freed asynchronously
as last step of the asynchronous teardown.

Each gmap has a host_to_guest radix tree mapping host (userspace)
addresses (with 1M granularity) to gmap segment table entries (pmds).

If a guest is smaller than 2GB, the topmost level of page tables is the
segment table (i.e. there are only 2 levels). Replacing it means that
the pointers in the host_to_guest mapping would become stale and cause
all kinds of nasty issues.

This patch fixes the issue by synchronously destroying all guests with
only 2 levels of page tables in kvm_s390_pv_set_aside. This will
speed up the process and avoid the issue altogether.

Update s390_replace_asce so it refuses to replace segment type ASCEs.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
---
 arch/s390/kvm/pv.c  | 35 ++++++++++++++++++++---------------
 arch/s390/mm/gmap.c |  7 +++++++
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index e032ebbf51b9..ceb8cb628d62 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -39,6 +39,7 @@ struct pv_vm_to_be_destroyed {
 	u64 handle;
 	void *stor_var;
 	unsigned long stor_base;
+	bool small;
 };
 
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
@@ -318,7 +319,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 	if (!priv)
 		return -ENOMEM;
 
-	if (is_destroy_fast_available()) {
+	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT) {
+		/* No need to do things asynchronously for VMs under 2GB */
+		res = kvm_s390_pv_deinit_vm(kvm, rc, rrc);
+		priv->small = true;
+	} else if (is_destroy_fast_available()) {
 		res = kvm_s390_pv_deinit_vm_fast(kvm, rc, rrc);
 	} else {
 		priv->stor_var = kvm->arch.pv.stor_var;
@@ -335,7 +340,8 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return res;
 	}
 
-	kvm_s390_destroy_lower_2g(kvm);
+	if (!priv->small)
+		kvm_s390_destroy_lower_2g(kvm);
 	kvm_s390_clear_pv_state(kvm);
 	kvm->arch.pv.set_aside = priv;
 
@@ -418,7 +424,10 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 	/* If a previous protected VM was set aside, put it in the need_cleanup list */
 	if (kvm->arch.pv.set_aside) {
-		list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
+		if (((struct pv_vm_to_be_destroyed *)kvm->arch.pv.set_aside)->small)
+			kfree(kvm->arch.pv.set_aside);
+		else
+			list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
 		kvm->arch.pv.set_aside = NULL;
 	}
 
@@ -485,26 +494,22 @@ int kvm_s390_pv_deinit_aside_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	if (!p)
 		return -EINVAL;
 
-	/* When a fatal signal is received, stop immediately */
-	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX))
+	if (p->small)
 		goto done;
-	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
-		ret = -EIO;
-	kfree(p);
-	p = NULL;
-done:
-	/*
-	 * p is not NULL if we aborted because of a fatal signal, in which
-	 * case queue the leftover for later cleanup.
-	 */
-	if (p) {
+	/* When a fatal signal is received, stop immediately */
+	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX)) {
 		mutex_lock(&kvm->lock);
 		list_add(&p->list, &kvm->arch.pv.need_cleanup);
 		mutex_unlock(&kvm->lock);
 		/* Did not finish, but pretend things went well */
 		*rc = UVC_RC_EXECUTED;
 		*rrc = 42;
+		return 0;
 	}
+	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
+		ret = -EIO;
+done:
+	kfree(p);
 	return ret;
 }
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 5a716bdcba05..2267cf9819b2 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2833,6 +2833,9 @@ EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
  * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
  * @gmap: the gmap whose ASCE needs to be replaced
  *
+ * If the ASCE is a SEGMENT type then this function will return -EINVAL,
+ * otherwise the pointers in the host_to_guest radix tree will keep pointing
+ * to the wrong pages, causing use-after-free and memory corruption.
  * If the allocation of the new top level page table fails, the ASCE is not
  * replaced.
  * In any case, the old ASCE is always removed from the gmap CRST list.
@@ -2847,6 +2850,10 @@ int s390_replace_asce(struct gmap *gmap)
 
 	s390_unlist_old_asce(gmap);
 
+	/* Replacing segment type ASCEs would cause serious issues */
+	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
+		return -EINVAL;
+
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
-- 
2.39.2

