Return-Path: <kvm+bounces-48896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 321AAAD4640
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD4F73A71A3
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428972D29C6;
	Tue, 10 Jun 2025 22:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P06Ybb3l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C901B2D0270
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596283; cv=none; b=AV4Mq8s99yaIXZQgdWiws+hF/mcPUcyjoboUuCsAvNlSoUahgcwXjvS/hFu0L52kBlmpeBO3wpVMDw1RCt2i1fCyS4UBlBKPZXYKFU3b3VRmZBajRW+Hx5kiIMuEtlSYXxzwJlfnnVGXtX6ANKqJx+7s0ezlF6AjvPWvGqo5BOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596283; c=relaxed/simple;
	bh=Iqk+r0mkPS9wxZN6JLWccuqNll17FPxCguRXZbhZZL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aAKhjSI+ZB/36qFJx3QZQue9whmbB0dGHgpwlUkG757tLUsPr2avqFExOMIBKzZt7P7MuaayzrBRGklTAq/G2W0G7ovB1rhOmI3FVYoldJwVmgT/jSeDjUCJzzhr0czSonHeCGZiS++4lZ84WRgFqdirMDYm3/zaX7MnN7dMAhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P06Ybb3l; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b240fdc9c20so6497388a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596281; x=1750201081; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LP6ms3d+pQenjptncaap9P6op8VHTzn1jsNbIWCvgs8=;
        b=P06Ybb3lGfZ3Xn36djdJSpj4xBkX2zAv/rfJf/9ET4PwhzoeBM40BW9+gGdx9HGbIJ
         WU44CUzeKt6xCavsYJGsvaVpSJkBPGGGKbQUfIHkaOXlV7qd8v3xczTOu5GnvSiujmqx
         WjusO/z6E9p7G7SR3C/+lAL4+ZJHH3zA9i72N+2z1QcWxnoVm3M4lcYP7mL04AHTjDk4
         uIbAoKWk8obMYMhxvTSbQ3n6DmWJDWB0YzHs7S98RKFs9qd4REFPIVRKUGs6lKTS3xU7
         uR7WE1Z6f7gU0TiyQjAE8kOiJdPXhxEuoOXBQiV4o+x3NPqU0Vxbcn3pKVUWVgkumEUM
         xSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596281; x=1750201081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LP6ms3d+pQenjptncaap9P6op8VHTzn1jsNbIWCvgs8=;
        b=O+AB3QFXq4Dg6XuJlWFJsHgTOeps+lKKD5AHiqVSn8xj8q/MWTMvgP7GPvtSZvvmrQ
         QokrJCXXTqdeaHvWX4ntB7veLBVXEUiDq5z4FzFu+PGyY3Aiw/ITIgsMTD+bMVc82fS7
         67F9esj3oDRsyRCXn23LIKERjFpOeQXMx3iCFK3rqr5QPfWy+LaaQR+duR9waWV/3Zdi
         2hydwy1j34aEOrzsJBqgqah3JMWHoKchQNjtnVnsizbm0qLC++Rhi5aBhBBYsz+piaPp
         5A9D7588ESStOq25s+9VKZkt4Sc4JGKOHxaKSzCekS9E9XUfM7SmipxMUTdm/R+q+Sbo
         DgqQ==
X-Gm-Message-State: AOJu0Yzb7Z19GPdSPMdgwCYO8ZQuF9C6OModRgmd32quuBfqmHPeZ6ux
	vlYgH/WQ03qO5qRmqgJoadyp4Umw9CcPClGtPP1By10H8SUmJsxWqraILHDdTiiCUHFZtiiPI48
	QsWcR3w==
X-Google-Smtp-Source: AGHT+IGatc4mYFUGYlCFaTCgqzCToLvrm+7M2KdPuOsDwnyjeWw0K47ZaYSLGJVwirLkJy6Ajwg7/3iAeR8=
X-Received: from pffx7.prod.google.com ([2002:aa7:93a7:0:b0:73c:26eb:39b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9996:b0:216:60bc:2ca9
 with SMTP id adf61e73a8af0-21f86758622mr2105491637.40.1749596281282; Tue, 10
 Jun 2025 15:58:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:17 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-13-seanjc@google.com>
Subject: [PATCH v2 12/32] KVM: nSVM: Don't initialize vmcb02 MSRPM with
 vmcb01's "always passthrough"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Don't initialize vmcb02's MSRPM with KVM's set of "always passthrough"
MSRs, as KVM always needs to consult L1's intercepts, i.e. needs to merge
vmcb01 with vmcb12 and write the result to vmcb02.  This will eventually
allow for the removal of svm_vcpu_init_msrpm().

Note, the bitmaps are truly initialized by svm_vcpu_alloc_msrpm() (default
to intercepting all MSRs), e.g. if there is a bug lurking elsewhere, the
worst case scenario from dropping the call to svm_vcpu_init_msrpm() should
be that KVM would fail to passthrough MSRs to L2.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 1 -
 arch/x86/kvm/svm/svm.c    | 5 +++--
 arch/x86/kvm/svm/svm.h    | 1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 360dbd80a728..cf148f7db887 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1285,7 +1285,6 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->nested.msrpm)
 		goto err_free_vmcb02;
-	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
 
 	svm->nested.initialized = true;
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1ee936b8a6d0..798d33a76796 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -889,8 +889,9 @@ u32 *svm_vcpu_alloc_msrpm(void)
 	return msrpm;
 }
 
-void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
+static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu)
 {
+	u32 *msrpm = to_svm(vcpu)->msrpm;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
@@ -1402,7 +1403,7 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
+	svm_vcpu_init_msrpm(vcpu);
 
 	svm_init_osvw(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9f750b2399e9..bce66afafa11 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -633,7 +633,6 @@ extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
-void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
-- 
2.50.0.rc0.642.g800a2b2222-goog


