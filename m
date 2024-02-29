Return-Path: <kvm+bounces-10425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7067E86C16E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB2381F24451
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90D847F7C;
	Thu, 29 Feb 2024 06:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkcnJtsj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEB44779E;
	Thu, 29 Feb 2024 06:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189634; cv=none; b=kuS8ay/xPh9Ks0hEnNU01Ry6EJndcdTloM0Undn6tDoZbQwhmVqA2tPEOrbIjhiv9hXXuSZ68V+NPGAMnAwrE9DLrMVV2KWLd4YpmM0tmmnlUX+BqFUjDQBZLkgrqQwHVHVHqRVKgPl+YwTBj1GLFjim6WKmdsQEEq/RLhlmnkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189634; c=relaxed/simple;
	bh=wLkR7aEG/EhxVLXUVeeUJKpIDRx2DyXyAakTyAkuIO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oRGqGoPhwMCqB6wnCcdoQriWjNbYgnprknXEU77mUIIyy6LdOJPO+deG0qD7NoBt85XaqhAPB9NA7kMctvZO1RqOeTgxUVn+jHr3Uaop+1DAh92in7+X3msMr5xBPChyyeTaD7BzJahN4xbfSkCy0ASGjKC1y1dUhdkX/McNtGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkcnJtsj; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dc5d0162bcso5874685ad.0;
        Wed, 28 Feb 2024 22:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709189632; x=1709794432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPGkmifTwwHLgO5fJhv34X15SDCvJK/C4nnS1+TZMW0=;
        b=HkcnJtsjwpxsYl71eefUiGDDqfww2cmp0ycPhXwhw5oddEVbQTjCpHZuV8xGPrmjDA
         fDz/I4Y97eI6G4vPLhO3TW5UtXE5AEQCiiDrD0pdwtTFqXcEPHqbGl0B7lGrAzLWoTYF
         rGtXKynki3WJSBRUQ2ibFwNTfoPiurI1e/qkoXCBBxNEw7XoEbssLtAZIxU0KLI+PvbI
         1X+HZWVTuV2GpOTB7ViQ66ABtazfOCXB0SZP4yYsUr7kVTwhPjoGyIdZ/R5ZTALZf6dv
         NGCiwtscXI7MrFKjkGEHPQId/6mw3fCRJwSdK4Q6+u+rzjboCIJuaU3WbLQ8XhwR2+si
         GoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709189632; x=1709794432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPGkmifTwwHLgO5fJhv34X15SDCvJK/C4nnS1+TZMW0=;
        b=ba0qw5vqQkbGntBWVlMn94OPfyooejUsxddIyTKBDCZqQvlbj9yZRqypYqAugREsEf
         6vHXtQUrsXRlp5zx6oJAKVZlQ3dtbATGsONSGmDLtnopEO37ZAWZ9VLPCxlCGD0x2wlp
         txhk3sP1gpS+mJtuKQKmOACXfKUA6ERNFgd5C6JYSF1skd4QY+xkQBh/v/6MGTknzKsb
         9zRC+yMxAf1mAx4KzSpRyxx5B9sEP18X/wZ+gsHt/2pX8H04VV3/flqIFs2CYRDxG3nM
         K1qed/RcyLKKAkgN4VgDYK9Z6/guOG4TNIUVjTd/+7a4vedFzwCbSSKdKrayGfSTJxww
         OpXw==
X-Forwarded-Encrypted: i=1; AJvYcCWwv1d+mFdok01j0WSVDFDe17zBpgP6g6yJphlIKZTmYVBzuvdnzNahswk6AKfP8hVNzDednjDm/7zrQJhbLBTb1aDMIOI5zgrsj6KGE1vEj+EEzW+exVMJtUY1GyGgFjUM
X-Gm-Message-State: AOJu0YwWeTcQ7QpBC2W0b2+AVKpVpc716aOAmZqpaQOI0R9VrhvxLJk5
	5+aW9YZT521KRruZ4/DoubiFJ92sN2UWbXzt+0rk7cBF/ezDDyNT
X-Google-Smtp-Source: AGHT+IEoVX+qNwQIdAZwon0zsOUV+m9tJa1G03TE/+hKAZWcCwptiImQH4ixo0jkpb35EouxZiB2WA==
X-Received: by 2002:a17:902:eccc:b0:1dc:7b6:867a with SMTP id a12-20020a170902eccc00b001dc07b6867amr1473111plh.21.1709189632045;
        Wed, 28 Feb 2024 22:53:52 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001dc0d1fb3b1sm610509plh.58.2024.02.28.22.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 22:53:51 -0800 (PST)
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
	imbrenda@linux.ibm.com
Cc: up2wing@gmail.com
Subject: [RESEND v3 2/3] KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
Date: Thu, 29 Feb 2024 14:53:12 +0800
Message-Id: <20240229065313.1871095-3-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240229065313.1871095-1-foxywang@tencent.com>
References: <20240229065313.1871095-1-foxywang@tencent.com>
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
index 16d076a1b91a..99bf53b94175 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -392,11 +392,6 @@ int kvm_setup_default_irq_routing(struct kvm *kvm)
 
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
index cec0fc2a4b1c..6a2e786aca22 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6414,9 +6414,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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


