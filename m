Return-Path: <kvm+bounces-35167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B2AA09F80
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DC673A99D6
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB371AB51F;
	Sat, 11 Jan 2025 00:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fE1zz00A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D631A4AAA
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555444; cv=none; b=XMZfLytsUGvLHEOV02lPoGY9uKtGCxE4DrhFp408OLdqUWdQg+7IsxQkIt0iuUY/HeJclV6PH/gJPDpAd+CaMm9z9t/1kienesyAP6+zU15WRnKvdA3Zh02nJ+GzwI7YhZFHcVBHoVwasCB2qH4NRsuxPnlWS+CLLPyMtnaxjiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555444; c=relaxed/simple;
	bh=CgCTnbjfFNnVKpFKwg84z0FvtEtLBmL4OxVK5kbQct8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dsO5BSkFAG2Q3i0ZkoF4tMGMu44mU+lMIRZcmxyq5asFxhm22xzvpApChMV7RpJLxnG7eZWffbEJMPunQI3sMtcJPCtMJTwooLsLjXJxen7OJRvS009SQDOIWlh+Zg+yuEr+Da7YTbFPiUHEwvZStIPn1EwhlpZ8k9N48HPmCk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fE1zz00A; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so7379957a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555442; x=1737160242; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ocaylAF5hSvVSunY3A5I2NKvvF78/qIR/+EQce5KeF0=;
        b=fE1zz00AV27g3pTM9/VarL6mXqUsbrhdMvhYYQP80cBk8n66CU6FKoAOenHXeSzt70
         5dHUxttqZ2A2pVVqaR8PbP/WyHEEOb40KDmygp7n990SKrzlITOD4Kv1XLLlnldFfLHo
         7hBop3NgUOv+W+3t8DKJ5ONp1/XP4I/dynB7D3ZYulCIoSlr8xtXI0s1vJxiPFhM1gRX
         Cyb5sSKmMbbc5xU9cb+odY3MpqtuyUjhAgaicqJ4YrYh34u+Q/2rCBYCsfwGgg88js43
         Cn5i+hW0g1kMSOJKVun3vK93kvR5TLyMUX4Wy4fZyWihZNdQWgk1nB3ZcmA68mQTYL8L
         FThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555442; x=1737160242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ocaylAF5hSvVSunY3A5I2NKvvF78/qIR/+EQce5KeF0=;
        b=bLIA5Z68b8H2X5yzGJTLQp7No5J69/Y7D4ynZw2/P0OXBUktNr329xMbV4npx0jepR
         axRC1uz9Gq3ng5nkGw5Cx7X1I1UW7aVGMaua51Gee2KomxmAuLdfEXqs3vJeN1OqrvQs
         yd80Kk2/JTq1n2VN6R6a9oNVFcDTPw4OjXBhWxGsH/monSZ5BWyV4nQxQAmkXMH0gTq3
         ERJMVZliDVRD1iWEECq1Ey8kcQZohvoFkfeIk/4srj6Oqdtggr7B48+8DQSuevk/xlAn
         Yu07hzhkXw4isRy/6Nch020lUh1aYdBmKAJCWBnsSlgZvk1Q6nGWFIrTwdpq1zoIZODD
         hpTA==
X-Gm-Message-State: AOJu0Yzti/P/tQm0P020Q3RxdKEvwrKThqKZApC/7wfVwiA5mVdSUBFm
	0H2hhUbRG+0QRDsPmgswB3mk83UGn/FNOjDTkt92Fl9Y9QEHZ7qYbJxcmK5z8oyFBkDVcdmYO6D
	NQw==
X-Google-Smtp-Source: AGHT+IGOOC+AbNNc0zQxpJQQyZielrn+6dpDffyNQ8EiCkz3fAyLcXYEPD0T1b2cpF01xoTFHd4VcJ7W2aI=
X-Received: from pjbtb12.prod.google.com ([2002:a17:90b:53cc:b0:2ea:756d:c396])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2808:b0:2ee:ab10:c187
 with SMTP id 98e67ed59e1d1-2f548f598e1mr19787698a91.18.1736555442230; Fri, 10
 Jan 2025 16:30:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:30:04 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-21-seanjc@google.com>
Subject: [PATCH v2 20/20] KVM: selftests: Allow running a single iteration of dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that dirty_log_test doesn't require running multiple iterations to
verify dirty pages, and actually runs the requested number of iterations,
drop the requirement that the test run at least "3" (which was really "2"
at the time the test was written) iterations.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 79a7ee189f28..23593d9eeba9 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -886,7 +886,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	TEST_ASSERT(p.iterations > 2, "Iterations must be greater than two");
+	TEST_ASSERT(p.iterations > 0, "Iterations must be greater than zero");
 	TEST_ASSERT(p.interval > 0, "Interval must be greater than zero");
 
 	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
-- 
2.47.1.613.gc27f4b7a9f-goog


