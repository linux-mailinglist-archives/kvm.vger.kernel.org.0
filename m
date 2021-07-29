Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673393DA4A5
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhG2Ns3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:48:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237825AbhG2Ns1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:48:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TDiI27078928;
        Thu, 29 Jul 2021 09:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vyJKt0bZhoq6ffyST58lUouDpSCAs2tHH4tmV7Qw7TU=;
 b=Ti4mKsbAMkW1//RkGfqT4znKMsJvbonU199wHuFqLo+PjGoOsSdkHlayl2MW1S2um3ux
 xymxIgrHxXk4PX4Of5r/OEIYnew4iNT3pdBjGtS8lZqqRLQoVSF1+QhNvuVeUI7qBMue
 knvriImhvLM09G/kzH68S39yYtp9biaeySbUwrtxZcD8LrlKUIjxx0SYC2ja5zaSMwlC
 dpJq7R/hu5UFKoVsukmcfeh9OzPj56gO6+heqF6m1Y95bcY3tNrR3xAXob8n7XFzMPTx
 PbmCuJLJQfUVqPax+fGKufDRV7THZqhBDUAclXxrarMe7zjwdRfih91EHOKmQxBcHx1q 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wftr3p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:17 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TDjOhS082679;
        Thu, 29 Jul 2021 09:48:17 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wftr3mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDZaEN007575;
        Thu, 29 Jul 2021 13:48:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3a235kh545-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:48:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDjRhp21955056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:45:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D55904C0BB;
        Thu, 29 Jul 2021 13:48:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B90C4C0B6;
        Thu, 29 Jul 2021 13:48:11 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:48:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 4/4] lib: s390x: sie: Move sie function into library
Date:   Thu, 29 Jul 2021 13:48:03 +0000
Message-Id: <20210729134803.183358-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729134803.183358-1-frankja@linux.ibm.com>
References: <20210729134803.183358-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AnrGKglxMdlTEmwuZV8tqQ9SN-oQ8UdF
X-Proofpoint-GUID: lV_-kcy4UMNGefFORXUOmB__JaEGZ3Iy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time to deduplicate more code.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.c  | 13 +++++++++++++
 lib/s390x/sie.h  |  1 +
 s390x/mvpg-sie.c | 13 -------------
 s390x/sie.c      | 17 -----------------
 4 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index ec0c4867..d971e825 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -43,6 +43,19 @@ void sie_handle_validity(struct vm *vm)
 	validity_expected = false;
 }
 
+void sie(struct vm *vm)
+{
+	/* Reset icptcode so we don't trip over it below */
+	vm->sblk->icptcode = 0;
+
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		sie_handle_validity(vm);
+	}
+	vm->save_area.guest.grs[14] = vm->sblk->gg14;
+	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+}
+
 /* Initializes the struct vm members like the SIE control block. */
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 {
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 946bd164..ca514ef3 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -198,6 +198,7 @@ struct vm {
 extern void sie_entry(void);
 extern void sie_exit(void);
 extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
+void sie(struct vm *vm);
 void sie_expect_validity(void);
 void sie_check_validity(uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 71ae4f88..70d2fcfa 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -32,19 +32,6 @@ extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
 extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
 int binary_size;
 
-static void sie(struct vm *vm)
-{
-	/* Reset icptcode so we don't trip over it below */
-	vm->sblk->icptcode = 0;
-
-	while (vm->sblk->icptcode == 0) {
-		sie64a(vm->sblk, &vm->save_area);
-		sie_handle_validity(vm);
-	}
-	vm->save_area.guest.grs[14] = vm->sblk->gg14;
-	vm->save_area.guest.grs[15] = vm->sblk->gg15;
-}
-
 static void test_mvpg_pei(void)
 {
 	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
diff --git a/s390x/sie.c b/s390x/sie.c
index 9cb9b055..ed2c3263 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -24,22 +24,6 @@ static u8 *guest;
 static u8 *guest_instr;
 static struct vm vm;
 
-
-static void sie(struct vm *vm)
-{
-	while (vm->sblk->icptcode == 0) {
-		sie64a(vm->sblk, &vm->save_area);
-		sie_handle_validity(vm);
-	}
-	vm->save_area.guest.grs[14] = vm->sblk->gg14;
-	vm->save_area.guest.grs[15] = vm->sblk->gg15;
-}
-
-static void sblk_cleanup(struct vm *vm)
-{
-	vm->sblk->icptcode = 0;
-}
-
 static void test_diag(u32 instr)
 {
 	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
@@ -51,7 +35,6 @@ static void test_diag(u32 instr)
 	report(vm.sblk->icptcode == ICPT_INST &&
 	       vm.sblk->ipa == instr >> 16 && vm.sblk->ipb == instr << 16,
 	       "Intercept data");
-	sblk_cleanup(&vm);
 }
 
 static struct {
-- 
2.30.2

