Return-Path: <kvm+bounces-25603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC151966D60
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67059284C8E
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71CB81531EA;
	Sat, 31 Aug 2024 00:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fhaWi+E1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03314A4E0
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063382; cv=none; b=GgoKIGIz4lbie+pwVDr8u99dQNHOAQMKXPvvf4HVUPaNLSwipHnjshlqcYG+C7NYxQWQZlvqIlkgro6snVoq77K9yioATUQ9BG3fuI/lDEC6vnsAaRj6r/LbUIK2tZguT8+IJPu/c9mXzKhgRoslAN8lN6UKF4JgrWGzaWR68S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063382; c=relaxed/simple;
	bh=ccmI6fgXaS6ULZCMeBWyQaXyCbh7+cmAtQZQ72hgJko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OW2ahEw02ZCqEMpsyqCLIerXSnoIj2fUcMEUPTKQNtQCKH1gWHot1akOLrhvib4QwpOPof9x60dGZxZyaEATxtoTkNMOUW4Xvw4lYk3rogRZRRU2e7bni5tj9DczWfqzyRgqV2GcXMplTjHm5GGXla8FfPAdRI8nG4VUkgKgLX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fhaWi+E1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b41e02c293so46031427b3.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063380; x=1725668180; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=heJP/gE8sNgyHlf3GBWAi72kmE/mtNKhFddnYBUVTOE=;
        b=fhaWi+E106CCFd5rgQtGX4joRjEjC0gmVzUlr+pTI5dSIPC7JrJoYsPFdc4PK8EFVt
         XKXw6KPkvSrYdFC0bNPtLpxTtE2paLsNrSHNoEBHfzjBpw1IvHmlx75IkqFufOKbUJlI
         yv6wHagtf98IUSXyoXqXnzxkz+mTcwh4Y++lnVlKvXKheb21V9q5uTXhbZuTZdw/tUfI
         cHZb8vH+y3lkUZGxXWS7YQ8+VLvM1ntiaFdNR5/U+Ofc5CHqNAMyvUnmKSVyD8NkJvVq
         VszHbjvT4g/Oogn1S/+m2xKGKbUpQmRYML14h48qy2b/DYAGRUTR9/8Jfo5i6nqD4V1A
         pWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063380; x=1725668180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=heJP/gE8sNgyHlf3GBWAi72kmE/mtNKhFddnYBUVTOE=;
        b=Tj9h5nPEYYkR0hWsjtf4DgU4ldV7/5PdrKZ6XEkWJWMJy/qTBdVj7IdzFPQ81lZYFb
         wqlvwgnYT604viu3e2GdRqjZnIgl9Ea5WVfjDFgXgKlqzSO+38jB6o5HjEDYzlUv8sgB
         0W5luVEbnDm1A+rm1SJXTxbZJhLHsAAWjtVnmQ9J12OfATnSWF9mcDs8nxdYQ290DLSg
         O9t1lOk5mM3W4bPMEN9bQP+qw+mn8eJjQlvopEqwWK7xwFZyhg850GzbNfQj3ovp9m4e
         9ckGUJeoRM/WlOAjJ/5IegLcUTolMp6Tx+5U2+iKDCB9GgOeW/zf9/5bWwEGc3qDAXTn
         r//g==
X-Gm-Message-State: AOJu0YxR+1fpTKPzOHxXqmnYNpbEXhignVW8ohObJpiD/wbBKpfE1c4/
	sgd/nGioB1xB0yTMlkOuxrsptxLDMm2HxcNYnA/bwKOBRlhA4Fe872fnGftvSh+jLk6tFV5geSm
	9bA==
X-Google-Smtp-Source: AGHT+IHiBKbgkYqyJRDMcIF9+XogmVSPipW/TOpEzV4NmLy2XzHmDX3Zwx+y82tht7UQeTFU4iZAMrMnrmI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6103:b0:62c:ea0b:a447 with SMTP id
 00721157ae682-6d40d88f5d9mr2178957b3.2.1725063380216; Fri, 30 Aug 2024
 17:16:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:34 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-20-seanjc@google.com>
Subject: [PATCH v2 19/22] KVM: x86: Rename reexecute_instruction()=>kvm_unprotect_and_retry_on_failure()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename reexecute_instruction() to kvm_unprotect_and_retry_on_failure() to
make the intent and purpose of the helper much more obvious.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 081ac4069666..450db5cec088 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8857,8 +8857,9 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	return 1;
 }
 
-static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-				  int emulation_type)
+static bool kvm_unprotect_and_retry_on_failure(struct kvm_vcpu *vcpu,
+					       gpa_t cr2_or_gpa,
+					       int emulation_type)
 {
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -9125,8 +9126,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				kvm_queue_exception(vcpu, UD_VECTOR);
 				return 1;
 			}
-			if (reexecute_instruction(vcpu, cr2_or_gpa,
-						  emulation_type))
+			if (kvm_unprotect_and_retry_on_failure(vcpu, cr2_or_gpa,
+							       emulation_type))
 				return 1;
 
 			if (ctxt->have_exception &&
@@ -9212,7 +9213,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return 1;
 
 	if (r == EMULATION_FAILED) {
-		if (reexecute_instruction(vcpu, cr2_or_gpa, emulation_type))
+		if (kvm_unprotect_and_retry_on_failure(vcpu, cr2_or_gpa,
+						       emulation_type))
 			return 1;
 
 		return handle_emulation_failure(vcpu, emulation_type);
-- 
2.46.0.469.g59c65b2a67-goog


