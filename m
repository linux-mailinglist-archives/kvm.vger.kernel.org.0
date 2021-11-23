Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446C145A080
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhKWKn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234772AbhKWKn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:26 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAMI0d013468;
        Tue, 23 Nov 2021 10:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pB9DbaxzbgZxcl3b2gcZ6Kmn9K459BmDgSefi48nYbM=;
 b=I8H/9DTVmLhVOhUbIDmToe8hmTG5vDmUR6qu9oIT7aJ5ieiMI0oippD7g/BR3SxEUvWa
 iSqzJgQ0g3MgHOyktAST+QEKlIhKc/xQOdHLhnnXzdaCwun4T9jNDonqeg9IdD+90+GN
 PiU5b8TUFnGod2Ydj6rHqbmUn0HsnKJheCLIAJ2CHTkB9O0KGvNfTB1XIyoE3A8rCodU
 TkVdcRiD5lSlFnz4vEorI2Z4s6vaSUcicIvn/G0zw/r+2IJt88wq3DMf6HwMNCxp3EZy
 X9X1BMigYbWQkHMSdpczWCNbYMFDbxlWNeKAc1GRfUgfRx5sPzSFnXHryYfozxqrab+H LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgxg308sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:17 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANAYmTE016781;
        Tue, 23 Nov 2021 10:40:17 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgxg308ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:17 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAcHxb007142;
        Tue, 23 Nov 2021 10:40:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3cern9nkn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAX3ow61735396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:33:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9827FA405E;
        Tue, 23 Nov 2021 10:40:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C4BAA406E;
        Tue, 23 Nov 2021 10:40:10 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/8] s390x: lib: Extend UV library with PV guest management
Date:   Tue, 23 Nov 2021 10:39:53 +0000
Message-Id: <20211123103956.2170-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123103956.2170-1-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BZpc3EC6Uz5WtO8Fg1Ax9aDg2ukjFviG
X-Proofpoint-ORIG-GUID: jCMWIGJizaGUV4UQPuVvntI-FQXTe8kt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's extend the UV lib with guest 1 code to be able to manage
protected VMs in the future.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h |  14 +++++
 lib/s390x/sie.h    |   3 ++
 lib/s390x/uv.c     | 128 +++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/uv.h     |   7 +++
 4 files changed, 152 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 6e331211..97c90e81 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -355,4 +355,18 @@ static inline int uv_set_se_hdr(uint64_t handle, void *hdr, size_t len)
 	return uv_call(0, (uint64_t)&uvcb);
 }
 
