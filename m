Return-Path: <kvm+bounces-8717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2CA855885
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D3621C29317
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35DA4A02;
	Thu, 15 Feb 2024 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IeruiMMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746E41361
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707958812; cv=none; b=tOEosybzQLSLCk1WRRcGCBHecozYW76SF8JADe2T1gLqzEQz3iy/tDOkrz5H31PQ2KfHgZRKyknvIiobnS3J0TPoWeKudBJdKnQ61LT4TTYoIo8eVWoucZf0hgC577/YZglLZ8TOyNhd9ynsSBSxoVbmeNg6E8j8YCCvWClK3Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707958812; c=relaxed/simple;
	bh=jTbj8jFvFfIS5LDb9HHYZfAL1obtBWvqzjhsbEJwzp0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CMmH4zhWYgklYpW/WyneyBUlFl94HH9Q4v8zp/EVbcctDsJG/XFuGsXyifm/CSEPZ2ro3YV7of+yFkoiNTxd+d7Fhleml7h5TSwQEh3EgpJjOvB4/vEa4hPsajslmO6Dn2BLnMUDwDfG1OotGcZKDrmv1mo0C+I1sCXPvF0SupE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IeruiMMc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d4212b6871so3501475ad.0
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 17:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707958811; x=1708563611; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oyVxJ2h9yAcFbY918b+63LNZqAyOtEjbfiMvxQtpRyI=;
        b=IeruiMMcMZSFPUI0zT3SmhYQ2E27EviymZSruaJf2DFqI/eLMnVmFKWZCBJw27WewJ
         3g0M1qyMgbdLxpq7ieITvQwYIQStDVJIecQseU285o//X35JYa72PJwoUXnLkVT4yRGb
         x6Jw++LQRLZFo9kIFwCWnTP73icwzoozj83eRzZm5ngLP9zr235riQEnc2HfLfdfXceK
         qpRfUneUjvh7rhlC+qBC3L7a2xF/4VrWvm2RnhBNdBKiLQclw6myONEvWuLI4XP2vFpv
         d47Wh7sg8oe0FNLpPTyqPHnuUH0vmO0CClVAp7vUc8RazdWECB0Xtoqv6gZyZWQ6EgFb
         Cp7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707958811; x=1708563611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oyVxJ2h9yAcFbY918b+63LNZqAyOtEjbfiMvxQtpRyI=;
        b=nR4jkhoN+2o16Lpn3oa1Hy6urQgeX60FasvOIRAJOLamugvxXoxrrwzv9CCfpF9DJc
         IerxyKIRDVJaVvnT55YxPzCgQgeJTGR8c5Gwjyv5fKskME8BUs37TV3X1/+Xo/UJpsoS
         L/YURT/uhksTgLYL8Z37OfYVRCa22VM1QcJs0ZIyhRY0Is9rQcQggnZhFRzfjbHkfHzp
         pdnCFGPxWcbei8qAD8KIuHcjiA+DH4NcNc1NVp5vV2cUQVYjxJvVnty6PUOaYYELo2YT
         gckOhCBO6OCSSZm5EwM6LN3kEYPQqk36N16fTt7ifJgCQAWTAy77GG9x6Lq4I6gapxvX
         6Q7Q==
X-Gm-Message-State: AOJu0YwkJ36/WEmqmRm0BFDKxq5x/KX2+zUeGcT1bbSzFoLi6irOoGGT
	bCOG9vffCGKtnGGMhIWI31VCoGTFS/TUCZaL6nQbkmuxiQN+QnL4RHA99OY16Vq584GbeW3wblp
	gLg==
X-Google-Smtp-Source: AGHT+IEU/4hLETLuxtQlh7LzyA7J6VgvcpNXKOm4QsY2QVfA2M9xsuFWVkTNpJVMp7Fe98nI1iS0AgVq/3M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f343:b0:1d9:a460:a63d with SMTP id
 q3-20020a170902f34300b001d9a460a63dmr682ple.11.1707958810510; Wed, 14 Feb
 2024 17:00:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 14 Feb 2024 17:00:03 -0800
In-Reply-To: <20240215010004.1456078-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240215010004.1456078-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Mark target gfn of emulated atomic instruction
 as dirty
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="UTF-8"

When emulating an atomic access on behalf of the guest, mark the target
gfn dirty if the CMPXCHG by KVM is attempted and doesn't fault.  This
fixes a bug where KVM effectively corrupts guest memory during live
migration by writing to guest memory without informing userspace that the
page is dirty.

Marking the page dirty got unintentionally dropped when KVM's emulated
CMPXCHG was converted to do a user access.  Before that, KVM explicitly
mapped the guest page into kernel memory, and marked the page dirty during
the unmap phase.

Mark the page dirty even if the CMPXCHG fails, as the old data is written
back on failure, i.e. the page is still written.  The value written is
guaranteed to be the same because the operation is atomic, but KVM's ABI
is that all writes are dirty logged regardless of the value written.  And
more importantly, that's what KVM did before the buggy commit.

Huge kudos to the folks on the Cc list (and many others), who did all the
actual work of triaging and debugging.

Fixes: 1c2361f667f3 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <tatashin@google.com>
Cc: Michael Krebs <mkrebs@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b66c45e7f6f8..3ec9781d6122 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8009,6 +8009,16 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
+
+	/*
+	 * Mark the page dirty _before_ checking whether or not the CMPXCHG was
+	 * successful, as the old value is written back on failure.  Note, for
+	 * live migration, this is unnecessarily conservative as CMPXCHG writes
+	 * back the original value and the access is atomic, but KVM's ABI is
+	 * that all writes are dirty logged, regardless of the value written.
+	 */
+	kvm_vcpu_mark_page_dirty(vcpu, gpa_to_gfn(gpa));
+
 	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 
-- 
2.43.0.687.g38aa6559b0-goog


