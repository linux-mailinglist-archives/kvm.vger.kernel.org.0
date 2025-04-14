Return-Path: <kvm+bounces-43238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB342A882FD
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 15:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 288063B30F1
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31AE2951D5;
	Mon, 14 Apr 2025 13:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkYXQxVf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68022957CC;
	Mon, 14 Apr 2025 13:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637333; cv=none; b=eutSjdfYbcq2DE3oSvLtCpCM2BVoWeJ80iHbucxsL7yvDyQLdZWnCDHhuH+UAqcuDCxNCZt4ygOw4AwWG5KhuSC9XPv25d+BhPUmDuPzgv0CL9ScW2YPk/3dMJarRZRagFPHVzqWEP/r0402wwujBVuNG0/JgSPR/wLtCvF9NA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637333; c=relaxed/simple;
	bh=36JVFDFvQfpm6HGHntZUrBhb8aeuTf4lVyVy5/Wj5Tg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OR7fR8azJAyD2bhVeN2trp4u2UGbU4PgRT3BR6pYgrRGP9uZyDd4+x92BU9tyyoUeo2pm7hBwG/58F4l9NDoBqJ3H00jV1CAIfzep/CVRG3jczgnd0KcDLghiwPzjj1Pp2gVQhfsA5H7uibASCSQ+BxDAbiWNgnX61bGAWElP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkYXQxVf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF202C4CEE2;
	Mon, 14 Apr 2025 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637333;
	bh=36JVFDFvQfpm6HGHntZUrBhb8aeuTf4lVyVy5/Wj5Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkYXQxVfo05uBpMb4D/8gLazwrbNFlnvfIEzwJJGzXbFWdj94gT7xyqPJbNHvIdXo
	 EjDOhr4AFxGX1PzUgi2zGaNSTdGQXbf5v8H2/1j/or9vXxIZQEm4Wx7nkTz6M8Rthp
	 aVmbW/AM7yrWBea/INP7XblwlfwfsQGlrtc8uq2mffSRtSGMwjIOBD5z7ewvxTd5Uj
	 o8fGt74z/YpUY0h7yeueTTAquctcapW2CjMRp7Zgh4BEU3EQO+rXhpcUaG3zQvrfo4
	 M2Yf0i2WvHNP22DfwsMLZh+aPGSgU06PgkQjROLy6ajoJrzdGRZ1AlKl8qtByrp0pj
	 nWQDaGk13qSSg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Michael Mueller <mimu@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	borntraeger@linux.ibm.com,
	imbrenda@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 02/30] KVM: s390: Don't use %pK through debug printing
Date: Mon, 14 Apr 2025 09:28:19 -0400
Message-Id: <20250414132848.679855-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250414132848.679855-1-sashal@kernel.org>
References: <20250414132848.679855-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.23
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 0c7fbae5bc782429c97d68dc40fb126748d7e352 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/intercept.c |  2 +-
 arch/s390/kvm/interrupt.c |  8 ++++----
 arch/s390/kvm/kvm-s390.c  | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index b16352083ff98..f0be263b334ce 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -94,7 +94,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_validity++;
 	trace_kvm_s390_intercept_validity(vcpu, viwhy);
-	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
+	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%p)", viwhy,
 		  current->pid, vcpu->kvm);
 
 	/* do not warn on invalid runtime instrumentation mode */
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 4f0e7f61edf78..bc65fa6dc1555 100644
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
index bb7134faaebff..286a224c81ee4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -998,7 +998,7 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		}
 		mutex_unlock(&kvm->lock);
 		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
-		VM_EVENT(kvm, 3, "New guest asce: 0x%pK",
+		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
 			 (void *) kvm->arch.gmap->asce);
 		break;
 	}
@@ -3421,7 +3421,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		kvm_s390_gisa_init(kvm);
 	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
 	kvm->arch.pv.set_aside = NULL;
-	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
+	KVM_EVENT(3, "vm 0x%p created by pid %u", kvm, current->pid);
 
 	return 0;
 out_err:
@@ -3484,7 +3484,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_s390_destroy_adapters(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
-	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
+	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
 }
 
 /* Section: vcpu related */
@@ -3605,7 +3605,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 
 	free_page((unsigned long)old_sca);
 
-	VM_EVENT(kvm, 2, "Switched to ESCA (0x%pK -> 0x%pK)",
+	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
 		 old_sca, kvm->arch.sca);
 	return 0;
 }
@@ -3978,7 +3978,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 			goto out_free_sie_block;
 	}
 
-	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK",
+	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%p, sie block at 0x%p",
 		 vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 
-- 
2.39.5


