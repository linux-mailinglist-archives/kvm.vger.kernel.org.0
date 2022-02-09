Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EEF4AF7B9
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiBIRFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237882AbiBIREj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D0CC050CD9;
        Wed,  9 Feb 2022 09:04:35 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219F3Rdl024574;
        Wed, 9 Feb 2022 17:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mMp4sTsYF7z5vurtuPHIe7DsUWryBjGdDwwwsJITJrA=;
 b=I5CBJXO0xkogdvN8KbJiHbyiikOQVeqGvxhGXjz8ajKqrmwQJ2JQBqMkMIU/m+XUovjY
 PDMxoDrIX7xmgZIixxp/wF2mr7lMr+oYO4OeqQ85OUJsnV7GC08VQf9VKkGnnzNn5L4U
 3RZwYMGugmXR+9czCcd6KlrJGwsKcl4XxFW1whL19mBp4MxW7/8w0v1Z8ROM7/W9b83P
 yT/Rrpt5Zik+cMUD2FE/dNvHQb+Fhw+gfKFjYtrT4FD9ikxZCmpnqdowVB529Dy3DNTE
 YhzxA9HIhvBHaV/zPgIegUo/CQE25mUdR49G0QRX+FbuDwT1qO8eGUA4c/tcVrZ76vUR Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4fww2vax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:33 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219GUEoe026885;
        Wed, 9 Feb 2022 17:04:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4fww2vag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219H23f4011921;
        Wed, 9 Feb 2022 17:04:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv9rxw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219H4Sca45089158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 17:04:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF261A405F;
        Wed,  9 Feb 2022 17:04:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69936A4060;
        Wed,  9 Feb 2022 17:04:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 17:04:27 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v3 07/10] KVM: s390: Rename existing vcpu memop functions
Date:   Wed,  9 Feb 2022 18:04:19 +0100
Message-Id: <20220209170422.1910690-8-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220209170422.1910690-1-scgl@linux.ibm.com>
References: <20220209170422.1910690-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J8hpTPss4HIeTUUts_lREaNf-e4GUnX2
X-Proofpoint-GUID: dXV-CGxTmeCDoNHqn81gF9nmhEhx1amt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_09,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Makes the naming consistent, now that we also have a vm ioctl.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7ee3d2e8ecf2..eb034f2398ef 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4740,8 +4740,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
-				   struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_sida_op(struct kvm_vcpu *vcpu,
+				  struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	int r = 0;
@@ -4768,8 +4768,9 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
 	}
 	return r;
 }
-static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
-				  struct kvm_s390_mem_op *mop)
+
+static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
+				 struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void *tmpbuf = NULL;
@@ -4830,8 +4831,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
-				      struct kvm_s390_mem_op *mop)
+static long kvm_s390_vcpu_memsida_op(struct kvm_vcpu *vcpu,
+				     struct kvm_s390_mem_op *mop)
 {
 	int r, srcu_idx;
 
@@ -4840,12 +4841,12 @@ static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
-		r = kvm_s390_guest_mem_op(vcpu, mop);
+		r = kvm_s390_vcpu_mem_op(vcpu, mop);
 		break;
 	case KVM_S390_MEMOP_SIDA_READ:
 	case KVM_S390_MEMOP_SIDA_WRITE:
 		/* we are locked against sida going away by the vcpu->mutex */
-		r = kvm_s390_guest_sida_op(vcpu, mop);
+		r = kvm_s390_vcpu_sida_op(vcpu, mop);
 		break;
 	default:
 		r = -EINVAL;
@@ -5008,7 +5009,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_s390_mem_op mem_op;
 
 		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
-			r = kvm_s390_guest_memsida_op(vcpu, &mem_op);
+			r = kvm_s390_vcpu_memsida_op(vcpu, &mem_op);
 		else
 			r = -EFAULT;
 		break;
-- 
2.32.0

