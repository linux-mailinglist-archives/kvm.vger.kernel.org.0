Return-Path: <kvm+bounces-14087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62C5D89ED9A
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8B0EB235E6
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DE713D62A;
	Wed, 10 Apr 2024 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3iMhqC/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D6413D605
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737739; cv=none; b=OCMmsg2KlE87MRN7bYidYv1o2MyrLBtBt7+RSTinfTsqZXaV/MDk5B79Xr1GKrJjIdLQV9YBLfCiAltBKVK856ORoY6meIGxbC9ixwjqhBuD2zjh+2ewp/D2th4WZoqcClxyhMycmrrJWXfwASLcSpKYX9KNKKB6QVvqX6JtP8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737739; c=relaxed/simple;
	bh=OKzpp3vLMjhEjznNuaqC33ICK4wZMPNfg/0hzxvwLzY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RsVzjzgAwASMGuxjI+7O0c41N1iaYb9fFVJmuQwQ8dwFXJRAuK+0n3ig/cPnKwVUOYy2cGSMqD+zB4v2RZoii32xTPN7htWBJzKDeeVw/zC+ALa5JB6Nw+Jvh1NhogDJ+DwvYU4ZJFQY/N0g6tspFtHMqNA0T2cQ4ZPJrrhs6hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3iMhqC/M; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a46ea03c2a5so1070356066b.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737736; x=1713342536; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=henblBD0eejAfMb1rp/7/m+PwpPrco2Rcp0q8OTMVVo=;
        b=3iMhqC/M9TvdaMWx2wpN/rsCrvBJOyPCxICsfzpXzFvsCrjBPAbeONzz3+YJsBIUGt
         1XDvkq8SrMTAoEX7OyTKAgF3TFa/lavrHYG4oZK95hXAe5PCI36zSiI60yJPPv4Brd5+
         q5+ebXblrKR7yBTiMEfp0TFvE+fcGyezqjULal3LUxW8l5+GveI4vQb9i/ntpF9Z+wKC
         p7RSTTP3teSp1/UttUzzc9F5ah4ocoxvAT2IV377NC2l8kySsIKvGCWuX14CF08Koedj
         WirCaOfQnYzNs+52MtN2db1jwlJuNPS9RVgQ/nrxSjIJKEApL9vgLgPH3ty+P2ku+GMk
         kqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737736; x=1713342536;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=henblBD0eejAfMb1rp/7/m+PwpPrco2Rcp0q8OTMVVo=;
        b=h7mnRbVbgiU5bhcWw3bIg/cOF4/i5H7mv/i5vDJZr/wNie6zfV78ke1fd3HKyRGE0B
         0Lg1d4a/TIlW8JN7TZuCV1hYAZb8Gdu0XV54+OuZw7BjQmOCW5bLMEm1WV0SaTuwFfSY
         l6AaqVuoKRPO0j6FMY4FFYtzjPuVNxRufilFsnxW6kV4/JWxUxHMq5uxwIQbFJLaqZ/q
         TH/dkr9xrzFpOUMpFaQEQOR6Zhpv9nKuXw9+E9lXxxCieZA4W0qFLWV8cbDXkSmrtfer
         ArSYXqFMfFyYuENHZuwuis+6PbMYA60KySWPA2OS94BnuscTYQcPmi2HY7uCH8ySya4b
         gRaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVf1PQTajJKQ1EnLRdv5H3kwKM0UftXpBlYaBcQtyavBmi6196aqTbx402gk+IELlVXjHqfSzZM3zy9GAUGxE2xPGzr
X-Gm-Message-State: AOJu0YzRN6ggSSc+Vx/RucsjH94y8Fhk/fxhMYgGKV2Ysgwd5bg7GppE
	O+RB8g6yAFEsvIullrPEMi+EprQiTs818897cImjgq7asknn4ikEGLRRJHv4eQ==
X-Google-Smtp-Source: AGHT+IH9EfTrxyP8L2t1ExqRK+qnv2iao0ut7BEh9JmB6lgatiwZJEUZjeaWiTsf3pfjLvZRGVJW3A==
X-Received: by 2002:a17:906:fd8d:b0:a51:e188:bced with SMTP id xa13-20020a170906fd8d00b00a51e188bcedmr4535131ejb.37.1712737735696;
        Wed, 10 Apr 2024 01:28:55 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id gl2-20020a170906e0c200b00a4df5e48d11sm6698623ejb.72.2024.04.10.01.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:28:55 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:28:51 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 05/12] KVM: arm64: nVHE: Add EL2h sync exception handler
Message-ID: <knel4xbyamvyhxe3yd6e4yyqxpwagk36r56zsg63fzlfbevrxe@smuav5udxoo6>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Introduce a handler for EL2h synchronous exceptions distinct from
handlers for other "invalid" exceptions when running with the nVHE host
vector. This will allow a future patch to handle kCFI (synchronous)
errors without affecting other classes of exceptions.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 7397b4f1838a..0613b6e35137 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -183,7 +183,7 @@ SYM_FUNC_END(__host_hvc)
 .endif
 .endm
 
-.macro invalid_host_el2_vect
+.macro __host_el2_vect handler:req
 	.align 7
 
 	/*
@@ -202,7 +202,7 @@ SYM_FUNC_END(__host_hvc)
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	__hyp_panic
+	b	\handler
 
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
@@ -212,6 +212,10 @@ SYM_FUNC_END(__host_hvc)
 	ASM_BUG()
 .endm
 
+.macro host_el2_sync_vect
+	__host_el2_vect __hyp_panic
+.endm
+
 .macro invalid_host_el1_vect
 	.align 7
 	mov	x0, xzr		/* restore_host = false */
@@ -221,6 +225,10 @@ SYM_FUNC_END(__host_hvc)
 	b	__hyp_do_panic
 .endm
 
+.macro invalid_host_el2_vect
+	__host_el2_vect __hyp_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consuming
  * SErrors that should only be consumed by the host. Guest entry is deferred by
@@ -238,7 +246,7 @@ SYM_CODE_START(__kvm_hyp_host_vector)
 	invalid_host_el2_vect			// FIQ EL2t
 	invalid_host_el2_vect			// Error EL2t
 
-	invalid_host_el2_vect			// Synchronous EL2h
+	host_el2_sync_vect			// Synchronous EL2h
 	invalid_host_el2_vect			// IRQ EL2h
 	invalid_host_el2_vect			// FIQ EL2h
 	invalid_host_el2_vect			// Error EL2h
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

