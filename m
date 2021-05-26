Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC34391C49
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhEZPqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:46:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233354AbhEZPqI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 11:46:08 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QFZHM0091469;
        Wed, 26 May 2021 11:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=KLQMidqpNJXuUcsX6USaZJHzqRrH8FWeJImszu+cH9Y=;
 b=gtlPXz9vb97Lo4KPxSrHwBDOXCal1nmIyTMQW1JG34wMHY+KXEG9juEiY3cxl+95lIrs
 yaE8ik7fvJgoZRyXjnyC2lIMymfnPyREu6BVskt5ANV35CvCxqtSOJ36UlxU8YLToBX7
 00GUbRzxlzRCocOgb4qs5NwBMpT6yQIC+Fo/dWR/8U1B+dsoR5QVZ8LPas8XqujPg+XJ
 ly+N5lc/9lftJM/bGT4zcd7lhgH4CYlmxazd97LuFwO/Bnenbo6H5Glq4Dj42XAUKMyA
 b5Kt1s9KGwNDrW1dOrjPY7UU0bxzen5ttD6N/B6LyPM1GBHjCWxztQwzaBFxAE1garKx vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38srkp9nj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 11:44:36 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QFZXsi094790;
        Wed, 26 May 2021 11:44:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38srkp9nhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 11:44:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QFiHNg001697;
        Wed, 26 May 2021 15:44:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 38sba2rg58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 15:44:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QFi1ZI29688228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 15:44:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87265AE053;
        Wed, 26 May 2021 15:44:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2454CAE04D;
        Wed, 26 May 2021 15:44:30 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.7.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 15:44:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com, kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v1 1/1] KVM: s390: fix for hugepage vmalloc
Date:   Wed, 26 May 2021 17:44:29 +0200
Message-Id: <20210526154429.143591-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MJjluDSso3oXTUoBxpyzjk1MTgcwPizj
X-Proofpoint-GUID: 1VrA7vWxPEal-QxMAb_xzuAx8G63x9bm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_10:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=987 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 clxscore=1015 phishscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Create Secure Configuration Ultravisor Call does not support using
large pages for the virtual memory area.

This patch replaces the vzalloc call with a longer but equivalent
__vmalloc_node_range call, also setting the VM_NO_HUGE_VMAP flag, to
guarantee that this allocation will not be performed with large pages.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 813b6e93dc83..2c848606d7b9 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -140,7 +140,10 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	/* Allocate variable storage */
 	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
 	vlen += uv_info.guest_virt_base_stor_len;
-	kvm->arch.pv.stor_var = vzalloc(vlen);
+	kvm->arch.pv.stor_var = __vmalloc_node_range(vlen, PAGE_SIZE, VMALLOC_START, VMALLOC_END,
+						GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL,
+						VM_NO_HUGE_VMAP, NUMA_NO_NODE,
+						__builtin_return_address(0));
 	if (!kvm->arch.pv.stor_var)
 		goto out_err;
 	return 0;
-- 
2.31.1

