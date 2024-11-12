Return-Path: <kvm+bounces-31637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D16E9C5D2D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C12A7282939
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A608D206063;
	Tue, 12 Nov 2024 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aJiUMJsS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2601A206072;
	Tue, 12 Nov 2024 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428780; cv=none; b=F4YtGfW61W2+jP/QRXlNx8garIJ1o7P3My44E+H2djpYMLLCPxZw8NjuN3OiSzvAuFHsAgtv+Ef/xB1GXFOSvfEPaSIMv2646To4G+gtpwbiQbftDGpRZqk6t9sDI1QgEXvj5YzlbPH2HF0rwxka62ip7GBe7EJB4FCED5wYZmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428780; c=relaxed/simple;
	bh=u6A7GPInXcbmvE3jD1+FplyiI3chLpxRs8bIrWlbt20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMJq3erDcHn1qJ7hlmJXCt6ikBydMV7oExGxbuZILAo7P/+EWgVty+6Gx8u7Cdsqdvh6q7YV5+CW/y2R3+PyGpySisLrcMTET+T8WKabQjbLhkOXflTdp6iD5vluxDqaQxSzoZvrT6BcoT79hJlnTs1SwlovOevPUg6uBq/Mcjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aJiUMJsS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACG7NIi029487;
	Tue, 12 Nov 2024 16:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kBOoVlNNw/x3Bj+x7
	h7gwYOwhyGS717i7luGDNG7RGY=; b=aJiUMJsSyZrmN2IgmerPeGjPIEBwAcUfb
	M/CMu4t+VmnSF89MxgXDASNlJ/LxIlMpel/niYGkxBSTbUtllVJ/gjbt8iRuZnbN
	fiB8UKi0PRX5uqal9pXe5EEVo6ZdCEFnzxIaSRKOxT8eUyiNu0UFlXNw03W2XU9t
	SCDQWcredMfxThi49t+62IOqATMiM6ADBnOZ5vuvJJX6d/oC6gPEB9lP9Fefx8G/
	eT51SqF0dKjbFWJflGpGBwBg5cfYfyo7JmpB7APhf9yN70sw7GVGqz6mexXACI0I
	pQRxtKiGL9mpDkjvWrda5Sj3LrNH3KLFFI/DDsRkOjuYcjMnT3oTQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9020g1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACErahs008392;
	Tue, 12 Nov 2024 16:26:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tjeyk9b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQ9cV37683636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A87320049;
	Tue, 12 Nov 2024 16:26:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD3FA2004B;
	Tue, 12 Nov 2024 16:26:08 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:08 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 06/14] KVM: s390: selftests: Add uc_map_unmap VM test case
Date: Tue, 12 Nov 2024 17:23:20 +0100
Message-ID: <20241112162536.144980-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fHe9xfC98aSUeDgZadH--9qxoPa7ZDxH
X-Proofpoint-GUID: fHe9xfC98aSUeDgZadH--9qxoPa7ZDxH
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=886 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120128

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Add a test case verifying basic running and interaction of ucontrol VMs.
Fill the segment and page tables for allocated memory and map memory on
first access.

* uc_map_unmap
  Store and load data to mapped and unmapped memory and use pic segment
  translation handling to map memory on access.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link:
https://lore.kernel.org/r/20241107141024.238916-2-schlameuss@linux.ibm.com
[frankja@linux.ibm.com: Fixed patch prefix]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241107141024.238916-2-schlameuss@linux.ibm.com>
---
 .../selftests/kvm/s390x/ucontrol_test.c       | 145 +++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index f257beec1430..3e649b12a0b9 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -16,7 +16,11 @@
 #include <linux/capability.h>
 #include <linux/sizes.h>
 
+#define PGM_SEGMENT_TRANSLATION 0x10
+
 #define VM_MEM_SIZE (4 * SZ_1M)
+#define VM_MEM_EXT_SIZE (2 * SZ_1M)
+#define VM_MEM_MAX_M ((VM_MEM_SIZE + VM_MEM_EXT_SIZE) / SZ_1M)
 
 /* so directly declare capget to check caps without libcap */
 int capget(cap_user_header_t header, cap_user_data_t data);
@@ -58,6 +62,23 @@ asm("test_gprs_asm:\n"
 	"	j	0b\n"
 );
 
