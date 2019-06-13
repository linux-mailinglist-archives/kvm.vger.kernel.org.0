Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1050B4480B
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393354AbfFMRD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53762 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729773AbfFMRD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so10994067wmj.3;
        Thu, 13 Jun 2019 10:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fp3D4r+gsXo4pbK4LPWYQ1sxU9VB9jUgzbEAv9Nh0sQ=;
        b=BVb22FBradebBX7GnCFWEqao4SPsi3CD9AEe+3rWW/S36aiRfroCwMTw8+48CZeF0x
         UGGcbVe9rwg4TPXFxmUyPgZxBgx/QRUlYCZcAi5qgboVs6I6Tpcfqgy8GvuIT6F+2/Wh
         ycrWzTczvgz7J07uw1sjzoXmF7QFBz88rR2BDJVM2d9yJhrkrBnVkmCMdK9qv/VAq04k
         MjDFLlR+CPi277sHdtSPUv9U2aaCoFLopl/HaQw2PlfwH9vXbhorwZJCciaWAsJaEZBv
         hNZcT3r1XJ54VDceQTLLJ0feM0UYV9zNyUmxuq1VawoYdar33GRNfxkzdLPMYIC1+h6B
         vYQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Fp3D4r+gsXo4pbK4LPWYQ1sxU9VB9jUgzbEAv9Nh0sQ=;
        b=K/ngesYlqLSp4uo4OQJ8N2/gq3fMzrhwyVzgbDjGqky9Cyn3TcFgGPy51Hkfef5QjP
         4pK+EO9eEcMsiRsupL7RmjDrrSzc6In0FVOk7SVfh8q0DSXimxnXoWnHfQAKzmnWweci
         VrW3xZFfoat82nsL8fmXjiIt4kRXY5K13ih199E0icxpqC6LvY54RnM7K+nd3stMeIyN
         MAnfWjcGCtUpZ0jvR7xlaNMXFzpZiGUJeQAN44leLOQCnpqqGoN0lsbc6V9EokHiQsfX
         gUDuZSa/J4jFZ+RuDbUxbJtkQsX5TK6hNMwKqD/bghXYAxG+qYs/VMYYlwCEaQaJxIjS
         BuhA==
X-Gm-Message-State: APjAAAU+GGrqnQvK4JDIcS4m+/Y6J0bdxQCjXDMPKJwvePp9ye+uX1O0
        +pPSVl4H07LNCu6AqcXI5TdQlmco
X-Google-Smtp-Source: APXvYqw39NrGlUQmQQ08F4/zyxZNZc9vtJJn//eNfHhkh7MW0UTMvZVP+bCXDttfDQuALDBHI9Ci6A==
X-Received: by 2002:a1c:e28b:: with SMTP id z133mr4230444wmg.136.1560445435094;
        Thu, 13 Jun 2019 10:03:55 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:54 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 21/43] KVM: nVMX: Don't reread VMCS-agnostic state when switching VMCS
Date:   Thu, 13 Jun 2019 19:03:07 +0200
Message-Id: <1560445409-17363-22-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

When switching between vmcs01 and vmcs02, there is no need to update
state tracking for values that aren't tied to any particular VMCS as
the per-vCPU values are already up-to-date (vmx_switch_vmcs() can only
be called when the vCPU is loaded).

Avoiding the update eliminates a RDMSR, and potentially a RDPKRU and
posted-interrupt updated (cmpxchg64() and more).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 18 +++++++++++++-----
 arch/x86/kvm/vmx/vmx.h    |  1 +
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f4415756ddd5..9478d8947595 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -279,7 +279,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	cpu = get_cpu();
 	prev = vmx->loaded_vmcs;
 	vmx->loaded_vmcs = vmcs;
-	vmx_vcpu_load(vcpu, cpu);
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 09632b8239de..7a2d9a4b828c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1234,11 +1234,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		pi_set_on(pi_desc);
 }
 
-/*
- * Switches to specified vcpu, until a matching vcpu_put(), but assumes
- * vcpu mutex is already taken.
- */
-void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
@@ -1299,8 +1295,20 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_has_tsc_control &&
 	    vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
 		decache_tsc_multiplier(vmx);
+}
+
+/*
+ * Switches to specified vcpu, until a matching vcpu_put(), but assumes
+ * vcpu mutex is already taken.
+ */
+void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx_vcpu_load_vmcs(vcpu, cpu);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
+
 	vmx->host_pkru = read_pkru();
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 581f4039b346..36a2056fafd4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -302,6 +302,7 @@ struct kvm_vmx {
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);
-- 
1.8.3.1


