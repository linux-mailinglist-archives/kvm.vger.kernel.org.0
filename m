Return-Path: <kvm+bounces-48591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B681DACF7C5
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AE42189BC61
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126AF27CB0A;
	Thu,  5 Jun 2025 19:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gwTdxZ1c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68A41EBFE0
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151358; cv=none; b=oN4a9lw72yjqwZR1UoSawS8ppCfykd3ZXn3U3iqjxxc7Sec6Ei7bMXtQ9ej6z8fsBWoyaOvTMNEfTugwnI+m1EBx1gl2w8rYjTmREiZ6npCEkE3c9fJ5TdH9a3fgLUR+UANgGBocIkYxPMi8sU/MUQJp2t68FfdhQ+UyyXb938k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151358; c=relaxed/simple;
	bh=d6Rcu6eeFaqrcFHlwpUPU2/9Eb8RBBJm63CKfBlhPDM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RvWUXAyvlLU/PEOpEevQdLc4NMJpAcVMQLiGbOkGH1G+Lt3v2jXbVpQ6Cx3vhikaAYNeRnIrK+g3tMURoMkprQrjtJTjiX729lZCXzubGtoq93FLTcM4UGWppraNXrOl48dloWe7DSnxoGIj13egoJGimlYJvcbmGW2p4KqJCkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gwTdxZ1c; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3113a29e1fdso1897680a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151356; x=1749756156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u7KVVER6prz9fmOH3/yc9VCRvvLHK6osAWOwCQSxtso=;
        b=gwTdxZ1cCC7wokPBFEWQdGaokZ7c9tlfWVtTkpVWxpOlBwgbBH6ZQvPNKhhRcObQTM
         L0Id+u+LPGMnNj/2Ee8JTa5X6Iw2q17oD/45C1Rv2xBomkXeQFJpKQ9eNIAT/Fql1Nby
         30tGXzenR1cRfrMaIhrNT8um/MD5Nmr32CcYGHPIRf9Ezrv699JL1q4qndVtsCdWWTAj
         wcxim73DaZEaJDhFgCqQMh0d/BwSdr2JN1sD0LgcDt3cYVlDU9Kg40CAodshmhb2T7x5
         7svi5XKoyZ/vpG1C6kkNdu/olUC8X527tHI7mrj1vPrmEj/4Wyb8c3i/eayiP4ewaGGG
         ADXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151356; x=1749756156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u7KVVER6prz9fmOH3/yc9VCRvvLHK6osAWOwCQSxtso=;
        b=ogPWIMfM7+h41QPWoqoxrJrFuFJV3xMa5TKQBbiAAiJDqbup+PrgD7WwdnNyBK0Vju
         m8HN2k6Deh9shuIWeOqqEStszTrb7jQ3sDUnrJETInIWwSNJTUJEjqPSLlTxUm43OXar
         WUdQaBSHYujZGnUnUhRlsURSFN+A3lYpQfpSkJf5rtTCRIHDvuqkmeWNhvevxUdtxGme
         5tqF71/13kqvoA32anrxqTPauhJo0oIzHG9iTbSmqXdxgmF4w5fFFhgRHmnY4Iow+saf
         tq68RTlXUPO/wk/POzGtggBM4J1t/Vqo/PtsGiAK1AmL5DvEFjKYYbZtJzxmUwrtmBfZ
         8nGQ==
X-Gm-Message-State: AOJu0YyUYZlCTCLdHWdkvTvujFGGJpjUJ576K1+W4Zt7LrL6eGjF4ZWQ
	fsa4yUY0a1d1e04ea/BtaFeEht3IGvlNkDugBtB/QiQ5tgKgXdRyvDeakUvWKsorGBPbT5ZxrC8
	BkVRH2Q==
X-Google-Smtp-Source: AGHT+IFI1czpR4AVi7034osZ1u8fbOCjk+65eRfLdmN1AtCKV4Mn//KiwmeDQw/ZqWOcKMxKWD0uxqiI9Ns=
X-Received: from pjbrj10.prod.google.com ([2002:a17:90b:3e8a:b0:313:221f:6571])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3506:b0:311:f2f6:44ff
 with SMTP id 98e67ed59e1d1-313474066dcmr1316841a91.17.1749151356155; Thu, 05
 Jun 2025 12:22:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:20 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 2/8] x86: nSVM: Test MSRs just outside the
 ranges of the MSR Permissions Map
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
index b738eb44..1795d7f6 100644
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
2.50.0.rc0.604.gd4ff7b7c86-goog


