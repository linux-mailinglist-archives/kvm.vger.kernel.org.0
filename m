Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1736B45A077
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhKWKnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234461AbhKWKnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:20 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAH5Ig024391;
        Tue, 23 Nov 2021 10:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fYeGeQA2L467cjW7dt9QVFuVnmTWuwcNMP0xX2YMqfQ=;
 b=Qte2dJnmou39mxZJrX0bpzVXQUVrgG4hG2grLMCD6n8OM+TOHlgdShQkYJUAxyE1Rfcm
 wY3GT459fWJQqd4ZjIQppelknw+dQfoA+5W0E/9vSKCS6aH01LFGlo5DRhKX3WR+AiKj
 GB2rqF0DSimH1kcrDMD3HfeedOE09lkQAwapd9K/v4T6rQfWbd1/oDI4RAMzXQcZaZUl
 74RaOhZhgY3oMC5Z0SzN0WmDP9PSN+Al5rxZvYh8jIMJ8kc7ia8RniBYfOEefQxlRQvO
 AX3TrvGEGKEtLDzn/MrQFL0R/adBqczOWF/CxmqWm5EDONFUnoeVyDT9OF3Zn9nS8tHQ Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxdqrc49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:11 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANALaMW007707;
        Tue, 23 Nov 2021 10:40:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxdqrc34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAaxRu026354;
        Tue, 23 Nov 2021 10:40:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3cer9jnpya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAe5t331457686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:40:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 813A7A405B;
        Tue, 23 Nov 2021 10:40:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D9ABA4051;
        Tue, 23 Nov 2021 10:40:04 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/8] lib: s390x: sie: Add sca allocation and freeing
Date:   Tue, 23 Nov 2021 10:39:49 +0000
Message-Id: <20211123103956.2170-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123103956.2170-1-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zGi4a_17PoawCVyZPaKQgdUvr7Us-n2e
X-Proofpoint-ORIG-GUID: G6q4QLPDiNXqLVRgSzgb8r8gadeNo0kM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=884 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For protected guests we always need a ESCA so let's add functions to
create and destroy SCAs on demand. We don't have scheduling and I
don't expect multiple VCPU SIE in the next few months so SCA content
handling is not added.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

