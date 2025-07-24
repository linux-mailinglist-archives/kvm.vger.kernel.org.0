Return-Path: <kvm+bounces-53396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9023AB11181
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 937951896299
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A6B2ECEB9;
	Thu, 24 Jul 2025 19:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="mxKYvUjs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE02F223716
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753384565; cv=none; b=JUyMSUHQc+LulJ5t32mdZ6Mj+S1LpRko3VyVwVk3bmi1bWXPeJY3Gbd5QmhMu4xZ1zvn+OxoC1OzsrO3CKyc6JZKwS9eAKxI48PyrM4ziPZKSiuZWoeoT4uU9NgDi8YRX6gEGDJf0VKM14PVxt1gbAs1qG76+4U56oRo6HKr9hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753384565; c=relaxed/simple;
	bh=X/5f2Py2pzdxclRxuZZlo3RrSMypFiiOuhv0B3RlVSk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ctCCQaMDaF3MadA2Mg4XixfgfysSflp85KqBZ6Bx9bdEpFuseqCyz20hBZUQaF3R/cLLYqf0QHWvew0q6KKrfY1kkqrP5XcMk9pk9XsZSYojLDfdTE9cgPWHStYDOxsfvAy4Cn10hAWTWPIEJCAU2KhCeOFxpqJC3tDTgdYuMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=mxKYvUjs; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45629703011so10325435e9.0
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753384562; x=1753989362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mTO69yoT9piHIx+QEbB3+pk0ILuUT8yGgDEKSbViWzU=;
        b=mxKYvUjsBv+ZtDp61oFN75Ygvqqg+506OnioVsOvTs2mHChGL9kIvM0D91DDJqLoEX
         LYNOJFs4eo1w+lmOxDRnAoU9mSctjOIWu1tFO68E9whcg8luAGqoBOyWJrRH4CNJleqI
         0Wz6VD1ZGhY1D78UPMNpa1fv83C/a9on4fIId5q/oZMwVB/B8Yv7qW7a24s9G/2VX92N
         Q3acR/oHAv2C+jXfPCJdj028F5ongTtJwqO3eHutXr/iIr00MHgZWT36yeCksrsQUFRy
         jXNd3Ql96TdVRYmURVJkM7YwGoF2UTdHJgHCHcUukPhnt7oIU6JW8Y83jZIxkimwhqTP
         hIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384562; x=1753989362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mTO69yoT9piHIx+QEbB3+pk0ILuUT8yGgDEKSbViWzU=;
        b=oUCd6l2VxH8d+xNPe973nnOjW9innF0QmYAFnBDBBzTACeAxqwutZLk68ujl7nSHql
         dyYnNbGe9tuQe2oypKXO8iC4LRhhA+Y+smfNV/PRHaEJGmXK9cRTYNHxTAnprN+jHWHU
         L+cHu9rHIkcQJT3Egv13oabttVYKIZFyKXzw+b2fgWq7WU5IK2fgboJX+7giqhQKvE6M
         LbkxUReaOjsxr7+Fuy972iFTCn0cfZG9+PfM0Ms15/NBNT9g1udDMFwGMHRMJx2xiyCk
         AuBRRI/ygRLcSqymdseFXF5qNXSJyPsEFx1kbmc7zsUJW8saJRuTUcGdRgBgI/P4oYwV
         QKBg==
X-Forwarded-Encrypted: i=1; AJvYcCXAiycbJm+cDhPkFXt4bqKa3ViiGyclrodAwtfBCzXehAbMhUewJ/KffEwNAPV75aVZ+aM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJa3mA3DdWNu9JWtb3LgRwImdyFN95VowglC+vj9u3CxmutrWY
	eH+EwefK5qeQ67SeXsytOlFhWf2P/gEQbyac0sPL9D1daQgoVEuToFMLC1BE/IypI6U=
X-Gm-Gg: ASbGncvswdvJa0bxb3dnPKhvjnHt9zEuCZlA0cGc7Gwm9xuEWQQwtkw8MTggnmWLThI
	1dn/IfpbIyYRL6fTBuU5NxMc+3w3gLzKmWl/STRW27XoFaMvcTvAFwBc6Y4COKTPXtWrkpPZH89
	ARwqW4/AEciY8DqfxqdTPpQ3nJ9THrn+Buvif+v3BBFqLFhJP9JXW/+MIm16SNXumUmmDmLIYB7
	whkJ6tvYXtgv+vPplI/mpMdjUR5L+C0Frsu/kRPSOKEHw1Axa7sM1QEcjR839JjvcdPlW8VV2m+
	DvMHq6ACKzhxOw7jw8G+xhWojoBWJLllxSG+hceG+hanCsjGxQMaHKtMRZfP9hd/H58ViTkAeqv
	Qp78Tan0iC8d3Y5pzr+pJNOzTp05Ek8oD9NSDeBQB0jdL3QqcJPeC5ug4lmx4km58/U55MxTXct
	kC5C+TpeWq0rsqGFjH
X-Google-Smtp-Source: AGHT+IFaXYbeY1PKTuyJWo/Xz9v5v+bWJsznOJEdzttQ/E0Um8sCOt2aa+bn2guLVeZ/hzb+MkHnkw==
X-Received: by 2002:a05:600c:5491:b0:456:fc1:c26d with SMTP id 5b1f17b1804b1-45868c91bd3mr80300835e9.2.1753384561855;
        Thu, 24 Jul 2025 12:16:01 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587272b405sm8797165e9.19.2025.07.24.12.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 12:16:01 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH] x86: Print error code for unhandled exceptions
Date: Thu, 24 Jul 2025 21:15:57 +0200
Message-Id: <20250724191557.1990954-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print the error code for unhandled exceptions too, to ease debugging.

Also use the symbolic name for the #PF vector.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/desc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index fca37b9a5cee..f4cdfbc92c56 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -141,10 +141,10 @@ const char* exception_mnemonic(int vector)
 
 void unhandled_exception(struct ex_regs *regs, bool cpu)
 {
-	printf("Unhandled %sexception %ld %s at ip %016lx\n",
+	printf("Unhandled %sexception %ld %s(%lx) at ip %016lx\n",
 	       cpu ? "cpu " : "", regs->vector,
-	       exception_mnemonic(regs->vector), regs->rip);
-	if (regs->vector == 14)
+	       exception_mnemonic(regs->vector), regs->error_code, regs->rip);
+	if (regs->vector == PF_VECTOR)
 		printf("PF at %#lx addr %#lx\n", regs->rip, read_cr2());
 
 	printf("error_code=%04lx      rflags=%08lx      cs=%08lx\n"
-- 
2.30.2


