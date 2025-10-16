Return-Path: <kvm+bounces-60221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CCEBE54F7
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E5BA54E43D2
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C032DF6E3;
	Thu, 16 Oct 2025 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CGX2PH1l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C06A2D9EF2
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760645064; cv=none; b=Z14x4vozB86wtvN5ZW8BJlPdcWYuGGPqVmlfScWvodBwnNOa+hpYsgP8X4e5rUGgwB0hoLA7b0hguDLls+tzNAwzn97SmcDnx9WjYPONsoBUqelYjzgRTQ9TsFEgsqObDdnkkT+IuwyyOq9qZ9tcnGhETzh9kRWwhXuSDH4tBJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760645064; c=relaxed/simple;
	bh=ghs0JTPXViv3gYU+802FotJFDsjdBY8OuXRfpqVMfLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WY2D4BouTzRWHdPMAgwqDF14jqK455haqtlvwJG1nzm9vM1UV/8zkDPMdkTudsplA+mru5CNzVFoiv3XCGQWBk1z9FUG3Xkue2eYAGNsgoZ/ORL9o9AMfSIPeCl51cN+I2AA3JYk9G+WgvShKjY2PsuPJF3GSIYMwJK/9JXiwiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CGX2PH1l; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bcb7796d4so482547a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 13:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760645063; x=1761249863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tm/qXlQLAHEXKOAgwJvK+AVS1CazgIKzCEoGFToXAKI=;
        b=CGX2PH1lgQTaTjenSrfDealGvevD1z/jDMBrFGYnbfoA4KRaLMiD+frDMH4kL7frPY
         6SMqfOzaXrZobUzQvjaDpvfc5F1zBaMhKyABVsghxVOUcX5J+T6dZq4mOYxF+kNWbR9C
         m+tp7BSQ08tJ5stqH2+NncJK1T9LPakPo1socUyhYPIrJZIY4UBQk9lKSpwB9DVPfLnJ
         UiT3iloKEMLe4Aj7UCaVIwQKuW7B//zaJmAuhZg7nGHLxovGaoGFEMGWMfiU/hKtnH4j
         I1RZaU+SuLPkn6qL6ssXgjGWfBinFZ6MCvMY+1D7y1R5swLWhkBXgX0gUD1xzaNk08+F
         zncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760645063; x=1761249863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tm/qXlQLAHEXKOAgwJvK+AVS1CazgIKzCEoGFToXAKI=;
        b=PiVGAU+s6Ccvvr63S/nONEBnTqx7GZ1jwcrzrI9gN1uIryHod1oHbduNdWfq0ju6Nd
         SaH2JDulwtUWChT6K4A0mQhbXsfoWBujD2G6AFtDWhTBHN3nXA8chy/nisQPVHp2rGHm
         RR+BqFlAOU876wTQ7Bk0maoMNTY7XA9p6FaFb2lLqeHyayhDMsct8f8h6blfSlMqJRP5
         00jN1cZ58Noz6IbQ76ycL4k/kyCBgM2H03ELbwzPWqaa7GX7k11KssN5NaaE3s1AgkLG
         l+L3yD/cWDzdu8mAqgn2IZG0rugJYzI2cp6xzmKvdvh50RxCcQv634FyzQGuErr/Lk2E
         QJeA==
X-Gm-Message-State: AOJu0YyrwhuV0e9UpJfFasjHtO2p5gtzZDuR64vBSYQvEEyZZAqEbE9v
	iFPm/pjL9zYc+7GysJkg+7yx+z2z/fMRJNaJqn+WzczsZH8b+A4zp3hDmnGrLPHULDaRcR+TePO
	NbVQrCg==
X-Google-Smtp-Source: AGHT+IGuIUJFiaFRJKV+M0sz1MHDa0oHWE72Edwvx9CfUodCWHzB70GPJHhUzQvB94hkWD6mQpKM9Yhq4pU=
X-Received: from pjg12.prod.google.com ([2002:a17:90b:3f4c:b0:32e:d644:b829])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2789:b0:32e:3686:830e
 with SMTP id 98e67ed59e1d1-33bcf8faad4mr1235069a91.23.1760645062625; Thu, 16
 Oct 2025 13:04:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 13:04:14 -0700
In-Reply-To: <20251016200417.97003-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016200417.97003-2-seanjc@google.com>
Subject: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache
 flush is skipped
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
because none of the "heavy" paths that trigger an L1D flush were tripped
since the last VM-Enter.

Note, the flaw goes back to the introduction of the MDS mitigation.  The
MDS mitigation was inadvertently fixed by commit 43fb862de8f6 ("KVM/VMX:
Move VERW closer to VMentry for MDS mitigation"), but previous kernels
that flush CPU buffers in vmx_vcpu_enter_exit() are affected.

Fixes: 650b68a0622f ("x86/kvm/vmx: Add MDS protection when L1D Flush is not active")
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f87c216d976d..ce556d5dc39b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6663,7 +6663,7 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
  * information but as all relevant affected CPUs have 32KiB L1D cache size
  * there is no point in doing so.
  */
-static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
+static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
 {
 	int size = PAGE_SIZE << L1D_CACHE_ORDER;
 
@@ -6691,14 +6691,14 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		kvm_clear_cpu_l1tf_flush_l1d();
 
 		if (!flush_l1d)
-			return;
+			return false;
 	}
 
 	vcpu->stat.l1d_flush++;
 
 	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
 		native_wrmsrq(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
-		return;
+		return true;
 	}
 
 	asm volatile(
@@ -6722,6 +6722,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		:: [flush_pages] "r" (vmx_l1d_flush_pages),
 		    [size] "r" (size)
 		: "eax", "ebx", "ecx", "edx");
+	return true;
 }
 
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
@@ -7330,8 +7331,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * and is affected by MMIO Stale Data. In such cases mitigation in only
 	 * needed against an MMIO capable guest.
 	 */
-	if (static_branch_unlikely(&vmx_l1d_should_flush))
-		vmx_l1d_flush(vcpu);
+	if (static_branch_unlikely(&vmx_l1d_should_flush) &&
+	    vmx_l1d_flush(vcpu))
+		;
 	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
 		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
 		x86_clear_cpu_buffers();
-- 
2.51.0.858.gf9c4a03a3a-goog


