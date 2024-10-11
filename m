Return-Path: <kvm+bounces-28590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C97999A2A
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E85283EE4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF42B1EF94F;
	Fri, 11 Oct 2024 02:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hn+crdcV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB671F9420
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612681; cv=none; b=gNtHgTxwsF2+aVkulx2msjjKJYVksEACW/JfF8QirvzxeRI5pOAlypfMIXaoZvJW9ifD45SWLwhR1tMr6C+8AE26OywDz4+T+/WKCp/arJr01wQOhl32GI3r3BssSi9mB84kkizV96veUvB07uayoZ6t2v8mIr92MC1AKx7sENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612681; c=relaxed/simple;
	bh=MQky5LU9doflUP6MUDx+1P9jZCBxYMqk3zoIPK03/xk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fX5z3DVmsJnVFBvKur+BJCgDwD9xp9S36/Ko/mSqhB22ScwZpk2HHhuzb7bUkK99l8184Pi5yZPsr0IgLhjewoFp+EixT7M/cDRQJV7hdbickt+9twJ04HMeV0kr12IZmL53kbfhMqrZhaa70hvmHm18wLjMw7gpNdxKvWecCUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hn+crdcV; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0353b731b8so2150273276.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612678; x=1729217478; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pofu/xUm1x5cnfvwcy3zr8J76zUU6HIdLt58yu7YvsI=;
        b=Hn+crdcVa3vq8a3tSKyqiXyFFqeZmnbRplEnpc5SPx4b8JD2gjo48Hr9i5KoyVE29v
         09KvSlvlhDNY5ny/C9RZJXx9O9YT/7JAvjQ3sxKsJAbsFteCJ0brVhRnvsu6vQzGLhKW
         Eozyc6rkAqpvY6N2yP+z9ip5OwI0KzRrrSbi4DaX90O8E6ZJoWLQxus68504n9cD3iHl
         cxQP+YuWjg0+jt7UaKwWacbvdY5OFuCZOvmKzWa4cmNYWIq+e4LibQ/izSkyHywS/fQj
         X9A6PwXbjK+j65u+MFAtLlD5Epcn53OhHA0M2aeA9OAMca2RVFBsuZ0ebdOWL370W+aN
         ZU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612678; x=1729217478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pofu/xUm1x5cnfvwcy3zr8J76zUU6HIdLt58yu7YvsI=;
        b=V75x5W+LiylsNy9VD2GyErVfSAxg9QDoUqmxO8x/kVDu0lbi9n3LLTreDbUqxZWLaK
         GbX21gF2VFNsAvbYeqRg71Mb5KpWYf4TAmypk6nNrSTH0FjZgcXJE+PeWqgThdymS4AS
         v7NQq0NdIBBC5H7lcX+9zNW3eKi3QXiSUZ9rWHbvpRuz3tPrV0QTtwSKKWoJJqRvmLNT
         FZS6+KzKglcbJbsdT+WJwbNBflmoeLkuMyeUK1JqgmOt0s0q2rpAza7hCjjCO1yvGzAC
         jvWMotG5pnl4DQO+ObTj/EfO0H9azwJPowRT+zzz42QwJO57AuCRcVDvDyrLXZlbWaBP
         47qg==
X-Gm-Message-State: AOJu0YyULqLfwWR6mQo84mP6dIiYBMjb+0ZRCQYzK1lHF8bqLwfkCQ0Y
	mJ4wkiU7NIgOPrZMgZeNBrBONk1qrUpsnTfaGbQVauXQuFB+2wxk7Byh5ZN8x/eNtI9D4+uBWPJ
	j+w==
X-Google-Smtp-Source: AGHT+IERrauzYd7CMcGSLwn903JJYQaXvPNepCw4lxr2jUmibgpbopAs+w2tf/sgFyOhULKSVVUqL8Le1K0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2687:b0:e28:eae7:f838 with SMTP id
 3f1490d57ef6-e2918e5b589mr1037276.0.1728612678637; Thu, 10 Oct 2024 19:11:18
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:45 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-14-seanjc@google.com>
Subject: [PATCH 13/18] KVM: x86/mmu: Process only valid TDP MMU roots when
 aging a gfn range
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Skip invalid TDP MMU roots when aging a gfn range.  There is zero reason
to process invalid roots, as they by definition hold stale information.
E.g. if a root is invalid because its from a previous memslot generation,
in the unlikely event the root has a SPTE for the gfn, then odds are good
that the gfn=>hva mapping is different, i.e. doesn't map to the hva that
is being aged by the primary MMU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f77927b57962..e8c061bf94ec 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1205,9 +1205,11 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 
 	/*
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
-	 * into this helper allow blocking; it'd be dead, wasteful code.
+	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
+	 * this helper must NOT be used to unmap GFNs, as it processes only
+	 * valid roots!
 	 */
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		rcu_read_lock();
 
 		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
-- 
2.47.0.rc1.288.g06298d1525-goog


