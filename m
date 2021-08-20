Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5143F2B67
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 13:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbhHTLlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 07:41:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239999AbhHTLlP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 07:41:15 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KBaNvd151535;
        Fri, 20 Aug 2021 07:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Qh1zqf5SK+tsNbTD2HcVwdJirLjCKunIK98c0yJ1t/E=;
 b=kgT3cw75iO/3iGBnFbAdKywg93lsj6V6lqD0MbguoA+0nvGOptgI4ST4dxkiFMIHkeVz
 U909x8q64YeBLtZTsJSODmfI8WE7ufqGGKJ9ieSVSnIr8GfYa7+9+grwLTCAOv0Lvym4
 dyk6TEPMTtRo0N6ek+oTa2syaqXc97PmuVQDdixO471p070B4jHl2ziIkJM8tSiWigeI
 cxqZpZQnECPLdIcWiX8vF2FE3zYKzwOeVzK66UTrU4l63idqFO3W4nsO8S95UzSstlKz
 48jNC3FkKr1OLQVMkxyMAubtiYvdWofVWKHZGTA6WKmdw6Og6t5GmWVqU6ZgdcLZiAMY Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ajaw5sa4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:40:37 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17KBbpXS159797;
        Fri, 20 Aug 2021 07:40:37 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ajaw5sa3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:40:37 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17KBdGEV019776;
        Fri, 20 Aug 2021 11:40:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3ae5f8geux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 11:40:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17KBeWQG54788558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 11:40:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C92EAE12A;
        Fri, 20 Aug 2021 11:40:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADA1BAE059;
        Fri, 20 Aug 2021 11:40:31 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Aug 2021 11:40:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/3] s390x: uv-host: Explain why we set up the home space and remove the space change
Date:   Fri, 20 Aug 2021 11:39:59 +0000
Message-Id: <20210820114000.166527-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210820114000.166527-1-frankja@linux.ibm.com>
References: <20210820114000.166527-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qR21uv53JKZOyB4fsy5bYKq3J6zy_Y96
X-Proofpoint-ORIG-GUID: YkYUoN2xCxbRLIzo6QENnIUKYl0YM0EF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_03:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UV home addresses don't require us to be in home space but we need to
have it set up so hw/fw can use the home asce to translate home
virtual addresses.

Hence we add a comment why we're setting up the home asce and remove
the address space since it's unneeded.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-host.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 426a67f6..28035707 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -444,13 +444,18 @@ static void test_clear(void)
 
 static void setup_vmem(void)
 {
-	uint64_t asce, mask;
+	uint64_t asce;
 
 	setup_mmu(get_max_ram_size(), NULL);
+	/*
+	 * setup_mmu() will enable DAT and set the primary address
+	 * space but we need to have a valid home space since UV calls
+	 * take home space virtual addresses.
+	 *
+	 * Hence we just copy the primary asce into the home space.
+	 */
 	asce = stctg(1);
 	lctlg(13, asce);
-	mask = extract_psw_mask() | 0x0000C00000000000UL;
-	load_psw_mask(mask);
 }
 
 int main(void)
-- 
2.30.2

