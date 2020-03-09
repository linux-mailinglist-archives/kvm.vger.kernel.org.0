Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72C317DBC5
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCIIwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:52:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726645AbgCIIvl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:41 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298pGVG004984
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:40 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym7t6dsbg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:40 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:38 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:34 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pXtc60162184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66FA6AE04D;
        Mon,  9 Mar 2020 08:51:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 552DFAE045;
        Mon,  9 Mar 2020 08:51:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 16D8AE0251; Mon,  9 Mar 2020 09:51:33 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 17/36] KVM: s390: protvirt: Add new gprs location handling
Date:   Mon,  9 Mar 2020 09:51:07 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-4275-0000-0000-000003A9B368
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-4276-0000-0000-000038BEC926
Message-Id: <20200309085126.3334302-18-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=762
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Guest registers for protected guests are stored at offset 0x380.  We
will copy those to the usual places.  Long term we could refactor this
or use register access functions.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 +++-
 arch/s390/kvm/kvm-s390.c         | 11 +++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index ba3364b37159..4fcbb055a565 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -343,7 +343,9 @@ struct kvm_s390_itdb {
 struct sie_page {
 	struct kvm_s390_sie_block sie_block;
 	struct mcck_volatile_info mcck_info;	/* 0x0200 */
-	__u8 reserved218[1000];		/* 0x0218 */
+	__u8 reserved218[360];		/* 0x0218 */
+	__u64 pv_grregs[16];		/* 0x0380 */
+	__u8 reserved400[512];		/* 0x0400 */
 	struct kvm_s390_itdb itdb;	/* 0x0600 */
 	__u8 reserved700[2304];		/* 0x0700 */
 };
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2881151fd773..bd62312fdc0e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4059,6 +4059,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int rc, exit_reason;
+	struct sie_page *sie_page = (struct sie_page *)vcpu->arch.sie_block;
 
 	/*
 	 * We try to hold kvm->srcu during most of vcpu_run (except when run-
@@ -4080,8 +4081,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		guest_enter_irqoff();
 		__disable_cpu_timer_accounting(vcpu);
 		local_irq_enable();
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+			memcpy(sie_page->pv_grregs,
+			       vcpu->run->s.regs.gprs,
+			       sizeof(sie_page->pv_grregs));
+		}
 		exit_reason = sie64a(vcpu->arch.sie_block,
 				     vcpu->run->s.regs.gprs);
+		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+			memcpy(vcpu->run->s.regs.gprs,
+			       sie_page->pv_grregs,
+			       sizeof(sie_page->pv_grregs));
+		}
 		local_irq_disable();
 		__enable_cpu_timer_accounting(vcpu);
 		guest_exit_irqoff();
-- 
2.24.1

