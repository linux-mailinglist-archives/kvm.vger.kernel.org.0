Return-Path: <kvm+bounces-16713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA5D78BCBCE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 12:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16D2E1C212D5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AEF14386B;
	Mon,  6 May 2024 10:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imoW8yWn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430E143727;
	Mon,  6 May 2024 10:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714990715; cv=none; b=dZ04TGklzP3rx4v/kFHFnyFQlP2wApNMoiJ1Rmx7XZU0Vc9StOSko+i7lhYiSKvikwPrqP8NMCJ2CJKG6vL8KiMLUFivUt/kPON8ZY1VnlQFOWkQR2JLETYGfPnK5GYoxnYEu5dTYeK6YCT5GCq3Z7xJ+wO/guL6i3IHHXzl39c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714990715; c=relaxed/simple;
	bh=ff+g84K7inAIdzVwporLJbQLKqNwcOlgSp3tPVrcevA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r2mr7T6UCrVJBtiBiGKGI1xzfwicDGgHfNbP9Pulil6cFjCWsxR90nGK7aJ73Neip/YpeFFCYh0QE9BtCLrP9c9CrokpRse1/y0FHozKjbGLZ6LQoaNKSXqAX3zUPGntmJA6lznX6jBtq4PHpepjVLJgkXm0hPCq9UxCEjpegEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=imoW8yWn; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2b2b42b5126so1596253a91.3;
        Mon, 06 May 2024 03:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714990713; x=1715595513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kpDmc07j9B+bsWzL0IUg31Cez5Uca1vji9WOl0EX0Q=;
        b=imoW8yWnVm3ideL/1IHMFfkVroBSNRUj5IPqzVNugWHoOcLz7SoG9YmPIKwQ4iXbwt
         /B1RxE8zwBXrU8WuYjIZzkmZX49/wn37D+asdHQ/sHCC142dVMfon+FDKGHZ7Op1s4oO
         MY129U+42/3qyrHAQgtTqfl91JbEHUVZlaZUXFb1QwvHm99c77rTR96DEsp60EXaLI9o
         iUXXIMbC+QI5xsMRaWqE8FbmqGpwqGa1rIy2dCU9IB2BFosI8dS+h+c27dl7foOQqxU7
         HIh3Jg8QnX86DyGqCwU5Z/rw0Nw/TaRPGzFxV7Qwxacec3Q/bC56IbQKHIrjyoSzlAu2
         mmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714990713; x=1715595513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kpDmc07j9B+bsWzL0IUg31Cez5Uca1vji9WOl0EX0Q=;
        b=PpJNlPyzuEDScLP7bha83IZMfyQDmgClDeK1s7HTXEned1IYstYEGIAT3vHeJPfTE1
         EHLUMShn4g5wCW9fKDx+VhA1JoJ/lL//RMbAyUANLCUQ+5W+oFWRtpx2WspliIraDXyY
         6UybWG5CL++LuyW5BQ4JMg4rHpTgFGyPtYbKZ+18GaC8CwLIS1f0jkldCXjtiKt0dWhN
         7D2N6Lm19ubklM7N/5F4sSCXqmnf39O52OIXeBJDc4a2oyA55aAybbufVze5apdZCv5b
         eImFKdGmhrGWC+wiWQRTZiKfgBwWRkJAlDZQVV/hHOkEWRERXQD0nXDDp3bByqdOtqaZ
         EHzg==
X-Forwarded-Encrypted: i=1; AJvYcCUKsgEPa93x3rW9o4MKX5tnte9cxPcRh14IcN/RzelsMlQwqxnWmjQFfJ3jNO6pm7oVKEgjAqzIG270jmn988MrQbCo7GrqD9anPmiqkHMErQqEqHIgZvFmdi1uEnMszOC0
X-Gm-Message-State: AOJu0YxP4JV2P7dOGIk6UPjJS0ZsAHXyqMyqntwDASZy87k9GgZyCy4O
	gefm9GWRjXNbbstsKzjmwAuQ5JgJ73qV6OLVi3OSOz/EihlXSGKW
X-Google-Smtp-Source: AGHT+IEUCmARAOaOm8tiHqB8SAbzVfrCzOTh7Dt11wYbbGJ3HynNT04r6tq4Rq0Atbzws3wyYjAHtg==
X-Received: by 2002:a17:90a:890d:b0:2b2:3376:b9e with SMTP id u13-20020a17090a890d00b002b233760b9emr8696215pjn.9.1714990713017;
        Mon, 06 May 2024 03:18:33 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id co18-20020a17090afe9200b002af8f746f28sm9747820pjb.14.2024.05.06.03.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 03:18:32 -0700 (PDT)
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
Subject: [v5 2/3] KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
Date: Mon,  6 May 2024 18:17:50 +0800
Message-Id: <20240506101751.3145407-3-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506101751.3145407-1-foxywang@tencent.com>
References: <20240506101751.3145407-1-foxywang@tencent.com>
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
index 91478b769af0..01270182757b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6527,9 +6527,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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


