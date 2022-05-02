Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EAF516D96
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384333AbiEBJnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 05:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384321AbiEBJnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 05:43:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A211208E;
        Mon,  2 May 2022 02:39:38 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2429U95G003090;
        Mon, 2 May 2022 09:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mDDGrZb6xXv7BDHfGB6lsqbcGQtaCAo9Ju+QNGuihj0=;
 b=jNkaBTCbzj/tZjaivOzMnuzTMJiBIhHG2wnu8eZbikFy0mF9Zm6WUAu2soQ99gKcjR5G
 LOVdYTJrtG3irc+Vsbx3U9TMVC2yy+IdjEEqf166BYdxslwETyWejN6hDUWdT7VP23sd
 ZRcQF/geJjxR//Qe/Lk/TD5sAejH6ppOdNVV6RapaK+6jiQULGlShWyjsTsTz5kXhtth
 JniyH5UbJ0sjv4ylXIsscXYhwRTLeAvjg2VEruVs/aBgiNQDQAPkM/oSRGa1IHlKHzSS
 NuOpjVpzZFJzH9J1OizDpzMvNkQAzs9RtRm5EgADXUNGNukcOAovb85EYe5G7mie/UUS Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftcqqg5gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:37 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2429UL4r003886;
        Mon, 2 May 2022 09:39:36 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftcqqg5f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:36 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2429c6TW025598;
        Mon, 2 May 2022 09:39:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3frvcj21sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 09:39:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2429dVJY36045100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 09:39:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87261AE04D;
        Mon,  2 May 2022 09:39:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCE60AE051;
        Mon,  2 May 2022 09:39:30 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 09:39:30 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 5/6] s390x: uv-guest: add share bit test
Date:   Mon,  2 May 2022 09:39:24 +0000
Message-Id: <20220502093925.4118-6-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220502093925.4118-1-seiden@linux.ibm.com>
References: <20220502093925.4118-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Me_Si3ocgJOPC5cI8DWHa54u8ShYWq9m
X-Proofpoint-GUID: mIBVMc1eXj0xVr5QZk1kv223XfFNaXmR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV facility bits shared/unshared must both be set or none.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-guest.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index fd2cfef1..152ad807 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -157,6 +157,16 @@ static void test_invalid(void)
 	report_prefix_pop();
 }
 
+static void test_share_bits(void)
+{
+	bool unshare = uv_query_test_call(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
+	bool share = uv_query_test_call(BIT_UVC_CMD_SET_SHARED_ACCESS);
+
+	report_prefix_push("query");
+	report(!(share ^ unshare), "share bits are identical");
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	bool has_uvc = test_facility(158);
@@ -167,6 +177,12 @@ int main(void)
 		goto done;
 	}
 
+	/*
+	 * Needs to be done before the guest-fence,
+	 * as the fence tests if both shared bits are present
+	 */
+	test_share_bits();
+
 	if (!uv_os_is_guest()) {
 		report_skip("Not a protected guest");
 		goto done;
-- 
2.30.2

