Return-Path: <kvm+bounces-66859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D5DCEAB18
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:14:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6A93303807F
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFF82FD1BC;
	Tue, 30 Dec 2025 21:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cfsZcIU4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFD32FD68D
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 21:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129236; cv=none; b=lzI3J3BIEnep40LsEibCsFXlUC4BThao+FMle8AEL1re4R2+n497ckngbjDncwiz21S3KP39Ixh8qxDlaVKLtxpCjid78FcNwfGKlPbSRCgXLUq04cpzBR9NRcXImF4eA7IBvHfQUMZUhN/wKBwS01ecTBUMKXoWd42aJog9QZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129236; c=relaxed/simple;
	bh=B+4ERGzRCfw5jMwC37fXuEHs9A9jh2a1ZNa1zK4cuGQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mFVRyKN7o9M5AdWztd0voAj1aP7SLwoCIviiZb+n26uV+IXsOOVtdL+XKP4ZxslgshWo3Tt0R/GZ7is0L92Xq0ufz7HsMLMfGPthGMdsjrG01Kdxkc9LfBGDpDKGcGS0lawuOXrFvalYmd1Ff2V6r1PCDdg/OJFLxLhkkyNgGoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cfsZcIU4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9321b9312so21440588b3a.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767129234; x=1767734034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v9BolbukkfXEm81oWgJJ+XaSPsS7Ia/w4dyAHDKHDXI=;
        b=cfsZcIU4Mnl4KsKMlbqWzOnkdE+yckHbKFlkok9wX2gIXDpxPPm9cgRH3WAzAo5Nwd
         bbpgWLa0egLVgPNviLesbRJdItivXru0K1z08vkbBOW05Fgs6JKcJjHjsCLvgbdR4oam
         b6NxKlm51XBZPjmFuKSD46R1p5Q71TdG3oLinGh/3tyrBIgi4hNu9qDR9aBUT2UzqaM/
         yG4f9L6akK0+kqnREWATJu6FHBdmHveBgNaRBYioaLJk4N13rfTuQQtXlhch8s/YerV0
         LPWPp/OmL5CTJUwsbrc7anMCl3EVqZapWKBSCSlrtIkXJ0rLY+2jkcITcRvS6ZVeKd8q
         BBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767129234; x=1767734034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v9BolbukkfXEm81oWgJJ+XaSPsS7Ia/w4dyAHDKHDXI=;
        b=Ihw6dktFNzx9WtlxJ9BWltXcn/wLcCDsTuK8PcOustMo1+X5jKSXcpb/JZLl17BKh5
         kCT83uOPN1Zsf6Ept67cj1M/m334miI/Ed03ws1QBE3WwU/Jv2KsvsJ2XJetuTq2L8Am
         dH/ZyyY+ISMTGGL4KHXOQtyqbT1oGngPHVDbPL/6dyUNTXYlM54l780Wvq9NsNMdNFWb
         ENfdFDr5v4GD14dFDns1bGlJ+gUC7Ix71dnVn3DYH8jd616R2fQrbTPutZQQKboUAkWV
         GstxtjzCNwdwh0EpJomOONQrKfsOUzEe5AUKI8BasItTnRcJt1stwRk/sFYrqJdwRQLM
         D2vQ==
X-Gm-Message-State: AOJu0YyGrfU7TyR7e3ULhvXXoN7WTQ/WGJtFoIpTjG8O8bmqYjD4xiv+
	1HJDjqJ54UeEe/wLcUyaKxtQbocHtSzzPcPv/p+LZ+hTiOsxLFSqq5b4N4uJRDuIpRc1eY95BAy
	A+0ktOQ==
X-Google-Smtp-Source: AGHT+IHHfrYGaC61aPB/ea5B/ICFankJwCsUHy15saTAvrWaEpZGe7M7AgYdzFXF+BVWYJ5DWGu3cCUZQeI=
X-Received: from pfez22.prod.google.com ([2002:aa7:8896:0:b0:7b7:8636:7b21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1d0c:b0:7e8:43f5:bd23
 with SMTP id d2e1a72fcca58-7ff6735eb64mr31633129b3a.56.1767129234006; Tue, 30
 Dec 2025 13:13:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 13:13:41 -0800
In-Reply-To: <20251230211347.4099600-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230211347.4099600-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230211347.4099600-3-seanjc@google.com>
Subject: [PATCH v2 2/8] KVM: SVM: Open code handling of unexpected exits in svm_invoke_exit_handler()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Fold svm_check_exit_valid() and svm_handle_invalid_exit() into their sole
caller, svm_invoke_exit_handler(), as having tiny single-use helpers makes
the code unncessarily difficult to follow.  This will also allow for
additional cleanups in svm_invoke_exit_handler().

No functional change intended.

Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c2ddf2e0aa1a..a523011f0923 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3443,23 +3443,13 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		sev_free_decrypted_vmsa(vcpu, save);
 }
 
-static bool svm_check_exit_valid(u64 exit_code)
-{
-	return (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
-		svm_exit_handlers[exit_code]);
-}
-
-static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
-{
-	dump_vmcb(vcpu);
-	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
-	return 0;
-}
-
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-	if (!svm_check_exit_valid(exit_code))
-		return svm_handle_invalid_exit(vcpu, exit_code);
+	if (exit_code >= ARRAY_SIZE(svm_exit_handlers))
+		goto unexpected_vmexit;
+
+	if (!svm_exit_handlers[exit_code])
+		goto unexpected_vmexit;
 
 #ifdef CONFIG_MITIGATION_RETPOLINE
 	if (exit_code == SVM_EXIT_MSR)
@@ -3478,6 +3468,11 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 #endif
 #endif
 	return svm_exit_handlers[exit_code](vcpu);
+
+unexpected_vmexit:
+	dump_vmcb(vcpu);
+	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
+	return 0;
 }
 
 static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
-- 
2.52.0.351.gbe84eed79e-goog


