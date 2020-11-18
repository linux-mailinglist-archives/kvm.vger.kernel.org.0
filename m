Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74EA2B7A82
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKRJjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 04:39:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgKRJju (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 04:39:50 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI9Vm9w070697;
        Wed, 18 Nov 2020 04:39:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xktAxGBOdEZvx7tyc+6+MDC+lnv6CTwONXvIwAGOYhk=;
 b=rMTgizFLN1dl+HA3Slzw3Z78zryRPdM1lcj4KbfAlc0EryVkz9bH+bu6pJvh3oJFyn2+
 jncmIUn0BfgvZLzH0dkdVnTX6TFHNvSC3+2KgWWe8BHXGZrB7W7spIrXMKmGo9INtkuN
 fVB+n2BQRdRiCk2TwGzZM8o84uC6dD1PoS9KiEyFfsaCo3Xos7Ga8JbkodTfREbDqpJ8
 9eEn/7kQfb34f2/FtzUGxg4y8WmzpSBVpYr5QIOdcniojXh3Gga7Jn1IcY+wyz3pYPx8
 E+c5k7rwA95JOPvJTe3yzJfEV16aF4+g/qwbRBLjF9i1BB6E/whHV0woa49Y4HC0/gpJ Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w12g07uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 04:39:49 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AI9VqiA070976;
        Wed, 18 Nov 2020 04:39:49 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34w12g07ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 04:39:49 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AI9bFIB020355;
        Wed, 18 Nov 2020 09:39:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh40v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 09:39:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AI9diDZ6488692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 09:39:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E164452050;
        Wed, 18 Nov 2020 09:39:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id CE67C52051;
        Wed, 18 Nov 2020 09:39:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 91597E23AF; Wed, 18 Nov 2020 10:39:43 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 1/2] s390/uv: handle destroy page legacy interface
Date:   Wed, 18 Nov 2020 10:39:41 +0100
Message-Id: <20201118093942.457191-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201118093942.457191-1-borntraeger@de.ibm.com>
References: <20201118093942.457191-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=984 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Older firmware can return rc=0x107 rrc=0xd for destroy page if the
page is already non-secure. This should be handled like a success
as already done by newer firmware.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: 1a80b54d1ce1 ("s390/uv: add destroy page call")
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 14bd9d58edc9..883bfed9f5c2 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -129,8 +129,15 @@ int uv_destroy_page(unsigned long paddr)
 		.paddr = paddr
 	};
 
-	if (uv_call(0, (u64)&uvcb))
+	if (uv_call(0, (u64)&uvcb)) {
+		/*
+		 * Older firmware uses 107/d as an indication of a non secure
+		 * page. Let us emulate the newer variant (no-op).
+		 */
+		if (uvcb.header.rc == 0x107 && uvcb.header.rrc == 0xd)
+			return 0;
 		return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.28.0

