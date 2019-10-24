Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15642E30D1
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407218AbfJXLm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409247AbfJXLm0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:26 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBb7qu007220
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:24 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vuags232k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:24 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:22 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:18 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBfirD19005868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:41:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EB875205A;
        Thu, 24 Oct 2019 11:42:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9D7EB52051;
        Thu, 24 Oct 2019 11:42:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 19/37] KVM: s390: protvirt: Add new gprs location handling
Date:   Thu, 24 Oct 2019 07:40:41 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-4275-0000-0000-00000376D3D6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-4276-0000-0000-00003889FDDB
Message-Id: <20191024114059.102802-20-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=542 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest registers for protected guests are stored at offset 0x380.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 +++-
 arch/s390/kvm/kvm-s390.c         | 11 +++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 0ab309b7bf4c..5deabf9734d9 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -336,7 +336,9 @@ struct kvm_s390_itdb {
 struct sie_page {
 	struct kvm_s390_sie_block sie_block;
 	struct mcck_volatile_info mcck_info;	/* 0x0200 */
-	__u8 reserved218[1000];		/* 0x0218 */
+	__u8 reserved218[360];		/* 0x0218 */
+	__u64 pv_grregs[16];		/* 0x380 */
+	__u8 reserved400[512];
 	struct kvm_s390_itdb itdb;	/* 0x0600 */
 	__u8 reserved700[2304];		/* 0x0700 */
 };
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 490fde080107..97d3a81e5074 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3965,6 +3965,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int rc, exit_reason;
+	struct sie_page *sie_page = (struct sie_page *)vcpu->arch.sie_block;
 
 	/*
 	 * We try to hold kvm->srcu during most of vcpu_run (except when run-
@@ -3986,8 +3987,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		guest_enter_irqoff();
 		__disable_cpu_timer_accounting(vcpu);
 		local_irq_enable();
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			memcpy(sie_page->pv_grregs,
+			       vcpu->run->s.regs.gprs,
+			       sizeof(sie_page->pv_grregs));
+		}
 		exit_reason = sie64a(vcpu->arch.sie_block,
 				     vcpu->run->s.regs.gprs);
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			memcpy(vcpu->run->s.regs.gprs,
+			       sie_page->pv_grregs,
+			       sizeof(sie_page->pv_grregs));
+		}
 		local_irq_disable();
 		__enable_cpu_timer_accounting(vcpu);
 		guest_exit_irqoff();
-- 
2.20.1

