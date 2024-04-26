Return-Path: <kvm+bounces-16017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C738B2F5F
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 273681F2126C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 04:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01307839FD;
	Fri, 26 Apr 2024 04:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e+VWwqlh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC23A8288A;
	Fri, 26 Apr 2024 04:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714105000; cv=none; b=DWAbTWOzpjdPt4TH9PhADAlL0Jsj5xGX270LQ+nU6MucGtFdlHAi1KTCvDfu9NEQlsMSelPMoX/zGxdLpy2dcJSDKKdk8qvH69hHDNcjvSciP8kyS4sPAt5jFftdK3RaPn68Fgt7Vx04aZumZNpBwHTADpgrGQEVe4+mA+n4iYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714105000; c=relaxed/simple;
	bh=ff+g84K7inAIdzVwporLJbQLKqNwcOlgSp3tPVrcevA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YqwiOILneZM9lJCo87yH4f528lRo9H5/vNtRLFQEdM6Wkejn3I1LYqJIGnRP6d+DBPh2DCddy/w5Ezi1ahvRWcfy4BbRFecy0S6XvQbArAn3Adbaq08JgMhePS34I+DucqH9mW6E1ZnziQ++ewdcFc38TMaXC0uaRdtPuKjlrS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e+VWwqlh; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e86d56b3bcso15836145ad.1;
        Thu, 25 Apr 2024 21:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714104997; x=1714709797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kpDmc07j9B+bsWzL0IUg31Cez5Uca1vji9WOl0EX0Q=;
        b=e+VWwqlhZB3sTU+LLFx29DJnuMjs4THTFs3wpFdthmuoTlI48Z6PjLsptd0JU7j55V
         T0LnhfxRUeU69Ba0plL9vA8F4j7asqt+IkusvJdWfqP8dI9c69RjgAZK07Bzeib3xBri
         u5Kxcq1wdJBCEnvo5DW4W0oMJyqlPdb38EwIKRYDvXAkjnJ/o0tco8rq+pwDl+kOMFhc
         JZsRqfrmqHEXcYmx4PJqltO1ECMXDNJHPmevnpui/TIUEG9aYoGyZJ9Ry7n3tLi0XmZC
         jTRHJKa+0EW/BAs+w/7TYSRfneLHz1q8lu04ptAEg4zuFpmsyyrStzUy5ZVIIN5AyZ5c
         GFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714104997; x=1714709797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kpDmc07j9B+bsWzL0IUg31Cez5Uca1vji9WOl0EX0Q=;
        b=FmDrkUwxTAtHqc3luC0x4sagK8N3/7d9U6atdj7/f+nV0mig5SkKf3wm+pW/JjzjQU
         Zr2oLDemVo6fEhID8tsgIBoqiuurUfkxpE/toWl5jKMrzXz7W8PRO+XYFErVXM42IgEV
         lCQaY06pND2rdSkG3NDoEGbuWG4Vwg7feZjb8cnzJDgsx9RSi92c8Ujg7eBRPMotLcr2
         C4sRPnKZT/yNgfomWDNsRfnrSBVkjOOmzXbVVANF5f7AA1wxjElsqUA0uRP34XsFesYB
         RZMFy3jAlnSfsjkoPM26Cjbw+E93KGjqf/77mSGO6sQnmF32ttMVKB8ph1UXzOY+8BSB
         70IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh0HAgzlvmIBzLLI0uqVpf5hqlIZJHg1kkwAE+OGZ8fWhiRxq0SB2SNgcxESOWSWpTAPehOlNHtzrW9JG21ndEjtJwo/Jz7+4UpWH51WinzWBUCWB2QOOa0HcQWGL3aWVE
X-Gm-Message-State: AOJu0YxqA09b4hkQ7SxXbWR9ZU6AUJGx3jer+Iief8Bf5O7hKXkOy55c
	I97CpTn0ix61gphdWLVmZCFwdkRgIfvoEY2+yj0Zooce23rSQSE+
X-Google-Smtp-Source: AGHT+IHcIzbPlTZjAQRVHlRvpqRHxQ5QJteedLdEq3Fm1shILV1ZygbVzKpk0l6Yi9wINhdbThGNNQ==
X-Received: by 2002:a17:902:a383:b0:1e8:26e4:d084 with SMTP id x3-20020a170902a38300b001e826e4d084mr1435914pla.60.1714104997033;
        Thu, 25 Apr 2024 21:16:37 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902ec8d00b001e9684b0e07sm9426780plg.173.2024.04.25.21.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:16:36 -0700 (PDT)
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
Subject: [v4 RESEND 2/3] KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
Date: Fri, 26 Apr 2024 12:15:58 +0800
Message-Id: <20240426041559.3717884-3-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240426041559.3717884-1-foxywang@tencent.com>
References: <20240426041559.3717884-1-foxywang@tencent.com>
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


