Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083466C7DE0
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjCXMSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjCXMS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57219A6
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:16 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OAQc7j009065
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KAdbi6pn+Eho9EEwCVAO9o2BkfVClorEVAtvQBhcMqE=;
 b=OZjNB+S//OJ35GaqqrVlctwjpckK6NsrhDmnJ0xiLuLI4wf5niRYMTTipI3X15L6ObYf
 WxCZvGkR2mZjw7uCGlqyFxBrf58wfoe5TSLwov7u2XpXExWcom84Pi7ymDYCDWwnPtYB
 xfF4q6v/UFYkFTRdFiHQUCYFR2nTfkVl+R56oDThyQe6xgreeQQBJY19rg26d5wps06c
 zmlqd3/d8R/gJayZLoJKFeaITHQGDQrosOeZiocR7APbDOipXrdwiBS3kIKg6feTHgHy
 K0LHeVCSiG7DYUEE4InNNDHYx5Q/tS+XAleMVkYUW1mV3Qe680k4OY4gB1kgoOesEavK Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph7s76b6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:16 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBxP7W015233
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:15 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph7s76b64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLsnZP012701;
        Fri, 24 Mar 2023 12:18:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pgy3s0t22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCI9Fj26935924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC9672006A;
        Fri, 24 Mar 2023 12:18:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17E742004B;
        Fri, 24 Mar 2023 12:18:09 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/9] s390x: uv-host: Check for sufficient amount of memory
Date:   Fri, 24 Mar 2023 12:17:17 +0000
Message-Id: <20230324121724.1627-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H5PVo28SvfsgVTMXlt3N2a2Wl569tNx1
X-Proofpoint-GUID: Up8GqSvPQKRup5n8KCb0BJmb9MBHsKr1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV init storage needs to be above 2G so we need a little over 2G
of memory when running the test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 9dfaebd7..91e88a1f 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -720,6 +720,17 @@ int main(void)
 	test_invalid();
 	test_uv_uninitialized();
 	test_query();
+
+	/*
+	 * Some of the UV memory needs to be allocated with >31 bit
+	 * addresses which means we need a lot more memory than other
+	 * tests.
+	 */
+	if (get_ram_size() < (SZ_1M * 2200UL)) {
+		report_skip("Not enough memory. This test needs about 2200MB of memory");
+		goto done;
+	}
+
 	test_init();
 
 	setup_vmem();
-- 
2.34.1

