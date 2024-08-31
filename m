Return-Path: <kvm+bounces-25591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87DDC966D45
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD894285150
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8AA322EED;
	Sat, 31 Aug 2024 00:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zg4wGD5x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895F51F94A
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063356; cv=none; b=m2WLmWovR95bWAfZflGgssFZaQt2Q6heY6HtcoKkAPuXa5Cv1Zn0SuYfen/jX/RfQ0BpqThVwAlnnYdgcsmwOdsUbQQQBUSGwMmzWYl4Tr6gFnXmLSAywBxU91uFKlwMvu3ZajmjtepK31ABORfzfmhYGMpP/dmMtrzuI+xBswo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063356; c=relaxed/simple;
	bh=pD5WjQYntO47PlRaRqi7VIbbwgINoA1bCT/vA6bz3VQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mULRs8i2F/OkMk+/0BltZ8cgiT93++7VxRyKJRxh7LdH0+UT3t9wUBuuKtJAeR+sIoGoiABfxxRkSsCAX909Usk27CYGVvJyv8xknrYP9y8Uwo9UxZqDPxEhzIYiTk3umamdvWZls7ASsrYqWwkcuMM+7hjW3KZsJJKhiFtXNlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zg4wGD5x; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d8817d8e03so828746a91.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063355; x=1725668155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+Qft+nZl+LjcqZqAniryaxEtRXUtCnTAy59Lv2DhjhA=;
        b=zg4wGD5xuUA3h+LdDwGof/mJtuSJEw13b9S35EQNGcCDy8uXbsfdzz4NcLX16XRdcS
         aoc8sWi/MglBjyiWUtm2NXpYc386Y1A6Ynte9I0ogyB1lm+GP26C0yaFfMNf8Hc29ViX
         PapNWp6AeSJBKPaQMJsKG62e+/Kn3t21vFvsxtjfRnLNIfe9G8CzIpcr9/gsAa8nSb13
         AS2W6XQsZoHmr6JxbG9jHP7OdvlTjkVEi/EED+PsETeba9dRDh8NczH+Ns0nUtEY43wZ
         7B6pgOOzInf3B7IVhJfzVXw6xSJ7viXSE/foXpenZsKMH3K6uzHXRaO/P5DScGWnJgqN
         cZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063355; x=1725668155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Qft+nZl+LjcqZqAniryaxEtRXUtCnTAy59Lv2DhjhA=;
        b=t96hnzgDUx3sRyWs4E6/yBD2eFYdwHPt8j4LsRGE6+I/77pdbPAs4Y+GI2Z/368tn7
         mTH07Y/sErAwL16kGIY1r8plID8jZ5S/YSD7ZgWB5aSe2o68zubB/OsdwHb/8TgOol1j
         bN9P0MvCsPBtAdh/BCM5W7Hb+4W3NQLL9e09r48JH3kmb0Pl16Dn4lx/M0Fb5/IrmNR4
         zwekEXyYA2SeKNyqSNHhrGT9Dv5Desuz71J3ZhmywMMrcC1Mq4rld+IVm4RKOEraMqTY
         S3y2sfqC9t7+sdGFPGNSYiXXxQzRbSOLhouxf2K3kYkxDKLdCO8EOEjHhrVdesO5JvEd
         7/1A==
X-Gm-Message-State: AOJu0Yys+CcplivdQtZsuoOVB4D5DAib570vtwHCQyIArGWhnCwW2YkE
	nUZi1LgBLxajJJJ4b7tA/gUPe7fmWMYCM+kspskFO6hCqNIE95+VwdUGiZ+wAu9BOMVeR0oi6YE
	UvA==
X-Google-Smtp-Source: AGHT+IGTQJIEJrg9n5PvoSMJ5tiETEAqsh2sRrvNvPq6jrtr32LGIiuli1Er3RpuQYOhVlsrghuEnFeBcIY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3f86:b0:2d8:8abe:cb03 with SMTP id
 98e67ed59e1d1-2d88abed74emr3402a91.6.1725063354736; Fri, 30 Aug 2024 17:15:54
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:22 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-8-seanjc@google.com>
Subject: [PATCH v2 07/22] KVM: x86: Store gpa as gpa_t, not unsigned long,
 when unprotecting for retry
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Store the gpa used to unprotect the faulting gfn for retry as a gpa_t, not
an unsigned long.  This fixes a bug where 32-bit KVM would unprotect and
retry the wrong gfn if the gpa had bits 63:32!=0.  In practice, this bug
is functionally benign, as unprotecting the wrong gfn is purely a
performance issue (thanks to the anti-infinite-loop logic).  And of course,
almost no one runs 32-bit KVM these days.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1f0f4dede55..c84f57e1a888 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8928,7 +8928,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 			      gpa_t cr2_or_gpa,  int emulation_type)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	unsigned long last_retry_eip, last_retry_addr, gpa = cr2_or_gpa;
+	unsigned long last_retry_eip, last_retry_addr;
+	gpa_t gpa = cr2_or_gpa;
 
 	last_retry_eip = vcpu->arch.last_retry_eip;
 	last_retry_addr = vcpu->arch.last_retry_addr;
-- 
2.46.0.469.g59c65b2a67-goog


