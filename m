Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6716142724F
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 22:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbhJHUde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 16:33:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35016 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231997AbhJHUd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 16:33:27 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KRS93016081;
        Fri, 8 Oct 2021 16:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=n2+7wlHfRulREAtja+GTuv8/96rm57QhYif0ZXDg9fQ=;
 b=ayxSDbWYJr0kKYg3FALNzn3hl01+pC1ZRWP1iSGpVb/A4OAEtvOSNuqCzZ+V6diCvhuy
 ofQQit+GCZy6pL7UohQv1am6/XJ+RP5xPD3Q3gTei676xOit/0wfVmzV4xZjm11Ghn9K
 B5PzQFGr/sc6ffsIpNNOaF+whcvHsw+E+VwA1B1XQVtoDK19LAyQ+JMti3zh4dC25Gjf
 qyP51M2benfbhNPni6DvIMs8h+ZSFLsnvfTTD8iQMsyNgWFNg3hccgvcsYY9bSh2weMJ
 73xDJyYzt9rPHCMMUFe0TwFpVAUQa253tBVPI7z2n7TIZxcgt8KDAbE5fVXFZiAmt5Xs pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjvnj8kdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:31 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198KSaIG022766;
        Fri, 8 Oct 2021 16:31:31 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjvnj8kcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198KM6SP027430;
        Fri, 8 Oct 2021 20:31:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3bef2ahbv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 20:31:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 198KQ0m255443786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 20:26:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EF03A405E;
        Fri,  8 Oct 2021 20:31:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28A90A4069;
        Fri,  8 Oct 2021 20:31:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 Oct 2021 20:31:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 43AADE039C; Fri,  8 Oct 2021 22:31:24 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 5/6] KVM: s390: Give BUSY to SIGP SENSE during Restart
Date:   Fri,  8 Oct 2021 22:31:11 +0200
Message-Id: <20211008203112.1979843-6-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008203112.1979843-1-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7ShPxSm6rchvGz3mzSBlx_E1qSStGbep
X-Proofpoint-ORIG-GUID: W3ZYuLc1CJ8WD5pN3MkgvooYwwjkDKQF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_06,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A SIGP RESTART is a special animal, in that it directs the
destination CPU to perform the restart operation. This is
basically the loading of the Restart PSW and letting it take
over, but a stopped CPU must first be made operating for this
to work correctly.

As this can take a moment, let's leave a reminder that this
SIGP is being processed, such that the SIGP SENSE logic
(which is not handled in userspace) can return CC=2 instead
of CC=1 (and STOPPED) until the CPU is started.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/sigp.c             | 17 +++++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a604d51acfc8..536f174c5e81 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -746,6 +746,7 @@ struct kvm_vcpu_arch {
 	__u64 cputm_start;
 	bool gs_enabled;
 	bool skey_enabled;
+	bool sigp_restart;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
 };
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..33d71fa42d68 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4603,6 +4603,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 	}
 
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
+	vcpu->arch.sigp_restart = 0;
 	/*
 	 * The real PSW might have changed due to a RESTART interpreted by the
 	 * ultravisor. We block all interrupts and let the next sie exit
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index c64e37f4347d..5a21354d0265 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -27,6 +27,8 @@ static int __sigp_sense(struct kvm_vcpu *vcpu, struct kvm_vcpu *dst_vcpu,
 	ext_call_pending = kvm_s390_ext_call_pending(dst_vcpu);
 	if (!stopped && !ext_call_pending)
 		rc = SIGP_CC_ORDER_CODE_ACCEPTED;
+	else if (stopped && dst_vcpu->arch.sigp_restart)
+		rc = SIGP_CC_BUSY;
 	else {
 		*reg &= 0xffffffff00000000UL;
 		if (ext_call_pending)
@@ -385,6 +387,18 @@ static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
 	return 1;
 }
 
+static void handle_sigp_restart(struct kvm_vcpu *vcpu, u16 cpu_addr)
+{
+	struct kvm_vcpu *dst_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
+
+	/* Ignore SIGP Restart to non-existent CPUs */
+	if (!dst_vcpu)
+		return;
+
+	if (is_vcpu_stopped(dst_vcpu))
+		dst_vcpu->arch.sigp_restart = 1;
+}
+
 static int handle_sigp_order_is_blocked(struct kvm_vcpu *vcpu, u8 order_code,
 					u16 cpu_addr)
 {
@@ -443,6 +457,9 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 	if (handle_sigp_order_is_blocked(vcpu, order_code, cpu_addr))
 		return 0;
 
+	if (order_code == SIGP_RESTART)
+		handle_sigp_restart(vcpu, cpu_addr);
+
 	if (handle_sigp_order_in_user_space(vcpu, order_code, cpu_addr))
 		return -EOPNOTSUPP;
 
-- 
2.25.1

