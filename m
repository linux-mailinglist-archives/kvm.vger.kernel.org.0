Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0633E0484
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbhHDPlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:41:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239204AbhHDPlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:41:16 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174FXe07136022;
        Wed, 4 Aug 2021 11:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hw2W77z6/PD99yD1oIx6PHkg+jw33VvlI2yFLVFYYNk=;
 b=KuucZUtjMrnHPv11mpdSdDMMT72uVhDou94o7bMu6NttfayOkXVIKVZXgyhiL1FGGroy
 J7dNedv04zevUI9Im0kypNKypH/Y2GSfayCuRnsi40voceTws7Zs6nirWdOT2LA0txuK
 4JDUm6nEEN0fm9NH2g5JBJxmEU3icP6Uq8IyZloCmVQYBGgXBUSAprCn9gMgKt0/c9UC
 OFrk3tQ7o7wa50tsIRWlGqrB1ZYkLu0H+xJPzjkAa2Rn6UMuYT8IpPFO96EuBx4TKOzC
 y96xeBgRNXPYe+kx35Lson0u2HU7/SWWRHMt/DtyMW8Jo4KHf8PR9NoAaG7QjmWoXhQg Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a733k4njc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:03 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 174FYLUY141878;
        Wed, 4 Aug 2021 11:41:03 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a733k4ngy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:03 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 174FYWnu001178;
        Wed, 4 Aug 2021 15:41:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3a4x58rhgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 15:41:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 174Feuxu23724342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 15:40:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7191E4C046;
        Wed,  4 Aug 2021 15:40:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09A9C4C052;
        Wed,  4 Aug 2021 15:40:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.150])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Aug 2021 15:40:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v3 06/14] KVM: s390: pv: handle secure storage exceptions for normal guests
Date:   Wed,  4 Aug 2021 17:40:38 +0200
Message-Id: <20210804154046.88552-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210804154046.88552-1-imbrenda@linux.ibm.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: opwJ7F0q9Ks1zimO-ev7Ot_3Ji6cjNAf
X-Proofpoint-GUID: mmcSaJUc-6QBZLbTL5Oj3ixig3uYSnKZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_03:2021-08-04,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0
 mlxlogscore=770 suspectscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108040089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With upcoming patches, normal guests might touch secure pages.

This patch extends the existing exception handler to convert the pages
to non secure also when the exception is triggered by a normal guest.

This can happen for example when a secure guest reboots; the first
stage of a secure guest is non secure, and in general a secure guest
can reboot into non-secure mode.

If the secure memory of the previous boot has not been cleared up
completely yet, a non-secure guest might touch secure memory, which
will need to be handled properly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/fault.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index eb68b4f36927..74784581f42d 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -767,6 +767,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	struct page *page;
+	struct gmap *gmap;
 	int rc;
 
 	/*
@@ -796,6 +797,14 @@ void do_secure_storage_access(struct pt_regs *regs)
 	}
 
 	switch (get_fault_type(regs)) {
+	case GMAP_FAULT:
+		gmap = (struct gmap *)S390_lowcore.gmap;
+		addr = __gmap_translate(gmap, addr);
+		if (IS_ERR_VALUE(addr)) {
+			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
+			break;
+		}
+		fallthrough;
 	case USER_FAULT:
 		mm = current->mm;
 		mmap_read_lock(mm);
@@ -824,7 +833,6 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			BUG();
 		break;
-	case GMAP_FAULT:
 	default:
 		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
 		WARN_ON_ONCE(1);
-- 
2.31.1

