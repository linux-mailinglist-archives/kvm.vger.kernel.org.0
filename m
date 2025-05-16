Return-Path: <kvm+bounces-46888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7BFABA538
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:32:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B1E11C00C15
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AEC28315A;
	Fri, 16 May 2025 21:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ez2pxuOF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5572528032E
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431018; cv=none; b=VoVX/7pOdKK2/vDHMqMWVlNvbH3FXAlXOW+xT/+6ZazrnDFfq+SQvPii8w8OgvnH7FuIWY9XtRroHiFS9RavxGmtixhZpA6rqmrpFkybJ+1FST7/W9WPF4OTt3y1IJtkCd+Ir0uXD80VxaCUl0XaKSwXlLNjbGPZLKo+JmHyPRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431018; c=relaxed/simple;
	bh=IYav/1dDjcX5ip4JkAY9bSkG1zmgQsJeTQlI5viDyAg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uqosvv8Kb4QXlLALYFPpVZv3hAgq+xjiQHLoGfFeuvJnqcfVvDVRTjrN5drCRHutcPk6GuSvq4VdrLVmxDqAhQtYU0Nkq5ahjqgDOvCE7RhXLBtiIW0Z1jJEdlx6lG4fCjNz+CEAoXOcmPCU4arl5qzYruqKuWpyaypecBboWz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ez2pxuOF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30adbe9b568so2476218a91.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431017; x=1748035817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VVF3vRzj16BIxVOrDVzAz6hJgiBEUt5vcCXrSP3D1EE=;
        b=Ez2pxuOFaahrXB+H6bp9rl9nv4ex1UmxLFGRJXxh6CKFwT4Dy35QzBaXUqEKQ909Cl
         riBuIh6kNP/Az9aYEa3sFB5yj38ZdO4x3bU+oS3vctg/CYVa1RODEMcOhfBMP2Ud2osy
         HIWzCTtsecJpfXiv847eRn/iRip6Bwf53HXVLJ5fUSefqs8puxUAeTn/Fn0W8XtJxJ4V
         iJrZbWPlrUetQaDloQVi9HktEjL2jT1K2n/PeAJ0U54r6aQAPXZI7HkeI82LPsbmBNtS
         byeFgh7zYEQFxKEHc62RMcToU/u9DkcOt0PlXZ6ToZyIWekpPgr5yohlJumq/65n4CnV
         wrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431017; x=1748035817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VVF3vRzj16BIxVOrDVzAz6hJgiBEUt5vcCXrSP3D1EE=;
        b=n4IwP5po5f7TeXuLTr6Y+TV2o85RywYkWRPOeMu3A9wKzmG1LUfJ+tSdsiFaU17Q/E
         OSXoeYJcCJvNB+KeZif5380f4sJVCaQ8ex46zgreMxOZUuJs3M8aTOg1vQUzRLZiKvyw
         oX+kJub2M2SPji/CNWk8ATyti8BI0a86gITAmnrIof9ym3ewhJlI4CsjaJjioRZIThgo
         daJ+1tlhdfefUL0aY9BtC+g0HRvlQ9Rt1jjSuY8Q+YpjEyelWOTIS5U73NmHEYf04fCh
         8iCg0aGqADEDSDO0ntPTcGA0e0tvLf+Gn1CCVebf/PWE7MX1/S0wAE0FDEcUbLYOSHam
         5GAQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2E/F0pY5Xz8j/FlviqW/3NQqrSuqo/XNeZ/8ROXqg8vqYo4sGA7E86JOLZhwO3J7BJjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfjCKoqyiHSo3N81kzzg9gvDUIkMGPiWOyv/JYJKslUeK+fQ/h
	2VqflPU9WEREWm9iK0aCEQpVyindri/e7/ySRSb6oLLEV6lDW45lDVPDWNb8ZjHvE0VxjSDkcNU
	cUfLHWQ==
