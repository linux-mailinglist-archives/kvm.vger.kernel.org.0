Return-Path: <kvm+bounces-47426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96203AC1824
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 928C11C02ED4
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7931A2D1F53;
	Thu, 22 May 2025 23:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xRAYAsoC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0F82BF3EE
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957070; cv=none; b=Pufx8FkaEi2z2rEHeSG+oersX7OCWixfi+pwG6+nfAOhYA4K9t25glQ0NsJaZnFYQAZiDi9K6feOFh+nPNqyx6VPO1LJtHXUULtD7kxE+wDYV05K+Kd2koUHbsOsjpv9h7zydBsubeJNLEzHbzYfFBot28dGA4q/GSRVNnvksYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957070; c=relaxed/simple;
	bh=LdrFxL1TgLnHv60eOYGpxumD1HywpJAHkaMLkE2on1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=koA3SpTq2gLXvxoCTeEEPgNACoToFWPtDZ9OfWZ1doDq56TgJ6zHNl74E15cKwZVL/ABb1M6L+SNCuq+VcEJvt1lMyFTsFuKJVISojuWSp2EDawIsRD4hqogdbZ/fCc7ASGrhPopbWj4gcjBBl2sMvGsrUcmZN6d43f3E2bFHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xRAYAsoC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9338430eso5370965a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957068; x=1748561868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=He1Fb8XWIhOrf7jG2epQVScv14uLcqGVLp5FewijIAc=;
        b=xRAYAsoCsf3MW5Sgw1xt4TXOUixbzuOwUv+4EXc05iRdWUqjAoOFrVIaSJ5BOyhBmq
         D37Q39Wtm0/9Ila9KKJdowyA1wSCaCqb7cklhHEPVpCsPDcmAtJ0Ebo1yd7SUebfqTgI
         f3PGK2Mb1VHjQENbDES3+QaeggsZ/vF2iQTCN2s7tAP87Nx0E2yvBqshJ1/pPQh0gg5Y
         MsXMS6uimtdBStkLxwsXh8BMnZXd+ouBtSUvy9vWHK0c7hFhDzsc9bQMJR6kmDhBaECZ
         X+V86FBW8MrnCc0bdMyx74SX4rz21Pr4/GgragoiBfBdtkENcLTd13CIF77BT5ldlHFd
         glRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957068; x=1748561868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=He1Fb8XWIhOrf7jG2epQVScv14uLcqGVLp5FewijIAc=;
        b=oeaeUxFR9Z3l1q+4SNk0hF8YIckdyB9BazU1qbw2rzvZhSZzk69cqp5haC8Vp/P8lf
         lO78aBE+nr2lBQklYCI8Yeas8L03crLOpwrLFwIrFpJ8m2PkgfVSOPWtSqOtvA6JNVmk
         naIM/fpNzM99Uql4e9V69RSGCMLJJzZv8P5Dx5fGABnAewgbwdtPoZOAMfaplxQOsbdk
         xX/atQpX5/xhJ9OAwM6yoBou+quUPRSvyta8n1jkgE4aqNnn+axmmQ24ERWhfbTjPBsx
         9ww9CxmNSvILyP8RIoDZSccSpFY2DxG8T8kf821VnW8aPxyMlywiaENRZl7y43Zs1k37
         Ocjg==
X-Forwarded-Encrypted: i=1; AJvYcCWCGASDwVZamKa557bHuMB69jdAPfZTcVFKVZs04HnN/QC9qvusxALcNyeWEb2yFkNa4YI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIhezPUwBbva0z4QvV2FA7lCf75C24ztGMAQxHJNVVoB9ncb8W
	TXRq37fvjfxCLEHpfFg+sbeD9zDBbxe1LGm8Mh5uV0RzNXYrGO5bX+qNzOWjwjSECKfxgS7Hqcj
	psprjyA==
X-Google-Smtp-Source: AGHT+IEY13ev1fFg8g1+XuY0Q3OScdgExPi1jAv5crcNvfE+k43onG6hdR5YtXe6pz4sFc3h4oa0wS9XN+4=
X-Received: from pjbdj5.prod.google.com ([2002:a17:90a:d2c5:b0:310:89bf:401])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5750:b0:30e:3737:7c71
 with SMTP id 98e67ed59e1d1-30e7d57e4e6mr38834925a91.20.1747957068219; Thu, 22
 May 2025 16:37:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:37:28 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522233733.3176144-5-seanjc@google.com>
Subject: [PATCH v3 4/8] x86, lib: Add wbinvd and wbnoinvd helpers to target
 multiple CPUs
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Kevin Loughlin <kevinloughlin@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Mingwei Zhang <mizhang@google.com>, Francesco Lavra <francescolavra.fl@gmail.com>
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
 arch/x86/kvm/x86.c         |  3 +--
 arch/x86/lib/cache-smp.c   | 12 ++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index e08f1ae25401..22bfebe6776d 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -113,7 +113,9 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 void wbinvd_on_all_cpus(void);
+void wbinvd_on_cpus_mask(struct cpumask *cpus);
 void wbnoinvd_on_all_cpus(void);
+void wbnoinvd_on_cpus_mask(struct cpumask *cpus);
 
 void smp_kick_mwait_play_dead(void);
 void __noreturn mwait_play_dead(unsigned int eax_hint);
@@ -154,11 +156,21 @@ static inline void wbinvd_on_all_cpus(void)
 	wbinvd();
 }
 
+static inline void wbinvd_on_cpus_mask(struct cpumask *cpus)
+{
+	wbinvd();
+}
+
 static inline void wbnoinvd_on_all_cpus(void)
 {
 	wbnoinvd();
 }
 
+static inline void wbnoinvd_on_cpus_mask(struct cpumask *cpus)
+{
+	wbnoinvd();
+}
+
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
 	return (struct cpumask *)cpumask_of(0);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be7bb6d20129..1d0e9180148d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8245,8 +8245,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 		int cpu = get_cpu();
 
 		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
-		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
-				wbinvd_ipi, NULL, 1);
+		wbinvd_on_cpus_mask(vcpu->arch.wbinvd_dirty_mask);
 		put_cpu();
 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
 	} else
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 1789db5d8825..b45e8baa69bb 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -20,6 +20,12 @@ void wbinvd_on_all_cpus(void)
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
 
+void wbinvd_on_cpus_mask(struct cpumask *cpus)
+{
+	on_each_cpu_mask(cpus, __wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(wbinvd_on_cpus_mask);
+
 static void __wbnoinvd(void *dummy)
 {
 	wbnoinvd();
@@ -30,3 +36,9 @@ void wbnoinvd_on_all_cpus(void)
 	on_each_cpu(__wbnoinvd, NULL, 1);
 }
 EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
+
+void wbnoinvd_on_cpus_mask(struct cpumask *cpus)
+{
+	on_each_cpu_mask(cpus, __wbnoinvd, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(wbnoinvd_on_cpus_mask);
-- 
2.49.0.1151.ga128411c76-goog


