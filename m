Return-Path: <kvm+bounces-38232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5D8A36A96
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C334C1897659
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30D71624C2;
	Sat, 15 Feb 2025 01:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JUMYj2e8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6537E146A6F
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581577; cv=none; b=SM75OKtOdiAU85IG4HI/7W67oXnWUcwUg1N7N9iAkAMZle7DiU8AEVuCl5Wme5yh/s0xdfDG+M52sP13wY1K8/z99h5ihxFyZ0xH6oR2hRlWc+RmvizdWDlJR5euJGV5BCQA6yPrxHtr8FrhFwJ7Kx02noMfHWZ+X9QFvaIvC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581577; c=relaxed/simple;
	bh=bSuqZiuVhGn+R3CBW88ZrNQnYfX6dqIbqMfitjYCmLM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sHVDsrf5G2H5M0Z0GeLS78Dlh2IxaX4vRZ+sONBijyj0u6zGa4OQSpqomny5lgCaaMkgueSnjGpUC3a5FxiqugVlxxyvzyUAPDvppalZlGsT8nTdYXVEq3Uw00MfVy8SKvQznsgZ1h6/0Jcx8Cs4aPw5qrlfJmcBzWn7ZWj+rP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JUMYj2e8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so1628203a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581574; x=1740186374; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zn5CjaOI/LVKyc7fUHXaWbf0DV9/drzUj0wLJyxdr5U=;
        b=JUMYj2e8ztRB9wvmZJVlppjf51+uPL+5ng/JYFX0Hvn1agTnbFH00Ec/JtXPLJxV2l
         689JmXF7zvRlYOqXYAKHKs8z0Qvcwla2aNXgN6qlmV6IbzT3sMg6DFf8MsIqBnIsc6h6
         Tse6QyqgUOwsoIgR5ggzN5aAFRAchNsND1+jbY6gQCrWtLiXZU08AutYA2Qg6C20eeEr
         Zo4fb3i/qZaz6A0vzgzTIKxi6MNDebPO9ZlxqIM8378I4j3Si4ouTeF7embzUrq9Hzcn
         JhyiAEeRdcXsrD6HGoLpT8cwAJlZFmOveYbkr7L8qVIQfNNN+TUFI0ae4IUU+piuildv
         3QgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581574; x=1740186374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zn5CjaOI/LVKyc7fUHXaWbf0DV9/drzUj0wLJyxdr5U=;
        b=JqmFWZXWhRx7Y9s3tMGvynR3C6LlGN7LYRHaecDdxEjQ+QvMIElhv5wYKjSmqSfIXm
         rWLQ4/jS+N9zvMxbfoNl7tiK3xzQRto6U0r2HRkxxY+bbm2cE72uKH89Jss0fV1ZfzPP
         Z1J83lgrB6NNFMWToKf2YZolDMR8MdSTlLp/f5xpB2pO8AlqqoDaPsOp39Cuy9FyDMSh
         5zEGMxpHduRH+YOsdiloorb6ltbBs1rddh5WErGlvUiEB7mKO3szjkn3Bbz1wyrM+ah4
         epDB2g9Q0XyyyG8rx4suTmTCFhOmpV4sDLLtb90mAwsEluTHILd+M8+6GOOgfeRVOIz0
         apRA==
X-Gm-Message-State: AOJu0Yy1bwL7Bmig9qxIR1grTRZehR+er5F+5MkDiIxq8avfhtyLwVxV
	h3fayKjplwGdyskwU5DuqTrnZ69Dj5ZeMXWlfo+q6plDGyUfwL0Qc9hW88l1P/ToJUBGDbdlHBL
	Fdg==
X-Google-Smtp-Source: AGHT+IFIwMKT3tvPATCPjCIoh5AEF4qKbxWAMxjW2j21dZojwEmwm8bNWQma8rcOLanXENnhrxNv4XpJxno=
X-Received: from pjbpq11.prod.google.com ([2002:a17:90b:3d8b:b0:2ea:5469:76c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380f:b0:2fa:ba3:5451
 with SMTP id 98e67ed59e1d1-2fc4115089fmr1816354a91.35.1739581574696; Fri, 14
 Feb 2025 17:06:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:06:09 -0800
In-Reply-To: <20250215010609.1199982-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215010609.1199982-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215010609.1199982-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86: Rename and invert async #PF's send_user_only
 flag to send_always
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rename send_user_only to avoid "user", because KVM's ABI is to not inject
page faults into CPL0, whereas "user" in x86 is specifically CPL3.  Invert
the polarity to keep the naming simple and unambiguous.  E.g. while KVM
often refers to CPL0 as "kernel", that terminology isn't ubiquitous, and
"send_kernel" could be misconstrued as "send only to kernel".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3506f497741b..0f1c57006da3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -999,8 +999,8 @@ struct kvm_vcpu_arch {
 		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
 		u16 vec;
 		u32 id;
-		bool send_user_only;
 		u32 host_apf_flags;
+		bool send_always;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
 	} apf;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b67425c3e3d..c8e2d905c172 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3561,7 +3561,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 					sizeof(u64)))
 		return 1;
 
-	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
+	vcpu->arch.apf.send_always = (data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
 	kvm_async_pf_wakeup_all(vcpu);
@@ -13394,7 +13394,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	if (!kvm_pv_async_pf_enabled(vcpu))
 		return false;
 
-	if (vcpu->arch.apf.send_user_only &&
+	if (!vcpu->arch.apf.send_always &&
 	    (vcpu->arch.guest_state_protected || !kvm_x86_call(get_cpl)(vcpu)))
 		return false;
 
-- 
2.48.1.601.g30ceb7b040-goog


