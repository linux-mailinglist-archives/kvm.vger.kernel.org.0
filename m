Return-Path: <kvm+bounces-35149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9ABCA09F57
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0D14188C940
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAFE22BB15;
	Sat, 11 Jan 2025 00:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="It68Rp+y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5156E4C80
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555415; cv=none; b=bButzvuzJvJRG1y2WsWc3AE5r6MAFSUZNtt8QrVRT1r+binqM6AdrduGmEw1ttU/6fDt7EJCVpormbDB8Emao4fmd77NQVY146BUs6HSIKDJxbZAf43xOPV7pzr7Ua+y4CkY8VgjwhQ7BNJA4ct2brJuwClVtPS1EJGFm8g5DTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555415; c=relaxed/simple;
	bh=kRFkQPfv0PSWUJLw1F058m2xO/VHwn24jbFbfVNRITs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I4BeYuxAD1B8dodYth8RNHJmUBxQ81R2/hwmZO0m/vw4sohqrUx4yiU8OaFh5zElBl6mchvjb9bW7fN8MHIwbphe7ci9PrLHtpcYWDlJcjtjPfvc5hrrZmimM85HmGpuUErmMZQcERgrzRCbSdfZ/EYryrcdfj3Z5xyKtmLFR1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=It68Rp+y; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21650d4612eso66016655ad.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555412; x=1737160212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a/SsNBrmeOL+XTcAujo8LRjEscp+rd5UoAKZNA95NGM=;
        b=It68Rp+yDxu/7/kCZev2rO9STwcX/eyBzG8h1wBr5LUlJyveZCnfc+3yXrTRolMLzA
         BRMLXWamNICP1lGr1OEDX/iO29/RM2A9n1AX1BgxJy7agZxWEjmbzt+n9kcFGKpxlByS
         pSP3WqHy1TqmIFum1I0hbBjLfBbq0xBiV1Kx7ZMgMtihuqHbl5Tm/2lvWNZw4gt2gE96
         p4+wsiaEC0eiSFfFFY/1Tpj9sbPu7Pkh4IkhSW/ASf02BV2sSXIK5P2VjmgFvqHP1QWF
         ZWLBDYz9D8OFTdYfMedm3CZ+DD8qpXF8uB+j1U2ONuowsCozxfIKE+vneWhUEqGa1lio
         tfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555412; x=1737160212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/SsNBrmeOL+XTcAujo8LRjEscp+rd5UoAKZNA95NGM=;
        b=u0jYCGCGbAk+OMlawtElvxlK3owie1o4cJ6uJn6qn0lgWWzxEi4NXDIGabMs958qcG
         YePa7GPk5xtACdIVNoM/us12FewspUSJIWozqydEOoqdFpTEN57o1ZCzQUX7N9U5bsHJ
         sgMpNTgT+UbQX9y6O5s/ASk/qqQJhRZ1/o+pu/5CoyNz2eQjurNWKzF2fj1Rcn5C2YVg
         0/C2MzyGX6pfMuFQB0OB3McePT6x1Jely8K9T0zKHPEr3ujD7g+2MgAA+oyah5wb7QOc
         Ki62rOqDO7q9a+6XjBCyJ7xf2EvJedp9+0TYeXCPY2X36IITHwPr8WV52Gj/W6ppKwvs
         F9Cw==
X-Gm-Message-State: AOJu0Ywe54jLTF/2fZtp25SOjJ4+SeKlDsm/KuJDDzT9PNgaEu32n1oQ
	CivhmrcbWKQzIiPHfeYs87mHIaLrLHSyFY+BIyDrsnxZnm3gL+cJpkoQx/bp8ErCwDvTZd/LQnx
	cmw==
X-Google-Smtp-Source: AGHT+IER8rVpMyBVqwsOrLxxaVqakEwToEI3FXRKOmF6JTF9kogaGHv2F8pSmh3aP9HQjsY+vFg7meksq5s=
X-Received: from pgwc7.prod.google.com ([2002:a65:66c7:0:b0:7fd:5164:d918])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f644:b0:215:b9a7:526d
 with SMTP id d9443c01a7336-21a83fa210cmr212852135ad.32.1736555412578; Fri, 10
 Jan 2025 16:30:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:46 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-3-seanjc@google.com>
Subject: [PATCH v2 02/20] KVM: selftests: Sync dirty_log_test iteration to
 guest *before* resuming
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Sync the new iteration to the guest prior to restarting the vCPU, otherwise
it's possible for the vCPU to dirty memory for the next iteration using the
current iteration's value.

Note, because the guest can be interrupted between the vCPU's load of the
iteration and its write to memory, it's still possible for the guest to
store the previous iteration to memory as the previous iteration may be
cached in a CPU register (which the test accounts for).

Note #2, the test's current approach of collecting dirty entries *before*
stopping the vCPU also results dirty memory having the previous iteration.
E.g. if page is dirtied in the previous iteration, but not the current
iteration, the verification phase will observe the previous iteration's
value in memory.  That wart will be remedied in the near future, at which
point synchronizing the iteration before restarting the vCPU will guarantee
the only way for verification to observe stale iterations is due to the
CPU register caching case, or due to a dirty entry being collected before
the store retires.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index cdae103314fc..41c158cf5444 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -859,9 +859,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		 */
 		if (++iteration == p->iterations)
 			WRITE_ONCE(host_quit, true);
-
-		sem_post(&sem_vcpu_cont);
 		sync_global_to_guest(vm, iteration);
+
+		sem_post(&sem_vcpu_cont);
 	}
 
 	pthread_join(vcpu_thread, NULL);
-- 
2.47.1.613.gc27f4b7a9f-goog


