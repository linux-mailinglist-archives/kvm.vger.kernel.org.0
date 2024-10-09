Return-Path: <kvm+bounces-28349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7712999758B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93D9AB21706
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D461E1C09;
	Wed,  9 Oct 2024 19:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lJd24jf2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7169417BB28
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501831; cv=none; b=EBo2LIkzKVD1+kRPM3+PBpsKyqwx3Kn/5cvCazW1VtEebwNOlc/nxMfFVcoeC8WlROgWfesNLkMQtqeopkL2uMKL73nZno9MOeU6RdDx8H11hsIbc3QH01agck9wOLfVo08+Cx6SfNQiYC196qT5Me0iidNAwkfRwPr1+kGLpl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501831; c=relaxed/simple;
	bh=imXtokP7LX0TTfuTLrfZD8ejaZvPA9bFhC2i8zqCO/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HJmSsYdfTWTjgM2Eys67pMSkpEaTm9EYp2/WBDfvoJkxdoXab6jGwTLjevMuNT4nsdNM8H7UNRew4bUECsbA0ggnHUy18oYk3uMLGK/pOsgywFjRMwowcnNfHq1DLYofIOzdoYZiPKpxT0t3FAKfJucrF2JkSN0Ixk9LinSbHJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lJd24jf2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e281e07f14so242995a91.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 12:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728501830; x=1729106630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SoLsPzJZiQfoNHdfok3jrkhtn52skZ1suvpgub7z+jA=;
        b=lJd24jf24INjaMVP26V0yM4ib1gX0McrV4PDOA4548PlfmaOGtBlgQzKBvl0zHo5pZ
         rgVzWjqC/MbxbSvmD9FBQeSieJE+rjuFfsd6021F/Zgn2aCcMU0Fj3ygrTgb3l2/r9qZ
         Cb+7TZlvvdX1CTINX9J7nzWl73CVj6/Xi+d2MQJ325WrTfY/k7cpqoAOKbVgIxiYEIRy
         0EpYm3I8wOmAm5WKIfz0f/pxQNuRd+jxTUae+M8V3ofaiU5JSJz79bqR+JY4b7VWAeFK
         qRVxnFDQQsitFDkzr8jn3MeiMPS3oDgNB4cfyGrEwbOcV22U++GTrxJRu2lZOck6p/sI
         DWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728501830; x=1729106630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SoLsPzJZiQfoNHdfok3jrkhtn52skZ1suvpgub7z+jA=;
        b=mPHhG//s9rGkvTsu/hZuMgq5nWPiRNRzXgWic2tRC38k+t9rk4HtgAd7+beM5CIKDr
         aHSGH+cAZA+N/cIb1Oi9/r8a8XHH9nu2eaG5PsYdz/4lCXo1QR7KsrIt2MhKOUkLRe7U
         czsOFL+trpB9bXEzEquM8P6uSN+lTV0145A3Kae98Kz7brSqKn2leOU0W3LbmIxpYSXs
         poEHMvuoMveVdsgUeLjasH7zSQIgbH6dg/vuu5GyRV1XDgpFohe/GOR3vUQwvM9mYlTq
         iZph4OicOxSeFja/aqWIryJt/o8mNlWVT0RuHU1eckRPYes443UOy5CDZ91Cxnh0yCiH
         Vlng==
X-Gm-Message-State: AOJu0Yyrw+cnY0OalTmuNonWedcF3k8kXcc1P0z9RCmzf191ggkXrZyR
	TT3ncouNOHq41QClZx92Z7MDMj7RcD6b1sNIdDhM8QA6Ww66h/bjO3KwAQbFHZ3G4vYz+9pZZGy
	tig==
X-Google-Smtp-Source: AGHT+IGLBnTXpLPgqKd8QtJogAC2lHie+sZQ2T4w8hdKUFlyw02+Np52KEI5BR6vwpF7PUUtSnLjOGP9Mac=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1b42:b0:2e0:b741:cdbc with SMTP id
 98e67ed59e1d1-2e2a250791emr3715a91.4.1728501829578; Wed, 09 Oct 2024 12:23:49
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 12:23:43 -0700
In-Reply-To: <20241009192345.1148353-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009192345.1148353-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009192345.1148353-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86/mmu: Zap only SPs that shadow gPTEs when
 deleting memslot
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

When performing a targeted zap on memslot removal, zap only MMU pages that
shadow guest PTEs, as zapping all SPs that "match" the gfn is inexact and
unnecessary.  Furthermore, for_each_gfn_valid_sp() arguably shouldn't
exist, because it doesn't do what most people would it expect it to do.
The "round gfn for level" adjustment that is done for direct SPs (no gPTE)
means that the exact gfn comparison will not get a match, even when a SP
does "cover" a gfn, or was even created specifically for a gfn.

For memslot deletion specifically, KVM's behavior will vary significantly
based on the size and alignment of a memslot, and in weird ways.  E.g. for
a 4KiB memslot, KVM will zap more SPs if the slot is 1GiB aligned than if
it's only 4KiB aligned.  And as described below, zapping SPs in the
aligned case overzaps for direct MMUs, as odds are good the upper-level
SPs are serving other memslots.

To iterate over all potentially-relevant gfns, KVM would need to make a
pass over the hash table for each level, with the gfn used for lookup
rounded for said level.  And then check that the SP is of the correct
level, too, e.g. to avoid over-zapping.

But even then, KVM would massively overzap, as processing every level is
all but guaranteed to zap SPs that serve other memslots, especially if the
memslot being removed is relatively small.  KVM could mitigate that issue
by processing only levels that can be possible guest huge pages, i.e. are
less likely to be re-used for other memslot, but while somewhat logical,
that's quite arbitrary and would be a bit of a mess to implement.

So, zap only SPs with gPTEs, as the resulting behavior is easy to describe,
is predictable, and is explicitly minimal, i.e. KVM only zaps SPs that
absolutely must be zapped.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a9a23e058555..09494d01c38e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1884,14 +1884,10 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 		if (is_obsolete_sp((_kvm), (_sp))) {			\
 		} else
 
-#define for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
+#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
 	for_each_valid_sp(_kvm, _sp,					\
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
-		if ((_sp)->gfn != (_gfn)) {} else
-
-#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
-	for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
-		if (!sp_has_gptes(_sp)) {} else
+		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
 
 static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
@@ -7063,15 +7059,15 @@ static void kvm_mmu_zap_memslot_pages_and_flush(struct kvm *kvm,
 
 	/*
 	 * Since accounting information is stored in struct kvm_arch_memory_slot,
-	 * shadow pages deletion (e.g. unaccount_shadowed()) requires that all
-	 * gfns with a shadow page have a corresponding memslot.  Do so before
-	 * the memslot goes away.
+	 * all MMU pages that are shadowing guest PTEs must be zapped before the
+	 * memslot is deleted, as freeing such pages after the memslot is freed
+	 * will result in use-after-free, e.g. in unaccount_shadowed().
 	 */
 	for (i = 0; i < slot->npages; i++) {
 		struct kvm_mmu_page *sp;
 		gfn_t gfn = slot->base_gfn + i;
 
-		for_each_gfn_valid_sp(kvm, sp, gfn)
+		for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn)
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-- 
2.47.0.rc1.288.g06298d1525-goog


