Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E437862600F
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 18:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiKKRHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 12:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiKKRGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 12:06:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A384373420;
        Fri, 11 Nov 2022 09:06:48 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABGrNj0027317;
        Fri, 11 Nov 2022 17:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=baUscpToHtILcsiB1v1SHAChIUBoYetp9n+sdI6stWY=;
 b=SI+0DnC8aL6va6yCvvgqOv0DO9PiuVjalFsVKPjqH3Hv7XgvIAuhQY9ZRkMBSuNXhB9c
 yR5vdJp6DqY1IQ0ND1R8yNGLgrcJhuLieApky8wECmxTgO6+1UWfMFw1F4YASUedN+G9
 lYjY/GHso7/68XEFNGh/pmFgjBDLWvXqTZ2dH1mYIjIDRrCz1H4wJQZneudA2/u7i0jM
 Nu/CeaXqNmcBmSwQQt05jyPZQaCP9yv4lIazoig8pwaaNeZpFuprRd3T5cdJMfFEN7Iz
 ezouEeQR/uX6LufsW12drC7dgGACHCe+QgyI1zYRw03NJ9RUUxUfqYCs9N7kHrXKnSu4 AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kstag8bay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:47 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ABGxiGp017991;
        Fri, 11 Nov 2022 17:06:47 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kstag8b9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:47 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ABH6XZC026552;
        Fri, 11 Nov 2022 17:06:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3kngqgh12d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ABH6fku56426982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 17:06:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 537684C04A;
        Fri, 11 Nov 2022 17:06:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C43224C040;
        Fri, 11 Nov 2022 17:06:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.65.74])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Nov 2022 17:06:40 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v16 5/6] KVM: s390: pv: support for Destroy fast UVC
Date:   Fri, 11 Nov 2022 18:06:31 +0100
Message-Id: <20221111170632.77622-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111170632.77622-1-imbrenda@linux.ibm.com>
References: <20221111170632.77622-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hMriFWfHRon1y5Glp59icQizG-BfrdW7
X-Proofpoint-ORIG-GUID: K2opzwa7hOi09DzU_JJrjte6yoruBCzu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_08,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110115
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
 arch/s390/kvm/pv.c         | 61 +++++++++++++++++++++++++++++++++-----
 2 files changed, 63 insertions(+), 8 deletions(-)

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
index 5f958fcf6283..e032ebbf51b9 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -203,6 +203,9 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 {
 	int cc;
 
+	/* It used the destroy-fast UVC, nothing left to do here */
+	if (!leftover->handle)
+		goto done_fast;
 	cc = uv_cmd_nodata(leftover->handle, UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY LEFTOVER VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy leftover vm failed rc %x rrc %x", *rc, *rrc);
@@ -217,6 +220,7 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 	free_pages(leftover->stor_base, get_order(uv_info.guest_base_stor_len));
 	free_pages(leftover->old_gmap_table, CRST_ALLOC_ORDER);
 	vfree(leftover->stor_var);
+done_fast:
 	atomic_dec(&kvm->mm->context.protected_count);
 	return 0;
 }
@@ -250,6 +254,36 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
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
+	if (rc)
+		*rc = uvcb.header.rc;
+	if (rrc)
+		*rrc = uvcb.header.rrc;
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM FAST: rc %x rrc %x",
+		     uvcb.header.rc, uvcb.header.rrc);
+	WARN_ONCE(cc, "protvirt destroy vm fast failed handle %llx rc %x rrc %x",
+		  kvm_s390_pv_get_handle(kvm), uvcb.header.rc, uvcb.header.rrc);
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
@@ -271,6 +305,7 @@ static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
 int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct pv_vm_to_be_destroyed *priv;
+	int res = 0;
 
 	lockdep_assert_held(&kvm->lock);
 	/*
@@ -283,14 +318,21 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
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
@@ -471,6 +513,7 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 {
 	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
 	u16 dummy;
+	int r;
 
 	/*
 	 * No locking is needed since this is the last thread of the last user of this
@@ -479,7 +522,9 @@ static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 	 * unregistered. This means that if this notifier runs, then the
 	 * struct kvm is still valid.
 	 */
-	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
+	r = kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
+	if (!r && is_destroy_fast_available() && kvm_s390_pv_get_handle(kvm))
+		kvm_s390_pv_deinit_vm_fast(kvm, &dummy, &dummy);
 }
 
 static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
-- 
2.38.1

