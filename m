Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D1B584D5C
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbiG2I20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbiG2I2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:28:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6295683209
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 01:27:21 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T8H0sb030704
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qQijznDGfkSwnh8BvUM2SBUHsNAt/IG3vM1t6VmAELI=;
 b=VfceDylOEFq6ILLsLkYic0Ssm9XZpED/ccMAHA39HDhEN8ARD6IyG6GzOI4+C+GW85nk
 NRlbwQaMQRJKqigXrYQ4eroPNngTZi9fhBWCpjctqEnIeT3lfO8YqhGZT2+cTzoSoQBJ
 Tf4UI4RxOCAJlDKcG4btMjeHf4kYQNuZiXad/nuJNmaIDFQ5C/A3c1osOZWFOGeXZhpg
 6YffSS8ven5dIFo2VD51SBt2HGjUIzjJsoDbNxLB9Hb6qvb5hcxGs6DBW3zboS4HSYoh
 DJ6z/u86z1GjRX6aKle9KVhK1gWsAsJYCnmJ2EZWxoIc8b50yoLSoqdULupYA9V2y966 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbw9g849-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:20 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26T8Isft011945
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbw9g83f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26T8LYwE009756;
        Fri, 29 Jul 2022 08:27:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hg97tfaxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26T8RTmF26804734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 08:27:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3BA952050;
        Fri, 29 Jul 2022 08:27:14 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 40E315204E;
        Fri, 29 Jul 2022 08:27:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 5/6] lib: s390x: Use a new asce for each PV guest
Date:   Fri, 29 Jul 2022 08:26:32 +0000
Message-Id: <20220729082633.277240-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729082633.277240-1-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fcRieiiXdWCJVUzNTIjUjwzD5Y4gvVwA
X-Proofpoint-ORIG-GUID: vKAQm02RdoX_56ij7B73fghue9T7bmqQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207290032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every PV guest needs its own ASCE so let's copy the topmost table
designated by CR1 to create a new ASCE for the PV guest. Before and
after SIE we now need to switch ASCEs to and from the PV guest / test
ASCE. The SIE assembly function does that automatically.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm-offsets.c |  2 ++
 lib/s390x/sie.c         |  2 ++
 lib/s390x/sie.h         |  2 ++
 lib/s390x/uv.c          | 35 +++++++++++++++++++++++++++++++++--
 lib/s390x/uv.h          |  5 ++---
 s390x/cpu.S             |  6 ++++++
 6 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index fbea3278..f612f327 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -75,9 +75,11 @@ int main(void)
 	OFFSET(SIE_SAVEAREA_HOST_GRS, vm_save_area, host.grs[0]);
 	OFFSET(SIE_SAVEAREA_HOST_FPRS, vm_save_area, host.fprs[0]);
 	OFFSET(SIE_SAVEAREA_HOST_FPC, vm_save_area, host.fpc);
+	OFFSET(SIE_SAVEAREA_HOST_ASCE, vm_save_area, host.asce);
 	OFFSET(SIE_SAVEAREA_GUEST_GRS, vm_save_area, guest.grs[0]);
 	OFFSET(SIE_SAVEAREA_GUEST_FPRS, vm_save_area, guest.fprs[0]);
 	OFFSET(SIE_SAVEAREA_GUEST_FPC, vm_save_area, guest.fpc);
+	OFFSET(SIE_SAVEAREA_GUEST_ASCE, vm_save_area, guest.asce);
 	OFFSET(STACK_FRAME_INT_BACKCHAIN, stack_frame_int, back_chain);
 	OFFSET(STACK_FRAME_INT_FPC, stack_frame_int, fpc);
 	OFFSET(STACK_FRAME_INT_FPRS, stack_frame_int, fprs);
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index c3a53ad6..5ba669f1 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -84,6 +84,8 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 
 	/* Guest memory chunks are always 1MB */
 	assert(!(guest_mem_len & ~HPAGE_MASK));
