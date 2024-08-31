Return-Path: <kvm+bounces-25606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CF3966D66
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9C1C1F21202
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E7E16F0F0;
	Sat, 31 Aug 2024 00:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ksu3PKTO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F5312B64
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063388; cv=none; b=SYNNtJ5MY9anniReysraapWX8gyDeyCJ4PRYFz0dmAt8EQQBC234TuASroQX3pag8HnjNri42xXaZQyAHz9zq/y/h4uqGT5US5c1YMkZLjILd4eDWbs9WfsdkN7C5TkHET3UoITNVIBxdTJPGf8ufbIW8KVqFkz6Ip9qi85tUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063388; c=relaxed/simple;
	bh=wP2W7KNm4uaZDYWeNWlAdBMglkxhSfv/7EU+XUEuEpI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q4fX4kwjUd3aKFefiivmao3t2/qYHahk9s7aKT1qwGx2MdbelPpoKtnct96mz4xDRjQgE6lJo8zDDKXNZqCLGWXvJ2LNxIA0XJeDs5d+rCnVuwsufjd4c30yr44UCNFRUX4SegxyCPkqgG54wKP3P6bPJuyk0znoAy2lVeP9Tn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ksu3PKTO; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc6db23c74so23663515ad.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063386; x=1725668186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gP7K1Sev7aMPsK1RhVpHEhmgUKxxDPKWFSHlKDQHYWk=;
        b=Ksu3PKTOOO4mxuAo6jd9hV464GRAdKdPpv/NZVShb8FV+EIBJH7n4cduy6DLOAtgyc
         Je3KWlcDmVEHo2gI7bj/zw96UV0EDNiXNh+foPKA54kr07ZVkC/fy672Jqp0vLbqNnXh
         UgFZk4Zvu5IG5kq2AoHGtO/4gUCO0/3/c5IwzB7lUw/taTvqBjVPurLsSYai+P2E3D+k
         lKA9ubIk7QKIper7UQJdo5dUvaYoTPFUSLZPssWgF8xLESR96XQOSjNUyRawOAEc7AJu
         NCpVVklH0zp5OPCwf9VqqyybNFfgND5eJIXFgpZm6t/bKQMef8DSHCI6d3R1CizKvoth
         zt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063386; x=1725668186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gP7K1Sev7aMPsK1RhVpHEhmgUKxxDPKWFSHlKDQHYWk=;
        b=anccfzYVSPCVxZ48QvciRCiZtWx7fnF33xCmiApi60ONvcGdBgnXFTK+oCPv+Hg5z2
         8HRo0J/FjdDTCDvvyLZwctyE7X1KKRVOP+h7wphDi0YlrPyHmDkWjAm7XiRwsQg3zNul
         1xwzDq4nwiBio04wfy0sgIOfn/4tgrej5KMgAWz9wtl6+KFJyvuuX2aAQz2il8nhedvL
         rbIbgHtMOLwcYGuPz+/OEr+jLfQwruI01gMdxDVCRqaJoqRJDWRKwWEUODoUDrBhCCkO
         T6xLMnbA0EXX5SJWnyMsI+uV+6xUxrZzF+gnU5tQR+ApijajeSa5+aN6qz5O5alDFf28
         1uuA==
X-Gm-Message-State: AOJu0YwFuVYWib6ktsbpdWN5X4U7LMTB2ATJYfRqidGEp0XJjcY7Hvnx
	po/Zh9RC6GaPBtE9jeNeWpz07HnP47exT8dj6ofOl2aZvcbFQ6pqc+Jzp4f+4rn/wO8qHWHxifI
	0Gg==
X-Google-Smtp-Source: AGHT+IETKE6MP4mUQ/pQIHpSlTqVQLzv82JDtckTBZhGegQc2MolI+RlmMC71D58MpTAuF2igBH8CH7kJwU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fb0e:b0:1fb:7f2c:5642 with SMTP id
 d9443c01a7336-2052764073dmr769545ad.4.1725063386022; Fri, 30 Aug 2024
 17:16:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:37 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-23-seanjc@google.com>
Subject: [PATCH v2 22/22] KVM: x86/mmu: WARN on MMIO cache hit when emulating
 write-protected gfn
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

WARN if KVM gets an MMIO cache hit on a RET_PF_WRITE_PROTECTED fault, as
KVM should return RET_PF_WRITE_PROTECTED if and only if there is a memslot,
and creating a memslot is supposed to invalidate the MMIO cache by virtue
of changing the memslot generation.

Keep the code around mainly to provide a convenient location to document
why emulated MMIO should be impossible.

Suggested-by: Yuan Yao <yuan.yao@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index be5c2c33b530..c9cea020aad6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5990,6 +5990,18 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	vcpu->arch.last_retry_eip = 0;
 	vcpu->arch.last_retry_addr = 0;
 
+	/*
+	 * It should be impossible to reach this point with an MMIO cache hit,
+	 * as RET_PF_WRITE_PROTECTED is returned if and only if there's a valid,
+	 * writable memslot, and creating a memslot should invalidate the MMIO
+	 * cache by way of changing the memslot generation.  WARN and disallow
+	 * retry if MMIO is detected, as retrying MMIO emulation is pointless
+	 * and could put the vCPU into an infinite loop because the processor
+	 * will keep faulting on the non-existent MMIO address.
+	 */
+	if (WARN_ON_ONCE(mmio_info_in_cache(vcpu, cr2_or_gpa, direct)))
+		return RET_PF_EMULATE;
+
 	/*
 	 * Before emulating the instruction, check to see if the access was due
 	 * to a read-only violation while the CPU was walking non-nested NPT
@@ -6031,17 +6043,15 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return RET_PF_RETRY;
 
 	/*
-	 * The gfn is write-protected, but if emulation fails we can still
-	 * optimistically try to just unprotect the page and let the processor
+	 * The gfn is write-protected, but if KVM detects its emulating an
+	 * instruction that is unlikely to be used to modify page tables, or if
+	 * emulation fails, KVM can try to unprotect the gfn and let the CPU
 	 * re-execute the instruction that caused the page fault.  Do not allow
-	 * retrying MMIO emulation, as it's not only pointless but could also
-	 * cause us to enter an infinite loop because the processor will keep
-	 * faulting on the non-existent MMIO address.  Retrying an instruction
-	 * from a nested guest is also pointless and dangerous as we are only
-	 * explicitly shadowing L1's page tables, i.e. unprotecting something
-	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
+	 * retrying an instruction from a nested guest as KVM is only explicitly
+	 * shadowing L1's page tables, i.e. unprotecting something for L1 isn't
+	 * going to magically fix whatever issue caused L2 to fail.
 	 */
-	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
+	if (!is_guest_mode(vcpu))
 		*emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 
 	return RET_PF_EMULATE;
-- 
2.46.0.469.g59c65b2a67-goog


