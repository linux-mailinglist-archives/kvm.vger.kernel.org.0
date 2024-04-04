Return-Path: <kvm+bounces-13626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0C6899240
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 01:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EB5C1F23686
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24FC13C8FD;
	Thu,  4 Apr 2024 23:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lVZ5BNiy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB0813C82F
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 23:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712274017; cv=none; b=dr/Bp2dXCa9d79ZnbFkYLLGMU/cRfnh9dxiuY4XmISBfc4sZfh7G8pmp08P+O9hn1v0cSiCjy37G7gJGKg4Ehrkm0Vo/AjYgFwjoZT9eLEq9+Q4ISn78ag5vSoaEMpZx94t72YEh8LH/B4hqCNW2tHUTjUUCfBuvP8Q3Lk82h+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712274017; c=relaxed/simple;
	bh=dnq5uTOatCrls3JaBY8EL3ud8sd2RV+VYen0Om+cfzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EkA7wA3AM8vJfNuK6s8bgiF884tb4UrZ7tQlmrraakNJxTBdLq1nvPPByU+P47DKi9fSopuVFfIda/y6c4iqB8EeNqNBVvrqYh3Irqa0CNHR2gBJw8yM2Hv54Q1oSW6ZUIm8tvaaN6Bd2B1cAbJvb64NXbX2Ii/842zCmDWxDzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lVZ5BNiy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60ccc3cfa39so23900037b3.2
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 16:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712274015; x=1712878815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ASBumnpATwEIL5UUy/iyu9pk1RBUk9y3GsDAXtyLwC0=;
        b=lVZ5BNiyEBZdHq/tUJikFT19N8VhxXGGhtyHLJ3S71A7SBbfFHDOxj8lfVbl7iatAA
         aZKfNQfVbot9NRv/IrBGJMCfkoH3/6uxmklfE4xtwHPAIgNXOsfrpwALYBRASp0BaAaM
         E95Bp7781HzF3GN6VmcvDR/7ammcHiGnRyN6OJ4nd5ODMiEhuaMha3j2qANtzzNbCuCU
         LVIgHjaTU/D77CWt7i3riT70PzhnjuKUYnso9n4JCNJJfcgIGoaYCJEAvOl1qPFXbCBW
         4i1kBEBXgdrJpO6ut44MOK0do8WHwhGLnPNM9Auj6sqorO/A4pUg2eXFYsgLCwDBycV7
         8jHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712274015; x=1712878815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASBumnpATwEIL5UUy/iyu9pk1RBUk9y3GsDAXtyLwC0=;
        b=WtQdzDJcIi4it2V5RI0kmWLF+yH3OubfzvVha3/sVaW9iyXjohcC1+heJvX/juu8ua
         5ExOLlOh6scXSV+mg/4LEzEfGnXU39kGuwLqcHhHUO+aTtE+A9AV4LAHbHmnDtarLPD0
         NR2eBtZGSPKjZlZP5MoA1cX4LzIhUt0qDy7rf6qKjWSuUMsgzcHNK/cZ2+0kbvqDv0IQ
         alDhsuHPibcwwW7ufJSgGen66KZpKpUNV8XY0mvLoXUtuc9acIpPSGoi8+CSPQymkeVv
         V5xRK7zmsUmqSYYQbTanFLaMD5jDTOxoxfRm8U3ALwt0pEXBZ9/mJN25Gfb5QfSEtYbW
         g3Nw==
X-Gm-Message-State: AOJu0YzhMVsIxkiTul0RY/Lc0+qRrPrVQbzY6PQuIpxxAej5vGe08tX7
	lTLaa9MBhOMKM4L1q90S5Z91LWuZwO/PN+/vEc74PJx5xUg9EecJs4ooLX82/EGZWgCNlL+FzzK
	tKQ==
X-Google-Smtp-Source: AGHT+IHVcGzGtkoYE/nA2+uLT99pxp9ic0A3LYA19FxHXeoqMxTP0p5qV3iEyvFi78P0BWvKb0AtUaP9/dY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:dfd3:0:b0:615:439a:dc3b with SMTP id
 i202-20020a0ddfd3000000b00615439adc3bmr268726ywe.8.1712274015451; Thu, 04 Apr
 2024 16:40:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Apr 2024 16:40:04 -0700
In-Reply-To: <20240404234004.911293-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404234004.911293-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240404234004.911293-3-seanjc@google.com>
Subject: [PATCH 5.15 2/2] KVM: x86: Mark target gfn of emulated atomic
 instruction as dirty
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Upstream commit 910c57dfa4d113aae6571c2a8b9ae8c430975902.

When emulating an atomic access on behalf of the guest, mark the target
gfn dirty if the CMPXCHG by KVM is attempted and doesn't fault.  This
fixes a bug where KVM effectively corrupts guest memory during live
migration by writing to guest memory without informing userspace that the
page is dirty.

Marking the page dirty got unintentionally dropped when KVM's emulated
CMPXCHG was converted to do a user access.  Before that, KVM explicitly
mapped the guest page into kernel memory, and marked the page dirty during
the unmap phase.

Mark the page dirty even if the CMPXCHG fails, as the old data is written
back on failure, i.e. the page is still written.  The value written is
guaranteed to be the same because the operation is atomic, but KVM's ABI
is that all writes are dirty logged regardless of the value written.  And
more importantly, that's what KVM did before the buggy commit.

Huge kudos to the folks on the Cc list (and many others), who did all the
actual work of triaging and debugging.

Fixes: 1c2361f667f3 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <tatashin@google.com>
Cc: Michael Krebs <mkrebs@google.com>
base-commit: 6769ea8da8a93ed4630f1ce64df6aafcaabfce64
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20240215010004.1456078-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9c26397dcfd..dc0a7b9469e3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7106,6 +7106,16 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
+
+	/*
+	 * Mark the page dirty _before_ checking whether or not the CMPXCHG was
+	 * successful, as the old value is written back on failure.  Note, for
+	 * live migration, this is unnecessarily conservative as CMPXCHG writes
+	 * back the original value and the access is atomic, but KVM's ABI is
+	 * that all writes are dirty logged, regardless of the value written.
+	 */
+	kvm_vcpu_mark_page_dirty(vcpu, gpa_to_gfn(gpa));
+
 	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 
-- 
2.44.0.478.gd926399ef9-goog


