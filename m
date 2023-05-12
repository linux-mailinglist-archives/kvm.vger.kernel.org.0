Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A607003CE
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 11:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbjELJcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 05:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240351AbjELJcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 05:32:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A659C5;
        Fri, 12 May 2023 02:32:01 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C9VT9l014068;
        Fri, 12 May 2023 09:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VW/qTCS/8FZIdfpo4cD6IG+UYTuun6xEUokOrKZNc44=;
 b=AdXQDadMBXqW3H8u96kHtIGaULucn5kCBBOn2+M8ZJmQcogUrbcsudlpdPg2noIYcx27
 6YqrAquv09eD2SNqcEDeFmcqtjfInJdx1hy9jgvKmkXnNQCdvdp4NbaD9EyvvITW7tYJ
 oW7/Hp7nevt7ne/IDBOTLXdJLSqfNpWK8IGncYt1DlDtkbNMjFoxfqy7uXqT89io1tCC
 Lba23jhUiWYjtRUJV85ylXqI/Ggi7UQvpgW3toH7U7ceDcCQ7EeeB2SwzsqHpIUP91MC
 V6I7QfnHHCAoU8ixFd/2oH9PVIm85kMhtX3T8n5z7buGwaWKsDk3763Kg95zW3ft+eVS HQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhjnj8g6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34BNZUrN022304;
        Fri, 12 May 2023 09:31:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qf84ea8hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 09:31:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34C9VsEW58196362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 09:31:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F23B820040;
        Fri, 12 May 2023 09:31:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A21ED20049;
        Fri, 12 May 2023 09:31:53 +0000 (GMT)
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
Subject: [PATCH 1/5] s390/uvdevice: Add info IOCTL
Date:   Fri, 12 May 2023 11:31:49 +0200
Message-Id: <20230512093153.206378-2-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512093153.206378-1-seiden@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eq4PEe384ynxtWURsxIDCHNDV73YnZ72
X-Proofpoint-ORIG-GUID: eq4PEe384ynxtWURsxIDCHNDV73YnZ72
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an IOCTL that allows userspace to find out which IOCTLs the uvdevice
supports without trial and error.

Explicitly expose the IOCTL nr for the request types.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/uapi/asm/uvdevice.h | 45 +++++++++++++++-
 drivers/s390/char/uvdevice.c          | 77 ++++++++++++++++++++++++---
 2 files changed, 114 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
index 10a5ac918e02..ed58979b8438 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -32,6 +32,36 @@ struct uvio_attest {
 	__u16 reserved136;				/* 0x0136 */
 };
 
+/**
+ * uvio_uvdev_info - Information of supported functions
+ *
+ * @supp_uvio_cmds - supported IOCTLs by this device
+ * @supp_uv_cmds - supported UVCs corresponding to the IOCTL
+ *
+ * UVIO request to get information about supported request types by this
+ * uvdevice and the Ultravisor.
+ * Everything is output. Bits are in LSB0 ordering.
+ * If the bit is set in both, @supp_uvio_cmds and @supp_uv_cmds,
+ * the uvdevice and the Ultravisor support that call.
+ *
+ * Note that bit 0 (UVIO_IOCTL_UVDEV_INFO_NR) is always zero for `supp_uv_cmds`
+ * as there is no corresponding UV-call.
+ */
+struct uvio_uvdev_info {
+	/*
+	 * If bit `n` is set, this device supports the IOCTL with nr `n`.
+	 */
+	__u64 supp_uvio_cmds;
+	/*
+	 * If bit `n` is set, the Ultravisor(UV) supports the UV-call
+	 * corresponding to the IOCTL with nr `n` in the calling contextx
+	 * (host or guest).
+	 * The value is only valid if the corresponding bit in @supp_uvio_cmds
+	 * is set as well.
+	 */
+	__u64 supp_uv_cmds;
+};
+
 /*
  * The following max values define an upper length for the IOCTL in/out buffers.
  * However, they do not represent the maximum the Ultravisor allows which is
@@ -46,6 +76,19 @@ struct uvio_attest {
 #define UVIO_DEVICE_NAME "uv"
 #define UVIO_TYPE_UVC 'u'
 
-#define UVIO_IOCTL_ATT _IOWR(UVIO_TYPE_UVC, 0x01, struct uvio_ioctl_cb)
+enum UVIO_IOCTL_NR {
+	UVIO_IOCTL_UVDEV_INFO_NR = 0x00,
+	UVIO_IOCTL_ATT_NR,
+	/* must be the last entry */
+	UVIO_IOCTL_NUM_IOCTLS
+};
+
+#define UVIO_IOCTL(nr)		_IOWR(UVIO_TYPE_UVC, nr, struct uvio_ioctl_cb)
+#define UVIO_IOCTL_UVDEV_INFO	UVIO_IOCTL(UVIO_IOCTL_UVDEV_INFO_NR)
+#define UVIO_IOCTL_ATT		UVIO_IOCTL(UVIO_IOCTL_ATT_NR)
+
+#define UVIO_SUPP_CALL(nr)	(1ULL << (nr))
+#define UVIO_SUPP_UDEV_INFO	UVIO_SUPP_CALL(UVIO_IOCTL_UDEV_INFO_NR)
+#define UVIO_SUPP_ATT		UVIO_SUPP_CALL(UVIO_IOCTL_ATT_NR)
 
 #endif /* __S390_ASM_UVDEVICE_H */
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 1d40457c7b10..27f5bf1cf27a 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -20,6 +20,7 @@
  *  channel for userspace to the Ultravisor.
  */
 
