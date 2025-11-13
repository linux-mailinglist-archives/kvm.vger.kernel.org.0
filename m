Return-Path: <kvm+bounces-63068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6425C5A6DE
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 852943B3EE1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3152329C69;
	Thu, 13 Nov 2025 22:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AocFHH2/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D95B32695C
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074599; cv=none; b=qie+vHNNAL6hXzlfl2BhiNpsiYCdIrVT9Q0GPjLFeQfkpjMgdG5ctmBf2EH3/3qsecUvbTFXNRd1F5YGBSvCEohS6ugaMgaCpcZxCBhWnxGhbFxfo3cdZ/AbU7zkb2nLUdYwAV/uWh5xs3qO+1dbr99ho/cI46rrgsWVfDBB730=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074599; c=relaxed/simple;
	bh=0CIm1vKKJY5ZLYOu6NiJGAw93xER85gCl/NfVvEElD0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XcH4oOjrVAlivgx3nGVuVcNZ0koM8qpUFftP01uzRCCbjBMz4mLKkcgZiG9jBdI7y55Sj+SfaGMK/b3e421f4WWgeOzMGSNzGzMqUzxGw/AA1eEhf0AxG0HviTKEM1nKD4RNN2fLsYgKobS1MSQ/IkS9ShucA4ISg1X1cIatE2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AocFHH2/; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso2769245a12.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074597; x=1763679397; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YmRUHznDSpJK0xelbJUhvMx/o3h12zh1VqONC/F/8SI=;
        b=AocFHH2/3i7UUnauc5KbKfhWgajO9G6MONneNdnFsln9FCxkri3F30Z3aIIzm0Xbvj
         62MRjHQwwRnwRpwRq72YNwQIZahjCCCZ5mpXLZeX1pJ3vTuf/1oxNYgAVwreDDzT0dzn
         VP8M9YdLA6/p6SqkO2dZMB7KglcDUPFIIb78ffTYp+BJzV6nOleUQ/n547x2B9umQNF2
         P//eZacShUgtNDAak0qSyvCOFbo+N5HXZ/RtvFZFofMGlFnqwO0ZYU3BMl5e2B4fl5GN
         Z0Wg5XK4nAwCkuaGRoExRtpJavLJ0MyJ3GSSQkuAZDrR6veAI9LgY3ixlg3G7HGlCiNz
         ytVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074597; x=1763679397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YmRUHznDSpJK0xelbJUhvMx/o3h12zh1VqONC/F/8SI=;
        b=k71RcbOk3e3YfVfrA22lxP0jTm/b9dfekarV3ncuWyYYHmhnnzmox1Eo36InG7dGn+
         SJuup20TfqLaFZNUYw4YjnavGrks2kPXs3qm8fjRaPaeusJvvJmeR7JTMkgy8GCZ0qZc
         SDVu9pPkiu6U73myJ1Onxq+yVkqINVZ7y5YRcij4tE4etTLr2LQf9pnkPK95g9nwaC+i
         wcWCiZ0z2PwBFc1hWTwsmNQmMLceiMNVhGIZMeFJYIui85WWARnwIi3dCoKVoXKsOghs
         VkgJbzm4XCBkhnO3to6QCCiPeAxdnE8/wAk+v0qDwZvV8m5dB5g5DdpEDkpus+t8Y8JU
         Lecw==
X-Gm-Message-State: AOJu0YxbOBTGyskSE4lkzhmEk9tZ23e+ltf21QSr0sKojaihgbApZ9r9
	Z5JfdEMvBhfMQXm2+ykQd2ZfmrKXcTOHYltY8NQ4GuJ8KRzGs0CNiLqhaFN7k3yi+ZpCEnsXcmq
	D2ELmZw==
X-Google-Smtp-Source: AGHT+IHtz3Opt/igSZsRzu0/BD9t+30LNZaNdqDEY5l03VcfbOrCZ8LxD69Ny8ODDjVmq8xM/VyGmM41VdQ=
X-Received: from pllb17.prod.google.com ([2002:a17:902:e951:b0:268:c82:4230])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:18b:b0:295:8c51:6505
 with SMTP id d9443c01a7336-2986a741aaemr6849745ad.33.1763074596938; Thu, 13
 Nov 2025 14:56:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:17 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-6-seanjc@google.com>
Subject: [PATCH 5/9] KVM: SVM: Check for an unexpected VM-Exit after RETPOLINE
 "fast" handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Check for an unexpected/unhandled VM-Exit after the manual RETPOLINE=y
handling.  The entire point of the RETPOLINE checks is to optimize for
common VM-Exits, i.e. checking for the rare case of an unsupported
VM-Exit is counter-productive.  This also aligns SVM and VMX exit handling.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 638a67ef0c37..202a4d8088a2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3435,12 +3435,6 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 
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
@@ -3457,6 +3451,12 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
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
2.52.0.rc1.455.g30608eb744-goog


