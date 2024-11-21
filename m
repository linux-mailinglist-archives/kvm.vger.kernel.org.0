Return-Path: <kvm+bounces-32295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2269D5301
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A99282029
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46151DFE25;
	Thu, 21 Nov 2024 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c6Wb3y92"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4774B1D95B3
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215214; cv=none; b=ZtRSygUu7rkWVGo5NH23wfKIiqOuI8cM16ySUKIt21e37J6eVy9gSseEiWo3gRythna0gvQbswuAZhnmw+TWpg+HW8PyyPAZLIMRorknwP8gqfONtOzqpoZEfnMSJNRhqXa6N6i2+AyZop4rDAmWBj8ZQi3xpH/otT1zapjDqdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215214; c=relaxed/simple;
	bh=AdrfMvymD5zuRqTBBGGoWNJ0DY8WVGxpVB1lhy6aBew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rj9dWUkcHKpEdyghyXGjR36eEQHyH1i3kzcsu8Cugfwau9J3eR4yyfyPmzcf2dURGBJKymdakoPMtDyO5XyF6gmOJ/ebutK7QVTfCEMEEibf39nsjn6W/XVnRtVCVzlj7MPI+XdXM7lRMkKK5u9kT7phuvs1pAciM1ZYd4qn1dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c6Wb3y92; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6eea70c89cbso14721937b3.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215211; x=1732820011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w7D09IdaThZ8r32cYXtPxjnC2nPk7QEMmJJMfReh37c=;
        b=c6Wb3y92jN9o1wPhx1H+KZtjUhOaBjvDEfYVw+FCK3DHZdtS6/wyXVHkn1aWAbJoQ2
         R1pkXJaSF5eibHaUkPoqxUKHZG/cqM13vXaDgvodrGHxiywJKY/NSVA0YNQ6a+cOh1kX
         RgHGXskBmN0IqFYn0xFDxZVFplviQmfREwjmAweHplMDxCDWjnGsIpRubdCLnEeAeKZ+
         ttEeYWv+dA0CRLP7DrOKbfN7TCvDdI0H7iEbGFMTO4yxqqyqcemDkD8P9Kzg3/9DNCwA
         T7J8MX5oaA2r5QoZjSE3Fy9nJsZ6oaCUtQP7EbQGheA8e1DCPGfnWzqsCdlQyMaCsoPj
         qgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215211; x=1732820011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w7D09IdaThZ8r32cYXtPxjnC2nPk7QEMmJJMfReh37c=;
        b=uy3+lv4AKa/e+8x7F9Pu4c2vmYr+nCing39SkbG8pLXW38zr97Y9qr1Q265jEtX8vk
         szvKScGSQrzh8kAk/sXNIRNkKJe0wdM50ri2mDvqxdme7UK9llMgY77MHOp0aFHpNn4I
         rByBXDlkAfCE1wt861QmpRg9Kk61ANKGJfkr96CrAZkEMhgkADQHs4NF+c39oTAo5nuw
         h/a2hUjjpn886UbTDauLuRwXNE6ZWIByDIessdjUKJNhq3iyIHYXpHrCN3SpCh0iKTvR
         mgv/nny4OPfVL8JCaMb7Fn3jvzi9hwG1pG7nAAitFiL9UlyDJ09qNcRIJM/W9lA9gzPG
         w3Cg==
X-Forwarded-Encrypted: i=1; AJvYcCW2mj1V1oeqhyf+1qdjn5WF0W8Esjc7/fDoVAVJgCd+6+kWmYrODqI9bCvoVX3fI8ProDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxqSRe84BVs6lupF0p89B3b5qyTcrskhGmarVVPFiC+FqV5FLS
	ZG7wZXgBn8sh3e5d0QmcPF62GGfhRD8QiLeSunj/ugzrHwI0e5aBLLgMf7VSio7oa5LiG2U/twc
	0pc/RjQ==
X-Google-Smtp-Source: AGHT+IFbxnZIDPmwz4a6QDx5WTc3XPCOUOGBb+6SCxkWJJgfTYLxgm8qVWZQaaUmH8BKA4bQqcQX6mWx6Kh8
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a81:a742:0:b0:6ee:a2b0:a803 with SMTP id
 00721157ae682-6eecd2b215emr527187b3.1.1732215211264; Thu, 21 Nov 2024
 10:53:31 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:00 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-9-mizhang@google.com>
Subject: [RFC PATCH 08/22] KVM: nVMX: Nested VM-exit may transition from
 HALTED to RUNNABLE
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

When a halted vCPU is awakened by a nested event, it might have been
the target of a previous KVM_HC_KICK_CPU hypercall, in which case
pv_unhalted would be set. This flag should be cleared before the next
HLT instruction, as kvm_vcpu_has_events() would otherwise return true
and prevent the vCPU from entering the halt state.

Use kvm_vcpu_make_runnable() to ensure consistent handling of the
HALTED to RUNNABLE state transition.

Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 931a7361c30f2..202eacfd87036 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5048,7 +5048,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 
 	/* in case we halted in L2 */
-	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	kvm_vcpu_make_runnable(vcpu);
 
 	if (likely(!vmx->fail)) {
 		if (vm_exit_reason != -1)
-- 
2.47.0.371.ga323438b13-goog


