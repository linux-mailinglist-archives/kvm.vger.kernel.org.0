Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2E33DA4A6
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbhG2Nsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:48:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12378 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237813AbhG2Ns1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:48:27 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TDgALf109798;
        Thu, 29 Jul 2021 09:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CDs+LVthPv03BLTFGwvqb05OcTnp8NgWKZ4mKsCatN8=;
 b=ZBiU/6WL2lrNFCVkJH2JTR0HHqhBy/jW9U2Rova1f75Hsx/8Natq47QNC2TDNS6Y4ImK
 eSOZhRaM8W8BeZrHgEW9WNso8EexhEprpRgd6JQ64SlNDJRNbYUiw3UncKq0AoK/xFL0
 1fjY83s3XCp+BlfqLaLXR/tmejzLKnbr+oVVkdZjFBAaFzcfCWPQfyZCJHW0CZPRg31u
 082gDa84YpEjqkTWZ8RVE88dTJhb23o50EkGh0Gwq36Cp+Unzlf3u05y9/6b8Bz/sNLX
 TJ32SL76A6VWyM0Gxj/bLwR4C0PU+FdiOFk78HGrgtPfSuG0zgnEcui0VtJMMpqFsuxF WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3qb6n4gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TDhQo3115640;
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3qb6n4fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDZwwg031045;
        Thu, 29 Jul 2021 13:48:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3a235m1r8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:48:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDjQIW33751512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:45:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 269964C095;
        Thu, 29 Jul 2021 13:48:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9E984C070;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 2/4] s390x: lib: Introduce HPAGE_* constants
Date:   Thu, 29 Jul 2021 13:48:01 +0000
Message-Id: <20210729134803.183358-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729134803.183358-1-frankja@linux.ibm.com>
References: <20210729134803.183358-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BnY1H4xdZdOit44nCLvpF6_A4Q1ywRM4
X-Proofpoint-ORIG-GUID: AiEDgN-oA7AFVZQr0aSFwcOXEa59IxbF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 phishscore=0 bulkscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They come in handy when working with 1MB blocks/addresses.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/page.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/s390x/asm/page.h b/lib/s390x/asm/page.h
index f130f936..2f4afd06 100644
--- a/lib/s390x/asm/page.h
+++ b/lib/s390x/asm/page.h
@@ -35,4 +35,8 @@ typedef struct { pteval_t pte; } pte_t;
 #define __pmd(x)	((pmd_t) { (x) } )
 #define __pte(x)	((pte_t) { (x) } )
 
+#define HPAGE_SHIFT		20
+#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
+#define HPAGE_MASK		(~(HPAGE_SIZE-1))
+
 #endif
-- 
2.30.2

