Return-Path: <kvm+bounces-23107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D8A94636A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05E411C21407
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15781547FE;
	Fri,  2 Aug 2024 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O6niLgpp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C741547D2
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722624919; cv=none; b=bcKPAqWrpOkyO+mKwcaqVLTBVSv/tRk9hPr1h5/IALwWKHCPx4dveT/mO5MeGLzmkVa6Xi1qQ3HIbFWLtOIHwA7GSgLXW+oJLuAP+IrjmZpvzZwdVarjKrOybhUBl/vtZ8ENO62wg2pnOFzXSSZOPAuHbCs2D5nix4PMq1cWm4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722624919; c=relaxed/simple;
	bh=mnZrmuWPX5t5ja+UqCYeyUexo17oJVd0vuCAX1ZnhL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ViEcZh/HsW0gTP9eB9kJZm45fGfBejt1lpLHLY89u5YYPdDV5Uw077nvRVhNTmxHWXhZHz85rmBKMnMHojWDMPBUe5uo7JBgMSwnhUHfMd8aY0VQUpqrrIZE9Bo8cM/WaiSr6eFiV7sYfHaixkNCN40asmKT37wuslEMgvA6e+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O6niLgpp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5e1ab396so86394385ad.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722624918; x=1723229718; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EajeKonpCp6o2uEc/AdOOPSf3UouMnnGsvqbuEFiuOQ=;
        b=O6niLgppqygRnW6C4uydYsE3KkEYJJN6bCWkDqhDxCWy77HpKaXhH0dm+eNiCkdRDE
         Kf2+fHpGyrujS/gXDog+21EbmumXbSc/RspukCBp63aQ0LtCoeNZPHPqLXOWUsS9TZ5Z
         f0bj3ypQs9IH5KIBcGyZKZwCGQN4wDt3nz/PCv8WqRSU/lM0LBuFO3vNrToOO+EKB3mx
         GqJKl9EzoUPAHJW6Wb69oDTyl/iT2C30VWQdtBG6gMmnsurUbP4AFeBxQLsf+7t91v10
         V07DB1aLZyjqONURQEgoL6RAED2Q89d67YKGgXC4WlSyOIIS1dTJesMFMFQqFYaS1zu/
         0KtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722624918; x=1723229718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EajeKonpCp6o2uEc/AdOOPSf3UouMnnGsvqbuEFiuOQ=;
        b=rzzcMRgnbdBLbWRPjvMlkrXM7SE6Bn5PVYOSJon5ydZYcIO/76F5Wog1app1g/c2Sf
         oGrR1Ky+NazyZw8xRAVhbcOJw+6heoYImA15k1xoGBmX1DKwxyuc0j6vNxv8m1ZJjwIJ
         nihB1ZdMBEGAEdxgYuhikmqjdAz2v/skY3SbWPIvUmHnPt4U5HgW7PdVLisjC1Y1pB4N
         cS7j3JHFhiV8gFTEVF8PMsjew6DtsmsHLZtI6fuAtSjKa0BPAITolq/mwkYpIaRjZRvc
         S3eS633z4vvSSP3FL0S66AuV5yxdwAMbLXlgSOBif6559KCgrr1od3EE3asu589Rdnz8
         0qpA==
X-Gm-Message-State: AOJu0YzZM4QhJbYoNZOLl+jDeuVE30QclhoCbFNe+9V8XwIoK7JBE2C/
	TIhtCt9UcDExtlN0PgJFPgfV565hqSCTGzkrXimYSXJt9VjfPbPUe59PwJJXU9Xn1qO18hSLk4p
	JKw==
X-Google-Smtp-Source: AGHT+IH4+t9YlrlI1s9wcp4ujmavOTmaJnP3SWsealeFsAcIA1+C7/YLWm0qqu4tVUlW2gwx478HHOJLckI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234e:b0:1fd:d740:b1e5 with SMTP id
 d9443c01a7336-1ff572a81a2mr3170335ad.6.1722624917668; Fri, 02 Aug 2024
 11:55:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:55:03 -0700
In-Reply-To: <20240802185511.305849-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802185511.305849-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802185511.305849-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: x86: Co-locate initialization of feature MSRs in kvm_arch_vcpu_create()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Bunch all of the feature MSR initialization in kvm_arch_vcpu_create() so
that it can be easily quirked in a future patch.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08c3480f1606..9d667c5ab1a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12259,6 +12259,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_async_pf_hash_reset(vcpu);
 
+	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
+	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
 	kvm_pmu_init(vcpu);
 
@@ -12273,8 +12275,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (r)
 		goto free_guest_fpu;
 
-	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
-	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_xen_init_vcpu(vcpu);
 	vcpu_load(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
-- 
2.46.0.rc2.264.g509ed76dc8-goog


