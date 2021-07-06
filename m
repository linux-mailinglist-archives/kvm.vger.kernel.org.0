Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F6E3BC7F4
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 10:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGFIjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 04:39:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2318 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhGFIjT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 04:39:19 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1668Y7iR172320;
        Tue, 6 Jul 2021 04:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=DF8pQTLNqPseDpyvJDQZVtjau3PN8vamtQXe5Y3DKmQ=;
 b=ZqMwZ8/CNfGzcgb23/ybFcJx+ESoVbmNmCrJfxRjpQ+RprjfHeV7YjaqzxRxJo1e2fyE
 fElXf5GubtO+qEMdRqSShP1XaDIMAht2HBQnePHlpoxvT9w/lgXNDH/je6Hq1DZEPRMf
 ys0Q1nKFQRv/1cbUU0hWX3WJE+psuqXVD7mFx1d1ejQxh11/z840VupCKs2BeeJNVqdN
 N87uOJEs3iemL8XWmU6gjNilIrbWeuELCM4Vw1u1J3Up99rhu+Ng17ooPvx5O/xREavo
 h1cHRZilAAXqyseasInoUaYsynjqPPF+TpCirjvN3n6yhV1wpmUqM6U3E0jHRRoX7HCR uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14t947-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:36:33 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1668YSax173363;
        Tue, 6 Jul 2021 04:36:33 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc14t932-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:36:33 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1668X0TM015288;
        Tue, 6 Jul 2021 08:36:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 39jfh88ky7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:36:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1668aSAA16187748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 08:36:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F91DA4067;
        Tue,  6 Jul 2021 08:36:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32EF3A4064;
        Tue,  6 Jul 2021 08:36:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  6 Jul 2021 08:36:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D98C0E07F7; Tue,  6 Jul 2021 10:36:27 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, vkuznets@redhat.com,
        wanghaibin.wang@huawei.com
Subject: [GIT PULL 2/2] KVM: selftests: do not require 64GB in set_memory_region_test
Date:   Tue,  6 Jul 2021 10:36:26 +0200
Message-Id: <20210706083626.10941-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210706083626.10941-1-borntraeger@de.ibm.com>
References: <20210706083626.10941-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ySE0TBpU_cYpzD1RMfmCYt6LttVWU6xg
X-Proofpoint-GUID: cFzTzUcLSfnVGJx50K1AWoT50PmXFBlC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_04:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unless the user sets overcommit_memory or has plenty of swap, the latest
changes to the testcase will result in ENOMEM failures for hosts with
less than 64GB RAM. As we do not use much of the allocated memory, we
can use MAP_NORESERVE to avoid this error.

Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: vkuznets@redhat.com
Cc: wanghaibin.wang@huawei.com
Cc: stable@vger.kernel.org
Fixes: 309505dd5685 ("KVM: selftests: Fix mapping length truncation in m{,un}map()")
Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/kvm/20210701160425.33666-1-borntraeger@de.ibm.com/
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index d8812f27648c..d31f54ac4e98 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -377,7 +377,8 @@ static void test_add_max_memory_regions(void)
 		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
 
 	mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
-		   PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		   PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
 	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
 	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
 
-- 
2.31.1

