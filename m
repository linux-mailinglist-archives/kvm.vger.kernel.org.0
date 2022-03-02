Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB624CAD2D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242095AbiCBSN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244507AbiCBSMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:12:50 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F54AD2244;
        Wed,  2 Mar 2022 10:11:59 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222I7YTY036391;
        Wed, 2 Mar 2022 18:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pkMO05K2nVI1b3Y9zLiy7i/+2Gxyhk7URi3/AHd/ND0=;
 b=EZKt5LjCnPMZ/9y2/BP13C+CNQ0B9VoHZgZ8ME/W5EA1WGpxKp/8GZnfb8LFYxQQk+Qy
 vGwZaHZUKsy9BiMhv+/Cxfrk41zXqsMFJUV2dvUMw2awx88XLu9aY5CrVkqYt5ihcKgP
 jIhu5Mb+GnqfGZEfu+anotKL3WmG0zjgG6aXnym0GnUYX2MUqKuVEg8aaLwgEvT7y3AV
 rg6gaZ80u3sf3M/pAuYt2SNqcnr/JQvl02N5YECF2G8bTah0B38glUPzy5VltGhs7AKf
 WrL3Y1v8QwWwqy29+w3rukcep9tu7TETJR4V3QvY9iUl962Soic3esk6Qwal8T1VHWBJ 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbj4u0dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:58 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222I9CCw018576;
        Wed, 2 Mar 2022 18:11:57 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbj4u0d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222I8suH000600;
        Wed, 2 Mar 2022 18:11:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3efbu9fkwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222IBpoQ32965104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 18:11:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B246B52050;
        Wed,  2 Mar 2022 18:11:51 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 36A9A52051;
        Wed,  2 Mar 2022 18:11:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 13/17] KVM: s390: pv: cleanup leftover protected VMs if needed
Date:   Wed,  2 Mar 2022 19:11:39 +0100
Message-Id: <20220302181143.188283-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302181143.188283-1-imbrenda@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i8SYCAsDt9N0_LEV7d7HIDVP2ArLpcGH
X-Proofpoint-GUID: _gfp1WGpM5DjD2pO8nFPls1aS-xZDE9G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 clxscore=1015 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2203020078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In upcoming patches it will be possible to start tearing down a
protected VM, and finish the teardown concurrently in a different
thread.

Protected VMs that are pending for tear down ("leftover") need to be
cleaned properly when the userspace process (e.g. qemu) terminates.

This patch makes sure that all "leftover" protected VMs are always
properly torn down.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/pv.c               | 69 ++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 1bccb8561ba9..50e3516cbc03 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -922,6 +922,8 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	void *async_deinit;
+	struct list_head need_cleanup;
 	struct mmu_notifier mmu_notifier;
 };
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 446f89db93a1..3637f556ff33 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2788,6 +2788,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_s390_vsie_init(kvm);
 	if (use_gisa)
 		kvm_s390_gisa_init(kvm);
+	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
 	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
 
 	return 0;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index be3b467f8feb..56412617dd01 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -17,6 +17,19 @@
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
 
+/**
+ * @struct deferred_priv
+ * Represents a "leftover" protected VM that does not correspond to any
+ * active KVM VM.
+ */
+struct deferred_priv {
+	struct list_head list;
+	unsigned long old_table;
+	u64 handle;
+	void *stor_var;
+	unsigned long stor_base;
+};
+
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
 {
 	kvm->arch.pv.handle = 0;
@@ -163,6 +176,60 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	return -ENOMEM;
 }
 
+/**
+ * kvm_s390_pv_cleanup_deferred - Clean up one leftover protected VM.
+ * @kvm the KVM that was associated with this leftover protected VM
+ * @deferred details about the leftover protected VM that needs a clean up
+ * Return: 0 in case of success, otherwise 1
+ */
+static int kvm_s390_pv_cleanup_deferred(struct kvm *kvm, struct deferred_priv *deferred)
+{
+	u16 rc, rrc;
+	int cc;
+
+	cc = uv_cmd_nodata(deferred->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", rc, rrc);
+	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
+	if (cc)
+		return cc;
+	/*
+	 * Intentionally leak unusable memory. If the UVC fails, the memory
+	 * used for the VM and its metadata is permanently unusable.
+	 * This can only happen in case of a serious KVM or hardware bug; it
+	 * is not expected to happen in normal operation.
+	 */
+	free_pages(deferred->stor_base, get_order(uv_info.guest_base_stor_len));
+	free_pages(deferred->old_table, CRST_ALLOC_ORDER);
+	vfree(deferred->stor_var);
+	return 0;
+}
+
+/**
+ * kvm_s390_pv_cleanup_leftovers - Clean up all leftover protected VMs.
+ * @kvm the KVM whose leftover protected VMs are to be cleaned up
+ * Return: 0 in case of success, otherwise 1
+ */
+static int kvm_s390_pv_cleanup_leftovers(struct kvm *kvm)
+{
+	struct deferred_priv *deferred;
+	int cc = 0;
+
+	if (kvm->arch.pv.async_deinit)
+		list_add(kvm->arch.pv.async_deinit, &kvm->arch.pv.need_cleanup);
+
+	while (!list_empty(&kvm->arch.pv.need_cleanup)) {
+		deferred = list_first_entry(&kvm->arch.pv.need_cleanup, typeof(*deferred), list);
+		if (kvm_s390_pv_cleanup_deferred(kvm, deferred))
+			cc = 1;
+		else
+			atomic_dec(&kvm->mm->context.protected_count);
+		list_del(&deferred->list);
+		kfree(deferred);
+	}
+	kvm->arch.pv.async_deinit = NULL;
+	return cc;
+}
+
 /* this should not fail, but if it does, we must not free the donated memory */
 int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
@@ -190,6 +257,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
 
+	cc |= kvm_s390_pv_cleanup_leftovers(kvm);
+
 	return cc ? -EIO : 0;
 }
 
-- 
2.34.1

