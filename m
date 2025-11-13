Return-Path: <kvm+bounces-63067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DC676C5A6E1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 504334EA940
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B65329389;
	Thu, 13 Nov 2025 22:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bkrMYktg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CCD326957
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074597; cv=none; b=MRCk+GtFo014f+7BTxED7/y/GAlrKVDhnGXBUfxiIiubN5LtRX9wfKOdcABQhp+2Zsk2na0++mn3S42QWCU4IioLAXWnhmlYKV2+YsyqLD0ToMElVLTbQiPM2/abGYKlucngndJDZOTAiylH+B4MBb/+/WG1IJgkyUn+WJtBDD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074597; c=relaxed/simple;
	bh=3ZKH73v//RDZ3fRn2i/PSc16YVjKg39gkH1Xa11RzC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WznjAkuO0pTTWOt2f3uGRl+M+UGuNtXcGg1ZDlDbwv+snBU8JaTI+0XlB1jYGOvd/aEw3xEIdcQrYO0+iXkpFBBIi43MWzQ47ZREmCf58hM8XnMSW81bxTaf+Z0FIgcxuEbU2xpf9kKcRkUWMvAf4PDmI5JiwoPqJffrFT1iFac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bkrMYktg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-295595cd102so32607195ad.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074595; x=1763679395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=44sHkalx4c+buJJlySyLatvfmOk9JIz0iW1u4PfgOGQ=;
        b=bkrMYktguQLziZS8oZIiD2611kMJzuTmPUNSEk0JmR/GZ7jjvY4u9XSVlBNSVZxvTX
         IUTqURSqNPqBHZBKwH13iGTtOpIdl19ga9LzO2r857mHVF6c+ipQjC0StFkrQ6EKVuuw
         scPc0ewPzJywxNGeIQOLfpMuiTe+w4AbjU2ykKqAbbNURvMotvvATK6Q3kieGpWjjBDB
         PX5Rdx4khzyVx6rbLn+MDrolQ8UIE8Gbs2elfwThDqsE+QKz7Ni7hS4VR1vHF1jUw6By
         PUTDNpELRCKJSjNNpzhFYT+quA7/Qb+d+bi0ZE2IlEo2Iby+bXSx2l/uitKkpj0jtNOu
         GroA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074595; x=1763679395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=44sHkalx4c+buJJlySyLatvfmOk9JIz0iW1u4PfgOGQ=;
        b=EpgEORkvakj5kd9ALbvF9lIbsDsGe1Sksg4BblN9VMFJCWLQcwPRdBoU8EAZZ47zlq
         NfOQBQE1io+95vj4hISw1wFA7u1Peyf0OjYaXAgGJWyQlPxBHk789te0E+h8Ufpj2+0B
         06f9AzIcSu8VvWll0Gg7ZYsv/JL6Hh/tB0KUojERzMQ7TsZQmB4GiElMlZSLCnb0P3LI
         g762QB8wM+RxYlcY+yh70x1zQIQFVokhGxOQzVm97QJQU1RyOvB8tMVvX+wxij8BnKDB
         vEEZlZLht+92HlVaNUVSAd6Wups9gTKelU0eplm3Kp9e6lr+rhNeaM6gPkJSZakSj95D
         /AJw==
X-Gm-Message-State: AOJu0Yy+cFN6MgcyUfubdngYkjsI+ccHiF2ObuI8A+Nh/bbihBHqXPC8
	ODg+C8O7Evv3EbQK1XGC4hHjClH0JNIvHdxHH03zSwyIrQOPdCZSkSgG4cZ5cZ19LhXI6e11+So
	p9F+nwA==
X-Google-Smtp-Source: AGHT+IGqAKWqFoUFyf2m0vap9g7gkzKL0KXcEIHMGW0cbM1JyDMMiT3yzbCUGWEfKZvzY/3IrvdaWAPUMuQ=
X-Received: from pldr17.prod.google.com ([2002:a17:903:4111:b0:27e:dc53:d244])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f790:b0:297:f8dd:4d8e
 with SMTP id d9443c01a7336-2986a741b93mr7487325ad.30.1763074595173; Thu, 13
 Nov 2025 14:56:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:16 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-5-seanjc@google.com>
Subject: [PATCH 4/9] KVM: SVM: Open code handling of unexpected exits in svm_invoke_exit_handler()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 52b759408853..638a67ef0c37 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3433,23 +3433,13 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
@@ -3468,6 +3458,11 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
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
2.52.0.rc1.455.g30608eb744-goog


