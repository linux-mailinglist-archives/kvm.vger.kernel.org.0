Return-Path: <kvm+bounces-33805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 653E09F1BC6
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAAA4188E76D
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD1F17579;
	Sat, 14 Dec 2024 01:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DKMbef6h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B61193425
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138468; cv=none; b=Qt31XpxP9lC/ypg1mPJuJaP+1CBt8tzetliBcqRIesp0OfIVayJESex7pkz8RP+KJPPLeWCsS75nMM+NH5lUFOsQJkEfLddI0TUtxf3HoSLH1L7LWObZ/MHFjwSKVhroN2APRSXKjH1xEIH1XZB5neCJoaOVU0990euWoOU071s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138468; c=relaxed/simple;
	bh=Y7iSeB/iFN2r5nReVSRRpd3Yjr16tNr3Xsa+8UTAWN4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qcucv4GFGQfBy0EPvbHB9XrSWJZBuMFcV0jOY4IRmhQYVS9W7NM/Nh+4FYaQL8nZCvE1ChPjkL494bOnh4xQEGkJIQ1n9JG8nEj5Fiy9RvRZq3uiveWLRqdSjYsF8hTjjYqcqKerfqheG72l8RceCOyVcGVztcBgJ7yyIZqj8Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DKMbef6h; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so3111853a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138467; x=1734743267; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eF/Qtxj8u+rXx6pztbYRnhJ4md/Ws0Wq0EpKN7FU8Sw=;
        b=DKMbef6hFSAU6h1IRlvxFnkqA2MbTVIWGXO3tirQ/m7MJKcYHjo2p0AethVTxbH+0/
         7JldOAMvLn4iSbp502kJMn5aBMNuAQ9RtbmLAMKOxS1+roKv1GJSYQkdqqE8f32lne7t
         N+q7rf8+3/U2BQaumuAJPLkdf7KIwb5fC3Km2EhQVJOgjIvfOas2lfyZSLkRZ901ThO8
         t4QZOq3j5yXG+ietxwXa3MjpLpijptw4t18tTb4ZWpGVsxPUFfk/jS5NemXM6S0O7wsi
         FrjlaESPqgKkgJRoOT+R/OBOLaDHKgfSzOpmbq04GKG8l3f1Gkq3kmOb/VPO98ABC0jA
         mGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138467; x=1734743267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eF/Qtxj8u+rXx6pztbYRnhJ4md/Ws0Wq0EpKN7FU8Sw=;
        b=tENF0VaXL61xuk6hUi1xIjuCjXcAlORzfZe1DbQBRxp3u5rFcptjoK+Bl8QPAaxyZC
         xqaysPPF1nI7yjxWLDedJce2T8QUEFWMUli7rJXIgzRo8RUOU1jO72GIFZ+YHEgZpK6L
         qT5r1yGhzamrC1lN27T5OI6UjLZr2i9kHD2B3huGCNHSStsGg83MHFxMYfdERMkYZfQb
         4ihaeX/ZBYf1uut0FFjbNrs7JCUcMyvC0VsVW62eWGk68ISHwg0wFo9m8+7kKvBQMzLB
         HYXeR1YIZ7XgnenivKufpmduaj3obMsOTBde8sWcaKTShOKNslLAN/zp0nPy+lUgy6Iw
         mHWQ==
X-Gm-Message-State: AOJu0YzRKu2jvp+M9sxpot+IoezOoMi+1gURJHzO78jpAJwCerWYpNVC
	pSYrbMkndp4h3IVSq7Fz9ysUhycjcIvfJlCA1XCLvP7ZkqVAil98FObmaDyg0VZmkdKlLNij0KQ
	8rQ==
X-Google-Smtp-Source: AGHT+IH0qFw1WgPjMXBzEGus8ENQhTcYTwf7/Lt7Vb5caWVGm2/gGGV3oi0MjPa5CrhahTjY2DcpyW9W95w=
X-Received: from pjbsc16.prod.google.com ([2002:a17:90b:5110:b0:2e9:5043:f55b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5345:b0:2ee:d96a:5831
 with SMTP id 98e67ed59e1d1-2f2900a6003mr7323795a91.30.1734138466757; Fri, 13
 Dec 2024 17:07:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:14 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-14-seanjc@google.com>
Subject: [PATCH 13/20] KVM: selftests: Print (previous) last_page on dirty
 page value mismatch
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Print out the last dirty pages from the current and previous iteration on
verification failures.  In many cases, bugs (especially test bugs) occur
on the edges, i.e. on or near the last pages, and being able to correlate
failures with the last pages can aid in debug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index d7cf1840bd80..fe8cc7f77e22 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -566,8 +566,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				}
 			}
 
-			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu)",
-				  page, val, iteration);
+			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu) "
+				  "(last = %lu, prev_last = %lu)",
+				  page, val, iteration, dirty_ring_last_page,
+				  dirty_ring_prev_iteration_last_page);
 		} else {
 			nr_clean_pages++;
 			/*
@@ -590,9 +592,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			 *     value "iteration-1".
 			 */
 			TEST_ASSERT(val <= iteration,
-				    "Clear page %"PRIu64" value %"PRIu64
-				    " incorrect (iteration=%"PRIu64")",
-				    page, val, iteration);
+				    "Clear page %lu value (%lu) > iteration (%lu) "
+				    "(last = %lu, prev_last = %lu)",
+				    page, val, iteration, dirty_ring_last_page,
+				    dirty_ring_prev_iteration_last_page);
 			if (val == iteration) {
 				/*
 				 * This page is _just_ modified; it
-- 
2.47.1.613.gc27f4b7a9f-goog


