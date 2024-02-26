Return-Path: <kvm+bounces-9875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3599F8678CD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CC4E1C29CAE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3540D12FB24;
	Mon, 26 Feb 2024 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evgEFPLY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CE612FF72;
	Mon, 26 Feb 2024 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958118; cv=none; b=RZOj+k8UvyZpWTIRHnAQF14Dv4+eU/g8mHa5FWkkMdtfxqUKtpo7sWQMoPG54YlFxJQ/ec59fEv4eX948THc/U9GodgndzhRhzjrQAysSPiZINX8tGxDXmXzmhklRouAJfbl0uH/xgntQrHI7dwWPFaGBWHLyZm2M0Nhpz5LXmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958118; c=relaxed/simple;
	bh=bVULcf1cUtmaXpPyRTkatm0ACsMJlUTYThVtsgkA4kk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qs/7z44xZ9nOqSGgkME+Fi6Nz75EaeJWA+HgFp74O0MAf5yZ9MBsuxLgn3dsJQaF3LfhBV8g0N/cHDYNCFt+E6uL2NVuUjjNkga8hX9c/oqTMj9OM0HHEZTgRD5fuu3dPhkqB8552+DROE2ySOIVxyZdX02Udu8fKxpnYfPPql4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evgEFPLY; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1db6e0996ceso23678875ad.2;
        Mon, 26 Feb 2024 06:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958116; x=1709562916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q55Xz98tQTUsOL6Z4q/HueBOFbtRKoeK1/Jth2H7uWk=;
        b=evgEFPLYiGYRqdH9fqKvZY7qFW/7RwsR+lzdGHxC4Y6hmy8v0FCOaC1YnLzC4slBcW
         bTJPict8UkCBh5uPsJujbBAkdHcqPjru4f/F3QuYkOy1tr+z+xqx+5jH97dJMbsrhtc9
         +RJmMY/gkL/Fb6WXqVVJiALIx+4soDXYivHTyGG/AYin//QABGUE/7H0Xd7rmcYd8HPZ
         /VxCFQrWgdGY0sJ/lpchUh4M+QF7udB59/CRQSdeibsZkK1phMdSe+6j+z0T5QHjl5lh
         YU6vLA3rZBr0vEVpSUVqwlzFuMz9CnNGDOBCPtunGTtruqVkrIB3bBdP6SdlenPqRBGd
         Ki1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958116; x=1709562916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q55Xz98tQTUsOL6Z4q/HueBOFbtRKoeK1/Jth2H7uWk=;
        b=Yd3Ra2vmINw4agfZRaToHf+geYJm1GEEVdVAJVOG0Ykb7FgLSkk/Nlg4ASRmebdeZa
         7Ldwvx2jJyq9nuIayBFPGrNRSwYEJBUaXhNGup6boEAi8ora1hZzU5d9POHrRlyEDgWP
         PZ9SxYGDzuJCpCMkrl1v/NIupyX69CkK+1/oEKC+rN0zjNmIB29ljFmFFJiqt+vKXh7p
         jKWtcfAJkdU8yOJG/z2115C/bYxzrgKmCuGA3fslH6yVy67rrerwkn7gMvKdIjCEXFbi
         DxdOntfj/MY+RR3qgzwRFELmWfg/sfO9air4MasKzN97OWxSjrfM4FH/YfqrXbcP6HQ8
         FqiA==
X-Forwarded-Encrypted: i=1; AJvYcCUK99lkoBzTXbewHOmoPb1uX5x2HIGNVcT9dcY2WoA3kpUBfXWKnGnDebZbVQwLcsdeDESbEotNq6ReQxtR/SnWGSTN
X-Gm-Message-State: AOJu0Yx88j1OCSCa5J7OcFzbiWYNnuWiGCVS2JIrtfA8PWZCtw1iT7Gm
	/KtQ8T+hqDJVa3fh0dJF/d2Nhmb2IsAHrlOYqqR3aNaxKghSNyrxtzcd2Fjq
X-Google-Smtp-Source: AGHT+IHkBPkB5xny3ra/TgRPvNN08vKJiwrUxBUwYLd3pBdUclIcjQgGvyRHpphiykpFXPS63hd0/g==
X-Received: by 2002:a17:903:449:b0:1da:2c01:fef5 with SMTP id iw9-20020a170903044900b001da2c01fef5mr6714781plb.56.1708958115987;
        Mon, 26 Feb 2024 06:35:15 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id ks14-20020a170903084e00b001db93340f9bsm4026898plb.205.2024.02.26.06.35.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:15 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 12/73] KVM: x86: Add NR_VCPU_SREG in SREG enum
Date: Mon, 26 Feb 2024 22:35:29 +0800
Message-Id: <20240226143630.33643-13-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Add NR_VCPU_SREG to describe the size of the SREG enum, this allows for
the definition of the size of an array.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9223d34cb8e3..a90807f676b9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -204,6 +204,7 @@ enum {
 	VCPU_SREG_GS,
 	VCPU_SREG_TR,
 	VCPU_SREG_LDTR,
+	NR_VCPU_SREG,
 };
 
 enum exit_fastpath_completion {
-- 
2.19.1.6.gb485710b


