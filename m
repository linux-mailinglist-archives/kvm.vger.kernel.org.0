Return-Path: <kvm+bounces-39429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C996A470A2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B71316EA63
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B112D145B3F;
	Thu, 27 Feb 2025 01:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h5bwLIWn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548601DA5F
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618080; cv=none; b=Pzb+MZ0GfZilU5BzpgoDhSrZAaqyu0ST681Wc5CS8z/JUeaI9ahcmW2rWPRzDPdClPeFIa65yMPmHMh/qzq9Nrs/VGjQNiDeGykxT7qS8r+JMmhhso8z8j4R6COIB8kJ4hLfND9BSmaGjlGVnR+gwQHndTXl+DNdDtqjJSXNMpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618080; c=relaxed/simple;
	bh=WlG71nbfhMG+iZLSreFus8KOoSWVnI0WTDVJb/q9jyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tv+qFJ9lVyYWg6FRZYdVgnv7KeRDn6XpekDlu7M/uwhSUA2EIjGkFhx+LflU5mVQHIg8dkVWQRlXJC1GpN1UH8EhqUX0nfdRQPExhUERZwVILv0ZLCV8hbD9oFl/kndYPyX5/IUwgUe5Q1XRKuGpUiuoc+aHeIjwqvR0c4By8eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h5bwLIWn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22349ce68a9so10545105ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740618077; x=1741222877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vBrLV0hVNi1a5D0W6BOn6trR5W1NotqikKgQ5Tv/tAA=;
        b=h5bwLIWnwuwrVytdM2CbIkyHDKiwxHsBucwH/HVkYoAGvzRRf2ExPXlMyntnUdjoas
         QobhzuDj107Ca/zGaDS+w8BQFr4aSwDVqMKP3XztP9CbtwtNVGlmpelAT2ovNx+GajMm
         MW2gB//r/0CeMbPWGRG9avSqFq6QfKj/zmv+4MgIL9RTU8bo18I1u6ZRNezMD64Pd+AZ
         N/m+tHyM9GIw+bIwKehFhe/KSUdgemEDxI44vQrKaHbMakUVB9awcY8nIHSsZKgi5LWS
         pogQZ+xysPF02k+tial2LdtKDUuLvHQJ/awgaLnsIvwGX+oUiAzO6f50wXg4+AtF/DPw
         orjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618077; x=1741222877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBrLV0hVNi1a5D0W6BOn6trR5W1NotqikKgQ5Tv/tAA=;
        b=cmdgSEFKzqRTvnLf3IopSI9H+sxWD2OG2uBDGyj2Mz9ohbtcJJ3Nliw48fWyJbyuai
         k7RCE2e+MwehtUsYoWZPnDzSlNgXO//et1VA3ImfxT41iYB5DV1EN6xl1tfXnLGSJlUc
         bwEShWxJIoBUULtQX2es2DamB8qM0FsUVJiEW5Xa3oYTKGrecDDBf1aArEKAK9N42oRK
         xcApNKeHOlfDAUQwa96NQ0DUZQTedqoijZF89dQIUAE8Fmeel9JBb4cUkS0xkVw5q2vy
         1Tk7SpilqDG7KxwvNTrF2JKgsvxkne5b8CqGKUWhRhjU2P4/ZJ9zpj7PaWSoHgNksxf5
         IzLw==
X-Gm-Message-State: AOJu0YxhT6jiIVtw0IL3VX2lJvHPAbnZw2bX1Ox575QgSTMRTlOynIhw
	MEiYmCwBKBqUH1NNYrTbd5qy0rfVQBE83PCaduGcFc2T6aB7CSuKRSHP5FgEsXQEKrUbZQYvAnS
	xhw==
X-Google-Smtp-Source: AGHT+IHs7OvM6rkyJG6uPTB8OuiiFrOfEIijhU66O7j1sKQRSBCikrQVvi/YgsIilD/6fEgCFLkFRZL+ErE=
X-Received: from pfbfb26.prod.google.com ([2002:a05:6a00:2d9a:b0:734:4341:5d97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:eccb:b0:220:ea90:1925
 with SMTP id d9443c01a7336-221a1148e99mr409270715ad.35.1740618077666; Wed, 26
 Feb 2025 17:01:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:01:11 -0800
In-Reply-To: <20250227010111.3222742-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227010111.3222742-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227010111.3222742-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86: Advertise support for WRMSRNS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Advertise support for WRMSRNS (WRMSR non-serializing) to userspace if the
instruction is supported by the underlying CPU.  From a virtualization
perspective, the only difference between WRMSRNS and WRMSR is that VM-Exits
due to WRMSRNS set EXIT_QUALIFICATION to '1'.  WRMSRNS doesn't require a
new enabling control, shares the same basic exit reason, and behaves the
same as WRMSR with respect to MSR interception.

  WRMSR and WRMSRNS use the same basic exit reason (see Appendix C). For
  WRMSR, the exit qualification is 0, while for WRMSRNS it is 1.

Don't do anything different when emulating WRMSRNS vs. WRMSR, as KVM can't
do anything less, i.e. can't make emulation non-serializing.  The
motivation for the guest to use WRMSRNS instead of WRMSR is to avoid
immediately serializing the CPU when the necessary serialization is
guaranteed by some other mechanism, i.e. WRMSRNS being fully serializing
isn't guest-visible, just less performant.

Suggested-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 97a90689a9dc..ebecfe4bea1e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -992,6 +992,7 @@ void kvm_set_cpu_caps(void)
 		F(FZRM),
 		F(FSRS),
 		F(FSRC),
+		F(WRMSRNS),
 		F(AMX_FP16),
 		F(AVX_IFMA),
 		F(LAM),
-- 
2.48.1.711.g2feabab25a-goog


