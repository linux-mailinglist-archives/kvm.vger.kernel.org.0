Return-Path: <kvm+bounces-58077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BABB8775F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BC9F3AE496
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861712451F0;
	Fri, 19 Sep 2025 00:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FSI2/Q3V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BC723D7E8
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241304; cv=none; b=rV8vBxtreAaf8CnDgk/ItSxtcEWKvtE8CNN0eto0DAU9cTXHR1oDK6hiZl1FOXTznCyr6YFHcsat5x5Ms57e1yKsaxD37r7erKXc9uUZXuOF53A+uChqnLU31WllFeAmIR/hJmdHVizM4kPmZNvlYRiyDoemGV+BBMjIUQi5skc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241304; c=relaxed/simple;
	bh=MYfyfCmqFxyCHS2O4BBURQ582kXjzfTNP4cFC+xONbY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d0XOpVIfjTAx3RDwYINj5KI+enIuWiMy9E79yf1jowYL0UHNYHIrlxIKhptZ2Gv93PeGQRQaHYWFKagAMeyckj7GDuKYdQN2bQ2o67cpueYkiYJeouSGYpeCKsjT6R0x4eZT8VMoNVFfwt7YCD9EGt5t9M8uHvnJqSfvN2MEAa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FSI2/Q3V; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eaeba9abaso2052206a91.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241302; x=1758846102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V6NR6hJNo39Ak194/iehCX8ivlJpJKQaL0LT6dsFNE4=;
        b=FSI2/Q3VD1im0Fy77i9QuczDnXKyID+S6TA1b4Nk4yEiCnaJcpKrkGPSLqDYcvH0W+
         Oms5qkf5IthRXm5SM2XZWvrVUO7k5I1rAHqI/bS/N5AdqnwIy/qllUZbJeQqcbOmsBl7
         ORzpOaHUWC2TIm3Pb6i9HS37K99thepZ8Ne+c9/Pn8SSWXaqcGL8ElthCyCTkR+jYcgg
         M4e3YxXh/IdAjKdZ+O6TgMtifeiGfh/6CzRYtF6F5Kv2f6rBh+F+vWOmnNGMfzjQOO6G
         80sKO4h0t94EYJc9mlZ47VS30++qmfBGcKdzYgSIqf+Z0P/+ObhC4sJ2zYJ3+2AhFCDH
         D4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241302; x=1758846102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V6NR6hJNo39Ak194/iehCX8ivlJpJKQaL0LT6dsFNE4=;
        b=S+h3f5EX4gu/sB5a2cbTIPh0ruFvsWdZPNqepGKGXY/G1Vy4alN3iuO+f2BSGVu6bI
         Qikjcr76PNgIjSFkySfYFmCcLpjQCNkPpC+tt5mkuC9x/XWS+flzjL70iFF8WGOnQ1j/
         ITXWlK1OVD5CE55UOCx7MZJqZFgaHocDJIH6RyN/NFp6Yhyi/rRqvUNQTDbUkc7RFiIs
         aFh9S6OxNvNkCpFJXDtjE/1x/jBU8Y0c1MgTPHovUkgvf6NwqhXF9bNQthIfnE+RSob3
         YlgozkX04yQl4KPgaH7pKhdgqk7zw+PWMg885BJlIa9+t21rfLFpXk4fccOxtHhH7lu6
         l2YQ==
X-Gm-Message-State: AOJu0YzU+GWPE9SzDkyD2yuUrMJ8YudHYzMcF2cUVc1mX3QSwrSd0nL0
	13Bl7rm0NRaOv/AqDqJSJahDAxDUNeospb3MeaNRARfxhHjLcDcYKzOwi/fLnWmq/IkN23DFcMi
	nnQKdSA==
X-Google-Smtp-Source: AGHT+IHT5D+RL1x9PZ0uSxi9CCmhcDhe9AetnWo73QWXpTR8epuroZH8jxE7cx4SFGVKQG3EeEHkob8mz+8=
X-Received: from pjn16.prod.google.com ([2002:a17:90b:5710:b0:32d:d956:20fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cd2:b0:32e:7270:949c
 with SMTP id 98e67ed59e1d1-3309838d098mr2017873a91.35.1758241302585; Thu, 18
 Sep 2025 17:21:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:21:32 -0700
In-Reply-To: <20250919002136.1349663-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919002136.1349663-3-seanjc@google.com>
Subject: [PATCH v3 2/6] KVM: SVM: Update "APICv in x2APIC without x2AVIC" in
 avic.c, not svm.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Set the "allow_apicv_in_x2apic_without_x2apic_virtualization" flag as part
of avic_hardware_setup() instead of handling in svm_hardware_setup(), and
make x2avic_enabled local to avic.c (setting the flag was the only use in
svm.c).

Opportunistically tag avic_hardware_setup() with __init to make it clear
that nothing untoward is happening with svm_x86_ops.

No functional change intended (aside from the side effects of tagging
avic_hardware_setup() with __init).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++++--
 arch/x86/kvm/svm/svm.c  | 4 +---
 arch/x86/kvm/svm/svm.h  | 3 +--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 478a18208a76..683411442476 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -77,7 +77,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
-bool x2avic_enabled;
+static bool x2avic_enabled;
 
 
 static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
@@ -1147,7 +1147,7 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
  * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
  * - The mode can be switched at run-time.
  */
-bool avic_hardware_setup(void)
+bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
 {
 	if (!npt_enabled)
 		return false;
@@ -1182,6 +1182,8 @@ bool avic_hardware_setup(void)
 	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
 	if (x2avic_enabled)
 		pr_info("x2AVIC enabled\n");
+	else
+		svm_ops->allow_apicv_in_x2apic_without_x2apic_virtualization = true;
 
 	/*
 	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3bcb88b2e617..d4643dce7c91 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5354,15 +5354,13 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	enable_apicv = avic = avic && avic_hardware_setup();
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
 	if (!enable_apicv) {
 		enable_ipiv = false;
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
-	} else if (!x2avic_enabled) {
-		svm_x86_ops.allow_apicv_in_x2apic_without_x2apic_virtualization = true;
 	}
 
 	if (vls) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1e612bbfd36d..811513c8b566 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -48,7 +48,6 @@ extern bool npt_enabled;
 extern int nrips;
 extern int vgif;
 extern bool intercept_smi;
-extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
 
@@ -800,7 +799,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG)	\
 )
 
-bool avic_hardware_setup(void);
+bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.51.0.470.ga7dc726c21-goog


