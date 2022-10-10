Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B85FA0A6
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiJJOzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 10:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJJOyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 10:54:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319D2165BA;
        Mon, 10 Oct 2022 07:54:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29ADGBOg012312;
        Mon, 10 Oct 2022 14:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=93LY8bYDrCM+dpONRPcTO0jk8BzhpVaIONBFPExlytw=;
 b=flUow8piDiYBKYS1zaV0DKXAPFR3kryToJyst3lZ4gn3gn0Cz3hPmi7PNaeBnGieUy8M
 uIRwJJ3bnCLskqty1En1OUzHkok1RD6gpsDq3/ktZSljtnwucw3AmfOdohgXhRL00E2I
 DVWoZYt6ge85GY5Ct2eDflgC6L3rtEZYMLnceTx2V9oI1vTwLkZkbuizlTT4ZB3nFCnT
 I9N+DLYeRQLjhUoEx+0ZpBIY80qWqy/w4aDKpmwL1+WKn2L1FzhErNNvrz1y+0dX8O1e
 33u7bKy+A+OEUvTlr3zLPc+VGf/oH1gpwoI7yzZ8Y4AqyPmRTOFJ6Hg7Qh2sDj2T5oTJ oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k6hrqsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:51 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29ADDX3F017302;
        Mon, 10 Oct 2022 14:54:50 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k6hrqrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:50 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AEpXdV002411;
        Mon, 10 Oct 2022 14:54:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3k30u926d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29AEsiKw47972644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 14:54:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE96752050;
        Mon, 10 Oct 2022 14:54:44 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.242])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 822BD52051;
        Mon, 10 Oct 2022 14:54:44 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v15 5/6] KVM: s390: pv: support for Destroy fast UVC
Date:   Mon, 10 Oct 2022 16:54:41 +0200
Message-Id: <20221010145442.85867-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221010145442.85867-1-imbrenda@linux.ibm.com>
References: <20221010145442.85867-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1akQfQmIFYg2mENUmN59lRxuSusTTv3Q
X-Proofpoint-GUID: byRPJDMhKIXxHSGPoIY9kPfFIbmV48Ec
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_08,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 10 +++++++
 arch/s390/kvm/pv.c         | 57 ++++++++++++++++++++++++++++++++------
 2 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index be3ef9dd6972..28a9ad57b6f1 100644
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
@@ -81,6 +82,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
+	BIT_UVC_CMD_DESTROY_SEC_CONF_FAST = 23,
 	BIT_UVC_CMD_DUMP_INIT = 24,
 	BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE = 25,
 	BIT_UVC_CMD_DUMP_CPU = 26,
@@ -230,6 +232,14 @@ struct uv_cb_nodata {
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
index 97b99f80aa19..4a299408a99b 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -201,6 +201,9 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 {
 	int cc;
 
+	/* It used the destroy-fast UVC, nothing left to do here */
+	if (!leftover->handle)
+		goto done_fast;
 	cc = uv_cmd_nodata(leftover->handle, UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY LEFTOVER VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy leftover vm failed rc %x rrc %x", *rc, *rrc);
@@ -215,6 +218,7 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 	free_pages(leftover->stor_base, get_order(uv_info.guest_base_stor_len));
 	free_pages(leftover->old_gmap_table, CRST_ALLOC_ORDER);
 	vfree(leftover->stor_var);
+done_fast:
 	atomic_dec(&kvm->mm->context.protected_count);
 	return 0;
 }
@@ -248,6 +252,32 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
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
@@ -269,6 +299,7 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
 int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct pv_vm_to_be_destroyed *priv;
+	int res = 0;
 
 	lockdep_assert_held(&kvm->lock);
 	/*
@@ -281,14 +312,21 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
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
@@ -469,6 +507,7 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 {
 	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
 	u16 dummy;
+	int r;
 
 	/*
 	 * No locking is needed since this is the last thread of the last user of this
@@ -477,7 +516,9 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
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
2.37.3

