Return-Path: <kvm+bounces-50799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47098AE96E0
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B1A0188769E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E5A25BF1F;
	Thu, 26 Jun 2025 07:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="sx3Up+9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6B9258CD4
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923311; cv=none; b=Vn0w33NagHXKKnzJYhOcN2lF3fQ3+9ZHMilGqgJsesVmiBX4vyyBGFNqgcJrVypLpFEH8OHR6YgWEaB6h8Fj4usq1sMc4aHMhk5zOCpehx87ul/OlZ/nRvzZM+L5RueQVf4m3WU6YJJiFOjn0trpfgpcD5jcYpS4uzZi1i2qiEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923311; c=relaxed/simple;
	bh=7jBXkBYwPQoqiK2jv8rSohQaS6ulBXtUBZwglAz0/hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSwLodjD9Z+EnZdUFro0R0wfS9U5MUZGmmItMjcbe7Nbximx2GRdtLbQoW0WqitwEKP0LGrAEqEZawscLncDZoZc41lceaSJJWXxRO1XQSLpOtbNQdX5ajmsfQQgoQfa/zJSshNujzhAQ5g6wGb/pihdEZMpWGTC03uuje4aCR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=sx3Up+9x; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a50fc7ac4dso324024f8f.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923308; x=1751528108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPxxqt5PQrzjWVTzh3HaEtEAT+Xya3yEG0dohlL7fg4=;
        b=sx3Up+9xhMk42I8iHAwREb+FMpw3LU4SuoiOU5lBWnvJwTZDD3w52vkNaHxUjaA+p2
         mMLyQY5wC/N4JTucEhEgo0yWSICH5W31tGmymbuQjEUQWWN0kLCFh3UAlNKQNi/JpMir
         JzDAtjFgfAnAuVMetqnD4eV/aX0kTIFUkIPIDAPq82RZ7azVwbwo7iiqRGtSANyO4Wj8
         XZCxnU9+kXQJ4Sf+7DLWPx5r3vLbHbmRYIDWcePBeZ3y+rp13UdUC9cWW3Jcsr3KsKh/
         QicSi1l/m9DDh5PUy3BHDo7MqkkUB6yDBo44c092OlVL8e9o/zCyinbHO7a8GbNbWA2J
         DFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923308; x=1751528108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPxxqt5PQrzjWVTzh3HaEtEAT+Xya3yEG0dohlL7fg4=;
        b=e6cmBO4XRJKtor/73wvB0vQBmHBq8NnZ6trfFaTJrcerTtq7Fgul+tJotIZjM8nzrq
         xzZUGTCsJ/EpDJlgVqKs1nnx7uwg3tXmCNbTWzjfcqpV0T2+Rjw+S8uWvk4T5VbtiTHj
         laRsNRj1Mp0nvreOZPaNjQhWvZBoqOdNurSS3ye4N0Lcw8DMOHz2FOat4ApQEjJw3NAS
         JNuKC8Jw9FQnHQBxCxE4wFtkbRWD5OB3vdlvn49LC6DXDNq0L9bm92WExHJNIPJJgZjB
         78WXere6ggtt7/RK5Nai+pHUCma7pkZ9jOF7HYwuyWiEM8USxttaPMFZfVYBzf2xGrdS
         9eJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa8Gal255h92YUXZISCph2xtom31mD8ahnUM+Jn7KrkJY7d/2T3KYivrsFsmODUbiKRDg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3mpN2QtW/bF+u09zqlMuUn5ssZpLf2ueWAUNH1ESmNkycHE9V
	pg7IqW6WGw3n7gfl8x30nuBMJkHgten5h6n14crzxkvrztqp+hkaX7RUXz/OdufoqD0=
X-Gm-Gg: ASbGnctV8RgsvcOJGq6eQtieOIVLmnIaja1WDwnhXsR3F6umx7QMTSvBf6iMCkuj4RQ
	PqsX37zgk3qKNc+X1KlykjEm7kZRnTrLGT4K+YtVaFDaMMQMnpACsbH5fKF1KYh/A8qpdXelZ7V
	TjcOagEAfQ1Grc2HIXHRNdW/hL41hXX2mFnLLuIRhl0N05bsEgLeHDv9HJkXmTeBHA0v4397ZoM
	Bw4EHkJ+YIVNdVFKD+SXqNvAJ8eEieyRCUgX5Y5XvH+zlvd0O0c4aWqNI4NvOkSHCMPExvqNe7p
	HLh+fmkqUbq22WEp51le05lDxJAtCrlivu67H+aGnh+aDrofccJu7+n8ZEWAFFNJPG0QXndxX6F
	EYlHl0oHTlrVsbArW6qTS9kvgrfZxRBNq1IfaAmC3M194ifEbhOsflihE2qx3Hog2Vw==
X-Google-Smtp-Source: AGHT+IHQ+1TbOpcDSOD0dpTIgGnGic0B6HcthmuzJrrcBdjr+sJndYmdD5NHjgJxNx3a2Y5+33gDpQ==
X-Received: by 2002:a5d:64cf:0:b0:3a5:85cb:e9f3 with SMTP id ffacd0b85a97d-3a6ed619208mr4527955f8f.12.1750923308124;
        Thu, 26 Jun 2025 00:35:08 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:07 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 06/13] x86: cet: Drop unnecessary casting
Date: Thu, 26 Jun 2025 09:34:52 +0200
Message-ID: <20250626073459.12990-7-minipli@grsecurity.net>
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

From: Chao Gao <chao.gao@intel.com>

cet_shstk_func() and cet_ibt_func() have the same type as usermode_func.
So, remove the unnecessary casting.

Signed-off-by: Chao Gao <chao.gao@intel.com>
[mks: make the types really equal by using uint64_t]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2: 
- change return type to uint64_t

 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 1459c3dd3d67..61db913d3985 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -8,7 +8,7 @@
 #include "alloc_page.h"
 #include "fault_test.h"
 
-static u64 cet_shstk_func(void)
+static uint64_t cet_shstk_func(void)
 {
 	unsigned long *ret_addr, *ssp;
 
@@ -31,7 +31,7 @@ static u64 cet_shstk_func(void)
 	return 0;
 }
 
-static u64 cet_ibt_func(void)
+static uint64_t cet_ibt_func(void)
 {
 	/*
 	 * In below assembly code, the first instruction at label 2 is not
@@ -88,13 +88,13 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
-- 
2.47.2


