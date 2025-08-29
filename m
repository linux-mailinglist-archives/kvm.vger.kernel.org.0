Return-Path: <kvm+bounces-56209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B3FDB3AED0
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 649B97BB248
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF34719E992;
	Fri, 29 Aug 2025 00:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bR/AYtRB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAB6157A72
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425990; cv=none; b=KDvxSQMSW+5ODSdHDfauhAUiPhJ/mGFt9UlBU4r9gfVOPbMLDGqCuvhkVrCxEMTrQY7L3P5Robkh4Yaeh25CIPfL5+g+t9jCZ/kxsqwd7Ol3vWOkq9IkcuUAptSw3eJ18v2/3AoE//e3+JVRJvHaj8h08HgeZnqWfnpSf906ypw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425990; c=relaxed/simple;
	bh=6yIUkZeN6bMoRkgKDRajINf2nZ43Ns9yxSaUcclg4QY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GmLQCrAS0cqW4De4m5iv3Wf7jEYFgIADebI6/DAw5KgSd94MAknlkUSHuaTqkbbdHk//iIBBxSCIkQ11c2c/OgTA+ortxynHls7AqWdSQaoVoZ8Vw+isdNTboJ6rSgkGmsJgfbsW1msNW5ndd1/DGlVz61WvzaAW24rpSO+BGVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bR/AYtRB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458264c5aso13564765ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756425989; x=1757030789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fiTedu7sqH0jEzzfnRQK+Pd8x3O94MW62vCUbcDlgmI=;
        b=bR/AYtRBNaTUgG9Rb+GCSjUaQHXFlOZIDhOkorCmu7zUUGVV7UqzGssDvbZ1TT/3hM
         mvpqg3fyU1jRADzH4YE8fOsmlDFrAsQvthGnoSN4FnbYgLu586cECp9WZfNSuWny0yqI
         5wAQZykKocuHxF4X+rGYmqvDXGohYgIgoW8PzPwu2MLk7v1LOSthHxkCnB94R6wzu5y8
         UNvvHH0mZAIpAPfRsr1pNgjiwhppHlXRT2epG5FSC+Tt8VjSQS5WOe0ejLAioaNd5tRY
         as5lXkN2f4bZfxgsHPybXyWnjonZXdl/ePPobMbebevI/d0CPihdgoyIwGbLr99QcEXx
         dapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425989; x=1757030789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fiTedu7sqH0jEzzfnRQK+Pd8x3O94MW62vCUbcDlgmI=;
        b=sHasYC8k3iFp37RSsM5tKIqfoNDQbi9vZNuSb9e08iPT2GOD+wVBBsn06dOFxnslTC
         B0gHGmKv1h+H9PaGM80dN57WJk4MSRQC/W6TXxVULMTWpKg3bqrrMiFV/qUi5d8gwyR+
         I7tbKQM8z+E7TsWiUF/taDhCWhswSqxO8fETsAOUp9Qe81q9IlnP1PVLkiiR8FbtL/j9
         dTCgFvFBjlKPsxPrn0atROedyzbtWSrNblO+3sFv5CwxkW/O9sSX7tuhxBT5NfQben3A
         urWZ+JoXP4E2jE0rCyAyKgSThRFReGn/yX91W9ENZDWC4r9beG7F4ktvG1LQHCLyQOyc
         Gefw==
X-Gm-Message-State: AOJu0YzjYbpPHcX84Yu1GXxRIH/L7HnFlNGMFb+Deo6QUsf2L0J14Bav
	idonHf8NluWqu9YchaK309piI7pGbKBOwBKxHp47vj33UNB28EQcE9CAA2hpzRWtVbEsKqh2tUs
	cvrMPBg==
X-Google-Smtp-Source: AGHT+IFZNlUvYoCp4G8CHMrlHBqcMouxg+12z/QGwQt6VYAqJdmYsFGUXf61w8vimDXzgykBxzSIvpAX7rQ=
X-Received: from pjbsv14.prod.google.com ([2002:a17:90b:538e:b0:321:c23e:5e41])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3546:b0:246:d703:cf83
 with SMTP id d9443c01a7336-246d703e19fmr236188325ad.17.1756425988741; Thu, 28
 Aug 2025 17:06:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:04 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-5-seanjc@google.com>
Subject: [RFC PATCH v2 04/18] KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_tdp_map_page() to kvm_tdp_page_prefault() now that it's used
only by kvm_arch_vcpu_pre_fault_memory().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f808c437d738..dddeda7f05eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4904,8 +4904,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
-			    u8 *level)
+static int kvm_tdp_page_prefault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				 u64 error_code, u8 *level)
 {
 	int r;
 
@@ -4982,7 +4982,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	 * Shadow paging uses GVA for kvm page fault, so restrict to
 	 * two-dimensional paging.
 	 */
-	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
+	r = kvm_tdp_page_prefault(vcpu, range->gpa | direct_bits, error_code, &level);
 	if (r < 0)
 		return r;
 
-- 
2.51.0.318.gd7df087d1a-goog


