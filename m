Return-Path: <kvm+bounces-64608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FBCC882AF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE898352264
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41655318130;
	Wed, 26 Nov 2025 05:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VgN60Tj0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87EC315D52;
	Wed, 26 Nov 2025 05:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764135254; cv=none; b=V85zZ+WnxopJ3JnIrxK7V4pwHk/MFOry5v+g0k7u+TwydNHC+GYbUWZBB9UgULeIyhKRWQufvo2PLBLJpizHJw9vteBBzdhCuOlFfkSZDJQBpdsgpVRiAFQF2zDoBvq/Fb3aJ+qhYC2X6UcmCc5IRBstDc3dAMwQd1KPiYVM9hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764135254; c=relaxed/simple;
	bh=mvsPUYw0w62tnnRd2ffBoljZN35pTsYuxSRPWQOgYKE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IcMuLSfeH4Ob3q0uE0wV9fWi4QLZMWznji93LEkDN/5DlzBZK86ZrEoj+HPtxa8kYh5ztwU8P5+sKQAUBoH2PKsfcWR7zFLB0pc7ctr7TV1bdImOO8z3ieWPQt4EAKeFULjnilSG8DELEuFeahTueBGwdw6HXe1x+5b7TZpAqRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VgN60Tj0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ2pV17019516;
	Wed, 26 Nov 2025 05:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zB4xAc
	MiYelzi6x42LgM5Wevmiqhfyq40QPtY/piGtE=; b=VgN60Tj05AVW1AY1ONRzCS
	RRsahsJ07TEXsdzB2TfnxrXK59ud5iO3UlixZnCWShWFeDXa2kAwShyHJ3LdO2vg
	ozIaG6lemfhdBKK0hId6wVZ2+xLRU6nYoUMHQz9/jaOy9TFWg2uL62VtckbDHttr
	hXP1Sc4/NyPVgw5E0ZNQVYKcWOtIdq7lM+fMYlQHeQmLF6DmhWAwK8NrR3hIj+4j
	ZafTh+J9kVAx0ACC0EHwsdQADTVCDKKUCese81GYJs2oNUQ9ljL0wj5eMdhvaFUr
	SoFdVHZxB4/PKwftDa3ZLM77W1heSxIoFMFfHs2zQjwjuBqalAzsFLycRZZChz2w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4w9hxjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ5N4eW000850;
	Wed, 26 Nov 2025 05:33:56 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvy0bu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:56 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQ5XdUY25821828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 05:33:40 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7952958056;
	Wed, 26 Nov 2025 05:33:54 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96DF658052;
	Wed, 26 Nov 2025 05:33:49 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Nov 2025 05:33:49 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Wed, 26 Nov 2025 16:33:12 +1100
Subject: [PATCH v2 3/3] KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK
 functions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-s390-kvm-xfer-to-guest-work-v2-3-1b8767879235@linux.ibm.com>
References: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
In-Reply-To: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX8F8nKA15KKZn
 PX0ZlCh87w3gCS7lxVYECU5geieLAVxcj09JPCOydMji1E6LX5+kxHxzIWUmxj7Y4HrMd7kwooc
 olKD8gU8pWh52N6wpCZ8X9Y50NcLbpx6snuMxW/snPFHWsuD85HT8ygzEWdNR5vv8GNtOvfgsT9
 Ayo/4L5+HRCGNQ1uQjX6LlF9Rn6R/SUqOoyLNQO1nRb/KXpXjHlYT3e/bf9rOGZC5Q270dLRdOr
 OLVkE8XDaHXjb4lAlYPMfORPNFZeJb6+dl3d8tPt7+qi40i6kffAVegI74S/zN6OjSbZ5XgqoP9
 X7u/6K8OGlnslrofwmX15RMna/drLDqXDIua76cOqhzQr4rRw6tBzrjPIlCZxFAvKE3wR77g2lm
 eAjVpOqzgaI8aAsqGkfkQD9uGVwEqQ==
X-Proofpoint-ORIG-GUID: cneRE04g3fUgAnHLqyjRIqOo7Q8-l-uH
X-Proofpoint-GUID: cneRE04g3fUgAnHLqyjRIqOo7Q8-l-uH
X-Authority-Analysis: v=2.4 cv=TMJIilla c=1 sm=1 tr=0 ts=69269145 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=1US_Z202mYDpc0AvFX8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

Switch to using the generic infrastructure to check for and handle pending
work before transitioning into guest mode.

xfer_to_guest_mode_handle_work() does a few more things than the current
code does when deciding whether or not to exit the __vcpu_run() loop. The
exittime tests from kvm-unit-tests, in my tests, were within a few percent
compared to before this series, which is within noise tolerance.

Co-developed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v2: if work is handled, recheck for outstanding work with interrupts
    disabled before entering guest (Heiko)

The way I've implemented this, I do the check between vcpu_pre_run() and
entering the guest, and bail out of the loop if
kvm_xfer_to_guest_mode_handle_work() returns nonzero, without calling
vcpu_post_run(). My impression is that this is safe, but it does mean
there is an sie_enter vcpu event and trace event which isn't matched with
corresponding exit events. Is this a problem?
---
 arch/s390/kvm/Kconfig    |  1 +
 arch/s390/kvm/kvm-s390.c | 25 ++++++++++++++++++-------
 arch/s390/kvm/vsie.c     | 18 +++++++++++++-----
 3 files changed, 32 insertions(+), 12 deletions(-)

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
index 3cad08662b3d80aaf6f5f8891fc08b383c3c44d4..34a4b8d112d4d2572336200feff04ea395fa70c6 100644
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
@@ -5112,7 +5110,17 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
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
index 347268f89f2f186bea623a3adff7376cabc305b2..fb630fba822efadbdb959ed646b45f00e138898f 100644
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


