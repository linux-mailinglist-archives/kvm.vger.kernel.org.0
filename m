Return-Path: <kvm+bounces-63065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 456C1C5A68D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F95F3A6B5A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E479326940;
	Thu, 13 Nov 2025 22:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M1btft1o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD0F3271FB
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074594; cv=none; b=DZx0VmflxOHy++L1UZKNAo5D4QeHZ4Xq8lG/bOg7zYAamUKF7weJ0KMwGbJdU9Lcbc3Nzr6nQppY8YX7KKYC0csGlq5qi30tgxweKe6pGdGGl5i1IhYyY1u5mGn21yRP6uzhqkpweGpbkSsWWFm4iS96L6p8TxvC4o0bdW044+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074594; c=relaxed/simple;
	bh=dooIsaMHUN0qX+ajs8N5jkyY00eEMse5x1PsDaesgCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=awpmXJyEBUpdo1paLjA+lP/stilWGpQu3DVOCQbSWNaOkj03h+SGVIK03ZJt/tv7jxM6qEXQBBev8T07EHTeyZua9SqdngP/jiJJM3/1+d5BuNvumLkk9tekqQKGG8rLwrb09tApLdxo2Y6WFRmzShzpSUzS2fw6zb3AKyl0Gn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M1btft1o; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958a134514so17799605ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074592; x=1763679392; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTfLPg3dHJBu/ZKUp1ze2yjCBpHKVd90r/rQFmyW4xA=;
        b=M1btft1o5Tcm9ACBdEOq9U3KnJOBB+220wcDFk/m0pc+Cu5OZIZ3+gvyfFvuoihwS5
         nZJCUi9rPrEdqSHtTstzOIatR8CaaS8rUI7yrqLvzY85PzHkO+d6CT4QMQx96GgUc+UH
         /YAuV3lOt+1UJn+EAVcg1RecfYKAA098/nnlAjucI5ysnjJL4ULhh8mzQiuvgs28zKdZ
         KTz/cAsfocuL849pS7iQ2hA2nts/0iTFFmxpCdAW2xR3FqYFSjpV4dSAt61Ft4lZKRkD
         wqKDbUTlrqgQ1eQmtRs25II+lKaSGk4x9wwjPSxjJXe3w5JDETP0yfMDsywM4Wb5U2zZ
         V0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074592; x=1763679392;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uTfLPg3dHJBu/ZKUp1ze2yjCBpHKVd90r/rQFmyW4xA=;
        b=AjO55PqqaQcdUEUBWzXLjhhFdBSWiWKhJAWahEdNuWf8QBHRqT00eP1HxANw5Y4QzY
         hLZfr2XfaCOzbQbJ/TGN4Ayq4Tl6OjLXKxsgFeg0JIYmuBVUOzbJddN1pNeVuNV0PGrD
         DYrzv2ORrFU5N4GwA7K5jut2DKCMRRFuBP2XyLKLD9Bm7X/+xPhecLY+Q9E22ey/GmFK
         nNladOYTgRY+vK7i5kuRH4z0BrejPi4tcYaYJBfSCOlA1SfM0wKxQeKg7rmwZJIfgZo1
         9iFA+kkU35/JJo4WWSnMfuWDC+d71VXd48TKYCa4hSkLKgRlprtPd1B+il60eHaV+MwK
         xscw==
X-Gm-Message-State: AOJu0Yw1qHD6dyQMRxGV1hn2W1PrJrQuRtGaGOt6ExvI8sHHhJyPVKyf
	DxIyX81U4AvcnBFIU/MZ9YfHM4DEfoLik3NAU1Qo07b0Hi/B3UElEePOxtyOIIpTycuenHWwWHg
	GcDMK2g==
X-Google-Smtp-Source: AGHT+IGqaleYBrBpIZDDEVOSXWg82pvZBfh9IfeZ7WNXzFngQTkVikEu8YA5GvKWL3ExVT05ZqFLMjWDxSE=
X-Received: from pgnn15.prod.google.com ([2002:a05:6a02:4f0f:b0:bc2:9d07:6db1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2406:b0:295:24ab:fb06
 with SMTP id d9443c01a7336-2986a6ceb22mr6800465ad.22.1763074591763; Thu, 13
 Nov 2025 14:56:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:14 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-3-seanjc@google.com>
Subject: [PATCH 2/9] KVM: nSVM: Set exit_code_hi to -1 when synthesizing
 SVM_EXIT_ERR (failed VMRUN)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Set exit_code_hi to -1u as a temporary band-aid to fix a long-standing
(effectively since KVM's inception) bug where KVM treats the exit code as
a 32-bit value, when in reality it's a 64-bit value.  Per the APM, offset
0x70 is a single 64-bit value:

  070h 63:0 EXITCODE

And a sane reading of the error values defined in "Table C-1. SVM Intercept
Codes" is that negative values use the full 64 bits:

  =E2=80=931 VMEXIT_INVALID Invalid guest state in VMCB.
  =E2=80=932 VMEXIT_BUSYBUSY bit was set in the VMSA
  =E2=80=933 VMEXIT_IDLE_REQUIREDThe sibling thread is not in an idle state
  -4 VMEXIT_INVALID_PMC Invalid PMC state

And that interpretation is confirmed by testing on Milan and Turin (by
setting bits in CR0[63:32] to generate VMEXIT_INVALID on VMRUN).

Furthermore, Xen has treated exitcode as a 64-bit value since HVM support
was adding in 2006 (see Xen commit d1bd157fbc ("Big merge the HVM
full-virtualisation abstractions.")).

Cc: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c81005b24522..ba0f11c68372 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -985,7 +985,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (!nested_vmcb_check_save(vcpu) ||
 	    !nested_vmcb_check_controls(vcpu)) {
 		vmcb12->control.exit_code    =3D SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi =3D 0;
+		vmcb12->control.exit_code_hi =3D -1u;
 		vmcb12->control.exit_info_1  =3D 0;
 		vmcb12->control.exit_info_2  =3D 0;
 		goto out;
@@ -1018,7 +1018,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	svm->soft_int_injected =3D false;
=20
 	svm->vmcb->control.exit_code    =3D SVM_EXIT_ERR;
-	svm->vmcb->control.exit_code_hi =3D 0;
+	svm->vmcb->control.exit_code_hi =3D -1u;
 	svm->vmcb->control.exit_info_1  =3D 0;
 	svm->vmcb->control.exit_info_2  =3D 0;
=20
--=20
2.52.0.rc1.455.g30608eb744-goog