+#include "asm-generic/ioctl.h"
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
@@ -32,6 +33,51 @@
 #include <asm/uvdevice.h>
 #include <asm/uv.h>
 
+/* Mapping from IOCTL-nr to UVC-bit */
+static const u64 ioctl_nr_to_uvc_bit[] __initconst = {
+	[UVIO_IOCTL_UVDEV_INFO_NR] = -1UL,
+	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
+};
+
+static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
+
+static struct uvio_uvdev_info uvdev_info = {
+	.supp_uvio_cmds = GENMASK_ULL(UVIO_IOCTL_NUM_IOCTLS - 1, 0),
+};
+
+static void __init set_supp_uv_cmds(struct uvio_uvdev_info *info)
+{
+	int i;
+
+	for (i = 0; i < UVIO_IOCTL_NUM_IOCTLS; i++) {
+		if (ioctl_nr_to_uvc_bit[i] == -1UL)
+			continue;
+		if (!test_bit_inv(ioctl_nr_to_uvc_bit[i], uv_info.inst_calls_list))
+			continue;
+		set_bit(i, (unsigned long *)&info->supp_uv_cmds);
+	}
+}
+
+/**
+ * uvio_uvdev_info() - get information about the uvdevice
+ *
+ * @uv_ioctl: ioctl control block
+ *
+ * Lists all supported IOCTLs by this uvdevice
+ */
+static int uvio_uvdev_info(struct uvio_ioctl_cb *uv_ioctl)
+{
+	void __user *user_buf_arg = (void __user *)uv_ioctl->argument_addr;
+
+	if (uv_ioctl->argument_len < sizeof(uvdev_info))
+		return -EINVAL;
+	if (copy_to_user(user_buf_arg, &uvdev_info, sizeof(uvdev_info)))
+		return -EFAULT;
+
+	uv_ioctl->uv_rc = UVC_RC_EXECUTED;
+	return  0;
+}
+
 static int uvio_build_uvcb_attest(struct uv_cb_attest *uvcb_attest, u8 *arcb,
 				  u8 *meas, u8 *add_data, struct uvio_attest *uvio_attest)
 {
@@ -185,8 +231,19 @@ static int uvio_attestation(struct uvio_ioctl_cb *uv_ioctl)
 	return ret;
 }
 
-static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp)
+static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
+				     unsigned long cmd)
 {
+	u8 nr = _IOC_NR(cmd);
+
+	if (_IOC_DIR(cmd) != (_IOC_READ | _IOC_WRITE))
+		return -ENOIOCTLCMD;
+	if (_IOC_TYPE(cmd) != UVIO_TYPE_UVC)
+		return -ENOIOCTLCMD;
+	if (nr >= UVIO_IOCTL_NUM_IOCTLS)
+		return -ENOIOCTLCMD;
+	if (_IOC_SIZE(cmd) != sizeof(*ioctl))
+		return -ENOIOCTLCMD;
 	if (copy_from_user(ioctl, argp, sizeof(*ioctl)))
 		return -EFAULT;
 	if (ioctl->flags != 0)
@@ -194,7 +251,7 @@ static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *a
 	if (memchr_inv(ioctl->reserved14, 0, sizeof(ioctl->reserved14)))
 		return -EINVAL;
 
-	return 0;
+	return nr;
 }
 
 /*
@@ -205,12 +262,17 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	struct uvio_ioctl_cb uv_ioctl = { };
 	long ret;
+	int nr;
+
+	nr = uvio_copy_and_check_ioctl(&uv_ioctl, argp, cmd);
+	if (nr < 0)
+		return nr;
 
-	switch (cmd) {
-	case UVIO_IOCTL_ATT:
-		ret = uvio_copy_and_check_ioctl(&uv_ioctl, argp);
-		if (ret)
-			return ret;
+	switch (nr) {
+	case UVIO_IOCTL_UVDEV_INFO_NR:
+		ret = uvio_uvdev_info(&uv_ioctl);
+		break;
+	case UVIO_IOCTL_ATT_NR:
 		ret = uvio_attestation(&uv_ioctl);
 		break;
 	default:
@@ -245,6 +307,7 @@ static void __exit uvio_dev_exit(void)
 
 static int __init uvio_dev_init(void)
 {
+	set_supp_uv_cmds(&uvdev_info);
 	return misc_register(&uvio_dev_miscdev);
 }
 
-- 
2.40.1

