Return-Path: <kvm+bounces-22409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A1693DBE1
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B355A1C20A45
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0084F1836E8;
	Fri, 26 Jul 2024 23:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qG7lmeAW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C7C183096
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038055; cv=none; b=RdvOx5xrTBXZvxnqRz69AySW6lczIhVil2B8jf32sp7h7gLVHUL4oItY1/A8RUJHBGbzINXeaAWE8nhdXPripPPx4NA8rwhqd2dGuBeCoGMi3d1uYvmd0iM3qrPRW5PqUug7vhiA01Rfl9zUU3SvE7KXd4sWGxTh++bdN5WDGrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038055; c=relaxed/simple;
	bh=PYmFTsup/AEmfy/4jq9PM2uJzzhDaOGf5jqGf3bldb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=POxjiU+akX7DHHHFZoiOt84OFR55ORrHHN47ICH8BAS5fCkFXZ4e2eafMzflKC3uwajW2Qv04lWV0T/w3nmyrsnrDqJqP0JFfpwr+9THwtLnlXG6Rfj7NboLIgQchiUV5d7KBj1bDyAJtJmxzVRhdtspqD+PZT+SBwU0xmAuhmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qG7lmeAW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb5ab2f274so1670083a91.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038053; x=1722642853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IbuNIltU7tfSlkccHv78LPGh6NGiPV3XEW5ZkU/rXdY=;
        b=qG7lmeAWjCmRFPGjSdtFWnVF5e8lzWK6C1pA4O4yqJYKVqbeW/XxPr9BF1EsoWCNx3
         nZXAhwOLGE14OsGoOoASVkjOct5HX7VAgUOvZYUZsfI+wiu/LTHsSMQ0QlOGUx0u+K4t
         5d7wv9u+gzCxcGFynRlRTvqXTdzIv8Oi7Qa1sVFlYJvEdVkjltEmPNnSuaJ720AbYW4j
         AHfLc5kA1XsJ5+zLhnKBzhlGYUInpLqBjZwJQs3rllyeqf6gGjZXRf7DovuwQRxOHRMr
         BnElQcAGdyePpfgBajZF3tMjQIdnOgmIuCXMqbue6N6p2EKzKcRetpNAffxJDk2/fI2O
         m/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038053; x=1722642853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IbuNIltU7tfSlkccHv78LPGh6NGiPV3XEW5ZkU/rXdY=;
        b=CxwWnKkYr2T3taYaXg+cZAukbPdLNvWDli/Q9PmHnWA+oupPpzhF7lf9/0FEj+aXpf
         I9sKUAT/EwcLtqCXoyg8kGSQOV87PnCv5WmBxX9knWBjqNsZMM0aw1j6DZ8GAfbgXDjp
         iyzYlV12nodhd8Mb9dkULZFe2Xje+sxCC0STsj+Pm2XqwkhgCvl2xWRT12bBxcUW9GTY
         m9RJkkqXIs3n2JLq0c5zQGOXwIhByBHk8RokAugkHjrzffPoMrs5GH6bTSoqHFKI5dwe
         6aCD6FH+AQXgb8fPyD2UVem0eA/Wc/vs5uLw2V68UgvkZ3gZ1VeTZywkBrfjZ7WwLeYy
         LwQg==
X-Gm-Message-State: AOJu0Yy3e7qrTu5B5pMnP+JSxtORAQ2p8Rg74QTV8vFOa0Z+iNgj+FMh
	JaCweQjwiXoMqDXolRYFpodwqdzuyf6/sa27Y44zwTlOeYVGishfsq5wzPRou/cvflduXnxtfoO
	YQQ==
X-Google-Smtp-Source: AGHT+IF1WA3mVZXk9S93pEq2eXLardKUPi+yfLeicmT6epShCKMtCcCE54tvymeWkFnvdj0Qbejb/rqSUKM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41cc:b0:1fd:87a7:1445 with SMTP id
 d9443c01a7336-1ff0489344bmr935735ad.9.1722038053119; Fri, 26 Jul 2024
 16:54:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:55 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-47-seanjc@google.com>
Subject: [PATCH v12 46/84] KVM: x86/mmu: Put refcounted pages instead of
 blindly releasing pfns
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Now that all x86 page fault paths precisely track refcounted pages, use
Use kvm_page_fault.refcounted_page to put references to struct page memory
when finishing page faults.  This is a baby step towards eliminating
kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 146e57c9c86d..3cdb1bd80823 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4326,6 +4326,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
 			    r == RET_PF_RETRY);
 
+	if (!fault->refcounted_page)
+		return;
+
 	/*
 	 * If the page that KVM got from the *primary MMU* is writable, and KVM
 	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
@@ -4337,9 +4340,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
 	if (!fault->map_writable || r == RET_PF_RETRY)
-		kvm_release_pfn_clean(fault->pfn);
+		kvm_release_page_clean(fault->refcounted_page);
 	else
-		kvm_release_pfn_dirty(fault->pfn);
+		kvm_release_page_dirty(fault->refcounted_page);
 }
 
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-- 
2.46.0.rc1.232.g9752f9e123-goog


