Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDCC73897F
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbjFUPfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjFUPeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:34:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C304C3;
        Wed, 21 Jun 2023 08:34:26 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LEt2gZ029611;
        Wed, 21 Jun 2023 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XrbWxvHgCh2PwO2el0dwyvZWaz/Fzjy6JuyRdN7+yVc=;
 b=BmhT7AvuV1jLMOp9IhcNn73CP9+gxDAsWm8lUGnPjg7vykyz4PliCDJduZgOgtrdMIzu
 fM6PR+2aEJ5kYB0R68OjI7I3W4m1KFP0grnYIvHFjqjX9QW49sjd2B0t/iYQ9MOMGsaE
 F2ZYPj4aikWn6+VMMIOH3p2fEyJH/iOE18ek579I1HDV8Ee2MoXixM3ll22NY7/Lk0cy
 7IYhd2QorNMnKeZIPpk0X0lWMXezewrXUgcX5ZKxNSQxMTA+XHnpuzG+aMZUofnjP3C6
 IIetHSOHlCplB9IE1jWt7aH4e1nFhpDbgyJAgx4JwQYD0ufirp+79iGOOd3idEMWNIsB JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3d0hepu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:24 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LEwD3N005667;
        Wed, 21 Jun 2023 15:34:24 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3d0henk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:24 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L5SGpp004427;
        Wed, 21 Jun 2023 15:34:22 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3r943e25fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:22 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYJpX5833380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CA2520049;
        Wed, 21 Jun 2023 15:34:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BD552004B;
        Wed, 21 Jun 2023 15:34:18 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 07/11] s390/uvdevice: Add 'Add Secret' UVC
Date:   Wed, 21 Jun 2023 17:29:13 +0200
Message-ID: <20230621153227.57250-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
References: <20230621153227.57250-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ltClDNdVIqZSIOo5EglPM4AQ4kkOeYBn
X-Proofpoint-ORIG-GUID: Kt81yF4vHcM4t-B73wYqVE4mtvGRJl0d
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306210127
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

Userspace can call the Add Secret Ultravisor Call using IOCTLs on the
uvdevice. The Add Secret UV call sends an encrypted and
cryptographically verified request to the Ultravisor. The request
inserts a protected guest's secret into the Ultravisor for later use.

The uvdevice is merely transporting the request from userspace to the
Ultravisor. It's neither checking nor manipulating the request data.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230615100533.3996107-4-seiden@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20230615100533.3996107-4-seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h            | 14 ++++++
 arch/s390/include/uapi/asm/uvdevice.h |  4 ++
 drivers/s390/char/uvdevice.c          | 63 +++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 28a9ad57b6f1..1babc70ea5d4 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -58,6 +58,7 @@
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 #define UVC_CMD_RETR_ATTEST		0x1020
+#define UVC_CMD_ADD_SECRET		0x1031
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
@@ -88,6 +89,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_DUMP_CPU = 26,
 	BIT_UVC_CMD_DUMP_COMPLETE = 27,
 	BIT_UVC_CMD_RETR_ATTEST = 28,
