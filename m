Return-Path: <kvm+bounces-56215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A71BB3AEDB
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D67A2582FB1
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB28221F15;
	Fri, 29 Aug 2025 00:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iWNrXZTC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E2F217659
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426001; cv=none; b=EaJztRNIbNL3WQOmCdoHEkC1EeiRoh/HiQthynXs3Jp/0q7M5vAyDmoZG4jKtyJvblBqnlq+VuiskhUDcEVZx0HGHAlh+7dacoh2ulovQ/r1AKCAq7cqVrhn3i4djIVCbPZkQeQNlkKyL1Bkai/0loPikZNBOYOvsaIFEUua4tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426001; c=relaxed/simple;
	bh=gyZpzdfigGs09+ImBbJAsRRHU5xktCFn0Yw4iaqicyc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tAs+N9qEv222TzpSEVQqB3hjU2CXDNPgiHJ0mAor4Fpqblycse5UlpYueznI1gWioju3tbiLK7SBVV7GSA9tbiT6d25zV9p9q5s1GcGelCL4IA/SAQ3PN3UDu6B76mfpAYnvXM9E5R1VGuo67uYWQIISeXgWAGBe9VL4oo2ITCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iWNrXZTC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3278bb34a68so1474154a91.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756425999; x=1757030799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwIMlaifmPTtVhzroBYxRLA8wwFTYLN4Sjt92uj7DWY=;
        b=iWNrXZTC+uVaaFU5eSNGiMo0IzTNPcS0L0iY8hZaoiECryVm2Fb1XWas14NZKUsBEz
         vcmHqQJ3MegEnZaP318JkRdsKWGoSLVIxvu7DJaEpTirImAZXgdX+RRpQJ+QHgFcCdwb
         7Xr/BUnezzapGgp/cwDCZ+oJ8ZFGffg+bKRh0UH4Y/whrNgi5H2q7NlI1LHNmsZApVhl
         VO4VbsnycnuqMgJ3TrgGkCn5vit9DAqQC4ImI5BoVxHbfg6guWV3bK9592HtOdnXz1YA
         GSjP3IT8g4vsbvn5asAFPvYJqbfWbDxM+aJJDZqo1XISUKLl6QXcUBb8xaY5JNqC9t11
         jBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425999; x=1757030799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZwIMlaifmPTtVhzroBYxRLA8wwFTYLN4Sjt92uj7DWY=;
        b=sL2Sq+4zicrkE8FPkaKNWx3fD9kmPczuiCIjaKS85J05feeEvZX43RAuqXTd2beWlv
         ofwIsuCdFX4O0peGASSb71d82ce5/d/aQmcmwnkdyYOR145CVYBtgTfKgLmScrcDWLu5
         TA2mG0KAZj6qS2766TrEIvttVDQrtROX57lvdp41jDxZc45K9vOCJEx7PQ4XMA5jMxE0
         cr0kPhne1Z669M2iZc0RjUYUN4DsHRmJA+iSxUcN4rXySLBosZj2aaAW7WsAwBvIbvFp
         EFOOu1ihMiJ7pEscgRXVGi4Ee+1HvkiQmwGqSXN8kST/DnNCE5dKd3D55CIyvUvPiMzM
         stzg==
X-Gm-Message-State: AOJu0Yxn3gF5x+FYDYPfTLwvX9WAy9LdfLCdEY1jRkaNZ07cljTRCszi
	6Lc1Sq7Rj+5MUz0CWebv2R7ee7MH+nbONfR4b7l3adOPMJMLCZIOyVNDbVf4g26Gsvgq/ha7Ejf
	qOruJug==
X-Google-Smtp-Source: AGHT+IF5M1lm57K1T4cESxSZmN/2EWRqfoLHHHsMaumxyGGp3Yd/18q0BTU+oBYQUA0CJrPoD1MkMyVS590=
X-Received: from pjbcz5.prod.google.com ([2002:a17:90a:d445:b0:327:50fa:eff9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c06:b0:327:e59d:2cc2
 with SMTP id 98e67ed59e1d1-327e59d2f16mr639721a91.10.1756425998989; Thu, 28
 Aug 2025 17:06:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:10 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-11-seanjc@google.com>
Subject: [RFC PATCH v2 10/18] KVM: TDX: Use atomic64_dec_return() instead of a
 poor equivalent
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Use atomic64_dec_return() when decrementing the number of "pre-mapped"
S-EPT pages to ensure that the count can't go negative without KVM
noticing.  In theory, checking for '0' and then decrementing in a separate
operation could miss a 0=>-1 transition.  In practice, such a condition is
impossible because nr_premapped is protected by slots_lock, i.e. doesn't
actually need to be an atomic (that wart will be addressed shortly).

Don't bother trying to keep the count non-negative, as the KVM_BUG_ON()
ensures the VM is dead, i.e. there's no point in trying to limp along.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cafd618ca43c..fe0815d542e3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1725,10 +1725,9 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
-		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
 			return -EIO;
 
-		atomic64_dec(&kvm_tdx->nr_premapped);
 		return 0;
 	}
 
@@ -3151,8 +3150,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
-	if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
-		atomic64_dec(&kvm_tdx->nr_premapped);
+	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
 
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-- 
2.51.0.318.gd7df087d1a-goog


