Return-Path: <kvm+bounces-48922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D998AD469E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCD33189DA55
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801F929B216;
	Tue, 10 Jun 2025 23:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sd6763k8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4A4296163
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 23:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749597623; cv=none; b=NZH6VQI49Q9dnBouKGfQMZAD7T19gZqYJCl7i8QtpCthq9S/UNE32Q54lMupeOYJcPh+TmsX8H7ccgZxfyE4r7rIwrv688vXl8x0Qo7JsEqfNeJEsDeMSapetUxg5DGXrFluOqzh8CxC6I22nWnVEaPdVORsM/cCYyuBvdOEV5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749597623; c=relaxed/simple;
	bh=d6ch4wFyzgD/snzZgnO2eV+6ES7j1OumzJhm7QshG3Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y8Fm2ITNZEHAWBDd2ElQmJtIMfShwLEddCmxm8F+lYV3alh6u1umo64iHuc1Mri3ff4YzNKW09yZcOy41ljO1KNcXgzSqhWCF4qEscWGEch5PTxr6EWkpAIEix8y+0Z8aGrA4jxBxteA9f2xoAsC2XLwe0RwM4EEXQgqCWb/KBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sd6763k8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fa1a84565so2085891a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749597621; x=1750202421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HHsuZnF4V8CqTjAQoLQV6ObUx/gLCkMj4Na53qEjTK8=;
        b=Sd6763k879hkqyUR5tOqLpcJAAa1leLxkbn91nPI31pl2AviKwUift7cMnEppxNLT2
         mNcxWOCLtZvkVZGCn5RDSVU03uLn3kviTepROplSNu8LbuG6qSUeoIwQcSko+F7B5+vP
         KC1D5DQKew0hAfoiXwGj55rBNirIjODeKgmABWvsBxjDMVlZUqznNoonCjSPrwI5buM8
         dskmcnObbJPI0w2gFScSDk3tX9BAUKEkfSKKZx36+dpw5IBDFd0tZIZXv+SGwncRzrbx
         JUVAKPe916vUidiPcM8MvqDX2BKYdOWdP3R1yEikgHNUOFk2JW3B1Tzd/HJS4QQ6BUM5
         9SCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749597621; x=1750202421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HHsuZnF4V8CqTjAQoLQV6ObUx/gLCkMj4Na53qEjTK8=;
        b=WBWux1E4ndg6xk/4/u5YoA2wurxilw2Yk/8PwBqlnAKmQsOdKOwMgCj8btdgBEv10r
         OYgE5B6PbT2rQH34+557pr3vqz4O2SopJSpZaXXfDqfwIr6kRdYdC8DRMYM3GtI/qCTm
         Iz1w61XTrt/+ZixoJ/Yk6qti6rpAF72MLEwAzc5Gcguu2PFZE5laJTcwoQIj/WqYAXqI
         4rsaeR2uCiFi4Qig5fHkjaPpt7dF+YKA4IIqxKhQMJOjQps7WT/LF4qY8A7bbOKlJ1Ob
         1J/3CmizM/onFOMNyNe6bd2eAoutcdjkeV176XKTN+SZeTXPX9HYMsZYZpavJgQZU8pU
         aHtQ==
X-Gm-Message-State: AOJu0Yybk3fH86ROjEmVPM6siue0/uuV9pt5D82NHyHBHBM9w2dNZwa7
	uKl3Lgv4zwbXypRg8fu9PE4aO2B3e15hI/XAGaOIF7W5SuQyPba9E396Yn7V0bX6HBEYoOZACAG
	7CZwa4Q==
X-Google-Smtp-Source: AGHT+IE421/JEGwRo8d9Ea0QC6Ps3NvN/Iwm9+D8SNEcgSRCuj3kTU86U0uXrHJRxcs4U5fyl1urJM88xFg=
X-Received: from plbmt8.prod.google.com ([2002:a17:903:b08:b0:235:c96e:dd92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4cc:b0:234:f4da:7eed
 with SMTP id d9443c01a7336-236426b5630mr8666335ad.44.1749597621540; Tue, 10
 Jun 2025 16:20:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 16:20:07 -0700
In-Reply-To: <20250610232010.162191-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610232010.162191-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610232010.162191-6-seanjc@google.com>
Subject: [PATCH v6 5/8] KVM: VMX: Extract checking of guest's DEBUGCTL into helper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Move VMX's logic to check DEBUGCTL values into a standalone helper so that
the code can be used by nested VM-Enter to apply the same logic to the
value being loaded from vmcs12.

KVM needs to explicitly check vmcs12->guest_ia32_debugctl on nested
VM-Enter, as hardware may support features that KVM does not, i.e. relying
on hardware to detect invalid guest state will result in false negatives.
Unfortunately, that means applying KVM's funky suppression of BTF and LBR
to vmcs12 so as not to break existing guests.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ab5c742db140..358c7036272a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2191,6 +2191,19 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+static bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data,
+				  bool host_initiated)
+{
+	u64 invalid;
+
+	invalid = data & ~vmx_get_supported_debugctl(vcpu, host_initiated);
+	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
+		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
+		invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
+	}
+	return !invalid;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2259,19 +2272,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
-	case MSR_IA32_DEBUGCTLMSR: {
-		u64 invalid;
-
-		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
-		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
-			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
-			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-		}
-
-		if (invalid)
+	case MSR_IA32_DEBUGCTLMSR:
+		if (!vmx_is_valid_debugctl(vcpu, data, msr_info->host_initiated))
 			return 1;
 
+		data &= vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
+
 		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
@@ -2281,7 +2287,6 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (data & DEBUGCTLMSR_LBR))
 			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
-	}
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-- 
2.50.0.rc0.642.g800a2b2222-goog


