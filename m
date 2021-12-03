Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B23467BF2
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382299AbhLCRBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:01:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240527AbhLCRBr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:47 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GIJFh015330;
        Fri, 3 Dec 2021 16:58:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1jBO2WT2aSqpCcSIKW6FdDb3rcAg4E+HBS25NXYYGbM=;
 b=OpKvZ/7rxn3SNwE/q0hvzAJKXUI6/1F5e3Bl44dBrSschQjcs4VLx7dB33SjTi30mvKn
 14kZEkFgPmUkbEgLz1K1pydPFIGO4EVGtZ2NgOrbu7iGMdsRNNtrBZfHycXvJtGv/AFi
 V/Dzic2T25T5RewIqZomJVnSqw044h8C+tfKqABVA3WKZRsUnMYTacMWebDtaZfK+xYD
 g4s45gTqP77sHouMIV2z4ZJ3rC0j9Ck8Rbi0+eKX21FxUuKGP6xAcouyjLcMz9bqonl4
 sI20g7NZ1L/jW2zXgE0vZOt1TPmmbrKlm1IZqA+x9gLyRgZBfx82buE8sBozTxIxbVej OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28rxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:23 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3GLTY1032715;
        Fri, 3 Dec 2021 16:58:23 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28rwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3Gvl70005046;
        Fri, 3 Dec 2021 16:58:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3ckcaan3d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwHCc29032828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36B7E52054;
        Fri,  3 Dec 2021 16:58:17 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A837B5204F;
        Fri,  3 Dec 2021 16:58:16 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 03/17] KVM: s390: pv: handle secure storage exceptions for normal guests
Date:   Fri,  3 Dec 2021 17:58:00 +0100
Message-Id: <20211203165814.73016-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f7WJo9WkkQAkcrS8bYqvDWi_iIDxHkoY
X-Proofpoint-ORIG-GUID: ccr9bZkjhE-NmkQKkjkW839lAf-NxDSK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=573 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
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
completely yet (which will be allowed to happen in an upcoming patch),
a non-secure guest might touch secure memory, which will need to be
handled properly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/fault.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index a1928c89bbfa..a644e593eef9 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -770,6 +770,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	struct page *page;
+	struct gmap *gmap;
 	int rc;
 
 	/*
@@ -799,6 +800,14 @@ void do_secure_storage_access(struct pt_regs *regs)
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
@@ -827,7 +836,6 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			BUG();
 		break;
-	case GMAP_FAULT:
 	default:
 		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
 		WARN_ON_ONCE(1);
-- 
2.31.1

