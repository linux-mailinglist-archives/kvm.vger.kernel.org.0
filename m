Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35B73A2F95
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhFJPop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:44:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230280AbhFJPon (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 11:44:43 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AFXO9a191021;
        Thu, 10 Jun 2021 11:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=C7T1dNiDQ2imTqntlWjIOOSa+cy5WfZb/znhYm7cuOo=;
 b=KJaB4swg7yxXlUgl4My5M+ngYjmdmpJ0rMKmJPDCWmpGBV3YVuFrH9g40OVZPk2lvGa4
 nXEMD4/leBFZ1GCjJtD5+SSWGlguh6AhZ9HmlIoFYtJypTHWkk+Tmq6nrPO1qw/7a1qH
 1su1DlWsi9w6NgNWdzGe67mwpIKxmGgjdGOfhX5rRbRO3mLCTWRXUMO1G2A1xFrXtb+o
 JYKgdLuafjEy3lzmq3e0I3c3m/MGrMjGpOJIs340xK8X+qUx9TUzWRYaeg79G5LOwgLY
 WBncbGVcF4JcQHnm1JsZlyd2Qg15WEuSJ+sJPlqXvUdw74TYVsaoZ6KXI0oCNWzAhW7H 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393maq2ymt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:42:29 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15AFXOdk191134;
        Thu, 10 Jun 2021 11:42:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393maq2ykf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:42:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AFa5Nb000714;
        Thu, 10 Jun 2021 15:42:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8jwt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 15:42:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AFgN4A33685930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 15:42:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BC6D4204B;
        Thu, 10 Jun 2021 15:42:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 714BF42045;
        Thu, 10 Jun 2021 15:42:22 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 15:42:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 2/2] KVM: s390: fix for hugepage vmalloc
Date:   Thu, 10 Jun 2021 17:42:20 +0200
Message-Id: <20210610154220.529122-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610154220.529122-1-imbrenda@linux.ibm.com>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: f2bIjlpU2qOZC5QP62bw1yslvSASTZBD
X-Proofpoint-GUID: jkcCYnLSx41nMxS6qSlPTyO2Y6TQYMln
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_10:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=687 spamscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Create Secure Configuration Ultravisor Call does not support using
large pages for the virtual memory area. This is a hardware limitation.

This patch replaces the vzalloc call with an almost equivalent call to
the newly introduced vmalloc_no_huge function, which guarantees that
only small pages will be used for the backing.

The new call will not clear the allocated memory, but that has never
been an actual requirement.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 arch/s390/kvm/pv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 813b6e93dc83..ad7c6d7cc90b 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -140,7 +140,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	/* Allocate variable storage */
 	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
 	vlen += uv_info.guest_virt_base_stor_len;
-	kvm->arch.pv.stor_var = vzalloc(vlen);
+	kvm->arch.pv.stor_var = vmalloc_no_huge(vlen);
 	if (!kvm->arch.pv.stor_var)
 		goto out_err;
 	return 0;
-- 
2.31.1

