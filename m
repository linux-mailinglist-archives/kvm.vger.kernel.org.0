Return-Path: <kvm+bounces-37037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BB3A2465D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 953BE188808D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD5413C908;
	Sat,  1 Feb 2025 01:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uhG4C+Js"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA917DA9C
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374927; cv=none; b=iqezfAlHUPftqB8U8XOGj26zLlvYTxJtwKVno5RM1Ru2zIxnh+r6szuA21k1SVYrtogSz0f9pPDtuZaI/L2hHzI+6RqXCsAQwPSCcRAX55wrFD54rICVUKz57dUhnbiM7Bn74s7jFQSqb2VNWLES92bAoADMreU55EMKy3ax8k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374927; c=relaxed/simple;
	bh=WTPZCV619SX538Cn6Abym6cnK99EEExx7aoodOVpBsw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CwepP6HYejkLLuN/kVZd+xttxqsoB5QmdSlXXLRO5PYzXYGSqaeBweGrl8nLlizh0MQWUul7aaVHciOXRmHfDSYJUgLTD7+GaYph5NuTBZqke/C961jOKZr77/x6V1H0HnlCwJL/JfYAWAupiw0bQV0yKjlViezsJELA0bvG1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uhG4C+Js; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa74481fdso5175664a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374925; x=1738979725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m3XOaiGIiENgl8NnCw2lngMp/lfgzjhOH8n22r5XeXs=;
        b=uhG4C+Jsyf7SQb5nbd/RoqDQo9efDc6yDtsZKyKZm+kR6nzG52nYL9hE1aOETaplfi
         GbDmZsmF2/JDGIL23IU9gjFwYdXMzTvcTVrouABvrG68Xp94rzXwHMP4u+FOy4ZUk97U
         z9Ypl9yVt5P2+3MiYy3W58DSP4XqnUqr2GuYMIMztqdDZdXfC2cNhAw2a6tflvkqcwAU
         Z0trLM7UxfFRecZvatlz4DekyTxFcZ436V4rA1I2jxKMjZSEmO2ZzdZeZ3DwghqkTkJM
         61PbFxtCDitM9eyFQxqVvjleKzQWwRNiUWQjJe3fwAGp6jOGrlAL4VGHmruWkf00Oow5
         /7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374925; x=1738979725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3XOaiGIiENgl8NnCw2lngMp/lfgzjhOH8n22r5XeXs=;
        b=RMdUFA8kU82LWrKOfzy7dyCf3oiWV0WwFBDoMyhnhQjVMWCrZtIrtmo7DJUvbdmikf
         AcXLnD0AIuZs4AuFWO056U1w7OgchGKLegGPP+FD0PdjeSIJF+LpITRLEKhSAd688Eaz
         YfY6v2KGOimiMLF45tkEUWqYXMfKnwRQ5e4UohK9MuNujzcL5XqrunqhqcuhIN8LJvd6
         LdvgfVRgTno0XUt/OpUtN6zqHTc/L0iVvTFQi69GkxZZqwXET7fxAthHE+2fPVP9PO4y
         CYuHfHOdZ/tyjhce3O4HWXvQoy3xDcNdOwRLWN7a5cxA0Y5jZiZ1LcJsQw9GrUB6M+RY
         I+Ew==
X-Gm-Message-State: AOJu0YwDO+eO2FY09CbderNYDQ1MyGIeF5gl5USoCGKf7plM5CU/Q8/J
	schdwi5SbDxHz38vs8xbesDAP3Wy676bDXvQHib2cFHOuIevd8CTvdkgdrdJTRKP4NRShAY6FMz
	4AA==
X-Google-Smtp-Source: AGHT+IFuItppbgWp7/fYWByB+OH6h9nXO6RPKexQwfXO/X+6riuHAEF3pgKvJptYfZThPrJiMZ3r6hXCHQI=
X-Received: from pjb14.prod.google.com ([2002:a17:90b:2f0e:b0:2e5:5ffc:1c36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d610:b0:2ee:4513:f1d1
 with SMTP id 98e67ed59e1d1-2f83ac5e5bcmr16213901a91.23.1738374925164; Fri, 31
 Jan 2025 17:55:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:10 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-4-seanjc@google.com>
Subject: [PATCH v2 03/11] KVM: nVMX: Allow emulating RDPID on behalf of L2
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Return X86EMUL_CONTINUE instead X86EMUL_UNHANDLEABLE when emulating RDPID
on behalf of L2 and L1 _does_ expose RDPID/RDTSCP to L2.  When RDPID
emulation was added by commit fb6d4d340e05 ("KVM: x86: emulate RDPID"),
KVM incorrectly allowed emulation by default.  Commit 07721feee46b ("KVM:
nVMX: Don't emulate instructions in guest mode") fixed that flaw, but
missed that RDPID emulation was relying on the common return path to allow
emulation on behalf of L2.

Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3654c08cfa31..9773287acade 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8049,18 +8049,19 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 	switch (info->intercept) {
-	/*
-	 * RDPID causes #UD if disabled through secondary execution controls.
-	 * Because it is marked as EmulateOnUD, we need to intercept it here.
-	 * Note, RDPID is hidden behind ENABLE_RDTSCP.
-	 */
 	case x86_intercept_rdpid:
+		/*
+		 * RDPID causes #UD if not enabled through secondary execution
+		 * controls (ENABLE_RDTSCP).  Note, the implicit MSR access to
+		 * TSC_AUX is NOT subject to interception, i.e. checking only
+		 * the dedicated execution control is architecturally correct.
+		 */
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_RDTSCP)) {
 			exception->vector = UD_VECTOR;
 			exception->error_code_valid = false;
 			return X86EMUL_PROPAGATE_FAULT;
 		}
-		break;
+		return X86EMUL_CONTINUE;
 
 	case x86_intercept_in:
 	case x86_intercept_ins:
-- 
2.48.1.362.g079036d154-goog


