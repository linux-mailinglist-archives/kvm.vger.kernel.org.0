Return-Path: <kvm+bounces-23771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 330A394D6F4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FA841C2245C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7D219D88D;
	Fri,  9 Aug 2024 19:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xhJNpf1j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDA119D074
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230245; cv=none; b=HTXKA+tSY+G+9kO8kX+jUlZuPFgt24V3JK4E6UEUuK3Z0DcftMy4ny45rDrxBMCeBC22/S7RWCAnj1yynTMc4jd0rRNtyyFBSdfleoZU+BfJ9D+15qAb1G0BU0khMp5An72K5W2vtpo75O8n15Lt+UPI0lG2S0YiYDVMw9F3zBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230245; c=relaxed/simple;
	bh=rL3+IDQm11patEvsiloUsWqSDQCzY8fDc8KY40xXf1M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EFBUA5fauM2yaEnSkPxljd+9EU3n773p9EyS9cPQNcq3F04YpAFW90WcsSShEI00S4k1yjy+r5jlfr4n2T7ey2knOYgV387sAqdlcGK72Ga/vekcRJNZ2fA8CjZrMoBoEiZcY/kGNMDLM9pFICzF0Q06FvqaQC5cVbBduqk+77Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xhJNpf1j; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70f0a00eb16so2143799b3a.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230244; x=1723835044; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zAoc9f/zQ674f2x3bQLKg9kULz1L+f8jr5RFvkl+QSU=;
        b=xhJNpf1jG8biD/CMsNeOEXm7qfDsq4e/aYc/J8CAoTWqbDccKWylPufMFLRY3K8Gef
         Rqgfmci2qygfNkSXmMAIx1vhDHXmJAFrP0WdGVHdYPeKFfhaKXpjyaInpTgPFTwBGrqN
         PnQ3Z89L46S1KSp3dq0Sg/x5Osi32fys2jhg6YAgs/SGFnP8QivF7U9zVukzeMT5xCBZ
         FgooekYw9Zzlfy+8E99vRavo67yKUpuRPC+kXZOhVSK/7v5s+VHVXBr2E4kfbauCgL2w
         czSsWCj/dV7jpbkEILqadRrvS7S7iFUbQvsAKKCXXwl3DKQfRfT30fXdQ3r8qzTp/fch
         BqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230244; x=1723835044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAoc9f/zQ674f2x3bQLKg9kULz1L+f8jr5RFvkl+QSU=;
        b=JSs2pw5kLSjnfX1l0y1a+quDO36Lq/hEj0kASkrpwyqw4qrC6mtx9CMWgQB/Ua9bC2
         ymXxtqPevCel4ePEmXQUwpj6s+v/lwb7lFlhPm1/LsINKXiNbR7AkjvO3Bvv31kB1rBs
         DjtWj+I0/K6rDchpegtB/EFZyz8fyPBE/SOCB0y+wIT7ZTBf+UGnLI7XzHzChQlppslM
         /Pvu/WSf32bDE+ZxirmOXCIxwCCfn/dPUTq39nAFlS1l3knW+A+CzuSmBghs/xKxkWHm
         sk4bV51GDditJ7IHsdM1Yqmejf0LuB9lQ0sa0ZKRlePwXDYLE8yHGgeQNCkSuN3Q6Tdh
         e5JQ==
X-Gm-Message-State: AOJu0Yxe5xbdaeLqR4Q0sRSl0ftia6iaam+AOKLTy4UbCzJ7FL+E8hO1
	wvegmSHDqOU5Qg8NXtAsDn5qaab3ww/AR4Fi2FMPen05J7sAbxab1AWL6vdnuHvfqmrfrUBQsPT
	T4Q==
X-Google-Smtp-Source: AGHT+IFWWDSkqm0UJUbqcujAzmPwVvL+hZvhhLf0wMFFrRq4oNl8ycj37ldJXO+dIolxfhHFVUMfScjgue4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9158:b0:710:4d39:c8f9 with SMTP id
 d2e1a72fcca58-710dcb62de8mr26720b3a.6.1723230243593; Fri, 09 Aug 2024
 12:04:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:17 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-21-seanjc@google.com>
Subject: [PATCH 20/22] KVM: x86: Rename reexecute_instruction()=>kvm_unprotect_and_retry_on_failure()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename reexecute_instruction() to kvm_unprotect_and_retry_on_failure() to
make the intent and purpose of the helper much more obvious.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 65531768bb1e..2f4bb5028226 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8863,8 +8863,9 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
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
@@ -9131,8 +9132,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				kvm_queue_exception(vcpu, UD_VECTOR);
 				return 1;
 			}
-			if (reexecute_instruction(vcpu, cr2_or_gpa,
-						  emulation_type))
+			if (kvm_unprotect_and_retry_on_failure(vcpu, cr2_or_gpa,
+							       emulation_type))
 				return 1;
 
 			if (ctxt->have_exception &&
@@ -9218,7 +9219,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return 1;
 
 	if (r == EMULATION_FAILED) {
-		if (reexecute_instruction(vcpu, cr2_or_gpa, emulation_type))
+		if (kvm_unprotect_and_retry_on_failure(vcpu, cr2_or_gpa,
+						       emulation_type))
 			return 1;
 
 		return handle_emulation_failure(vcpu, emulation_type);
-- 
2.46.0.76.ge559c4bf1a-goog


