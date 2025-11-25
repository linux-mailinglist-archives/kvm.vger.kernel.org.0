Return-Path: <kvm+bounces-64472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3381FC83C6A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 08:47:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1B28B4E55BE
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E532D2384;
	Tue, 25 Nov 2025 07:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V2JKz5a1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FB1248F66;
	Tue, 25 Nov 2025 07:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764056813; cv=none; b=Z1ivz+BGa6DdAXXMkck4BvQ/orSDRRZzrI/fDd+mnZmtm5L9WU12aCZaGNY7YTcrQLOjH1KTVVLWjAyuvXvcpkwZvlabTIxUKZSVEL4t/dpJHlEsy+hpJQdqB2CTBVHpM+DVPGHhHH3DK3ZIP6C2R1s0O+0M09G1cd/6LnJWPv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764056813; c=relaxed/simple;
	bh=K9z8/SihDEkfmDzEo5CX9O5OBfQeWK8JOc32pj8sytE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f6TTpFwCFb3OrshcHow7aO1eMD3RAMWdvGC6VQRF3W2fG8NaLYKETW3pi0UAi36JKMdlZW1f+tViO6WZjTW3KbKZkdXn+pY0yzq3SQkVQrDwqkkGufO8Kj4weiI2XOaRf/ETskPCNpTFS1QTPhqGAr7NBkzPkb0qun+/NbFsRyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V2JKz5a1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOIaR9k027288;
	Tue, 25 Nov 2025 07:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b896sJ
	ZZMc2+LtYePPEd5eL5buUnbpg4X5zsSQ8nhyU=; b=V2JKz5a1aqXlIdWGUdJwYX
	uw4DlimcEcof/Oi6M6RtYYgXRU+yKT91UW0ZgTP59An1ZdTcHBg3IxFroqgiqEOO
	RdO2sciHuoxatJSyFaMNEFt/+q7GRKkFzHmANFZfgfAYbzMUQFwXSI3enB0ZY+RC
	mGWEc9DB0gack9NSPmVeo3cCJPFMv7fOUl0Fbi74QAQm6zEO88pf+MjXB7QCUk5y
	xw6/nPK8/zOZRhIvYer+LxF95pQnUQm5t9lwiVz1XWnkE4yvMhq814iFd2duTtex
	IeXNT5m6t3rQGoqgu6sB21PxDQEYJ9Dr08ZqgEDkcug8pHQ1pH2twYwuJbece+Cg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4phv4e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 07:46:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP5qFZZ000857;
	Tue, 25 Nov 2025 07:46:32 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvxtg8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 07:46:32 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AP7kUg719464954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 07:46:31 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5FEE58052;
	Tue, 25 Nov 2025 07:46:30 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43DDB58056;
	Tue, 25 Nov 2025 07:46:24 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.150.29.34])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Nov 2025 07:46:23 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Tue, 25 Nov 2025 18:45:54 +1100
Subject: [PATCH 3/3] KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK
 functions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-s390-kvm-xfer-to-guest-work-v1-3-091281a34611@linux.ibm.com>
References: <20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com>
In-Reply-To: <20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com>
To: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAxNiBTYWx0ZWRfX00daICIbwvWJ
 V8ecsC7YYveyP4xYB7WWjYlaHAG1DIK8wf/KAiFs3F6obdP76S683to4ct5pG2MfRrEQ+k9RWSf
 UbODdeaQfIQZfReUxa0YhueaJqI7Scxt/YLvY7RtL51QyjMH1hBVMESpFJuS+g531n/yQN2jdXx
 xOVVW2/Sw13c59Cg49resFGugxsGBAo1iQsjyTiQOyZdwt75m+AHCC/pqH+4XbYDyLK7pl3fJod
 gkIOhTbh7XFdOmc5daK22N++DaogxF/IdoLswgG3QSODtvQrqtAFT04SJ4U0KkeLWbepj9HdmoR
 tstUCUztsx2Ka5dhA1Qb0QJ8Sb2DRJol4TtMTLxHMREI0cArYXCs2lBj9Rw8iy4gabBxUE3tpN9
 5eCEnS4xT6XdMT2xoLOhzihjnhUTvg==
