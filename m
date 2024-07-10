Return-Path: <kvm+bounces-21382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DFB8592DCEB
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:45:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 567E3B23AB4
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC8D16A39E;
	Wed, 10 Jul 2024 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rMFUNTKL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D691607A1
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654970; cv=none; b=M2AsFDDjXH7k1GIUP+Y4D5aq+E7s99BPh3g6mNb86VMAdJqCOGzLUAvOxaK6gs4qQcqLusq6ku6kJhh7Ilz3lrYRzeRX7YfsIjMbWru0QIU191p9A7GhPcC8E65BHuPlIX6idk8Vzgbq7DrnWTENTnLcWXnBKG6tI6k3231Cmow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654970; c=relaxed/simple;
	bh=EiaFG/eYwx8Esdk1XHkxgkjzifP+kflmXrizk7/imlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VroGlwkog9q1d5w8Wh00e8zbb7iSNqveztJ3FbUEkaQ9N3/tqZY1r6JtIPmZFfJjD1XiBXdklQyfzEr9R5AhpF9FwS82WFH9xKOb8DiHY+rhQYGz2D9Ag4Snsm5l8yOiptkK6tqPBCL8/AyuDiVKgjUZSKLxS01rAEz/EplOxRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rMFUNTKL; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0360f8d773so448006276.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654967; x=1721259767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=45lnTGeGmxXRWR2sOGpDAv49wjAnxo1Jn2Fj4ejBtf8=;
        b=rMFUNTKLofPpwYducIF7Cw1iPUXYaUMhIvA4pJK+FJsMhuBbEfYeGicZCi2TAepbxP
         /gfUoP17B9rXWJ04a8cN6dpwPorrae1HDEr0DaMvofo0rxTKVYyJk9uUPiW5jtycP6sM
         pZCFGBncyRsJ84unXBEqIZeqeIws7SW9Aowz3p9Z4Xi6IVfFcdNkG+NI1RgmFuLsV6lL
         UmM+1Q0Svtf4n6oRyE3aVLRupiIw93GNtJDF0o8h9JlpvB5VAcPLnJj2TRcnb92fpZhf
         4B7SwgKMUOCpAGuicSrQ9lZgLXgduUWTfR31z++P+QGZH+8fD6eMyxul0aWQ/fd1+Pht
         1qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654967; x=1721259767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45lnTGeGmxXRWR2sOGpDAv49wjAnxo1Jn2Fj4ejBtf8=;
        b=LR7bYYQ41i6WLiQH8KAPKrNuSH36aq4JuWUUZRM3V2y801xWSZyiNN4nEbv84z6KKM
         /9z7J4hCaq326PypC4tzPvd8Mr5wR+I+KLHiZCb4YhNsANEn2EjIYZuGvpgCqMTLnAQE
         vDAv6mUNrbodHOSE/eUoJlH8A6MOQKyiGE9XY6vlq0yGhAcLRDxMF0jysW2l/pQ+ZD3d
         nRCdKEQ8iztIoam12Q+gd1SA0OvezM4aUUPelbAjdxNIIgdAT9G0ORG3FXhAyGlQhThM
         v2Zte1vJkW1Fija9oa7uNLiS83qpGJSEZYDXBSP0cPPr+HYwoJ9MbMAnVP5mqngT9ZU2
         Rwqg==
X-Forwarded-Encrypted: i=1; AJvYcCU1UB9UW+g1KfyFOWpOVDXAfthiWKcJOc6PHJ3a90qEYRMH93l8fEKLkHxx68KuTeOqzRmn6NaJH2Y6+T2yQS7bUK1a
X-Gm-Message-State: AOJu0YwbwAFKiA5VodsnrTPl9PGIzt3gMQS56LwZ8TGH2wxk33dx7sGJ
	sAQhv7ArOcS8PozYBYEB4RDhr57QnthtdyR1wdAib2phNNyNUSVMXWq8Q5DpH5RgSwidmHotL4F
	wKic3muX7KcN+YLVigQ==
X-Google-Smtp-Source: AGHT+IFCxPs0hzUflzzz70jRYwVRx4Gd4jDUqm7Yw06oBbmfCbRIBM9zwU8x8QPsTa/dYviA394CpxXkoxFldKzv
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2381:b0:e05:65b7:32d9 with
 SMTP id 3f1490d57ef6-e0565b7352bmr91773276.6.1720654966908; Wed, 10 Jul 2024
 16:42:46 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:13 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-10-jthoughton@google.com>
Subject: [RFC PATCH 09/18] KVM: x86: Add vCPU fault fast-path for Userfault
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Without this fast-path, we will take the asynchronous userfault path
every time, which is inefficient.

As implemented today, KVM Userfault isn't well optimized at all, but I'm
providing this optimization because something like this will be required
to significantly improve post-copy performance. Memory fault exits for
userfaultfd were proposed for the same reason[1].

[1]: https://lore.kernel.org/kvm/20240215235405.368539-7-amoorthy@google.com/

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b6a053758ec..f0dbc3c68e5c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4380,6 +4380,13 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
+	/* Pre-check for userfault and bail out early. */
+	if (gfn_has_userfault(fault->slot->kvm, fault->gfn)) {
+		fault->pfn = KVM_PFN_ERR_USERFAULT;
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, false,
 					  &async, fault->write,
-- 
2.45.2.993.g49e7a77208-goog


