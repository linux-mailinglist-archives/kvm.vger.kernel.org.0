Return-Path: <kvm+bounces-46884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E6AABA52F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D8DC7A8E54
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE7F281351;
	Fri, 16 May 2025 21:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EHwsbHb6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0504728032B
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431011; cv=none; b=NNGXOzzdIQ49e3sJHZMFHnOzGbNJSb50Dzwp/RO+UQNH2TZ2CB0dTLGxC+58LPLXKFsWIz90IcYsY+bVGKlSAUAHI+JFz63E210bevWNYSWAQij+ZFljbziWKs+wdPXNxMbs4UGL7gnc8eOX+32vbzFz4PHI4SF3vzViQ1ReMe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431011; c=relaxed/simple;
	bh=DIrrcPlHnq5EeZRAr8HvqCuhe1CzBiwfAT2oWIINOSE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GLbyrUGvq/7hAHyBri5oZ6lEp2/XyZkwjaq04ZtrY2Yl2kDkxbiaHODKjzeFeFJa2os5OdqJyRBh8dd0X1PRXagHWnu1Yrpjeu9OupgK9iGajDbKFLwPD1x7F57kpQB49fAqnHcgIU1kA2NMQevssksVuK4lHGq2nn09LO2a15I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EHwsbHb6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-231d7f590ffso9292285ad.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431009; x=1748035809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NqEHUZ2TPYAtGToYJi37fXESd2ZGwlNQjgbzr/1LJdY=;
        b=EHwsbHb6b4nydBI5mtDrWco7DDoaRbTr4XyYo+L9P6RrxK4689dEWQMgG6G6m2DatD
         GAnN+P0CNRAglsp3KI6G7O1CSYGIY7lG8caLVxo3eqgRZykG4RHjg3ScUaiCFSyd0PNt
         vCKKpzYQxbC8TcGL+rocujSmtSv8gTiCYfzWCEVPoCu8xFoOPPlKmXvAahXNDK5+Y0Mo
         0CWrU/uqwoINJ3/2OKm5kh2zAz/wdC3mBrviC0DDrhMfwjTb4eQvF0p9glvbfD+pYuyu
         X/l3/hS9NZzEuM40CyDqodKpdXmZ1fqifZ+aAqJMSmlJjp24BUJk1HM0XKZ4jGDFZH9p
         uoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431009; x=1748035809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NqEHUZ2TPYAtGToYJi37fXESd2ZGwlNQjgbzr/1LJdY=;
        b=dcCushT/dq0B9g065aQSWDMVxfRLxXWoxxpDrWVV32oNMceNvE2xVeSoAph1KJp2cp
         S9+6poErUCxYfiLwkkkGO1qXbK1SzHOAK413JPGPoClre1nehiGCin/UhMy0+YLX2rNN
         pzqUUAU+LyeZyuMSiCiNFwPZFe4gcpwDKjlR9RiGMsM41fajWipH5I0mQoopYsaXvjKy
         kE8kcw+O3d/PiTEKb42UPLf/+q0z4907N89IVStAwUbjDo681MNpiCUBDJ0nkkfQWose
         cnODO4CpGdHpSnIerr57o13SdY8fB5tn3FG625oaXng4KpXsjSSR4LqlVmR4NAOki13M
         gsvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaWM89c/fyeCsoIMChBF2iyh2ZIWGxQ4Zhmu/XmdSvkRa6iThH6ZCksHjfTj4Z+39wHiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbbMyXEVhOrZyx1DUHhOdDXIDhO5eJ7eVMuT771onEDrJTp9UA
	Sw+HBVK80rsWO8roWujcYPrmzAzxEfj3K/sXuLdMDFoEoemHNwfp8p/mQWsL83p/AsEg3WtL1J2
	Nc16IjA==
X-Google-Smtp-Source: AGHT+IHTq80VcqezatgmWlMunNaSOj4mkdrzwcQ+8bhQSnlwEViznyKrv/5A/SubVqL2ubXidQVjO6bdruo=
X-Received: from plbp12.prod.google.com ([2002:a17:903:174c:b0:223:52c5:17f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4c5:b0:223:faf5:c82
 with SMTP id d9443c01a7336-231de2e6c76mr46558255ad.8.1747431008643; Fri, 16
 May 2025 14:30:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:28 -0700
In-Reply-To: <20250516212833.2544737-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-4-seanjc@google.com>
Subject: [PATCH v2 3/8] x86, lib: Drop the unused return value from wbinvd_on_all_cpus()
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

Drop wbinvd_on_all_cpus()'s return value; both the "real" version and the
stub always return '0', and none of the callers check the return.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/smp.h | 5 ++---
 arch/x86/lib/cache-smp.c   | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 0c1c68039d6f..028f126018c9 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -112,7 +112,7 @@ void __noreturn hlt_play_dead(void);
 void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
-int wbinvd_on_all_cpus(void);
+void wbinvd_on_all_cpus(void);
 
 void smp_kick_mwait_play_dead(void);
 void __noreturn mwait_play_dead(unsigned int eax_hint);
@@ -148,10 +148,9 @@ static inline struct cpumask *cpu_l2c_shared_mask(int cpu)
 
 #else /* !CONFIG_SMP */
 #define wbinvd_on_cpu(cpu)     wbinvd()
-static inline int wbinvd_on_all_cpus(void)
+static inline void wbinvd_on_all_cpus(void)
 {
 	wbinvd();
-	return 0;
 }
 
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 7af743bd3b13..079c3f3cd32c 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -14,9 +14,8 @@ void wbinvd_on_cpu(int cpu)
 }
 EXPORT_SYMBOL(wbinvd_on_cpu);
 
-int wbinvd_on_all_cpus(void)
+void wbinvd_on_all_cpus(void)
 {
 	on_each_cpu(__wbinvd, NULL, 1);
-	return 0;
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
-- 
2.49.0.1112.g889b7c5bd8-goog


