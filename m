Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C759738975
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbjFUPfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbjFUPer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:34:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD0B1FE7;
        Wed, 21 Jun 2023 08:34:26 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LEt1X2029548;
        Wed, 21 Jun 2023 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=pObdPNeAcFJ9kzxuagSOlQxZ/Rl0hzL+z+fBmpAGHm0=;
 b=Ppp6mBhud+o2tO+qSIrfNYIepjL0/77XwG7AxY3HWAShy+X41G3VxJR40i7tU4gOxaAR
 LtfjdbDzVCayiIe2gnOifGWUu0SiOIaq3UJtAu3oT64d648ON24dxbtgnIInoLH9pKDz
 wknFYWw29JdYmdvVmcfbQKaKy0Whswi7vI9W/SuQ8uU/tI6tnS6ey+mrecceZhpQ+DWV
 oYNPRdZp4j7irJXR0eYvFbeTpT9OuTZV/IFPNJVu73hrk8vlmiuaxlCMT04KQnt75xzn
 08FWDJK+/o7LuejNQcQ9DmfLAZJIa9RjwiDCELiq6cILKsXtmEWc5Y4rdIlrrw5qjZrP AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3d0hepw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:25 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LFV0XW010751;
        Wed, 21 Jun 2023 15:34:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3d0henf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35LEleuK011893;
        Wed, 21 Jun 2023 15:34:22 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3r943e2ucp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:21 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYIQH62062988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:18 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A58820049;
        Wed, 21 Jun 2023 15:34:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2655520043;
        Wed, 21 Jun 2023 15:34:18 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 06/11] s390/uvdevice: Add info IOCTL
Date:   Wed, 21 Jun 2023 17:29:12 +0200
Message-ID: <20230621153227.57250-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
References: <20230621153227.57250-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QKb2g6OYkDFlIjnsSX5wAe6snf2hP_nk
X-Proofpoint-ORIG-GUID: kqByetxUDtgfHiwBDqdiuXnOcjOx7XAZ
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

Add an IOCTL that allows userspace to find out which IOCTLs the uvdevice
supports without trial and error.

Explicitly expose the IOCTL nr for the request types.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230615100533.3996107-3-seiden@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20230615100533.3996107-3-seiden@linux.ibm.com>
---
 arch/s390/include/uapi/asm/uvdevice.h | 42 ++++++++++++++-
 drivers/s390/char/Kconfig             |  2 +-
 drivers/s390/char/uvdevice.c          | 77 ++++++++++++++++++++++++---
 3 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
index 10a5ac918e02..9d9b684836c2 100644
--- a/arch/s390/include/uapi/asm/uvdevice.h
+++ b/arch/s390/include/uapi/asm/uvdevice.h
@@ -32,6 +32,33 @@ struct uvio_attest {
 	__u16 reserved136;				/* 0x0136 */
 };
 
+/**
+ * uvio_uvdev_info - Information of supported functions
+ * @supp_uvio_cmds - supported IOCTLs by this device
+ * @supp_uv_cmds - supported UVCs corresponding to the IOCTL
+ *
+ * UVIO request to get information about supported request types by this
+ * uvdevice and the Ultravisor.  Everything is output. Bits are in LSB0
+ * ordering.  If the bit is set in both, @supp_uvio_cmds and @supp_uv_cmds, the
+ * uvdevice and the Ultravisor support that call.
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
+	 * corresponding to the IOCTL with nr `n` in the calling contextx (host
+	 * or guest).  The value is only valid if the corresponding bit in
+	 * @supp_uvio_cmds is set as well.
+	 */
+	__u64 supp_uv_cmds;
+};
+
 /*
  * The following max values define an upper length for the IOCTL in/out buffers.
  * However, they do not represent the maximum the Ultravisor allows which is
@@ -46,6 +73,19 @@ struct uvio_attest {
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
diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
index 80c4e5101c97..8a03af5ee5b3 100644
--- a/drivers/s390/char/Kconfig
+++ b/drivers/s390/char/Kconfig
@@ -96,7 +96,7 @@ config SCLP_OFB
 config S390_UV_UAPI
 	def_tristate m
 	prompt "Ultravisor userspace API"
-	depends on S390
+	depends on S390 && (KVM || PROTECTED_VIRTUALIZATION_GUEST)
 	help
 	  Selecting exposes parts of the UV interface to userspace
 	  by providing a misc character device at /dev/uv.
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 1d40457c7b10..7d7866be389b 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -32,6 +32,52 @@
 #include <asm/uvdevice.h>
 #include <asm/uv.h>
 
+#define BIT_UVIO_INTERNAL U32_MAX
+/* Mapping from IOCTL-nr to UVC-bit */
+static const u32 ioctl_nr_to_uvc_bit[] __initconst = {
+	[UVIO_IOCTL_UVDEV_INFO_NR] = BIT_UVIO_INTERNAL,
+	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
+};
+
+static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
+
+static struct uvio_uvdev_info uvdev_info = {
+	.supp_uvio_cmds = GENMASK_ULL(UVIO_IOCTL_NUM_IOCTLS - 1, 0),
+};
+
+static void __init set_supp_uv_cmds(unsigned long *supp_uv_cmds)
+{
+	int i;
+
+	for (i = 0; i < UVIO_IOCTL_NUM_IOCTLS; i++) {
+		if (ioctl_nr_to_uvc_bit[i] == BIT_UVIO_INTERNAL)
+			continue;
+		if (!test_bit_inv(ioctl_nr_to_uvc_bit[i], uv_info.inst_calls_list))
+			continue;
+		__set_bit(i, supp_uv_cmds);
+	}
+}
+
+/**
+ * uvio_uvdev_info() - get information about the uvdevice
+ *
+ * @uv_ioctl: ioctl control block
+ *
+ * Lists all IOCTLs that are supported by this uvdevice
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
+	return 0;
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
 
-	switch (cmd) {
-	case UVIO_IOCTL_ATT:
-		ret = uvio_copy_and_check_ioctl(&uv_ioctl, argp);
-		if (ret)
-			return ret;
+	nr = uvio_copy_and_check_ioctl(&uv_ioctl, argp, cmd);
+	if (nr < 0)
+		return nr;
+
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
+	set_supp_uv_cmds((unsigned long *)&uvdev_info.supp_uv_cmds);
 	return misc_register(&uvio_dev_miscdev);
 }
 
-- 
2.41.0

