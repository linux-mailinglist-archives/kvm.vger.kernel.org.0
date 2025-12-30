Return-Path: <kvm+bounces-66860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80691CEAB27
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5169304568B
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A420030E0C5;
	Tue, 30 Dec 2025 21:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="swrQSEnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD3D2FCC0E
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 21:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129238; cv=none; b=KY0MtiSZJlO1hJ5oZikvTpt5gFlIR9l6hl4s+Gcg/nQ25/Ip339ZCml9jhTSQYOxifhwEyIGczJI9STlgpQ9IKJ/8v7cgHsinu0U8joUAv00jKm6JiEyKWoy46Ms8VogtHrVhG1T/pJihNe0r2Ps2zwxKq5u1WVFhZSbFLWLIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129238; c=relaxed/simple;
	bh=dFYvwKO0rAM5gd+DQa6wT7749+Cjr6pisryKGAR8XHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UG/MUzGYxCHSMwKp4Zbbajg33/GjeEY7rLhKpUZwhgmsJmpsz1PIm5LXiUgAARGScl2az3YQ9wntrdG+stbHJskypHaU0T1WXgu5p9x0GSu4ELhEu10xQX2Wvl2sHuS68RCmfWVlH2k+A8M0PLfap8f0bUW4HiWN1MrAuC2HdtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=swrQSEnX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f2381ea85so218607925ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767129236; x=1767734036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OP9hotpCQrsVZqE8v5eRxWNMJZgi8k5mDCW7kmyDFTA=;
        b=swrQSEnX12C3++X4mU5FO25yCDLIaVsgFNv8gPCgdAsBePsTO9fQgoBerVBSje06y5
         STgaKGOWQdDhyCvrl7lNTsXlGWFUBVZDh3l0x2K0UQLiZoZZoGPLZEbell3P5Hkb05Jx
         yEPRA6X6o9ZejCPZuoddf2kcUYmZe572ThMN1fh6QA5/z8XxrkVnED/+35bQMu79jNBp
         +wdlox8HSwv2SyXKaMneaVnevTSVomvjUOY8RG7CaCtiVXWy6xC0xbnTnGHZ2XSZLROb
         8xSynvtZxkfWdcpOpQl6fP4MjVLH7B1CdSD8aLIW7GAQOEsW0gnQpHyzVv0nUC/5loEl
         Jmtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767129236; x=1767734036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OP9hotpCQrsVZqE8v5eRxWNMJZgi8k5mDCW7kmyDFTA=;
        b=K0cLdpvdAk1zBe+DfE77cVDziRzoBQ7EqNdjzFzC4zY6b8tGY5jhpv4/vailZTtDSa
         t17x3T6qWvCzFELEq19FXqn3XJA4qD3uTj9nZtGMeslxodqdw41iCb8nGW/Q4py5UU8n
         AV5AcusT19EUjlwptUBnfTPvudD6wHfvt7n9kRiGnkgbxid9dusORf6zTmYFDgIl4UkE
         KUGYOil3Ol9m6sNBY3K2iUMCtMV2Wp6hm9ltVjnxEz5R0A7ty9ChTX+41DmJLao0ObF2
         cQe607ac4P3PeVI5CV9cRPcdQXBtz22xgwvV7Ga+0Xhg7Fzj86O12UZL2IFUnYI9WrRF
         2jxw==
X-Gm-Message-State: AOJu0YykaAnPQ/YJuj+TMQ8KhZbPww4pGRJKSRFMoVP2xnfsV48/p8i0
	x9BTv7yGtlQQGEgt7XqGwaI89ADFFyWKxUyooPXe+1UYuprJ1OBpxLwhhM/OY/lgXY2CDQDQBH2
	W8fO11g==
X-Google-Smtp-Source: AGHT+IGUJEnlpUD6Gd1YvivFP9uFX0/uZZ/iPrK157AWfRyC2+k/meCq+u7wH7O0QvzOvD9z3tsbRw5bG4o=
X-Received: from pjbqb12.prod.google.com ([2002:a17:90b:280c:b0:34a:4aa7:b774])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f78d:b0:2a0:c35c:572e
 with SMTP id d9443c01a7336-2a2f2836480mr346664485ad.30.1767129235953; Tue, 30
 Dec 2025 13:13:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 13:13:42 -0800
In-Reply-To: <20251230211347.4099600-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230211347.4099600-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230211347.4099600-4-seanjc@google.com>
Subject: [PATCH v2 3/8] KVM: SVM: Check for an unexpected VM-Exit after
 RETPOLINE "fast" handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Check for an unexpected/unhandled VM-Exit after the manual RETPOLINE=y
handling.  The entire point of the RETPOLINE checks is to optimize for
common VM-Exits, i.e. checking for the rare case of an unsupported
VM-Exit is counter-productive.  This also aligns SVM and VMX exit handling.

No functional change intended.

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a523011f0923..e24bedf1fc81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3445,12 +3445,6 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-	if (exit_code >= ARRAY_SIZE(svm_exit_handlers))
-		goto unexpected_vmexit;
-
-	if (!svm_exit_handlers[exit_code])
-		goto unexpected_vmexit;
-
 #ifdef CONFIG_MITIGATION_RETPOLINE
 	if (exit_code == SVM_EXIT_MSR)
 		return msr_interception(vcpu);
@@ -3467,6 +3461,12 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 		return sev_handle_vmgexit(vcpu);
 #endif
 #endif
+	if (exit_code >= ARRAY_SIZE(svm_exit_handlers))
+		goto unexpected_vmexit;
+
+	if (!svm_exit_handlers[exit_code])
+		goto unexpected_vmexit;
+
 	return svm_exit_handlers[exit_code](vcpu);
 
 unexpected_vmexit:
-- 
2.52.0.351.gbe84eed79e-goog


