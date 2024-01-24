Return-Path: <kvm+bounces-6829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D6783A801
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 12:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85DED1C23778
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 11:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65AF24A04;
	Wed, 24 Jan 2024 11:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUYduI0H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADACA1B817;
	Wed, 24 Jan 2024 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706096117; cv=none; b=D4g+P6fCW4gbdM7+nbcM2hVZS5AiAhJkUXC7VAiXD2x/8W0YHdFXINIngDdWJ/yofea6K//mMlknC8b/345i1myQeLRZcjW8xWvcrLQhjiV6H0cQRLhlnd9TEGn6NxPXKYgDeVXcvIcbb3SvZhrBCHUec7xXrevb7VpbuUFvxQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706096117; c=relaxed/simple;
	bh=wLkR7aEG/EhxVLXUVeeUJKpIDRx2DyXyAakTyAkuIO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AiBUL0BNrIiPewaGeubPw41HWBED/MpVAGpmPO/lFFJfAvI1P4YWFvYV1tLGlzkL5664UOm09BgDUYH1INGljHrBhL3+ohmzBYcl6Ym+eZJ95YbZrDC/M1AzHd/icvnv4d56e4oyly88Ld36QoGSqiNYsBs3/mToyHaFyMQ1v1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dUYduI0H; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-599abffe3e5so774064eaf.3;
        Wed, 24 Jan 2024 03:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706096115; x=1706700915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPGkmifTwwHLgO5fJhv34X15SDCvJK/C4nnS1+TZMW0=;
        b=dUYduI0HKFIe4nPWpdmXnQuA0FN44OTI7lvox5tItLB9NG+IS+PpyB1td5dhIaMXX/
         e7acsTWrlHt8nWjMLWNi1vawgPXrMqp8AzCowmAnS0ZaWqPkSA3a27DgI0L82Dw7STR6
         ycfcVfq+V8DQRROzAPawrmNNWA9Ozoo/M/DqY2C83CnRe3lYA+PwT3ujgbjkMZzf6JQT
         2mCgLx2Q+/GFvhUT2mc92x7AKIscWsLfhEmp86CSuxRwD953+vghmPaEI9oLYhJi0Hou
         6fOd0kjBGDzI6nwzRiNlWl7eVFmRhBu39aDIwfElInROxpD52vG1QJwf53cEdGLiTPct
         FHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706096115; x=1706700915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPGkmifTwwHLgO5fJhv34X15SDCvJK/C4nnS1+TZMW0=;
        b=nVYPEXx9xQXLRMERyE50MhvcWIN3RXNmr4uMUxdZaBzcw9euBqG3kIFypg7dzZpJbo
         RqxuqM41DiiGMOPKng3b4oCBYY7t+hmUGG1x+j1Z20PHLv87ce3UJ2372BsMzpbJeDkR
         udGTsF3mwr1CbE8p7OGw0V7Pece9rT9Mlnx34MwXJoIAaa5cVR2nnA5BrVlsazEUojGC
         BdlksfHW9ENW8rJT4VjYn7VErcYUC4/zzkQluUn6+PtNiiPjWCiA5dlMRSKpcXdEsGCB
         WE4Ac811ncMiiYtcr7cOgwmPxo52KiKmK+/zqy1NeXo1X8BdSI9MnMmoY/MQmtn02KEG
         IBpA==
X-Gm-Message-State: AOJu0YyzXVbBgsQ+BmmXkU1SYIyaQP1Glunzi7deecIab7T3ezNURZMk
	M7ajC8n50cH/K4T+CbOJJqBBmxrC6P7mdcNWY9tx8tp6MtZmNehA
X-Google-Smtp-Source: AGHT+IGWjty74l8fVlCoR6RutAYoZpBySt69X9+suSm8CUshUTc6BYdpPnicibqzJe1IiFG6SXL2MQ==
X-Received: by 2002:a05:6358:2c83:b0:175:bfae:a564 with SMTP id l3-20020a0563582c8300b00175bfaea564mr6725058rwm.38.1706096114720;
        Wed, 24 Jan 2024 03:35:14 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id c15-20020a63d50f000000b00578b8fab907sm11727820pgg.73.2024.01.24.03.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 03:35:14 -0800 (PST)
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
Subject: [v3 2/3] KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
Date: Wed, 24 Jan 2024 19:34:45 +0800
Message-Id: <20240124113446.2977003-3-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124113446.2977003-1-foxywang@tencent.com>
References: <20240124113446.2977003-1-foxywang@tencent.com>
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


