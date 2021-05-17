Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E05386550
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhEQUJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44746 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237680AbhEQUJY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:24 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK64cA160497;
        Mon, 17 May 2021 16:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ux1ZiH2dHVImPcfr09DJicV6FTfK5SjlQcNU5NOD2Wc=;
 b=pH+0Gvm3mLx3g+4IlnH7LAutNb8YuRkt/uSytbm496zRvZu8Mkd01uMwlICfLLBLjsXb
 1nUY6qm9B7GSL7MUSuj3HUZNYAmfJ6vO9ltdUZlJF3GMKeyCTmdYBbt42iUFfvJvW3yH
 fY5pJMMk4YJ4wXJHuQ7Xt0sUV1d86IWqlmgivqNdw9Pi0L+vw4oKRCLT+qGpZgEDEFos
 QG491fwqJevu+2ZAwgp0LeBX/4a9nTkt/D9hduGk+rRTmrgf05A2sxJ6NBLcwJatCkZf
 maj6WzZukEwIEbgCjjNfOrhIPvZMtb4RFLKzM/RBzirLH+YyzHiiKNh5oOc/k8mEYa3V Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxq1rudx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:06 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK6Fb7161080;
        Mon, 17 May 2021 16:08:06 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxq1rudb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:06 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK84wt028913;
        Mon, 17 May 2021 20:08:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 38j5jgs2ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK81sb25297168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:08:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37D7752050;
        Mon, 17 May 2021 20:08:01 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C731452051;
        Mon, 17 May 2021 20:08:00 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 04/11] KVM: s390: pv: handle secure storage exceptions for normal guests
Date:   Mon, 17 May 2021 22:07:51 +0200
Message-Id: <20210517200758.22593-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N0PtbDs51uFJT6yq5C7GoKvYHG4vD1OM
X-Proofpoint-ORIG-GUID: CqLMEsUWwDCXp5I_afU5orqDwPOl8T4r
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 mlxlogscore=929
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With upcoming patches, normal guests might touch secure pages.

This patch extends the existing exception handler to convert the pages
to non secure also when the exception is triggered by a normal guest.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/fault.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index efdef35bc415..24a39457cd48 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -789,9 +789,20 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	struct page *page;
+	struct gmap *gmap;
 	int rc;
 
 	switch (get_fault_type(regs)) {
+	case GMAP_FAULT:
+		gmap = (struct gmap *)S390_lowcore.gmap;
+		/*
+		 * Very unlikely, but if it happens, simply try again.
+		 * The next attempt will trigger a different exception.
+		 */
+		addr = __gmap_translate(gmap, addr);
+		if (addr == -EFAULT)
+			break;
+		fallthrough;
 	case USER_FAULT:
 		mm = current->mm;
 		mmap_read_lock(mm);
@@ -820,7 +831,6 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			BUG();
 		break;
-	case GMAP_FAULT:
 	default:
 		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
 		WARN_ON_ONCE(1);
-- 
2.31.1