+/* Test program manipulating memory */
+extern char test_mem_asm[];
+asm("test_mem_asm:\n"
+	"xgr	%r0, %r0\n"
+
+	"0:\n"
+	"	ahi	%r0,1\n"
+	"	st	%r1,0(%r5,%r6)\n"
+
+	"	xgr	%r1,%r1\n"
+	"	l	%r1,0(%r5,%r6)\n"
+	"	ahi	%r0,1\n"
+	"	diag	0,0,0x44\n"
+
+	"	j	0b\n"
+);
+
 FIXTURE(uc_kvm)
 {
 	struct kvm_s390_sie_block *sie_block;
@@ -67,6 +88,7 @@ FIXTURE(uc_kvm)
 	uintptr_t base_hva;
 	uintptr_t code_hva;
 	int kvm_run_size;
+	vm_paddr_t pgd;
 	void *vm_mem;
 	int vcpu_fd;
 	int kvm_fd;
@@ -116,7 +138,7 @@ FIXTURE_SETUP(uc_kvm)
 	self->base_gpa = 0;
 	self->code_gpa = self->base_gpa + (3 * SZ_1M);
 
-	self->vm_mem = aligned_alloc(SZ_1M, VM_MEM_SIZE);
+	self->vm_mem = aligned_alloc(SZ_1M, VM_MEM_MAX_M * SZ_1M);
 	ASSERT_NE(NULL, self->vm_mem) TH_LOG("malloc failed %u", errno);
 	self->base_hva = (uintptr_t)self->vm_mem;
 	self->code_hva = self->base_hva - self->base_gpa + self->code_gpa;
@@ -222,6 +244,60 @@ TEST(uc_cap_hpage)
 	close(kvm_fd);
 }
 
+/* calculate host virtual addr from guest physical addr */
+static void *gpa2hva(FIXTURE_DATA(uc_kvm) *self, u64 gpa)
+{
+	return (void *)(self->base_hva - self->base_gpa + gpa);
+}
+
+/* map / make additional memory available */
+static int uc_map_ext(FIXTURE_DATA(uc_kvm) *self, u64 vcpu_addr, u64 length)
+{
+	struct kvm_s390_ucas_mapping map = {
+		.user_addr = (u64)gpa2hva(self, vcpu_addr),
+		.vcpu_addr = vcpu_addr,
+		.length = length,
+	};
+	pr_info("ucas map %p %p 0x%llx",
+		(void *)map.user_addr, (void *)map.vcpu_addr, map.length);
+	return ioctl(self->vcpu_fd, KVM_S390_UCAS_MAP, &map);
+}
+
+/* unmap previously mapped memory */
+static int uc_unmap_ext(FIXTURE_DATA(uc_kvm) *self, u64 vcpu_addr, u64 length)
+{
+	struct kvm_s390_ucas_mapping map = {
+		.user_addr = (u64)gpa2hva(self, vcpu_addr),
+		.vcpu_addr = vcpu_addr,
+		.length = length,
+	};
+	pr_info("ucas unmap %p %p 0x%llx",
+		(void *)map.user_addr, (void *)map.vcpu_addr, map.length);
+	return ioctl(self->vcpu_fd, KVM_S390_UCAS_UNMAP, &map);
+}
+
+/* handle ucontrol exit by mapping the accessed segment */
+static void uc_handle_exit_ucontrol(FIXTURE_DATA(uc_kvm) *self)
+{
+	struct kvm_run *run = self->run;
+	u64 seg_addr;
+	int rc;
+
+	TEST_ASSERT_EQ(KVM_EXIT_S390_UCONTROL, run->exit_reason);
+	switch (run->s390_ucontrol.pgm_code) {
+	case PGM_SEGMENT_TRANSLATION:
+		seg_addr = run->s390_ucontrol.trans_exc_code & ~(SZ_1M - 1);
+		pr_info("ucontrol pic segment translation 0x%llx, mapping segment 0x%lx\n",
+			run->s390_ucontrol.trans_exc_code, seg_addr);
+		/* map / make additional memory available */
+		rc = uc_map_ext(self, seg_addr, SZ_1M);
+		TEST_ASSERT_EQ(0, rc);
+		break;
+	default:
+		TEST_FAIL("UNEXPECTED PGM CODE %d", run->s390_ucontrol.pgm_code);
+	}
+}
+
 /* verify SIEIC exit
  * * fail on codes not expected in the test cases
  */