+	BIT_UVC_CMD_ADD_SECRET = 29,
 };
 
 enum uv_feat_ind {
@@ -292,6 +294,18 @@ struct uv_cb_dump_complete {
 	u64 reserved30[5];
 } __packed __aligned(8);
 
+/*
+ * A common UV call struct for pv guests that contains a single address
+ * Examples:
+ * Add Secret
+ */
+struct uv_cb_guest_addr {
+	struct uv_cb_header header;
+	u64 reserved08[3];
+	u64 addr;
+	u64 reserved28[4];
+} __packed __aligned(8);
+
 static inline int __uv_call(unsigned long r1, unsigned long r2)
 {
 	int cc;
diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
index 9d9b684836c2..e77410226598 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -69,6 +69,7 @@ struct uvio_uvdev_info {
 #define UVIO_ATT_ARCB_MAX_LEN		0x100000
 #define UVIO_ATT_MEASUREMENT_MAX_LEN	0x8000
 #define UVIO_ATT_ADDITIONAL_MAX_LEN	0x8000
+#define UVIO_ADD_SECRET_MAX_LEN		0x100000
 
 #define UVIO_DEVICE_NAME "uv"
 #define UVIO_TYPE_UVC 'u'
@@ -76,6 +77,7 @@ struct uvio_uvdev_info {
 enum UVIO_IOCTL_NR {
 	UVIO_IOCTL_UVDEV_INFO_NR = 0x00,
 	UVIO_IOCTL_ATT_NR,
+	UVIO_IOCTL_ADD_SECRET_NR,
 	/* must be the last entry */
 	UVIO_IOCTL_NUM_IOCTLS
 };
@@ -83,9 +85,11 @@ enum UVIO_IOCTL_NR {
 #define UVIO_IOCTL(nr)		_IOWR(UVIO_TYPE_UVC, nr, struct uvio_ioctl_cb)
 #define UVIO_IOCTL_UVDEV_INFO	UVIO_IOCTL(UVIO_IOCTL_UVDEV_INFO_NR)
 #define UVIO_IOCTL_ATT		UVIO_IOCTL(UVIO_IOCTL_ATT_NR)
+#define UVIO_IOCTL_ADD_SECRET	UVIO_IOCTL(UVIO_IOCTL_ADD_SECRET_NR)
 
 #define UVIO_SUPP_CALL(nr)	(1ULL << (nr))
 #define UVIO_SUPP_UDEV_INFO	UVIO_SUPP_CALL(UVIO_IOCTL_UDEV_INFO_NR)
 #define UVIO_SUPP_ATT		UVIO_SUPP_CALL(UVIO_IOCTL_ATT_NR)
+#define UVIO_SUPP_ADD_SECRET	UVIO_SUPP_CALL(UVIO_IOCTL_ADD_SECRET_NR)
 
 #endif /* __S390_ASM_UVDEVICE_H */
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 7d7866be389b..7221e987703a 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -37,6 +37,7 @@
 static const u32 ioctl_nr_to_uvc_bit[] __initconst = {
 	[UVIO_IOCTL_UVDEV_INFO_NR] = BIT_UVIO_INTERNAL,
 	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
+	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
 };
 
 static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
@@ -231,6 +232,65 @@ static int uvio_attestation(struct uvio_ioctl_cb *uv_ioctl)
 	return ret;
 }
 
+/** uvio_add_secret() - perform an Add Secret UVC
+ *
+ * @uv_ioctl: ioctl control block
+ *
+ * uvio_add_secret() performs the Add Secret Ultravisor Call.
+ *
+ * The given userspace argument address and size are verified to be
+ * valid but every other check is made by the Ultravisor
+ * (UV). Therefore UV errors won't result in a negative return
+ * value. The request is then copied to kernelspace, the UV-call is
+ * performed and the results are copied back to userspace.
+ *
+ * The argument has to point to an Add Secret Request Control Block
+ * which is an encrypted and cryptographically verified request that
+ * inserts a protected guest's secrets into the Ultravisor for later
+ * use.
+ *
+ * If the Add Secret UV facility is not present, UV will return
+ * invalid command rc. This won't be fenced in the driver and does not
+ * result in a negative return value.
+ *
+ * Context: might sleep
+ *
+ * Return: 0 on success or a negative error code on error.
+ */
+static int uvio_add_secret(struct uvio_ioctl_cb *uv_ioctl)
+{
+	void __user *user_buf_arg = (void __user *)uv_ioctl->argument_addr;
+	struct uv_cb_guest_addr uvcb = {
+		.header.len = sizeof(uvcb),
+		.header.cmd = UVC_CMD_ADD_SECRET,
+	};
+	void *asrcb = NULL;
+	int ret;
+
+	if (uv_ioctl->argument_len > UVIO_ADD_SECRET_MAX_LEN)
+		return -EINVAL;
+	if (uv_ioctl->argument_len == 0)
+		return -EINVAL;
+
+	asrcb = kvzalloc(uv_ioctl->argument_len, GFP_KERNEL);
+	if (!asrcb)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(asrcb, user_buf_arg, uv_ioctl->argument_len))
+		goto out;
+
+	ret = 0;
+	uvcb.addr = (u64)asrcb;
+	uv_call_sched(0, (u64)&uvcb);
+	uv_ioctl->uv_rc = uvcb.header.rc;
+	uv_ioctl->uv_rrc = uvcb.header.rrc;
+
+out:
+	kvfree(asrcb);
+	return ret;
+}
+
 static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
 				     unsigned long cmd)
 {
@@ -275,6 +335,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case UVIO_IOCTL_ATT_NR:
 		ret = uvio_attestation(&uv_ioctl);
 		break;
+	case UVIO_IOCTL_ADD_SECRET_NR:
+		ret = uvio_add_secret(&uv_ioctl);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.41.0

