Return-Path: <kvm+bounces-62906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D9544C53BCB
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:41:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7B874344E41
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B4734B1A7;
	Wed, 12 Nov 2025 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y3tyoGdq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8F63491D5
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969192; cv=none; b=bPrxzsvtXHT7AkuhzLF3olHTmynaZpi2DrOl5m6A0CyEsHIiUIYbi8VHZH4niA2mjNrYYbthVepqhSKh2zISkvzFcjz9CAxVqqwHuVvgbihTNr9EHsT3pP8u0rjjHttbfTjiUSC/c6fO+Zhee43IvjbQPYPY0+eCBR9Gl7A45AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969192; c=relaxed/simple;
	bh=WiNWbvfwoo+8EdAa9Uz8Q0T/2sNuMxxs4D8jJ5u/WA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G9jAF49byqrnP/ObLYNZqckbjXkHfBtvkrwEYaKYrJ9vBc/vg6N+05lJwPmKzWYSVKiGiwzGCg+iwQXP/HcJl/CnJSliv6CyhiTH+4TJ4sjQcuqvQdA3on2swK7/X05ZobxiznQseaLrahBS2fDW5iPcBCmBo7FyEqWVWC60Suw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y3tyoGdq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-78105c10afdso1216136b3a.1
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969190; x=1763573990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3jB11KRi3IX+N8TsZocIARdIpUY/Xl/OcZwePjrIV+8=;
        b=Y3tyoGdqbebJ/iYR0RzdyQOMJr0PQXO1K+T54w9ajGBsNzvAQIOcBxd34sb3SDUIN1
         Uwewv+rSjoTz6PjZUjw/rKVp/F7PhrPhbnrYNRuvauRVAoJM/LPX6c94P+2iuSNuit4x
         1G7wra4+l+EBsIWMFo7nqrlZ1YRlbMai2sCAIgd5duYJpW7UI/qq7WutrL1uYaAt5a7j
         HifApJZMfD9Lx9xGEp9p3Sm3fjPREK0f2jQ10Qdl+ubFz6RVvhhL/ycu0BUGXItqgK5s
         ZS8q1cX7Tw1Hx4YfprbeMtf14uVFawUce+uc6m1QnlPTWsyE/yVMnZJV0vDd7PsWrXBI
         8f0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969190; x=1763573990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jB11KRi3IX+N8TsZocIARdIpUY/Xl/OcZwePjrIV+8=;
        b=AdhMOy08q+X0FEEV+hq20IUcxc5dAsYMmBoW84oPC70zY2boMDdY7YdS0cGfGDkwtu
         74KP4ItFBeAf2LrHhcJYdF1KbBDkIH7RNU5a7WmUVoVMaLmU9vezpHrzlpQghHnitb8d
         gZ5eWnbX11S4VK7zE9KcynqyUWdHO/kpxSaYqv3KeUGvPXhbiNjJaX8wscVT5IXMHqFI
         xov/5NiyX7g1o7s9Vf68DKQvQuIR61I3I0dOcTy+r5B7L42IvqJJ5Yd+NCTboXg+HyZf
         ZCqyzekUoH1DqC1KN5VcKtSlW0yDoku20O5rsTk6fjLnnCTjBWQqi+ctJJklDSg0TBFa
         J+0g==
X-Forwarded-Encrypted: i=1; AJvYcCUp48pd0abR4AmrQZWN7FqRvXa/5rT5qo1ge0D8KXN6W5Y+vivVQW1lce/0scX5AjqyohM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTEZcab7YBAZZJbOQcdSY+znZnIz/4T+fQovqwZhFS8sBF/cTF
	jqtaUvvFGi9fsLXM8+4gdX+YakpHmJy7A87GkTw8Qt0/iMb4fCxmYUUeyJLhPAyiN0enrUyxjvv
	HsryQkw==
X-Google-Smtp-Source: AGHT+IEzUdshi4KJh5WFIAXko+n+YEgi4OqqdjsC4s4GZ3jRZGaScEAL16+P4T3e1ewsgL1T8TGXhgEoctI=
X-Received: from pge1.prod.google.com ([2002:a05:6a02:2d01:b0:bac:6acd:817e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4305:b0:343:9397:c4d5
 with SMTP id adf61e73a8af0-3590908eb63mr5330693637.12.1762969190457; Wed, 12
 Nov 2025 09:39:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 09:39:42 -0800
In-Reply-To: <20251112173944.1380633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112173944.1380633-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112173944.1380633-3-seanjc@google.com>
Subject: [PATCH 2/4] x86/mtrr: Drop unnecessary export of "mtrr_state"
From: Sean Christopherson <seanjc@google.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org, linux-coco@lists.linux.dev, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't export "mtrr_state" as usage is limited to arch/x86/kernel/cpu/mtrr
(and nothing outside of that directory even includes the local mtrr.h).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 8c18327eb10b..0863733858dc 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -89,7 +89,6 @@ static int mtrr_state_set;
 u64 mtrr_tom2;
 
 struct mtrr_state_type mtrr_state;
-EXPORT_SYMBOL_GPL(mtrr_state);
 
 /* Reserved bits in the high portion of the MTRRphysBaseN MSR. */
 u32 phys_hi_rsvd;
-- 
2.51.2.1041.gc1ab5b90ca-goog


