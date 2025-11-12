Return-Path: <kvm+bounces-62905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1564FC53D21
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 50C794FFD0A
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BAB0348886;
	Wed, 12 Nov 2025 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XE6L3XRY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE0F347BD2
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969191; cv=none; b=euPi+bbc3/LyCOcsoIy/Sk+kpgpP3clnIjMB8HTiOCd93T5SPh3oM0fOGhW3YBfSAViNQCMUVJaiU/ZHafz/Y2TQ3WPZe1fvR25z/mJY9i7AgPbg1riTlrI4m4shZVmhXi4bQ9n+vVdnXH851RH+dztfqgxRJa9sQK1F44VzG7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969191; c=relaxed/simple;
	bh=3wjLaIqPwLhtaQu3sd4+Wy6uET4Lt+dOtxB/f9/oZG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ep8pCl5+Ylih6KdK3K9tXQYqr4XQejB90gRwu11MkIrLbQDnfWRjrDa1bYSFJzU56Oj8KzNNypE1nz2eXv2HZM/n2dnUI7yCezU2/gA0XSiAfTEPZxPgrG0qVBpjPFhnC+E/WO7EBL02MIiMwpVBmcU605tV8Wd1IIyNBe0uv+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XE6L3XRY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b969f3f5bb1so2784545a12.0
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969189; x=1763573989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B2W7BhYEA5i1i5woy4wPEVZBPGLjZrrhpv/7K43a+Bc=;
        b=XE6L3XRYIGnHXqzE2hZSNKwfPkIn+KABRpvnxQEPdhP4eA0mYWv2Mc2BVdivuxLdGC
         ZyUgylMBRHQymM1eD3cF0fpF5z5nj434JhRQjsYJ1aH/v+rzubvMv1HHU1vXM7BObPU1
         dLKdhw/05wX81YDE9rPIi6yMiWbYWC2cTVnK86ExM4NQpInpklfh+zQYq3mVYh7lv7ZU
         mDOXvlacBI6ZSswAXjmtkZAMa81eIEFBTASlnbKDUhjC7SD0EZVUunJzBsmV71JiNh7o
         G/Slb6srgBDzWkTVnEf7deRzZKKv8sGasq9mDjy5DiIuO4bJEkuOfb5PekIAfo0XX7z3
         ICtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969189; x=1763573989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B2W7BhYEA5i1i5woy4wPEVZBPGLjZrrhpv/7K43a+Bc=;
        b=QtannmFPV4bsrdnsVWDxsPKLHn+ArQrxyjKclaAbBPYZLN9zcbyd1r6wzbVwyUVdN1
         RYAuzVhKCALk9+s3cr4rwo924NfqEDMWlrtM8pSe1AkpjlFCzYOgeAiusfxUFudqFJgK
         9xKTi2E95Yc77akjepMkf/zRUfS8dKgYGfNq/x3UbUtiIlRL/XH2kzc1m/8h6aYqeNYG
         rd/OjvLJgZKd6fq0ue2EW05160kzPVYHIcvSFmAUWJCgWV2EzYwo9BWr3HmROqGqr1eV
         PT47mGS5aF1bZuJOLTcAE143FDaqdg5tOgWjmXWNi+C1KPTsIbjQNYCtNc2I1Z81k1kO
         lTAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWovETS9HhWZ5SF/fORlKkhig+jwEkoSucHSeDHHpF5YjZPJpaA3XqkeAD7AAf4r/nQaF0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpfMk/Pa4J0oGgdX59KWXkc+q7Pioo/YibTUpb8cCbq8Xq2zvl
	+LV83a2LGHRSZ8Wkb1cwmM6HRA+eS+ZIriXnkLZ5y18jlRzIXGwlQefpsk+d66PteniNKK6RfNU
	7Vl4nSA==
X-Google-Smtp-Source: AGHT+IGQoB1Kabu3uhkCb7ua9Zbxd1SwMYzdy0+WZvzbXxJsOOkw0xVig1+MnTLbGmRa1/KiP7NDHIAhv+E=
X-Received: from plbks6.prod.google.com ([2002:a17:903:846:b0:27d:1f18:78ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2c9:b0:297:e66a:2065
 with SMTP id d9443c01a7336-2984ee00891mr56835055ad.56.1762969188545; Wed, 12
 Nov 2025 09:39:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 09:39:41 -0800
In-Reply-To: <20251112173944.1380633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112173944.1380633-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112173944.1380633-2-seanjc@google.com>
Subject: [PATCH 1/4] x86/bugs: Drop unnecessary export of "x86_spec_ctrl_base"
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

Don't export x86_spec_ctrl_base as it's used only in bugs.c and process.c,
neither of which can be built into a module.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d7fa03bf51b4..57c1d0ed36a5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -102,7 +102,6 @@ static void __init vmscape_apply_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
-EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
 
 /* The current value of the SPEC_CTRL MSR with task-specific bits set */
 DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
-- 
2.51.2.1041.gc1ab5b90ca-goog


