Return-Path: <kvm+bounces-30777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 604E39BD53C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2289B22C8E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216BD1F668B;
	Tue,  5 Nov 2024 18:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SwLGGq9N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012791EF0AB
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832231; cv=none; b=NjHh6331uAS8MExspqX7YmojeMgz3jJKBth0fC2I8V3v5RplTZUfja8+p5XkbzlHh0lkHTfCWlmvYbXThOjI2YhxiSZ3FQAf3xhKI+HBFroJh4+Zj2/kgbg4xlZpPWgvZgHcSVu1nXFjTdLKNWaUCdb9eYCJpUDtfbCx2u06VUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832231; c=relaxed/simple;
	bh=gQHbST9g9dX7AdsXb60482aaTjlBxEvk62T1cYPsouI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sn8nGlII1Ryg1JUxP4lX2l7hO0irLqb2SbR3O4N7axB5tCI1lEl2h0jvfFgga2HnpqJuP711RaJa2BsrwgipcK2B5QXnc8voEjs8eYg3CpVLeLGFSk8P7nO15FCneScvjzIH8Rk7DaLLZZrJomoJwhCm8rQKwrU+6NxnJCZiJp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SwLGGq9N; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2b9f2c6559so8704974276.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832228; x=1731437028; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RVQiqQNJn8V9+bn63bPEy1RgKjlRZWWwgjJvsJY30w0=;
        b=SwLGGq9NnoMxQhrWHy4HL//u0U4PSD9cGBFijgKCyTpFaeGWZ5bB21Pq9GTqkY+Imi
         8cIFM8Yd5Pso9pqOz916fnU9wdrVcXmH5fsrSw3Of8LSq7CHscXP42QnYm6MgAL7zOJG
         ZBtMcvmawjmHO1+1OdBkPaZixvQ/ZUziAK0XP5c+9lXrL5J6MU3xST7i7MX/u83/FdGX
         mJdhpM5UqVFvI/mB4rt0JetT23QTSBcYT9jJdoUB3NtjcJgZXIYoRwzVZ209BYPnuFrA
         MXTbg3RkI+zf8CXUJlm0RXIATxlmImHjOA2mUXG2W8HcioONbxpbz5+pkPXi2vhkvfXV
         fWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832228; x=1731437028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVQiqQNJn8V9+bn63bPEy1RgKjlRZWWwgjJvsJY30w0=;
        b=SqkTb3QavLI72J3eNF6OE/DEoWF7aMhAEm1dVq6hmJQWUtJ7pv9BrngdKSho/3Clj9
         Kh1lEEZS6vxgIBbR8cTMf8Dsa8KJj5c4q9cq2VTwA+D77EZaNFlL2tyhhfnlg2L3cYX4
         80lOiS8vH5JM+a4dEhyvN+3RAfGQRf3FDZYXF+z1BsFsENuMvHjTEBzsdvvUbV6zW7F0
         TEobPdKoc61OhALAp69EecAwPLqN2+gjJfIT7k8QAvd0cUrDH+MJuOK9CcYxZNNWkzbH
         BCUOdm/LzbOHKLgq08rGD8Bh2bKUSZRoXHyNgCK0N8Hfr/v37JUkXIQfWZYCwN4Np8oL
         Ixqw==
X-Forwarded-Encrypted: i=1; AJvYcCXBmWQ8DrMl4ASJKVWOvMK0tP1x0/PfAHIOs5z0blLJswxuUFVCzEOcqIv6jUh79dw0XxE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxtK0OVtKo1sq3yiLIhaOahXgF0QfSI3kHSIhH2756+p5jSEuh
	QZONIdQBow/4TmAuHFyrXDyYOmAgKiN8pwHwA8wmLUn6F+plsFzLPt5igweJbXvadxbi+7XdZp3
	+EyvBf3WtUXFL4htozw==
X-Google-Smtp-Source: AGHT+IHXM00di5OmvL87GQ4jzSym+HQrvnV/cZmee9spmhbqBumr9Iqc/+cJun+krlb+CD896NkOpi3sK+UJI8u9
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:86c8:0:b0:e30:d717:36ed with SMTP
 id 3f1490d57ef6-e30e5b3afe2mr13577276.10.1730832228018; Tue, 05 Nov 2024
 10:43:48 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:27 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-6-jthoughton@google.com>
Subject: [PATCH v8 05/11] KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reorder the TDP MMU check to be first for both kvm_test_age_gfn and
kvm_age_gfn. For kvm_test_age_gfn, this allows us to completely avoid
needing to grab the MMU lock when the TDP MMU reports that the page is
young. Do the same for kvm_age_gfn merely for consistency.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 26797ccd34d8..793565a3a573 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1586,15 +1586,15 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
+	if (tdp_mmu_enabled)
+		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
+
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		young = kvm_rmap_age_gfn_range(kvm, range, false);
+		young |= kvm_rmap_age_gfn_range(kvm, range, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (tdp_mmu_enabled)
-		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
-
 	return young;
 }
 
@@ -1602,15 +1602,15 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm)) {
+	if (tdp_mmu_enabled)
+		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
+
+	if (!young && kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		young = kvm_rmap_age_gfn_range(kvm, range, true);
+		young |= kvm_rmap_age_gfn_range(kvm, range, true);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (tdp_mmu_enabled)
-		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
-
 	return young;
 }
 
-- 
2.47.0.199.ga7371fff76-goog


