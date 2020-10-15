Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66DF28F9D4
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392047AbgJOT7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 15:59:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392041AbgJOT7a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 15:59:30 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09FJWK4r052334
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 15:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kkZA4dQ2SEiNmikp1aBvQd4Bikkx2QW8nE+Gl0l+ZLA=;
 b=VNeybYh2VV7P/I5mi25AynS2Wel0Z3Xopo7ltO39sVtKq0rGthWsRe8iDbndTQSHjhfm
 sav36f+ACOdwKZtByTcfpWKtOextTkme731E3TV+HFwXPsAZtKrLRh7iec+GNcBiQVu1
 010eC6SqEdnESxasA4d0EXoaRF874wd0mr7hwRB7VU3dayrb5PvDmC9oNCXda3wOglVL
 vUEyAzrb44f4eizBY5KBxmvC4XNMOh/8Z6DIXwV9aCCsa4yBOFpE91+d3V4n1W3SWo+6
 GAh4zxmAx5j2ZDbN5TFi+UCNkzwJfIgN5vgfhpRR+DhUkBV+AYpt0S10qOZfNSZ+d1Va UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 346uj1tse5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 15:59:29 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09FJXqRj059888
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 15:59:29 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 346uj1tsdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 15:59:29 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09FJvuFQ028663;
        Thu, 15 Oct 2020 19:59:28 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3434ka7ehm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 19:59:28 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09FJxK3E42861036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 19:59:20 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88DC978060;
        Thu, 15 Oct 2020 19:59:27 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFB9E7805E;
        Thu, 15 Oct 2020 19:59:26 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.130.217])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 15 Oct 2020 19:59:26 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
Subject: [PATCH v2 1/2] s390/kvm: fix diag318 reset
Date:   Thu, 15 Oct 2020 15:59:12 -0400
Message-Id: <20201015195913.101065-2-walling@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201015195913.101065-1-walling@linux.ibm.com>
References: <20201015195913.101065-1-walling@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_15:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 clxscore=1015 mlxlogscore=999 suspectscore=13
 adultscore=0 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DIAGNOSE 0x0318 instruction must be reset on a normal and clear
reset. However, this was missed for the clear reset case.

Let's fix this by resetting the information during a normal reset. 
Since clear reset is a superset of normal reset, the info will
still reset on a clear reset.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..b0cf8367e261 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3516,6 +3516,7 @@ static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_RI;
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
 	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
+	vcpu->run->s.regs.diag318 = 0;
 
 	kvm_clear_async_pf_completion_queue(vcpu);
 	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
@@ -3582,7 +3583,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
 
 	regs->etoken = 0;
 	regs->etoken_extension = 0;
-	regs->diag318 = 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-- 
2.26.2

