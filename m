Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5959EA04
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbfH0Nt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:49:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730021AbfH0Nt5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Aug 2019 09:49:57 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7RDm5kn026883
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:49:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2un2cj0u8q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:49:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 27 Aug 2019 14:49:52 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 27 Aug 2019 14:49:49 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7RDnQfx13435332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 13:49:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E48652050;
        Tue, 27 Aug 2019 13:49:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9E78852059;
        Tue, 27 Aug 2019 13:49:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 1/3] s390x: Move pfmf to lib and make address void
Date:   Tue, 27 Aug 2019 15:49:34 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190827134936.1705-1-frankja@linux.ibm.com>
References: <20190827134936.1705-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082713-0008-0000-0000-0000030DDCE9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082713-0009-0000-0000-00004A2C1978
Message-Id: <20190827134936.1705-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-27_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=889 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908270149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's needed by other tests soon.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/mem.h | 31 ++++++++++++++++++++++
 s390x/pfmf.c        | 63 ++++++++++++++-------------------------------
 2 files changed, 50 insertions(+), 44 deletions(-)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 75bd778..9b8fd70 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -54,4 +54,35 @@ static inline unsigned char get_storage_key(unsigned long addr)
 	asm volatile("iske %0,%1" : "=d" (skey) : "a" (addr));
 	return skey;
 }
+
+#define PFMF_FSC_4K 0
+#define PFMF_FSC_1M 1
+#define PFMF_FSC_2G 2
+
+union pfmf_r1 {
+	struct {
+		unsigned long pad0 : 32;
+		unsigned long pad1 : 12;
+		unsigned long pad_fmfi : 2;
+		unsigned long sk : 1; /* set key*/
+		unsigned long cf : 1; /* clear frame */
+		unsigned long ui : 1; /* usage indication */
+		unsigned long fsc : 3;
+		unsigned long pad2 : 1;
+		unsigned long mr : 1;
+		unsigned long mc : 1;
+		unsigned long pad3 : 1;
+		unsigned long key : 8; /* storage keys */
+	} reg;
+	unsigned long val;
+};
+
+static inline void *pfmf(unsigned long r1, void *paddr)
+{
+	register void * addr asm("1") = paddr;
+
+	asm volatile(".insn rre,0xb9af0000,%[r1],%[addr]"
+		     : [addr] "+a" (addr) : [r1] "d" (r1) : "memory");
+	return addr;
+}
 #endif
diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 9bf434a..0aa5822 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -16,60 +16,29 @@
 #include <asm/facility.h>
 #include <asm/mem.h>
 
-#define FSC_4K 0
-#define FSC_1M 1
-#define FSC_2G 2
-
-union r1 {
-	struct {
-		unsigned long pad0 : 32;
-		unsigned long pad1 : 12;
-		unsigned long pad_fmfi : 2;
-		unsigned long sk : 1; /* set key*/
-		unsigned long cf : 1; /* clear frame */
-		unsigned long ui : 1; /* usage indication */
-		unsigned long fsc : 3;
-		unsigned long pad2 : 1;
-		unsigned long mr : 1;
-		unsigned long mc : 1;
-		unsigned long pad3 : 1;
-		unsigned long key : 8; /* storage keys */
-	} reg;
-	unsigned long val;
-};
-
 static uint8_t pagebuf[PAGE_SIZE * 256] __attribute__((aligned(PAGE_SIZE * 256)));
 
-static inline unsigned long pfmf(unsigned long r1, unsigned long paddr)
-{
-	register uint64_t addr asm("1") = paddr;
-
-	asm volatile(".insn rre,0xb9af0000,%[r1],%[addr]"
-		     : [addr] "+a" (addr) : [r1] "d" (r1) : "memory");
-	return addr;
-}
-
 static void test_priv(void)
 {
 	report_prefix_push("privileged");
 	expect_pgm_int();
 	enter_pstate();
-	pfmf(0, (unsigned long) pagebuf);
+	pfmf(0, pagebuf);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 }
 
 static void test_4k_key(void)
 {
-	union r1 r1;
+	union pfmf_r1 r1;
 	union skey skey;
 
 	report_prefix_push("4K");
 	r1.val = 0;
 	r1.reg.sk = 1;
-	r1.reg.fsc = FSC_4K;
+	r1.reg.fsc = PFMF_FSC_4K;
 	r1.reg.key = 0x30;
-	pfmf(r1.val, (unsigned long) pagebuf);
+	pfmf(r1.val, pagebuf);
 	skey.val = get_storage_key((unsigned long) pagebuf);
 	skey.val &= SKEY_ACC | SKEY_FP;
 	report("set storage keys", skey.val == 0x30);
@@ -80,15 +49,18 @@ static void test_1m_key(void)
 {
 	int i;
 	bool rp = true;
-	union r1 r1;
+	union pfmf_r1 r1;
 	union skey skey;
+	void *addr = pagebuf;
 
 	report_prefix_push("1M");
 	r1.val = 0;
 	r1.reg.sk = 1;
-	r1.reg.fsc = FSC_1M;
+	r1.reg.fsc = PFMF_FSC_1M;
 	r1.reg.key = 0x30;
-	pfmf(r1.val, (unsigned long) pagebuf);
+	while (addr != pagebuf + 256 * PAGE_SIZE) {
+	       addr = pfmf(r1.val, addr);
+	}
 	for (i = 0; i < 256; i++) {
 		skey.val = get_storage_key((unsigned long) pagebuf + i * PAGE_SIZE);
 		skey.val &= SKEY_ACC | SKEY_FP;
@@ -103,15 +75,15 @@ static void test_1m_key(void)
 
 static void test_4k_clear(void)
 {
-	union r1 r1;
+	union pfmf_r1 r1;
 
 	r1.val = 0;
 	r1.reg.cf = 1;
-	r1.reg.fsc = FSC_4K;
+	r1.reg.fsc = PFMF_FSC_4K;
 
 	report_prefix_push("4K");
 	memset(pagebuf, 42, PAGE_SIZE);
-	pfmf(r1.val, (unsigned long) pagebuf);
+	pfmf(r1.val, pagebuf);
 	report("clear memory", !memcmp(pagebuf, pagebuf + PAGE_SIZE, PAGE_SIZE));
 	report_prefix_pop();
 }
@@ -119,16 +91,19 @@ static void test_4k_clear(void)
 static void test_1m_clear(void)
 {
 	int i;
-	union r1 r1;
+	union pfmf_r1 r1;
 	unsigned long sum = 0;
+	void *addr = pagebuf;
 
 	r1.val = 0;
 	r1.reg.cf = 1;
-	r1.reg.fsc = FSC_1M;
+	r1.reg.fsc = PFMF_FSC_1M;
 
 	report_prefix_push("1M");
 	memset(pagebuf, 42, PAGE_SIZE * 256);
-	pfmf(r1.val, (unsigned long) pagebuf);
+	while (addr != pagebuf + 256 * PAGE_SIZE) {
+	       addr = pfmf(r1.val, addr);
+	}
 	for (i = 0; i < PAGE_SIZE * 256; i++)
 		sum |= pagebuf[i];
 	report("clear memory", !sum);
-- 
2.17.0

