Return-Path: <kvm+bounces-25402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3EE964E93
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 477B32824CA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D5A1BA27C;
	Thu, 29 Aug 2024 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2vA6tzHe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897981B9B36
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724958865; cv=none; b=Zvd3yK89Vjmu2q73RN5m4fHXSqWFV0y06HgtRPKpr+c32xZ5whdbW/lls81rLgB+2quJXsBpdp0O2gmsnDpypY6yqhA52HEc8eTFHSe7NLMgeVPPzaHEC+ROCUHVMzUBJUYlKxXHohRrWAYKfllhTBfRjC5iaep5SqBQOcc3mCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724958865; c=relaxed/simple;
	bh=DLYVbOyAOXiOoZ7O1FIx1sY+tLPrpj43JW66pjzCKCY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XLt2y4yM+KkTJyxEQ3Tlc5SmDOx3jkrn7o2wEp8oSIRl2NBFw0zXRDAC+kQH8f4LHIujPNGMsiVMk/dMQ6Q7I70pKbshgz81IyRbBzFABrPQC9v92fUjpHtaNLgB/+YI05rpcWeRdGhWg0gS6yiGnrcrac014DQpR4P5QinWShY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2vA6tzHe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201f45e20b1so11594185ad.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724958862; x=1725563662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=p/FgfdhlBFPaII3VwKu8OXKCzJuOVcc3OJ6Xh9EER4Y=;
        b=2vA6tzHedxqaioiTOTWkPLjs6KcByk4qEKdhPRWSBQeqRCMCNYjrr/925PRUh8EuYT
         K/48/mOXFxAG0n0O2dlrmTFtTYOalQpxNRC85wTTXGLHUoJqKsDni8MPNYx3qEKzsGuk
         zcC89VwsQklKXY3WPXTwsX5Bszf4fxkhbxsjMwA2fVePCmFx0O7bvekRB7Fx8d8d11+e
         euhw9Eai2JBw/RsxACIfOBmuzEBFml46Gmm9/+VP8vtmOBPn7AZmV8tUsgKYxGi/VQxa
         cJGnjMoVJRbTpHV3ad1KL0COvfGVEDvMQjHL6OWQj/kRzTstanuDT/DQ4/fycrRZzR47
         tnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724958862; x=1725563662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p/FgfdhlBFPaII3VwKu8OXKCzJuOVcc3OJ6Xh9EER4Y=;
        b=hvToPCBPygszrIDBMSxSUH5V3e2Ls/tn1GGIZOY7jyNIsx2rNkIfV+nypXcdHkb3ym
         qnIZ/aGwFvLegjbqt4KtHY+rIQF7mBJbxaEp3wD/C9jKXspJ1aMtemEX2QvvF/+dTxeu
         VJyyZy6Vx8apTBapjMUnP1p+rDZtCMTaMoTFfz/BHbyAYnYzyUh5YZo1Vtw245TqiIKW
         hYGOsH3ofs0E8/Ass5YiT/aav7thPtInjtK0z6mDQzGBH/L64pEew6KFYU+yr1UM/UaB
         6W4slI6eZ3rwjOczLxh+h0nCjuxC8KvyQHh0kDDLnb35/NWJglEgNbHPCq9gbrcG6qTh
         OxbA==
X-Gm-Message-State: AOJu0Yx3aup0sLIiy9EDDZRUv+o9W9+/ojkvTOSEbJO/Hq8gbMMOr9G7
	eez3mFso9S1NlDj/jll8zfMiGzmqf42NwKTEZ/+rOXE3dWqt+wD/cyqOVsU3CrA8RBteZkotu9u
	V4w==
X-Google-Smtp-Source: AGHT+IH5ChutmsP6103JjAhCqMw5SQ3KVVJLqVu9D4hnLR2shZ7oURw/Tuxrcs9dgf/1fd1kguor7MJA+VU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d508:b0:1fc:5ef0:23d1 with SMTP id
 d9443c01a7336-2050c3dbfc1mr1999975ad.7.1724958861863; Thu, 29 Aug 2024
 12:14:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 12:14:13 -0700
In-Reply-To: <20240829191413.900740-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191413.900740-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240829191413.900740-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: Harden guest memory APIs against out-of-bounds accesses
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zyr_ms@outlook.com, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When reading or writing a guest page, WARN and bail if offset+len would
result in a read to a different page so that KVM bugs are more likely to
be detected, and so that any such bugs are less likely to escalate to an
out-of-bounds access.  E.g. if userspace isn't using guard pages and the
target page is at the end of a memslot.

Note, KVM already hardens itself in similar APIs, e.g. in the "cached"
variants, it's just the vanilla APIs that are playing with fire.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e036c17c4342..909d9dd7b448 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3276,6 +3276,9 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 	int r;
 	unsigned long addr;
 
+	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
+		return -EFAULT;
+
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
@@ -3349,6 +3352,9 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 	int r;
 	unsigned long addr;
 
+	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
+		return -EFAULT;
+
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
@@ -3379,6 +3385,9 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	int r;
 	unsigned long addr;
 
+	if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
+		return -EFAULT;
+
 	addr = gfn_to_hva_memslot(memslot, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-- 
2.46.0.469.g59c65b2a67-goog


