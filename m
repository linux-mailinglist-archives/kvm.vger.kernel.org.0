Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DBC2B8287
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 18:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgKRRCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 12:02:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbgKRRCj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 12:02:39 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIGg25F096937;
        Wed, 18 Nov 2020 12:02:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=F4R1xVKOfLPBffxpB6TbUmxJsHZtMlfMkdttB86CPt8=;
 b=rUAjaBn5BSEbfoFHJZx/6JLUwec1s86vVIaGkbr6tSR9zbQXKVquqZELdHIXkHSBF/Nt
 AS4GfO4rKG1/Hc8lVN+anrHPsJbyZ/Rg8YQT74kdjyjNMJvagCqVR6j7kycvXKSs2y+w
 fe/kgH7cPkgSzz7aE74bTBUBsp6Ve8+O83r76HsapZsmGyQHjehb39wjicthMTQ2J4mn
 y60PW86mS8KqcdNUC9O+4nJA+oQ2HlubjhDo2OdjcE2qE6xB5POayjHxejCV0fp79KrF
 7CuajSN5IocjqEueVv9B4TUiNmRqzSsc01pcR8wGC5l5lzaaRYb/T9gIGyPGc2vwYsWh Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w31vk72f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 12:02:38 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AIGgUct099667;
        Wed, 18 Nov 2020 12:02:38 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w31vk715-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 12:02:38 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AIH1OnP003357;
        Wed, 18 Nov 2020 17:02:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v8as98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 17:02:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AIH1HHN6226458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 17:01:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDEDE4C058;
        Wed, 18 Nov 2020 17:01:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB84E4C04E;
        Wed, 18 Nov 2020 17:01:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Nov 2020 17:01:17 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 8F91DE01E9; Wed, 18 Nov 2020 18:01:17 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 1/2] s390/uv: handle destroy page legacy interface
Date:   Wed, 18 Nov 2020 18:01:15 +0100
Message-Id: <20201118170116.8239-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201118170116.8239-1-borntraeger@de.ibm.com>
References: <20201118170116.8239-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Older firmware can return rc=0x107 rrc=0xd for destroy page if the
page is already non-secure. This should be handled like a success
as already done by newer firmware.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Fixes: 1a80b54d1ce1 ("s390/uv: add destroy page call")
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
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

