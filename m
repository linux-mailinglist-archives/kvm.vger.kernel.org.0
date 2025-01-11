Return-Path: <kvm+bounces-35164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D20A09F78
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47CD2161DEA
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21237199947;
	Sat, 11 Jan 2025 00:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q3IwUtbV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A1919342E
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555439; cv=none; b=M9nUiG1dUlwQxZCLlPre1Nz8ptmrh9su6sZsQ4aZ9xyOtacNjx8thdgWenU6XJQYo5tnR1L5QfNq3OB+4MlK42oI3kiXOCTEPR9+/JaFOJZiZz8Iywoyz7+iCXAsNyfr/Uip3osiIzcD+xwzURLRohPsElHnNRUbcodWWQDhv1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555439; c=relaxed/simple;
	bh=ffKdnt6OQ9sJ5KUQQMoYl2zuIsgzofVRC0DeXLSAMvI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhqO2NPLHDfYu8OH3Z45gIbknbwMD/ASO6yJSGm2ZkMinpZUWMLJbPKO9OB2BqbAbtsH61ci4Iqn4tGJC2bhRQtbCmyn+7RHap++Xy7FxgbV5fpkpNxJl7seLeCcOKaPK7SOzrg81yJVacbd/Mek8lH4bAayJeKS23IPvWwNJdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q3IwUtbV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166f9f52fbso79050835ad.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555437; x=1737160237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lA1KJSr+vieulKkZ+q7IF2xXZKzzAMoWJFf8rW49CSw=;
        b=Q3IwUtbVZMGYOoCiXnz9xtr6SXB+NbL86bNN1xgufd5xC9/vTxKhrzvX9dVyNKSCl4
         hXkHWrmcgw1VtGES3KmXocMCBGc/Rlf17+tEv2/RBpnP4U/nWVekqxw2b8eAromR1Ydt
         8qjNe2ikYuZ8A1i/XJznVU8yb+h62wRkjemvPOlK2NXdsSo1JZBgX0MS0kJaxMMOEBqM
         HrTxij7fI5UY1DaSysFQp1eZy3O+1iKqUIDJ17d3e4CO/E7hfIz5jQ7Wv/G+/q9BQfET
         +TdhGW4MsipQxnl5A8t66ChKJEf1b7ayAvpzDf4unudITUbrwibFLstzu9g6HQnFnhTf
         GxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555437; x=1737160237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lA1KJSr+vieulKkZ+q7IF2xXZKzzAMoWJFf8rW49CSw=;
        b=TgKtQQeiTnXfHc7pT/kFN3o/SPtqff+fkqBvq3YP+fU6hK3IVxtXy5//rMeEzEUHup
         gCvA8Iitf6s0nybf1riMSWVrAQbGQD3yj3mDT0GGalNTQ+zYU38v4TVmcQrouQ4QsbvN
         9MeTNV7/89hVAtuaMsZ63ETuMjxxwThrn6nWigdIZVRCEsWnPhVMGYVdg0TkT64VayFg
         fXnUnf5TRDKAZg9Di4IPxHZuw6O+S36us4zgPIKKmHfabw9CJN35deUhHOODwSus7HnZ
         holjafHUDMOVszH4FB8hGsdPD5+ZuaKoIZ3rXuPQj65XbVD6+avyzx0GVHRvYvfsdAbv
         A/cA==
X-Gm-Message-State: AOJu0YzmkVPVqRM/375pfbts4ViHWrBqawM1ri+Oeh7bA9P5vzMobIOD
	YhfniQLi983LKfCq5J5TBWNApK3cpzjtYxhkVFrgIR0wQXrc2EjTlAmh0hAHnEZWzGY3j8oAJz1
	UdA==
X-Google-Smtp-Source: AGHT+IFdUmsiFredELwAhQ4qCYzXu5e+Jrsp000dNrYBVJ5QXSlgLrbjK9TLk3bbURHzIFEBProJ78YM0dY=
X-Received: from plbmq14.prod.google.com ([2002:a17:902:fd4e:b0:21a:8476:ecc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d482:b0:215:b058:28a5
 with SMTP id d9443c01a7336-21a83f52831mr168627105ad.18.1736555437233; Fri, 10
 Jan 2025 16:30:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:30:01 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-18-seanjc@google.com>
Subject: [PATCH v2 17/20] KVM: selftests: Tighten checks around prev iter's
 last dirty page in ring
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 22 +++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index c6b843ec8e0c..e9854b5a28f1 100644
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