X-Proofpoint-ORIG-GUID: h3-qIqpxB78b35zH-XeSy5HvJ96MUbzq
X-Authority-Analysis: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=69255ee4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=1US_Z202mYDpc0AvFX8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: h3-qIqpxB78b35zH-XeSy5HvJ96MUbzq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220016

Switch to using the generic infrastructure to check for and handle pending
work before transitioning into guest mode.

xfer_to_guest_mode_handle_work() does a few more things than the current
code does when deciding whether or not to exit the __vcpu_run() loop. The
exittime tests from kvm-unit-tests, in my tests, were +/-3% compared to
before this series, which is within noise tolerance.

Co-developed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
The way I've implemented this, I do the check between vcpu_pre_run() and
entering the guest, and bail out of the loop if
kvm_xfer_to_guest_mode_handle_work() returns nonzero, without calling
vcpu_post_run(). My impression is that this is safe, but it does mean
there is an sie_enter vcpu event and trace event which isn't matched with
corresponding exit events. Is this a problem?
---
 arch/s390/kvm/Kconfig    |  1 +
 arch/s390/kvm/kvm-s390.c | 25 ++++++++++++++++++-------
 arch/s390/kvm/vsie.c     | 17 ++++++++++++-----
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index cae908d645501ef7eb4edbe87b8431f6499370a4..0ca9d6587243c98034d086c0ebd4ef085e504faf 100644
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
index 3cad08662b3d80aaf6f5f8891fc08b383c3c44d4..759158695bcdbb7c96c9708b2c7529d6e4484304 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/compiler.h>
+#include <linux/entry-virt.h>
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fs.h>
@@ -4788,9 +4789,6 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gg14 = vcpu->run->s.regs.gprs[14];
 	vcpu->arch.sie_block->gg15 = vcpu->run->s.regs.gprs[15];
 
-	if (need_resched())
-		schedule();
-
 	if (!kvm_is_ucontrol(vcpu->kvm)) {
 		rc = kvm_s390_deliver_pending_interrupts(vcpu);
 		if (rc || guestdbg_exit_pending(vcpu))
@@ -5095,12 +5093,12 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
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
@@ -5113,6 +5111,16 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		}
 
 		local_irq_disable();
+
+		xfer_to_guest_mode_prepare();
+		if (xfer_to_guest_mode_work_pending()) {
+			local_irq_enable();
+			rc = kvm_xfer_to_guest_mode_handle_work(vcpu);
+			if (rc)
+				break;
+			local_irq_disable();
+		}
+
 		guest_timing_enter_irqoff();
 		__disable_cpu_timer_accounting(vcpu);
 
@@ -5142,9 +5150,12 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_vcpu_srcu_read_lock(vcpu);
 
 		rc = vcpu_post_run(vcpu, exit_reason);
-	} while (!signal_pending(current) && !guestdbg_exit_pending(vcpu) && !rc);
+		if (rc || guestdbg_exit_pending(vcpu)) {
+			kvm_vcpu_srcu_read_unlock(vcpu);
+			break;
+		}
+	};
 
-	kvm_vcpu_srcu_read_unlock(vcpu);
 	return rc;
 }
 
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 347268f89f2f186bea623a3adff7376cabc305b2..3a5219d0587343c2d0ea17adff356ad3284a5f33 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1181,11 +1181,21 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	barrier();
 	if (!kvm_s390_vcpu_sie_inhibited(vcpu)) {
 		local_irq_disable();
+		xfer_to_guest_mode_prepare();
+		if (xfer_to_guest_mode_work_pending()) {
+			local_irq_enable();
+			rc = kvm_xfer_to_guest_mode_handle_work(vcpu);
+			if (rc)
+				goto skip_sie;
+			local_irq_disable();
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
 
@@ -1345,13 +1355,11 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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
@@ -1483,8 +1491,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
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


