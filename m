Return-Path: <kvm+bounces-33809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA959F1BCE
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9DDE7A046E
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337441B4F3E;
	Sat, 14 Dec 2024 01:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dQePBnFw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17651ADFEB
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138476; cv=none; b=Vt7qRRXI7L+Un8rC2qVjtvnMyV71H8pf1guB+mZoK+JgXGC+pL/BeIeUyDT7SWSduEoYMjS++bol2VLdEl6Bk07wCtvZmmE5jYSRQ4LyFcMhTtp0z0+5dhSQIPTmpQd7VbYv9wtJJD02aRDbEgpdMCHEPr9ZXNYMKRmYlRkfV94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138476; c=relaxed/simple;
	bh=15fjBvur3l72YTctDs8wzcqD8BFstsOioZDobvlDBPk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fx2MJX6agEHR6p97QF3BoAgWopqJHTVPCtCXyAONnjeOO3ZLilz/Uhe+zbmLFKYselPdDnmRCY3CS2o9HjVZx47hlKi3xmeqqhR8aJigMkEUivHBy3fUvVO2CMKSqPza/1CqVfrjaVylfRRkqKw9GYJfz/GzwW2md0g8DluCoDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dQePBnFw; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-725e2413114so1788004b3a.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138473; x=1734743273; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l6O5Kjy9lNdBNSlyw7J2d7cJV0mm9IEhLLTToQ8CHPk=;
        b=dQePBnFwXpMIfDmew92avrGAWDye97SyhD7Zl8s2hcHE4KThG/c53G9hhnyaEEmcOY
         qFAh6LjuVmc4dPGF+Q3u51iLkLrc1mAaNiSzQ/S8bOKFo9UWtbHFiOtk96PxkfN3Rrog
         hdGf5fnfz+p3qVr+5651Z0iuEOVYOtZnn8nAO47U4xS7xrzf5WK6buvHPWZcPzqMTyTX
         R+8rgvB5u4wCiBLmL2XPlPoxsn3lgG/f3qS0psurhtaPwtl6w4+xu2yHH4kItYtSdcSm
         P7+B6PE2EYu5fQ1bH2IUpdLxrCSOCFIH3LUrfc0dRDzzdCvD5ORPuIh+mN82lDAAQPqE
         bNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138473; x=1734743273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l6O5Kjy9lNdBNSlyw7J2d7cJV0mm9IEhLLTToQ8CHPk=;
        b=BGeIRr4uJEG8D68y1OFBk80AceHGuDbi8yMEH8GSo/cK9Q9JWK+35bsDeHhkqsHjRA
         f9/CNQaGqxmmRk/hjwJFH6xKn+XUTQC2eaP9Z+sk4TCrBF5ibHm/WPihF6yKg8Jh+X+Z
         BnP2iFzvOqOEJDmkhFqNVEHdRXEx/o2Pb3wWSZQIhyQ5BKRRPF8TgoCuhFMzjVYWBpF1
         8Iob5p88IueD2g1uI1RaiVsJldCL0piNSdqUCGcSkgjpS6Aa9SxWq2Q5GLwtsLIhHLHj
         IzwYTLKmez6nxXGUOTk1A4zyzSzQi/yrao6rulsW5xzmIwicevPfyb0WgbDEKK/8bCcG
         W1eQ==
X-Gm-Message-State: AOJu0YyFtfOc9uqkP5bAs88C2GuICt5GdCqcjG6lPfooNS60EZO9bQLm
	UGijD69bhNG8z9/BU6q5d3TxkqYHt2tO5zLhclaKVBre8qGirvgv9hWpOmjMrY29SuVEqn/FtH0
	m7w==
X-Google-Smtp-Source: AGHT+IFbjgenJSEGTWdLgFOWtExnq+ivKP1l9rQ765/WWBXl0wC/gywOgYMd4e6dYdWbXXmt3f8FtKaH6qI=
X-Received: from pfbgg9.prod.google.com ([2002:a05:6a00:6309:b0:728:e4d7:e3d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:288e:b0:725:e957:1dd1
 with SMTP id d2e1a72fcca58-7290c25b8d8mr6933616b3a.17.1734138473024; Fri, 13
 Dec 2024 17:07:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:18 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-18-seanjc@google.com>
Subject: [PATCH 17/20] KVM: selftests: Tighten checks around prev iter's last
 dirty page in ring
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that each iteration collects all dirty entries and ensures the guest
*completes* at least one write, tighten the exemptions for the last dirty
page of the previous iteration.  Specifically, the only legal value (other
than the current iteration) is N-1.

Unlike the last page for the current iteration, the in-progress write from
the previous iteration is guaranteed to have completed, otherwise the test
would have hung.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 22 +++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8eb51597f762..18d41537e737 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -517,14 +517,22 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
 
 			if (host_log_mode == LOG_MODE_DIRTY_RING) {
 				/*
-				 * The last page in the ring from this iteration
-				 * or the previous can be written with the value
-				 * from the previous iteration (relative to the
-				 * last page's iteration), as the value to be
-				 * written may be cached in a CPU register.
+				 * The last page in the ring from previous
+				 * iteration can be written with the value
+				 * from the previous iteration, as the value to
+				 * be written may be cached in a CPU register.
 				 */
-				if ((page == dirty_ring_last_page ||
-				     page == dirty_ring_prev_iteration_last_page) &&
+				if (page == dirty_ring_prev_iteration_last_page &&
+				    val == iteration - 1)
+					continue;
+
+				/*
+				 * Any value from a previous iteration is legal
+				 * for the last entry, as the write may not yet
+				 * have retired, i.e. the page may hold whatever
+				 * it had before this iteration started.
+				 */
+				if (page == dirty_ring_last_page &&
 				    val < iteration)
 					continue;
 			} else if (!val && iteration == 1 && bmap0_dirty) {
-- 
2.47.1.613.gc27f4b7a9f-goog


