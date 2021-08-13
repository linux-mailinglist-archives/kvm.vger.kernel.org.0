Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4DF3EB1A5
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbhHMHiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239518AbhHMHiF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:05 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7WwiH010993;
        Fri, 13 Aug 2021 03:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gkbFMvLr/xV9N43Lk4ve3dXBfX3O6IpsQd3M1XBoxPg=;
 b=bHfCvVXy4WZAuZbwndhKNiZwnJYuHPqcAJ14EepSgyIEop204dvC2BkyDaR9oLvatpLM
 VXVWBzg4WQks94XioiHX1UkG3/TU7da3Bxcp+rxxgN2Y30Fb+UbKX13X4AIZA3O1/h2C
 r5eGNiU0qCwPBRjW3pltQ8/npNvHsXcwEOaV7DScmoEYujXmRYO/zaz8sMZGPlZlhM4s
 UxeQoUjgyNxwGHgKVH6UMgCf0aMNetbGrCQKSQhzANN1Zn1JjIRNXUFqMIw4wlS9lYHm
 PMOnVDOAr7KIji09euBIgBoLSzgH7KEXpL9j6yvnsWnX6NPdxkisdgD9+vRKQ4jNyC9C Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstpk5eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:38 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7X24G011351;
        Fri, 13 Aug 2021 03:37:38 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstpk5dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:38 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7MX5v003190;
        Fri, 13 Aug 2021 07:37:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3ada8sgjme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bXHC55640406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 659C44204B;
        Fri, 13 Aug 2021 07:37:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 153CB42041;
        Fri, 13 Aug 2021 07:37:33 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 8/8] lib: s390x: uv: Add rc 0x100 query error handling
Date:   Fri, 13 Aug 2021 07:36:15 +0000
Message-Id: <20210813073615.32837-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: io-VadB7KvQ6acMTQXp2ixUg8Vg1ZUzE
X-Proofpoint-ORIG-GUID: O8mU9nbWYtrTHN5-a20yUYU0LdYLMESf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's not get bitten by an extension of the query struct and handle
the rc 0x100 error properly which does indicate that the UV has more
data for us.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/uv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index fd9de944..c5c69c47 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -49,6 +49,8 @@ int uv_setup(void)
 	if (!test_facility(158))
 		return 0;
 
-	assert(!uv_call(0, (u64)&uvcb_qui));
+	uv_call(0, (u64)&uvcb_qui);
+
+	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 	return 1;
 }
-- 
2.30.2

