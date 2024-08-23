Return-Path: <kvm+bounces-24935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 225C695D597
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 20:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5D121F236EF
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E437193094;
	Fri, 23 Aug 2024 18:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AB7cH2+N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCA5192D6B
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724439236; cv=none; b=jZwPtutCojOvzW5tOHPdDnTIyOzQYq2EnchPZv1wkAHp65n87kVWnwQiTlxXbCf55uPtwaFfEFBTaOmGmuggTRqgQoUIzjmiE/78A0NCZqIivretMQVFyw8LKwlTb2sH0HoZYYEMD6hH/NUmDGmlA1+EoozBiLsqCIlCjFS1eEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724439236; c=relaxed/simple;
	bh=NbZ6C/T+ZCVhDcFWCkfg5AfdlArNrEwsL3Hq4JGm01U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DTpphaZajnz8lIQZMxU/K01MaceSt4UR9f88trq4829iYHWomRt5phWkoPjX6GtREWtrdSU5qdUFD15hcSleAJPHKbaA2zZNMN8DftSF25CR4k9noCY5FzuJlXTx4CFREj6dZZG6EF0S9tPIN+IXugvICVaIFqz/DTRv/TwH7fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AB7cH2+N; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e11703f1368so3255136276.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 11:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724439234; x=1725044034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MZhuyhwkXzq5TLpNWTsJTlY8QsgB091bBfZe2SCWV7A=;
        b=AB7cH2+NFVAmFBTOcluuqyZUyS7gRY/HCenqd8+oaI/JRk/JmzPey5sY3ux4lvZQyj
         iEyK0SKHNSWvk1+TyWSLsL0zPRoaXiG5VWzxLDf1aTlJKBJ7Es8FGlAIhjiF/uf+xERj
         9RcaAAgZMOv7QvMYgsZD95jZGqgOSNjxPKoTmrjdF4ri2ZqhqPOYfZ1jM2b5gQTx2F7G
         /y0pS5TzPhuRg92vEZBYkCta6uTeGesplSjaAU18eHLnmrNKMYKRnx+aFzfD3+9th0fk
         L6aH9IGrTTOWFF8PMrtf9cbgeFD4euuGHqLmF61rpF0yeFSEnQc2/1IQKtSnyhK1MSE5
         zqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724439234; x=1725044034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MZhuyhwkXzq5TLpNWTsJTlY8QsgB091bBfZe2SCWV7A=;
        b=OPzSwEKGm485dsO7PDDunDuwvzMNGQzgEyj5xR5r4PbUi42id40mfqUZ8k7e8xm13b
         a1ckITa5wFBN0338s8Rw88KNiHJWoFyOGOrXbSUEq1UJv/mUlkhzLLOWmHsxCo0LMZpj
         x52IkQsu/8mSbjFEq/VHaE4rLdTTRBTdC9edB18cUl1g2m8EqO59KB7ZOF65dJe6/8Ks
         KStOrXcsqy0NkWR8vbxL/V3m9syi6IkWr4gVEyVqhVUDLqlCcJ7r6jkAlE5O0/8uF016
         L46VPcz8jEZJ6eIYO/IHJGBBWVTF1Xn8Q7V8YI+mYCJDxq+Xz/qxmXCCvF42raxeorxH
         ivsg==
X-Forwarded-Encrypted: i=1; AJvYcCVne6PCslvdvx69e/G8ZnxJ3hwX/2rr0w+neQazYeq5mRQppX+5of48E0JwhPeF6ikmmIc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvgmhLhdfEcoUJYUkMYHSUNe1C3T1+bscgbOcZYDID5ttxHPlj
	oX536NGVt6TaQqRWw+5ani9HJKKUGulC7znRVfhlu3sTBwaUUzs19aVxUOUQAZ7EOoZ8lrb33Jw
	g6SeIh/ftdw==
X-Google-Smtp-Source: AGHT+IEypgUJ5wnYpxkM8UoctfuiVZ7zGv0wV5gsWQk1EXSBHETI8UYVQUPub68MaSVJRIAEV6qFA/ajyKJHpw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a25:bf91:0:b0:e16:67ca:e24f with SMTP id
 3f1490d57ef6-e17a865aba3mr4635276.10.1724439234156; Fri, 23 Aug 2024 11:53:54
 -0700 (PDT)
Date: Fri, 23 Aug 2024 11:53:12 -0700
In-Reply-To: <20240823185323.2563194-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823185323.2563194-1-jmattson@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823185323.2563194-4-jmattson@google.com>
Subject: [PATCH v3 3/4] KVM: x86: Advertise AMD_IBPB_RET to userspace
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

This is an inherent feature of IA32_PRED_CMD[0], so it is trivially
virtualizable (as long as IA32_PRED_CMD[0] is virtualized).

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..ec7b2ca3b4d3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -751,7 +751,7 @@ void kvm_set_cpu_caps(void)
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		F(AMD_PSFD)
+		F(AMD_PSFD) | F(AMD_IBPB_RET)
 	);
 
 	/*
-- 
2.46.0.295.g3b9ea8a38a-goog


