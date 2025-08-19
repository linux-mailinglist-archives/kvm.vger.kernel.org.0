Return-Path: <kvm+bounces-55078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 517D7B2D07D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 099BD6285BE
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED6827AC45;
	Tue, 19 Aug 2025 23:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S+LQvu5T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F33054E2
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755647333; cv=none; b=q1O3EgdAwr67rXRbYdmgjWX0LczaMmZOGlU9mTHaicEvzDB9yixHoj+81pmv7bBM6vv2w/X+eF09qfYZ2C27OjNxa1xz2uNM4vzjL0zv0R82s0WjUzI18rDXfNEOHeIw87X6BoJWZSOLONK3o2g9k5rk5KuVDdDmuQ8GeRCS08o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755647333; c=relaxed/simple;
	bh=lITnaRkjBJqY+s4uyQTehv1KV2HCpxGls0cZ6YtYGyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tcjLVbdEy79BhOP5YTAeBmxrAKGQQF4m+dIyGn1HnTwuPU95wdL4/acKFvNQjkEh3XunPQJcqQoWBrxbpmI9vV2yV5WwoIJyycwx/AtSHlsg4R+hDNtLSd58/hJBTkdqTCs1C8ShSQ24UyQ9bJWy1azls/cqPnwLJqvPt3ckszU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S+LQvu5T; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326779c67so5538497a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755647332; x=1756252132; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Tth4gC5ORJ8LF8jN+rSvkEDxOuRgeyGlIIpPyPLGE3o=;
        b=S+LQvu5TEJaXSX9VzthtuWnAkoXsiLDWxX2XZQ3LVx+fRlJfePzvqWCR3BIkElBkGE
         oHLvY9iqDNWEZjE9MKb0uLVcXmiVqjJmj8WaLmAYSot0emU/aEZhXY6sgGtn+h0gqqxw
         yZ5vgid8yqEFizcmL/E9fYMAALpMgWXecxU6XTSm3KaMCqRDr/x+YVp6LfcihuV833dd
         OZ0JXFV+UTjfcpU/lQ3gYPw7rk8ll5ipZmpQ4dXJvcC7OiIDKFFWY0Uh0elRGWWXRd4A
         /80415ACmunSuPu6/GpU7W0xEUKzb4WL/+EkSLc7yqkRDOSyfSZDRC2HgvLwcyEqCkha
         DI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647332; x=1756252132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tth4gC5ORJ8LF8jN+rSvkEDxOuRgeyGlIIpPyPLGE3o=;
        b=o8WzR3SssC9ez6bOomWbDY9C98aXPSC/lp8eaUg1SzFlzkgJUkcE958SusheGPPNAk
         2anVuemmyMWTMOnV/1zHwLkqNWyE21dVF5Qy5jeUrQkOl4XCRUIXKzyedMajDV/h4mqP
         6liBbvoKPYL6HXIPzbesYRd7Rf6q5hy5UEPDY2odp6Rh/nBtgL3euRTet8d3f/y4eqMB
         pGYQwO14CVsWelnOFZnUd0iFrPo4ISg0EE9Vdc947bS8wxFKtkI/kUXqqxyxG1OclX6g
         vOJrPFtERNxv8eZJt9poeCtf1Oq5qH9MJxQRsZm5Qc40H0F7mdjnJxRgus55e4fJcu1f
         XcJQ==
X-Gm-Message-State: AOJu0YwB6FFXwA4LRTCKFj4/8I6VmeQ8BjcKm4ng4Rm2HKr4o2hMPScj
	g9MVzeQ7D6B3MLabgWt8GWO6k3JWmVBXVQdkxCvQgERUFUAWc/yNcextFCrTItloGZRe2Qn8Um0
	TZAdO3A==
X-Google-Smtp-Source: AGHT+IG2cqgU08PbgqqndLfgFE9jwo7bEi262vS+JQXh7SdNHWZB2+dLGBX8Ek0J2Jlc79qXI/pkZvdeMdY=
X-Received: from pjbnc7.prod.google.com ([2002:a17:90b:37c7:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:584b:b0:31f:12d:ee4f
 with SMTP id 98e67ed59e1d1-324e1423ef4mr1131948a91.23.1755647331805; Tue, 19
 Aug 2025 16:48:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Aug 2025 16:48:32 -0700
In-Reply-To: <20250819234833.3080255-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819234833.3080255-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819234833.3080255-8-seanjc@google.com>
Subject: [PATCH v11 7/8] KVM: SEV: Fold sev_es_vcpu_reset() into sev_vcpu_create()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Vaishali Thakkar <vaishali.thakkar@suse.com>, Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fold the remaining line of sev_es_vcpu_reset() into sev_vcpu_create() as
there's no need for a dedicated RESET hook just to init a mutex, and the
mutex should be initialized as early as possible anyways.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 7 ++-----
 arch/x86/kvm/svm/svm.c | 3 ---
 arch/x86/kvm/svm/svm.h | 1 -
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ee7a05843548..7d1d34e45310 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4577,6 +4577,8 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct page *vmsa_page;
 
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
+
 	if (!sev_es_guest(vcpu->kvm))
 		return 0;
 
@@ -4592,11 +4594,6 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void sev_es_vcpu_reset(struct vcpu_svm *svm)
-{
-	mutex_init(&svm->sev_es.snp_vmsa_mutex);
-}
-
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
 {
 	struct kvm *kvm = svm->vcpu.kvm;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8ed135dbd649..b237b4081c91 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1244,9 +1244,6 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	svm->nmi_masked = false;
 	svm->awaiting_iret_completion = false;
-
-	if (sev_es_guest(vcpu->kvm))
-		sev_es_vcpu_reset(svm);
 }
 
 static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 321480ebe62f..3c7f208b7935 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -829,7 +829,6 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu);
 void sev_init_vmcb(struct vcpu_svm *svm, bool init_event);
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
-- 
2.51.0.rc1.167.g924127e9c0-goog


