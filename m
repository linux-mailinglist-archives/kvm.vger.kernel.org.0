Return-Path: <kvm+bounces-38536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FDCA3AEF3
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 077211891D2C
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FA61B87E3;
	Wed, 19 Feb 2025 01:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n5D1tx5s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB561B4247
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928447; cv=none; b=bBuoecdaEcxNAxcZ1CCsO8eqpmC7cI25t1QWysYNm/RHyuVr6wc8jqD7ihT6NfkmM7tmWH0ALGUP5753YpRFfCTWbkNwfkbltzE6KhCwaLrsn8xcbFoKue1oPAgJoRFl0nIMwA6eZXAKZuLKa+cNrW9JlF1mArrYluATc+aQQVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928447; c=relaxed/simple;
	bh=8HNmILbOSwalR8zIxIIl3FnGV1i2PFV3f6IC6S2LJd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XQYYRz0/OVS03B9qWT/bcPkbG9RDWer3aTTlerbH1E4e05qNY1/W9dmIb+VXWUICVJ1h+2xGjwqCFwiku9IKXMTBMOBJilpeyPRqy4cz6s2NQBk//5IWBPH7gp7nqSScexxI/dw/xE4pdlmscrKAJFt/2nqnnbJkOzph/M9/ra0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n5D1tx5s; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220d1c24b25so128009415ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928445; x=1740533245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B2fI7t6EYAl/h+pggEYQL1iQEGSfxTQzaS+eT4QW64Y=;
        b=n5D1tx5s4LyrpmeIBuF6EoQcIisvIdOywDWaTyOeJn/di3wsacPlBIafIsNnT5l1ev
         AN9UDwMwVzsKX21lTUwp+4KuNfe5N/tW+4haM1UdU9NFv4Zhy74LW+BSgnG3s8XtB0bG
         BwUgD3hueQbqVv4Mxj7IHzalNKA3RrN7s8z5MNKqf8sa9TcDzDtIfDgbQK1LfAVZsTol
         dVRlzHU8UndRqQhDL6h9NAh0/z+O9FD6JWWwwmF3K2/nB4eUSbJOksFxFuYlz3arFh9Z
         iGjKPRs+moW0Kq945PVvNK1VSzm3QZO+ydkXq/XBUhPzTefEOEVYh6dAYOqrQ5ZINn5M
         HnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928445; x=1740533245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B2fI7t6EYAl/h+pggEYQL1iQEGSfxTQzaS+eT4QW64Y=;
        b=PnxaAWfYhPgg395UhNcvG4b8+fwbTRRp0Qne9HXtxDOYe7+KmSGalhzG8J0ndtXiAR
         HXtJTbWSDUK3jX4K9leOwH1e6WYBG10hY6tKtfZlPkybtXSPTG1vD0kRjcqmJrQMuMXC
         F/Fs2wFiFAwdQF8qjP9lTEkoUFEp1XXUpGxAmu6vCev+T6B2XOIH5lhBHx/YkuTuYvgC
         6Pp/pQQXzCZBnH8VIu0OXDpKLddH1e6mI26YKDXRnkyNw2H1bq1LtpeFT7mmjoZ3DGp6
         2G0u2tL5Mamz79i3SP//GThdHO9rINTC4bJeP8ETAZQXLLGuEuZ4fhgu/XLdP6IG6tev
         bVmA==
X-Gm-Message-State: AOJu0Yz2isDzzsm33/oEmEK8oqwKYoAt6MX4ZRlnrCVX/uFrwwyO7FxL
	GwhvjRlLzvZn/cztdBrmX3TUYP3d+QoUg0ZYmjfuw/Mlb9+SZEsS9c9RUMo2qrLUe8QjFio5ZeK
	ONQ==
X-Google-Smtp-Source: AGHT+IGQDxe+HD8d0dlDg/Exw7kmkBeU3b0w8uvLuKNdfY8ETtEedCLbMAFDAagya2O0dqtA5uEXA76atec=
X-Received: from pjbrs15.prod.google.com ([2002:a17:90b:2b8f:b0:2f2:e97a:e77f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3d0c:b0:21f:7964:e989
 with SMTP id d9443c01a7336-221040d84ccmr247065355ad.52.1739928445031; Tue, 18
 Feb 2025 17:27:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:27:05 -0800
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-11-seanjc@google.com>
Subject: [PATCH 10/10] KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

When processing an SNP AP Creation event, invalidate the "next" VMSA GPA
even if acquiring the page/pfn for the new VMSA fails.  In practice, the
next GPA will never be used regardless of whether or not its invalidated,
as the entire flow is guarded by snp_ap_waiting_for_reset, and said guard
and snp_vmsa_gpa are always written as a pair.  But that's really hard to
see in the code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 15c324b61b24..7345cac6f93a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3877,6 +3877,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 		return;
 
 	gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
 
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!slot)
@@ -3906,8 +3907,6 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	/* Mark the vCPU as runnable */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
-	svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-
 	/*
 	 * gmem pages aren't currently migratable, but if this ever changes
 	 * then care should be taken to ensure svm->sev_es.vmsa is pinned
-- 
2.48.1.601.g30ceb7b040-goog


