Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00EA4BFB4A
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 15:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiBVOzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 09:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbiBVOzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 09:55:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CDC10C513;
        Tue, 22 Feb 2022 06:55:10 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MEhqrZ000330;
        Tue, 22 Feb 2022 14:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=btGRwvF7AFlYnTVHmc0uCAheHymyGzGwFIweOZtQICQ=;
 b=BpQ37i59s6tGM3caDRrVEuIl4ueTF6vbkGiXy+gTiEFC4RqmTEPFhkd6Jif3/hZ+ocLf
 zmNBvBAKTlUA9YOhS+Xj1ZEn6h4fts4VMfr5y3NoUqwnbflG2zQWXkNK0ftHoFoySIII
 ssXIvurD1lX/gyTfWetMht1xmPoo9Re2emFFerkxhUPKFdnWymXxyN6IkzRBS2FxKGRQ
 tbxuJ9k7BbGDD0rXFi5sBqoTzcDSDtlyocy1A0c8ZgY/046trHcOFpMyI4Eh3T5xXMsH
 KyNPF88wW2B/EsiFoyypRhYdgLU6pbxRTv0wUrh8xrZ8uw9Us1mSMX08fwGIWf0tVTbS jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed1dj8u4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:09 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MEkcK4017163;
        Tue, 22 Feb 2022 14:55:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed1dj8u3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MEhWHc018828;
        Tue, 22 Feb 2022 14:55:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ear693qns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 14:55:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MEt3Wt56099124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 14:55:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC8BFA4065;
        Tue, 22 Feb 2022 14:55:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96B88A405F;
        Tue, 22 Feb 2022 14:55:02 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 14:55:02 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 4/5] s390x: uv-guest: add share bit test
Date:   Tue, 22 Feb 2022 14:54:55 +0000
Message-Id: <20220222145456.9956-5-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222145456.9956-1-seiden@linux.ibm.com>
References: <20220222145456.9956-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m9WkwSMBIExHV7-WTIV7nbo1sqDkYW_l
X-Proofpoint-ORIG-GUID: MBdAFwdr1_TqfdCcziAqej7iGjDcMYjC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV facility bits shared/unshared must both be set or none.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-guest.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 728c60aa..77057bd2 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -159,6 +159,14 @@ static void test_invalid(void)
 	report_prefix_pop();
 }
 
+static void test_share_bits(void)
+{
+	bool unshare = uv_query_test_call(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
+	bool share = uv_query_test_call(BIT_UVC_CMD_SET_SHARED_ACCESS);
+
+	report(!(share ^ unshare), "share bits");
+}
+
 int main(void)
 {
 	bool has_uvc = test_facility(158);
@@ -169,6 +177,12 @@ int main(void)
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

