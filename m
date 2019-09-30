Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B4C21C3
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbfI3NUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 09:20:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731280AbfI3NUI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Sep 2019 09:20:08 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8UDIGBX134036
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:07 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vbjd70buy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:06 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Sep 2019 14:20:05 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Sep 2019 14:20:01 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8UDJxgO14090322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 13:19:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE679AE04D;
        Mon, 30 Sep 2019 13:19:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 970CAAE045;
        Mon, 30 Sep 2019 13:19:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 30 Sep 2019 13:19:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 4C917E01C8; Mon, 30 Sep 2019 15:19:59 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        qemu-s390x <qemu-s390x@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PULL 12/12] s390/kvm: split kvm mem slots at 4TB
Date:   Mon, 30 Sep 2019 15:19:55 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930131955.101131-1-borntraeger@de.ibm.com>
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19093013-0028-0000-0000-000003A3FD55
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19093013-0029-0000-0000-0000246626AF
Message-Id: <20190930131955.101131-13-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=858 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909300138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of splitting at an unaligned address, we can simply split at
4TB.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Igor Mammedov <imammedo@redhat.com>
---
 target/s390x/kvm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index 54864c259c5e..c24c869e7703 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -126,12 +126,11 @@
 /*
  * KVM does only support memory slots up to KVM_MEM_MAX_NR_PAGES pages
  * as the dirty bitmap must be managed by bitops that take an int as
- * position indicator. If we have a guest beyond that we will split off
- * new subregions. The split must happen on a segment boundary (1MB).
+ * position indicator. This would end at an unaligned  address
+ * (0x7fffff00000). As future variants might provide larger pages
+ * and to make all addresses properly aligned, let us split at 4TB.
  */
-#define KVM_MEM_MAX_NR_PAGES ((1ULL << 31) - 1)
-#define SEG_MSK (~0xfffffULL)
-#define KVM_SLOT_MAX_BYTES ((KVM_MEM_MAX_NR_PAGES * TARGET_PAGE_SIZE) & SEG_MSK)
+#define KVM_SLOT_MAX_BYTES (4UL * TiB)
 
 static CPUWatchpoint hw_watchpoint;
 /*
-- 
2.21.0

