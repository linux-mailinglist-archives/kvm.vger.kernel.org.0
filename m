Return-Path: <kvm+bounces-48011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B707AC83C0
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:57:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AB4F9E202F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FE3293479;
	Thu, 29 May 2025 21:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v7r0t0DD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83E1293742
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748555842; cv=none; b=N12bFA3DeV+2i/24HvLUoifKwrPWeh5E6x5DWBfMf3049vLj8z1m9V5KE+4Dr1COxSl4z2xzqOoTO22jRaGSYlTx2eF44gLoR2no+ATptnG0Lx5fuQufs17CMB5KsZqhDp4AF1H+McsiPq8Rxf5ZOnhA2Q5ygD/qvbW5OzClYxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748555842; c=relaxed/simple;
	bh=CFUCf6twoS1HSDlOzWwad2qq88LmQxFqyhStTkVJQiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q5I/jzJCuIE6t6ZfANqSHkFW5hwE6hGV8RojzqwVTqMkJ2CAc/tjUVS0O/PtjhoqMdrLH/gmvWoX4rBJLaDxDXhSpDbt1BR+E9Il9gzyAiTE4QmF0syMgEC4kwAZinhAcSOsnS8lrflr02FW33RA1d7SoHm18FLG4/nPvZ9cbEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v7r0t0DD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so1137302a91.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 14:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748555839; x=1749160639; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CQahoMkqgWyUnRQDNgMFm/ZI9Fu6cYUWFcDoEtuaCMg=;
        b=v7r0t0DDDpkQiXHfxqGo8NJqcHUFvcve892YB//S5ruIy+HOwjVRnHgh/afBch3dna
         U8BtQF7Db29wSYyq5eHf0dV1xESa72+PUan+Hurxdg0lXT9zWRQxKM4kXoRz5hUuoVFT
         pSG1T3/ZyB8QZwKU0j7p9xpkW8D3y9fPJwMifkxAuly5aOtDppogtqfE+kmBmJS598Z5
         joxFwByvb0QHELO5HL6WoLJTvGJwZ9XUVWG920XJmn+tTGo2xEq/hcwEf4rVeWENUZaX
         Yhg0OFxzVYxri28id3mR9NCsTwe4Jbag95giL4N0DHN3ZHmGw6LncCpt6Ow397RIqicz
         O1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748555839; x=1749160639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQahoMkqgWyUnRQDNgMFm/ZI9Fu6cYUWFcDoEtuaCMg=;
        b=Q5/TUNVBgDEzE1Q3xAWddV7dDyLVxCjvsFuxOn9ROU4y4nJDOSUmgSEuRB4EPclEHO
         tiBQrGuefx5r7PxrOlZwgNO8isyn94wiFJJT+FTbndKmpKrjgdrHd1c/4Bx52aigCbzO
         QZP5OB3Lso26iN8TGNh+saipAozE3gW5wdxATr4KMqeC6pfmdbLcdY98UNeHOzegLf0N
         EFQJrV0jzMIOC/mgwf4nMz4PkXy8iYCtqWhHztftEhTzDkD7RE+i3Uc9PSZHV+TKytma
         admmT6N7bD+jzvUb3Sq5vz609SWdTslOPaPEn81+rQ0pWxGKRI6NNQo7ZYURS9irQBz8
         5kjA==
X-Gm-Message-State: AOJu0YzEqt9RMaYBJkmtv2Cb8y4aDNyVatj6W9qmSBO32v3B8oR0kZKQ
	k92V6U02BL3nIcSWxOnlS9XOP6FlQEWLi9AJ3shJYvZ2ijZBIyha0ppPHQQbCOrfoBb7bW1TTuc
	eFSAodg==
X-Google-Smtp-Source: AGHT+IGAzkgycDWMozk6JkTlUKV8UXToaJxwaVEPHD9WgzPnvT8Nq3ods7w3jTMMdPU6ydBHnqayeGxept4=
X-Received: from pjbsn11.prod.google.com ([2002:a17:90b:2e8b:b0:311:1a09:11ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55c3:b0:311:fde5:c4c2
 with SMTP id 98e67ed59e1d1-312413f6065mr1549601a91.1.1748555839089; Thu, 29
 May 2025 14:57:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 14:57:13 -0700
In-Reply-To: <20250529215713.3802116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529215713.3802116-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529215713.3802116-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/2] x86/svm: Test MSRs just outside the ranges
 of the MSR Permissions Map
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Verify that KVM correctly intercepts MSRs outside of all MSRPM ranges.  To
keep the run time sane, test only MSRs just before/after each range.  Odds
are very good that any bug that affects one out-of-range MSR will affect
all out-of-range MSRs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index de9ab1b9..0732c03c 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -322,7 +322,7 @@ static void test_msr_intercept(struct svm_test *test)
 	u64 ignored;
 	int vector;
 
-	for (msr_index = 0; msr_index <= 0xc0011fff; msr_index++) {
+	for (msr_index = 0; msr_index <= 0xc0012000; msr_index++) {
 		if (msr_index == 0xC0010131 /* MSR_SEV_STATUS */) {
 			/*
 			 * Per section 15.34.10 "SEV_STATUS MSR" of AMD64 Architecture
@@ -333,11 +333,14 @@ static void test_msr_intercept(struct svm_test *test)
 			continue;
 		}
 
-		/* Skips gaps between supported MSR ranges */
-		if (msr_index == 0x2000)
-			msr_index = 0xc0000000;
-		else if (msr_index == 0xc0002000)
-			msr_index = 0xc0010000;
+		/*
+		 * Test one MSR just before and after each range, but otherwise
+		 * skips gaps between supported MSR ranges.
+		 */
+		if (msr_index == 0x2000 + 1)
+			msr_index = 0xc0000000 - 1;
+		else if (msr_index == 0xc0002000 + 1)
+			msr_index = 0xc0010000 - 1;
 
 		test->scratch = -1;
 
-- 
2.49.0.1204.g71687c7c1d-goog


