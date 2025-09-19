Return-Path: <kvm+bounces-58198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB7FB8B4F4
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD1147E2F86
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F632D1F68;
	Fri, 19 Sep 2025 21:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AGCPiX6W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E661D25A2DE
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758316614; cv=none; b=jtL4I6/giPXPByO696Ii7jbplyLz0JwddZH42RuJweGqxm9JYfW8KQoAuY1dVR5dNT0caRbDsL3FFGCtfOEja8zv1FJTl3qyDbV+JjvHFhFCCouuHHn62mzIraCh4kUVzWroei3wobP7ZDGHUKxkUZhlOvBWQdaQtgy+bTx7PzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758316614; c=relaxed/simple;
	bh=GvbOndAFg22idUQxnB2Zau3WELPEHRJzinOa5U16QAc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sQMbHIfcO1zTOBONX0wutcSlZtcFQ69lspUa/JXXURMOlD+mirHo9LWnTiqYjTRTeDbESQSJiHUGtTm3iJ7uepqqSbekKP/JYs+GintI4CddpUvS3fus9HOlz/kHjrlzA0cj4hrLiFxyRY2xx77CPpnrQWn3Hnhlgm2UEnD5BWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AGCPiX6W; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2698b5fbe5bso26532325ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758316612; x=1758921412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3vSRPYz/l41886yoT08n72HBlws2OkwcwCFkvly7l+s=;
        b=AGCPiX6Wr0knH5ZAUxGkx0T/W1SOpOKb+QRR28WlPyn3CC8lLjmpvRuWE41wDmTXHA
         w7uo86anib+xZyhM/lyms5cZR55BbGZgihJpEI9oikR/y4vg36R4D2VhX/nl+LdlZftj
         sW+8BmnilusXriEXVlkb7Rdvl4Nvm6bNABq4sBorxI/OPXpmSMXeLQpY/oa+aWiKVSmz
         C99o5wJE+9duZndzoiIc/dEV80SeZVTkiYVIU9/tMD8MiOJIXrdwdgfG+BWwAhUmzibj
         2xIWRIz4CS8auSwke0jujvUUdbG1jHbDv3KIjgpD/S4mqhvV2snkwfGQJNXjKWpcSsR/
         10vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758316612; x=1758921412;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vSRPYz/l41886yoT08n72HBlws2OkwcwCFkvly7l+s=;
        b=wpu6cgUgLHHVWYF+My+JJyryRcxV6EXpkq8x0RODrBmya18W+HOxWkXxt5tRo/ylIq
         xIEg05iTdiWyXz08+043vsEC28bb6EWNnnyRHisQKfpnANZGBQkrsq3NyGsNnNRxykUy
         8TC+AgXLDhEBJUCToa/RuPDCo5Nm1qF45eXg3mQSWsFqIOD54NE8GNkNDonmN7cHCezl
         LUveWwHn6GKgGHU+8Re0y8Fh/+r7aJ2OghjZR+Uw3GzCQFDCWVROmMxZ4I/i5t9VQQPo
         dJ5fmNLsbezIx5DOYIIoe8FrzP1um2iHDWzfAxKFefkr9ktP6c6t8VSfrnjCb8M2aaNr
         2AkQ==
X-Gm-Message-State: AOJu0YwJ+qpknOFPHTxYJVDo4fiC79L0wR3wbRK/6SrC/6B6xwuZsRsl
	DZZtpe/HBIlMz4B7cUwvhgUwaL1x36mTK+1y+1ExZ2ynnw+3NkdLWCsPgxfx7zgY504i3dqQ7m6
	+42O/3Q==
X-Google-Smtp-Source: AGHT+IHncTnxtJ6hIK4AtyqUpuFZv8d+5SgVbkA6ZdQhnTI1SZWs27kxNaMHVLrVmScQSISG1aDh/1VNSAk=
X-Received: from pjbsl14.prod.google.com ([2002:a17:90b:2e0e:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d54c:b0:269:87a3:43b8
 with SMTP id d9443c01a7336-269ba40ac1emr57477075ad.4.1758316612303; Fri, 19
 Sep 2025 14:16:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:16:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919211649.1575654-1-seanjc@google.com>
Subject: [PATCH v2] KVM: SEV: Reject non-positive effective lengths during LAUNCH_UPDATE
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

Note #2, the PAGE_ALIGNED(params.len) check ensures that lengths between
1 and 4095 (inclusive) are also rejected, i.e. that KVM won't end up with
npages=0 when doing "npages = params.len / PAGE_SIZE".

Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Check params.len right away. [Tom]

v1: https://lore.kernel.org/all/20250826233734.4011090-1-seanjc@google.com

 arch/x86/kvm/svm/sev.c | 2 +-
 virt/kvm/guest_memfd.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cce48fff2e6c..31b3e128e521 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2370,7 +2370,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
 		 params.gfn_start, params.len, params.type, params.flags);
 
-	if (!PAGE_ALIGNED(params.len) || params.flags ||
+	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
 	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
 	     params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
 	     params.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 08a6bc7d25b6..1d323ca178cb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -716,7 +716,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	long i;
 
 	lockdep_assert_held(&kvm->slots_lock);
-	if (npages < 0)
+
+	if (WARN_ON_ONCE(npages <= 0))
 		return -EINVAL;
 
 	slot = gfn_to_memslot(kvm, start_gfn);

base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.470.ga7dc726c21-goog


