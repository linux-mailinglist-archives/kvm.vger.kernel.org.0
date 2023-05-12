Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECB77003E5
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240333AbjELJhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 05:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240296AbjELJhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:37:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E7FDDA6;
        Fri, 12 May 2023 02:37:08 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C9aAtD023393;
        Fri, 12 May 2023 09:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HEdoMCubOLYMaIYe7koDDCyKLHkdmR3rZo0zKmr6dHM=;
 b=qpbZbDfIkerZPFTjlwkNkZNWX47D1ZkCjDAtco1sGzarZsZKnNRNuJIWDhe1rbBhBWG2
 CDHq68Wr23w6TQ1VhhXRpLEM6NtWFgMvvRuJ05MWvHPXl7cUCaWzQvd85nBGjcQ6T4jM
 RywcGpWoF7LYF6buZHjl6esscYdTOxNFN3nQaQ/sdEonCoLvFjUjX0tF/8C10vDTm+s7
 9+A4A1yXBfRDjQORXBGgeMWgnruJBFDVifAB8XwK2xLijqUN0eorDYnzjJJNILUsJG+T
 i7c+Bmz3pEt6+tps3eOjj/LqMa2/8M64ChAfxUFHijfxwQrOldu0bmaR8RiqbFhGPi3Z YA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhjs0g7tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:36:56 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C98W35017271;
        Fri, 12 May 2023 09:31:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qf7dg1uxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34C9VsOr31654226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 09:31:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B5442004B;
        Fri, 12 May 2023 09:31:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08FB820043;
        Fri, 12 May 2023 09:31:54 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 12 May 2023 09:31:53 +0000 (GMT)
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
Subject: [PATCH 2/5] s390/uvdevice: Add 'Add Secret' UVC
Date:   Fri, 12 May 2023 11:31:50 +0200
Message-Id: <20230512093153.206378-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512093153.206378-1-seiden@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Iu_WrrUa4lSDQi03A08BCifjYNKmXJQj
X-Proofpoint-GUID: Iu_WrrUa4lSDQi03A08BCifjYNKmXJQj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can call the Add Secret Ultravisor Call
using IOCTLs on the uvdevice.
During the handling of the new IOCTL nr the uvdevice will do some sanity
checks first. Then, copy the request data to kernel space, perform the
Ultravisor command, and copy the return codes to userspace.
If the Add Secret UV facility is not present,
UV will return invalid command rc. This won't be fenced in the driver
and does not result in a negative return value. This is also true for
any other possible error code the UV can return.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h            | 14 +++++++
 arch/s390/include/uapi/asm/uvdevice.h |  4 ++
 drivers/s390/char/uvdevice.c          | 58 +++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 28a9ad57b6f1..a7dff64e1e24 100644
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
+ * A common call for pv guests that contains a single address
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
index ed58979b8438..e919b802213c 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -72,6 +72,7 @@ struct uvio_uvdev_info {
 #define UVIO_ATT_ARCB_MAX_LEN		0x100000
 #define UVIO_ATT_MEASUREMENT_MAX_LEN	0x8000
 #define UVIO_ATT_ADDITIONAL_MAX_LEN	0x8000
+#define UVIO_ADD_SECRET_MAX_LEN		0x100000
 
 #define UVIO_DEVICE_NAME "uv"
 #define UVIO_TYPE_UVC 'u'
@@ -79,6 +80,7 @@ struct uvio_uvdev_info {
 enum UVIO_IOCTL_NR {
 	UVIO_IOCTL_UVDEV_INFO_NR = 0x00,
 	UVIO_IOCTL_ATT_NR,
+	UVIO_IOCTL_ADD_SECRET_NR,
 	/* must be the last entry */
 	UVIO_IOCTL_NUM_IOCTLS
 };
@@ -86,9 +88,11 @@ enum UVIO_IOCTL_NR {
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
index 27f5bf1cf27a..ba3e60dc4ba8 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -37,6 +37,7 @@
 static const u64 ioctl_nr_to_uvc_bit[] __initconst = {
 	[UVIO_IOCTL_UVDEV_INFO_NR] = -1UL,
 	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
+	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
 };
 
 static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
@@ -231,6 +232,60 @@ static int uvio_attestation(struct uvio_ioctl_cb *uv_ioctl)
 	return ret;
 }
 
+/** uvio_add_secret() - perform an Add Secret UVC
+ *
+ * @uv_ioctl: ioctl control block
+ *
+ * uvio_add_secret() performs the Add Secret Ultravisor Call.
+ * It verifies that the given userspace argument address is valid and its size
+ * is sane. Every other check is made by the Ultravisor (UV) and won't result
+ * in a negative return value. It copies the request to kernelspace,
+ * performs the UV-call, and copies the return codes to the ioctl control block.
+ * The argument has to point to an Add Secret Request Control Block.
+ * It is an encrypted and  cryptographically verified request generated by
+ * userspace to insert the actual secret into the UV.
+ * If the Add Secret UV facility is not present,
+ * UV will return invalid command rc. This won't be fenced in the driver
+ * and does not result in a negative return value.
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
+		return -EINVAL;
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
@@ -275,6 +330,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
2.40.1

