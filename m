Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837A638890F
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243695AbhESIKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:10:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13862 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240902AbhESIKE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 04:10:04 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J83obQ073817;
        Wed, 19 May 2021 04:08:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mFALUa3fuajBPiOvzejYEozmKRmPbbix5gf/S6TPx3o=;
 b=Htr8z2jrjtuSqxQs7VB3LHikEho1ubNOtoqp2ZhpXEyg23Wo5GYGT7xf/htjsXtUGvQc
 i8+sC8i0oDDxsyYBTryr69vIsuy9DP7Gr4nJJWQljuPY+WE81gfb4xTKMPyb4AKFoAU8
 eGKbnmdxWd2VHP0AqYz11kUHD8LCZUxx+TgqZR1tiFhBxK52/u9PLFQz7Osoy4+QV8O0
 8KkiNJV78lerA4rXiy9ySbo0SEnUEBx5qOGuJ9Ud0vt40LBKi/Jro9R/89ZlbbDXSpGc
 ytKxUWJzuClBr4dJ6MZfo0sijePl4H+dVccioNshSi6c7VEKp7xt+BPGM6bBIlOuy7pR Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxj10n65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:08:44 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14J84RUi079001;
        Wed, 19 May 2021 04:08:44 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxj10n43-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:08:44 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J7bXPK018342;
        Wed, 19 May 2021 07:40:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 38j5jgsxe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:40:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J7ee7V37290342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 07:40:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 176B3A405F;
        Wed, 19 May 2021 07:40:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53D04A4054;
        Wed, 19 May 2021 07:40:39 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 07:40:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 5/6] s390x: uv-guest: Test invalid commands
Date:   Wed, 19 May 2021 07:40:21 +0000
Message-Id: <20210519074022.7368-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519074022.7368-1-frankja@linux.ibm.com>
References: <20210519074022.7368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E_UfDJHzegGhQol49iTOlTf-GwIhdHnI
X-Proofpoint-ORIG-GUID: HdpMKJISutn9qp8IRG9MBtEkvlCmbJ_d
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 impostorscore=0 adultscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if the UV calls that should not be available in a
protected guest 2 are actually not available. Also let's check if they
are falsely indicated to be available.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-guest.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index e99029a7..f05ae4c3 100644
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
+		       (invalid_cmds[i].call_bit == -1 || !uv_query_test_call(invalid_cmds[i].call_bit)),
+		       "%s", invalid_cmds[i].name);
+	}
+	report_prefix_pop();
 }
 
 int main(void)
-- 
2.30.2

