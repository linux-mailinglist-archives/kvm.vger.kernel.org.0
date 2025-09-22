Return-Path: <kvm+bounces-58388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FE1B923A5
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0364E1905785
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D943115B8;
	Mon, 22 Sep 2025 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KBwpc7Xd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB4311C31
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758558589; cv=none; b=M5M20S7YyRpTDTB/r+zhf3B+gRThVTkrjQm+SNvXAFZGd9vqxroEglbJrKEgenlpdS+VY8Uf1uOwfFa0BPmxjgzpA6JUiRO2vrLsuSK41MMUWiYHGiTlAOhvNKf7T9xG3vrdZjZ3IPoGEzTuC9QvkzKLwu1gYyOCZUscXeXORAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758558589; c=relaxed/simple;
	bh=+AfEV7PHgIu7UmJcTa4KYV/jPHc5HSP/3qgRcJXqG1M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fZHPi4xasOVUr8fIyObJiHaG8XulpjyhLQ8EWDSTRl/KZLLxnR60mKHd+Fw7h+gYGwIKHVpqz0+Wp8pm7mR6CcEk/l2KEECaSJNifIgCbGiZA7W41+K2DEfRS3ImkLIBMZYCLGFUYMyz7cGqMu6KFMTmnRiiVUQ7Z2TRjo0P3lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KBwpc7Xd; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806b18aso55471515ad.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758558587; x=1759163387; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LdozBGYRlBcZqjevMElO/H0w/H7p8NnZnxj5dmMPvVQ=;
        b=KBwpc7XdZHdJIY8IPm2WNMPYZ4AvA2nLVRHBk5qxvvnWGK/MlWONlZv+KmUcTj0BEK
         /QrX/4M28Sh4R0tC5lGXqdradXQxGPGRT6Ax0RgO90PvcpK78oAfQA0RKf8bptNSNyum
         eD84yj/RGpi1plOWxBTt7QXkTUWwAa4/7hbvW8YCwzxfEH8mFNirWLfztbkebFzLQDSF
         Q43ZgJzEqOaaVcYsyXhcWwveBW9Zt51KvwfSPVP5aCLa3TbF79mzJx++6MBBcs0lTNMK
         l3OIiLgHeHOMpjPMm5n+zIi7moCwUFP/ghcC6bZusyWHRWTPq2FnQ2LITY+yV9/9RxkI
         m6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758558587; x=1759163387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LdozBGYRlBcZqjevMElO/H0w/H7p8NnZnxj5dmMPvVQ=;
        b=GfSzF3vxaHUi9XJJMF8KXhJ589YCQDF3GHepJaPmxcgdYMbH8ZYyjYe8t11FWQmetk
         85j8WmOROHMvvc38BzHFC0YgAewwrF4B3SsT6GEx2OIKT7kdZzEpoPZJSvErYMswkhvK
         0Mecps+RT4t0HGnslFIb4i2oTcVVXFpvQqTJ0onjT6wPUR4xUbAJCyvUW7k+1yfSTDFV
         jmL3CYXfa2okRxH3VsT5vXQIwT/sRsV0ffb2CbZs/Bs0f9gpP8FLhsXKBcD3PAn+Fa88
         QURbl8fY7LnXFxX3X2Hxer/OfolRMYIQ/170fJSJXkWp/6O6if7ZV8P4cN9DAM886yhA
         A5XA==
X-Forwarded-Encrypted: i=1; AJvYcCU4UhLHJdF4lNAuzvDSWhMHbVTEdLcjPtEw91xCockOXZUaOL4r3cBzfg1WFltrxOPwndc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2NRfuPBoxJxt9IV/IyhfRpc7B023V/PaBGxiFocCqt0PN00S1
	kprkgtAMt4iHHokTybC76XsG3hV9EyIp0x6DYA335Lp6GnGhNyHZ2dRggS9njQh+Oo5rpRRO93x
	mUvu9SPoE+BRGZw==
X-Google-Smtp-Source: AGHT+IE2Yj2x8TYEvuev/x9ofFF2/xvADz3y3r4CoSUngH1fR65kM003j6GLZK8zR9dA1OhDJKvqJJIryS66iA==
X-Received: from pjv6.prod.google.com ([2002:a17:90b:5646:b0:330:6e2a:9844])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3bcc:b0:27c:3a0f:f066 with SMTP id d9443c01a7336-27c3a0ff0bcmr3616815ad.22.1758558587283;
 Mon, 22 Sep 2025 09:29:47 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:29:23 -0700
In-Reply-To: <20250922162935.621409-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250922162935.621409-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250922162935.621409-3-jmattson@google.com>
Subject: [PATCH 2/2] KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Mark the VMCB_NPT bit as dirty in nested_vmcb02_prepare_save()
on every nested VMRUN.

If L1 changes the PAT MSR between two VMRUN instructions on the same
L1 vCPU, the g_pat field in the associated vmcb02 will change, and the
VMCB_NPT clean bit should be cleared.

Fixes: 4bb170a5430b ("KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 177a9764fb64..9ecdc462e98c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -613,6 +613,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	nested_vmcb02_compute_g_pat(svm);
+	vmcb_mark_dirty(vmcb02, VMCB_NPT);
 
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
-- 
2.51.0.470.ga7dc726c21-goog


