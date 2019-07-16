Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FBC6B292
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 01:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfGPX5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 19:57:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbfGPX5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 19:57:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GNNT5h149644;
        Tue, 16 Jul 2019 23:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=iGxqOrnoCsUDmQ+EtjCgG1a3Cbay8ZdSlGC0Ue/qnEw=;
 b=b+Usz3/5iF9+AH5c3Z9YIMxZdrU/gaIO1sDDY4wCcTf+dIzKLAcdal0AteEA4j+y0LJl
 SXq2u7rvFUAfGeESzeG9KR5BkXCkEg3nRZvOMaALWuJHxRsOwaItV3Ere1v0WG1cW1Nh
 a7c0VemfZPYK6e+dP8IEAsPCSQ6zCQEguIgPn6TvsspL3eHxS0epexGHBR4PBDOiCdJx
 ZYpOpv2LSEEoIzWSfVlOHtagcAYHaMELsgn+2pl2yNvV90JGFcL4IjxAGDG/4bqCh9a7
 OT0X8GbQwBxOCubpJ34yrmAVqD5K24/RYF2AE4vsrRug1hrLTP1+UHEfvXGF13edXdyT 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tq6qtqgtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 23:57:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCfSs139344;
        Tue, 16 Jul 2019 23:57:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tq4du74s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 23:57:18 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GNvGWJ012784;
        Tue, 16 Jul 2019 23:57:16 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 23:57:15 +0000
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>,
        Singh Brijesh <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v2] KVM: SVM: Fix detection of AMD Errata 1096
Date:   Wed, 17 Jul 2019 02:56:58 +0300
Message-Id: <20190716235658.18185-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=995
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160261
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160261
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Errata 1096:
When CPU raise #NPF on guest data access and vCPU CR4.SMAP=1, it is
possible that CPU microcode implementing DecodeAssist will fail
to read bytes of instruction which caused #NPF. In this case,
GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
return 0 instead of the correct guest instruction bytes.
This happens because CPU microcode reading instruction bytes
uses a special opcode which attempts to read data using CPL=0
priviledges. The microcode reads CS:RIP and if it hits a SMAP
fault, it gives up and returns no instruction bytes.

Current KVM code which attemps to detect and workaround this errata have
multiple issues:

1) Code mistakenly checks if vCPU CR4.SMAP=0 instead of vCPU CR4.SMAP=1 which
is required for encountering a SMAP fault.

2) Code assumes SMAP fault can only occur when vCPU CPL==3.
However, the condition for a SMAP fault is a data access with CPL<3
to a page mapped in page-tables as user-accessible (i.e. PTE with U/S
bit set to 1).
Therefore, in case vCPU CR4.SMEP=0, guest can execute an instruction
which reside in a user-accessible page with CPL<3 priviledge. If this
instruction raise a #NPF on it's data access, then CPU DecodeAssist
microcode will still encounter a SMAP violation.
Even though no sane OS will do so (as it's an obvious priviledge
escalation vulnerability), we still need to handle this semanticly
correct in KVM side.

As CR4.SMAP=1 is an easy triggerable condition, attempt to avoid
false-positive of detecting errata by taking note that in case vCPU
CR4.SMEP=1, errata could only be encountered in case CPL==3 (As
otherwise, CPU would raise SMEP fault to guest instead of #NPF).
This can be a useful condition to avoid false-positive because guests
usually enable SMAP if they have also enabled SMEP.

In addition, to avoid future confusion and improve code readbility,
comment errata details in code and not just in commit message.

Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
Cc: Singh Brijesh <brijesh.singh@amd.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/svm.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 735b8c01895e..7d6410539dd7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7120,13 +7120,41 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 
 static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 {
-	bool is_user, smap;
-
-	is_user = svm_get_cpl(vcpu) == 3;
-	smap = !kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
+	unsigned long cr4 = kvm_read_cr4(vcpu);
+	bool smep = cr4 & X86_CR4_SMEP;
+	bool smap = cr4 & X86_CR4_SMAP;
+	bool is_user = svm_get_cpl(vcpu) == 3;
 
 	/*
-	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh
+	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
+	 *
+	 * Errata:
+	 * When CPU raise #NPF on guest data access and vCPU CR4.SMAP=1, it is
+	 * possible that CPU microcode implementing DecodeAssist will fail
+	 * to read bytes of instruction which caused #NPF. In this case,
+	 * GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
+	 * return 0 instead of the correct guest instruction bytes.
+	 *
+	 * This happens because CPU microcode reading instruction bytes
+	 * uses a special opcode which attempts to read data using CPL=0
+	 * priviledges. The microcode reads CS:RIP and if it hits a SMAP
+	 * fault, it gives up and returns no instruction bytes.
+	 *
+	 * Detection:
+	 * We reach here in case CPU supports DecodeAssist, raised #NPF and
+	 * returned 0 in GuestIntrBytes field of the VMCB.
+	 * First, errata can only be triggered in case vCPU CR4.SMAP=1.
+	 * Second, if vCPU CR4.SMEP=1, errata could only be triggered
+	 * in case vCPU CPL==3 (Because otherwise guest would have triggered
+	 * a SMEP fault instead of #NPF).
+	 * Otherwise, vCPU CR4.SMEP=0, errata could be triggered by any vCPU CPL.
+	 * As most guests enable SMAP if they have also enabled SMEP, use above
+	 * logic in order to attempt minimize false-positive of detecting errata
+	 * while still preserving all cases semantic correctness.
+	 *
+	 * Workaround:
+	 * To determine what instruction the guest was executing, the hypervisor
+	 * will have to decode the instruction at the instruction pointer.
 	 *
 	 * In non SEV guest, hypervisor will be able to read the guest
 	 * memory to decode the instruction pointer when insn_len is zero
@@ -7137,11 +7165,11 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	 * instruction pointer so we will not able to workaround it. Lets
 	 * print the error and request to kill the guest.
 	 */
-	if (is_user && smap) {
+	if (smap && (!smep || is_user)) {
 		if (!sev_guest(vcpu->kvm))
 			return true;
 
-		pr_err_ratelimited("KVM: Guest triggered AMD Erratum 1096\n");
+		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
-- 
2.20.1

