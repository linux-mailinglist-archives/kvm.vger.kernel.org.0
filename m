Return-Path: <kvm+bounces-54203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0C9B1CEAB
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 23:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F06013BC586
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 21:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F65238D5A;
	Wed,  6 Aug 2025 21:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZXFodiD2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5D6233727
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 21:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754517106; cv=none; b=XWYisZtoWEVJ9mlYIuJ44Twe0ei8epTTl7EflGFUq9R4g29bbMKTLwTAcYWkwH/HA7DaV8MPIwmxdutAqxXX/AftMF9Mi61U1eE1+lqSVr+s9xUvqnJXfNeoeOiN65WCHycPRx6Ni0f0qOXexnbnqKtBJ0TPrHiLVgmsI5M1kkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754517106; c=relaxed/simple;
	bh=ioGhk3xk84BoXwkcOPC/uTsbu3UVQYxlGhQBp62yXPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oFQWHiUGkcgqD/UBAjgPdp9B2vdo2X1hjomGguv3CzT7x64TX3PYCvMZwQKSqFXp5EwVuK0Ks08RKX1hjGuIWRMjbsbqnLiZBTwUYrYWCkK5c7UEMSkIxeTOSgf7H+qBj4uwSVjmXxFVl4WcB0+yZTaDvJ8+MFvzqUlJ+/AYQR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZXFodiD2; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b423dcff27aso436720a12.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 14:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754517104; x=1755121904; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B4YJ+3jCatffCVLDpGjGjNQPin+iS8DfOQi6G+axJLM=;
        b=ZXFodiD28PmINu/pwign8ms5UTAjEXQ5/vegigDrLBdxKyDY2H1mybK4rcFtxIvTnw
         NdNLomjlM9LY1/NtckvlO2KX5/xPS6MJdO31Fg+Ffj6JuteG2UQStNUD632Rs82zB1zx
         tI96+w514z5xxuz6ytthpC4qdWybH+P3ksXWWGeV0Few+T6otbWENWQtp9ty/EjljKlW
         /Fl+o/SwgSLXSJtvW5He/4pdvfzKydsZ3x9rpGjj1cgHHKW1JCoheM3tuXPDwKoAmVju
         4xsQgWlkkOT7XEXpl7+tRTBPTYhoxZFtUgbh5MaQt0WyDImLwJLZF8oMzhuShYQicDTM
         DjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754517104; x=1755121904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B4YJ+3jCatffCVLDpGjGjNQPin+iS8DfOQi6G+axJLM=;
        b=aQbc6xfBlpZhy9y/7Ee0uRp6dS9G6qy1auckW7+O7UZBTf+umPeOr51CrLgofOvNhU
         eg8Ugy2NnEwOCwan3LVIa4LEYMumCNNEm1+34j/NSH533zVBeioAXEPZwNIyg5c/gSRO
         YSfJXGc7huABMTUH3aUGuKlyjJIgPsAA0oNzmMDHJz/rhxPAx8czmVawzjHBE9xxbbbB
         FLZp2/4Q8g2nNTYZWqpzS5zvz9PF7Uz/fYDQoBaIe6JbFU6GuMVMuC9QPZ4cdBRPBDP/
         FDvRafSQIhLi6o8uHJ/MW9fLZTY6Bp2yXVxHQdytb2hhJkm1NaF9XMpitTPkdSKYHNb/
         Tg+g==
X-Forwarded-Encrypted: i=1; AJvYcCViwTSKvzyCFS0xIEjma2X/V0A6z+vzNJEELwpWtvEpP/eGvp595THP7ayZnWg4DZOkbzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwOcmo81yL4V8izl+3RI9u+LxMrmPqwfY9wxKFt05ZXBbgHl2V
	AKsY5AcHXHE2d18lxCGQ0o9031X+2sIPQpz4Ua1cycsfc+3UDEqT+VWKROnWpeXh7lAZaU+991G
	J9xuKGhQW2peBjFGwd/AbNg==
X-Google-Smtp-Source: AGHT+IEFHzjbTvF06Bn7ryEnz1G4fFcb0+2rb8vE4CxPsmdqrExCBZEQOrWh+mH7nhcPPrOgHcK/Y1pm7L5bNJ1t
X-Received: from pjbmf11.prod.google.com ([2002:a17:90b:184b:b0:312:1900:72e2])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b08:b0:240:80f:228e with SMTP id d9443c01a7336-242a0bc8d31mr52399045ad.52.1754517104106;
 Wed, 06 Aug 2025 14:51:44 -0700 (PDT)
Date: Wed,  6 Aug 2025 21:51:32 +0000
In-Reply-To: <20250806215133.43475-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806215133.43475-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250806215133.43475-3-jthoughton@google.com>
Subject: [PATCH 2/2] Documentation: fault-injection: Add entries for KVM fault
 injection points
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

KVM now supports three fault injection points:
1. fail_kvm_mmu_invalidate_retry, for all architectures.
2. fail_tdp_mmu_cmpxchg, for x86 only.
3. fail_tdp_mmu_resched, for x86 only.

Provide basic documentation for them.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/fault-injection/fault-injection.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index c2d3996b5b407..da75c921d6c4d 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -87,6 +87,18 @@ Available fault injection capabilities
   inject init_hctx() errors by setting config items under
   /sys/kernel/config/nullb/<disk>/init_hctx_fault_inject.
 
+- fail_kvm_mmu_invalidate_retry
+
+  For KVM, injects fake MMU invalidations.
+
+- fail_tdp_mmu_cmpxchg
+
+  For KVM/x86, injects cmpxchg failures for TDP MMU SPTE updates.
+
+- fail_tdp_mmu_resched
+
+  For KVM/x86, injects fake MMU lock contention for TDP MMU SPTE iteration.
+
 Configure fault-injection capabilities behavior
 -----------------------------------------------
 
-- 
2.50.1.703.g449372360f-goog


