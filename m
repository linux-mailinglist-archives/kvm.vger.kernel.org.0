Return-Path: <kvm+bounces-58202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C478B8B626
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4DC37E6389
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B9A2D3ED7;
	Fri, 19 Sep 2025 21:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jE1hgLPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9632D063D
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318185; cv=none; b=EG1W/dBcehOtq9mS1ReMWxfQYb2s0pTYBkrBXtBK+dJKttg6LOVFEjQnmFvvdwvfLVgJUyxR1km7xZlIXP0pLKrRiPAbEa8C5wnfr1e3tTH4mZvOMJEF879XzqQc6vPJo9aClOa3bOrlJVxiqW4YnVSHLDCUOr5p9hJ918A8VvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318185; c=relaxed/simple;
	bh=fo9zhk8d1XcI2uMyFbsR9nIEeWYZfmZgSjeGc0DVHHQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ra8aKAOd2fWE5momYreysx3sYBK8yY8CeP6l2wT294162NcRWAEtG9FETA5uP4NqYKM67sgcCs9dZaeF/zfzIx4+l6zDOrJf8lrBy2FQ6LnXuiMmFYneVqlukDDJu+ltmuA11jSlqPUBDJDgLjJhvnojhXDd3i8yr51OfStxEq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jE1hgLPN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2699ed6d43dso21524075ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758318182; x=1758922982; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3AOsivK1Y+PB0qISVUU/vGa8EBoPowdOlaSDsePieg=;
        b=jE1hgLPNFElPYKeCoL7SX6As5ADIau3dOfhBJn3DZxlR87Qfad7MidhPaJrTxpC9sK
         2IzgR1wSK18BcNRtPryX4YCHvtdqN4aN8K8P6I8DGfugDDTKGG5Ax+uLzn5K1YbHl3N7
         ufGUN6B9O8yN9iax8uHrwKMhw38hHQzSuEBMoIxsfsmRoamjEDKjr76TTIjrmwffEpUT
         go4ptglMeXqTg5CYs1T47zlj/yEhpVQFyoC+vRmt9GWR4ozA5R8Dz4/bHFRh33tPuDEi
         4TdaDaa38lCzYti4KXY4/idU2c5uu6M0l+f4zX/ErE+5pzA4OOOHOrXHN/+3zmIjeufV
         qxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758318182; x=1758922982;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3AOsivK1Y+PB0qISVUU/vGa8EBoPowdOlaSDsePieg=;
        b=S/QeoJabLW3Ib7ev+bAGZSL1UgVeuSpJ/ZrXj7l8N4p5J4Ad7y24BWIbiZJ7CVqpga
         p1jL1KBaE98ZllygDu51vG6IDshFUZt3oNUYUL6uma31OBNwub4N7DERB7dYKIsvbzxI
         60TLekee1Z8RAI4/oXaH/RfNp17mIWLftcc9+msW3frPUak741jdnOanI+25A2vh5J7+
         fKXRYHO8AEtcDxTvmWPtH1FgYUc3o00r+g13Ni7QshF78S5bMq6C/CsTy8bVreHKSJS3
         ePJPsyMvYaBpfeRllqeKFCpMI10hi8Vol5hXFGE00cVa+9j5kx39uutdVl8yCs78r/nn
         O0Sw==
X-Gm-Message-State: AOJu0YyURuWQerO9TpWZKeKlQGrftSTV8Q0WLZbu6fDHw99t3XFYjwLe
	Nfg+OQZzDOzl9IRGTc/Z2Qp8kvZo60GPj69QXe8fmY+rAV2FWKK4aDQHYx5KQKrrxYULpCOpjlK
	TOgTN/w==
X-Google-Smtp-Source: AGHT+IG+taE21KAkZ/36UWw+w7S59/hNxFhflX8TBiMBtmUFtRPif/HlX+dV2UiJTiz7tKgEOMbcutGV9Vo=
X-Received: from pjur6.prod.google.com ([2002:a17:90a:d406:b0:32e:749d:fcc6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40c5:b0:262:663c:8d25
 with SMTP id d9443c01a7336-269ba5596e8mr69557105ad.57.1758318181957; Fri, 19
 Sep 2025 14:43:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:42:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919214259.1584273-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that skips WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
and use the helper kvm_set_user_return_msr() to make it obvious that the
double-underscores version is doing a subset of the work of the "full"
setter.

While the function does indeed update a cache, the nomenclature becomes
slightly misleading when adding a getter[1], as the current value isn't
_just_ the cached value, it's also the value that's currently loaded in
hardware.

Opportunistically rename "index" to "slot" in the prototypes.  The user-
return APIs deliberately use "slot" to try and make it more obvious that
they take the slot within the array, not the index of the MSR.

No functional change intended.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://lore.kernel.org/all/aM2EvzLLmBi5-iQ5@google.com [1]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/vmx/tdx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 21 ++++++++++-----------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17772513b9cc..b633d5c33f57 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2374,8 +2374,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
-int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
-void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
+int kvm_set_user_return_msr(unsigned int slot, u64 val, u64 mask);
+void __kvm_set_user_return_msr(unsigned int slot, u64 val);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ff41d3d00380..b3cb39ae937d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -809,8 +809,8 @@ static void tdx_user_return_msr_update_cache(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
-		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
-						 tdx_uret_msrs[i].defval);
+		__kvm_set_user_return_msr(tdx_uret_msrs[i].slot,
+					  tdx_uret_msrs[i].defval);
 }
 
 static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e07936efacd4..d975d0c60107 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -648,6 +648,15 @@ static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
 	}
 }
 
+void __kvm_set_user_return_msr(unsigned int slot, u64 value)
+{
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+
+	msrs->values[slot].curr = value;
+	kvm_user_return_register_notifier(msrs);
+}
+EXPORT_SYMBOL_GPL(__kvm_set_user_return_msr);
+
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
@@ -660,21 +669,11 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 	if (err)
 		return 1;
 
-	msrs->values[slot].curr = value;
-	kvm_user_return_register_notifier(msrs);
+	__kvm_set_user_return_msr(slot, value);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
-void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
-{
-	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
-
-	msrs->values[slot].curr = value;
-	kvm_user_return_register_notifier(msrs);
-}
-EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
-
 static void drop_user_return_notifiers(void)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);

base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.470.ga7dc726c21-goog


