Return-Path: <kvm+bounces-38237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72707A36AB2
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:15:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5F7A7A1F2D
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 225681422AB;
	Sat, 15 Feb 2025 01:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKqYx03f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C764D74BE1
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582083; cv=none; b=h6I183V0fRRFv9beikEOGfN02SFWF+sqjt2k1wPoCf94hTdLUnzCzWD4FDv+FS+rqdqvx8+UQGZdbaw3GSNJwsYK31ApRsTCpzjj2rbm/kgp54rsgmbPulD1HlI852BPMkpFRTwTvqUIF+tialEvUGHZIg5yMtr3wbPgNbvjUhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582083; c=relaxed/simple;
	bh=5xz8jYzPHf6amN47H298De5D9Y9tv1lp18wh8jahuOA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c9d0pVo3l9NXK21docJh4slgN+IkDlis0IrQaoLjh9wKXuIGSPfqT3RVWwTv3lXggX3AKcZL2bNu1QoV8AjlpQTJed2CpHU97JbYpNWHa0CQB8+sxm0PPORtm8bmjhaquzTw3fOlKbrc5+zbkx1A6I4C2FxRRNF8IuKZCtVQLok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fKqYx03f; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso6388075a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582081; x=1740186881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GLdih/SuzIjNw6oPbBJsSyQpCg9vqoYPBoF6JqvqcU0=;
        b=fKqYx03fSRk0KWaQ0vKK7pE93MNuapj66D+iGOq9iN7aAHeo1HTdZ7zbMt3qOIik6H
         tmNi648gvc79IIwK7mZy45a4delXqJOnLrGiEfyhR8CHNDzUa4csuDb91tKA7LcnkIBB
         EQXBPvwtVcO5Q8Lxs+B2MziexU1wJVEhz2PgjL7jUyMElY3Zggrm+Jzjy/9zbStYmruP
         DcjgH7jE/FlB1RhIHbQTsZN5KxFJ26AbVqWcxdChDh2TFc5X6CnNeKy4MHHeiXlsTorw
         GVuBXr+fX1RFCHE4TmOxy/pVmDiwK7hSVkMOtpIER9XY3xWgdvImUFvLlH5opkfQarXA
         K08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582081; x=1740186881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GLdih/SuzIjNw6oPbBJsSyQpCg9vqoYPBoF6JqvqcU0=;
        b=dRJ1/iGDxTzQqeTL6ZYZ7Xte120Uv6U9rc4HQ7Bh+8lgXNL1TOAINxJCI3uxxspVlp
         PvV+8nlDe4NPO+Iz8+SJrK7YnMq00roniotMu+YP5QQ1JjCcWFrCMxFfJcJUgWzJCJFa
         U6PrDt7Lj4L3tCczL2+3szSlnWKVO30Z2/voGPhcyzNmMDTVffTa8DJKeXo1PEbMIzz/
         dIFI3632z9qlKxOlq3Ns/dveM/E5ZZ5liP3D4IOfB+wObIgR6AoYujohlUUFwqXF16gM
         o0O75HwTzMo61AKcPtxN8iu+PKU/e1izXQv+ZyxQfZP/TI0gNtmC8yjzEA3PNef17w3F
         HiOA==
X-Gm-Message-State: AOJu0Yx88SZTDj56RenStxHiolV80KY9PUsNU24Ytvo1BH3AkBGlm9Fe
	KjNEGPVOp8eqSUrwSYScwOQJHj1/D+8VOMUXrVCaeijK+Z9z0X4/GKZ6LamLP5fU77FYTTS/5ri
	Mwg==
X-Google-Smtp-Source: AGHT+IFZUvzAbZYpqr2AjgrHoxhevdhJ9HY2uplUSiVhOtxQe9AbMED3arOME3GI3dmwMldwaM//5r5OIG4=
X-Received: from pfbgb10.prod.google.com ([2002:a05:6a00:628a:b0:731:9461:420e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a91:b0:1ee:40e2:8f51
 with SMTP id adf61e73a8af0-1ee8cc4c56dmr2573341637.42.1739582081022; Fri, 14
 Feb 2025 17:14:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:14:33 -0800
In-Reply-To: <20250215011437.1203084-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215011437.1203084-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215011437.1203084-2-seanjc@google.com>
Subject: [PATCH v2 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Reject userspace attempts to set the Xen hypercall page MSR to an index
outside of the "standard" virtualization range [0x40000000, 0x4fffffff],
as KVM is not equipped to handle collisions with real MSRs, e.g. KVM
doesn't update MSR interception, conflicts with VMCS/VMCB fields, special
case writes in KVM, etc.

While the MSR index isn't strictly ABI, i.e. can theoretically float to
any value, in practice no known VMM sets the MSR index to anything other
than 0x40000000 or 0x40000200.

Cc: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 3 +++
 arch/x86/kvm/xen.c              | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9e75da97bce0..460306b35a4b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -559,6 +559,9 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
 
+#define KVM_XEN_MSR_MIN_INDEX			0x40000000u
+#define KVM_XEN_MSR_MAX_INDEX			0x4fffffffu
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..5b94825001a7 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1324,6 +1324,15 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	     xhc->blob_size_32 || xhc->blob_size_64))
 		return -EINVAL;
 
+	/*
+	 * Restrict the MSR to the range that is unofficially reserved for
+	 * synthetic, virtualization-defined MSRs, e.g. to prevent confusing
+	 * KVM by colliding with a real MSR that requires special handling.
+	 */
+	if (xhc->msr &&
+	    (xhc->msr < KVM_XEN_MSR_MIN_INDEX || xhc->msr > KVM_XEN_MSR_MAX_INDEX))
+		return -EINVAL;
+
 	mutex_lock(&kvm->arch.xen.xen_lock);
 
 	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
-- 
2.48.1.601.g30ceb7b040-goog


