Return-Path: <kvm+bounces-50803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B85D3AE96E4
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E6211886DE7
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CEF243946;
	Thu, 26 Jun 2025 07:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="IC4datT7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255CD23BCF3
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923314; cv=none; b=DinXe8xLP7FfioopBPOmH+b/qzsBf3lbvvMjcyyI3ckbqnFwdk0ZSOEYwiPFdId6wzK/GwDlzjws5uxi/ohh66zdXH/1wPY2r5kjZOJ2AoS2bAvN76kR0viQgI3LPoP7xCWHJSpoaIWp2QqkcDnbmutR0XkgU9Wqy2egnLl/8gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923314; c=relaxed/simple;
	bh=3R7JpG0GYfpl3JbHPDZ1dVSrrMpDHUlfMMTPyeJ/SZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZwDCvseZ4/OZU92xE7mc+ZqrUfFa55zNMpn1cgkhyLVfcpcNf4+4OLB4UqsZ4i3fReu1lYwemrWZ4di97MQweRfpv7fWy8N0gMtrHjCkTuQINk8wCCyRRK/pE/awzqiTJvWuM7KFH9FE8Vw3cK2PHyqvT6svpGWcTPUzxjRmAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=IC4datT7; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so610635f8f.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923311; x=1751528111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxQzFsA49Ug+RvAX3tV+Ew75+aF26HLquVzficC/lo4=;
        b=IC4datT78yrzO2HgNJ2vLucyLEORuKOLUlQwTV0TD0aKn3gHh7Yil8wSpwYnwPeo29
         pIbY5uuPq55Hijt+RuS0hreTzy29ypjs0UN+gQeWgGgP5L0OyIfOmdYljh5WeQXf9/74
         S6vURIz7MDLe3ir1yBzaKNQJLbrBQ+SIOH627fz4+VqadJP/p+j1DZkCJfm3ypEYafFV
         FYtXhoTq8fRATfl9QJJ2odDo13OpRBU7+YsezHE/LGKDOfzGUuiyu3CIQiV1InwNEuR+
         G2gmZgoiJGlyHFGLzVq9+L8iVqIoGVpb/tbzzgZv/S9Rx1nTpWg2ie/k/cT+NH0cWNDs
         2l+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923311; x=1751528111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OxQzFsA49Ug+RvAX3tV+Ew75+aF26HLquVzficC/lo4=;
        b=T52aGo8w1HC0a53Y8Qv3Jpqbkz/rrrPgfVfWlHPlE4n+M0HKHHkb/eE2iPTi0X67Px
         9rMI1/DEuyZPtL3XAwBdCwfRuIfNsVMFxFUTMdV9bBI6/4OsIdKsNnCgNsUA60PYjkcX
         yMak2gnwjE7M/kQYAPz6rOZgui+AplnBj5NYEVg5OZe/sEIsuPxAor7QBb/BzxQyIg2/
         bnq1SH8F8KA3FqSlBz8z7f2KufcIhej3unz7tHgXVGpylznp00RsrVjhCWb8kx7TdwE8
         CgvR6/HgS0oZu+CK+l1kyySv5+nYTKyt09eluJzbGffwnVbbu27ZLOFjRCjZLqkMgfAu
         KcWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/R/y/CJPcOWTeaYw2AxMLe1c0MY/irdzw9B4/gGqQ3D9kYC7nIFCDbZkvKbFWhMOTZ2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YziBjoW0dLM+wBHhMoMr+d9TVLJQ/vrS5oz37Wt2scXJsnNR1/Y
	JD6dqtMrAur3YJANzfA/jw5p7rrvsA5qdHz0us5UshToKURaeuhvThyJ1lRaO6KfSFM=
X-Gm-Gg: ASbGncv+al6+D2eWjpUhlTZPoB8EntbpRlZnaRSqktyqqssx8vmkX7EzL96oanna8rC
	zMz5I98ec0n9AEjhmMEaDLLlU9lD3GboLCDSuH9yVUy0QY9xXwwlvbQJNUUvHwpb7jSpFpyDf+b
	oGzDES60iT7AlEOShUIS8Na4B4HDH034Un+PK86o1BaBi1JvWs242fIQBlwhqKIxNo/mnZwWdyr
	I8v6I0auAAtoM66JqKg+iG8cShJNg2eAURVXq7jVvNwsWT+OcQMDOnygRv8egQWlR3/3XdgmgPq
	PdhXIzukvTsoMMk2xaGrVLmo78J5zwHWQMBXaBxfJC1nz+T8cewsM3Wx0qyoRzGpCPPeNi5TNj6
	fcsgX368CIXMu9LTtL0Z0qEu8Tv+LZ33kw/UqUY6W537GIIjm5rsQCS0=
X-Google-Smtp-Source: AGHT+IGvQDRAtxKgSDaZv9DSlqs2NWX4U2xiT06X7ggYESub9XCnyfUr29n6f7p2kpVUK94iIj9SwA==
X-Received: by 2002:a5d:5f84:0:b0:3a5:8abe:a264 with SMTP id ffacd0b85a97d-3a6ed637b6emr4263722f8f.37.1750923311317;
        Thu, 26 Jun 2025 00:35:11 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:11 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 10/13] x86: cet: Simplify IBT test
Date: Thu, 26 Jun 2025 09:34:56 +0200
Message-ID: <20250626073459.12990-11-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The inline assembly of cet_ibt_func() does unnecessary things and
doesn't mention the clobbered registers.

Fix that by reducing the code to what's needed (an indirect jump to a
target lacking the ENDBR instruction) and passing and output register
variable for it.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 50546c5eee05..dfc2484cba5d 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -33,18 +33,17 @@ static uint64_t cet_shstk_func(void)
 
 static uint64_t cet_ibt_func(void)
 {
+	unsigned long tmp;
 	/*
 	 * In below assembly code, the first instruction at label 2 is not
 	 * endbr64, it'll trigger #CP with error code 0x3, and the execution
 	 * is terminated when HW detects the violation.
 	 */
 	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
-	asm volatile ("movq $2, %rcx\n"
-		      "dec %rcx\n"
-		      "leaq 2f(%rip), %rax\n"
-		      "jmp *%rax \n"
-		      "2:\n"
-		      "dec %rcx\n");
+	asm volatile ("leaq 2f(%%rip), %0\n\t"
+		      "jmpq *%0\n\t"
+		      "2:"
+		      : "=r"(tmp));
 	return 0;
 }
 
-- 
2.47.2


