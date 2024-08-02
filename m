Return-Path: <kvm+bounces-23138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4A9946477
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07D5EB21536
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB3D7C0B7;
	Fri,  2 Aug 2024 20:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AMkR73z/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F956440
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631147; cv=none; b=gE7U9fAOGgc9lSE8Qb239xx/uXsRfiLI1xOJgtNeC6MB3OmMqXaHe9eNioTVpm+gUE00Q4560Vmt2yU423W6UkydmKNvVwyb3R13dbbAk638K9L4EKUF6UY7447yHaNNjFhlevGAMfUiiMpdXJwUT96P7lCvinhELEqS8iFl0/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631147; c=relaxed/simple;
	bh=uEQJJy35Z3zwuI3RWRH09lvrxnJ9BdiLiESax8ufYG8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rgxlPLpMGuLRTPkmiKAq0CwkAfDn99cp0cklZDcR0kdfrrFd+Bksq6gfFHGzHMckBjrFxS2yZzjuqd0ps3mx2NLp2k6gMYralVwxURAJxTaJrH7vT1STcTQnxIPEJDgxcvEJf0jYssgUptYmwZij9tW59zVBGDrm8fKvuJqRT2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AMkR73z/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc4e03a885so74870565ad.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631145; x=1723235945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OaXT0AL8GbS9YXbDGbiDFqWt3txOFoZxKOINxRCY5SE=;
        b=AMkR73z/J+xfKTo4+2KJ10lIM8b8ESsXGC09sH6vuOKyBK+95ZuBVzIn87e6p1jZo/
         pZ897iyZDJRVpLCQJBxfEEUyFKKOgq/wZ8m2X3LycIo6fWKzR/IsO2Yiw2xBUDSQ+scA
         PqJgufQpAx5eEO/FkyUwOvnBXiFslWPyzia3njes6g1PAE3NDUYOcC7tDO0EFbhEg3Qo
         rs+zqu3qxxX1Y25o6T64Detj3ICs38Y/UGQiDttWY7otMoGEyOIMUVWGMzdDoHH7eczq
         DVoHgKEG9Mv+c4PcIrosz3VkidxfV2ERfEs4/001ZyUkV7gkW9XgPoHKYL2LfCieu2Zl
         W9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631145; x=1723235945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OaXT0AL8GbS9YXbDGbiDFqWt3txOFoZxKOINxRCY5SE=;
        b=MYyLCWgzZiZOtnMLVPN22HPFX9ptiNn3D2yYsVRBMzdPclmdFZkVhqKI+AD2mBN9oA
         vq1bbJSo9ZacKg/j5N9bhOnapGgyFoim7OzU6eE/Z0Nt/1dHksjD3KKlpSM0xTehqWMK
         EA7kFcmT+ikHfR+0RKMR7aVYZkm5SasSj8CXSeBPvl6+uhU9s26WpyJsqdo8Wsz428sZ
         AiCnEWm5KP+/UUkvEiZz2FbmMxSR6eo8kH6UdFgN+aakXcnegLURhmiuWupAUkEQsz3+
         aWUrvnrQRDPSqRfEP4L/Xmo8CikKJ198GDCtAtCtpedwUnOOtfJR/Oeo/LhZX2DDA05k
         QiJg==
X-Gm-Message-State: AOJu0YznmCUSH06UpJ7D8A3aCw3vAvgdGFp4JoLEQwicx4E1dHga4WDJ
	1YrcHPQzgREP2Zo5RFwSXiLjQftkTakmZSITC9tnJOkEPsYzUO4BjR4jm6vwlLjnChK27wkLlf7
	AJQ==
X-Google-Smtp-Source: AGHT+IHQrbolfUfTpHvOTZVD4J59z3A8mKmJAPa7A07Gpd2BgjA5jYbxRm2+aRNcTednDQCuVzY4bKyQXBU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d502:b0:1f9:b35f:a2b6 with SMTP id
 d9443c01a7336-1ff5725095fmr2659555ad.1.1722631144792; Fri, 02 Aug 2024
 13:39:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:38:58 -0700
In-Reply-To: <20240802203900.348808-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802203900.348808-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802203900.348808-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86/mmu: Decrease indentation in logic to sync new
 indirect shadow page
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Combine the back-to-back if-statements for synchronizing children when
linking a new indirect shadow page in order to decrease the indentation,
and to make it easier to "see" the logic in its entirety.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 40 ++++++++++++++++------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 69941cebb3a8..0e97e080a997 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -674,27 +674,25 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
 					  false, access);
 
-		if (sp != ERR_PTR(-EEXIST)) {
-			/*
-			 * We must synchronize the pagetable before linking it
-			 * because the guest doesn't need to flush tlb when
-			 * the gpte is changed from non-present to present.
-			 * Otherwise, the guest may use the wrong mapping.
-			 *
-			 * For PG_LEVEL_4K, kvm_mmu_get_page() has already
-			 * synchronized it transiently via kvm_sync_page().
-			 *
-			 * For higher level pagetable, we synchronize it via
-			 * the slower mmu_sync_children().  If it needs to
-			 * break, some progress has been made; return
-			 * RET_PF_RETRY and retry on the next #PF.
-			 * KVM_REQ_MMU_SYNC is not necessary but it
-			 * expedites the process.
-			 */
-			if (sp->unsync_children &&
-			    mmu_sync_children(vcpu, sp, false))
-				return RET_PF_RETRY;
-		}
+		/*
+		 * Synchronize the new page before linking it, as the CPU (KVM)
+		 * is architecturally disallowed from inserting non-present
+		 * entries into the TLB, i.e. the guest isn't required to flush
+		 * the TLB when changing the gPTE from non-present to present.
+		 *
+		 * For PG_LEVEL_4K, kvm_mmu_find_shadow_page() has already
+		 * synchronized the page via kvm_sync_page().
+		 *
+		 * For higher level pages, which cannot be unsync themselves
+		 * but can have unsync children, synchronize via the slower
+		 * mmu_sync_children().  If KVM needs to drop mmu_lock due to
+		 * contention or to reschedule, instruct the caller to retry
+		 * the #PF (mmu_sync_children() ensures forward progress will
+		 * be made).
+		 */
+		if (sp != ERR_PTR(-EEXIST) && sp->unsync_children &&
+		    mmu_sync_children(vcpu, sp, false))
+			return RET_PF_RETRY;
 
 		/*
 		 * Verify that the gpte in the page we've just write
-- 
2.46.0.rc2.264.g509ed76dc8-goog