@@ -255,6 +331,12 @@ static bool uc_handle_exit(FIXTURE_DATA(uc_kvm) * self)
 	struct kvm_run *run = self->run;
 
 	switch (run->exit_reason) {
+	case KVM_EXIT_S390_UCONTROL:
+		/** check program interruption code
+		 * handle page fault --> ucas map
+		 */
+		uc_handle_exit_ucontrol(self);
+		break;
 	case KVM_EXIT_S390_SIEIC:
 		return uc_handle_sieic(self);
 	default:
@@ -286,6 +368,67 @@ static void uc_assert_diag44(FIXTURE_DATA(uc_kvm) * self)
 	TEST_ASSERT_EQ(0x440000, sie_block->ipb);
 }
 
+TEST_F(uc_kvm, uc_map_unmap)
+{
+	struct kvm_sync_regs *sync_regs = &self->run->s.regs;
+	struct kvm_run *run = self->run;
+	const u64 disp = 1;
+	int rc;
+
+	/* copy test_mem_asm to code_hva / code_gpa */
+	TH_LOG("copy code %p to vm mapped memory %p / %p",
+	       &test_mem_asm, (void *)self->code_hva, (void *)self->code_gpa);
+	memcpy((void *)self->code_hva, &test_mem_asm, PAGE_SIZE);
+
+	/* DAT disabled + 64 bit mode */
+	run->psw_mask = 0x0000000180000000ULL;
+	run->psw_addr = self->code_gpa;
+
+	/* set register content for test_mem_asm to access not mapped memory*/
+	sync_regs->gprs[1] = 0x55;
+	sync_regs->gprs[5] = self->base_gpa;
+	sync_regs->gprs[6] = VM_MEM_SIZE + disp;
+	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
+
+	/* run and expect to fail with ucontrol pic segment translation */
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(1, sync_regs->gprs[0]);
+	ASSERT_EQ(KVM_EXIT_S390_UCONTROL, run->exit_reason);
+
+	ASSERT_EQ(PGM_SEGMENT_TRANSLATION, run->s390_ucontrol.pgm_code);
+	ASSERT_EQ(self->base_gpa + VM_MEM_SIZE, run->s390_ucontrol.trans_exc_code);
+
+	/* fail to map memory with not segment aligned address */
+	rc = uc_map_ext(self, self->base_gpa + VM_MEM_SIZE + disp, VM_MEM_EXT_SIZE);
+	ASSERT_GT(0, rc)
+		TH_LOG("ucas map for non segment address should fail but didn't; "
+		       "result %d not expected, %s", rc, strerror(errno));
+
+	/* map / make additional memory available */
+	rc = uc_map_ext(self, self->base_gpa + VM_MEM_SIZE, VM_MEM_EXT_SIZE);
+	ASSERT_EQ(0, rc)
+		TH_LOG("ucas map result %d not expected, %s", rc, strerror(errno));
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(false, uc_handle_exit(self));
+	uc_assert_diag44(self);
+
+	/* assert registers and memory are in expected state */
+	ASSERT_EQ(2, sync_regs->gprs[0]);
+	ASSERT_EQ(0x55, sync_regs->gprs[1]);
+	ASSERT_EQ(0x55, *(u32 *)gpa2hva(self, self->base_gpa + VM_MEM_SIZE + disp));
+
+	/* unmap and run loop again */
+	rc = uc_unmap_ext(self, self->base_gpa + VM_MEM_SIZE, VM_MEM_EXT_SIZE);
+	ASSERT_EQ(0, rc)
+		TH_LOG("ucas unmap result %d not expected, %s", rc, strerror(errno));
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(3, sync_regs->gprs[0]);
+	ASSERT_EQ(KVM_EXIT_S390_UCONTROL, run->exit_reason);
+	ASSERT_EQ(PGM_SEGMENT_TRANSLATION, run->s390_ucontrol.pgm_code);
+	/* handle ucontrol exit and remap memory after previous map and unmap */
+	ASSERT_EQ(true, uc_handle_exit(self));
+}
+
 TEST_F(uc_kvm, uc_gprs)
 {
 	struct kvm_sync_regs *sync_regs = &self->run->s.regs;
-- 
2.47.0


