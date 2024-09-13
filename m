Return-Path: <kvm+bounces-26845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFB569786D4
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86EEA1F230F4
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6F284D25;
	Fri, 13 Sep 2024 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="niQwaI9+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF064F883
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248772; cv=none; b=MY+YsfuW6OOQ5vyzMQmpbPxkU8QYlYeFIxpkZLwKiP1ooF/VH4dtud2IgvJxLzYMKijr+JlqcK1NztjocAW8/SZvIn/2aZcYi6jzbDkLmifVCRg8G00bjZdUjKX67UxlfIp1fvN4XQNcOhein5izFRBlTKaUrjNV1wUhcAZXgaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248772; c=relaxed/simple;
	bh=lyEUOp7yyG5TGF+bGoNH8TP17o0yuwPTlbekxn+hnYo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=UeT7Oc9Go0hB0JpRoWs5JMFoBCxV2gSB1Vqw1RYqWvlWLG0KPLmzPqo+x4DzEOz1XA4MpdfpFgNceNJKfx/rNoYuWeiOiW5dz9c+BZ+K3Lj29bp9mfnfj++rxiiN+CWzS6NXW85K2IaVNejhyoC3j8/0NjWz+NlIDMUFfR368OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=niQwaI9+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71930797560so1958675b3a.1
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 10:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726248770; x=1726853570; darn=vger.kernel.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=91RTRIi5vowPNp8C9+ogp2zeY4jmVB+O69eyfUOWRpA=;
        b=niQwaI9++RfA2O0Yu+RAG6O6HRM5v9EFQLXapAd57WuBP4u9Wm9HhKCR5kN30RwnYD
         X8G8B/bLsOXj4m2P9rq+49D8gAZYVjUSYpH9EI22xEUmSAP7jhPTzeZWQFb4b8ZvqGIT
         rdatnV5AAexY9qzkWd9ylyRcQilz91amza7GqcKSwb6yV/O2lXJrIxP8ZCciZh5nCOAZ
         yKcMj7oXDDgATmshch0dkrOwV7XaW3MDbEtBmE/pj9ZvMa1V7Wa2VboyCmZROYKmvsgS
         uJWrjE6WO/mDd8SGyT0nRq176p4HGAY4asSB+zTqX+v/QhnnxQk7Zs08bydMlz77JBkb
         ECiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726248770; x=1726853570;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=91RTRIi5vowPNp8C9+ogp2zeY4jmVB+O69eyfUOWRpA=;
        b=mS32Z4GkAWWQ6WC8j1Aw0/H93pYgQeTxfxtW/Pw9QJvTOQQ6jU/AYwTW8vRubtu7ng
         3G+H7xGHVGXXpDbRgvPMUS1T9rmqhldBGiT0duDAZRUpb7xpeCk5/cizqiCYln3tkFue
         C5oAQpLa9t3fszXDr1M01M63B4KDk3fdvXwpqUiZMLPJtgvPa8gYo9S6y3sjXC7ZoTWg
         skSjcwLSs0lCnrgVRPo6kiy5ndwIgdoW72yUigoaSRQaE0bdxGO2rd8BKVWqawBTOMvK
         Fwf4HVvcUDUq/TSOLFegaj0NZDUje6DiIBRsq9dk/MryufBtlojolYZSgQGCg1jCwk4+
         UOwg==
X-Forwarded-Encrypted: i=1; AJvYcCXbpfIvbzyKs/5S4AVE31Y9LPq8/1UUC0vIDQbSamKywqSHtWF1PDZ0Zau7rm5NeQ+D9D8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2DkrbROmi/qii8rGN5UyRJi25tMxGuzG9emKIN5siUbu/fsym
	/4Pma24oA9m8DXpUjS4INWCU83MC2lGhR6M5KDI5i6aCGgETlOk2YIYCHTVyVb2KWQGpM829Qz4
	a+UKvHLVZlg==
X-Google-Smtp-Source: AGHT+IG1pwPz6NYQtTl15SBWiF6NhPLYBGU7lbYLmwsArhUnps0AUyBOh5iGDwxbKPx/1KBqTdSDdJ5gbSx0pg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a62:ab11:0:b0:718:d519:20e2 with SMTP id
 d2e1a72fcca58-7192634303bmr13511b3a.5.1726248770272; Fri, 13 Sep 2024
 10:32:50 -0700 (PDT)
Date: Fri, 13 Sep 2024 10:32:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240913173242.3271406-1-jmattson@google.com>
Subject: [PATCH v4 0/3] Distinguish between variants of IBPB
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
terminology, the RSB). Hence, the older version of AMD's IBPB was not
equivalent to Intel's IBPB. However, KVM has been treating them as
equivalent, synthesizing Intel's CPUID.(EAX=7,ECX=0):EDX[bit 26] on any
platform that supports the synthetic features X86_FEATURE_IBPB and
X86_FEATURE_IBRS.

Equivalence also requires a previously ignored feature on the AMD side,
CPUID Fn8000_0008_EBX[IBPB_RET], which is enumerated on Zen4.

v4: Added "guaranteed" to X86_FEATURE_IBPB comment [Pawan]
    Changed logic for deducing AMD IBPB features from Intel IBPB features
    in kvm_set_cpu_caps [Tom]
    Intel CPUs that suffer from PBRSB can't claim AMD_IBPB_RET [myself]

v3: Pass through IBPB_RET from hardware to userspace. [Tom]
    Derive AMD_IBPB from X86_FEATURE_SPEC_CTRL rather than
    X86_FEATURE_IBPB. [Tom]
    Clarify semantics of X86_FEATURE_IBPB.

v2: Use IBPB_RET to identify semantic equality. [Venkatesh]

Jim Mattson (3):
  x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
  KVM: x86: Advertise AMD_IBPB_RET to userspace
  KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB

 arch/x86/include/asm/cpufeatures.h |  3 ++-
 arch/x86/kvm/cpuid.c               | 12 +++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.46.0.662.g92d0881bb0-goog


