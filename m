Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C545773897A
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbjFUPfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbjFUPer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:34:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EF519A3;
        Wed, 21 Jun 2023 08:34:26 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LFSOUW019236;
        Wed, 21 Jun 2023 15:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=0QevZ86JqtFE7G2HU50yRKwnnPsAxZ2n1pOUwOGq/cU=;
 b=MZ4Bn5IPCC9ZiDXfC5sEiOp649hrP5SkzDQT+y3Sn4OnzF0QRg8fLUEUcv/fewa+5Fny
 hfIKogMLvR8dzt7m13b/tI4uG9SeKntL/l5iZoeenouQwfVpIoOxR4LAkO2Dhtr/EYEw
 RTanXLOlvyrgABlMa4ntx5VRAwSj/+zoAIkidMf7QaVvhV4EPtT+GdUkQLLKMQ2/l5yK
 CcjN7axeb39uXg5naRH0Qo+LrgdKvlTYUGnoQFS35lwsBTeEo6GAzY/zQGxg0i9h5dEz
 RoqDx5JtT0T7b7pAcYOTKYjfObyq6n6Gtd1ANLT2u0xUTNKLtk3lvRg5A1wozmENoWd9 vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3vn07bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:26 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LFTJUd021266;
        Wed, 21 Jun 2023 15:34:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3vn078r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L1iLQf030595;
        Wed, 21 Jun 2023 15:34:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r94f5aue1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:22 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYJKO5833384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 822C720040;
        Wed, 21 Jun 2023 15:34:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DCD820043;
        Wed, 21 Jun 2023 15:34:19 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 08/11] s390/uvdevice: Add 'List Secrets' UVC
Date:   Wed, 21 Jun 2023 17:29:14 +0200
Message-ID: <20230621153227.57250-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
References: <20230621153227.57250-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0unV-dYY4ckbGuoIZodmL9Cm8053N3vP
X-Proofpoint-ORIG-GUID: Bd8rf3yLDAF_qMa15beK7whJuNwfkA2w
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306210131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

Userspace can call the List Secrets Ultravisor Call
using IOCTLs on the uvdevice. The List Secrets UV call lists the
identifier of the secrets in the UV secret store.

The uvdevice is merely transporting the request from userspace to
Ultravisor. It's neither checking nor manipulating the request or
response data.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230615100533.3996107-5-seiden@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20230615100533.3996107-5-seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h            |  3 ++
 arch/s390/include/uapi/asm/uvdevice.h |  4 +++
 drivers/s390/char/uvdevice.c          | 52 +++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 1babc70ea5d4..3739c8f6a129 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -59,6 +59,7 @@
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 #define UVC_CMD_RETR_ATTEST		0x1020
 #define UVC_CMD_ADD_SECRET		0x1031
+#define UVC_CMD_LIST_SECRETS		0x1033
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
@@ -90,6 +91,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_DUMP_COMPLETE = 27,
 	BIT_UVC_CMD_RETR_ATTEST = 28,
 	BIT_UVC_CMD_ADD_SECRET = 29,
