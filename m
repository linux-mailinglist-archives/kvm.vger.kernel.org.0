Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D746A638A66
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiKYMnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiKYMnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3381AD82;
        Fri, 25 Nov 2022 04:43:04 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APBRHCH018632;
        Fri, 25 Nov 2022 12:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=jTxOvWRO4mO3ns2X1EK74MAymT2WB/xYER8F33BhhPg=;
 b=q9NCMlCsnYh2hHpRzGbnJaZYPbAnUTNdkWSowFxrCIj3e/+UbPJ1IYRmcFCTyNxoE1YF
 Idma9eCiDDSt7ZNBs6/l/OLTsh4CikL8TBuonWN+NWwgkMH/6IjhLKCPFYcG2Id1EQgV
 NfILpMhuCuDaArmgtF8YIzqUuk1Toa86W2WcgHYvvCLKgTkxfSJXCOkM1EIXnyvOWXlF
 JzTa0SSjyUE9goM70aUV3wLxAnZ7rf1RBOSE8iu9w1PTYl5QKSq9ZieUl0rXVWE6zbQs
 1uJIMEYmHjmqvn/AFgKyQw/ezORRY+qSXmDRKkWmsHlI6d57Il8dnG7vcTUwdhJkQsFk ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2vum1jvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:03 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCRvmk029891;
        Fri, 25 Nov 2022 12:43:03 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2vum1jv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZeZW029941;
        Fri, 25 Nov 2022 12:43:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdj1mb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCgw0U55050644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:42:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A2834C044;
        Fri, 25 Nov 2022 12:42:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 988FF4C046;
        Fri, 25 Nov 2022 12:42:57 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:42:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 04/15] KVM: s390: sida: sort out physical vs virtual pointers usage
Date:   Fri, 25 Nov 2022 13:39:36 +0100
Message-Id: <20221125123947.31047-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U7va-nLMCgPfC70jdYdPWNgDSGX7bvpT
X-Proofpoint-GUID: vs7_YsFUTZWt164l9nQ0ak-dVcIlA0Kn
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

All callers of the sida_origin() macro actually expected a virtual
address, so rename it to sida_addr() and hand out a virtual address.

At some places, the macro wasn't used, potentially creating problems
if the sida size ever becomes nonzero (not currently the case), so let's
start using it everywhere now while at it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20221020143159.294605-5-nrb@linux.ibm.com
Message-Id: <20221020143159.294605-5-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 3 +--
 arch/s390/kvm/intercept.c        | 7 +++----
 arch/s390/kvm/kvm-s390.c         | 9 +++++----
 arch/s390/kvm/priv.c             | 3 +--
 arch/s390/kvm/pv.c               | 8 +++++---
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 931f97875899..21f1339a4197 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -142,8 +142,7 @@ struct mcck_volatile_info {
 			   CR14_EXTERNAL_DAMAGE_SUBMASK)
 
 #define SIDAD_SIZE_MASK		0xff
-#define sida_origin(sie_block) \
-	((sie_block)->sidad & PAGE_MASK)
+#define sida_addr(sie_block) phys_to_virt((sie_block)->sidad & PAGE_MASK)
 #define sida_size(sie_block) \
 	((((sie_block)->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
 
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index b703b5202f25..0ee02dae14b2 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -409,8 +409,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 out:
 	if (!cc) {
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
-			memcpy((void *)(sida_origin(vcpu->arch.sie_block)),
-			       sctns, PAGE_SIZE);
+			memcpy(sida_addr(vcpu->arch.sie_block), sctns, PAGE_SIZE);
 		} else {
 			r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
 			if (r) {
@@ -464,7 +463,7 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
 
 static int handle_pv_spx(struct kvm_vcpu *vcpu)
 {
-	u32 pref = *(u32 *)vcpu->arch.sie_block->sidad;
+	u32 pref = *(u32 *)sida_addr(vcpu->arch.sie_block);
 
 	kvm_s390_set_prefix(vcpu, pref);
 	trace_kvm_s390_handle_prefix(vcpu, 1, pref);
@@ -497,7 +496,7 @@ static int handle_pv_sclp(struct kvm_vcpu *vcpu)
 
 static int handle_pv_uvc(struct kvm_vcpu *vcpu)
 {
-	struct uv_cb_share *guest_uvcb = (void *)vcpu->arch.sie_block->sidad;
+	struct uv_cb_share *guest_uvcb = sida_addr(vcpu->arch.sie_block);
 	struct uv_cb_cts uvcb = {
 		.header.cmd	= UVC_CMD_UNPIN_PAGE_SHARED,
 		.header.len	= sizeof(uvcb),
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0f7ff0c9019f..bd6e0201bfe5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5167,6 +5167,7 @@ static long kvm_s390_vcpu_sida_op(struct kvm_vcpu *vcpu,
 				  struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	void *sida_addr;
 	int r = 0;
 
 	if (mop->flags || !mop->size)
@@ -5178,16 +5179,16 @@ static long kvm_s390_vcpu_sida_op(struct kvm_vcpu *vcpu,
 	if (!kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EINVAL;
 
+	sida_addr = (char *)sida_addr(vcpu->arch.sie_block) + mop->sida_offset;
+
 	switch (mop->op) {
 	case KVM_S390_MEMOP_SIDA_READ:
-		if (copy_to_user(uaddr, (void *)(sida_origin(vcpu->arch.sie_block) +
-				 mop->sida_offset), mop->size))
+		if (copy_to_user(uaddr, sida_addr, mop->size))
 			r = -EFAULT;
 
 		break;
 	case KVM_S390_MEMOP_SIDA_WRITE:
-		if (copy_from_user((void *)(sida_origin(vcpu->arch.sie_block) +
-				   mop->sida_offset), uaddr, mop->size))
+		if (copy_from_user(sida_addr, uaddr, mop->size))
 			r = -EFAULT;
 		break;
 	}
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 3335fa09b6f1..9f8a192bd750 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -924,8 +924,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 		return -EREMOTE;
 	}
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
-		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
-		       PAGE_SIZE);
+		memcpy(sida_addr(vcpu->arch.sie_block), (void *)mem, PAGE_SIZE);
 		rc = 0;
 	} else {
 		rc = write_guest(vcpu, operand2, ar, (void *)mem, PAGE_SIZE);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 7cb7799a0acb..c7435c37cdfe 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -44,7 +44,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 		free_pages(vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
 
-	free_page(sida_origin(vcpu->arch.sie_block));
+	free_page((unsigned long)sida_addr(vcpu->arch.sie_block));
 	vcpu->arch.sie_block->pv_handle_cpu = 0;
 	vcpu->arch.sie_block->pv_handle_config = 0;
 	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
@@ -66,6 +66,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 		.header.cmd = UVC_CMD_CREATE_SEC_CPU,
 		.header.len = sizeof(uvcb),
 	};
+	void *sida_addr;
 	int cc;
 
 	if (kvm_s390_pv_cpu_get_handle(vcpu))
@@ -83,12 +84,13 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
 
 	/* Alloc Secure Instruction Data Area Designation */
-	vcpu->arch.sie_block->sidad = __get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!vcpu->arch.sie_block->sidad) {
+	sida_addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!sida_addr) {
 		free_pages(vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
 		return -ENOMEM;
 	}
+	vcpu->arch.sie_block->sidad = virt_to_phys(sida_addr);
 
 	cc = uv_call(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
-- 
2.38.1

