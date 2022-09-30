Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A43A5F0D13
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 16:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiI3OHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 10:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiI3OHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 10:07:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739C9C7444;
        Fri, 30 Sep 2022 07:07:02 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28UDnW21010920;
        Fri, 30 Sep 2022 14:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V/AwWycrAwVtD7M4gyIC+vo4+ZFR0grczVJ0XQGYhlA=;
 b=PvGLldKOagVSQ3ntTAHfjKC5mH3ip9Mpvu1XZCkecXY+83qs18g5BCrGQl6bExGRaWee
 gzX3tyumslZavYC2kpTY/eKawnuZpn7xuMtdyqIMiiJxMmm/XccmrKkL95ImEbypzwzA
 WvJh+9YusKm+CU8cfnCKMVNksNHK3Fzd3qVrQWPszL6BgwaaRpEtKHlFLDFBzK0IUHJH
 PBgkXW0uLA2B2ly+k4AGmHSTdCrRq3mqhwavN2hn6N7ZZakW7rMQYDMUNoi59hOksg2R
 TKFRlPpzpFZoBQpGBv6RTf9TzLIGWt6ZoHoFbGUyfcf8AgfZfzpSq6lXZ/oAYraFMFbc +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1pagnbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:07:00 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28UDwvc7012364;
        Fri, 30 Sep 2022 14:06:59 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1pagn8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:06:59 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28UDoGN7023829;
        Fri, 30 Sep 2022 14:01:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3jss5hx5ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28UE1r4460031232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 14:01:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F0B6A4051;
        Fri, 30 Sep 2022 14:01:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B333A404D;
        Fri, 30 Sep 2022 14:01:53 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Sep 2022 14:01:53 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v14 5/6] KVM: s390: pv: support for Destroy fast UVC
Date:   Fri, 30 Sep 2022 16:01:49 +0200
Message-Id: <20220930140150.37463-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930140150.37463-1-imbrenda@linux.ibm.com>
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dEJ1yhDLzM_KBVpHUBkhl9vCljUPJqMC
X-Proofpoint-GUID: cJSVz1hZH-pHNiBlJVB4NDpZ9MBqL40c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_04,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209300090
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
index 335eeec6e3da..1b51e5c3f7df 100644
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
 
 	/*
 	 * If another protected VM was already prepared for teardown, refuse.
@@ -280,14 +311,21 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
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
@@ -464,6 +502,7 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 {
 	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
 	u16 dummy;
+	int r;
 
 	/*
 	 * No locking is needed since this is the last thread of the last user of this
@@ -472,7 +511,9 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
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

