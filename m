Return-Path: <kvm+bounces-46892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4702CABA54D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 450A71887045
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110A628150E;
	Fri, 16 May 2025 21:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3jW5aK8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC55A280A51
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431348; cv=none; b=VThCg7LUqT/iXwoLVswK8tA0rGnh6hh+Gf4ecnfkjELcVumOrpTgxk2ItbxwsrUlwBvdgAS1klKuhQB7Qn86VgzixySuyfsZKW8CzgrX8XMsZ+vuO9xzBSiuK+ycC3gaUJsGoEqjbiaA3uxkBVI85RVj3mFZzgU/gmdtnerVq0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431348; c=relaxed/simple;
	bh=RrZIIikij6DmitW6dz05NLZuqphJeOs9Ps1ePqojGbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e2eFG71PBoNdwaX0Mz0FD7DlSnUqlHlACPWqX2/GBvrYj9acq7ne3tQo11y81IxQ8x8CSeXt4Y2xUGM19MO7RkpW6j/CmTOlriw2eb3bL+7Z/v/L8IMUSC3hl0+sfHhdXZQ5RAgBnYduyvuGXl7Hr3aEz7SL3N9iaKHNxn4dowk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3jW5aK8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30c9b0aa4ccso2336513a91.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431346; x=1748036146; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G9wmHetGMkK5ECrcXO3NqdUKVr+Bbfy2OeQR2kTh+6U=;
        b=F3jW5aK8hS9KEX1vtOHIcreyHVASXmaxPtKg5/Oygiu5GwtIUGdEXGrJnE6gP7I/L3
         JnlQP2oGA6uFUmSlTfq4zt3CSs4/3lkeMF1c7RhAVL4xeimdbEhT6jswq8UbmT08lYtY
         izRBSoBrO9sG6k/Fc7v/NE6ErPJ3n3KEdndH6OR1PYHfOpilP0tnY4dCXAmfClcu34Ga
         Q3OmW76oJglaYZZPT8tE6y+oNrXzT4oSXROKN4cfy38Z2ZaFoyS1bEnmKYjtEZdHwH//
         /0WEh/Fu9h0QVlFQnJa/rzOPeuPztu+Xpy1QdsiJ80KdG8s8brnYIX1mBhxDVx/o7wN2
         mVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431346; x=1748036146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9wmHetGMkK5ECrcXO3NqdUKVr+Bbfy2OeQR2kTh+6U=;
        b=Ksds1IjXSTijF3+P/Jcv8MgFt9eoKIGI1+I0KJ6BblNkve9NbADjjrmjkzXWhjgqCj
         HVuXbbuJPqrgA0cY5Ap/TQMye9sS5huHgQdZ6N+j3lHXhe/KDV5bI8JoKYaoj+OFHlm9
         tZ372U89ksAxD7jk0b0nMy770wTSc1BbeNswZEMm3SvQnXVlOQpfhyvs12TbeYlZw3dQ
         TOBWWpso2T6S9iyZbembtpZwA2Sr59z0jAkiIYzHG4YlqXrpSAFfbYSijmDHehyPdvI+
         xScUBPvtfMO4EMaNoJ5wEqZ3t+ibrIi1VXxDTIk33m+QlE5p1G21bQuVT4iwA6sFl7zV
         9cdA==
X-Gm-Message-State: AOJu0YwghnQYb2TEKzA0ME+BepKj71tlpQN3VMXECqbnl7NeARThHjyF
	gUQAqqFoJIRw+r7/pu0CaYiKp5DRnl8Cg/Y3CTXorAHXzTOQsBNPK4p+09bZIEaEs+GbkKIr5El
	NPJU32Q==
X-Google-Smtp-Source: AGHT+IFa21w7PEBxGuke+jG4g4hQIIBprIgWw+tC2Qp349rJsk36zh/R3cXUzcky2fs51sE1Hx6oGfXmwC8=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e8e:b0:30e:54be:37cc
 with SMTP id 98e67ed59e1d1-30e7d5a93a3mr6251597a91.23.1747431346001; Fri, 16
 May 2025 14:35:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:35:36 -0700
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516213540.2546077-3-seanjc@google.com>
Subject: [PATCH v3 2/6] KVM: Bail from the dirty ring reset flow if a signal
 is pending
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Abort a dirty ring reset if the current task has a pending signal, as the
hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
in a timely fashion.

Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 77986f34eff8..e844e869e8c7 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -118,6 +118,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 	cur_slot = cur_offset = mask = 0;
 
 	while (likely((*nr_entries_reset) < INT_MAX)) {
+		if (signal_pending(current))
+			return -EINTR;
+
 		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
 
 		if (!kvm_dirty_gfn_harvested(entry))
-- 
2.49.0.1112.g889b7c5bd8-goog


