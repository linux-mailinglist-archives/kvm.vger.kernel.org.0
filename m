Return-Path: <kvm+bounces-65003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3473BC976C2
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:56:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 076554E41EF
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC83B3148C1;
	Mon,  1 Dec 2025 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X4jgdYTn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C88D313264;
	Mon,  1 Dec 2025 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593123; cv=none; b=aGgLAeQSxc60hAqX0wxMSVIue4JAobNAU8Nom/QfIVgafKY4h8kREWBwxDmAEvds4Wwa6ugvbO3ZY9gt6SjoHDExwYk4vfD6mpxR7dFG/8pONbYg2RtUqbYAgtKxbxTZ4rQn6MDcctMUYkTDwgmgcoIUOsNjfjqLjofvDlcFijw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593123; c=relaxed/simple;
	bh=OfKZGdEgPK7vlZUF6YWA+ybENhzgjBiJ10CcXPcof7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4dqFU+UVz8R2Bpl+eQC5ovBxRpC/uLkaCcGXP0UZGG+cLVxC6OpVX9bLznsCBkB1F0CZsgNmVoeAJTB6zkosG6ab3Wac4kG65MkHMGdtpNQeNU/fpym4gicPHtsOaQWi/q4xAaQ3yW7p7W1rcBEjpbcN9+h99JhxdesJ+Bm3lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X4jgdYTn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1AxibQ031757;
	Mon, 1 Dec 2025 12:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZvMRIdthVh61hXIDt
	Ji246eiJcEcOXQARVNgxEebk8w=; b=X4jgdYTnPkkKQQyW/SP8D30puVYl5sBnX
	GoL31Rsx2n+s92aSYqJfUKsv64B6xWMWzYHMvylu/X5ghP+oftf6YDNQ9NJPlO16
	CzQ6aSKb4GVPL9HsTmnBDYkXoXNzdusTk0gQqizQ2co4sJm+qxFUmEK7G5MBfuWF
	8Ar8bxFT2eH8JrLJg8fzwwdQ+gNQq81lIwJQCFnhysc4NQ16n93jEfrw9RWWUv3k
	TZPmqU1Pwa4Ru+FzqjzRQMT3EFdwkArff/EdYh4hW1mtjdXj5d2LbmteePA8nLej
	wEQiq7GPLFU3ba7xyvQS7v2U17EmSPKtOqx2umY84q+3SrtD19+fg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrbfy571-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:18 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1AHGCm029328;
	Mon, 1 Dec 2025 12:45:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ardv164ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjE2W41026042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:14 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B53420040;
	Mon,  1 Dec 2025 12:45:14 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94DA62004B;
	Mon,  1 Dec 2025 12:45:13 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:13 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [GIT PULL 10/10] KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK functions
Date: Mon,  1 Dec 2025 13:33:52 +0100
Message-ID: <20251201124334.110483-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JMcwiOnyK1YW9wKs4Cfws4rrTr8JEdLJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAxNiBTYWx0ZWRfXw+i2Yd+PjOsz
 klGiAaJVDNG5PmPRdvTJMLLdAM2u6DIC/oJeIAvayUoPSTzB3g+krFs3Yem83n9RC0NNz9FpnAG
 ua3esdpxgaS7wgpP1SSOuq3QeDJljNjQdp9GBpsWJZkdS62HvffISGuHJSpnd2/jWzJeSdoh81j
 hHTdvoi7+UTfhinL0+TGIKfrXrdtY8uA2s01d2j90+91NnmzMc+2oeAP/Yf6Z8TXt8txwHuDvyJ
 fEOJHlPHUPOn7+NtJ4xpzfFqtZe1TOZDhkYq3jZs7uMOxyGL+ApM9IXlC/20jfk33QxTu8be5UQ
 L3X1vVIrx07JOh9EZWabG/kXs8TxgF29UgPwNM7cFTRF787nv5EMRwySaUJJiqxoMEQ7zL3y6I5
 XwQ5XKOYUtvpMyxykZdYLLWr/IE0xA==
X-Authority-Analysis: v=2.4 cv=UO7Q3Sfy c=1 sm=1 tr=0 ts=692d8dde cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=1US_Z202mYDpc0AvFX8A:9
X-Proofpoint-GUID: JMcwiOnyK1YW9wKs4Cfws4rrTr8JEdLJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290016

From: Andrew Donnellan <ajd@linux.ibm.com>

Switch to using the generic infrastructure to check for and handle pending
work before transitioning into guest mode.

xfer_to_guest_mode_handle_work() does a few more things than the current
code does when deciding whether or not to exit the __vcpu_run() loop. The
exittime tests from kvm-unit-tests, in my tests, were within a few percent
compared to before this series, which is within noise tolerance.