+	BIT_UVC_CMD_LIST_SECRETS = 30,
 };
 
 enum uv_feat_ind {
@@ -298,6 +300,7 @@ struct uv_cb_dump_complete {
  * A common UV call struct for pv guests that contains a single address
  * Examples:
  * Add Secret
+ * List Secrets
  */
 struct uv_cb_guest_addr {
 	struct uv_cb_header header;
diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
index e77410226598..76045da44868 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -70,6 +70,7 @@ struct uvio_uvdev_info {
 #define UVIO_ATT_MEASUREMENT_MAX_LEN	0x8000
 #define UVIO_ATT_ADDITIONAL_MAX_LEN	0x8000
 #define UVIO_ADD_SECRET_MAX_LEN		0x100000
+#define UVIO_LIST_SECRETS_LEN		0x1000
 
 #define UVIO_DEVICE_NAME "uv"
 #define UVIO_TYPE_UVC 'u'
@@ -78,6 +79,7 @@ enum UVIO_IOCTL_NR {
 	UVIO_IOCTL_UVDEV_INFO_NR = 0x00,
 	UVIO_IOCTL_ATT_NR,
 	UVIO_IOCTL_ADD_SECRET_NR,
+	UVIO_IOCTL_LIST_SECRETS_NR,
 	/* must be the last entry */
 	UVIO_IOCTL_NUM_IOCTLS
 };
@@ -86,10 +88,12 @@ enum UVIO_IOCTL_NR {
 #define UVIO_IOCTL_UVDEV_INFO	UVIO_IOCTL(UVIO_IOCTL_UVDEV_INFO_NR)
 #define UVIO_IOCTL_ATT		UVIO_IOCTL(UVIO_IOCTL_ATT_NR)
 #define UVIO_IOCTL_ADD_SECRET	UVIO_IOCTL(UVIO_IOCTL_ADD_SECRET_NR)
+#define UVIO_IOCTL_LIST_SECRETS	UVIO_IOCTL(UVIO_IOCTL_LIST_SECRETS_NR)
 
 #define UVIO_SUPP_CALL(nr)	(1ULL << (nr))
 #define UVIO_SUPP_UDEV_INFO	UVIO_SUPP_CALL(UVIO_IOCTL_UDEV_INFO_NR)
 #define UVIO_SUPP_ATT		UVIO_SUPP_CALL(UVIO_IOCTL_ATT_NR)
 #define UVIO_SUPP_ADD_SECRET	UVIO_SUPP_CALL(UVIO_IOCTL_ADD_SECRET_NR)
+#define UVIO_SUPP_LIST_SECRETS	UVIO_SUPP_CALL(UVIO_IOCTL_LIST_SECRETS_NR)
 
 #endif /* __S390_ASM_UVDEVICE_H */
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 7221e987703a..70502c4ec290 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -38,6 +38,7 @@ static const u32 ioctl_nr_to_uvc_bit[] __initconst = {
 	[UVIO_IOCTL_UVDEV_INFO_NR] = BIT_UVIO_INTERNAL,
 	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
 	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
+	[UVIO_IOCTL_LIST_SECRETS_NR] = BIT_UVC_CMD_LIST_SECRETS,
 };
 
 static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
@@ -291,6 +292,54 @@ static int uvio_add_secret(struct uvio_ioctl_cb *uv_ioctl)
 	return ret;
 }
 
+/** uvio_list_secrets() - perform a List Secret UVC
+ * @uv_ioctl: ioctl control block
+ *
+ * uvio_list_secrets() performs the List Secret Ultravisor Call. It verifies
+ * that the given userspace argument address is valid and its size is sane.
+ * Every other check is made by the Ultravisor (UV) and won't result in a
+ * negative return value. It builds the request, performs the UV-call, and
+ * copies the result to userspace.
+ *
+ * The argument specifies the location for the result of the UV-Call.
+ *
+ * If the List Secrets UV facility is not present, UV will return invalid
+ * command rc. This won't be fenced in the driver and does not result in a
+ * negative return value.
+ *
+ * Context: might sleep
+ *
+ * Return: 0 on success or a negative error code on error.
+ */
+static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
+{
+	void __user *user_buf_arg = (void __user *)uv_ioctl->argument_addr;
+	struct uv_cb_guest_addr uvcb = {
+		.header.len = sizeof(uvcb),
+		.header.cmd = UVC_CMD_LIST_SECRETS,
+	};
+	void *secrets = NULL;
+	int ret = 0;
+
+	if (uv_ioctl->argument_len != UVIO_LIST_SECRETS_LEN)
+		return -EINVAL;
+
+	secrets = kvzalloc(UVIO_LIST_SECRETS_LEN, GFP_KERNEL);
+	if (!secrets)
+		return -ENOMEM;
+
+	uvcb.addr = (u64)secrets;
+	uv_call_sched(0, (u64)&uvcb);
+	uv_ioctl->uv_rc = uvcb.header.rc;
+	uv_ioctl->uv_rrc = uvcb.header.rrc;
+
+	if (copy_to_user(user_buf_arg, secrets, UVIO_LIST_SECRETS_LEN))
+		ret = -EFAULT;
+
+	kvfree(secrets);
+	return ret;
+}
+
 static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
 				     unsigned long cmd)
 {
@@ -338,6 +387,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case UVIO_IOCTL_ADD_SECRET_NR:
 		ret = uvio_add_secret(&uv_ioctl);
 		break;
+	case UVIO_IOCTL_LIST_SECRETS_NR:
+		ret = uvio_list_secrets(&uv_ioctl);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.41.0

