Return-Path: <kvm+bounces-17133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 494D78C148C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 20:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 999EF1F22DEE
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 18:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35C0770FC;
	Thu,  9 May 2024 18:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nL0LcUgs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730246EB62
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715278301; cv=none; b=bXrnZsF0Nvl7386vgpit9KFEHSYdgheSK90GbsCwgwHnYDcGk8XVZvFFs5RBxod17DGFy0do56HgkKcClx/xjbUl0u76VbvDi+YTlQW7+8JjGMf7BRBXazCR7TPqNev1zcBA/Sr4n6DdFYnKHub0RBIywEiG3HvAaXavF/dBRpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715278301; c=relaxed/simple;
	bh=vyL4+7rwBlSzQ1yw64XA+jmOZTA4LTXHIexIIjpvqcw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pfS3VZoylkY7f0huCY0Tt71AXnPl1hf9QT3K3ajvAoebo/ssRcHfYlhCUrg/lX6OYEJSA8DT4NPqtuuwyAzCZkjltclOj/Rdf4oX8HyUaX8W7ZY4kpJrqA+qCbcnlMb91CgCWZpnKzcycHD5NI4oXXqyfupF6OgUsWyFYM4pKXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nL0LcUgs; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de603db5d6aso1961942276.2
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 11:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715278298; x=1715883098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c+nrjDian7TK/aMUH1xjmM/ZogxsmrGe5vjnrXIZTgU=;
        b=nL0LcUgsPYsC3AYv6aVqTF5pjIbdgsgn8hoEM46eP2zk74UsCWYTJ3vrbY0bGhz+ZE
         ummLScX0zio2cKbIQzKLfwaBMNRlwXFDzBuOxwI7qrd+atAjAA6JAYQYBjxDKA9SG6wV
         X7qKLHo89oWSQJ5Y6S7mHF/1cyRWX6b6xcA+QGs8POSOpnnM2luA61QSS8mGrCVpDZtF
         idHpIoXvluZ3gp+vSzwhdb9x58DhnOk8oQbUBx/QRD7A2mXDoTKYzRFG7AmfLyQXdUHy
         opnX18PJGMVHAXBF6sLzCzlX3rHFToNWWdS7CpcH7IEhaFqdiSOl2dipLdgEiIli9oU7
         eULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715278298; x=1715883098;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c+nrjDian7TK/aMUH1xjmM/ZogxsmrGe5vjnrXIZTgU=;
        b=SHs8BtlSEyCaWXQnGG4kEGLIzrzql+eWaURbUN4RA0CBgauVSgCO6V8peUZ6uMwdKE
         zp0VTsCbjlJDFMmiHj70fiX7QGxzZU63X0lt1eaw5Z8qB4e0+JFPO3TWjlaJxHgdWU/f
         6A4GWjMC+blKphaFdXKciyXrxxgbkLGvk5fEjFcGYY6OedRYsuvbDoPcC9oUqh5JMx9s
         XpTS+m9+DJW3afF2aK9yKLAnb2vV+8Q44ZSxOghxvjbklbtWSzCsJlRn2AZ1YLHDe3qm
         o1K9B45RXGYBplAGCLkpLp5qv7Tf9SWXWE6AFeJ9yB+THvGKB/R9zi3vOu1mQY6MHJsJ
         VOLw==
X-Gm-Message-State: AOJu0Yzqu6J4usPz2ow5NyPbn+HXdXCULs+ySkrssfCuLn1ro+QWc+gz
	aonlChrpcgEGbq/uAv1K6DdFiOv6T9nRLxcELG0rd+gWV8EDnkaUj6sUSziH6sqP7xOVYn0gSM8
	fbIIDcZyZyA==
X-Google-Smtp-Source: AGHT+IEP23+qP0wzhW4Fi0tttzJPPNyFOxQmMv5bs0uRv9ume3b1wzMDhjG96Pu7MknJILDCaKHwadddDjHOgw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:1002:b0:de5:9f2c:c17c with SMTP
 id 3f1490d57ef6-dee4f37bbfbmr74981276.9.1715278298406; Thu, 09 May 2024
 11:11:38 -0700 (PDT)
Date: Thu,  9 May 2024 11:11:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240509181133.837001-1-dmatlack@google.com>
Subject: [PATCH v3] KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU SPs
 for eager splitting
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="UTF-8"

Always drop mmu_lock to allocate shadow pages in the TDP MMU when doing
eager page splitting. Dropping mmu_lock during eager page splitting is
cheap since KVM does not have to flush remote TLBs, and avoids stalling
vCPU threads that are taking page faults in parallel.

This change reduces 20%+ dips in MySQL throughput during live migration
in a 160 vCPU VM while userspace is issuing CLEAR_DIRTY_LOG ioctls
(tested with 1GiB and 8GiB CLEARs). Userspace could issue finer-grained
CLEARs, which would also reduce contention on mmu_lock, but doing so
will increase the rate of remote TLB flushing (KVM must flush TLBs
before returning from CLEAR_DITY_LOG).

When there isn't contention on mmu_lock[1], this change does not regress
the time it takes to perform eager page splitting.

[1] Tested with dirty_log_perf_test, which does not run vCPUs during
eager page splitting, and with a 16 vCPU VM Live Migration with
manual-protect disabled (where mmu_lock is held in read-mode).

Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
v3:
 - Only drop mmu_lock during TDP MMU eager page splitting. This fixes
   the perfomance regression without regressing CLEAR_DIRTY_LOG
   performance on other architectures from frequent lock dropping.

v2: https://lore.kernel.org/kvm/20240402213656.3068504-1-dmatlack@google.com/
 - Rebase onto kvm/queue [Marc]

v1: https://lore.kernel.org/kvm/20231205181645.482037-1-dmatlack@google.com/

 arch/x86/kvm/mmu/tdp_mmu.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index aaa2369a9479..2089d696e3c6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1385,11 +1385,11 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(void)
 {
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
 	struct kvm_mmu_page *sp;
 
-	gfp |= __GFP_ZERO;
 
 	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
 	if (!sp)
@@ -1412,19 +1412,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 
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
@@ -1433,7 +1420,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split();
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
@@ -1524,8 +1511,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				break;
 			}
 
-			if (iter.yielded)
-				continue;
+			continue;
 		}
 
 		tdp_mmu_init_child_sp(sp, &iter);

base-commit: 2d181d84af38146748042a6974c577fc46c3f1c3
-- 
2.45.0.118.g7fe29c98d7-goog


