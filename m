Return-Path: <kvm+bounces-55807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7502DB375D3
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 923AD1B677B1
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A5E1D618A;
	Wed, 27 Aug 2025 00:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nWiW2FVT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD4D84A2B
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253133; cv=none; b=YBIRg1NPQRBuoTfGAGrRkVUGrslYznZvoyqY9+SkjQk5+27T/xIBpW+czSyOQpdVvaJNtyrNMcwEvVv1n8RfJ2wu5JnHh3dZojdauaAHMwc6MX5V+dOGu4+P63AmFKMq764lGHxc6XuIb6pDMGpFP7GFJ2Xi/RSuKpAXMGCV4SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253133; c=relaxed/simple;
	bh=FGy4L3v0KtbV9YN3vnt/aQL+JAZTHJYLOBd60TOt0zU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PR2qOrWYFUa3QkLeEvrThFfFrihN3ml1zgjt22C57zec5Y9M3TUgvclIr43HpV2oHEgV9Lort9dzaDM61QdSjA4ItgqLGe8uPuAtuAAHnAJhB8FIGnUHrfmmEctRCAhxF0gpSELRmZqfR3giBWR+n0iMaRQoTQJsgVQ05d62JL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nWiW2FVT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3259ff53c31so3014303a91.2
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253131; x=1756857931; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vjPTpt85fE4g1CG7pF94hdcCHChaMHe3lO1UHe6fhuU=;
        b=nWiW2FVTO3R723r7l2OkGz3fLhtbIDIyDsazX720GXQ84GVhEjyO4rGnPkXcmAED8J
         M4xyw3rQ7J4MydL8MrrzMEZLg/PDEPyXI9QxRe/EdLz5X1PCzcSreoQmF6hZ9NLeuuCp
         m1S8WE9PppN71uTVHoca7Wbxb4HDMkBWib2pc5Yyytb/jSqoqs1+Bv9C2YSeOEhJAqLU
         4m5zbnytyCC3Kj4bMxDXJKVZHObVBzerfC6eBMny4x0RnospcOSjDAXubNxmzMOSo4A4
         aLXM4XCVJRjg0iy2IMXOEGO7fonEtOjE8czXdR28FgJe8pAQKHTSP61UGUd9lf+gTt2w
         9Gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253131; x=1756857931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vjPTpt85fE4g1CG7pF94hdcCHChaMHe3lO1UHe6fhuU=;
        b=DMh/yw6bN4TI7OZbA2qqs0wLeyWmAmqsoL+E6vpSvJKu2fIWTF90FK5ImzOWa7fQU4
         czagBu+za5L5RMk7PPrEj4lilHPVZfcLulOsNuHd9s/HaZdlyJIC86GyLawfEXM8UlDK
         RvH2BGiiPgsDLSNK3A4Yvsu4LSHIXN9ym4j4LOOKT+YQIeC2hcFfQ+p/M6K+LSpYMZwN
         nvdhq6m65q1BX9AsyP47JG5O0XW52DhyMlt1zqdxrs46q6MBJ6n0k0z0RR8Veah8cXuk
         bP/kwcEQ2Wz8HQR07rmX4lDQ637S39UZnN10H5se83xL66pgxDh9IcD8X6UrASGy+Mto
         853w==
X-Gm-Message-State: AOJu0YwW3XHxiOnnTkQbi4EMTWTxGzTXBw8iqfr/8im1Jt5kNa3gNdR/
	DhCkUnYLGRXzwILNz0YZY4eiTJWgp+ij+41vx74msfu2U+12Bg2zaaQM7wxIZ4R7tqqUYdDq3l8
	VRBTH/w==
X-Google-Smtp-Source: AGHT+IGLkMUWbX4PKUWtDmrQW/m5uF2FUQJTdZQVW6EUfFTc+RCCET4ypzRI00ALI5rO63jIy/dfa6gX95M=
X-Received: from pjbse15.prod.google.com ([2002:a17:90b:518f:b0:325:9cb3:419e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d2:b0:325:ce00:fcb4
 with SMTP id 98e67ed59e1d1-325ce00fe37mr7595526a91.31.1756253131527; Tue, 26
 Aug 2025 17:05:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:14 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-5-seanjc@google.com>
Subject: [RFC PATCH 04/12] KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_prefault_page()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_tdp_map_page() to kvm_tdp_prefault_page() now that it's used
only by kvm_arch_vcpu_pre_fault_memory().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f532beed9029..cb08785ce29b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4900,8 +4900,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
-			    u8 *level)
+static int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+				 u64 error_code, u8 *level)
 {
 	int r;
 
@@ -4978,7 +4978,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	 * Shadow paging uses GVA for kvm page fault, so restrict to
 	 * two-dimensional paging.
 	 */
-	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
+	r = kvm_tdp_prefault_page(vcpu, range->gpa | direct_bits, error_code, &level);
 	if (r < 0)
 		return r;
 
-- 
2.51.0.268.g9569e192d0-goog


