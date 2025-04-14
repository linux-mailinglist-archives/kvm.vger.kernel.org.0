Return-Path: <kvm+bounces-43236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A3BA8829A
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 15:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D33023BB895
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 13:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23C227A11A;
	Mon, 14 Apr 2025 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaHGLPGw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ACC289376;
	Mon, 14 Apr 2025 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637255; cv=none; b=kjsKFhmE6CtOUXGmSFL4MOc+SbWO3gBU/oXG/HsK7ibRs+dE1kifcBVyUZd6bgTYUPNTD+ODEqxo7KBJufphzDDynx5HC64tyKsFzIEgODXK/qL0OcEKkVG+8lRw9rXm1Dm+SX/fv9AC7Fz3C/mzWd784GLkLJSDyGRESRVonKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637255; c=relaxed/simple;
	bh=jqoALahQrzBO6OZuSfkVAH7azoMusWA3N33iS+qxDdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rNqxm4L8Jnut7YDo0YnL5Sfi+UStX6YX9m34GfafgrMI8V+9yncEJ+Nk3aPu5DxEb9wGK007IDabw4d5nEb89VWyin4S5N0PlsGT2NR82OSRuZ8674J6N9+LIxQEk5wi+Vkd9Zxd6fbhCIkyWhPPwFqcQqiBzMI+xVP8iD2VB/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaHGLPGw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D16CC4CEE2;
	Mon, 14 Apr 2025 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637254;
	bh=jqoALahQrzBO6OZuSfkVAH7azoMusWA3N33iS+qxDdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaHGLPGw+37uLDcgU75gvo5nY1s1iL17HEdyFxkOQvVsR5HB5TEvfHaJklvgO/HjD
	 NIwM+la34k6Skw/HWW82GXp/cEhx3kPyPHALJhkEwTXnmPMY32yI7nFy+LEKJVefY9
	 rtBE+GT+5kP4PC2UpYZ/qg0hzew0aMuyqDbSmXto01eJ1UzozW9f/Lyhu1Ky+iCra9
	 3zo2zE4giIRpw5cc6koYXC9AS+4LojCfBCgEzGQFI9mxeKTR1mj7UleQXizoUY3BLE
	 m/xeCSnlsA5Ia2vWgFT5Rvt6jcgxDTc07e35eq+FmE00TbxLsJEiIzMzk8YFZv79CV
	 r6xUZlMQLlgkg==
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
Subject: [PATCH AUTOSEL 6.13 02/34] KVM: s390: Don't use %pK through debug printing
Date: Mon, 14 Apr 2025 09:26:56 -0400
Message-Id: <20250414132729.679254-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250414132729.679254-1-sashal@kernel.org>
References: <20250414132729.679254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.11
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
index 5bbaadf75dc64..9c4304d484de7 100644
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
index d4f031e086fc3..ad194055b5599 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3158,7 +3158,7 @@ void kvm_s390_gisa_clear(struct kvm *kvm)
 	if (!gi->origin)
 		return;
 	gisa_clear_ipm(gi->origin);
-	VM_EVENT(kvm, 3, "gisa 0x%pK cleared", gi->origin);
+	VM_EVENT(kvm, 3, "gisa 0x%p cleared", gi->origin);
 }
 
 void kvm_s390_gisa_init(struct kvm *kvm)
@@ -3175,7 +3175,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
 	gi->timer.function = gisa_vcpu_kicker;
 	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
 	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);
-	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
+	VM_EVENT(kvm, 3, "gisa 0x%p initialized", gi->origin);
 }
 
 void kvm_s390_gisa_enable(struct kvm *kvm)
@@ -3216,7 +3216,7 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 		process_gib_alert_list();
 	hrtimer_cancel(&gi->timer);
 	gi->origin = NULL;
-	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
+	VM_EVENT(kvm, 3, "gisa 0x%p destroyed", gisa);
 }
 
 void kvm_s390_gisa_disable(struct kvm *kvm)
@@ -3465,7 +3465,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 		}
 	}
 
-	KVM_EVENT(3, "gib 0x%pK (nisc=%d) initialized", gib, gib->nisc);
+	KVM_EVENT(3, "gib 0x%p (nisc=%d) initialized", gib, gib->nisc);
 	goto out;
 
 out_unreg_gal:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d8080c27d45bd..5b0f1645ac027 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1019,7 +1019,7 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		}
 		mutex_unlock(&kvm->lock);
 		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
-		VM_EVENT(kvm, 3, "New guest asce: 0x%pK",
+		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
 			 (void *) kvm->arch.gmap->asce);
 		break;
 	}
@@ -3451,7 +3451,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		kvm_s390_gisa_init(kvm);
 	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
 	kvm->arch.pv.set_aside = NULL;
-	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
+	KVM_EVENT(3, "vm 0x%p created by pid %u", kvm, current->pid);
 
 	return 0;
 out_err:
@@ -3514,7 +3514,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_s390_destroy_adapters(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
-	KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
+	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
 }
 
 /* Section: vcpu related */
@@ -3635,7 +3635,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 
 	free_page((unsigned long)old_sca);
 
-	VM_EVENT(kvm, 2, "Switched to ESCA (0x%pK -> 0x%pK)",
+	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
 		 old_sca, kvm->arch.sca);
 	return 0;
 }
@@ -4012,7 +4012,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 			goto out_free_sie_block;
 	}
 
-	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK",
+	VM_EVENT(vcpu->kvm, 3, "create cpu %d at 0x%p, sie block at 0x%p",
 		 vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 
-- 
2.39.5


