Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70E9638A79
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiKYMn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiKYMnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328DD1ADA1;
        Fri, 25 Nov 2022 04:43:09 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APCfn35002303;
        Fri, 25 Nov 2022 12:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=dDIzmcJhwdnUZQx45wqmuiJ1G+QIBtWIRI/rjhZFnaQ=;
 b=ORbfyZaEokZJ8PQ1V3F8dLRtsS7Kv/JfZ9YowPIMwZZx2qpuSm7g/LkqTvIgqZqm42I7
 auyzPk0ByY3Y728lTiXm4+1aLk7ISqfwjZSnChUEbNhYd8QQ6jqLIwcurSGT7AN/M3L6
 bNODs6zUT2h4Wtmaic5U0d4gTce4nloBnJm/rvPYG3cLjedpba2EYNg7AP680zK7HwK0
 Tmerr7vZoS9VBu+qql8SJo26VnTYQifQ4w+5lHrDMw7o2JOHXOe2XlG6haBuwKZIBIFJ
 U0lHB21LukoNyBALO4nFzAo++Qsrf75HvMPS3ydvLsrADDd2noR/gDRORaNPSWPnZCkJ kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wxcr0h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:08 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCh8Da006000;
        Fri, 25 Nov 2022 12:43:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wxcr0gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZ0Xf032146;
        Fri, 25 Nov 2022 12:43:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3kxps91kpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCh2jV25035512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:43:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 967394C046;
        Fri, 25 Nov 2022 12:43:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 258484C044;
        Fri, 25 Nov 2022 12:43:02 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:43:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [GIT PULL 12/15] KVM: s390: pv: support for Destroy fast UVC
Date:   Fri, 25 Nov 2022 13:39:44 +0100
Message-Id: <20221125123947.31047-13-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yMNefj_-f1_1sDShNOfbTUHRq82w10Bu
X-Proofpoint-GUID: YVcm_Vz28SeA2ZV7ezW97zvXvdn79XvP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Add support for the Destroy Secure Configuration Fast Ultravisor call,
and take advantage of it for asynchronous destroy.

When supported, the protected guest is destroyed immediately using the
new UVC, leaving only the memory to be cleaned up asynchronously.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111170632.77622-6-imbrenda@linux.ibm.com
Message-Id: <20221111170632.77622-6-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

