Return-Path: <kvm+bounces-17781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A518CA1A6
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D33E1C20E60
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FEB2139593;
	Mon, 20 May 2024 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vn0rEH0p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CA21386BD
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227979; cv=none; b=lOdmEGIsdxJZ4TZJ3pRZA6rCi87i4icGq7aZLzTHY3PYkMh2pwOcZV1pWOBbNGRcH/ole/Sa82oP6G6yLFfqlCII+1Do8wTRvt3YQVu7UPf64+vZ/Anyzmt0BRPtKTuBXq3JdelD3aeaVjQO0JGgaglcWLvQYeS3H/GV8uUpMBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227979; c=relaxed/simple;
	bh=vF2Yj6737+T5fbLrkbfv86yxNTj8wyqqJ3uxL6wKpGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lYfIMINgzvQ/cB3vi8EQmzefPVAC/hEphBD/p6M5FW0klSmFaVhOWUcDK/VQn6zr94/e0igtvy312TSOExTWzXVuCEoDD5GxtvHz6Acsyjii/6HXI4OTWxY20RsLRXVL8xmtRz+ZmM58bUbDXkmb584DM2NhNKJ83VJRu90PzZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vn0rEH0p; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61e0c1f7169so150262437b3.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227977; x=1716832777; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iMAt8VWgn8RbL2AEggg8DaZQb1WLQqKQrSgsJ/ON8s4=;
        b=Vn0rEH0pZvBODPsX+Ug6nqB8rt28uqYNe3QRGT1Bwqf8PZR+8HO2BPuuseqiOlH3mL
         /bemnJUpJeLmtAD0IoupjFpfR65wN53b324f4n6JsBrxJEg3tH6sU4O6STv1KdaPfhHO
         Mfio7l7mOb3Vr5rFJvGZ5vun4X+pYvnWrodlcfIEizEfo9SDlRdcFEJYxJCiojyNQZdZ
         4/39jfm1iHv/xMqzj3TcSM0luWgkL0v20oLwphAX30wq9yZtoLYEHufH2grYU13Yjtvs
         FQgqT3y0EG9WrC0iPtNroMzYRWQvWKfBWXYz6IDg3wc9lX8Mi7lmg6QxxhBJHuCU1p/i
         X9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227977; x=1716832777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMAt8VWgn8RbL2AEggg8DaZQb1WLQqKQrSgsJ/ON8s4=;
        b=VFfUWeu8aDq3tawl8QtVSl1b2QC5FE/IHimKocNGZ9Gc1QYwcn3UzlBFOXIurfLRGG
         HNKyoDH46El5/c2GF1jt5R6kqWFDwGrR5qvZYOaX3dbHa7HGKLcNZy2/zbL7JIuSrgSx
         U2zOsSQn8dYMBvvSGiSJ1AM5qGHoN9cJjhrQzYJaAxxZvEC3mmjGhmC+oRTd73Bci6qT
         aqtX8PtJEkOmIfWU8WbqCCS/vEVCBq04KgtwnC1PpJQP6I6u56tHuQn4ojwrkvIz68SX
         gMyg6AF3BLqmBLpMcHreyw/8lsBfw9SG5XSc9cZgG5yeomt1sYzvTE3au23kTtWPxP7O
         y9vw==
X-Gm-Message-State: AOJu0Yw9cacO5lg6tvbP4FECAJ+zSL9l+qbaXjlL+vjTz6rkRyTRejpK
	t19Gx9T1SeASu/MrIgJQcZ+z7E8f3t3I27oouKYra4uLiNJa4dIoHB9jExUOWiGw2HXq4+w+Oqg
	RRQ==
X-Google-Smtp-Source: AGHT+IHqN7Po+vXF35tjFtD/uavBNtiFJ0bwZsyAqbKYRm71GxGB2SMq71SviX0dXkXHWhjTRbsLdmTul78=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b05:b0:dee:7d15:e987 with SMTP id
 3f1490d57ef6-df49061563dmr2372632276.3.1716227977269; Mon, 20 May 2024
 10:59:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:18 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-4-seanjc@google.com>
Subject: [PATCH v7 03/10] KVM: x86: Stuff vCPU's PAT with default value at
 RESET, not creation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the stuffing of the vCPU's PAT to the architectural "default" value
from kvm_arch_vcpu_create() to kvm_vcpu_reset(), guarded by !init_event,
to better capture that the default value is the value "Following Power-up
or Reset".  E.g. setting PAT only during creation would break if KVM were
to expose a RESET ioctl() to userspace (which is unlikely, but that's not
a good reason to have unintuitive code).

No functional change.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d750546ec934..32fcf2a81f39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12211,8 +12211,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
-	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
-
 	kvm_async_pf_hash_reset(vcpu);
 
 	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
@@ -12379,6 +12377,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		vcpu->arch.smbase = 0x30000;
 
+		vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
+
 		vcpu->arch.msr_misc_features_enables = 0;
 		vcpu->arch.ia32_misc_enable_msr = MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
 						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
-- 
2.45.0.215.g3402c0e53f-goog