Co-developed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
[frankja@linux.ibm.com: Removed semicolon]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/Kconfig    |  1 +
 arch/s390/kvm/kvm-s390.c | 25 ++++++++++++++++++-------
 arch/s390/kvm/vsie.c     | 18 +++++++++++++-----
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index cae908d64550..0ca9d6587243 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -30,6 +30,7 @@ config KVM
 	select HAVE_KVM_NO_POLL
 	select KVM_VFIO
 	select MMU_NOTIFIER
+	select VIRT_XFER_TO_GUEST_WORK
 	help
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4d13601ec217..d31155e371df 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/compiler.h>
+#include <linux/entry-virt.h>
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fs.h>
@@ -4675,9 +4676,6 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gg14 = vcpu->run->s.regs.gprs[14];
 	vcpu->arch.sie_block->gg15 = vcpu->run->s.regs.gprs[15];
 
-	if (need_resched())
-		schedule();
-
 	if (!kvm_is_ucontrol(vcpu->kvm)) {
 		rc = kvm_s390_deliver_pending_interrupts(vcpu);
 		if (rc || guestdbg_exit_pending(vcpu))
@@ -4982,12 +4980,12 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	kvm_vcpu_srcu_read_lock(vcpu);
 
-	do {
+	while (true) {
 		rc = vcpu_pre_run(vcpu);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		if (rc || guestdbg_exit_pending(vcpu))
 			break;
 
-		kvm_vcpu_srcu_read_unlock(vcpu);
 		/*
 		 * As PF_VCPU will be used in fault handler, between
 		 * guest_timing_enter_irqoff and guest_timing_exit_irqoff
@@ -4999,7 +4997,17 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 			       sizeof(sie_page->pv_grregs));
 		}
 
+xfer_to_guest_mode_check:
 		local_irq_disable();
+		xfer_to_guest_mode_prepare();
+		if (xfer_to_guest_mode_work_pending()) {
+			local_irq_enable();
+			rc = kvm_xfer_to_guest_mode_handle_work(vcpu);
+			if (rc)
+				break;
+			goto xfer_to_guest_mode_check;
+		}
+
 		guest_timing_enter_irqoff();
 		__disable_cpu_timer_accounting(vcpu);
 
@@ -5029,9 +5037,12 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_vcpu_srcu_read_lock(vcpu);
 
 		rc = vcpu_post_run(vcpu, exit_reason);
-	} while (!signal_pending(current) && !guestdbg_exit_pending(vcpu) && !rc);
+		if (rc || guestdbg_exit_pending(vcpu)) {
+			kvm_vcpu_srcu_read_unlock(vcpu);
+			break;
+		}
+	}
 
-	kvm_vcpu_srcu_read_unlock(vcpu);
 	return rc;
 }
 
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index d23ab5120888..b526621d2a1b 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1180,12 +1180,23 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	current->thread.gmap_int_code = 0;
 	barrier();
 	if (!kvm_s390_vcpu_sie_inhibited(vcpu)) {
+xfer_to_guest_mode_check:
 		local_irq_disable();
+		xfer_to_guest_mode_prepare();
+		if (xfer_to_guest_mode_work_pending()) {
+			local_irq_enable();
+			rc = kvm_xfer_to_guest_mode_handle_work(vcpu);
+			if (rc)
+				goto skip_sie;
+			goto xfer_to_guest_mode_check;
+		}
 		guest_timing_enter_irqoff();
 		rc = kvm_s390_enter_exit_sie(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);
 		guest_timing_exit_irqoff();
 		local_irq_enable();
 	}
+
+skip_sie:
 	barrier();
 	vcpu->arch.sie_block->prog0c &= ~PROG_IN_SIE;
 
@@ -1345,13 +1356,11 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		 * but rewind the PSW to re-enter SIE once that's completed
 		 * instead of passing a "no action" intercept to the guest.
 		 */
-		if (signal_pending(current) ||
-		    kvm_s390_vcpu_has_irq(vcpu, 0) ||
+		if (kvm_s390_vcpu_has_irq(vcpu, 0) ||
 		    kvm_s390_vcpu_sie_inhibited(vcpu)) {
 			kvm_s390_rewind_psw(vcpu, 4);
 			break;
 		}
-		cond_resched();
 	}
 
 	if (rc == -EFAULT) {
@@ -1483,8 +1492,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 	if (unlikely(scb_addr & 0x1ffUL))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-	if (signal_pending(current) || kvm_s390_vcpu_has_irq(vcpu, 0) ||
-	    kvm_s390_vcpu_sie_inhibited(vcpu)) {
+	if (kvm_s390_vcpu_has_irq(vcpu, 0) || kvm_s390_vcpu_sie_inhibited(vcpu)) {
 		kvm_s390_rewind_psw(vcpu, 4);
 		return 0;
 	}
-- 
2.52.0


