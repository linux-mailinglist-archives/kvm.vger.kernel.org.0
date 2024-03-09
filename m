Return-Path: <kvm+bounces-11423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56548876E66
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03CA81F216C3
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1382D208D0;
	Sat,  9 Mar 2024 01:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2FT3jFrK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56361DA52
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709946587; cv=none; b=OuTMthdWos25r81gr7Dky9LYdEH6jr60xo1npvzT6dMmspj6cNZQl4ylzQaCYod7PQ5BSAhY4lDR8cNZrfJHBKmWuER53HSaXNkpjSIzOy80W52PEgxXwR7Mo82YWUwi4T83oflSZDVvmKYQqaR7kqUGTWJktuT6LgWSGSmT6Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709946587; c=relaxed/simple;
	bh=ycBchpSWHJX8l3+qZZZs50c8pkvQnvrnnxo1fe2hEZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HuA7ZyIW9utiMq3YGul1FR2LoGpvxskNx9FGLZj++YJW0pBi7rxJ272NFEdCRVOtulliRRKLewO+2tr/R7/CZfAaTQdqeP3tKEiIb4MNatldkj8moKunKnBkp2GNkEqZkd3MT4JEm/bjoG33qEPccMUH60kO+o0o9h/rftyBG3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2FT3jFrK; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609ff5727f9so22500337b3.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709946585; x=1710551385; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g4owpzTMykQxDUqiA6ej7g45orHQxXd/2WL2dIWa35k=;
        b=2FT3jFrKAA7AuyqS+TGTMp9MsPHqm7nfNdjH2gI2DxkC+nmlNDEui/eS9thJOX3L5S
         AzMQ3rFqqzsW2L7qbBnund07mHDuaEKVjKrvkYPDHCZXG0ur10H3cnx9atKyDG3p1MgU
         tqvTarwQn0JLdGbaxq8kQyeUpzT1VeJQZJiRFWgNca0pp10U63YKD0HWAnTCWX1w7YTb
         F9DEM4vZmuJ/sM/Q+Xk9GimlRSMfphtZQt5tJhFx5z4an4zE9fMBWPSYNP8SgYEN39s0
         M7c/AbD+IijsH9oKNgd5nl8BpE7xcDg6qtDMYzwvW7/ZF6D39eBgg8UiKfaARAtWLOr0
         g0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709946585; x=1710551385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g4owpzTMykQxDUqiA6ej7g45orHQxXd/2WL2dIWa35k=;
        b=SQNNndbDdVo40IIFy91hBlLHzUp1eSTdG/HAPKYmHr3SDqOcR4UKHJeRSzrngJCXLC
         DHBML2thhZNt2zVV9V6WqRwZl2eRyq4ejXJ6OtHbGqxCD/yhkCjGkqKz4fEisxNl8oSY
         +t96cEbdtFBGyyRDBH81qrlhYFvj6IdDbzbsgQ1gx9dminZeX5VOtFr4HLvewbp6Uh+B
         lLxaiM+fTIG3LaTDYNjJ/TXVVl1TtWwspe7xJuEAc2vIdAzkEhyhmQxVZCTVnIQaeC+B
         vevmePO+xMaTQKZh3noWegfBZ1VEflXwIK5oKUxxxXuB/VIP+O+SRlrBuHazQ4kEK5Lk
         fRVA==
X-Gm-Message-State: AOJu0YxSfaYcFk99nHy5VvoLv6GPnCHVvL8cZmFkTirYGXsqvVX8r7yP
	gTbsyt033Z27yxjbX48GUdG+bNCknWYKGcWeNwDyId9I9AdK6uFV6JoKWuJghyj1emOxZ/gxL1r
	6lQ==
X-Google-Smtp-Source: AGHT+IG6WhzVfQfNxhkh6vO1oFttllHBGIxq53Aa6SsBcpq2DPCtMuTS0yWAgaYlxw31FNSJQ8BASJ/xVnw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:df93:0:b0:609:6150:da22 with SMTP id
 i141-20020a0ddf93000000b006096150da22mr217869ywe.1.1709946585045; Fri, 08 Mar
 2024 17:09:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:09:27 -0800
In-Reply-To: <20240309010929.1403984-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309010929.1403984-4-seanjc@google.com>
Subject: [PATCH 3/5] srcu: Add an API for a memory barrier after SRCU read lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

To avoid redundant memory barriers, add smp_mb__after_srcu_read_lock() to
pair with smp_mb__after_srcu_read_unlock() for use in paths that need to
emit a memory barrier, but already do srcu_read_lock(), which includes a
full memory barrier.  Provide an API, e.g. as opposed to having callers
document the behavior via a comment, as the full memory barrier provided
by srcu_read_lock() is an implementation detail that shouldn't bleed into
random subsystems.

KVM will use smp_mb__after_srcu_read_lock() in it's VM-Exit path to ensure
a memory barrier is emitted, which is necessary to ensure correctness of
mixed memory types on CPUs that support self-snoop.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/srcu.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 236610e4a8fa..1cb4527076de 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -343,6 +343,20 @@ static inline void smp_mb__after_srcu_read_unlock(void)
 	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
 }
 
+/**
+ * smp_mb__after_srcu_read_lock - ensure full ordering after srcu_read_lock
+ *
+ * Converts the preceding srcu_read_lock into a two-way memory barrier.
+ *
+ * Call this after srcu_read_lock, to guarantee that all memory operations
+ * that occur after smp_mb__after_srcu_read_lock will appear to happen after
+ * the preceding srcu_read_lock.
+ */
+static inline void smp_mb__after_srcu_read_lock(void)
+{
+	/* __srcu_read_lock has smp_mb() internally so nothing to do here. */
+}
+
 DEFINE_LOCK_GUARD_1(srcu, struct srcu_struct,
 		    _T->idx = srcu_read_lock(_T->lock),
 		    srcu_read_unlock(_T->lock, _T->idx),
-- 
2.44.0.278.ge034bb2e1d-goog


