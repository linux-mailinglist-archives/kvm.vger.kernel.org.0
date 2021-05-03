Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07153371561
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhECMsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:48:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233158AbhECMsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:48:16 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 143Chlhu111578
        for <kvm@vger.kernel.org>; Mon, 3 May 2021 08:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=G2JlGtX2ozq2IpnKeki6I70Y+RDTEp02vJMVP5vsifY=;
 b=lRAiHEKyDCOC1veWRuHxc2x7jUD7YcjdykljC8qAeAbBY76HSLiWjiOslNXcBkILcwbp
 KOoEHa2ZdCV0Lsr0bVDR8RTI7ioLbP6z//zO2YAEQbqrcXUioJWyG0gdf7RaRwWikMnj
 GRlmibzb9JTHMpD+BUz4nixQVGiCBj0XYHrenqPMaby2D6baG3lRZpmOVbXlRde8my3N
 nfHCK6JQcnrQa8gR/AVF2jXSbbCKIRH6S/hXy3WrtJ8TsLpBjsl5g7e+HgYb+bVpo9qf
 p+kIYzX4iJfeLRF7kbzoe/tQgai+o60oBo2ujGDqOns3Ib/M15LBNRWKQK08MOMrsFIn RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ahe803ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 08:47:23 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 143Cj4us118937
        for <kvm@vger.kernel.org>; Mon, 3 May 2021 08:47:22 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ahe803c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 May 2021 08:47:22 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 143CVjNf014629;
        Mon, 3 May 2021 12:47:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 388xm8gq4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 May 2021 12:47:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 143ClIow34275684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 May 2021 12:47:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 216CAA4060;
        Mon,  3 May 2021 12:47:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2DC6A4067;
        Mon,  3 May 2021 12:47:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.164.58])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 May 2021 12:47:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: Fix vector stfle checks
Date:   Mon,  3 May 2021 12:47:13 +0000
Message-Id: <20210503124713.68975-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G8Fh_NmeRkGTb2GQWQmL_D3j7TkJoRqH
X-Proofpoint-ORIG-GUID: T2oXPk0E59_wCUWwUq2fzKhs7-xA2Oee
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-03_07:2021-05-03,2021-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 bulkscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105030087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

134 is for bcd
135 is for the vector enhancements

Not the other way around...

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
---
 s390x/vector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/vector.c b/s390x/vector.c
index d1b6a571..b052de55 100644
--- a/s390x/vector.c
+++ b/s390x/vector.c
@@ -53,7 +53,7 @@ static void test_add(void)
 /* z14 vector extension test */
 static void test_ext1_nand(void)
 {
-	bool has_vext = test_facility(134);
+	bool has_vext = test_facility(135);
 	static struct prm {
 		__uint128_t a,b,c;
 	} prm __attribute__((aligned(16)));
@@ -79,7 +79,7 @@ static void test_ext1_nand(void)
 /* z14 bcd extension test */
 static void test_bcd_add(void)
 {
-	bool has_bcd = test_facility(135);
+	bool has_bcd = test_facility(134);
 	static struct prm {
 		__uint128_t a,b,c;
 	} prm __attribute__((aligned(16)));
-- 
2.27.0

