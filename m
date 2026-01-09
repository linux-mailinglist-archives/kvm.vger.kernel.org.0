Return-Path: <kvm+bounces-67503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5776D06FFA
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB4DB3043130
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370DF19AD8B;
	Fri,  9 Jan 2026 03:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JpWode3T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536001CD2C
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767929473; cv=none; b=a7vRcFzwM9JU4zKksJnp77Vj9eJ8PIuPw802DGLD3AJgLHJ8YFyFFN9uZjAZaIoHLEwGC5JRbcstlqaXV47OQ430XXyqEawDuMhhYDZzWl0Yt/uMATesgs5g0V0wJEnrcn7y56wo+SULrKFiuGHMDfqzMuluIfT+u/3s9/SPsho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767929473; c=relaxed/simple;
	bh=2V4BltaQ+YT06u2mT3N06cdcQ3NXx15sNRSCRp+q/gY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k9O/RjWeCnhndxYf2e9K8CGPUCBd1CRm2lRu7ebUKj92jF7RJOhoh9vPvkIOplZEYV6mqMGXNWCYV2af3Meee6UQRPm3kRakmlE5Z82dLgXYNf+IyyZW4Dbot/BzyoAwJIOLAlejScLa7i8qKQBveMrdusr4GCNPXXbe+90KV0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JpWode3T; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c6cda4a92so5039267a91.3
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767929466; x=1768534266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Mla1DRxHLEybanQJcXviUnnpDYAkH+oHijzXn/g2Vr8=;
        b=JpWode3TNyM/SCwJr9PAg4JHosSDyYJqfhvHNFfocjLcYh0WZYK139iWthpefqD0Rr
         69lqjZKgR7s2XrM7wwn5mcFjg5d8/+aQOKC8MQt0R5D69nHKYiWV+NP7PWHZBkmuG6EM
         G2Oxha22C+a1sdijrNmX0/OuAlFdmAi/WZtCzxzA6Uj3t9zUCaoskNtnGZU+UWP2lkZx
         vF/FVSGKrHdP6YY3snZ2MlIUvhH6EgJ5T5hJkyDYQGPNz/rm5oCODPvaazcKSXXvhg+b
         JF4RoH1f0XS+wVK667fx5OygwP55LIPws26b/06DNeWZbXqhCEj8jYYK20V/CkglG9Gz
         s9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767929466; x=1768534266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mla1DRxHLEybanQJcXviUnnpDYAkH+oHijzXn/g2Vr8=;
        b=cO85WR653yLTtBqXbMKyK4Xcw88YqL3YB+QrXIwnINnEINQFLe/OjUkOPR/lFmD/pC
         Zb94sz6LbhI9Zgustyea5RiofWhXjU3Nt+p/LuJ5uwGJ0GZLz+6JL9sJmNdb5v9xctCl
         +w24rhTFrq2cJ6Kx5pOF3wNYUqhIyJtI/6ls5sc5vUdXBhsoqn9gHmGei2sOkF2h2G6P
         TO+CkHRsLuTI84nhisUCLDu9jajYi1lWhOvPFmiLwjdjNgc97FI9rBPv3XKPc+8ha12o
         EquLVhImycsBQn5RKe6vHz6Zk6us/Ku8A9nVKPliHUAZNd+UHai7YQKVeXkaJwr7vjI/
         /XLA==
X-Gm-Message-State: AOJu0YxUWd5VKRSZ3Yezy2KP2Y/Ip4YWMikUrdOyEUxZrs/MyZNxdPH9
	oqEYnCki5HuLnnf6v1EOzKC7WgbDhjrECBlzPOMRFigJBvIWGLjHxuWia8n4YlHY7mIUEPMjlCJ
	B0E/B7Q==
X-Google-Smtp-Source: AGHT+IGLWrXplPynHk8EJUyO1AzJ4B8EBeIefbRuNJ3ysVbIscyNZnWwa9KhrXRUl4V6C3eSPSPHCrxMnas=
X-Received: from pjbnm2.prod.google.com ([2002:a17:90b:19c2:b0:340:5073:f80f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350b:b0:32c:2cd:4d67
 with SMTP id 98e67ed59e1d1-34f68c204e2mr7331315a91.13.1767929466108; Thu, 08
 Jan 2026 19:31:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:31:00 -0800
In-Reply-To: <20260109033101.1005769-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109033101.1005769-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109033101.1005769-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: SVM: Drop the module param to control SEV-ES DebugSwap
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Rip out the DebugSwap module param, as the sequence of events that led to
its inclusion was one big mistake, the param no longer serves any purpose.

Commit d1f85fbe836e ("KVM: SEV: Enable data breakpoints in SEV-ES") goofed
by not adding a way for the userspace VMM to control the feature.
Functionally, that was fine, but it broke attestation signatures because
SEV_FEATURES are included in the signature.

Commit 5abf6dceb066 ("SEV: disable SEV-ES DebugSwap by default") fixed that
issue, but the underlying flaw of userspace not having a way to control
SEV_FEATURES was still there.

That flaw was addressed by commit 4f5defae7089 ("KVM: SEV: introduce
KVM_SEV_INIT2 operation"), and so then 4dd5ecacb9a4 ("KVM: SEV: allow
SEV-ES DebugSwap again") re-enabled DebugSwap by default.

Now that the dust has settled, the module param doesn't serve any
meaningful purpose.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..9b92f0cccfe6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -53,9 +53,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 static bool sev_snp_enabled = true;
 module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
-/* enable/disable SEV-ES DebugSwap support */
-static bool sev_es_debug_swap_enabled = true;
-module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
 static unsigned int nr_ciphertext_hiding_asids;
@@ -3150,12 +3147,10 @@ void __init sev_hardware_setup(void)
 	sev_es_enabled = sev_es_supported;
 	sev_snp_enabled = sev_snp_supported;
 
-	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
-	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
-		sev_es_debug_swap_enabled = false;
-
 	sev_supported_vmsa_features = 0;
-	if (sev_es_debug_swap_enabled)
+
+	if (sev_es_enabled && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) &&
+	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 
 	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
-- 
2.52.0.457.g6b5491de43-goog


