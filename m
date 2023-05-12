Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3387700419
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbjELJlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 05:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240539AbjELJl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:41:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54911D94;
        Fri, 12 May 2023 02:41:04 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C9Xisj019421;
        Fri, 12 May 2023 09:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=egkAw74qeYS173SDG802c6hK7ykRYEzoZg9rWoV3y+k=;
 b=cdDBmUnYuPElvLFRFcz86pAHc+CbzxM4DQ2TTWZNKIOAeRcFpFjWuZE2YSv6JMC8AcNY
 wZMbpxbaGawVEn3l1FtXKa2jl07uBQbEbPFjJFaXA7Re3aFZPZOvlp9Wd2P9T4T5ypJh
 mQ4xIQfYeyqkx1fcYR5WoEmUvNOeJA7ZEQyheSqTyDWTI6R3UiDQQCGPC41fpSNRV+/W
 v7MPtomu0fJQUsw0YzZh8Cdu4Z0hICcrCL228Zq1+NBPsoYubTWfqjqNb1g/F5Jglje/
 p3xlkKpus3yps/BJSF4zEmdDGXAfeyQt6WWrx0aK1E5QoJgJ2iwgVT4o61hqBtBOs7Nc zA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhjxd0e5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:40:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34BNjKU9012966;
        Fri, 12 May 2023 09:31:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qf7e0sub0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34C9Vsw514942794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 09:31:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B40C320043;
        Fri, 12 May 2023 09:31:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 643D92004D;
        Fri, 12 May 2023 09:31:54 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 12 May 2023 09:31:54 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [PATCH 3/5] s390/uvdevice: Add 'List Secrets' UVC
Date:   Fri, 12 May 2023 11:31:51 +0200
Message-Id: <20230512093153.206378-4-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512093153.206378-1-seiden@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iLTHnn50L5_CuY0xA-2A32Zeo_F4mAvL
X-Proofpoint-ORIG-GUID: iLTHnn50L5_CuY0xA-2A32Zeo_F4mAvL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305120079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can call the List Secrets Ultravisor Call
using IOCTLs on the uvdevice.
During the handling of the new IOCTL nr the uvdevice will do some sanity
checks first. Then, perform the Ultravisor command, and copy the answer
to userspace.
If the List Secrets UV facility is not present, UV will return
invalid command rc. This won't be fenced in the driver and does not
result in a negative return value. This is also true for any other
possible error code the UV can return.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h            |  3 ++
 arch/s390/include/uapi/asm/uvdevice.h |  4 ++
 drivers/s390/char/uvdevice.c          | 55 +++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index a7dff64e1e24..1e4f0f6d4923 100644
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
  * A common call for pv guests that contains a single address
  * Examples:
  * Add Secret
+ * List Secrets
  */
 struct uv_cb_guest_addr {
 	struct uv_cb_header header;
diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
index e919b802213c..cf12d6b8d8d8 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -73,6 +73,7 @@ struct uvio_uvdev_info {
 #define UVIO_ATT_MEASUREMENT_MAX_LEN	0x8000
 #define UVIO_ATT_ADDITIONAL_MAX_LEN	0x8000
 #define UVIO_ADD_SECRET_MAX_LEN		0x100000
+#define UVIO_LIST_SECRETS_LEN		0x1000
 
 #define UVIO_DEVICE_NAME "uv"
 #define UVIO_TYPE_UVC 'u'
@@ -81,6 +82,7 @@ enum UVIO_IOCTL_NR {
 	UVIO_IOCTL_UVDEV_INFO_NR = 0x00,
 	UVIO_IOCTL_ATT_NR,
 	UVIO_IOCTL_ADD_SECRET_NR,
+	UVIO_IOCTL_LIST_SECRETS_NR,
 	/* must be the last entry */
 	UVIO_IOCTL_NUM_IOCTLS
 };
@@ -89,10 +91,12 @@ enum UVIO_IOCTL_NR {
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
index ba3e60dc4ba8..5fcd719047ab 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -38,6 +38,7 @@ static const u64 ioctl_nr_to_uvc_bit[] __initconst = {
 	[UVIO_IOCTL_UVDEV_INFO_NR] = -1UL,
 	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
 	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
+	[UVIO_IOCTL_LIST_SECRETS_NR] = BIT_UVC_CMD_LIST_SECRETS,
 };
 
 static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
@@ -286,6 +287,57 @@ static int uvio_add_secret(struct uvio_ioctl_cb *uv_ioctl)
 	return ret;
 }
 
+/** uvio_list_secrets() - perform a List Secret UVC
+ *
+ * @uv_ioctl: ioctl control block
+ *
+ * uvio_list_secrets() performs the List Secret Ultravisor Call.
+ * It verifies that the given userspace argument address is valid and its size
+ * is sane. Every other check is made by the Ultravisor (UV) and won't result
+ * in a negative return value. It builds the request, performs the UV-call,
+ * and copies the result to userspace.
+ *
+ * The argument specifies the location for the result of the UV-Call.
+ *
+ * If the List Secrets UV facility is not present,
+ * UV will return invalid command rc. This won't be fenced in the driver
+ * and does not result in a negative return value.
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
+	int ret;
+
+	if (uv_ioctl->argument_len != UVIO_LIST_SECRETS_LEN)
+		return -EINVAL;
+
+	secrets = kvzalloc(uv_ioctl->argument_len, GFP_KERNEL);
+	if (!secrets)
+		return -ENOMEM;
+
+	uvcb.addr = (u64)secrets;
+	uv_call_sched(0, (u64)&uvcb);
+	uv_ioctl->uv_rc = uvcb.header.rc;
+	uv_ioctl->uv_rrc = uvcb.header.rrc;
+
+	if (copy_to_user(user_buf_arg, secrets, uv_ioctl->argument_len))
+		ret = -EFAULT;
+	else
+		ret = 0;
+
+	kvfree(secrets);
+	return ret;
+}
+
 static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
 				     unsigned long cmd)
 {
@@ -333,6 +385,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
2.40.1

