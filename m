Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F28C77D240
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbjHOSo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbjHOSn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:43:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22042F1;
        Tue, 15 Aug 2023 11:43:55 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FIXXwn012566;
        Tue, 15 Aug 2023 18:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=q/jLwR83/lnH1cHBc32/KhpZyw/fX7+xBJ8P7kPzvv4=;
 b=pYdTRs/ftpFfGQ6/j/hAmhCUbE+XnfxoexZB9/JTbOlv8uNxNbFl4AJ4T2dBuGWE8ExO
 YHzaLqIMMGxe0aJt+j2jX6O5qazb+5SO3oZ8M0gpwnS9WCsHrfxBlM49IKAm5hJTAbXe
 4/UcZXF00nhqEe+mMtCcUNRbLJUFLGS1aZRgDLs+TQkTwYrsMRo3cairVrIg5/deaFN4
 KKzJoHS8ydrIGaRxOXXwDPEDQrQKpzF0H6Gf+SG/5V3xT6vv0BZue42iHycsikLF6aw4
 hhcjF+BmZDrjV4J2i5FLRRnpuVyQQjNNS5m74WD+hFK9dfp7qCgjU1xZCpOSe41TUR68 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgeqv86sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:52 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FIhLl9013204;
        Tue, 15 Aug 2023 18:43:52 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgeqv86s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:51 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FH6ndU003495;
        Tue, 15 Aug 2023 18:43:51 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3semdsffps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 18:43:51 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FIhnFo65929616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 18:43:50 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E17205804E;
        Tue, 15 Aug 2023 18:43:49 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97B3F5803F;
        Tue, 15 Aug 2023 18:43:48 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.75.177])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 18:43:48 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Janosch Frank <frankja@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH 10/12] s390/uv: export uv_pin_shared for direct usage
Date:   Tue, 15 Aug 2023 14:43:31 -0400
Message-Id: <20230815184333.6554-11-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230815184333.6554-1-akrowiak@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u4fDNuUAdztnBL0gu5brzCMK0il2XpfG
X-Proofpoint-ORIG-GUID: RJ-7Rlb3E-ZIKB8wmEnxu9bjEIlgAZaS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=874 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308150167
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Export the uv_pin_shared function so that it can be called from other
modules that carry a GPL-compatible license.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Tested-by: Viktor Mihajlovski <mihajlov@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 6 ++++++
 arch/s390/kernel/uv.c      | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index d6bb2f4f78d1..d2cd42bb2c26 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -463,6 +463,7 @@ static inline int is_prot_virt_host(void)
 	return prot_virt_host;
 }
 
+int uv_pin_shared(unsigned long paddr);
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_owned_page(unsigned long paddr);
@@ -475,6 +476,11 @@ void setup_uv(void);
 #define is_prot_virt_host() 0
 static inline void setup_uv(void) {}
 
+static inline int uv_pin_shared(unsigned long paddr)
+{
+	return 0;
+}
+
 static inline int uv_destroy_owned_page(unsigned long paddr)
 {
 	return 0;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 66f0eb1c872b..b771f1b4cdd1 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -88,7 +88,7 @@ void __init setup_uv(void)
  * Requests the Ultravisor to pin the page in the shared state. This will
  * cause an intercept when the guest attempts to unshare the pinned page.
  */
-static int uv_pin_shared(unsigned long paddr)
+int uv_pin_shared(unsigned long paddr)
 {
 	struct uv_cb_cfs uvcb = {
 		.header.cmd = UVC_CMD_PIN_PAGE_SHARED,
@@ -100,6 +100,7 @@ static int uv_pin_shared(unsigned long paddr)
 		return -EINVAL;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(uv_pin_shared);
 
 /*
  * Requests the Ultravisor to destroy a guest page and make it
-- 
2.39.3

