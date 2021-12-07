Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D841F46C030
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhLGQFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:05:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238770AbhLGQFf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:05:35 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7FB96I010625;
        Tue, 7 Dec 2021 16:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4co1akxJ7RgYlJWBC0CrtxVjswftUbb3VIvMzKjoNn8=;
 b=MvDgzNILKohyk4K7kFVYob6D+qupTr9TwlaDqIRxhbRpGDDcDWouMH5lS3he8i/PNz9n
 6m8d2ND9EAbd+KuxBQ9U+hpDkjnxghwAZ8G2SwUh8pbcCIvFmdn/B0UBTs4k8COworEr
 yRdiVMej9Qt+OMbZWC5Kx7awEZGH1MpLAqS9eKIohYT0CZaiMdw+upZ7g4Y5F50m9Nyx
 BMwh9oi33EewnPU+xb8X61h3AGVdMmw03UZvclYnVIsME7pE4W60i25hOtQ1RFAcsuTa
 mEJZw7lIGFDXmms+rTMe4BCyHpFieh9edsMCxW4T5c2Yv5kJfM5mJyfnlllEqHxTGNwD 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct9avt6kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:04 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Fml9d023587;
        Tue, 7 Dec 2021 16:02:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ct9avt6jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Fqh3c010880;
        Tue, 7 Dec 2021 16:02:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykj86yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7G1wLY28967394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 16:01:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61FE54C050;
        Tue,  7 Dec 2021 16:01:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45D354C044;
        Tue,  7 Dec 2021 16:01:57 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:01:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 01/10] lib: s390x: sie: Add sca allocation and freeing
Date:   Tue,  7 Dec 2021 15:59:56 +0000
Message-Id: <20211207160005.1586-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207160005.1586-1-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _JRMd0Z6INEn5PDPSw-orceLgFl2daWA
X-Proofpoint-GUID: D_hT--5fD5XVF9mqS9SSeM7VI-HalxkY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 mlxscore=0 spamscore=0 mlxlogscore=878 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For protected guests we always need a ESCA so let's add functions to
create and destroy SCAs on demand. We don't have scheduling and I
don't expect multiple VCPU SIE in the next few months so SCA content
handling is not added.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.c | 12 ++++++++++++
 lib/s390x/sie.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index b965b314..51d3b94e 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -55,6 +55,16 @@ void sie(struct vm *vm)
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
 }
 
+void sie_guest_sca_create(struct vm *vm)
+{
+	vm->sca = (struct esca_block *)alloc_page();
+
+	/* Let's start out with one page of ESCA for now */
+	vm->sblk->scaoh = ((uint64_t)vm->sca >> 32);
+	vm->sblk->scaol = (uint64_t)vm->sca & ~0x3fU;
+	vm->sblk->ecb2 |= ECB2_ESCA;
+}
+
 /* Initializes the struct vm members like the SIE control block. */
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 {
@@ -80,4 +90,6 @@ void sie_guest_destroy(struct vm *vm)
 {
 	free_page(vm->crycb);
 	free_page(vm->sblk);
+	if (vm->sblk->ecb2 & ECB2_ESCA)
+		free_page(vm->sca);
 }
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 7ef7251b..f34e3c80 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -191,6 +191,7 @@ struct vm_save_area {
 struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
+	void *sca;				/* System Control Area */
 	uint8_t *crycb;				/* Crypto Control Block */
 	/* Ptr to first guest page */
 	uint8_t *guest_mem;
@@ -203,6 +204,7 @@ void sie(struct vm *vm);
 void sie_expect_validity(void);
 void sie_check_validity(uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
+void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
 
-- 
2.32.0

