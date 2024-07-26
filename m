Return-Path: <kvm+bounces-22398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F3793DBB9
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 681CA288C1C
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D4D1802CB;
	Fri, 26 Jul 2024 23:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aoeOr1kE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E21180043
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038032; cv=none; b=SparJ/kyLaB/dMwNvdlU/4uWb8QVOc0zeUb1vA5zDqYzke9HOKSXOgfFvbHmXiPqfSUm5nKyoZ5QGZwb5DQGM8EwZupw56M0Mz98LBBNbRXcLxbgWHw/TJiPIhcGhG7MQUUmcLbeRQaGSpKiFH/cUe61Po6Fw1RtrZ4OG8H0Etw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038032; c=relaxed/simple;
	bh=RxYXW38TO1i/zpJ/VZw7DD4eCUef7bpZ1SOW7WvxVVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t9amGUHz5rcMD1Ycd3d5twissZUBBuOb2zSi4+u9S13rmmVYGzh5XuSefwf3IonKc/wX92V18T7M/13p2EfHCG+azQ/u0gOL4HwhHEhL0NAWIYMbs8wX/ed9t7j81Tw65ceLtWfGMf3NvA3IGhKVfBz1k5lCQBzSFzk8z76SEbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aoeOr1kE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1df50db2so1368138b3a.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038030; x=1722642830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xse5B7AOfcqAOlY7bR5VB/olShqjuvoHnQg+aILML2Y=;
        b=aoeOr1kEZUS2hBv2Rkn8ifZLZOsxsP1Bv1brvMyrBSyhc1VJSDS4GJD2qLZd4fKGqg
         GLGZb9CmxkUApyCT167eWggqwYfZgCM+z3d0UyGrz1dPbu3vwRhJ9EsymEIy2OPrtnTy
         c5yiogbRA6/8VfhbSRUmh4R5fLa5vHTPnY/26wDkDbIpeahfnjBynbQFFbERdKVId0XB
         zHdsNTMUL0ukBfXw6KG6hYi8pQtDWDOTzAbgbGIIpiudrp6I3noyejDaxyhbsWKqOjYW
         +VaCM/LSCPDW9Nsuvh3DjAIRJpvSHyjdfPC60R8xlWQm2R38kaLFybKV9YDFwk5e0bRG
         Rkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038030; x=1722642830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xse5B7AOfcqAOlY7bR5VB/olShqjuvoHnQg+aILML2Y=;
        b=IRfN8lSGApWs/gDiSNfYzQYGMucHlqHkFpMQUl5x1JKUsnnLqS4nd7FqllPNw3tzD3
         14jxRz5ZiFRoJrZyskZO//JJv/jUaCCiipB2TowrVGSFCN4bbC2EIRd52BG6OdVYkg9z
         T3iWEmmaSKA1P7GXmewTy4cMpY2NGRuV0O2MNvBWZldjfNsmaejmdadVD9iwisEuBKqE
         +VxINLoeaz0PewzVnqSeD+qbhtQImwQRY/Mlb8eO+1IrJ5nrwbxdrTorXP4L2dEsD0HR
         aV/bbvDD79KbfQa0fydDl4oQ2JOIpN/J9L5FfmhsnsOFnR7x6c5qyKQbJy+ckxnjgwaw
         Kckg==
X-Gm-Message-State: AOJu0YxHejU5vJx0uwRImXR/hL+FId9dEy0rS3O36bNCPbnSdd5+OTM4
	dFFeRH/pSLSRibGGcZ8HxiL34dsx0k1Sn04n+zLvXnIo0vHVD4QrmahGWDC4LzWIhw8SyZyETgW
	KJQ==
X-Google-Smtp-Source: AGHT+IEFcNwoZPtxzQ32cLJ1vxa7gkQJVcgltXDXIuLlGv+WV+Ss10kIc9nwtzcNKm3zIIgT6vAGf5Ndk9o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e2a:b0:70d:9a0e:c13b with SMTP id
 d2e1a72fcca58-70ece7f0562mr55820b3a.3.1722038029490; Fri, 26 Jul 2024
 16:53:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:44 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-36-seanjc@google.com>
Subject: [PATCH v12 35/84] KVM: x86: Use kvm_lookup_pfn() to check if retrying
 #PF is useful
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

Use kvm_lookup_pfn() instead of an open coded equivalent when checking to
see if KVM should exit to userspace or re-enter the guest after failed
instruction emulation triggered by a guest page fault.

Note, there is a small functional change as kvm_lookup_pfn() doesn't mark
the page as accessed, whereas kvm_release_pfn_clean() does mark the page
accessed (if the pfn is backed by a refcounted struct page).  Neither
behavior is wrong per se, e.g. querying the gfn=>pfn mapping doesn't
actually access the page, but the guest _did_ access the gfn, otherwise
the fault wouldn't have occurred.

That said, either KVM will exit to userspace and the guest will likely be
terminated, or KVM will re-enter the guest and, barring weirdness in the
guest, the guest will re-access the gfn, and KVM will fault-in the pfn and
mark it accessed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..59501ad6e7f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8867,7 +8867,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  int emulation_type)
 {
 	gpa_t gpa = cr2_or_gpa;
-	kvm_pfn_t pfn;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -8892,22 +8891,15 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	}
 
 	/*
-	 * Do not retry the unhandleable instruction if it faults on the
-	 * readonly host memory, otherwise it will goto a infinite loop:
+	 * Do not retry the unhandleable instruction if emulation was triggered
+	 * for emulated MMIO, e.g. by a readonly memslot or lack of a memslot,
+	 * otherwise KVM will send the vCPU into an infinite loop:
 	 * retry instruction -> write #PF -> emulation fail -> retry
 	 * instruction -> ...
 	 */
-	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
-
-	/*
-	 * If the instruction failed on the error pfn, it can not be fixed,
-	 * report the error to userspace.
-	 */
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(kvm_lookup_pfn(vcpu->kvm, gpa_to_gfn(gpa))))
 		return false;
 
-	kvm_release_pfn_clean(pfn);
-
 	/*
 	 * If emulation may have been triggered by a write to a shadowed page
 	 * table, unprotect the gfn (zap any relevant SPTEs) and re-enter the
-- 
2.46.0.rc1.232.g9752f9e123-goog


