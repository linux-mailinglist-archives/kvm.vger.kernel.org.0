Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93575378FF5
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbhEJN5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:57:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241881AbhEJNxQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:53:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14ADXKMD154732;
        Mon, 10 May 2021 09:52:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8IPg4IOSf+Gd9cE6+WkaA1WBxdjp7wmZGSno3Q6KPQY=;
 b=icvdCgs1myGfRrKxTCKyAkNEknrxXubPoaia9PJ28AIc8VAEA9JmmW2I3m6eDhIqibac
 mY7QJohREcdZd3Jf3BrtoZqJIPPvirEtw5sXn16VoT630Ck4Rz2sHyNfnc5fLJZmej2x
 R2UFJkPb6NaqbFlL4sb4s9zCjfHgIXXCZrgio0KxALUMaTVa54m5d5BGsGCwiwgSspPs
 hp/jqphMfloU/SdsnLXq4nQyyaVUF1JfIqXCQcVGDvzZwhS8ajZozTVIDScsm0muZEpn
 wzOueDHpeMdMPPg80QRxxWqiAZc0nXVlcX8LF0J2iOWxLRohCCWH4Aj5W0/hhuEpOKiG MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3scvygd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:12 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14ADXe90158248;
        Mon, 10 May 2021 09:52:11 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3scvyfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:11 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14ADq9iM001789;
        Mon, 10 May 2021 13:52:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 38dhwh90j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:52:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14ADpdM628180946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 13:51:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47CB7A4040;
        Mon, 10 May 2021 13:52:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85C22A4057;
        Mon, 10 May 2021 13:52:05 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 13:52:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 5/6] s390x: uv-guest: Test invalid commands
Date:   Mon, 10 May 2021 13:51:47 +0000
Message-Id: <20210510135148.1904-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510135148.1904-1-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JKV_nPaJv2Q0Nwldr5SxnFn02_bof0MS
X-Proofpoint-GUID: sJUKpIomKBX3bWhmziMXUQ-LlTCxMdDt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_07:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 mlxscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105100096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if the UV calls that should not be available in a
protected guest 2 are actually not available. Also let's check if they
are falsely indicated to be available.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-guest.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index e99029a7..ce2ef79b 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -121,16 +121,48 @@ static void test_sharing(void)
 	report_prefix_pop();
 }
 
+static struct {
+	const char *name;
+	uint16_t cmd;
+	uint16_t len;
+	int call_bit;
+} invalid_cmds[] = {
+	{ "bogus", 0x4242, sizeof(struct uv_cb_header), -1 },
+	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
+	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
+	{ "destroy conf", UVC_CMD_DESTROY_SEC_CONF, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_DESTROY_SEC_CONF },
+	{ "create cpu", UVC_CMD_CREATE_SEC_CPU, sizeof(struct uv_cb_csc), BIT_UVC_CMD_CREATE_SEC_CPU },
+	{ "destroy cpu", UVC_CMD_DESTROY_SEC_CPU, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_DESTROY_SEC_CPU },
+	{ "conv to", UVC_CMD_CONV_TO_SEC_STOR, sizeof(struct uv_cb_cts), BIT_UVC_CMD_CONV_TO_SEC_STOR },
+	{ "conv from", UVC_CMD_CONV_FROM_SEC_STOR, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_CONV_FROM_SEC_STOR },
+	{ "set sec conf", UVC_CMD_SET_SEC_CONF_PARAMS, sizeof(struct uv_cb_ssc), BIT_UVC_CMD_SET_SEC_PARMS },
+	{ "unpack", UVC_CMD_UNPACK_IMG, sizeof(struct uv_cb_unp), BIT_UVC_CMD_UNPACK_IMG },
+	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_VERIFY_IMG },
+	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
+	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
+	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
+	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
+	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
+	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },
+	{ "unpin shared", UVC_CMD_UNPIN_PAGE_SHARED, sizeof(struct uv_cb_cts), BIT_UVC_CMD_UNPIN_PAGE_SHARED },
+	{ NULL, 0, 0 },
+};
+
 static void test_invalid(void)
 {
-	struct uv_cb_header uvcb = {
-		.len = 16,
-		.cmd = 0x4242,
-	};
-	int cc;
+	struct uv_cb_header *hdr = (void *)page;
+	int cc, i;
 
-	cc = uv_call(0, (u64)&uvcb);
-	report(cc == 1 && uvcb.rc == UVC_RC_INV_CMD, "invalid command");
+	report_prefix_push("invalid");
+	for (i = 0; invalid_cmds[i].name; i++) {
+		hdr->cmd = invalid_cmds[i].cmd;
+		hdr->len = invalid_cmds[i].len;
+		cc = uv_call(0, (u64)hdr);
+		report(cc == 1 && hdr->rc == UVC_RC_INV_CMD &&
+		       invalid_cmds[i].call_bit == -1 ? true : !uv_query_test_call(invalid_cmds[i].call_bit),
+		       "%s", invalid_cmds[i].name);
+	}
+	report_prefix_pop();
 }
 
 int main(void)
-- 
2.30.2

