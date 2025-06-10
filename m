Return-Path: <kvm+bounces-48887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACDE6AD462D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F96C3A6FFB
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80CBC298277;
	Tue, 10 Jun 2025 22:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ziGyi8Ma"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9428D8E4
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596268; cv=none; b=VN06QogFQbRb9L5ycYY+b2H0mypSnrvfdCN2ECJmG8wHnwWlaZdK5c36ypYBr6n4eRLRwJBvTZbZgpK2+0ZGgMmRqiqz0CmpD5enH6VtRWCSKa7LNwWaACIh38uMp/UrczjzOt5c+Z1sIri2OAecIuyxjtAVTnOmEVmAvJ+C73U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596268; c=relaxed/simple;
	bh=9VEAvtUsud2CGs9vlrwfusz06B+7ZsvAKB7oC960uWQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OcRKl/bNFIHXq73IePPOn4G9yyplDkE2OsoQc1fFjPKb/GhrOBrRqcV56bySvwDVz+iTftB3o0s4FKiFpi8UAO/fNqqwqVPPCnli1JFHjuGQpea6ZFNV8VLjzwnAloN5Ok2w9Buha3gO4YHemRw1a9JVnptDVQib67aULG2liVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ziGyi8Ma; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-740270e168aso4844268b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596266; x=1750201066; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sgbdhI3yd/wQ/3cQ73eXvLbLWKSkDV545uFxsAvOoCg=;
        b=ziGyi8Mavn6a6PdpdzWGfFzc3CBeFRC3BGD2s3dVd9sJlC5ZiL9GRhM/S69ZWV655j
         ormtFGCto370krwFDKu/iWosSmSyfoRdrDh/p188J77npgoe6EO66htmdNC7hNUgvNKF
         gF3JomtT6WVwMiWTIBwtHu2J5a87LpsfqE50wsu3UcBBRLT+eqFPHLS1e03dUNOh3NBR
         xU+1zW5iLQvFZHEPN5UOHgtykctpNvEwtiamJDPmGzO09nPt/LADrwEp6UxxgdXnY4El
         XjL/Asu+IhBcj+bvH6xEV65QLReNca0W+r6cX4r36zIGBUb6/agntTRjXyWR638m8Zv4
         1u9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596266; x=1750201066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sgbdhI3yd/wQ/3cQ73eXvLbLWKSkDV545uFxsAvOoCg=;
        b=v20npBWeWKHbNMdiUYQ6X0XNu02p4C+oyTPwxP9ONgKNEpZ0H08Pr29w9aWWjXNmKd
         Gk7wECBRyMheYm9f4v9piiTz/jd8UCwZciIS8ZL0mbQcEOh1bQBs++3buSG6MisblLIM
         IvfTFS/43OyuSCxQXPbG1Hcn4C/RVmsAPVaL5jsi7sbzszXB2wml5uV2X9vaaXZQa7QX
         VT/+KSPusYrMmIHXJLPYtIaIaimmIj1tvdT6BT+6wPJAyD7d7E4gAQvgfXcP4s8fh5Ne
         MaIsucdpMybBwbTxn7Af3tDnTvISb0hEtNIJ509ZIQQ8+bpjwIS4BwDjykRga9uvnWbI
         B3kQ==
X-Gm-Message-State: AOJu0YzM3QV8XMuVcw1bx5oyKXS2/TNYec+zHt/UqH9MkuLcZNC31Zgk
	Tq408Qp86ypZwUnM/OwxK+vgTFlwpFgMtCvpHxnwFKn3BIGi5m87fvQ5Fm9PBE+5xlnM6RXKDNF
	eyFfECw==
X-Google-Smtp-Source: AGHT+IFoj6QRzLKrYLLSAJQ2LmKp+ObVPY/ahIVkPm5UND4Cxp0AWwCGUQGOuOLKDbn2xQa0z5KnVXCOFdg=
X-Received: from pffv21.prod.google.com ([2002:aa7:8095:0:b0:746:2897:67f3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d92:b0:748:32cc:eebc
 with SMTP id d2e1a72fcca58-7486cbd9035mr1442926b3a.17.1749596266499; Tue, 10
 Jun 2025 15:57:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:08 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-4-seanjc@google.com>
Subject: [PATCH v2 03/32] KVM: SVM: Don't BUG if setting up the MSR intercept
 bitmaps fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

WARN and reject module loading if there is a problem with KVM's MSR
interception bitmaps.  Panicking the host in this situation is inexcusable
since it is trivially easy to propagate the error up the stack.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 262eae46a396..f70211780880 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -945,7 +945,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void add_msr_offset(u32 offset)
+static int add_msr_offset(u32 offset)
 {
 	int i;
 
@@ -953,7 +953,7 @@ static void add_msr_offset(u32 offset)
 
 		/* Offset already in list? */
 		if (msrpm_offsets[i] == offset)
-			return;
+			return 0;
 
 		/* Slot used by another offset? */
 		if (msrpm_offsets[i] != MSR_INVALID)
@@ -962,17 +962,13 @@ static void add_msr_offset(u32 offset)
 		/* Add offset to list */
 		msrpm_offsets[i] = offset;
 
-		return;
+		return 0;
 	}
 
-	/*
-	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
-	 * increase MSRPM_OFFSETS in this case.
-	 */
-	BUG();
+	return -ENOSPC;
 }
 
-static void init_msrpm_offsets(void)
+static int init_msrpm_offsets(void)
 {
 	int i;
 
@@ -982,10 +978,13 @@ static void init_msrpm_offsets(void)
 		u32 offset;
 
 		offset = svm_msrpm_offset(direct_access_msrs[i].index);
-		BUG_ON(offset == MSR_INVALID);
+		if (WARN_ON(offset == MSR_INVALID))
+			return -EIO;
 
-		add_msr_offset(offset);
+		if (WARN_ON_ONCE(add_msr_offset(offset)))
+			return -EIO;
 	}
+	return 0;
 }
 
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
@@ -5505,7 +5504,9 @@ static __init int svm_hardware_setup(void)
 	}
 	kvm_enable_efer_bits(EFER_NX);
 
-	init_msrpm_offsets();
+	r = init_msrpm_offsets();
+	if (r)
+		return r;
 
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				     XFEATURE_MASK_BNDCSR);
-- 
2.50.0.rc0.642.g800a2b2222-goog


