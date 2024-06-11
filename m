Return-Path: <kvm+bounces-19363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 375989046B9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 00:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B9521C2244E
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC64155308;
	Tue, 11 Jun 2024 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="maX5ke7g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE51153823
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143523; cv=none; b=mOmF2hxh1f2z4LK6S4h0F6TH2sCozJb71khyqboQePA7nnAfhx8Yxy5Xre4lg8olL29MNlaNEgn9OGxcN0y+ihtFB0fRxOhKo3tx7lAqYfW6TCGSq8j5+KFdVHYwjxjloMEj2N89SnyURW47yAGntONmpB2lF5Q4HmVSoDbqPrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143523; c=relaxed/simple;
	bh=tBTT0YzYZmIQ08jDKrRrM52oI3cCt7LuvA+9gttFOMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JSdwvjMV1rVx6SgAroYnXsHXRKvTxC6Sb5vviZ/evIeLHlASsAtLYi5IdqYImkXlpXL+NnDKbW+GsL4BfysvfKeohEvF1vwTXwJqaA0Ap2YxiAlKMjeAYRajTcjNCfADYKRo5zRxv45RsSkXxoTIONZMdjE6BBRdFqerKdImysw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=maX5ke7g; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df771b5e942so9846226276.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718143521; x=1718748321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6V/i1CuMRW7vCXDnaQc6ILDmfsdZJdA9Ksq5F+/kAHk=;
        b=maX5ke7g1WuWJLVBrEyZa+zPAlITGcZXG3QCA/ikwHgMQYqHj68qrJZwSxo/P5pGtk
         gIxicu+wXJmbk+MeKrys+BvZE50lmp1KS+48u1DuPy7UNUQxgV7lVQhW+tin5ibkwnuC
         WvWrKSUIV7S9ZjfvBNnP+5RhSmXrrZbd+b1UFJtGeM2dj/oGDAKITtFQsIQUrTDbOk/L
         tRb2OMeXHn+R9aHCwrU/1PwmyurzS6kXgL6JAXyyo2cd9MGQkW/DK51sEIjKkYQrDFKy
         Aw9m3Q8+HteJppAi4Rbbp0YyThQ8PlbZKD8dc8K9xXS8b/jvC3zZRgmLciAk5+lgqZHj
         z/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718143521; x=1718748321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6V/i1CuMRW7vCXDnaQc6ILDmfsdZJdA9Ksq5F+/kAHk=;
        b=YDvFBXNSFH886l/HXiap2Sc4LOaHbnLT1bGNhLUuRfOr438H687+YzDGPGL4T3cH3M
         amVztQfbQJOMHIoXxNFDp+c29mawmH2vH6a5+WXtxuQ44uWTFJ5jcGGC30h+0ELYLBg0
         DTI6GJFrv7dHJwELufTHMp+y6oERTOCdFUay/2332fo5MPrLR/kMhxjhAyyZMg4tDyVM
         nu4yJPUAD3HSZHyiQZLHW8h1G+w6IZPHftCimfSMTy3mTJyRtYjlyPIeUkfelt3xlK2v
         klBdVpIMz6t0sFRKy5nk9KqdrB7I3qY/Mi/UstntgsnHddscQqdU+NH4BzlXZiAP7Riu
         NZvw==
X-Gm-Message-State: AOJu0YxoTQTY5KtusyVvPBP5ZV2zq0yXYq1vE/BdiKtONH4CMMe7HXe3
	mewDC7v02kQqXEVPog/lXEwmH2x8TYPxA9B/KZKhrahoVCgi+prwkeEFeU+c2f2pypsRnc7NLIh
	KqK2o1/i9SA==
X-Google-Smtp-Source: AGHT+IHbQPJ57HBK4CfqZWqkrKv+avZJS1Ml7m7jCeBhUs+6SkgJuz1wnVp4bG+9bZDmV0O7yAWEH64b6Gq3dw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:2b8a:b0:df1:d00c:130c with SMTP
 id 3f1490d57ef6-dfe66673483mr7031276.5.1718143521361; Tue, 11 Jun 2024
 15:05:21 -0700 (PDT)
Date: Tue, 11 Jun 2024 15:05:09 -0700
In-Reply-To: <20240611220512.2426439-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611220512.2426439-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611220512.2426439-2-dmatlack@google.com>
Subject: [PATCH v4 1/4] KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU
 SPs for eager splitting
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="UTF-8"

Always drop mmu_lock to allocate shadow pages in the TDP MMU when doing
eager page splitting. Dropping mmu_lock during eager page splitting is
cheap since KVM does not have to flush remote TLBs, and avoids stalling
vCPU threads that are taking page faults while KVM is eager splitting
under mmu_lock held for write.

This change reduces 20%+ dips in MySQL throughput during live migration
in a 160 vCPU VM while userspace is issuing CLEAR_DIRTY_LOG ioctls
(tested with 1GiB and 8GiB CLEARs). Userspace could issue finer-grained
CLEARs, which would also reduce contention on mmu_lock, but doing so
will increase the rate of remote TLB flushing, since KVM must flush TLBs
before returning from CLEAR_DITY_LOG.

When there isn't contention on mmu_lock[1], this change does not regress
the time it takes to perform eager page splitting.

[1] Tested with dirty_log_perf_test, which does not run vCPUs during
eager page splitting, and with a 16 vCPU VM Live Migration with
manual-protect disabled (where mmu_lock is held for read).

Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 36539c1b36cd..c1f3b3798764 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1366,19 +1366,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
-	/*
-	 * Since we are allocating while under the MMU lock we have to be
-	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
-	 * reclaim and to avoid making any filesystem callbacks (which can end
-	 * up invoking KVM MMU notifiers, resulting in a deadlock).
-	 *
-	 * If this allocation fails we drop the lock and retry with reclaim
-	 * allowed.
-	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
-	if (sp)
-		return sp;
-
 	rcu_read_unlock();
 
 	if (shared)
@@ -1478,8 +1465,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				break;
 			}
 
-			if (iter.yielded)
-				continue;
+			continue;
 		}
 
 		tdp_mmu_init_child_sp(sp, &iter);
-- 
2.45.2.505.gda0bf45e8d-goog


