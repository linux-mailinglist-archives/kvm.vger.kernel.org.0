Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221BB15F978
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgBNW1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:27:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727957AbgBNW13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:29 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMOcQh035853;
        Fri, 14 Feb 2020 17:27:27 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y3wxvyprx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:27 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMQCCM038707;
        Fri, 14 Feb 2020 17:27:27 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y3wxvyprn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:27 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP5iO003828;
        Fri, 14 Feb 2020 22:27:26 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 2y5bc09x95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:26 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMRNtU36831576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:23 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBD15136097;
        Fri, 14 Feb 2020 22:27:22 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EC8B136093;
        Fri, 14 Feb 2020 22:27:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:22 +0000 (GMT)
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
Subject: [PATCH v2 23/42] KVM: s390: protvirt: Write sthyi data to instruction data area
Date:   Fri, 14 Feb 2020 17:26:39 -0500
Message-Id: <20200214222658.12946-24-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=2 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

STHYI data has to go through the bounce buffer.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/intercept.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 1e231058e4b3..cfabeecbb777 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -392,7 +392,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	if (addr & ~PAGE_MASK)
+	if (!kvm_s390_pv_is_protected(vcpu->kvm) && (addr & ~PAGE_MASK))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	sctns = (void *)get_zeroed_page(GFP_KERNEL);
@@ -403,10 +403,15 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 
 out:
 	if (!cc) {
-		r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
-		if (r) {
-			free_page((unsigned long)sctns);
-			return kvm_s390_inject_prog_cond(vcpu, r);
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			memcpy((void *)(sida_origin(vcpu->arch.sie_block)),
+			       sctns, PAGE_SIZE);
+		} else {
+			r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
+			if (r) {
+				free_page((unsigned long)sctns);
+				return kvm_s390_inject_prog_cond(vcpu, r);
+			}
 		}
 	}
 
-- 
2.25.0

