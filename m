Return-Path: <kvm+bounces-28350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F23B99758E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BC2AB20F5E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E891E22FF;
	Wed,  9 Oct 2024 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N92p/F66"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAD81E1A2D
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 19:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501833; cv=none; b=VbsEYlIXH6XVqcv8QxSLnhf/9qXwAl0TFDQEhgKflexly+49ajMabrEtoEH48P9cyMx1/LJmOh00Jp6yRBuV4JJiEpw2XUQRi4eVt3AilzwPK5GBtyEwUpmYOWy3A53R3cMFuSG6KIsM+vmd1TVWOOnWTpFor0qdB48/lxJHl3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501833; c=relaxed/simple;
	bh=ck6e1+clLHvY37y71iwCVIslPuIUb7JPkmFmrD3a1sQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nbc/2lak4L+mbSeH2cs+JmQDux4XHbhpgITNTBbKSojjIuU27jEz8Vl9bedGCzpkx3Dl/cyj4gujkl4TNsUAiaSMu0nTaYADEkucihvn96j/puzyQCPmY0b4YPZM2njpvvgbHg0RZBWzu/maxYZ2gs37XQvy8RblaMx19jQTtH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N92p/F66; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7b696999c65so64298a12.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 12:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728501832; x=1729106632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fx7eMx6VVUuvVYcfbaCKh7/MSwGopnW89lun6HOpi5I=;
        b=N92p/F66PYk+rn224Up55qmHhy8Lw+Dig5dtGTJkeclaHSciaQ/gWGfqbu9lxqu8VA
         MSeaSZldHDfP5kG1DdiyQ+bPpYfb81IM7AGFUKwBUBhg+z2QVVnl/ayw94KhkGd8QTbY
         +sIO7sVeGhKGmIp/+NmIAYAHX9CzOHthqPFS261JZcfAGAWdENLWhwiDhSO0BEefbh+6
         8e64i7WvtmJ5iPxtM+OLHCUrIQU0EmYRMAKamq+H+IICO8o4sqvfib/PtXyfZ7q0dmnj
         mWhPbfXpvKJRv3DWmMvOiwjHsKYEs7/79OEeioqrMcvH7GPKk3m73faiut9DgtMMCdT2
         lZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728501832; x=1729106632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fx7eMx6VVUuvVYcfbaCKh7/MSwGopnW89lun6HOpi5I=;
        b=c6NQ2y1tcZErM15jQocFjsTBVgAqbj0VGmLXGjIIfv5CJKUCGhxMlyEtmnl6Oeyqon
         gD0gaoZ9q1O+B6iA6C6lJXrFhYRqL6P7TWI6CZWO+eyO/M8+8wOx5eVj6dIEvHssZvWV
         7Am6A/nr3lD5FeUitrpl+Zf/XmDbFTZMbdS8gBWp4FnGC84gASNGE9JCbf6mx17bNWIj
         xNWB4POPxu9QBZYFXljSyP9cdKkCQm8A0CFMbZp1QHzql+EeQqLglTl5D2Kjmj1CCJHB
         8w/WP05beav1u6m7NayDYUoPZA4kVR+xyka2Sq3U39WFOZqbTOdhhmcBik/c57uzOmbz
         ymdQ==
X-Gm-Message-State: AOJu0YzPMZTTvvGh6ApQa3BnaBTO1MCRVXkp7/x3Ty0WrPZX3yhXhp8b
	AHc2Njl/y6z+b6KGuCExPa4mp27Rn0UEnzy8Mh8eldNXVeHMtACaQzNeovan2T3bBI4OBt9ruRK
	vyA==
X-Google-Smtp-Source: AGHT+IFK05VgrJ7xkHvKexCmcT/byWx7dnDBJFxQBRnl03+WtCAsj2ptxNvLmZkLLNUb1oQXRFWnt4p+I5g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:6247:0:b0:7d5:e48:4286 with SMTP id
 41be03b00d2f7-7ea320e1a64mr3014a12.7.1728501831481; Wed, 09 Oct 2024 12:23:51
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 12:23:44 -0700
In-Reply-To: <20241009192345.1148353-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009192345.1148353-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009192345.1148353-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86/mmu: Add lockdep assert to enforce safe usage of kvm_unmap_gfn_range()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a lockdep assertion in kvm_unmap_gfn_range() to ensure that either
mmu_invalidate_in_progress is elevated, or that the range is being zapped
due to memslot removal (loosely detected by slots_lock being held).
Zapping SPTEs without mmu_invalidate_{in_progress,seq} protection is unsafe
as KVM's page fault path snapshots state before acquiring mmu_lock, and
thus can create SPTEs with stale information if vCPUs aren't forced to
retry faults (due to seeing an in-progress or past MMU invalidation).

Memslot removal is a special case, as the memslot is retrieved outside of
mmu_invalidate_seq, i.e. doesn't use the "standard" protections, and
instead relies on SRCU synchronization to ensure any in-flight page faults
are fully resolved before zapping SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09494d01c38e..c6716fd3666f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1556,6 +1556,16 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
 
+	/*
+	 * To prevent races with vCPUs faulting in a gfn using stale data,
+	 * zapping a gfn range must be protected by mmu_invalidate_in_progress
+	 * (and mmu_invalidate_seq).  The only exception is memslot deletion,
+	 * in which case SRCU synchronization ensures SPTEs a zapped after all
+	 * vCPUs have unlocked SRCU and are guaranteed to see the invalid slot.
+	 */
+	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
+			    lockdep_is_held(&kvm->slots_lock));
+
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
 						 range->start, range->end,
-- 
2.47.0.rc1.288.g06298d1525-goog


