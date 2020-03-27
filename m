Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8B01953E2
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 10:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgC0JYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 05:24:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgC0JYF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 05:24:05 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R93QLJ097759;
        Fri, 27 Mar 2020 05:24:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywd2v2pgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 05:24:03 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02R93sIM099089;
        Fri, 27 Mar 2020 05:24:03 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywd2v2pgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 05:24:03 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02R9NIdj028461;
        Fri, 27 Mar 2020 09:24:02 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 2ywawmnbjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Mar 2020 09:24:02 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02R9NxTW55312846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 09:23:59 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAAD66A04D;
        Fri, 27 Mar 2020 09:23:59 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 176BB6A04F;
        Fri, 27 Mar 2020 09:23:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 Mar 2020 09:23:58 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2] s390/gmap: return proper error code on ksm unsharing
Date:   Fri, 27 Mar 2020 05:23:56 -0400
Message-Id: <20200327092356.25171-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_02:2020-03-26,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=690 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a signal is pending we might return -ENOMEM instead of -EINTR.
We should propagate the proper error during KSM unsharing.

Fixes: 3ac8e38015d4 ("s390/mm: disable KSM for storage key enabled pages")
Reviewed-by: Janosch Frank <frankja@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/mm/gmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 27926a06df32..1ef864c252e6 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2552,12 +2552,13 @@ int gmap_mark_unmergeable(void)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
+	int ret;
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
-				MADV_UNMERGEABLE, &vma->vm_flags)) {
-			return -ENOMEM;
-		}
+		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
+				  MADV_UNMERGEABLE, &vma->vm_flags);
+		if (ret)
+			return ret;
 	}
 	mm->def_flags &= ~VM_MERGEABLE;
 	return 0;
-- 
2.25.1

