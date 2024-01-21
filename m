Return-Path: <kvm+bounces-6485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 044AD835573
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36B021C21030
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 11:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E01376E9;
	Sun, 21 Jan 2024 11:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMke3DRS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34852374F9;
	Sun, 21 Jan 2024 11:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705835896; cv=none; b=Fop8lKDF8NUXBpmrr80tUHNEuYsfliLJdrf09Aq84DDEf+tZVTDSyi7zrz/MS+Yhch+uyHgvaelnAVj4oSBlyO7ABKMbE2Lghr24xPZfKmNePL3khvRnl4mKLu8d0RMwBWwWruqgYpdbK8UJlHuauqHTNSZPJH0I9dulhwUxw2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705835896; c=relaxed/simple;
	bh=txReBV8YLfbycPKHMIbc4ms91KN7No+Dt+T6VWaXX3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h8BUn4iRd6jY427K/VFf9m2IKn3gXN/1tprjIqRiYFWw1D1zahCJsNZEJiY5StFWgAnAiAbq3dszx4667/iZdWsMWt37mMrNDvH9Yo2yDovL5HM6U0mB0jX3EOgGwkZTgtnIUjdsedxT4TjWHVDIOd2dABJfMLcK2//mh2YNkSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMke3DRS; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d427518d52so15843075ad.0;
        Sun, 21 Jan 2024 03:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705835894; x=1706440694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lb7WkWDV/HzZrJOS35uAIlLaaoEJGaYIhNVQXCSUCs=;
        b=HMke3DRSOW7jNwK+dmK35FtZOwpZDncJKOUnGDK5YhpSRNGmdzj9Nym/LVN12aFpLh
         koFhAhjym3vhGE06ycdeCGD661n0rr9f+m4+8r1crfMfYXeKjYZBK/EPXyy6jBb8afBc
         f4EYWMoJ8B5nNhIj7mlg4fRQd9oKH3ydSFt17KP2dCQacfYGbI7NX9RXHC6CDSamTmqg
         UZMkm9mRZgQzSlxUQWlX1J3RiraGzVTTywsslYTFPvfnFSNYYfMQGq2E2iHaX6MGcVMp
         6kpIpu2Zpn3eL+T0loRBrgl4HLml+jxudgiu+vBmUBuNT1K5ndEEltRylf2Vbb1qG8AU
         mmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705835894; x=1706440694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7lb7WkWDV/HzZrJOS35uAIlLaaoEJGaYIhNVQXCSUCs=;
        b=qYdYRQYAJOFfZDmBT5ZhOZt/9cdmuf3GoO2NlYFAiw4ytrcTdPd8ilnaM3iAj9Y6cY
         wj7uiU3Jb+EtDHwXUvDuXnzILrsifCpBsCUJysQiWque5a0S8V3JCxeQJnDnuCqXCNeB
         pZvSKVapC1XYeJpe4DDG6ANsWSj0bTWDTtlhFzbHT+koMlbnw+agFqvoFR/gKN453abX
         U1+HCuX1IjfaOgIo8AQ5Dqte37W9StVk0DhCEUBmhmRAWiDtrKsOsjEkqvUWeAD7Jf8/
         OLOVu0QWMuG+vi5vok7sU8xu8ciS3K6Q71TSxYlvOkgyR4ti0ooeNhfr/VIO7dmKpPI6
         svBw==
X-Gm-Message-State: AOJu0YwkaM6N1/LlQE7vry6A2uAhQdWMrfydFiyjiIS4fnGenNt+76oC
	YoOkihD7USIsg3zf/cTD9pjpju9+VIrA7X7AGCCnBUECNb4U2ZJWHCljl79dOLgQnBGG
X-Google-Smtp-Source: AGHT+IF/gQgMXhHk/mQ5AIbqXFeFAbJqxFlkgCFixuupuRit8IREeRXsXfTvbSo5MCP1ldT3B4SClw==
X-Received: by 2002:a17:902:e883:b0:1d7:5ce:cc9e with SMTP id w3-20020a170902e88300b001d705cecc9emr5741250plg.33.1705835894344;
        Sun, 21 Jan 2024 03:18:14 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id jc9-20020a17090325c900b001d7233f1a92sm3560255plb.221.2024.01.21.03.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 03:18:14 -0800 (PST)
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
Subject: [v2 3/4] KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
Date: Sun, 21 Jan 2024 19:17:29 +0800
Message-Id: <20240121111730.262429-4-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240121111730.262429-1-foxywang@tencent.com>
References: <20240121111730.262429-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


