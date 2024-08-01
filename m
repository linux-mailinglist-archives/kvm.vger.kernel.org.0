Return-Path: <kvm+bounces-22844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CA4944258
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81B19283F55
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272B114885C;
	Thu,  1 Aug 2024 04:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TojKWnip"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F68141987
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488373; cv=none; b=se6R47rm16uBAoVgWSOFs+cQ31fWwE5ze73u6nZP60r8KI/KQLejGdhxRKREK9wxisybxMb0MMAr7tB9nykG8dILSvk48uhemeJM9Zd1j43+xZLTi4lCGy8id0YbO0m0RpjRnS49Ts06aQd+Bx4p8vMBbd4JSGFXZepNrFB1AsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488373; c=relaxed/simple;
	bh=U9q0KA3ceAZtvfLGiI0Um1mr6SQ6acjihjd/dq5pXZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qs7G7QmNPS/6+CiMIO/VCg811BrecO8a1jI1kF9MO801Sn5kwb/NiTk4uCbZ/PV/iHNSZPRGQ71VJgtrx+/deEvhr3rxhZ5zgSUrRoixlf56hl/KzaLhftBqcHI05wpIUtXiyCY3Ro0SkiyuLojET+iV5R4IGiepCH/f7zdp/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TojKWnip; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb6c5f9810so6593797a91.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488371; x=1723093171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EfFo/7SOA2NaX48pCngKagowZ/hRWebUXr42Y4/rrHs=;
        b=TojKWnip8flvl93DDu4hmLwAAFDfPhTI7fsB/LESFyxKszGYKMxD20Ua+pLmSDGnuW
         mGwYIhXFNOOQMewUYymaTHsPOPk2GimCuRqLfF/gRcYxZAMT4sioExoMmZFk0lhO66Bi
         ItzRvD/3QZkhHZONAY5ECD6M+YmfcgeIlDS5QuKQyEnzAzSx53gocb8Po1DX0r9UyjFK
         jfl0k42ok+6JYltXOvRDqRyyi9Etc0RA/ppzmLYwOD7ijs51wjvQ/ONqJSi8pa+vNGbE
         6FLGe7chpvaxoMBDrHjf95XzfetTqWjsok431lrLhGK3Be2Fc86BThImHZRfRvvPqByD
         7MUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488371; x=1723093171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EfFo/7SOA2NaX48pCngKagowZ/hRWebUXr42Y4/rrHs=;
        b=Tz3KuFvO5EsEg2DHUGrWJqYJQTUbN9UGm8TQS2ol6xuCoMC5UYs+6JfHnLYR0Wo6EU
         SIcZm5BYkND8Ps1jIdTUPHMuS4QuV1NlTxm5CkjuSHcY2IQiAe4ciCrA3hWDqFLHV6y3
         yBDMuK2bjF9IGUOD5fmHzSDyyVQDoJkxhcP/74DS3ijwd/0Yvfoq6ysIIlRwlAXUS0OL
         67B0cjOjv2Zv60hfozyo+p9hiAm729MGWQIrMgp3UKGCt5PWx9uxGyJBvNXbN8MsjC3d
         EbKEzJwUFAKBzrqvDDInvKUu5G/igmP6sBjTjelmH8nxOZs0qVdqqwswG3j9XBKpsjuR
         thkA==
X-Forwarded-Encrypted: i=1; AJvYcCW8YIAULCJSli3Nh4MKw1qIiO283HCtAJ8+s8UIWmXOaTnF4d5FnwQdwgmvqDNiE3FaBnqA55UUNrBihm/gKZC29i6N
X-Gm-Message-State: AOJu0YxPmDHUeTA99bYqjWx1tDYXYvMG7lVCcjrj/MS9oFaUKcIeeBvp
	hM0GKhjyhW95nkVKr7aGNyIiUSjpecYfAgOHVphNYSV4RgflbXV9j4iPQfko19HmiEhDkzXRM7+
	+rxWvUg==
X-Google-Smtp-Source: AGHT+IH80Lb85B5R8lk+f773M0uEW3Y0z51r3A8XQV/UqIsQk9O6qLgF2FJ/z2vQpwIO9/0ZtI8d/04lsfh4
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90b:1b06:b0:2c9:61f9:9aea with SMTP id
 98e67ed59e1d1-2cfe7b4c4d2mr70658a91.5.1722488371281; Wed, 31 Jul 2024
 21:59:31 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:20 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-12-mizhang@google.com>
Subject: [RFC PATCH v3 11/58] x86/irq: Factor out common code for installing
 kvm irq handler
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

KVM will register irq handler for POSTED_INTR_WAKEUP_VECTOR and
KVM_GUEST_PMI_VECTOR, the existing kvm_set_posted_intr_wakeup_handler() is
renamed to x86_set_kvm_irq_handler(), and vector input parameter is used
to distinguish POSTED_INTR_WARKUP_VECTOR and KVM_GUEST_PMI_VECTOR.

Caller should call x86_set_kvm_irq_handler() once to register
a non-dummy handler for each vector. If caller register one
handler for a vector, later the caller register the same or different
non-dummy handler again, the second call will output warn message.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/irq.h |  2 +-
 arch/x86/kernel/irq.c      | 18 ++++++++++++------
 arch/x86/kvm/vmx/vmx.c     |  4 ++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 194dfff84cb1..050a247b69b4 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -30,7 +30,7 @@ struct irq_desc;
 extern void fixup_irqs(void);
 
 #if IS_ENABLED(CONFIG_KVM)
-extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
+void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void));
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 385e3a5fc304..18cd418fe106 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -312,16 +312,22 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
 
-void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
+void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
 {
-	if (handler)
+	if (!handler)
+		handler = dummy_handler;
+
+	if (vector == POSTED_INTR_WAKEUP_VECTOR &&
+	    (handler == dummy_handler ||
+	     kvm_posted_intr_wakeup_handler == dummy_handler))
 		kvm_posted_intr_wakeup_handler = handler;
-	else {
-		kvm_posted_intr_wakeup_handler = dummy_handler;
+	else
+		WARN_ON_ONCE(1);
+
+	if (handler == dummy_handler)
 		synchronize_rcu();
-	}
 }
-EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
+EXPORT_SYMBOL_GPL(x86_set_kvm_irq_handler);
 
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3c83c06f826..ad465881b043 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8292,7 +8292,7 @@ void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 
 void vmx_hardware_unsetup(void)
 {
-	kvm_set_posted_intr_wakeup_handler(NULL);
+	x86_set_kvm_irq_handler(POSTED_INTR_WAKEUP_VECTOR, NULL);
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
@@ -8602,7 +8602,7 @@ __init int vmx_hardware_setup(void)
 	if (r && nested)
 		nested_vmx_hardware_unsetup();
 
-	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
+	x86_set_kvm_irq_handler(POSTED_INTR_WAKEUP_VECTOR, pi_wakeup_handler);
 
 	return r;
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog


