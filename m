Return-Path: <kvm+bounces-55804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A6BB375CD
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A5ED7AF8E9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A0342A9D;
	Wed, 27 Aug 2025 00:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGyojEsT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597A524F
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253128; cv=none; b=aM8Bc6nYXXfPtFkj2VpDhVQGXdftdfvW5rAdSrEepaHWYecY+/nKKeLD9Qoup6bwOF7U9YGaVoP00fTXn/i+ubr1XQBCcgUpTIVAfkPE4afJLQhaiQKMoKjL1DDqvGVIrcp2dwhOJo3DTjzAfLLZ9zoNzoGfUJuqAfpB+Riveck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253128; c=relaxed/simple;
	bh=BYrpGObWdcKQBFBTHXHA+hrFfJH7FFHHmouCdbQhKuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z98TWtn8LW2Qs/O6helb53B40hoWTXrHtemuliVPsRlyGMu+DL8UkuJwgAygDWPyeJGNkgK7HaNMvSCRB81rf3FIFeXazdYl8izR82knyM97BXG4DIEUZd0CQb6uG5U/9Vo44ndPjEjz06vjU/HXC3RqaxSiBlSdOo0DA6SIb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGyojEsT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-324e4c3af5fso6258188a91.3
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253126; x=1756857926; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=s1TG4lPviW9zkkUbrVAE+VToTbwmtvD/jmWrMLbsJcE=;
        b=jGyojEsT4ct+XdN2AQet9P+2+mGXhZRRCRdydxtZwyXB60FKS+0hlk4KUtiiA62Y41
         814sSBNWgLob50pQ4IfEfo/OCQy+UCcTZnIXNwA895PUTMbKECTIEJ6flQXvXok1OLCI
         RioIjZ6vGtEv32GbiZ8ZIwzwFePa5rhcGFLFfvF/pybMpSkEjVaZxs/JYg7UiEyJDN5F
         zs2Ed/2GoNnV2VkgvM5iooKOcOGNwKaIEDp4wD1KCMVx0yXgHSqmX/DQ70V05oVHV59M
         n4iz0a2n0glh0BU34QNeRja9f5Phy7kCDganOGrRWJBpWVPBXWwsu7nqF81YMgfkdwcr
         uNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253126; x=1756857926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1TG4lPviW9zkkUbrVAE+VToTbwmtvD/jmWrMLbsJcE=;
        b=SZJYx+PT45gcYwc4F/EY5RP7P1S57bJOE8QMv3MGGlhIfjbIL0RZsNeXTVF7hCCQtL
         8Hpw7YM8CxNNQRiFP86rXgmD5fdDkIzVi+HziXlFA/wMFJofOMRIzDDxOCEGuNJF6cUN
         iyTnnRj6ntcu/N7tVWZumnX98k/2TYxC0wvq6/Slfgf7dzmJ6vuARDeE7XQMmrnIYMDn
         G+2X7IVVf5cdqlRJsjQTUV4M3juVQs7qYAtrzguOS1N1/N5aGrSUxalaOu0G14v9samy
         lZYlXeqIpbcAMGf5iJKoQh8A1hKIHByGvHeGUpMZptR8JWeMcIrQ1MZjP2CpK6uO+BP+
         /veg==
X-Gm-Message-State: AOJu0YxR5s+LrH3I0aaVl1WclSErEMXdYJbPQmjju7GqkgZnpDKO2hZL
	5YrJmsg6wZ76B6Blce2hulxCg2SDmXRijSjcilvOKZz7t2eVduCN8DmLwMV3GFeh+tyqjZWf9Wl
	OcCpVGg==
X-Google-Smtp-Source: AGHT+IHMYfnsineRSbdna+fy5FAeFnMFw6K03y0LLQ596CpMf66ldbok0nFnHZEXgnhOL9BnTiJGl1S20gs=
X-Received: from pjae9.prod.google.com ([2002:a17:90a:1189:b0:327:5941:b2fd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c85:b0:323:28ac:4594
 with SMTP id 98e67ed59e1d1-32515e2e438mr18787121a91.5.1756253125797; Tue, 26
 Aug 2025 17:05:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:11 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-2-seanjc@google.com>
Subject: [RFC PATCH 01/12] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop TDX's sanity check that an S-EPT mapping isn't zapped between creating
said mapping and doing TDH.MEM.PAGE.ADD, as the check is simultaneously
superfluous and incomplete.  Per commit 2608f1057601 ("KVM: x86/tdp_mmu:
Add a helper function to walk down the TDP MMU"), the justification for
introducing kvm_tdp_mmu_gpa_is_mapped() was to check that the target gfn
was pre-populated, with a link that points to this snippet:

 : > One small question:
 : >
 : > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
 : > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
 : > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
 : > return error when it finds the region hasn't been pre-populated?
 :
 : Return an error.  I don't love the idea of bleeding so many TDX details into
 : userspace, but I'm pretty sure that ship sailed a long, long time ago.

But that justification makes little sense for the final code, as simply
doing TDH.MEM.PAGE.ADD without a paranoid sanity check will return an error
if the S-EPT mapping is invalid (as evidenced by the code being guarded
with CONFIG_KVM_PROVE_MMU=y).

The sanity check is also incomplete in the sense that mmu_lock is dropped
between the check and TDH.MEM.PAGE.ADD, i.e. will only detect KVM bugs that
zap SPTEs in a very specific window.

Removing the sanity check will allow removing kvm_tdp_mmu_gpa_is_mapped(),
which has no business being exposed to vendor code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..a6155f76cc6a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3175,20 +3175,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * The private mem cannot be zapped after kvm_tdp_map_page()
-	 * because all paths are covered by slots_lock and the
-	 * filemap invalidate lock.  Check that they are indeed enough.
-	 */
-	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
-		scoped_guard(read_lock, &kvm->mmu_lock) {
-			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
-	}
-
 	ret = 0;
 	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
 			       src_page, &entry, &level_state);
-- 
2.51.0.268.g9569e192d0-goog


