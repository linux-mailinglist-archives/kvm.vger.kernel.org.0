Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0CEE69CD2
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 22:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbfGOUbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 16:31:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731366AbfGOUbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 16:31:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FKSpbG074899;
        Mon, 15 Jul 2019 20:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=EYTrKg8RF1oUflTqZCBg9xy7h3/ijviGoYM08L3E+Oo=;
 b=z5U0C4yvzpDn3Z1w2H/dO7YnK4cP6yi25Crfvz6/oGN4itVAPmYrNAtjCZQJL2VLLAfq
 7LuSKCacY9e+UP12i/n1OUilAIdmdskW3YIFzlQi1rzYObw6w+0s12tvLyaqjBz3vQfT
 TTyo2qBDOAb8JYbOjP03PAd8e7/Jsra3+nQCKdTlkipZQR8JXGUWpPnbGRVOcgdMprYd
 nRqHwexGaynFoNi9wi/sPOXaWGb8xGVe9zLPTM9z421K4JRejfTMMzF7thBHjeRym5Lp
 bf0fOmBMlrIILKeNtnP1kBLOKYApBP7qusxf3+g5YrXhu7IXg4Gh7mYjGfQJ4uezfWIr sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tq7xqrp6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 20:31:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FKRmsO128616;
        Mon, 15 Jul 2019 20:31:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tq4dth59c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 20:31:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6FKV36X020971;
        Mon, 15 Jul 2019 20:31:03 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 13:31:03 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     brijesh.singh@amd.com, Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Date:   Mon, 15 Jul 2019 23:30:42 +0300
Message-Id: <20190715203043.100483-2-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715203043.100483-1-liran.alon@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=915
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=957 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150234
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to AMD Errata 1096:
"On a nested data page fault when CR4.SMAP = 1 and the guest data read generates a SMAP violation, the
GuestInstrBytes field of the VMCB on a VMEXIT will incorrectly return 0h instead the correct guest instruction
bytes."

As stated above, errata is encountered when guest read generates a SMAP violation. i.e. vCPU runs
with CPL<3 and CR4.SMAP=1. However, code have mistakenly checked if CPL==3 and CR4.SMAP==0.

To avoid future confusion and improve code readbility, comment errata details in code and not
just in commit message.

Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/svm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 735b8c01895e..79023a41f7a7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7123,10 +7123,19 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	bool is_user, smap;
 
 	is_user = svm_get_cpl(vcpu) == 3;
-	smap = !kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
+	smap = kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 
 	/*
-	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh
+	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
+	 *
+	 * Errata:
+	 * On a nested page fault when CR4.SMAP=1 and the guest data read generates
+	 * a SMAP violation, GuestIntrBytes field of the VMCB on a VMEXIT will
+	 * incorrectly return 0 instead the correct guest instruction bytes.
+	 *
+	 * Workaround:
+	 * To determine what instruction the guest was executing, the hypervisor
+	 * will have to decode the instruction at the instruction pointer.
 	 *
 	 * In non SEV guest, hypervisor will be able to read the guest
 	 * memory to decode the instruction pointer when insn_len is zero
@@ -7137,11 +7146,11 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	 * instruction pointer so we will not able to workaround it. Lets
 	 * print the error and request to kill the guest.
 	 */
-	if (is_user && smap) {
+	if (!is_user && smap) {
 		if (!sev_guest(vcpu->kvm))
 			return true;
 
-		pr_err_ratelimited("KVM: Guest triggered AMD Erratum 1096\n");
+		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
-- 
2.20.1

