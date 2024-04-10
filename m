Return-Path: <kvm+bounces-14084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 302C989ED94
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF783284D90
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A2D13D638;
	Wed, 10 Apr 2024 08:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e1WUOx91"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82A513D61C
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737704; cv=none; b=YHH6ErTzfYIxlRJnnKNRRTcOmt5ugaHmGpFdT/NRylNWHl7LrKFhLqu99CAA8gOw1VtDbsPJG4ZWgjo9NIbVvrS4fK1FRAHIQ3FgChJC8e64my65CH/ykJjhUCUNN94bucISWzQZzOdEBix4nXuB+yepNMKd/M89lJbkCqt92ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737704; c=relaxed/simple;
	bh=SNsqoj9eNqjKtvp5/K3OU5JaLw8PBS6M12dONrb5QKc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TjG7vXzaKMZHLbOJjM30K2TQFb2eftsvFVrjyRx6JJ+msm7V12NoCR6YrLLYoyrblM7xF9pWpvWei41LuHnuiVu91ey9iRLdkIfBV5CrCpyPiZxmU5SZvIGlWJrJKFnu8kjIMOoqNFZ8CEppP5nAWsLWpfu90NnhTrBja31u4uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e1WUOx91; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a52140ea1b5so20168666b.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737701; x=1713342501; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcC4Vj21DILBZiNE6/g7j9wakFMnVaxsPp20pxP4UlU=;
        b=e1WUOx91v37y0xQH63eMQO+Wx1GcQwYFQt7jYIhV6jYbe2F3YJPQzzo/XAIzYx6WAm
         xxKh3i1uGLdMHg6riiL29XRdsga7KOyxga4DCMVsduyBUyFPuD0HQmSZt1LviYMD4lCN
         L3dx1ZnGq6M1VWnAo2l1cQjDMuzvcIUmQFsFLZqziI0jfFhe6NzUCL6wmHreMhLrwV/h
         hS1MDEWhvWSrr6ufuwCZlLBWyV/V39c9smEs4ltJYOtaTtHNeqb5wezcz1dEATl3EGIt
         3NdenaOAysGRWfg1Z0JG2VaIv9itfF6fUTmQ1QCsCNwb8YdjBT9iJfNqqBUB3+/AT6Fa
         Idbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737701; x=1713342501;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcC4Vj21DILBZiNE6/g7j9wakFMnVaxsPp20pxP4UlU=;
        b=Q5oh/IEMHXXpjtFBjhLTVz/CRgiTJ6mAhS9QcYlLAYRk+VaOR4+1Hcjrlyx8pyu7Rf
         7NAtG8VsediQA7HvKDcgwBXJFRWSOUyNTzbRYone+jbpzfRaY9J/cCvJw6zBH7Fdib1F
         hSvJ5HDL8s7QawIESyx0ZXqmqxTiwHYf8ZKZ27KcVXG42lF5TOzF3k2+Aa4yUN0bJ83H
         +AOG5ncljKCT2ZSMLamiFsVkQOz0weejaq/Yzm792QzoewiFd18hk3WJowkiTqS8I079
         1hAoLLanDTGOuWipd99T8fBUBJRsiRX4UnQ4fsKFNg8M1GdHJ/OTIp7O8WDHLJ+aA4ly
         KspQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3cRGbsK7Ge2qtzi+2qabE2KDbWKxqlMOohciWi0WAfC6J1oOG5PPFFk4GPhTL6lcI9j0vIhbEERNX0i+hmQFHsf7t
X-Gm-Message-State: AOJu0YyWvB+8oX9xr6uRb3ZWeH7rBrpDtOX29hfxIN05PfImlokDgNj4
	VzBel1s4rCOBxnXgGXuJdplFOOlD5aH6zf0VyeQIq2HfOXKI860WYVLBevSryAx5dGcFQkt7D1d
	HEw==
X-Google-Smtp-Source: AGHT+IGDOlmZUNa/b3VDkvm8WfG9UbS0FH17m/cxzH6+qrZhejCFvYfRumRMzmA89IrkJpXU6vz+vw==
X-Received: by 2002:a17:907:70c1:b0:a4e:a068:7f with SMTP id yk1-20020a17090770c100b00a4ea068007fmr962531ejb.49.1712737700913;
        Wed, 10 Apr 2024 01:28:20 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id qq18-20020a17090720d200b00a51cdf560b9sm4255362ejb.37.2024.04.10.01.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:28:20 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:28:16 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 02/12] KVM: arm64: Fix __pkvm_init_switch_pgd C signature
Message-ID: <22rqvzc34ehoirj42j6q27gfkxj53gjuryvtqqwh2q5d5yggme@rffmqhcxmtvy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Update the function declaration to match the asm implementation.

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3e2a1ac0c9bb..96daf7cf6802 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bc58d1b515af..bcaeb0fafd2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt = hyp_phys_to_virt(phys);
-	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
 
 	BUG_ON(kvm_check_pvm_sysreg_table());
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

