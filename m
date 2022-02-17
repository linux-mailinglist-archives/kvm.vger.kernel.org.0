Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661D34BA30E
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241981AbiBQOf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:35:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbiBQOfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834A12B1A8F
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:22 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HEGak2005748
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=k90ugeX7QRiIsoQ/yaN6nAGSe53R8dwCGA7dTRTyJPI=;
 b=ZgLELItgBGeoURmdLSBTNUhwlKU1oubTvGaNmLv/e+noHos5QUVNS/OBc0dYwQRig0vF
 AZFt41Poc5xis6sRryOQNh23IqO2tH/w/79gvd8/uaAWI/CmrQAuZ0qCz+MWvouKY16p
 abi9Q2z+3SDCrAKbMO3zJPhZ876dTCPApcg+NjtosZ+1pZGh6p/u5hDzQJXEXkv1qEq4
 Rp85MT1kUOW+hPAt7ZfBjf7NhdKHrTnMC1kLmriHUgq2KIYAdPxtjQeMTJwt3loZDbAn
 6ApmqjTRDExqr7wSeIm4wkf73wj2b/tLghkgZnTqvBulJdZngZOZy/I7aRPssyQ1gxJw 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9r008f2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:21 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HEVTBi017870
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9r008f1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEXNEm032259;
        Thu, 17 Feb 2022 14:35:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e64hak97j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZEGS29819318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00D0142042;
        Thu, 17 Feb 2022 14:35:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B21154204B;
        Thu, 17 Feb 2022 14:35:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:13 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 2/9] s390x: uv: Fix UVC cmd prepare reset name
Date:   Thu, 17 Feb 2022 15:34:57 +0100
Message-Id: <20220217143504.232688-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c0Euedgx3pWt_Vf2mtpjGLngaHLzpCeo
X-Proofpoint-GUID: ScX28k-TCk_alkwY8QiM76VD3VcCrsxd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The specification and the kernel use UVC_CMD_PREPARE_RESET so let's
fix our naming up.

The call bit is named correctly but is not the same as the name we use
on KVM. So let's clear that up too.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 4 ++--
 s390x/uv-guest.c   | 2 +-
 s390x/uv-host.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 97c90e81..70bf65c4 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -39,7 +39,7 @@
 #define UVC_CMD_VERIFY_IMG		0x0302
 #define UVC_CMD_CPU_RESET		0x0310
 #define UVC_CMD_CPU_RESET_INITIAL	0x0311
-#define UVC_CMD_PERF_CONF_CLEAR_RESET	0x0320
+#define UVC_CMD_PREPARE_RESET		0x0320
 #define UVC_CMD_CPU_RESET_CLEAR		0x0321
 #define UVC_CMD_CPU_SET_STATE		0x0330
 #define UVC_CMD_SET_UNSHARED_ALL	0x0340
@@ -66,7 +66,7 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_CPU_RESET = 15,
 	BIT_UVC_CMD_CPU_RESET_INITIAL = 16,
 	BIT_UVC_CMD_CPU_SET_STATE = 17,
-	BIT_UVC_CMD_PREPARE_CLEAR_RESET = 18,
+	BIT_UVC_CMD_PREPARE_RESET = 18,
 	BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET = 19,
 	BIT_UVC_CMD_UNSHARE_ALL = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 44ad2154..99120cae 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -142,7 +142,7 @@ static struct {
 	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_VERIFY_IMG },
 	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
 	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
-	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
+	{ "prepare clear reset", UVC_CMD_PREPARE_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_RESET },
 	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
 	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
 	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 92a41069..de2e4850 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -55,7 +55,7 @@ static struct cmd_list cmds[] = {
 	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_VERIFY_IMG },
 	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
 	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
-	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
+	{ "conf clear reset", UVC_CMD_PREPARE_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_RESET },
 	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
 	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
 	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },
-- 
2.34.1

