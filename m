Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759E43EB1A2
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239530AbhHMHiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14918 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239508AbhHMHiE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:04 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7Y7Wc004651;
        Fri, 13 Aug 2021 03:37:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NN/i62EjJProUv1yyj9rF15TOnLZNMYBCpicJKHwcdQ=;
 b=mi3mPaE60WwhSnJExRWcgxZmi3XrnfnTtUO2wWzNfDNEgBQHlGKL6mKzV/X9hZWe4RRE
 mqKdrqKW7xtX/cYhs3Y+isdM3VsJv3M9wD125mEmyHIur0KifgbjAx75JKwQXW/uM3YX
 R6j8bq9NBzCD35Uf6C+anpXeTfoPeaamR4AQKNLjk99JgTYPTTjQaWbwxE5+q3tP3VyS
 +SnHlHsqoWEKJclBmr8jHLvv0mvPKHWvR0yj5KBXKiPYg8Mv1X6gcmAB0ledl+Aeqn+D
 oCmcBrM5E66ir1nXsWiUxKYkWU379MS++sts2V3elrXdthjPH1ho3Tlor0jGRhmiA5JU Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad5sdxfxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:37 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7ZNF6009106;
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad5sdxfwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7NXCg028759;
        Fri, 13 Aug 2021 07:37:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3acf0kup7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bWLm52167000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34DC842054;
        Fri, 13 Aug 2021 07:37:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC2F442047;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 5/8] s390x: uv-host: Explain why we set up the home space and remove the space change
Date:   Fri, 13 Aug 2021 07:36:12 +0000
Message-Id: <20210813073615.32837-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FoBz53g9dzzOl_YLNZPv5WT9T6pCebVB
X-Proofpoint-GUID: SNaic6cIt8rLcDjowtWNI58oTjT9uhQ0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UV home addresses don't require us to be in home space but we need to
have it set up so hw/fw can use the home asce to translate home
virtual addresses.

Hence we add a comment why we're setting up the home asce and remove
the address space since it's unneeded.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

