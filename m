Return-Path: <kvm+bounces-10202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0403E86A6D1
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 353671C23538
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E8A33070;
	Wed, 28 Feb 2024 02:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rpsnoFLQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2548E2D05F
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088142; cv=none; b=abqzMO1p7WdPRx/kCy02I8tv1t/1ckT6+2cHGF26D/1T9L8Phjk/ZiJs/tefFcO5Ep7ACqG9fv8NnBBC42N7sOXgHo7t+cGP4z0/rkW+ohUx5ypWURgprSdyiOoAWpOV9DrmWJE/Bmoj9S+fZ7m4i9ke+FCgIxijWmn5A1QRTnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088142; c=relaxed/simple;
	bh=szLQWH4Y5Bzo6Uy7reBTywxc6dUFXHryHkO47zK9DXo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IYM40lHKoUp8/tJJ3Fy5QHyQACE7Tlc231xGveXCKNW09ylZAD1mw+reCeWvLkV1zNhwmJxj6AdNo4lNw0j2ipInIo6cxEbBOEUHFfT+wmAd1uIo8WhGfAXFOkCo4+iF2BGWH+4o2QbwfSpm+5pTalBmU9+bdtJn9GQjo9HvUV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rpsnoFLQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29a9f042643so1781543a91.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088140; x=1709692940; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fK/e/x3+Tf/3Rz4S7hZymU4b4heBfx/RABet1RXMTfk=;
        b=rpsnoFLQv8Hr66kEDU1R/DQUQ6CdvcALLXvKoaMxmlhmQQG0O67AeLnt9n4kiGI3r+
         PWR7gPyio7d5kk9PHvrwe7XFTqnGtSBvBBUha/E58qdt+bIRrE6ajvnakAJv8ygpVNm0
         ZVB22rxYNL2l03f1fOgK3fKGP2AMjMOFUenCCXtDI1rvr148vHTjobq17YZnIdfdOrty
         Z7LqtuCCEzC2upLTszhOf9oi1MamnqctqOUGgibMm3WrrOxMYmtZtV/76so88kR7Fwl2
         KgJ8DDkgQakRo3CVqGSAEY/9qgpAiz6YRMPVu36M27+i2ImmG5uj2SU1X8ON65jaU2KD
         OIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088140; x=1709692940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fK/e/x3+Tf/3Rz4S7hZymU4b4heBfx/RABet1RXMTfk=;
        b=emlA+Ukp6CmvnUro8OdYLGtdhL1h9dWSqlI27TVMq10INjMc9oNj4tWuts/lBT4b+R
         grhIuQbw5BicAtfH+k+nWpjg9PxVZOrqEJLVBn8IfNkubpJCDs7DnAZOG2HWo75PA9Ls
         VOOTCleyXlN9a/P6zNEzPgbO2ZvMJvQ85e8XdBy7oDpQ3E36orO7c+5fESyomUT0cgZN
         SZGhCVhTT6rSbRONGZwAIeDAKxVnDYsYij/y39bTanMwwTX1THUskEmRRw/gecyhHU1q
         z/BSfOYHtico9zmxDOLiY7Fmj+a8sdwVNyNeEtGdFjAIrcdMg/xlABP71cyubnM+K03v
         3JwA==
X-Gm-Message-State: AOJu0Yxa1D/Hc6ZGn41hnDTuHzejmEuh5YFNqTZkeS3REjNdxgf2FYwr
	vmUw8MHuVQBr5KUtZkqVqdmiS3+dlS0RrBUvIpGQagcCRKrnKpO1BuXVPIE5I/5Tjl87UgjYfm/
	5Lg==
X-Google-Smtp-Source: AGHT+IFQ0g9E+Mk5m1PF8jqDNWlJr3OOxNFUEzGXFuClugZHZeqtSpftN+Bu/TNy5X1nKDvg9GP+3UI48k4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2d0b:b0:299:40c3:338f with SMTP id
 sy11-20020a17090b2d0b00b0029940c3338fmr38855pjb.1.1709088140382; Tue, 27 Feb
 2024 18:42:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:47 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-17-seanjc@google.com>
Subject: [PATCH 16/16] KVM: x86/mmu: Sanity check that __kvm_faultin_pfn()
 doesn't create noslot pfns
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if __kvm_faultin_pfn() generates a "no slot" pfn, and gracefully
handle the unexpected behavior instead of continuing on with dangerous
state, e.g. tdp_mmu_map_handle_target_level() _only_ checks fault->slot,
and so could install a bogus PFN into the guest.

The existing code is functionally ok, because kvm_faultin_pfn() pre-checks
all of the cases that result in KVM_PFN_NOSLOT, but it is unnecessarily
unsafe as it relies on __gfn_to_pfn_memslot() getting the _exact_ same
memslot, i.e. not a re-retrieved pointer with KVM_MEMSLOT_INVALID set.
And checking only fault->slot would fall apart if KVM ever added a flag or
condition that forced emulation, similar to how KVM handles writes to
read-only memslots.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 43f24a74571a..cedacb1b89c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4468,7 +4468,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(vcpu, fault);
 
-	if (WARN_ON_ONCE(!fault->slot))
+	if (WARN_ON_ONCE(!fault->slot || is_noslot_pfn(fault->pfn)))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
 	/*
-- 
2.44.0.278.ge034bb2e1d-goog


