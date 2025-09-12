Return-Path: <kvm+bounces-57472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82248B55A34
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5DAC1D6379B
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA322E093C;
	Fri, 12 Sep 2025 23:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uO0zXof7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9584E2DFA31
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719460; cv=none; b=f0QUCWMH9xXJX2Ju0H3tc+tIbJiNQmJfrUa0XzyGtXPrNtPhiL6Ek+o9aWLXmKwzxthUjsu9iZBJNsE8FH70BFLwEzNs8R9/rCcP9BN8WYXhgeKjRXwK7mtGi2aq7MaVqaJNmK5lDhNoaiwtIHAKMmf/OcHZJD+RSj2JNnvwdng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719460; c=relaxed/simple;
	bh=KUIXASNxskjmqUJOgO/QgQkaUDfDVcrrzNQuV3KF8GE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mUZLo2Y9L+dlwUSXPZD9IiNlo0k/C9GkRbDUEeTTGM/rjttpZkk2SnNjXQfUyJK9yMnJT2wzEQu8j+BRLfkaQ4pmb+naHVIhYWiNkAydQQrkxuxCbU5jryyvTUtsyrYZkOXVnSJSH6lRb4BKJksHoBcKSuOrEwqUM0pMiA4+2z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uO0zXof7; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77253535b2cso2314584b3a.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719458; x=1758324258; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=acVnJCIA0aUw87xnkPi6IWmDTxWY2akxB7SwAIX1iTA=;
        b=uO0zXof7L1cA0Gyt0nxd23qUt5TMxBcs49WTU1YRTflWNnGFTVk5Nv2ePfUbTJ+mJ4
         Iy8xzwcIg/GSuPwfTBO1qK+Xi1mH80plzTKHiI1EOhgArcw8S32ObntRnnUzFjCRmOGx
         i5U24UIYVp64myqMF6egsk+KZDmhzqDtpjcfSqZ90tzcVDmYZDc+ff/NnQYuny32p0VQ
         4JonVZsK8XThK8NWnNYPWg0k/ZFFo4+X+xKbJtT40yuNs/702Ff+wNCYIHTYV3pHCLmr
         g5Uc7hWxnuU0GY+5iiJD6J1EgBDriiD6FPqc6Ttg1kfP9AQhlxyUMUoSWO/P2UIVbihu
         7yOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719458; x=1758324258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=acVnJCIA0aUw87xnkPi6IWmDTxWY2akxB7SwAIX1iTA=;
        b=mn42fpOig+DaJwOuJyiXgwSAAAeKj0CkgEdz0SmnCQcb5voDcwkzNmODhEcFCuChYV
         2ERhTqe4TveK9hSCjhZ4ErSqIpJ2EU9pYVO/s2X7puPuH3fIo9bnZOLOX02EbsZ7PMT8
         L5/OqwdqthSvZKcQpOo5LIIc3Gj3myAMjEFYDo7o4BH/DgDJb/DCmX9Kt3UJT+O59dWa
         vKPbjPA33yZAuKmV9r9vI2L5oZUhoGeFBRmHbtFfawWSkQhzhCeNWG/qkHBAUF/TLlln
         9U15JXGluyC9QamLN4sT6z2cWeJt15IAgvpgOpB/jS1ZjK1ag/6VSy6pntFsVAaarrBW
         3Q3Q==
X-Gm-Message-State: AOJu0YzOhvCyZ5k/EtCenz/P7H0Jqs/XWL24DDDRaPSI+o85xidj68WX
	LporS9FfF+Oidh11PXMavms7ygtJkKkBQXaAb+ZeF2GUuzXEpivNfETzs6b/r/vE+BGeqkzJ3Mt
	fDAvlaQ==
X-Google-Smtp-Source: AGHT+IFaM+VXOKkAtrGu/dhgQBF1CUqwLyK6WuKd4FpXtAapvPhdPE8MhzSUBP9M9ToqqHcMBUwfbMtgHZ4=
X-Received: from pgaa17.prod.google.com ([2002:a63:1a11:0:b0:b4c:2f5f:b986])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e290:b0:247:374:be22
 with SMTP id adf61e73a8af0-260275faa28mr6171128637.0.1757719457908; Fri, 12
 Sep 2025 16:24:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:07 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-30-seanjc@google.com>
Subject: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the GHCB
 when it's valid
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Synchronize XSS from the GHCB to KVM's internal tracking if the guest
marks XSS as valid on a #VMGEXIT.  Like XCR0, KVM needs an up-to-date copy
of XSS in order to compute the required XSTATE size when emulating
CPUID.0xD.0x1 for the guest.

Treat the incoming XSS change as an emulated write, i.e. validatate the
guest-provided value, to avoid letting the guest load garbage into KVM's
tracking.  Simply ignore bad values, as either the guest managed to get an
unsupported value into hardware, or the guest is misbehaving and providing
pure garbage.  In either case, KVM can't fix the broken guest.

Note, emulating the change as an MSR write also takes care of side effects,
e.g. marking dynamic CPUID bits as dirty.

Suggested-by: John Allen <john.allen@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 arch/x86/kvm/svm/svm.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0cd77a87dd84..0cd32df7b9b6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	if (kvm_ghcb_xcr0_is_valid(svm))
 		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
 
+	if (kvm_ghcb_xss_is_valid(svm))
+		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
+
 	/* Copy the GHCB exit information into the VMCB fields */
 	exit_code = kvm_ghcb_get_sw_exit_code(ghcb);
 	control->exit_code = lower_32_bits(exit_code);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a42e95883b45..10d764878bcc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -942,5 +942,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
 DEFINE_KVM_GHCB_ACCESSORS(xcr0)
+DEFINE_KVM_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.51.0.384.g4c02a37b29-goog