+	/* For non-PV guests we re-use the host's ASCE for ease of use */
+	vm->save_area.guest.asce = stctg(1);
 	/* Currently MSO/MSL is the easiest option */
 	vm->sblk->mso = (uint64_t)guest_mem;
 	vm->sblk->msl = (uint64_t)guest_mem + ((guest_mem_len - 1) & HPAGE_MASK);
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 320c4218..3e3605c9 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -205,12 +205,14 @@ union {
 struct vm_uv {
 	uint64_t vm_handle;
 	uint64_t vcpu_handle;
+	uint64_t asce;
 	void *conf_base_stor;
 	void *conf_var_stor;
 	void *cpu_stor;
 };
 
 struct vm_save_regs {
+	uint64_t asce;
 	uint64_t grs[16];
 	uint64_t fprs[16];
 	uint32_t fpc;
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 3b4cafa9..99775929 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -76,7 +76,8 @@ void uv_init(void)
 	int cc;
 
 	/* Let's not do this twice */
-	assert(!initialized);
+	if (initialized)
+		return;
 	/* Query is done on initialization but let's check anyway */
 	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 
@@ -90,6 +91,25 @@ void uv_init(void)
 	initialized = true;
 }
 
+/*
+ * Create a new ASCE for the UV config because they can't be shared
+ * for security reasons. We just simply copy the top most table into a
+ * fresh set of allocated pages and use those pages as the asce.
+ */
+static uint64_t create_asce(void)
+{
+	void *pgd_new, *pgd_old;
+	uint64_t asce = stctg(1);
+
+	pgd_new = memalign_pages_flags(PAGE_SIZE, PAGE_SIZE * 4, 0);
+	pgd_old = (void *)(asce & PAGE_MASK);
+
+	memcpy(pgd_new, pgd_old, PAGE_SIZE * 4);
+
+	asce = __pa(pgd_new) | ASCE_DT_REGION1 | REGION_TABLE_LENGTH | ASCE_P;
+	return asce;
+}
+
 void uv_create_guest(struct vm *vm)
 {
 	struct uv_cb_cgc uvcb_cgc = {
@@ -125,7 +145,8 @@ void uv_create_guest(struct vm *vm)
 	vm->uv.cpu_stor = memalign_pages_flags(PAGE_SIZE, uvcb_qui.cpu_stor_len, 0);
 	uvcb_csc.stor_origin = (uint64_t)vm->uv.cpu_stor;
 
-	uvcb_cgc.guest_asce = (uint64_t)stctg(1);
+	uvcb_cgc.guest_asce = create_asce();
+	vm->save_area.guest.asce = uvcb_cgc.guest_asce;
 	uvcb_cgc.guest_sca = (uint64_t)vm->sca;
 
 	cc = uv_call(0, (uint64_t)&uvcb_cgc);
@@ -166,6 +187,16 @@ void uv_destroy_guest(struct vm *vm)
 	assert(cc == 0);
 	free_pages(vm->uv.conf_base_stor);
 	free_pages(vm->uv.conf_var_stor);
+
+	free_pages((void *)(vm->uv.asce & PAGE_MASK));
+	memset(&vm->uv, 0, sizeof(vm->uv));
+
+	/* Convert the sblk back to non-PV */
+	vm->save_area.guest.asce = stctg(1);
+	vm->sblk->sdf = 0;
+	vm->sblk->sidad = 0;
+	vm->sblk->pv_handle_cpu = 0;
+	vm->sblk->pv_handle_config = 0;
 }
 
 int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 44264861..5fe29bda 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -28,9 +28,8 @@ static inline void uv_setup_asces(void)
 	/* We need to have a valid primary ASCE to run guests. */
 	setup_vm();
 
-	/* Set P bit in ASCE as it is required for PV guests */
-	asce = stctg(1) | ASCE_P;
-	lctlg(1, asce);
+	/* Grab the ASCE which setup_vm() just set up */
+	asce = stctg(1);
 
 	/* Copy ASCE into home space CR */
 	lctlg(13, asce);
diff --git a/s390x/cpu.S b/s390x/cpu.S
index 82b5e25d..45bd551a 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu.S
@@ -76,6 +76,9 @@ sie64a:
 	.endr
 	stfpc	SIE_SAVEAREA_HOST_FPC(%r3)
 
+	stctg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r3)
+	lctlg	%c1, %c1, SIE_SAVEAREA_GUEST_ASCE(%r3)
+
 	# Store scb and save_area pointer into stack frame
 	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
 	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
@@ -102,6 +105,9 @@ sie_exit:
 	# Load guest register save area
 	lg	%r14,__SF_SIE_SAVEAREA(%r15)
 
+	# Restore the host asce
+	lctlg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r14)
+
 	# Store guest's gprs, fprs and fpc
 	stmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r14)	# save guest gprs 0-13
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-- 
2.34.1

