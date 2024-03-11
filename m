Return-Path: <kvm+bounces-11533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6E6877F06
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 12:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E374FB2103A
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE5F3D54B;
	Mon, 11 Mar 2024 11:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3RebpOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52383CF51;
	Mon, 11 Mar 2024 11:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710156753; cv=none; b=CLuqdzdJHb3iztSWRpsMSrLnvuuJzTbPSTObSG5AY4SBFAjpPkdyAmKCz9SoXOvrOMF8k9ny4LKwgIRdSYupCKXNDbxK/z++mIHUld4Sf2AoRlSNp/0B6bA5QyB5ix7QEzfGRiW+ljE99EpADp/Y5+a50n/8POV1iZd30QKRva4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710156753; c=relaxed/simple;
	bh=3sEdjEL+tkd1dbRFZxB/NJD7ePvvslMMkcgCmOt/36g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HFPhnAaC0MeEycFhDjz8TeZeFLXti/WwImEl2PGiFBwKRAW/MsfixYtgDsu2jA5Bf+a45djeQq7LqNZ8z1cV+0Fb8K9fEMfT7pqpw8QNGTPdRSltQk8nyKYV4XLhb5ZSipRdZzLtK+WjerZMUu+RwPyad5QWFJEEEijMvo9Lu1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M3RebpOB; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5cddfe0cb64so2790312a12.0;
        Mon, 11 Mar 2024 04:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710156751; x=1710761551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3JU5aZVast6q5cUP52RH6r2ifyqeB+uHpySlMSxkBA=;
        b=M3RebpOBeqoUR/sVYQcyL3SomT67izvP/5tIZYnx1+j1vcTOQPCa2NgY30wbrdbP1V
         yQDUFliZEfEE1xcOD86kyNryKOxIrPYgwHU+sAiEyJ3fcb5xjKE3CiIBuPIb0rT4LtII
         691Faizv2Q7STNWGqOpq+bClXIdfraoR4waZzdRbgJid/t5EZ3yImbv1NvpOfKC20Ue9
         skrvmm3IBgpf5d4qklaHZsJ+uZgXYU6sUvn31sYYuwwMWGy65z/4bRFOrp8F5FEemXPb
         7b7rBtPZIGgtEUqNZ6JYHlcmJpingXJQ6mgWpeI9t38k3yLfTTBoy+cv+eay2z9pA3wc
         N5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710156751; x=1710761551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3JU5aZVast6q5cUP52RH6r2ifyqeB+uHpySlMSxkBA=;
        b=rToO48cwSvc2KRmLnGy/SkFMj5T6hh0Q9fDzLH6b6A6dxqa/VzPb/Xc1B/oQJBWgQF
         h6ui+0pS0MPm5mKCHZ/hnrBjVVPw5CNsONILf08G5DoEq5qL6AfceGHhlN/LjaqvLLVM
         mahUYsHg8VzyMExUjAL6y6qKsZiJrJ4W2osLnh/a/Iq5qpp6Nv8+of0Tw5cMvbrK4Yc2
         z6zkGyO/nWnjCMA9uy0VUMu/5013dS8jdg7lwcKna7B2ef8iXMdxVSCrTXmoD0iGAFAD
         YOTss7X9i4TyyyhMMncCP77B7LR0SlbR9Houc+azS+cxWsP6rtTuLRzkeYnXjfPRLOu4
         7flg==
X-Forwarded-Encrypted: i=1; AJvYcCXPyhGWgQ5Iqj58JUb5BgrMqganA5NYDDRkimqyptBPTVJSrlD+YHFBLIDNkMI2aipZeExZyL9oN2jHjE+4dJ4rkG6AamJO97C73I5WqEJTa5waDCP175iS3IWDWW7UiZJf
X-Gm-Message-State: AOJu0YymxbxWLeVsUuvCFXwHQojQutRNTrA3Vv6VxNsy9wRRugYMCr8z
	As+wrIJJbnYLC9GI3WGGcL6AKicBJFObZ3YWa4p+n0RxAtbSGo8w
X-Google-Smtp-Source: AGHT+IHz0N2BBDbWdYc/8vLSpVARUc7036/e9bEWp0kWpSelBoS3upTUjz06uJZuk7nrWpLCeCkerA==
X-Received: by 2002:a17:903:1c4:b0:1dc:5dc0:9ba with SMTP id e4-20020a17090301c400b001dc5dc009bamr6012865plh.26.1710156750853;
        Mon, 11 Mar 2024 04:32:30 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902e5c300b001dda32430b3sm1459042plf.89.2024.03.11.04.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 04:32:30 -0700 (PDT)
From: Yi Wang <up2wing@gmail.com>
X-Google-Original-From: Yi Wang <foxywang@tencent.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wanpengli@tencent.com,
	foxywang@tencent.com,
	oliver.upton@linux.dev,
	maz@kernel.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	weijiang.yang@intel.com
Cc: up2wing@gmail.com
Subject: [v4 2/3] KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
Date: Mon, 11 Mar 2024 19:31:45 +0800
Message-Id: <20240311113146.997631-3-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240311113146.997631-1-foxywang@tencent.com>
References: <20240311113146.997631-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Wang <foxywang@tencent.com>

We found that it may cost more than 20 milliseconds very accidentally
to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
already.

The reason is that when vmm(qemu/CloudHypervisor) invokes
KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
might_sleep and kworker of srcu may cost some delay during this period.

As we have set up empty irq routing when creating vm, so this is no
need now.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 arch/x86/kvm/irq.h      | 1 -
 arch/x86/kvm/irq_comm.c | 5 -----
 arch/x86/kvm/x86.c      | 3 ---
 3 files changed, 9 deletions(-)

diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index c2d7cfe82d00..76d46b2f41dd 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -106,7 +106,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
 int apic_has_pending_timer(struct kvm_vcpu *vcpu);
 
 int kvm_setup_default_irq_routing(struct kvm *kvm);
-int kvm_setup_empty_irq_routing(struct kvm *kvm);
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 			     struct kvm_lapic_irq *irq,
 			     struct dest_map *dest_map);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 68f3f6c26046..6ee7ca39466e 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -397,11 +397,6 @@ int kvm_setup_default_irq_routing(struct kvm *kvm)
 
 static const struct kvm_irq_routing_entry empty_routing[] = {};
 
-int kvm_setup_empty_irq_routing(struct kvm *kvm)
-{
-	return kvm_set_irq_routing(kvm, empty_routing, 0, 0);
-}
-
 void kvm_arch_post_irq_routing_update(struct kvm *kvm)
 {
 	if (!irqchip_split(kvm))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e02cc710f56d..eee3a0892137 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6469,9 +6469,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			goto split_irqchip_unlock;
 		if (kvm->created_vcpus)
 			goto split_irqchip_unlock;
-		r = kvm_setup_empty_irq_routing(kvm);
-		if (r)
-			goto split_irqchip_unlock;
 		/* Pairs with irqchip_in_kernel. */
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
-- 
2.39.3


