Return-Path: <kvm+bounces-55802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C05B37599
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 01:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E5711B65F1C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 23:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5083093C0;
	Tue, 26 Aug 2025 23:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="med1qlGa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5323D2BF
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 23:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756251459; cv=none; b=aVPbNN70OU/r56t5pHOFbZn1MCuD8dvS/EFhwg2k9GLADqfeEmD/2Yh0yaTfsnbZEn9UxMcw9LpIdSC4A1rAVggLK2xmhDIvfHtF9QRInV/c6BmP2vYyKWGiRGPfeT3efPD5GDTsA1P4vmVXdlgs9iE38leQv3RIejjBwibVptI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756251459; c=relaxed/simple;
	bh=j57N/Gk82iBRerXycfBZguqB9r1i9u4OOCcaeL2IZ/k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RwSboW0wYUHLXV7zE9HpxOnfVPjEdIVzuUOwyCrVzVwGzM9WHlsPi3eT3Oqf+qe3kWqmmDHr8aekZkOyz8a0bIw4v/C/NGwSVYcYqbDMRh8k1NwNZQZmEYJbu6mf15WRKFqcsf+vXw/zdMvAGjLTT3fcnmoPvYxw1lJ2psOdmRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=med1qlGa; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-246cf6af2f4so54132105ad.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 16:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756251457; x=1756856257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjoQc+0HHdQoYN8CUyvxMw+PJ0TtJn9kjqaYpRARa/o=;
        b=med1qlGa69yZMBsdwEfWqKVNV0u/iL+5wxbGISOOWzbx0YU6WkyJ4wmiLI59e9cIbW
         q5jJDWNHB0bIoNkGiu3UC0C8yEBnVVH4JsTiJyxmYTOCyTTpd+J/x4D0C131wdczi+kt
         cGbIz61MTxRpuiYR2mP6sZX6WvVtCFAIiAeEb/lG1qh+jy9elRfD8MyLA0QxEqTU4mnL
         UW3t/l5pqTVJIz6pvX+F3+bm602jExYo8a3oNY6az0F0N+6rFOhx//lMt6W5ughGIipa
         H351qs36OqKxR/SVc15FawJ8C1C2ubfKjumhbrNPVxu/q1ro0FQeh6CUjql0j65yECne
         M0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756251457; x=1756856257;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XjoQc+0HHdQoYN8CUyvxMw+PJ0TtJn9kjqaYpRARa/o=;
        b=hC+KAMxzfByS7Oxyd1alDaBodbfnqQL/dU2aFKyhXJu+iWgcswxQYG2VZK4s49stG1
         ntr+eT1ABEjJGPfP2Izr6YFG/SCDnd50bUvJgmn50aAyc0YUd5nzNzqfy7dE9VyUm2XH
         5L0J5MCWk5QOYKNqiNPN7zjJZ9WqlmPI2gyPMV61J9g7zw1mAgdzUaxOByg99B03+nkQ
         e4FFV5u6BEzO2UGJpD9C1awobBBMnq+sZhmamGk1COeRugI18ZuKdAba2RgxAqLqWbai
         8uxPf+QpdildNQqcqU+IONzRsHRK3+Ai67P0iF8IIvsi66SQWd1pbt8dLtc0tvs782O5
         34cA==
X-Gm-Message-State: AOJu0YyJmIdVJaWtnm5fgJ2CkBE4AQfj24rBAbARvLVxBnFepe8R2Pzg
	HuKCw3Lgc2vjEQxuuURHVRHZFP7JZnxIdnVNFf6K3pnnuLbg4JVF5bgxLODyZBa5kP6vrMwp2i4
	/80IHfg==
X-Google-Smtp-Source: AGHT+IHFcFV7G2qwiXBjY3JxXFXbDIce6OGwarZ3EB+aa4VM9or737yUcUD+ZQ6zcGFGrv2dxeZBVUYrzgs=
X-Received: from plbke15.prod.google.com ([2002:a17:903:340f:b0:234:c2e4:1df6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef4f:b0:246:571:4b22
 with SMTP id d9443c01a7336-2462ef49f48mr233105655ad.59.1756251456668; Tue, 26
 Aug 2025 16:37:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 16:37:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250826233734.4011090-1-seanjc@google.com>
Subject: [PATCH] KVM: SEV: Reject non-positive effective lengths during LAUNCH_UPDATE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

Check for an invalid length during LAUNCH_UPDATE at the start of
snp_launch_update() instead of subtly relying on kvm_gmem_populate() to
detect the bad state.  Code that directly handles userspace input
absolutely should sanitize those inputs; failure to do so is asking for
bugs where KVM consumes an invalid "npages".

Keep the check in gmem, but wrap it in a WARN to flag any bad usage by
the caller.

Note, this is technically an ABI change as KVM would previously allow a
length of '0'.  But allowing a length of '0' is nonsensical and creates
pointless conundrums in KVM.  E.g. an empty range is arguably neither
private nor shared, but LAUNCH_UPDATE will fail if the starting gpa can't
be made private.  In practice, no known or well-behaved VMM passes a
length of '0'.

Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Compile tested only.  Came across this when trying to figure out how to
handle the batching of gmem post-populate calls.

 arch/x86/kvm/svm/sev.c | 2 ++
 virt/kvm/guest_memfd.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f4381878a9e5..746a57bf1f71 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2360,6 +2360,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	npages = params.len / PAGE_SIZE;
+	if (npages <= 0)
+		return -EINVAL;
 
 	/*
 	 * For each GFN that's being prepared as part of the initial guest
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7d85cc33c0bb..79552467add5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -639,7 +639,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	long i;
 
 	lockdep_assert_held(&kvm->slots_lock);
-	if (npages < 0)
+
+	if (WARN_ON_ONCE(npages <= 0))
 		return -EINVAL;
 
 	slot = gfn_to_memslot(kvm, start_gfn);

base-commit: ecbcc2461839e848970468b44db32282e5059925
-- 
2.51.0.268.g9569e192d0-goog


