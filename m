Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB25C44D495
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 11:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhKKKEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 05:04:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20756 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229668AbhKKKET (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 05:04:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AB8hguT013130
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qOs//QHoWOopFMVE4LAXB7AzNcXBeFEHRb+Y1EnUdss=;
 b=Hl7BrmXIc5V3zoAnCJw4s3aQUw9t64aUMtcJxtlQKawTbzQGe2104afCmGsBCdIsNVwm
 8vYw+HZ7PZG/CWij2VVqH/WegJMOAnURxiHs2YmsRRASfkEdBrvl0bhHZU8wk67c+FpL
 ZHG1RUSZHTkFI+k7ue4anEgNZVMeb/vME56+CfdR24JS6wVqHxygJlqL/7/9aV7ha6JF
 nEMD8+kV02/QgWkbACIPA7uIw8yDl7OISlV4k+HmIHyZWnMMSdzm3rp6ArUc+JLKjcpg
 KixMwtGfGcbU/TV8YkriOrWRTBqzsKVVd+RYwCnC4Ug9MKUoPfJWVkB0HD8OMhi4dt9T Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c8ywv9wu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:01:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABA0HjU012904
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:01:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c8ywv9wtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 10:01:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AB9wn3o032195;
        Thu, 11 Nov 2021 10:01:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3c5gyk40sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 10:01:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABA1PHb55116194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 10:01:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E87DA52073;
        Thu, 11 Nov 2021 10:01:24 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.58])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9238352074;
        Thu, 11 Nov 2021 10:01:24 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Date:   Thu, 11 Nov 2021 11:01:53 +0100
Message-Id: <20211111100153.86088-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eYQBBIr4VW5wLk3gpbpG0eW3m_gN4zHV
X-Proofpoint-ORIG-GUID: aUUdEVGLULIlBdGm71kLTnTUPWcarh34
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_02,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=984 clxscore=1015 phishscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The allocator allocate pages it follows the size must be rounded
to pages before the allocation.

Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
index 78582eac..080fc694 100644
--- a/lib/s390x/malloc_io.c
+++ b/lib/s390x/malloc_io.c
@@ -41,7 +41,7 @@ static void unshare_pages(void *p, int count)
 
 void *alloc_io_mem(int size, int flags)
 {
-	int order = get_order(size >> PAGE_SHIFT);
+	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
 	void *p;
 	int n;
 
@@ -62,7 +62,7 @@ void *alloc_io_mem(int size, int flags)
 
 void free_io_mem(void *p, int size)
 {
-	int order = get_order(size >> PAGE_SHIFT);
+	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
 
 	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
 
-- 
2.25.1

