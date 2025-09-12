Return-Path: <kvm+bounces-57444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D55DB559FA
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DDEE1C27A98
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC446286897;
	Fri, 12 Sep 2025 23:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g2Hq5nYv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BC62836B1
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719409; cv=none; b=rSgoGnfTqEMH1PrrkBmyEpyqoRSPK9pdb2K1HolOTwCmDjlL/xB07I7L7PqEnr8/x60zcH3rXONeu+YPZ1TVqeoUCKREC7g5rfOX/LMOs5IVnwE/D4ot49U0gKgQzU+pkJigBKTpp0wzZvpeLEfSFWewin+cxUCwlv49AIU3hVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719409; c=relaxed/simple;
	bh=r7keHhPSl/ZsINgiku4qxCsoIZDRWPCly3Ia9CUnCtM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UF1XYqz+6CKI8wOpgAgvYCwaTD9HgN0LGVgJjqL6FpnqRpzaVD7pXIO7AivMcJ+ueBG0hloTbgCemlXAUDLuq6+8M3ZlpOpeYMh6IMp1c3IMEwB3KRLn7jVRD6dK3Wai08ThvQyG95+ZAseq08avhD44LZ5MfODcH1vZq4UDAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g2Hq5nYv; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4d3ab49a66so3304044a12.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719407; x=1758324207; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2aufua2/8jN63zHyNl5OPd1VmsqwIgjY1xs28jVoYjg=;
        b=g2Hq5nYvywDPeEOIn39Iar5Z3v5QwMY2Gl+ZWnQUgvyk/JS2udb+Zywb/oWL1O5iN3
         cyOQQ9ylLUW/UYgok63vrra0JpDSmF35Tsq4YoNe2Hg16gU76DjxB4VYBPfIoMoFBwTJ
         8MKMCDMfQhnkV2pwNwTTR/AUPERDdvvfPvpJXynMAzAQK9o1eejWS75f66rdOz5SJbKA
         86OagnMcMJt4L8mMNG676gK5RLPCJ/9DPzxJOevxL5fViwbkZJ2qVN60Oy4hJZk3J/sq
         MvnCk3VWFW+hfhTfDtgWMBQKER/iPZClH2JYRxnYgERtx4qkYqlzFHuyun6lr8Xgkx69
         XLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719407; x=1758324207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2aufua2/8jN63zHyNl5OPd1VmsqwIgjY1xs28jVoYjg=;
        b=SPWR2Q4vKBdBfQDHIGf6MiXeQh6U9o6y/TgrdAv6+znJrjdY2J1IbJVFahMTjVG/+o
         I+acrhB/knS8LBfP8+NXeKb9sUPXVTjhqs46qZVmeBZQh0pT1Tym4yWO97taQm2kykud
         Yc/bmDmypWbHCfc4zPqk6tDNg5YBHnkZ/D2nDRVIzPU+a3+HldruA5rUwwWCAfoxzlt+
         CNGJrBh4iZSWpK9Xkx1HsopKiI/ZyGvVUzqY7mkMU1nXf4Zn1RbR86jiufymFfgyTR0g
         XCzn3/1gtpqsxXpAJ1ekVnYz+jYNPrqtbVklFhwTtGwjBhdnJW481RckmxW0e/iC4FJK
         zY2A==
X-Gm-Message-State: AOJu0YzGpiv8KXwOdRUW1CsHkjsIxoim6a/p/e3XZQPw8Lw9sH1IlZgw
	DOmjq7T/QxR+ObHnQgQH4qHouJ1hMFq2esgwGD7Frm3APBb+w/w9AEYqiwSiDCRiBRndxzjp6aR
	CZu/IZw==
X-Google-Smtp-Source: AGHT+IHHzgbw/XBQzAtCVBlNqG134UP+Hxy4J40on9uJ3r+AzCZzk5i/NZAmxAjojr+hxUYoGtUH6MD3BAA=
X-Received: from plbmu15.prod.google.com ([2002:a17:903:b4f:b0:25c:9927:b204])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc47:b0:246:570:2d9a
 with SMTP id d9443c01a7336-25d286014e7mr57345885ad.59.1757719406796; Fri, 12
 Sep 2025 16:23:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:39 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-2-seanjc@google.com>
Subject: [PATCH v15 01/41] KVM: SEV: Rename kvm_ghcb_get_sw_exit_code() to kvm_get_cached_sw_exit_code()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_ghcb_get_sw_exit_code() to kvm_get_cached_sw_exit_code() to make
it clear that KVM is getting the cached value, not reading directly from
the guest-controlled GHCB.  More importantly, vacating
kvm_ghcb_get_sw_exit_code() will allow adding a KVM-specific macro-built
kvm_ghcb_get_##field() helper to read values from the GHCB.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fdd2e478a97..fe8d148b76c0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3216,7 +3216,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 		kvfree(svm->sev_es.ghcb_sa);
 }
 
-static u64 kvm_ghcb_get_sw_exit_code(struct vmcb_control_area *control)
+static u64 kvm_get_cached_sw_exit_code(struct vmcb_control_area *control)
 {
 	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
 }
@@ -3242,7 +3242,7 @@ static void dump_ghcb(struct vcpu_svm *svm)
 	 */
 	pr_err("GHCB (GPA=%016llx) snapshot:\n", svm->vmcb->control.ghcb_gpa);
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
-	       kvm_ghcb_get_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
+	       kvm_get_cached_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
 	       control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
@@ -3331,7 +3331,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	 * Retrieve the exit code now even though it may not be marked valid
 	 * as it could help with debugging.
 	 */
-	exit_code = kvm_ghcb_get_sw_exit_code(control);
+	exit_code = kvm_get_cached_sw_exit_code(control);
 
 	/* Only GHCB Usage code 0 is supported */
 	if (svm->sev_es.ghcb->ghcb_usage) {
@@ -4336,7 +4336,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	svm_vmgexit_success(svm, 0);
 
-	exit_code = kvm_ghcb_get_sw_exit_code(control);
+	exit_code = kvm_get_cached_sw_exit_code(control);
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
 		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
-- 
2.51.0.384.g4c02a37b29-goog


