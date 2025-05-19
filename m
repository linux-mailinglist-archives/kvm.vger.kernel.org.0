Return-Path: <kvm+bounces-47039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8DF3ABCB68
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B0767A6E1D
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59DDB221728;
	Mon, 19 May 2025 23:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ys2gxZKo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3223221286
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697303; cv=none; b=jhvYQeQG2Tc6TLUuZOeSfwRtL+vVAy8nTiuZJ1q7RriEiBu21fBHnTPantf2MSxXs0MTznN4D7Q1xdgTyHVchNBBgGA+nJTEyyTYF7Djo80C0h6VoUD7xras+h3xFA8VLdHXLN0eXngD/YOx+x+Irh7A67Z4kFX9N6zPRZUlDTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697303; c=relaxed/simple;
	bh=TZGr2td1h33ko9T6IYN3lnbl4ki862/9brDQeg1ijGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N/64plZvu9RuKUuSL+eORaQdOemB4UMG4mZw262dYSjonURI9yrj/P25GdazHfxUvwt/7KERk26+ce9ADtA0f9L1kTx6Ou0/xVB02ybCr3gY5bt0QwMX95ChOulsJKCH4fQubgOVvsL9S6+xirFtvhkOd/TKUrtAnavWvFibMdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ys2gxZKo; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00e4358a34so2939167a12.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697301; x=1748302101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EcRbALdwTeGNvoC4govCYju6evjp/u15dHDXwG2KWSs=;
        b=ys2gxZKowIPfHh64xpMd0Y3c9QvzTQCgY0CQCfX5z9QSu5L11V0aY60T5dqnx2ZDmL
         c3ZYYpnanQ6KmAiDdpgZBiw3OMNCvAQWsWCIHVp3WS+phjxUz6VJkA6LmByLcY1NZq3R
         5/uh4KosuEGEnNyieSkoJpX8sHy400v1v7uGGUu+Z7vlBpgBew683oDV086C81pYUwl2
         MngmvTy3BclJmkypwU5DDbGy6EvCFuf9y7sDeyqOu+9zqTKsvunm7OvTgqA1UFqXfOK3
         H3VP1QWiMI4F/qfy4nPChkymmKYri6eSRWcVQ1QXr5LnY1zjAIkE6/YN1EzaCzVQJ/dC
         I//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697301; x=1748302101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EcRbALdwTeGNvoC4govCYju6evjp/u15dHDXwG2KWSs=;
        b=D5mQfIJsOjZYz+WdaiGIhpUIbf8U8uxdB0vj6iLjecHr+krHvKzAi/UUW4fUR4Wx61
         Qv3ZFCo7MKQ+QUy0pbVCQDfxV4Wwbb69k2cHwQcj/x05KHiLS/5MfiPUKSgMuzs9e+im
         g2WLm6qslJnwd1slAXupGnO64sOGdu5FlugyQEeJz6mQ4AzB8Eh2f+RrPMlgFFPlgVW0
         78XWaC8b7vmzqlqIDMptUFUv7KPnUIaF4VaaFGIxXEFCtWrxOgFNp50oKYgUQN7Oa+Cb
         wdij0XtmvNfrWFhyOcnsq9lT1MG9ezUNPqYXBWWdXBg+lTpgz6k+jU6ApENE1MVGZfDr
         2vGA==
X-Gm-Message-State: AOJu0YzFsq5ul4PV+4B77DFoosZG3387yYW5bEW64YO4D5Ba1FKm5ECg
	UXWf13fsX0wuMvc99tieCwLTh72bYnsFzZWE/eaIs4jkZ1nhZjVN94QqthqPrBzFJigLURlfeXx
	I9gq6Xg==
X-Google-Smtp-Source: AGHT+IF7+4b7yGtntkh4zoI53SgqpcYBnPjTzm88X0tIel2RclzHU5WAM3rg5ojEKoeoo+USix/wmVCrCBc=
X-Received: from pjboi16.prod.google.com ([2002:a17:90b:3a10:b0:2fe:7f7a:74b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d25:b0:1f5:8072:d7f3
 with SMTP id adf61e73a8af0-216219f04f0mr23522411637.30.1747697301306; Mon, 19
 May 2025 16:28:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:27:57 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-5-seanjc@google.com>
Subject: [PATCH 04/15] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop the superfluous kvm_hv_set_sint() and instead wire up ->set() directly
to its final destination.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c   | 10 +++++++---
 arch/x86/kvm/hyperv.h   |  3 ++-
 arch/x86/kvm/irq_comm.c | 12 ------------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 24f0318c50d7..7f565636edde 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -497,15 +497,19 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	return ret;
 }
 
-int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vpidx, u32 sint)
+int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		    int irq_source_id, int level, bool line_status)
 {
 	struct kvm_vcpu_hv_synic *synic;
 
-	synic = synic_get(kvm, vpidx);
+	if (!level)
+		return -1;
+
+	synic = synic_get(kvm, e->hv_sint.vcpu);
 	if (!synic)
 		return -EINVAL;
 
-	return synic_set_irq(synic, sint);
+	return synic_set_irq(synic, e->hv_sint.sint);
 }
 
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector)
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 913bfc96959c..4ad5a0749739 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -103,7 +103,8 @@ static inline bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu);
 
 void kvm_hv_irq_routing_update(struct kvm *kvm);
-int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
+int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		    int irq_source_id, int level, bool line_status);
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8dcb6a555902..b85e4be2ddff 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -127,18 +127,6 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
 }
 
-#ifdef CONFIG_KVM_HYPERV
-static int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e,
-		    struct kvm *kvm, int irq_source_id, int level,
-		    bool line_status)
-{
-	if (!level)
-		return -1;
-
-	return kvm_hv_synic_set_irq(kvm, e->hv_sint.vcpu, e->hv_sint.sint);
-}
-#endif
-
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level,
 			      bool line_status)
-- 
2.49.0.1101.gccaa498523-goog


