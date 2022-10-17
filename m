Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1F1600B15
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiJQJkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiJQJkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A209A264B4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:40:04 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H9Fta8027017
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jE9sWz1ovN5Pl22JvVJt77ITNe0sjU8w19kXxw8DRmk=;
 b=Yl2ALzF6glX7bD2Kh1LhWzAkB57uQYSBTLBym9y5hDhjNDg/VIoNSAZ54ParcT9WBgXW
 V1AdRCEEcpcUQPS5GL0hgLhiYWmK7FJSJplxqoahRc4WpOrEnyayjyTWK/lKZLbSRP5F
 zm/tQCupPsegegt4Tn80HYXKCTyLk4FOKlxj5dtpIuEbW8kWOB8l/EYn6c9m9NJdlb8C
 uhqIKa2QIyVRHFNBZjYGUtMU2sMCgfPeJuUwYYEdI3Z+xoStLRDujFJqGhjxIL1vWdKA
 wMT9WFr5SrhHmBX3PxScIQCO8FGRVbm0b5GC/QtJdcbeDgEf7swh3s261gYgOcmAXOx5 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86sjkq9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:04 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H8gXBQ020050
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:40:03 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86sjkq83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:03 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9ZDKH022726;
        Mon, 17 Oct 2022 09:40:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg9232f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:40:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9Z2BH46465488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:35:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63763A405C;
        Mon, 17 Oct 2022 09:39:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAEACA4054;
        Mon, 17 Oct 2022 09:39:57 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 7/8] s390x: uv-host: Fence against being run as a PV guest
Date:   Mon, 17 Oct 2022 09:39:24 +0000
Message-Id: <20221017093925.2038-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cqpq6JyyVRZA5RPAVvUZ0IStyCZN_tkm
X-Proofpoint-GUID: o17FRfaQ_cW6MrwQObRGhSM7bfJrb7w6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test checks the UV host API so we should skip it if we're a PV
guest.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/uv-host.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 76d3e373..a33389b9 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -703,6 +703,10 @@ int main(void)
 		report_skip("Ultravisor call facility is not available");
 		goto done;
 	}
+	if (!uv_os_is_host()) {
+		report_skip("This test needs to be run in a UV host environment");
+		goto done;
+	}
 
 	test_i3();
 	test_priv();
-- 
2.34.1

