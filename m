Return-Path: <kvm+bounces-47036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F24ABCB61
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 818937A113E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97313220F3F;
	Mon, 19 May 2025 23:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CgI3bHOw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D6C21FF51
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697298; cv=none; b=k6jtfwMV+e6x2NytyYHoxnLjpcGP1DozR940uVQujOsrsDYNrgkIac8rEQv9mU98KdCVeTUcb3rqyD7YCWR55wWCRgi4cjxN1F69HUmJElulmvx71yXP96WELQoa41D6gPG0dPh1ad0qT0eO1pW2ti3n66oB22ZVXG1rlgVZZO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697298; c=relaxed/simple;
	bh=7XLMy6k3euXlqZoZIk6NOl+uE5XTQOe7T5Piz8sEjIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kl5KzLrlCM4fJyH9OuyBWc21WconEv2Hyn+PtkCGvpjVbFh7ZLNdVMuDI6ZUKcQhzH5cQuP0RZAqJQX15AsTXLESRPdtLFqDqWbT2NRO+p6lLZ1BlgaAhYCOHhG0lKU76E0kjT7Fp9wUU9vZiPEA1k/1syclZxZCdrtTLZ9t75o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CgI3bHOw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30f01e168b9so1137048a91.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697296; x=1748302096; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFZL/kH4WRlINTL3eamUJbEcDFBeTVdE3ERRtxKHz5s=;
        b=CgI3bHOwwC5ZzIt4N+CUiQ49COZPzu0fzTbaGfoVi4ePAw7JHmMjPGZHFsu+ndv6LA
         cCv0RSBq3zkkW5p8yp9YvtU3ddIXrBhFFTNZNPAu3uvecZdswLFTzDIqj7NKxoibwClp
         9rwUuFF1aZbhCaVZ5yfuWps4kviQHMcXdRI9MwCYgDRAt0en7MMDr2vpKzaEQPo9R58P
         zKVgzzl/Rolwj1IlQfHOFlGcTd3er8Y2Oo50IRXKJFHJaCi4XTih+U7VNI/mdXas1zgj
         ++qTeriAf38RQf2XAPRX1M8n7uS/wiAyctqF5V5Q1FAD4EfjkOkydMfllE9YI7WCGk/0
         ZPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697296; x=1748302096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFZL/kH4WRlINTL3eamUJbEcDFBeTVdE3ERRtxKHz5s=;
        b=wKhSJcfsQCRqtjztyZDBG8xapJ0BBicFrkR3vmEqMP9po8dW+St5ohvRW2DPAu26Bw
         SIRfSpysJ3lt5TKnypWBhMkj3mP3OrrAd2ANqPtpM0z/SeNZ4arBnuS6BPP3c2V83XPH
         r1MxI/PE/n0w6tuRvEBMsXdcoA0By1uucGzktKRG1TxIdwM8e5kx5KWgBkjt0mn9z0Q2
         bP820cAtVi2y1qwVGH5ZHHT19nEkkPeu+bTcPJsALVUjQthWjaq8e10LMb+tPHcK6pYy
         lMX3DfA4Is3gxZP3do888pS6z2yJriInfNNMSLptOjraOVDHi0QO1qOph1M8AVH8125G
         vLOw==
X-Gm-Message-State: AOJu0Yz3PYAoK8MEn6Ro3m/TPAn1FMaNNNtSDbT1Dvw+BAOTPW/j1kUn
	QCJY3TUjsV/Z9zpUk3xPOXHq2X+CCCiBTwcHKwBwYFePDE36TPjQfbbAY2cgD2VumvAMG3sGPog
	MggEz6w==
X-Google-Smtp-Source: AGHT+IHQHbcXZtaoWAtgRshiy3d8CBLPCDH18KzA2veAqY8K4gctlw03Pifc9NLOszqBQATvWqPErDxNwGg=
X-Received: from pjk3.prod.google.com ([2002:a17:90b:5583:b0:30a:4874:5389])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e85:b0:2ee:c30f:33c9
 with SMTP id 98e67ed59e1d1-30e7e770523mr18211368a91.14.1747697296528; Mon, 19
 May 2025 16:28:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:27:54 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-2-seanjc@google.com>
Subject: [PATCH 01/15] KVM: x86: Trigger I/O APIC route rescan in kvm_arch_irq_routing_update()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Trigger the I/O APIC route rescan that's performed for a split IRQ chip
after userspace updates IRQ routes in kvm_arch_irq_routing_update(), i.e.
before dropping kvm->irq_lock.  Calling kvm_make_all_cpus_request() under
a mutex is perfectly safe, and the smp_wmb()+smp_mb__after_atomic() pair
in __kvm_make_request()+kvm_check_request() ensures the new routing is
visible to vCPUs prior to the request being visible to vCPUs.

In all likelihood, commit b053b2aef25d ("KVM: x86: Add EOI exit bitmap
inference") somewhat arbitrarily made the request outside of irq_lock to
avoid holding irq_lock any longer than is strictly necessary.  And then
commit abdb080f7ac8 ("kvm/irqchip: kvm_arch_irq_routing_update renaming
split") took the easy route of adding another arch hook instead of risking
a functional change.

Note, the call to synchronize_srcu_expedited() does NOT provide ordering
guarantees with respect to vCPUs scanning the new routing; as above, the
request infrastructure provides the necessary ordering.  I.e. there's no
need to wait for kvm_scan_ioapic_routes() to complete if it's actively
running, because regardless of whether it grabs the old or new table, the
vCPU will have another KVM_REQ_SCAN_IOAPIC pending, i.e. will rescan again
and see the new mappings.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq_comm.c  | 10 +++-------
 include/linux/kvm_host.h |  4 ----
 virt/kvm/irqchip.c       |  2 --
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d6d792b5d1bd..e2ae62ff9cc2 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -395,13 +395,6 @@ int kvm_setup_default_irq_routing(struct kvm *kvm)
 				   ARRAY_SIZE(default_routing), 0);
 }
 
-void kvm_arch_post_irq_routing_update(struct kvm *kvm)
-{
-	if (!irqchip_split(kvm))
-		return;
-	kvm_make_scan_ioapic_request(kvm);
-}
-
 void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
 			 u8 vector, unsigned long *ioapic_handled_vectors)
 {
@@ -466,4 +459,7 @@ void kvm_arch_irq_routing_update(struct kvm *kvm)
 #ifdef CONFIG_KVM_HYPERV
 	kvm_hv_irq_routing_update(kvm);
 #endif
+
+	if (irqchip_split(kvm))
+		kvm_make_scan_ioapic_request(kvm);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c685fb417e92..963e250664d6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1020,14 +1020,10 @@ void vcpu_put(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_HAVE_IOAPIC
 void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm);
-void kvm_arch_post_irq_routing_update(struct kvm *kvm);
 #else
 static inline void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm)
 {
 }
-static inline void kvm_arch_post_irq_routing_update(struct kvm *kvm)
-{
-}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 162d8ed889f2..6ccabfd32287 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -222,8 +222,6 @@ int kvm_set_irq_routing(struct kvm *kvm,
 	kvm_arch_irq_routing_update(kvm);
 	mutex_unlock(&kvm->irq_lock);
 
-	kvm_arch_post_irq_routing_update(kvm);
-
 	synchronize_srcu_expedited(&kvm->irq_srcu);
 
 	new = old;
-- 
2.49.0.1101.gccaa498523-goog


