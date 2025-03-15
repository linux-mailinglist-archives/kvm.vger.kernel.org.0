Return-Path: <kvm+bounces-41130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F6BA624AE
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94D1E19C1AC2
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60B11885B8;
	Sat, 15 Mar 2025 02:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vjvPYez7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BE3A41
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006104; cv=none; b=GxRWsGIsWnimZPyuQxIWR+nxrm/eOAcy4+yqTjaStan8vmV6D1T5mMjoU3GsKzgJB7oBelRLkFSOjNKTg2NE+1lsDv0oP3S8PI399K9Sk5u84kHJSkkVG1dTFy21eVU53Y20XHLGoKZa1z4Kd9XSOb9+Ofgs3yEplCM6VeDFwWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006104; c=relaxed/simple;
	bh=bt6b+H0+Tq29i30rceRXL9x4MJus4+Bpjrr9EgkPhpM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ObIcqoMhStZ9KXk06DcStRLNEFWaOqPG1HdIu3GVWNU3qh1xDhSEcONcoNmJRBJ7qfdr1edkRNSWqn4Khk/4CxoZ5GEjXj9Oo8Mx8UKa4a+UpexAWAAY4BKUbZvPZ6VkJMx/MhGXoKygkSuTFGTJ41Bdyys9YjECcnVfQSZXsZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vjvPYez7; arc=none smtp.client-ip=209.85.160.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-qt1-f201.google.com with SMTP id d75a77b69052e-476900d10caso63546461cf.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006101; x=1742610901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUw+0S4IAaDwD3W5stow5kvzTojbmPGuc8IbGH7DBLM=;
        b=vjvPYez7ioSweuaiPSQTx0y4jWU4atN6Oh6Tbx6erD4VXit0yHWJNeU7Vp3jrPZZgQ
         KH13OcC4vfyb0HfvnPI3xEyRIfChkDsiBiRyGXs10ANtSIHhXohWw20OILwRZpoSAmWB
         3LZuRNKli/wMwoD76UYqD8kIFWuPqLC/CLEk/IOjK8YvlA03C2jpDAEPIvIgXy7cv7MH
         OaYYR4Eo3eWWHZojX4x4M8IwGIrZTxV+NejhAc1jIyCw/w7yJStztdnm38Yp3sEaPZC+
         u0SF6QYE1uBCO90SkFA46jO4AzjljP9woqxmjW8FyV24I1zu4mD8vweF06iOFIKEQAiV
         vxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006101; x=1742610901;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wUw+0S4IAaDwD3W5stow5kvzTojbmPGuc8IbGH7DBLM=;
        b=Mao7zk2poqTWCxQSndN3hTHVpKqLspWQLL1GtXsMHtoL1oiRH2rYCeydnB49uV/kW8
         sPVguCCLnXC31RaId2ovT7JBJbG8CqEWP3OUcxiDqYtctlDM4V5oIS1p2EYV6EBZfLZg
         ypTylrBd/rjr00fPm2crdb4lYrAnnCxMtqj5+MhxK9I9fJRLZ9wHR54wPB1NE66WQrtl
         xPhHTUJotOHgbaqKVgf4g2u+Aq6kFqrc4iRqdXs0gs03dq9MaTWYQdxzcRszhWmGeQBJ
         qaS2uGhoASr04/7mgXLlK3dbZ6mEJ7SplvvvQt4hYXIeXoBkAECS8oX4ESWNmpdlxawl
         zThQ==
X-Gm-Message-State: AOJu0YxD5MLxWlib1lJPWkICJaEVbN3m2rvwxtnfb2V/kDhRnXYh34ba
	TbkSwgZHG4XmlyED1AM0KqbbdnezPlTozL8bcj9ugxDnHpDNahALBRjKKaEK1eYwbbWj8BQTwjw
	I0Q==
X-Google-Smtp-Source: AGHT+IF020CXLzNRsrx3v6dX0rbzclkdn2qtBV7z55bEEyPLl1wfqcSdtChwztGq7Tqi5jOTVvEIHKoL1lo=
X-Received: from pgbbw33.prod.google.com ([2002:a05:6a02:4a1:b0:af2:357f:4269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9005:b0:1f5:8678:183d
 with SMTP id adf61e73a8af0-1f5c1178019mr6816987637.14.1742006090522; Fri, 14
 Mar 2025 19:34:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:34:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315023448.2358456-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Wrap sanity check on number of TDP MMU pages
 with KVM_PROVE_MMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Wrap the TDP MMU page counter in CONFIG_KVM_PROVE_MMU so that the sanity
check is omitted from production builds, and more importantly to remove
the atomic accesses to account pages.  A one-off memory leak in production
is relatively uninteresting, and a WARN_ON won't help mitigate a systemic
issue; it's as much about helping triage memory leaks as it is about
detecting them in the first place, and doesn't magically stop the leaks.
I.e. production environments will be quite sad if a severe KVM bug escapes,
regardless of whether or not KVM WARNs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d881e7d276b1..30b81a81a1c7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1471,8 +1471,13 @@ struct kvm_arch {
 	struct once nx_once;
 
 #ifdef CONFIG_X86_64
-	/* The number of TDP MMU pages across all roots. */
+#ifdef CONFIG_KVM_PROVE_MMU
+	/*
+	 * The number of TDP MMU pages across all roots.  Used only to sanity
+	 * check that KVM isn't leaking TDP MMU pages.
+	 */
 	atomic64_t tdp_mmu_pages;
+#endif
 
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7cc0564f5f97..21a3b8166242 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -40,7 +40,9 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
 	kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
 
-	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
+#ifdef CONFIG_KVM_PROVE_MMU
+	KVM_MMU_WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
+#endif
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -325,13 +327,17 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
+#ifdef CONFIG_KVM_PROVE_MMU
 	atomic64_inc(&kvm->arch.tdp_mmu_pages);
+#endif
 }
 
 static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
+#ifdef CONFIG_KVM_PROVE_MMU
 	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+#endif
 }
 
 /**

base-commit: 7d2154117a02832ab3643fe2da4cdc9d2090dcb2
-- 
2.49.0.rc1.451.g8f38331e32-goog


