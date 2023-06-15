Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2AC7314D2
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343512AbjFOKFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 06:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241743AbjFOKFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 06:05:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA2E26AD;
        Thu, 15 Jun 2023 03:05:41 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35F9i6f1004815;
        Thu, 15 Jun 2023 10:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QnlUyMDfS9Yqi42asRErIcHPc5zerf+NVjYc9cQTKBY=;
 b=N4EiPewESHa1W+fgkMrXzXaEVtL7ZG/76BQZIdtPpRI2TEyJSlE9wFc9BR9bt6bbu/CK
 uXDhGDpSuGJGqhVOpl5Y1l3COwKJ814gK26bYIct86wi6GokWFmGN4Hy2J/t3Ng1PFsM
 gDBe0m9Kx38yhM/UL+DRQLUtN8fad3NnusxPgrtsxjTmo8Se/pXHHVHttm5vrCt6aNQz
 0CmzQ0bpFd/UbMpuiTn+QWu2ff58KOMpz6jLWHMx3qjmv20tAVC3b6gm2o/PytfWV2WL
 3Yh1EyZJBRBATzy+3a3ama6WzZ1gnICw7EF8BnlSaicvngsVT7BHIrxpABY/TukqXycQ mg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r80908j8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35F0NCWC017873;
        Thu, 15 Jun 2023 10:05:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r4gt53h89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35FA5Yft5702204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 10:05:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B74DE20063;
        Thu, 15 Jun 2023 10:05:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A28020073;
        Thu, 15 Jun 2023 10:05:34 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jun 2023 10:05:34 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v5 5/7] s390/uvdevice: Add 'Lock Secret Store' UVC
Date:   Thu, 15 Jun 2023 12:05:31 +0200
Message-Id: <20230615100533.3996107-6-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615100533.3996107-1-seiden@linux.ibm.com>
References: <20230615100533.3996107-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EzSC3xbKDlCy0vZ1FNCvfbIU6AHAzEB2
X-Proofpoint-GUID: EzSC3xbKDlCy0vZ1FNCvfbIU6AHAzEB2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_06,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can call the Lock Secret Store Ultravisor Call
using IOCTLs on the uvdevice. The Lock Secret Store UV call
disables all additions of secrets for the future.

The uvdevice is merely transporting the request from userspace to the
Ultravisor.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h            |  2 ++
 arch/s390/include/uapi/asm/uvdevice.h |  3 +++
 drivers/s390/char/uvdevice.c          | 39 +++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index eeb945a7c80e..1d47b3e40be8 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -60,6 +60,7 @@
 #define UVC_CMD_RETR_ATTEST		0x1020
 #define UVC_CMD_ADD_SECRET		0x1031
 #define UVC_CMD_LIST_SECRETS		0x1033
+#define UVC_CMD_LOCK_SECRETS		0x1034
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
@@ -92,6 +93,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_RETR_ATTEST = 28,
 	BIT_UVC_CMD_ADD_SECRET = 29,
 	BIT_UVC_CMD_LIST_SECRETS = 30,
+	BIT_UVC_CMD_LOCK_SECRETS = 31,
 };
 
 enum uv_feat_ind {
diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
index 76045da44868..b9c2f14a6af3 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -80,6 +80,7 @@ enum UVIO_IOCTL_NR {
 	UVIO_IOCTL_ATT_NR,
 	UVIO_IOCTL_ADD_SECRET_NR,
 	UVIO_IOCTL_LIST_SECRETS_NR,
+	UVIO_IOCTL_LOCK_SECRETS_NR,
 	/* must be the last entry */
 	UVIO_IOCTL_NUM_IOCTLS
 };
@@ -89,11 +90,13 @@ enum UVIO_IOCTL_NR {
 #define UVIO_IOCTL_ATT		UVIO_IOCTL(UVIO_IOCTL_ATT_NR)
 #define UVIO_IOCTL_ADD_SECRET	UVIO_IOCTL(UVIO_IOCTL_ADD_SECRET_NR)
 #define UVIO_IOCTL_LIST_SECRETS	UVIO_IOCTL(UVIO_IOCTL_LIST_SECRETS_NR)
+#define UVIO_IOCTL_LOCK_SECRETS	UVIO_IOCTL(UVIO_IOCTL_LOCK_SECRETS_NR)
 
 #define UVIO_SUPP_CALL(nr)	(1ULL << (nr))
 #define UVIO_SUPP_UDEV_INFO	UVIO_SUPP_CALL(UVIO_IOCTL_UDEV_INFO_NR)
 #define UVIO_SUPP_ATT		UVIO_SUPP_CALL(UVIO_IOCTL_ATT_NR)
 #define UVIO_SUPP_ADD_SECRET	UVIO_SUPP_CALL(UVIO_IOCTL_ADD_SECRET_NR)
 #define UVIO_SUPP_LIST_SECRETS	UVIO_SUPP_CALL(UVIO_IOCTL_LIST_SECRETS_NR)
+#define UVIO_SUPP_LOCK_SECRETS	UVIO_SUPP_CALL(UVIO_IOCTL_LOCK_SECRETS_NR)
 
 #endif /* __S390_ASM_UVDEVICE_H */
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 70502c4ec290..144cd2e03590 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -39,6 +39,7 @@ static const u32 ioctl_nr_to_uvc_bit[] __initconst = {
 	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
 	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
 	[UVIO_IOCTL_LIST_SECRETS_NR] = BIT_UVC_CMD_LIST_SECRETS,
+	[UVIO_IOCTL_LOCK_SECRETS_NR] = BIT_UVC_CMD_LOCK_SECRETS,
 };
 
 static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
@@ -340,6 +341,41 @@ static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
 	return ret;
 }
 
+/** uvio_lock_secrets() - perform a Lock Secret Store UVC
+ * @uv_ioctl: ioctl control block
+ *
+ * uvio_lock_secrets() performs the Lock Secret Store Ultravisor Call. It
+ * performs the UV-call and copies the return codes to the ioctl control block.
+ * After this call was dispatched successfully every following Add Secret UVC
+ * and Lock Secrets UVC will fail with return code 0x102.
+ *
+ * The argument address and size must be 0.
+ *
+ * If the Lock Secrets UV facility is not present, UV will return invalid
+ * command rc. This won't be fenced in the driver and does not result in a
+ * negative return value.
+ *
+ * Context: might sleep
+ *
+ * Return: 0 on success or a negative error code on error.
+ */
+static int uvio_lock_secrets(struct uvio_ioctl_cb *ioctl)
+{
+	struct uv_cb_nodata uvcb = {
+		.header.len = sizeof(uvcb),
+		.header.cmd = UVC_CMD_LOCK_SECRETS,
+	};
+
+	if (ioctl->argument_addr || ioctl->argument_len)
+		return -EINVAL;
+
+	uv_call(0, (u64)&uvcb);
+	ioctl->uv_rc = uvcb.header.rc;
+	ioctl->uv_rrc = uvcb.header.rrc;
+
+	return 0;
+}
+
 static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
 				     unsigned long cmd)
 {
@@ -390,6 +426,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case UVIO_IOCTL_LIST_SECRETS_NR:
 		ret = uvio_list_secrets(&uv_ioctl);
 		break;
+	case UVIO_IOCTL_LOCK_SECRETS_NR:
+		ret = uvio_lock_secrets(&uv_ioctl);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.40.1

