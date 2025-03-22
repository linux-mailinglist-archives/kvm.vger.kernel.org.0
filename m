Return-Path: <kvm+bounces-41753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA6AA6C9DF
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 12:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F2F11B6620E
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE161FC0E2;
	Sat, 22 Mar 2025 11:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bW7iAb9m"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7551F1524;
	Sat, 22 Mar 2025 11:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742641946; cv=none; b=niEwORUghEnFHAWQ5ZljxnBzCoxXW4fkGpyTAYKkVO4uEbSzCcjNy4x+XLVVbApRn20lRgdjcGH5enM0TGN5v5UevSoiAbQLU7UsvX28OO2jSXfNO3no/+YKlqBCcJhaY0bbWYlZhpoO1XzTbbd0CpqlYwW90WtdiOB/2SObiko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742641946; c=relaxed/simple;
	bh=JVXJNKH7WrtAc7W+xempKIXjjNQXDAxAHhekerblCwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/knNxd9L6rGnGVUt6F4Joe1OoxspEudfWsucyuZdbrjdvQ+0kus3jjVsD59RK7U97ANkh0B83d6vG4CiGT+xmrvM+/e2VWB/gwuyBiQ3LXLGaQ26ok00vSQs9zGn3RMwFL+kxYDPWVkqw9ZNZkoxf1GdnhbdElqlRSkYprPtM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bW7iAb9m; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52M90GYJ017156;
	Sat, 22 Mar 2025 11:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Do1PI6
	9Mcopt2iyDNx88DfEMOD/pf0r79bsnTCDOt/0=; b=bW7iAb9mfl12+Qs2AKI1mB
	xPfJY+jvlVQwo5AfQIxNCd+LMtKAPaaN+s6ThF5H84O7flKf71PIL92f90MOQLgc
	rgBGKbLfwL8HjEBNgBm9i35epqpm1yupK8U/wzx5HBPu43q7BxL14TYjN8amLWal
	jEYjl5JjkPGk4toXVqymWiPoOMsjQkr3aWFl2/MD2DBf/JcunUZxcEJJMTVykjsF
	jZaBSUIyeqCqj1gQgr+fBqW3A7SQv/wYkSp5uH1mzcGOgD1UpDBZvbSHeCxQBXr+
	JgZkVMZujxoGCN3bnjmVTI3MwCBjJ0AhP4imNOilHLosw8yHSYjMuTiDrgB/T2Gw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45hngm93py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 11:12:11 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52M91j9E008309;
	Sat, 22 Mar 2025 11:12:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45hn89h8du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 11:12:11 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52MBC7NL53674452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Mar 2025 11:12:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 429F820043;
	Sat, 22 Mar 2025 11:12:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8A3E20040;
	Sat, 22 Mar 2025 11:12:06 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.47.152])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 22 Mar 2025 11:12:06 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [GIT PULL 2/2] KVM: s390: Don't use %pK through debug printing
Date: Sat, 22 Mar 2025 12:06:45 +0100
Message-ID: <20250322111119.24548-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250322111119.24548-1-frankja@linux.ibm.com>
References: <20250322111119.24548-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cw0MOm6I6O6r4fJD-9i74jmXVpQW7ywr
X-Proofpoint-GUID: cw0MOm6I6O6r4fJD-9i74jmXVpQW7ywr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-22_04,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 mlxlogscore=763 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503220080

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

Restricted pointers ("%pK") are only meant to be used when directly
printing to a file from task context.
Otherwise it can unintentionally expose security sensitive,
raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Tested-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20250217-restricted-pointers-s390-v1-2-0e4ace75d8aa@linutronix.de
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20250217-restricted-pointers-s390-v1-2-0e4ace75d8aa@linutronix.de>
---
 arch/s390/kvm/intercept.c |  2 +-
 arch/s390/kvm/interrupt.c |  8 ++++----
 arch/s390/kvm/kvm-s390.c  | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 610dd44a948b..a06a000f196c 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -95,7 +95,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_validity++;
 	trace_kvm_s390_intercept_validity(vcpu, viwhy);
-	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
+	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%p)", viwhy,
 		  current->pid, vcpu->kvm);
 
 	/* do not warn on invalid runtime instrumentation mode */
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 07ff0e10cb7f..c0558f054007 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3161,7 +3161,7 @@ void kvm_s390_gisa_clear(struct kvm *kvm)
 	if (!gi->origin)
 		return;
 	gisa_clear_ipm(gi->origin);
-	VM_EVENT(kvm, 3, "gisa 0x%pK cleared", gi->origin);
+	VM_EVENT(kvm, 3, "gisa 0x%p cleared", gi->origin);
 }
 
 void kvm_s390_gisa_init(struct kvm *kvm)
@@ -3178,7 +3178,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
 	gi->timer.function = gisa_vcpu_kicker;
 	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
 	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
-	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
+	VM_EVENT(kvm, 3, "gisa 0x%p initialized", gi->origin);
 }
 
 void kvm_s390_gisa_enable(struct kvm *kvm)
@@ -3219,7 +3219,7 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 		process_gib_alert_list();
 	hrtimer_cancel(&gi->timer);
 	gi->origin = NULL;
-	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
+	VM_EVENT(kvm, 3, "gisa 0x%p destroyed", gisa);
 }
 
 void kvm_s390_gisa_disable(struct kvm *kvm)
@@ -3468,7 +3468,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 		}
 	}
 
-	KVM_EVENT(3, "gib 0x%pK (nisc=%d) initialized", gib, gib->nisc);
+	KVM_EVENT(3, "gib 0x%p (nisc=%d) initialized", gib, gib->nisc);
 	goto out;
 
 out_unreg_gal:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ebecb96bacce..9e427ba3aed4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1020,7 +1020,7 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		}
 		mutex_unlock(&kvm->lock);
 		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
-		VM_EVENT(kvm, 3, "New guest asce: 0x%pK",
+		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
 			 (void *) kvm->arch.gmap->asce);
 		break;
 	}
@@ -3464,7 +3464,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		kvm_s390_gisa_init(kvm);
 	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
 	kvm->arch.pv.set_aside = NULL;
-	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
+	KVM_EVENT(3, "vm 0x%p created by pid %u", kvm, current->pid);
 
 	return 0;
 out_err:
@@ -3527,7 +3527,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_s390_destroy_adapters(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
-	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
+	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
 }
 
 /* Section: vcpu related */
@@ -3648,7 +3648,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 
 	free_page((unsigned long)old_sca);
 
-	VM_EVENT(kvm, 2, "Switched to ESCA (0x%pK -> 0x%pK)",
+	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
 		 old_sca, kvm->arch.sca);
 	return 0;
 }
@@ -4025,7 +4025,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 			goto out_free_sie_block;
 	}
 
-	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK",
+	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%p, sie block at 0x%p",
 		 vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 
-- 
2.49.0


