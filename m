Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F409D27AF
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 13:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfJJLF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 07:05:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbfJJLF0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Oct 2019 07:05:26 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9AACcme044849
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 07:05:24 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vj2pmsk0e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 07:05:24 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 10 Oct 2019 12:05:22 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 10 Oct 2019 12:05:20 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9AB5JoA43188284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 11:05:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32597AE056;
        Thu, 10 Oct 2019 11:05:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E2C0AE04D;
        Thu, 10 Oct 2019 11:05:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Oct 2019 11:05:19 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C6CEEE0248; Thu, 10 Oct 2019 13:05:18 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 1/2] KVM: s390: count invalid yields
Date:   Thu, 10 Oct 2019 13:05:17 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010110518.129256-1-borntraeger@de.ibm.com>
References: <20191010110518.129256-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101011-0016-0000-0000-000002B6D483
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101011-0017-0000-0000-00003317E06E
Message-Id: <20191010110518.129256-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910100084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To analyze some performance issues with lock contention and scheduling
it is nice to know when diag9c did not result in any action or when
no action was tried.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/diag.c             | 18 ++++++++++++++----
 arch/s390/kvm/kvm-s390.c         |  1 +
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index abe60268335d..02f4c21c57f6 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -392,6 +392,7 @@ struct kvm_vcpu_stat {
 	u64 diagnose_10;
 	u64 diagnose_44;
 	u64 diagnose_9c;
+	u64 diagnose_9c_ignored;
 	u64 diagnose_258;
 	u64 diagnose_308;
 	u64 diagnose_500;
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 45634b3d2e0a..609c55df3ce8 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -158,14 +158,24 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 
 	tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
 	vcpu->stat.diagnose_9c++;
-	VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d", tid);
 
+	/* yield to self */
 	if (tid == vcpu->vcpu_id)
-		return 0;
+		goto no_yield;
 
+	/* yield to invalid */
 	tcpu = kvm_get_vcpu_by_id(vcpu->kvm, tid);
-	if (tcpu)
-		kvm_vcpu_yield_to(tcpu);
+	if (!tcpu)
+		goto no_yield;
+
+	if (kvm_vcpu_yield_to(tcpu) <= 0)
+		goto no_yield;
+
+	VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d: done", tid);
+	return 0;
+no_yield:
+	VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d: ignored", tid);
+	vcpu->stat.diagnose_9c_ignored++;
 	return 0;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4a3bc40ca1a4..d9e6bf3d54f0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -155,6 +155,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "instruction_diag_10", VCPU_STAT(diagnose_10) },
 	{ "instruction_diag_44", VCPU_STAT(diagnose_44) },
 	{ "instruction_diag_9c", VCPU_STAT(diagnose_9c) },
+	{ "diag_9c_ignored", VCPU_STAT(diagnose_9c_ignored) },
 	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
 	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
 	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
-- 
2.21.0

