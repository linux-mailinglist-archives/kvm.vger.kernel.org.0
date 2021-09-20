Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E92B41158C
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbhITN0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:26:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239415AbhITN0m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:42 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD5P9022597;
        Mon, 20 Sep 2021 09:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hw2W77z6/PD99yD1oIx6PHkg+jw33VvlI2yFLVFYYNk=;
 b=gCcGzEZ1OHmLbzxNYcXQGxjW7i1a4XyYJt6b9WJG5jGk/2rwxV3KMSBdB1EUbUcB3dxr
 BapyQSuElZ1/UjlMYTrdHrWh5bNtZe3YRFJW90nHGgZ6SwF0S5gVy+tDPRhnhGyqs+tt
 esIgmGB5eDdsHsl27g5El4YHey+eNQDatyX1f8D/Svry/V/SP148gIHAuPEDIN6ntz12
 WMMfHfeWVNo0s0d1nKqkyrx03Qkor+hTTiy1460ZoVI1LSHnzeV0PQlZoXpXskdLo8XZ
 JtAZfe8ktzOuDI7CmOntJDeKbCucjK8mo8WBs4yp01TijYtKkQn3XBsHsjgpk/Fmdueu SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w6aj86k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:15 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDECvO025732;
        Mon, 20 Sep 2021 09:25:14 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w6aj857-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:14 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDC7O1006188;
        Mon, 20 Sep 2021 13:25:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3b57r9835q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDP7Vm42992036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:25:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6661A406E;
        Mon, 20 Sep 2021 13:25:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A34BA404D;
        Mon, 20 Sep 2021 13:25:07 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:07 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 08/14] KVM: s390: pv: handle secure storage exceptions for normal guests
Date:   Mon, 20 Sep 2021 15:24:56 +0200
Message-Id: <20210920132502.36111-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920132502.36111-1-imbrenda@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rOvXDodf52uB1rboPyO8bjiwz5lxlyxN
X-Proofpoint-ORIG-GUID: UO6NLJ4B_cMJ3aCSAnqGrXUGKYG2fq6Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=0 impostorscore=0 mlxlogscore=680
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200084
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

