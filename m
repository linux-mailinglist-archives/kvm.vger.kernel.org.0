Return-Path: <kvm+bounces-55814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C068B375E1
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01AAC7C0675
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA4C223DE8;
	Wed, 27 Aug 2025 00:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TxEF2nTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244E521FF26
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253145; cv=none; b=vFRZ/FKAAZEoIHofLKPOyruD1RJXsm1+mK5d3F73i4Kk61dvTmbeic4PlKt+X7gchilrQYNmy5SzqZs04MFCdHpNPpgD6Ypb5DEEZ24dlHZ4vc073jo7KrKDYiSH8HzCey7oKr5MzD676ag6IB2um2ir0xEbuLovg/AzitEAO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253145; c=relaxed/simple;
	bh=LPaxkW9YyCXUJeIK8cRJGK+UjtY30XS0fpBptMGlvUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ReJBExVuirPq+ER2rUpZ8BZNreCnvhmx7stTkDUlYI+QNCNzmFkRSpW7qi/rtU1HTV1CmI3Up0RtvL2nhYFHsbKwXyS166ocpfJzr01EcmRlxDZe6Ce8TP2eCltIczZu+yzdvdJGqq3geAf+PoKH3tzELAsovq70Fc0Pp663pro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TxEF2nTJ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-771b23c0a6bso4708733b3a.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253143; x=1756857943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FsJkpNgJKrVlrQ0kYYDnZ364wlXe53Et8BwiZ80i0+M=;
        b=TxEF2nTJSm7I/lUichMiss/0dvcKnEKDsf82vrVDpgCCQjNJm0HP0v6S2+6VYI6S89
         calCE3XGypg6kPehwicAXodOrXQXCZ9deEDjA3XEiJ/7/rng4LKDFZ6DO9Z5GbSUHKsF
         TpNfLMWj+ZVNMDslsamUf8xUSjm51BxWOKbpffAdV7ZyMOFiwNSNmoqcggWqWbFpaGL2
         jns5LFUzHCFEBKvbi8j25BZwm9EUfEUMF2dxxEH2eMKCRIVwdwcffum1QKNPymcOug0M
         m2NTuqt3YxcTLWrVdQB2r8OeB86JqdltJviAfRzBVF/NQzuBOupGtyCc/es8jZ9NzsE0
         umRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253143; x=1756857943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FsJkpNgJKrVlrQ0kYYDnZ364wlXe53Et8BwiZ80i0+M=;
        b=KMKz4URkZyxePr8EbXdMVVgNkxYWVz4052/HlPKHU6QAancRv/zmcemeyyqAGWnTVY
         H6TIrxU14muxcK1X6AFx3EKuqUfn0u2icAwfajK595bExi5CnXNL5XF9nImD7bfl4DZ6
         yg4jPBqNu9ha8iP1DDOoJyU5PtWZtZKXq/b/1VY7Wa0NTTxPRCkpsg8rmFSsypHIkX+8
         hfHfzt3fbnUMQvoVcVFs294ctxfSMikp7jTKxnfXc9YJct61MAfUfRi1Yx8dPV0d/vqv
         XYQQi2XrWbzmZcyvTVLFVZ42vwLlF321Qd7veTdkZiWfxvF6oDHP/OWAJ/s8TyaNv5zZ
         vzvw==
X-Gm-Message-State: AOJu0YxdzuBNnHK0QwAH91pfyCHjcNLy+dwD1l9yQY0XVdXuE21cNKaN
	aEZaBA00d+lUMPJY1L+aCZf1ZO4cZ7cdvsZrw1522jvLkwBvtVsv4OQnagEFlifUcEDnmJSyxhU
	qL0g9yA==
X-Google-Smtp-Source: AGHT+IEpi55G8voNDVUumr/uaCI0zU1p73RuojkrRDx6WiI41KFFc3w7odsA7AW9Ablcl98PDu4S12vgqWw=
X-Received: from pjvb15.prod.google.com ([2002:a17:90a:d88f:b0:311:c197:70a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:5493:b0:243:15b9:7661
 with SMTP id adf61e73a8af0-24340d71cfcmr26934393637.59.1756253143613; Tue, 26
 Aug 2025 17:05:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:21 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-12-seanjc@google.com>
Subject: [RFC PATCH 11/12] KVM: TDX: Track nr_premapped as an "unsigned long",
 not an "atomic64_t"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Track the number of premapped pfns as a non-atomic variable as all usage
is guarded by slots_lock, and KVM now asserts as much.  Note, slots_lock
has always effectively guarded nr_premapped since TDX support landed, the
use of an atomic64_t was likely a leftover from development that was
never cleaned up.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 ++++----
 arch/x86/kvm/vmx/tdx.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 27941defb62e..5d2bb27f22da 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1639,7 +1639,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
 			return -EIO;
 
-		atomic64_inc(&kvm_tdx->nr_premapped);
+		kvm_tdx->nr_premapped++;
 		return 0;
 	}
 
@@ -1771,7 +1771,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
 		lockdep_assert_held(&kvm->slots_lock);
 
-		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
+		if (KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm))
 			return -EIO;
 
 		return 0;
@@ -2846,7 +2846,7 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
 	 * TDH.MEM.PAGE.ADD().
 	 */
-	if (atomic64_read(&kvm_tdx->nr_premapped))
+	if (kvm_tdx->nr_premapped)
 		return -EINVAL;
 
 	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
@@ -3160,7 +3160,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
-	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
+	KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm);
 
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ca39a9391db1..04ba9ea3e0ba 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -37,7 +37,7 @@ struct kvm_tdx {
 	struct tdx_td td;
 
 	/* For KVM_TDX_INIT_MEM_REGION. */
-	atomic64_t nr_premapped;
+	unsigned long nr_premapped;
 
 	/*
 	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do
-- 
2.51.0.268.g9569e192d0-goog