X-Google-Smtp-Source: AGHT+IHkPYaluTndmSlfUiXGyyaJLXx4X+SBO5Q/4uaYOgx+OJqKuWd6RzYI5mr8azAci2LMYsf58XYaMmI=
X-Received: from pjbtb8.prod.google.com ([2002:a17:90b:53c8:b0:309:f831:28e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56cc:b0:2fe:a8b1:7d8
 with SMTP id 98e67ed59e1d1-30e7d5acb07mr7192751a91.25.1747431016716; Fri, 16
 May 2025 14:30:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:32 -0700
In-Reply-To: <20250516212833.2544737-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-8-seanjc@google.com>
Subject: [PATCH v2 7/8] x86, lib: Add wbinvd and wbnoinvd helpers to target
 multiple CPUs
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kevin Loughlin <kevinloughlin@google.com>, 
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Zheyun Shen <szy0127@sjtu.edu.cn>

Extract KVM's open-coded calls to do writeback caches on multiple CPUs to
common library helpers for both WBINVD and WBNOINVD (KVM will use both).
Put the onus on the caller to check for a non-empty mask to simplify the
SMP=n implementation, e.g. so that it doesn't need to check that the one
and only CPU in the system is present in the mask.

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20250128015345.7929-2-szy0127@sjtu.edu.cn
[sean: move to lib, add SMP=n helpers, clarify usage]
Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/smp.h | 12 ++++++++++++
 arch/x86/kvm/x86.c         |  8 +-------
 arch/x86/lib/cache-smp.c   | 12 ++++++++++++
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index e08f1ae25401..fe98e021f7f8 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -113,7 +113,9 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 void wbinvd_on_all_cpus(void);
+void wbinvd_on_many_cpus(struct cpumask *cpus);
 void wbnoinvd_on_all_cpus(void);
+void wbnoinvd_on_many_cpus(struct cpumask *cpus);
 
 void smp_kick_mwait_play_dead(void);
 void __noreturn mwait_play_dead(unsigned int eax_hint);
@@ -154,11 +156,21 @@ static inline void wbinvd_on_all_cpus(void)
 	wbinvd();
 }
 
+static inline void wbinvd_on_many_cpus(struct cpumask *cpus)
+{
+	wbinvd();
+}
+
 static inline void wbnoinvd_on_all_cpus(void)
 {
 	wbnoinvd();
 }
 
+static inline void wbnoinvd_on_many_cpus(struct cpumask *cpus)
+{
+	wbnoinvd();
+}
+
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
 	return (struct cpumask *)cpumask_of(0);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8b72e8dac6e..e00a4b3a0e8c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4981,11 +4981,6 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return r;
 }
 
-static void wbinvd_ipi(void *garbage)
-{
-	wbinvd();
-}
-
 static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 {
 	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
@@ -8286,8 +8281,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 		int cpu = get_cpu();
 
 		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
-		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
-				wbinvd_ipi, NULL, 1);
+		wbinvd_on_many_cpus(vcpu->arch.wbinvd_dirty_mask);
 		put_cpu();
 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
 	} else
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 1789db5d8825..ebbc91b3ac67 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -20,6 +20,12 @@ void wbinvd_on_all_cpus(void)
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
 
+void wbinvd_on_many_cpus(struct cpumask *cpus)
+{
+	on_each_cpu_mask(cpus, __wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(wbinvd_on_many_cpus);
+
 static void __wbnoinvd(void *dummy)
 {
 	wbnoinvd();
@@ -30,3 +36,9 @@ void wbnoinvd_on_all_cpus(void)
 	on_each_cpu(__wbnoinvd, NULL, 1);
 }
 EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
+
+void wbnoinvd_on_many_cpus(struct cpumask *cpus)
+{
+	on_each_cpu_mask(cpus, __wbnoinvd, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(wbnoinvd_on_many_cpus);
-- 
2.49.0.1112.g889b7c5bd8-goog


