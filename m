Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F321F490D17
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241542AbiAQRAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44562 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241492AbiAQRAC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:00:02 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGveD2023477
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D5FvXFkE7Q6a1GtjVrzY1q2EZsqIgl4ob6uLH39pQ60=;
 b=qzfHXwFYqlMcMc41jsGbstVKdN5+Qd15xPy38iMp3hEuhYTSjQKCk6OpcmweUUn+blJ8
 T2uNzApSvnM1mMcpf6TeYy61IgykM/or4kStTPF+mj+MTq274M3mhGWTdJHxgu2d2/65
 C7oHYXwHV8Hdk4QvUflSKO1EU2iCHORgADjuhrFiqvhzS3mHjHA2hqY0riIiz4On8X2d
 MC7PxuWq5nrCDD6bKC6rpRtTsiADR+ufdudLWALUybV5d+nwW1boOwi+bTgWbfXsE+Ya
 nTAin7fV4RFZ+xDKzyfxb+gwflrBPlzhH+SZbUX7IspbU4/rebU6qFw22k73DDc8qdWe nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dncefr156-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:01 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGx5Eu027676
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dncefr14u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 17:00:00 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGl7D0019653;
        Mon, 17 Jan 2022 16:59:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9e2u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGofTm41877956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:50:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAE60A4060;
        Mon, 17 Jan 2022 16:59:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95A72A4054;
        Mon, 17 Jan 2022 16:59:55 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 13/13] s390x: firq: Fix sclp buffer allocation
Date:   Mon, 17 Jan 2022 17:59:49 +0100
Message-Id: <20220117165949.75964-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jl3rqJ6g2c8fmcSgj3hJVqmJ2reg2zoL
X-Proofpoint-ORIG-GUID: oTq6CX0G1zcmSZ1pf0ugO1BckbZY0iyt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1015 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=773 lowpriorityscore=0 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We need a 32 bit address for the sclp buffer so let's use a page from
the first 31 bits.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/firq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/firq.c b/s390x/firq.c
index 1f877183..fb9a2906 100644
--- a/s390x/firq.c
+++ b/s390x/firq.c
@@ -87,7 +87,7 @@ static void test_wait_state_delivery(void)
 	 */
 	while(smp_sense_running_status(1));
 
-	h = alloc_page();
+	h = alloc_pages_flags(0, AREA_DMA31);
 	h->length = 4096;
 	ret = servc(SCLP_CMDW_READ_CPU_INFO, __pa(h));
 	if (ret) {
-- 
2.31.1

