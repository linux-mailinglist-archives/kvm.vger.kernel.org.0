Return-Path: <kvm+bounces-38372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C82FDA3845E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 14:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2548E17382C
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 13:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F33021CC5F;
	Mon, 17 Feb 2025 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PvCsAxiQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nwbvr9nH"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E042222D1;
	Mon, 17 Feb 2025 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739798047; cv=none; b=YZiZlf1Z3VLlkP9BXhNBF8BU9mXvIs6lI1AhqdC83ryMDIAzqEqEXb7pc5+3w/6s5Lrsj394XFAzCdRLybFhih4eMiTs0MUmF/w80xBFIaXFONCslEcvWXAEIKE37/NyF1hRNE3mwo8MVEeaSbHS6c5t/Cvoao2Th9i4qZCldGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739798047; c=relaxed/simple;
	bh=V3fyDC9yh0t3Fh0PUuUv/4heGxrfUlqLKpA6uL+w0kk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Zd2XM9em4CeOIT/McOofDSigVmDpAgc810awccxFzXRS/nHp17ruPqLsEnmqyOI1A2JKrJNIArTtRziV+gX8zz5FaoPVs0qvmTBhR30zdCD8dDYVSIiJCV6CWHiqPyhtDQarZ2d+Y5bqOQTMnaOW/98diam/GdmGtoZmRIPF9Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PvCsAxiQ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nwbvr9nH; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739798044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eM9xw7vIcTgt36ytjnZ1Bho9/6hLoGzSgqSRessB2VY=;
	b=PvCsAxiQYIWWcLZhAuvTUgX2Lv65VIjId6Hy1PxwX9w80QkHHhnN3S7VW4jUPlG1S/sdSv
	O1MTKCX4WuiKC6L4bzn5o9C1emMNXDc8MRSkeUkG7CcQXt3ljkR+aUWnBm0v9ICRXmztxa
	Y8dyr3drzkYS1aMaRlDu3Dkaew8ESVBaJyTPUlDebwZ0dr4xP5DeMpKDIwQ7KtUE0bY3cW
	gYkVr6C4RyOqYWBoB6RvmedS/WS5R9BfZgEdOouToi7LuQYItK2gGDlhPU3nPKkxEbAg9r
	y1DVNB65GfxifWatTRf5bg4uC7dwJMqqkXRPAwd5thagrF63uX40wLCb28eszw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739798044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eM9xw7vIcTgt36ytjnZ1Bho9/6hLoGzSgqSRessB2VY=;
	b=nwbvr9nHQBhr0hkCV/Uhor3DQRt54IoXFV3k6AkRtCqEINGN8eBdELtwV75yTJdRkoCxem
	IQbzUZWs3A5jUjAw==
Date: Mon, 17 Feb 2025 14:13:57 +0100
Subject: [PATCH 2/2] KVM: s390: Don't use %pK through debug printing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250217-restricted-pointers-s390-v1-2-0e4ace75d8aa@linutronix.de>
References: <20250217-restricted-pointers-s390-v1-0-0e4ace75d8aa@linutronix.de>
In-Reply-To: <20250217-restricted-pointers-s390-v1-0-0e4ace75d8aa@linutronix.de>
To: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@redhat.com>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1739798042; l=4553;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=V3fyDC9yh0t3Fh0PUuUv/4heGxrfUlqLKpA6uL+w0kk=;
 b=OWNyUZqdifbtLDnDqMyaC5mmBWRzP0pt/EKbD/tUNQUA6326/2vPIcFrOw628/rH2R3uxE+hp
 IGxB+I297ZVCV2MfTvmPbIq6upjfg7QDzkZomep8bXdASEPPDKZM+kW
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Restricted pointers ("%pK") are only meant to be used when directly
printing to a file from task context.
Otherwise it can unintentionally expose security sensitive,
raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/s390/kvm/intercept.c |  2 +-
 arch/s390/kvm/interrupt.c |  8 ++++----
 arch/s390/kvm/kvm-s390.c  | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 610dd44a948b22945b0a35b760ded64bd44ef7cb..a06a000f196ce0066bfd21b0d914492a1796819a 100644
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
index 07ff0e10cb7f5c0294bf85f1d65d1eb124698705..c0558f05400732b2fe6911c1ef58f86b62364770 100644
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
index ebecb96bacce7d75563bd3a130a7cc31869dc254..9e427ba3aed42edf617d6625b5bcaba8f43dc464 100644
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
2.48.1


