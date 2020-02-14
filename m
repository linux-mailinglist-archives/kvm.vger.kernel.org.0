Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8EA15F97F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgBNW1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:27:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728081AbgBNW1e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:34 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMNZJT093827;
        Fri, 14 Feb 2020 17:27:33 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j88908d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:33 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMNlWH094334;
        Fri, 14 Feb 2020 17:27:33 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j889088-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:33 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP4r4007185;
        Fri, 14 Feb 2020 22:27:32 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 2y5bc0cdss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:32 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMRSgS27394332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:28 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 325CC136091;
        Fri, 14 Feb 2020 22:27:28 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6976D136098;
        Fri, 14 Feb 2020 22:27:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:27 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v2 29/42] KVM: s390: protvirt: Add diag 308 subcode 8 - 10 handling
Date:   Fri, 14 Feb 2020 17:26:45 -0500
Message-Id: <20200214222658.12946-30-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

If the host initialized the Ultravisor, we can set stfle bit 161
(protected virtual IPL enhancements facility), which indicates that
the IPL subcodes 8, 9, and 10 are valid. These subcodes are used by a
normal guest to set/retrieve an IPL information block of type 5 (for
protected virtual machines) and transition into protected mode.

Once in protected mode, the Ultravisor will conceal the facility bit.
Therefore each boot into protected mode has to go through
non-protected mode. There is no secure re-ipl with subcode 10 without
a previous subcode 3.

In protected mode, there is no subcode 4 available, as the VM has no
more access to its memory from non-protected mode. I.e., only a IPL
clear is possible.

The error cases will all be handled in userspace.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4a97d3b7840e..f96c1f530cc2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2621,6 +2621,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (css_general_characteristics.aiv && test_facility(65))
 		set_kvm_facility(kvm->arch.model.fac_mask, 65);
 
+	if (is_prot_virt_host()) {
+		set_kvm_facility(kvm->arch.model.fac_mask, 161);
+		set_kvm_facility(kvm->arch.model.fac_list, 161);
+	}
+
 	kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
 	kvm->arch.model.ibc = sclp.ibc & 0x0fff;
 
-- 
2.25.0

