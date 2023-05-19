Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6F1709438
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjESJ4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjESJ4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:56:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BE71A6;
        Fri, 19 May 2023 02:56:04 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34J9m4Pt030068;
        Fri, 19 May 2023 09:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dnajLaYc7HRSwjGNlx6kUzGfXXcdn6M3+LoNYGNYWtw=;
 b=ktyN2c/jJBpbx2VqIigFsgE/vpJABeh1r5aQKyW3WNAu4SfTV4E3n/UmygnGnTBgfbZt
 oxAnv8/O8WBT7SPWUrgY5NtZE9hYziPuk6NYj5w2EaotevFz+QtOqGqD6a+e81dgeExj
 TXXb+t8voVdA6L6GO35BOKyvr/H5H8iqoKeamCl7q4efOqFvxupodhBCKBegKRNzgHqC
 BCpSUm2sbUw69AB5Sekfolp1uvjfTIWp/6t+0ukLMRkFgxFH9pLjccrvvO7821ij/W4V
 5sED/gDMHXcIzkCvEDweT06IHsFlxMwU50uE0oesI+kqDQvjj2eukzKxMWX0dN6pr3ky aw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qp4q5ufvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 09:56:03 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34J7WEXu025741;
        Fri, 19 May 2023 09:37:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qj1tdtjgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 09:37:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34J9b91q52625676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:37:09 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98A8C20040;
        Fri, 19 May 2023 09:37:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49DEE2004B;
        Fri, 19 May 2023 09:37:09 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 19 May 2023 09:37:09 +0000 (GMT)
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
Subject: [PATCH v2 2/6] s390/uvdevice: Add 'Add Secret' UVC
Date:   Fri, 19 May 2023 11:37:04 +0200
Message-Id: <20230519093708.810957-3-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519093708.810957-1-seiden@linux.ibm.com>
References: <20230519093708.810957-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MgEjIPP3aRtygvGkAEOp2nfpnuRaZII1
X-Proofpoint-GUID: MgEjIPP3aRtygvGkAEOp2nfpnuRaZII1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_06,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015 phishscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305190080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 61c7f284c5c5..c9bcd1b63d3c 100644
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

