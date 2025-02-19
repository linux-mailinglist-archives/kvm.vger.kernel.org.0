Return-Path: <kvm+bounces-38528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E317AA3AEE1
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:27:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 449933AB219
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C8B17ADE8;
	Wed, 19 Feb 2025 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1AuCBU+Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C7914B08C
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928433; cv=none; b=B8/CYK+cAYBagid49SsMhsO2j3oMjR09rfcKe4J5fQQ/vtKIIWmsfJ+717tsI5GCL791fmeBSUz9xvMoRvVucctBKvZAp0EAQ96hIJ7z6VXaN7rLor2fRzMXvv4aQ6eGI8mFtAcM4Jyr/xNrp8iHyjjZjv3l59L6dqPMqcbiRaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928433; c=relaxed/simple;
	bh=J1nAFJt6r7Ajioiex0cydNgYgyWbIcK2APGZ3IXZAOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A4HO+oahyauK79wiJ2DTmp4MIlL9Gs/tRrtZah4NAMGhly8mivF3BZDazo3Y+qcFTpSErl9W6Kr3OeDvmd1lvuluaBHsDGI55dBhsUoU8KcnlvhgSk7+j7Iv67e4NDeIwcjDmfctaAoAkmlRxQkq9p7XoTXhf3Zr3sycP4Gw+c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1AuCBU+Z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1e7efe00so10884715a91.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928431; x=1740533231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cvedP6xsz4gidjwnbxw7j1GxK5ZG/kcCzWXYJHFDTTk=;
        b=1AuCBU+ZoCGIElranhfzG7pPwN9N7KJOhmGn4yd5wzlAgz979cXFillJHbOdfnWt88
         8yhTDT8fmQh5I66Fb2ir9bY2UidYE1n6fpPxI+o38Mg0DP5rvhFlyb98nXdUb8jILzHf
         keKDVS5yy4AB3gzXcI3+t8wzdJfBGBuS+hTpIizvl6FhSMarBMTDk2dpm+onnePrN4nS
         1Gw9IxBAs1NzYw9zDq7wDjMyEotA3MPtasOt40tJ31/Kx7Ap409KNpOnkcNrU+W3ajFc
         3+X96bO6QgN4OBdj4GSF+F3akpL/rhv5zYOSM9n6PXUO/wzz0tGvTgaULEj7IQCtkogB
         tTAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928431; x=1740533231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cvedP6xsz4gidjwnbxw7j1GxK5ZG/kcCzWXYJHFDTTk=;
        b=Ez5E7y/lsYWq5veCjZWRoIQAd7vYd+EBLRPcNjWVg2xa1rdzwLfr1fu2tWwmly3os+
         nUBDbWS6mJ/k/m6+yPLtAGa430nDTrE4h3o3VQzuXQTBfrDvqrWmcJQYVHgj5qvObt9F
         pcHP9EYjb12RlBozgJnioM/toPyc8O9TpadmvSsFIb6W3XChlDti1aLVZDMc3dSsbUTz
         aJfTlOZcjYo3sLgWofHkegAHpb/6l/3J74ZSIvQz8kubeB/0wUvs0k1hHvqEq+VhvG9s
         QfZuf9g316Htm75jQTuxPSAk939hM23XeM9CIvoDOy0kJFQIJPxLHwCJxpAw8S+JLELG
         kybw==
X-Gm-Message-State: AOJu0Ywvnbu2dYdWssHyFCeOaN21Iqkh4fdsN9OyS0hKQatjp8n5YlrB
	5l9gb7DAiUoNLKebw5563M6oTsZYwRLgJtHTOQU4qRR4jV3ETRa54eNKwXja5eH1V+Y/7Dr8qjq
	Dng==
X-Google-Smtp-Source: AGHT+IF2j6eaylYhREGn8frIKvQEbG2ipSn6kEWP+C6rQfqXJMdySmc8Mo7nKr7CRXlAX8q7sHTfLLzlpqA=
X-Received: from pfun4.prod.google.com ([2002:a05:6a00:7c4:b0:732:6425:de9a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1746:b0:732:535d:bb55
 with SMTP id d2e1a72fcca58-732617757demr25124172b3a.4.1739928431594; Tue, 18
 Feb 2025 17:27:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:26:57 -0800
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-3-seanjc@google.com>
Subject: [PATCH 02/10] KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Never rely on the CPU to restore/load host DR0..DR3 values, even if the
CPU supports DebugSwap, as there are no guarantees that SNP guests will
actually enable DebugSwap on APs.  E.g. if KVM were to rely on the CPU to
load DR0..DR3 and skipped them during hw_breakpoint_restore(), KVM would
run with clobbered-to-zero DRs if an SNP guest created APs without
DebugSwap enabled.

Update the comment to explain the dangers, and hopefully prevent breaking
KVM in the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e3606d072735..6c6d45e13858 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4594,18 +4594,21 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
 	/*
 	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
 	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
-	 * saves and loads debug registers (Type-A).  Sadly, on CPUs without
-	 * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
-	 * DebugSwap on secondary vCPUs without KVM's knowledge via "AP Create",
-	 * and so KVM must save DRs if DebugSwap is supported to prevent DRs
-	 * from being clobbered by a misbehaving guest.
+	 * saves and loads debug registers (Type-A).  Sadly, KVM can't prevent
+	 * SNP guests from lying about DebugSwap on secondary vCPUs, i.e. the
+	 * SEV_FEATURES provided at "AP Create" isn't guaranteed to match what
+	 * the guest has actually enabled (or not!) in the VMSA.
+	 *
+	 * If DebugSwap is *possible*, save the masks so that they're restored
+	 * if the guest enables DebugSwap.  But for the DRs themselves, do NOT
+	 * rely on the CPU to restore the host values; KVM will restore them as
+	 * needed in common code, via hw_breakpoint_restore().  Note, KVM does
+	 * NOT support virtualizing Breakpoint Extensions, i.e. the mask MSRs
+	 * don't need to be restored per se, KVM just needs to ensure they are
+	 * loaded with the correct values *if* the CPU writes the MSRs.
 	 */
 	if (sev_vcpu_has_debug_swap(svm) ||
 	    (sev_snp_guest(kvm) && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP))) {
-		hostsa->dr0 = native_get_debugreg(0);
-		hostsa->dr1 = native_get_debugreg(1);
-		hostsa->dr2 = native_get_debugreg(2);
-		hostsa->dr3 = native_get_debugreg(3);
 		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
 		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
 		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
-- 
2.48.1.601.g30ceb7b040-goog


