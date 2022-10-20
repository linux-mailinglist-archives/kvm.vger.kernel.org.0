Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ECE606324
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJTOdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiJTOdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:33:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A27515DB3E;
        Thu, 20 Oct 2022 07:33:33 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KEGkje003824;
        Thu, 20 Oct 2022 14:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6y3grxiCUqjZW1P2xC3g5gcir4KiPgH14Zi0nk3whs4=;
 b=hHJwzqlqSr+d+mcl0G60s32M3UBBIQ2x45gyfwQ6LsOaGsezbLdGba4T7xR3hVu8kC48
 d/41Ja0kSCsBIo8bD/eIZA9tZTejXbqNudiKtXJIE4AVsWqVz8QdnXEc+oCG8JVazxnY
 91bZQdb89sjnQFPR+nlU6Zd7bowPWV0umWHlvstQhEAwr3+CWrDBBPi5Ynltgpy+/A5E
 QHdYVOZ9SUlR3BmWTzvpbruMDNQDYpDQqCfEQP9HslO8F8HXhRDDm9cbyjJOhyZ2p5jm
 bpCVAyNwqrk5tJnKIYtIvF9rv9Qn0xFtBDYTxBEGUmltpq6yE2XsZ2npjtZP8DNCE5pR Cg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb7xr8h1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:33:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KELGfN010193;
        Thu, 20 Oct 2022 14:32:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg993pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KEW1sf2097778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 14:32:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A433AE045;
        Thu, 20 Oct 2022 14:32:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FF9AAE04D;
        Thu, 20 Oct 2022 14:32:01 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 14:32:01 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [v1 4/5] KVM: s390: sida: sort out physical vs virtual pointers usage
Date:   Thu, 20 Oct 2022 16:31:58 +0200
Message-Id: <20221020143159.294605-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020143159.294605-1-nrb@linux.ibm.com>
References: <20221020143159.294605-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KHRJLPzsJnxP2_URPlx82Y5d0rlpHSMe
X-Proofpoint-GUID: KHRJLPzsJnxP2_URPlx82Y5d0rlpHSMe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 suspectscore=0
 bulkscore=0 phishscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All callers of the sida_origin() macro actually expected a virtual
address, so rename it to sida_addr() and hand out a virtual address.

At some places, the macro wasn't used, potentially creating problems
if the sida size ever becomes nonzero (not currently the case), so let's
start using it everywhere now while at it.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.37.3

