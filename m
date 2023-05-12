Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B847003D1
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbjELJcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 05:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240334AbjELJcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:32:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4430F8A7F;
        Fri, 12 May 2023 02:32:01 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C9M5qQ024417;
        Fri, 12 May 2023 09:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Przw5wX7LusbQmgojWDyuB1hJtXSKpEmLujX8VYDULE=;
 b=YsCVRzlscmrbs9fReS4ZZ/l24WFYRIwNfEbzR04VXPTiUygo/B/LEIsMesQeqM0MBkIm
 nuSSctlXC0tRvLGwdLgT9P0V3FECR5WBZkPNqm+lZK8vkuK158QjFKdhQJZ8JmuYbpme
 vt8cun28mF3nu7zXy1lhkW55RmOiYaRuE2QS8lTxwsqg6BKvScu+a3tyc/ogjnLbodLs
 0DE4laquPPji8DYN8iJQOBS/jjZnEptSLMfh5XXHJ9keP6Bc0jA7YACALsnL1Cmzi86X
 LwzPE+x0YOjBfBdv86Wts3/7Ha/rDFVlUe9cDr8vTGtlvgOj6O1UcvkKd9NjgVuMaHQk GQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhjrx09wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:32:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C472Hi022068;
        Fri, 12 May 2023 09:31:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qf7nh28cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34C9VtjK39715434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 09:31:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19F4220043;
        Fri, 12 May 2023 09:31:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE94520049;
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
Subject: [PATCH 4/5] s390/uvdevice: Add 'Lock Secret Store' UVC
Date:   Fri, 12 May 2023 11:31:52 +0200
Message-Id: <20230512093153.206378-5-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512093153.206378-1-seiden@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IWxcvuxNi8jmcDk6bniPV9t_dLrk3i2K
X-Proofpoint-ORIG-GUID: IWxcvuxNi8jmcDk6bniPV9t_dLrk3i2K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace can call the Lock Secret Store Ultravisor Call
using IOCTLs on the uvdevice.
During the handling of the new IOCTL nr the uvdevice will do some sanity
checks first. Then, perform the Ultravisor command, and copy the
return codes to userspace.
If the Lock Secrets UV facility is not present, UV will return
invalid command rc. This won't be fenced in the driver and does not
result in a negative return value. This is also true for any other
possible error code the UV can return.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/uv.h            |  2 ++
 arch/s390/include/uapi/asm/uvdevice.h |  3 +++
 drivers/s390/char/uvdevice.c          | 39 +++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 1e4f0f6d4923..6180ac8909d5 100644
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
index cf12d6b8d8d8..b6e8d47dd589 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -83,6 +83,7 @@ enum UVIO_IOCTL_NR {
 	UVIO_IOCTL_ATT_NR,
 	UVIO_IOCTL_ADD_SECRET_NR,
 	UVIO_IOCTL_LIST_SECRETS_NR,
+	UVIO_IOCTL_LOCK_SECRETS_NR,
 	/* must be the last entry */
 	UVIO_IOCTL_NUM_IOCTLS
 };
@@ -92,11 +93,13 @@ enum UVIO_IOCTL_NR {
 #define UVIO_IOCTL_ATT		UVIO_IOCTL(UVIO_IOCTL_ATT_NR)
 #define UVIO_IOCTL_ADD_SECRET	UVIO_IOCTL(UVIO_IOCTL_ADD_SECRET_NR)
 #define UVIO_IOCTL_LIST_SECRETS	UVIO_IOCTL(UVIO_IOCTL_LIST_SECRETS_NR)
+#define UVIO_IOCTL_LOCK_SECRETS UVIO_IOCTL(UVIO_IOCTL_LOCK_SECRETS_NR)
 
 #define UVIO_SUPP_CALL(nr)	(1ULL << (nr))
 #define UVIO_SUPP_UDEV_INFO	UVIO_SUPP_CALL(UVIO_IOCTL_UDEV_INFO_NR)
 #define UVIO_SUPP_ATT		UVIO_SUPP_CALL(UVIO_IOCTL_ATT_NR)
 #define UVIO_SUPP_ADD_SECRET	UVIO_SUPP_CALL(UVIO_IOCTL_ADD_SECRET_NR)
 #define UVIO_SUPP_LIST_SECRETS	UVIO_SUPP_CALL(UVIO_IOCTL_LIST_SECRETS_NR)
+#define UVIO_SUPP_LOCK_SECRETS	UVIO_SUPP_CALL(UVIO_IOCTL_LOCK_SECRETS_NR)
 
 #endif /* __S390_ASM_UVDEVICE_H */
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 5fcd719047ab..621c9f2b9853 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -39,6 +39,7 @@ static const u64 ioctl_nr_to_uvc_bit[] __initconst = {
 	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
 	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
 	[UVIO_IOCTL_LIST_SECRETS_NR] = BIT_UVC_CMD_LIST_SECRETS,
+	[UVIO_IOCTL_LOCK_SECRETS_NR] = BIT_UVC_CMD_LOCK_SECRETS,
 };
 
 static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
@@ -338,6 +339,41 @@ static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
 	return ret;
 }
 
+/** uvio_lock_secrets() - perform a Lock Secret Store UVC
+ *
+ * @uv_ioctl: ioctl control block
+ *
+ * uvio_lock_secrets() performs the Lock Secret Store Ultravisor Call.
+ * It performs the UV-call and copies the return codes to the
+ * ioctl control block.
+ *
+ * The argument address and size must be 0.
+ *
+ * If the List Secrets UV facility is not present,
+ * UV will return invalid command rc. This won't be fenced in the driver
+ * and does not result in a negative return value.
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
@@ -388,6 +424,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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