+static inline int uv_unp_page(uint64_t handle, uint64_t gaddr, uint64_t tweak1, uint64_t tweak2)
+{
+	struct uv_cb_unp uvcb = {
+		.header.cmd = UVC_CMD_UNPACK_IMG,
+		.header.len = sizeof(uvcb),
+		.guest_handle = handle,
+		.gaddr = gaddr,
+		.tweak[0] = tweak1,
+		.tweak[1] = tweak2,
+	};
+
+	return uv_call(0, (uint64_t)&uvcb);
+}
+
 #endif
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 1a12faa7..6d209793 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -203,6 +203,9 @@ union {
 struct vm_uv {
 	uint64_t vm_handle;
 	uint64_t vcpu_handle;
+	void *conf_base_stor;
+	void *conf_var_stor;
+	void *cpu_stor;
 };
 
 struct vm_save_regs {
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index c5c69c47..6fe11dff 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -17,11 +17,14 @@
 #include <asm/facility.h>
 #include <asm/uv.h>
 #include <uv.h>
+#include <sie.h>
 
 static struct uv_cb_qui uvcb_qui = {
 	.header.cmd = UVC_CMD_QUI,
 	.header.len = sizeof(uvcb_qui),
 };
+static uint64_t uv_init_mem;
+
 
 bool uv_os_is_guest(void)
 {
@@ -54,3 +57,128 @@ int uv_setup(void)
 	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 	return 1;
 }
+
+void uv_init(void)
+{
+	struct uv_cb_init uvcb_init = {
+		.header.len = sizeof(uvcb_init),
+		.header.cmd = UVC_CMD_INIT_UV,
+	};
+	static bool initialized;
+	int cc;
+
+	/* Let's not do this twice */
+	assert(!initialized);
+	/* Query is done on initialization but let's check anyway */
+	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
+
+	/* Donated storage needs to be over 2GB aligned to 1MB */
+	uv_init_mem = (uint64_t)memalign_pages_flags(HPAGE_SIZE, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
+	uvcb_init.stor_origin = uv_init_mem;
+	uvcb_init.stor_len = uvcb_qui.uv_base_stor_len;
+
+	cc = uv_call(0, (uint64_t)&uvcb_init);
+	assert(cc == 0);
+	initialized = true;
+}
+
+void uv_create_guest(struct vm *vm)
+{
+	struct uv_cb_cgc uvcb_cgc = {
+		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
+		.header.len = sizeof(uvcb_cgc),
+	};
+	struct uv_cb_csc uvcb_csc = {
+		.header.len = sizeof(uvcb_csc),
+		.header.cmd = UVC_CMD_CREATE_SEC_CPU,
+		.state_origin = (uint64_t)vm->sblk,
+		.num = 0,
+	};
+	unsigned long vsize;
+	int cc;
+
+	uvcb_cgc.guest_stor_origin = vm->sblk->mso;
+	uvcb_cgc.guest_stor_len = vm->sblk->msl;
+
+	/* Config allocation */
+	vsize = uvcb_qui.conf_base_virt_stor_len +
+		((uvcb_cgc.guest_stor_len / HPAGE_SIZE) * uvcb_qui.conf_virt_var_stor_len);
+
+	vm->uv.conf_base_stor = memalign_pages_flags(PAGE_SIZE * 4, uvcb_qui.conf_base_phys_stor_len, 0);
+	/*
+	 * This allocation needs to be below the max guest storage
+	 * address so let's simply put it into the physical memory
+	 */
+	vm->uv.conf_var_stor = memalign_pages_flags(PAGE_SIZE, vsize,0);
+	uvcb_cgc.conf_base_stor_origin = (uint64_t)vm->uv.conf_base_stor;
+	uvcb_cgc.conf_var_stor_origin = (uint64_t)vm->uv.conf_var_stor;
+
+	/* CPU allocation */
+	vm->uv.cpu_stor = memalign_pages_flags(PAGE_SIZE, uvcb_qui.cpu_stor_len, 0);
+	uvcb_csc.stor_origin = (uint64_t)vm->uv.cpu_stor;
+
+	uvcb_cgc.guest_asce = (uint64_t)stctg(1);
+	uvcb_cgc.guest_sca = (uint64_t)vm->sca;
+
+	cc = uv_call(0, (uint64_t)&uvcb_cgc);
+	assert(!cc);
+
+	vm->uv.vm_handle = uvcb_cgc.guest_handle;
+	uvcb_csc.guest_handle = uvcb_cgc.guest_handle;
+	cc = uv_call(0, (uint64_t)&uvcb_csc);
+	vm->uv.vcpu_handle = uvcb_csc.cpu_handle;
+	assert(!cc);
+
+	/*
+	 * Convert guest to format 4:
+	 *
+	 *  - Set format 4
+	 *  - Write UV handles into sblk
+	 *  - Allocate and set SIDA
+	 */
+	vm->sblk->sdf = 2;
+	vm->sblk->sidad = (uint64_t)alloc_page();
+	vm->sblk->pv_handle_cpu = uvcb_csc.cpu_handle;
+	vm->sblk->pv_handle_config = uvcb_cgc.guest_handle;
+}
+
+void uv_destroy_guest(struct vm *vm)
+{
+	int cc;
+	u16 rc, rrc;
+
+	cc = uv_cmd_nodata(vm->sblk->pv_handle_cpu,
+			   UVC_CMD_DESTROY_SEC_CPU, &rc, &rrc);
+	assert(cc == 0);
+	free_page((void *)vm->sblk->sidad);
+	free_pages(vm->uv.cpu_stor);
+
+	cc = uv_cmd_nodata(vm->sblk->pv_handle_config,
+			   UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
+	assert(cc == 0);
+	free_pages(vm->uv.conf_base_stor);
+	free_pages(vm->uv.conf_var_stor);
+}
+
+int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)
+{
+	int i, cc;
+
+	for (i = 0; i < len / PAGE_SIZE; i++) {
+		cc = uv_unp_page(vm->uv.vm_handle, addr, tweak, i * PAGE_SIZE);
+		assert(!cc);
+		addr += PAGE_SIZE;
+	}
+	return cc;
+}
+
+void uv_verify_load(struct vm *vm)
+{
+	uint16_t rc, rrc;
+	int cc;
+
+	cc = uv_cmd_nodata(vm->uv.vm_handle, UVC_CMD_VERIFY_IMG, &rc, &rrc);
+	assert(!cc);
+	cc = uv_set_cpu_state(vm->uv.vcpu_handle, PV_CPU_STATE_OPR_LOAD);
+	assert(!cc);
+}
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 2b23407a..6ffe537a 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -2,9 +2,16 @@
 #ifndef _S390X_UV_H_
 #define _S390X_UV_H_
 
+#include <sie.h>
+
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
 bool uv_query_test_call(unsigned int nr);
+void uv_init(void);
 int uv_setup(void);
+void uv_create_guest(struct vm *vm);
+void uv_destroy_guest(struct vm *vm);
+int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak);
+void uv_verify_load(struct vm *vm);
 
 #endif /* UV_H */
-- 
2.32.0

