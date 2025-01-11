Return-Path: <kvm+bounces-35160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D0CA09F6F
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E6B3166753
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6162C1917D4;
	Sat, 11 Jan 2025 00:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3kdqhOo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B5818F2DD
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555432; cv=none; b=CvtTTQNUszxYACUmhcAPbCVZy/cc6zMWbYCWLQqRH+1SxfNGPB86tVQWwm01KvOOS8CNAlO8XQuJb1zswz2FIie/PgIeGTcnY9k3Do9hPZKZH87N+D+1hwmREEQpTPRJsFPazl6Il3ava06Fc6FQnJLZlhwqumnI8C45S+9pt4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555432; c=relaxed/simple;
	bh=X7hrJAn5Xd5/ffe52AsOh35kq+1hLy36dj+3TszD2jM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UykIxvKebHNUnBTLLJkF5X9gnuFssOkdmA0+FUwjpOba5bF4go0IBLPF5UOYxWatbZ/3k6Y4jGMJ74qXUaXpDW+vw17Qq3UB1CZ5nHNiBk97RRU8DdXiiw65+L1ATukIKsNz/siEuSOuD7+GIcIomuxinUmp/WY8PS9rO2mylpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3kdqhOo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso4772439a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555430; x=1737160230; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xyN0UMRkk6rC6WIB3fcMIoPE8NE4GF50oCJ4Jr6Xg0Y=;
        b=F3kdqhOoJPU1ILmLGSbMSfJU6GKiBddLNkQpIBuzga/DrIPukoiBEIaeTFN2/cjOsO
         EdKislkUdig9PE0zDi2pRd4CnJ7rYm9dCJfc7R0yYKiQm9oJ1z4EWGgt3tnaKwv+v7B3
         V/78b2IAY8WvIc5zsKHegWhggH/WbjEJui6F/9HZZBTi8bzNESyVcSfCuYUy9qwKryto
         nYxyd11M9BmPuo9S8hiqJkmCSKf/F5SqZp/qowI8gmE4Sq9/IT69v7pGJcY3kwwLpXRk
         E0Iq73mnxe05vw7XXIxKVzF6xZOvX2s4fDLN5r+SqZXvBVdxW8szYAsw+dKgTkUKxJVL
         yi1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555430; x=1737160230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyN0UMRkk6rC6WIB3fcMIoPE8NE4GF50oCJ4Jr6Xg0Y=;
        b=Yd1kKa0bTacCzkxnVDClHOAcTMlvIUeuNi8IukadCNGvcf5DCn3GbSjS7gbcrVrPIb
         jy+sjeiy8Am+zP4n26eFGUcHaOKRVafOJ5mN/tECrjwJsXvORHRy4N4rwdx96I2iEtmV
         ZU5idS1xbyxaGco4MNWynlskiib/261eACpR2N/OTcE7Kpl6uB4W1sBtNdABkqdYn1xj
         dbrgzhSd6pTpdjEzjngeAgndZmBR2qN/KsW9a0jHbP3wZNMWWY4vlhuk7xM17okyYRiU
         bpOIToP3G0/ec+i3gB9NlWnWzw0/fgEfBDdmut+av6KybU2hsvpypHr7LfXlGCCAriNS
         gErg==
X-Gm-Message-State: AOJu0YxrCQwWk3JemtKR3Khq7ICO3bG3A9OQJyFW8HWlul9w3AcugbIl
	ei09gPQUIM4QCDE96nqqJO3YJMsXSBK6k2+Lm/Vr9ACAMVMgIwyK0z/Y+mv5/fx5qQqrJi0Bkj8
	lGQ==
X-Google-Smtp-Source: AGHT+IEVKgEyyMYviyDeVcIm5o6jXTSkBhgMiqMrJzFk4QIbXfpDD6AKxEzcxV0qnKVdo1toVPZDgB8gkB8=
X-Received: from pjbqi14.prod.google.com ([2002:a17:90b:274e:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2509:b0:2f6:be57:49cd
 with SMTP id 98e67ed59e1d1-2f6be574ac9mr253754a91.25.1736555430491; Fri, 10
 Jan 2025 16:30:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:57 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-14-seanjc@google.com>
Subject: [PATCH v2 13/20] KVM: selftests: Print (previous) last_page on dirty
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
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


