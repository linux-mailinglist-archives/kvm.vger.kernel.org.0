Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74955E85C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347056AbiF1N5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346939AbiF1N4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:56:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D48B338BA;
        Tue, 28 Jun 2022 06:56:34 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDAwZn016557;
        Tue, 28 Jun 2022 13:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eTw9yQe3/izu77Ytzq0yZJvH0DuwII33Exc48mkk8Ug=;
 b=Wu15kyIAsYOaxQX9LX/6Sm+Bk6DdU7ZhODGqqhN7yu6ZAinzPrIbCBV/OZef5kZfwPff
 y2if8hF8xahdTa1xXb6yb+W51DLk+j1g9VeJemWvAZImM5oXDaskuauCxucAovRVDjxk
 UUG2/jc21lz3ix3v+u/MKpQElqcwEJ3dK2UXPrvx6vd6AGiYABaw7EG3wYV+HydTjkyD
 BGAPKA7my240KO6PV+JQPj/CkLrrA/ZGcCNQg/IUOYXnVaewLDA2kHEhVeTyBy1q+d6L
 Qk63oPn/B+pIqHICAnPH4c9xOjkLD9pn91Rnmcb9CcIj/8pFIlai4SlmJMDJcxEguGKe zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjb27u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDBTsT018089;
        Tue, 28 Jun 2022 13:56:33 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjb26s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:33 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDpu8x004928;
        Tue, 28 Jun 2022 13:56:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3gwt093pt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDuRCt15991188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:56:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75DC34C044;
        Tue, 28 Jun 2022 13:56:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C5E14C046;
        Tue, 28 Jun 2022 13:56:27 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:56:27 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v12 17/18] KVM: s390: pv: support for Destroy fast UVC
Date:   Tue, 28 Jun 2022 15:56:18 +0200
Message-Id: <20220628135619.32410-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628135619.32410-1-imbrenda@linux.ibm.com>
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AGXtto1_TS1-5KGmhcThtvdYe0Wy3RjM
X-Proofpoint-ORIG-GUID: Qoh6MQ78L-tknpCuDtGciSbBedgJ72Tu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for the Destroy Secure Configuration Fast Ultravisor call,
and take advantage of it for asynchronous destroy.

When supported, the protected guest is destroyed immediately using the
new UVC, leaving only the memory to be cleaned up asynchronously.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 10 +++++++
 arch/s390/kvm/pv.c         | 57 ++++++++++++++++++++++++++++++++------
 2 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index ba64e0be03bb..8b255d26c5a7 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -34,6 +34,7 @@
 #define UVC_CMD_INIT_UV			0x000f
 #define UVC_CMD_CREATE_SEC_CONF		0x0100
 #define UVC_CMD_DESTROY_SEC_CONF	0x0101
+#define UVC_CMD_DESTROY_SEC_CONF_FAST	0x0102
 #define UVC_CMD_CREATE_SEC_CPU		0x0120
 #define UVC_CMD_DESTROY_SEC_CPU		0x0121
 #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
@@ -77,6 +78,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
+	BIT_UVC_CMD_DESTROY_SEC_CONF_FAST = 23,
 	BIT_UVC_CMD_RETR_ATTEST = 28,
 };
 
@@ -213,6 +215,14 @@ struct uv_cb_nodata {
 	u64 reserved20[4];
 } __packed __aligned(8);
 
+/* Destroy Configuration Fast */
+struct uv_cb_destroy_fast {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 handle;
+	u64 reserved20[5];
+} __packed __aligned(8);
+
 /* Set Shared Access */
 struct uv_cb_share {
 	struct uv_cb_header header;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 512b8101e7cd..5bd1359711ae 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -200,6 +200,9 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 {
 	int cc;
 
+	/* It used the destroy-fast UVC, nothing left to do here */
+	if (!leftover->handle)
+		goto done_fast;
 	cc = uv_cmd_nodata(leftover->handle, UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY LEFTOVER VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy leftover vm failed rc %x rrc %x", *rc, *rrc);
@@ -214,6 +217,7 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 	free_pages(leftover->stor_base, get_order(uv_info.guest_base_stor_len));
 	free_pages(leftover->old_gmap_table, CRST_ALLOC_ORDER);
 	vfree(leftover->stor_var);
+done_fast:
 	atomic_dec(&kvm->mm->context.protected_count);
 	return 0;
 }
@@ -247,6 +251,32 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
 
+static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct uv_cb_destroy_fast uvcb = {
+		.header.cmd = UVC_CMD_DESTROY_SEC_CONF_FAST,
+		.header.len = sizeof(uvcb),
+		.handle = kvm_s390_pv_get_handle(kvm),
+	};
+	int cc;
+
+	cc = uv_call_sched(0, (u64)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM FAST: rc %x rrc %x", *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy vm fast failed rc %x rrc %x", *rc, *rrc);
+	/* Inteded memory leak on "impossible" error */
+	if (!cc)
+		kvm_s390_pv_dealloc_vm(kvm);
+	return cc ? -EIO : 0;
+}
+
+static inline bool is_destroy_fast_available(void)
+{
+	return test_bit_inv(BIT_UVC_CMD_DESTROY_SEC_CONF_FAST, uv_info.inst_calls_list);
+}
+
 /**
  * kvm_s390_pv_set_aside - Set aside a protected VM for later teardown.
  * @kvm: the VM
@@ -268,6 +298,7 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
 int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct pv_vm_to_be_destroyed *priv;
+	int res = 0;
 
 	/*
 	 * If another protected VM was already prepared, refuse.
@@ -279,14 +310,21 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->stor_var = kvm->arch.pv.stor_var;
-	priv->stor_base = kvm->arch.pv.stor_base;
-	priv->handle = kvm_s390_pv_get_handle(kvm);
-	priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
-	if (s390_replace_asce(kvm->arch.gmap)) {
+	if (is_destroy_fast_available()) {
+		res = kvm_s390_pv_deinit_vm_fast(kvm, rc, rrc);
+	} else {
+		priv->stor_var = kvm->arch.pv.stor_var;
+		priv->stor_base = kvm->arch.pv.stor_base;
+		priv->handle = kvm_s390_pv_get_handle(kvm);
+		priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
+		WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+		if (s390_replace_asce(kvm->arch.gmap))
+			res = -ENOMEM;
+	}
+
+	if (res) {
 		kfree(priv);
-		return -ENOMEM;
+		return res;
 	}
 
 	kvm_s390_destroy_lower_2g(kvm);
@@ -463,6 +501,7 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 {
 	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
 	u16 dummy;
+	int r;
 
 	/*
 	 * No locking is needed since this is the last thread of the last user of this
@@ -471,7 +510,9 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 	 * unregistered. This means that if this notifier runs, then the
 	 * struct kvm is still valid.
 	 */
-	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
+	r = kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
+	if (!r && is_destroy_fast_available())
+		kvm_s390_pv_deinit_vm_fast(kvm, &dummy, &dummy);
 }
 
 static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
-- 
2.36.1

