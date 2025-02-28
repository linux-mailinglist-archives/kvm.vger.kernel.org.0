Return-Path: <kvm+bounces-39771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20678A4A6A0
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A533189C3A8
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 23:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFE01DF72D;
	Fri, 28 Feb 2025 23:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lhRvukt/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB401957FF
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 23:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740785936; cv=none; b=WpCueCCFXwRWGt04RWKjuIOY4fwBZYe89aslJlJjqp2U9xn/nAM3peRBl4fIDj6vr+xSOTP4JXViDWPOgj0hmUcPc9obuuWIAKYkDCOHqhl1q9LCp7i5rGSEKaA3acXK3GFtNy1tCgwmGhLrBClcENXaIhHbZtzUf9vFF3t8NCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740785936; c=relaxed/simple;
	bh=nhBuLSHCL4xyw4gOiqkVQwKY5nbree8JXvV0DRxnYvM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=U1/OvfFiE1Numl8vVZC+pRm55+JGkGGAqXi002xG2irSAJKWcc8vWbiAaBVduGAVHHGgCvBPq9w0pzZwJO+a1AOSV7NZ4mGojS5C2P689MZll7KgYM1LdDmdLwOnCCTVhWgC4/YoIV8Mi0VqxnFEVgwz6ghJoBAeaOm7eTrBSB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lhRvukt/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2feda4729e9so242923a91.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 15:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740785934; x=1741390734; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oAgVUaQ/5QpkIjZdfQSYmkJEXkBnIBVVvk+1+kbCJBQ=;
        b=lhRvukt/wFGJqPKJAGi8CLeCBaTFhepskQ0mlIkmlm93Wr7YvA5QQCY39aqimMxRR5
         ZYl2MRXzaW0n9mJauFAkkrz/hbB8lG/d69/cuSDNPLwwmsyaERU0Abah1Kfv/e+lmlqJ
         K6GP2XdS5GZLvFG5j3XX53hhM3zo4HkC0ciCVvwYeVVMMa+HF+YUCMJqZQ4/DayWpyzr
         L2Q8TgvQznvrhnntb7ONqy65ztCxwQcqL0zDxq70ojj6qJnI5IfRLKHuQdg0XxMsO0wo
         Zrqozmt05NvuYy8JmNNrakMuv2QlQ0eI/nSHIh7GnXjUZ7POnHw7BvKxuMzrwf1JeN7y
         dv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740785934; x=1741390734;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAgVUaQ/5QpkIjZdfQSYmkJEXkBnIBVVvk+1+kbCJBQ=;
        b=DwazfaI+z41RfGxycHjPdTINBDUWS0eKbkdYvAQJW/2c7VxWeaL/NVRUCsFew5aEZm
         +Zy81kH6H3cv+AITr4uOa491It0VDunb7bNV6qCqJFht3Vst7ewuRaAGgacjZ2BYbgEw
         qTJgcTRUWEjMM+ZeFMJHFR1NzcXfB4OiaU/4jdUvUxtF97UCj5z8q5ecprk07Y3EdJ2i
         pdIgW5c3bWX4EhjJLbr5P3ICN4xXfW2lZ+9jR0dhnu6OvhtKr4duTbS0X8a12dGsek9Y
         8vaCF4VEdp7iP59jaayRj9KAxKT89R8cN48D1YMub4AYLtFConTw2LJYPHqyVzUPPZPQ
         FtgQ==
X-Gm-Message-State: AOJu0Yw3+bzoE6OfBjUIKpfeUzgImzehwMs2gT2JUNY4rsyiZyNIRTNz
	sCBXoAvMIcXAE3dOreIm5ifAIzR9+4/rlbtdaBMJL7cZaUFpHZqKtvS4/N4jAyhGZ3tzZJS3Ky2
	j7A==
X-Google-Smtp-Source: AGHT+IFnl2YN8VfCrIYRtahVs6jHn/SgWILk1l63LSIsxYCsUJruInHFf6e0vLqdVYg8ya5iiJVmkg8vrkc=
X-Received: from pfbk29.prod.google.com ([2002:a05:6a00:b01d:b0:732:2d80:4544])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:68c:b0:1f1:2a5:6461
 with SMTP id adf61e73a8af0-1f2f4ddb6f4mr10052983637.28.1740785934498; Fri, 28
 Feb 2025 15:38:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Feb 2025 15:38:52 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228233852.3855676-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Fix printf() format goof in SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Print out the index of mismatching XSAVE bytes using unsigned decimal
format.  Some versions of clang complain about trying to print an integer
as an unsigned char.

  x86/sev_smoke_test.c:55:51: error: format specifies type 'unsigned char'
                                     but the argument has type 'int' [-Werror,-Wformat]

Fixes: 8c53183dbaa2 ("selftests: kvm: add test for transferring FPU state into VMSA")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/sev_smoke_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index a1a688e75266..d97816dc476a 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -52,7 +52,8 @@ static void compare_xsave(u8 *from_host, u8 *from_guest)
 	bool bad = false;
 	for (i = 0; i < 4095; i++) {
 		if (from_host[i] != from_guest[i]) {
-			printf("mismatch at %02hhx | %02hhx %02hhx\n", i, from_host[i], from_guest[i]);
+			printf("mismatch at %u | %02hhx %02hhx\n",
+			       i, from_host[i], from_guest[i]);
 			bad = true;
 		}
 	}

base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


