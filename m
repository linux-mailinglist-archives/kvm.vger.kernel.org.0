Return-Path: <kvm+bounces-23284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBBA4948619
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F8791F223A7
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001E6171E40;
	Mon,  5 Aug 2024 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DNKFwzoI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E79170A35
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900690; cv=none; b=mY0b8ZxLZ4F38+SwhWSPsvnnWyzZ3/v62yCkMc0HNIuqHegduQdxTkePNfIFdcuj+Hh5mRC7/UEoG3MxZBdKK6F5Os9cBid7vfigAC9tBcUZoJZH2DSQCT1sJ/oCr2OYpr29Qk9EWapLF6LVtvrFcYaOUm2iOdGhONf6QYosnjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900690; c=relaxed/simple;
	bh=MDOMLayfjIGR/QoQ/prCRhBhZISBv/jdpz5s1GldHHE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ulyjIncPxT5cgFOGNirD04CLl5VzTVZxLNnwrRltzAXkHWzo4ZckEUbT7sX1/iANZO0s2Akj+z3ub5gsJCb6l/42ibCRnvNo7m7wQw/4zTIrF4rCsFFX9SsXlmyfJY3O5ed35I5YA5b8gZ031fcn7EaWjcjR1h2RDkyRBHDg1Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DNKFwzoI; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0353b731b8so124397276.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900687; x=1723505487; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MHhVlAWRZI6u1lNbQzZ5qdQHjZqjpl6IHTgK6z1gw9I=;
        b=DNKFwzoIt0v18aqaKgP8SfpqnT/s6yx7MH6DgU5Vr3PBhJwhqCQW3Mx8oNE8KSGz8L
         E4jYrMdCSOZyEJM5gLp5lWup8nfuVW042kXXnEtuXK4bLTKtoHopWMb2iWOK3xkRpqVc
         AhTPLXz+QHk0hKNUS4+7pccEKLhBzD+AlVxmAZ8SX8gaxsOHgNzh2CzLo47zs9n03ez2
         v5n0EMqsV1JjvaHTTGTPEUXo7Nayt51vVjWGYE4jOU1kI5Da1AWzvnyukfBhWhkywJlX
         kS2CSUJzbVzb1x7Tb4UZBDXUISySobQBavv+gECLJlBSaveLB8blzvw+8malmzKgtWP/
         51xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900687; x=1723505487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MHhVlAWRZI6u1lNbQzZ5qdQHjZqjpl6IHTgK6z1gw9I=;
        b=PrCpSJXlSlEIrISBhU11k5UCd8YGlCbOALeFMm5WCPpItD9qIMI7uIuXOq9LTw3rQt
         8jU+lzv2sqNGy/c4fGECFZsdlvGnOhI+iRL86m15BUNKE+KACyYsIJ5sn7OPQtHqKwLg
         xY6sNrrbv8FdvwF4XQdJser3rBL04J9uOzPxCJ4ABiPfVRiCLATkdRSt2mHGeAVWYM15
         3gL8M1K+RTtMUZCCJAXxsycu6oC7MpetN34JLUNwC62EfeTB3j8jQh7xS2xp4KlPq/lc
         s13D9D23sOZ13+qAa00j0wfS7pDpCFJ9jACv+EE2mVq7Ei0jGL8VEV3NUzH/OnuGE+Rt
         dPSA==
X-Gm-Message-State: AOJu0Yxe2ZaTtWDInEho3KmdBd0aKgvHoyGMTNCZM0eT4Q9bAhLoGRt9
	X+NzXeIRb3cliwyrR/mUFLj/5yJq0Ms0L66kcxOtIiZ1oRFO8MCna3urZNCeW4N865CKzC2r+xA
	ofZZJBR27bQ==
X-Google-Smtp-Source: AGHT+IF7slbkdtxlS0N6e+PrgrzfBzkNXTgW7Ht42YhCFEGRcI4DezIZzAG98aSUQatMmAEpn7loFuaKtxwhpw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:120e:b0:e0b:fa7e:8cbe with SMTP
 id 3f1490d57ef6-e0bfa7e8ed7mr15238276.11.1722900687581; Mon, 05 Aug 2024
 16:31:27 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:13 -0700
In-Reply-To: <20240805233114.4060019-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-7-dmatlack@google.com>
Subject: [PATCH 6/7] KVM: x86/mmu: WARN if huge page recovery triggered during
 dirty logging
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN and bail out of recover_huge_pages_range() if dirty logging is
enabled. KVM shouldn't be recovering huge pages during dirty logging
anyway, since KVM needs to track writes at 4KiB. However its not out of
the possibility that that changes in the future.

If KVM wants to recover huge pages during dirty logging,
make_huge_spte() must be updated to write-protect the new huge page
mapping. Otherwise, writes through the newly recovered huge page mapping
will not be tracked.

Note that this potential risk did not exist back when KVM zapped to
recover huge page mappings, since subsequent accesses would just be
faulted in at PG_LEVEL_4K if dirty logging was enabled.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9da319fd840e..07d5363c9db7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1586,6 +1586,9 @@ static void recover_huge_pages_range(struct kvm *kvm,
 	bool flush = false;
 	u64 huge_spte;
 
+	if (WARN_ON_ONCE(kvm_slot_dirty_track_enabled(slot)))
+		return;
+
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-- 
2.46.0.rc2.264.g509ed76dc8-goog


