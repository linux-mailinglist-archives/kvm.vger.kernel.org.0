Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33B7386549
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbhEQUJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237715AbhEQUJZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:25 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK4EHw180618;
        Mon, 17 May 2021 16:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IkQrFwfQLgY8mmgSfXQgJ8FcV+A12hr/mwZR74/w49k=;
 b=cVcSo40SPJ8bt6Oax54jreGJc88PQ8gKXHsgfWpKWiVfX6JOLzJTwRCnqwbMmQmkQ1Fx
 lLOhdUpjaikgsVpzb7AWkHvY/BkMLpNT8b/+wQs1kX5vDgoE/+asfDsBLEja/HliC9Ja
 TG0MD4t+6+ETUpe81pTePNok2komGoTLsmAQ26beLCglwzyq7RWASpYxlXUiodVmd4/8
 O9UaEzrN1HfomAfSnqsPhDtdrjO/mSe9fhtF30NozIbagZllv8Vbc8LVOwzUjXeMiOSE
 /+n8ibgouL/XCU0FvMtn1qA5WE8wX8Uz37WAqktJrfRtquCJDfFdkTPbhmJ3zZjqYQX1 XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxwr8g9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:08 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK4Fdg180719;
        Mon, 17 May 2021 16:08:07 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxwr8g8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK85Ju005722;
        Mon, 17 May 2021 20:08:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7s2nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK82LA23068992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:08:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8100F5204F;
        Mon, 17 May 2021 20:08:02 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 20CBF52057;
        Mon, 17 May 2021 20:08:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 07/11] KVM: s390: pv: add export before import
Date:   Mon, 17 May 2021 22:07:54 +0200
Message-Id: <20210517200758.22593-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zK19GH1nIwmkKZEohsPrWw6gPQTYY9y5
X-Proofpoint-ORIG-GUID: mUIXc4IvunjnJbw94Uqk2CadebnsuXkz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to upcoming changes, it will be possible to temporarily have
multiple protected VMs in the same address space. When that happens,
it is necessary to perform an export of every page that is to be
imported.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index b19b1a1444ec..dbcf4434eb53 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -242,6 +242,12 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	return rc;
 }
 
+static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
+{
+	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
+		atomic_read(&mm->context.is_protected) > 1;
+}
+
 /*
  * Requests the Ultravisor to make a page accessible to a guest.
  * If it's brought in the first time, it will be cleared. If
@@ -285,6 +291,8 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 
 	lock_page(page);
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
+	if (should_export_before_import(uvcb, gmap->mm))
+		uv_convert_from_secure(page_to_phys(page));
 	rc = make_secure_pte(ptep, uaddr, page, uvcb);
 	pte_unmap_unlock(ptep, ptelock);
 	unlock_page(page);
-- 
2.31.1

