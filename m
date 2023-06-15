Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB87314D6
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 12:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343579AbjFOKFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 06:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245296AbjFOKFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 06:05:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F5B270E;
        Thu, 15 Jun 2023 03:05:41 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35F9rjon003227;
        Thu, 15 Jun 2023 10:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GYsghdN0ErHRWqjISdWce/ywKIp7aTfAzKxlY+daVsQ=;
 b=PVfIKUTwMcO+euFYOU3uAKo8RhrHcwAcYpqPZzmJuIFkwHMSANpLjgmI9pCR0m831WyT
 7HHQUiu/UikP0D7nGb5I/Zen8Zyl3R/rzHqi3cIRJiwr+D4bq78AZLLjlFa7Go7c3GVo
 16xrxvfzBVUFG6hPyu6BrWlqp4YBXthFOvxs/IoULKB/PDNKlFCUceBmd3F/RqynaRG6
 diJmzLU7T+YaQ03xSpm5dFfoME3qDBcriFDgNQTBqLRZk7fc4NAYcAWOAKX5wNEVMCgH
 ovrz5P5VSWfH6UrKT0P+tad4AxiGXVx28I28SvZjrginErv24LU6UruzXFszi/CadRzM 5w== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r80djg98n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:39 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35F5j3wG026971;
        Thu, 15 Jun 2023 10:05:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3r4gt52knx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 10:05:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35FA5Xa661669826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 10:05:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C5CF2006E;
        Thu, 15 Jun 2023 10:05:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D8322006B;
        Thu, 15 Jun 2023 10:05:33 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jun 2023 10:05:33 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v5 0/7] s390/uvdevice: Expose secret UVCs
Date:   Thu, 15 Jun 2023 12:05:26 +0200
Message-Id: <20230615100533.3996107-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yam3VfqKvFIEK4FZ9EMVxI4AZ3bHZDEs
X-Proofpoint-GUID: Yam3VfqKvFIEK4FZ9EMVxI4AZ3bHZDEs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_06,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
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

IBM Secure Execution guests may want to inject secrets into the Ultravisor(UV).
Also they should be able to know which secrets the UV possesses and prevent the
further addition of more secrets.

Therefore, add three new Ultravisor-Calls and expose them via the uvdevice: Add
Secret, List Secrets, and Lock Secrets. The uvdevice still acts as the
messenger only and does not inspect or modify the requests. Only some sanity
checks are made to prevent the kernel from corruption.
Also add a new IOCTL to get information about the supported UV-calls of the
uvdevice. As userspace wants to know which secrets, types, etc. are supported
expose the corresponding UV Query info data to userspace via sysfs.

The series contains:
  * A patch to export uv_info unconditionally
  * A new info IOCTL, giving information about the capabilities of the uvdevice and UV
  * 3 patches adding new Ultravisor-Calls and expose them to userspace
  * A patch replacing scnprintf with sysfs_emit in arch/s390/kernel/uv.c
  * A patch with an Ultravisor Query Info update for the new secret related information

Changes for v5:
  * fix Kconfig for uvdevice
  * add PATCH to always export `uv_info`
  * fix oopsie
  see diff below

Changes for v4:
  * more nits from Janosch

Changes for v3:
  * misc nits from Janosch

Changes for v2:
  * use __set_bit instead of the atomic set_bit (Heiko)
  * add a patch for replacing scnprintf with sysfs_emit in arch/s390/kernel/uv.c (Heiko)
  * use scnprintf instead of sysfs_emit for the new sysfs entries in the last patch (Heiko)
  * use hex values in struct definitions (Claudio)

Steffen

DIFF v4->v5

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index cdffc395f1cd..1e66d2cbb096 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -50,7 +50,7 @@ void uv_query_info(void)
 		uv_info.supp_add_secret_req_ver = uvcb.supp_add_secret_req_ver;
 		uv_info.supp_add_secret_pcf = uvcb.supp_add_secret_pcf;
 		uv_info.supp_secret_types = uvcb.supp_secret_types;
-		uv_info.max_secrets = uvcb.max_secrets
+		uv_info.max_secrets = uvcb.max_secrets;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 0687fc0360fe..6a0153289ace 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -23,12 +23,20 @@
 int __bootdata_preserved(prot_virt_guest);
 #endif
 
+/*
+ * uv_info contains both host and guest information but it's currently only
+ * expected to be used within modules if it's the KVM module or for
+ * any PV guest module.
+ *
+ * The kernel itself will write these values once in uv_query_info()
+ * and then make some of them readable via a sysfs interface.
+ */
 struct uv_info __bootdata_preserved(uv_info);
+EXPORT_SYMBOL(uv_info);
 
 #if IS_ENABLED(CONFIG_KVM)
 int __bootdata_preserved(prot_virt_host);
 EXPORT_SYMBOL(prot_virt_host);
-EXPORT_SYMBOL(uv_info);
 
 static int __init uv_init(phys_addr_t stor_base, unsigned long stor_len)
 {
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
index 79f694e04ac4..144cd2e03590 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -78,7 +78,7 @@ static int uvio_uvdev_info(struct uvio_ioctl_cb *uv_ioctl)
 		return -EFAULT;
 
 	uv_ioctl->uv_rc = UVC_RC_EXECUTED;
-	return  0;
+	return 0;
 }
 
 static int uvio_build_uvcb_attest(struct uv_cb_attest *uvcb_attest, u8 *arcb,

END DIFFv4->v5

Steffen Eiden (7):
  s390/uv: Always export uv_info
  s390/uvdevice: Add info IOCTL
  s390/uvdevice: Add 'Add Secret' UVC
  s390/uvdevice: Add 'List Secrets' UVC
  s390/uvdevice: Add 'Lock Secret Store' UVC
  s390/uv: replace scnprintf with sysfs_emit
  s390/uv: Update query for secret-UVCs

 arch/s390/boot/uv.c                   |   4 +
 arch/s390/include/asm/uv.h            |  32 +++-
 arch/s390/include/uapi/asm/uvdevice.h |  53 +++++-
 arch/s390/kernel/uv.c                 | 108 ++++++++----
 drivers/s390/char/Kconfig             |   2 +-
 drivers/s390/char/uvdevice.c          | 231 +++++++++++++++++++++++++-
 6 files changed, 386 insertions(+), 44 deletions(-)

-- 
2.40.1

