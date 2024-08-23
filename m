Return-Path: <kvm+bounces-24933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C2095D594
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 20:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A04731C2272A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15E21925BB;
	Fri, 23 Aug 2024 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SIglpl5b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B944A1922CB
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724439233; cv=none; b=Vc3t2xX6DCp2/YwBNFr2MWMubpvfRi+/oB9c73YeNmPPNG6f2HK6U+G3I6bCZKIg4SUxxzWPJa9+vkXcO9b2azeDqIJ59+ybTlD01IfvoSJt9XxefWA2fk1R3NeRZBxlKExgooFDQGV8NPsh/3JCTKY4F+QCJ9En9+qjP1D5oss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724439233; c=relaxed/simple;
	bh=DbKaS9v1hLowfyFA8YQtCHNg0LVk6j3k68viAaH4Ds4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=jLyvb6PAmld43xnmqcyt2GruM6meuRtJStFDT0IH96qhwhnaOeAkm+ijL1qK4AF1WZYi/TmW1djK9c7NfVhBiTG1SIFLKGr8ESKbJc5jwBziipAbH5qx8gTf3wKeVu0Y/SsV1YYrfjsYX7ffwW3fPsIq50X9YmMKnFQpXxoZn3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SIglpl5b; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ac83a71d45so39616547b3.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 11:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724439231; x=1725044031; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KwMz41rbAs2jbwtsewipMfgHdQI9fhKtFZZhcI6NPZQ=;
        b=SIglpl5bZPDomhELz8oeoutz/1F8flJgR2x64o3hT48VMIBeBy7n11zVgxOctbUk3X
         4C1JSOOeH+aMFJ1qEAJ9etODDQs+yCiyBbQxnR7MQNBNobUnMfyNmWnAHoTTY3xyZYPt
         82fOqII5HTxi/UJKoAAApU+iYhqgmvte9NEf2DtgCgjtL9lAkUDoE+3YfLSrF9wTEyQr
         /1jlm0NWyDyjNDyMKnMoi7ZdHDZYz4XpE7tjFOlfmRFeyD2DEHdyeJ/lNcEc1ioddpRH
         XjbYPVcNOfUPbHjd+cJIOkOSH8SXyQwBalarP6pke/fypUIHHDUvIGQKwe/82yzC47AW
         FYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724439231; x=1725044031;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KwMz41rbAs2jbwtsewipMfgHdQI9fhKtFZZhcI6NPZQ=;
        b=NCZ6o64410/CCN+za7TfT9m+hGk/4BpLfAsl5TM1vsTM1m3ENWKfeGkQ18sJcsswoh
         ghL63wKSyuyOc2gBgjRbLJdzdN4yGcEkrrTZxiRBmMZea27guI8hbWk96+acuH2rq8ZA
         NrCic8Q4ShhVACSz5xh0aYwKCTdV96YYHA4qdq5McUv6uZUQqgp0H8AqJav75QbgurB7
         RMkVp8PYKqzUs45R23Rf3bYEjdQfEgpfUO127fzPvbh55O92buWcxs66Jc28JBVlxCwo
         gPRLMuquKC3AUf9+VGYwhU5kRa5z2UUkh425gpTuOLD+XrQOe5cTM9d/StLkd4SK9Jel
         CGWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAUFMpEncBJ7lV+42C0YGdqPzn0ZPLmW6FoH4SW4sSp0xB8zUtgoFf7C5Tu5zo83DkyuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmRaMRiOy2MrsRHhCCJidcYvNLqQwHzI9JeLuVi506SZ9aTrGP
	N91IIQWx/1P0XtHMq4Dgna8vN8UYce/2KrG9vykdgU215zm05F9IPbJmUgfYNRfpv3SABxUjRE/
	q5XPg+zV9pA==
X-Google-Smtp-Source: AGHT+IGt9OG3rVzE5j5b6W9ETNhjDkmgngAjvjwYxKrJostWZwYoOunXg/OItHw0FTuwyj8ghTwOFVUov2j50A==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a05:690c:408a:b0:691:55ea:85e6 with SMTP
 id 00721157ae682-6c628b96609mr66577b3.7.1724439230622; Fri, 23 Aug 2024
 11:53:50 -0700 (PDT)
Date: Fri, 23 Aug 2024 11:53:10 -0700
In-Reply-To: <20240823185323.2563194-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823185323.2563194-1-jmattson@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823185323.2563194-2-jmattson@google.com>
Subject: [PATCH v3 1/4] x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since this synthetic feature bit is set on AMD CPUs that don't flush
the RSB on an IBPB, indicate as much in the comment, to avoid
potential confusion with the Intel IBPB semantics.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..cabd6b58e8ec 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -215,7 +215,7 @@
 #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* Disable Speculative Store Bypass. */
 #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
 #define X86_FEATURE_IBRS		( 7*32+25) /* "ibrs" Indirect Branch Restricted Speculation */
-#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier */
+#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without RSB flush */
 #define X86_FEATURE_STIBP		( 7*32+27) /* "stibp" Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_ZEN			( 7*32+28) /* Generic flag for all Zen and newer */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* L1TF workaround PTE inversion */
-- 
2.46.0.295.g3b9ea8a38a-goog


