Return-Path: <kvm+bounces-48915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9826EAD4663
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 544A41895073
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AC82D2FF3;
	Tue, 10 Jun 2025 22:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bPPtYFuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EFC28A1DD
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596315; cv=none; b=tRv23WpbSAIBrN5dsmI6L5zeHZS3GbWAu2Bd2BJOf84YyMlDEp9ujtJ39p5zQ/b15yvf0SGTIw70CElIZtFEMJzIFr67q1Vi5OvBJ0t0B2/6QI4gEyetgqVkEA/bvkSK429BU2XNrRaT9oLTxHK6k7no8kHYWTZnS+SmoQyjglI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596315; c=relaxed/simple;
	bh=jiZmlQeeZHjv8j7JWaCkYOsUvUOPi3J9ClLWUxwWMQ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hSE3oRreAJ9qStrOsjtn30HW3AiTUeSonVa4xvexo14KqJQvkRW/ipiYFa649nuht4S6n9q9w84vqUl/fM+KDJVt2UGfiBlBdlsKO3RnpdJo8/Ce8rUgTgMUzIQwRg+fUAVPEp7qyU7YYkTAvqcP3JFJ28u/9SUc4KhwTe+9N1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bPPtYFuJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2323bd7f873so50432165ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596313; x=1750201113; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=izOjJ2HeWMTKGvvKPd+weoqGV6BoeCSaINzg8XvWVDQ=;
        b=bPPtYFuJjUpw01SILGj/p3x0pfYSoXpbP4gQLsbYxsvtlggpNDh8vgvQusIjwjc1UG
         gKX6So54HjT/f2rYgfH8k3WxFMeNPNIQZTwtAOaQDtWPwHMchXndxRHPKP0z+whkaaHW
         yPuvC8Ui0cd+FEZ4gc0QFgeO9lhbocWgL1O3y27KNhFbN1576vOtEJsUIMI2cUjPjLxk
         64/P52I/IncG0H6w7dV3oacdOS39xfKtghGdjDFvtHNimtfcySePtfWMdbttf/OVfqRQ
         H6sA+dv0LGShPElwt+ykxzYoCWIq5NT/3x73bWNH8KE8p+jxb4CxkwPQuoE/EfEX6IOH
         hRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596313; x=1750201113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izOjJ2HeWMTKGvvKPd+weoqGV6BoeCSaINzg8XvWVDQ=;
        b=L+mcD7SKRqVY8yaRjJX+jbxuPhK1bpo3kKimPiA+4ujnVBN2Sbc6+Oev4Igh282Gp5
         laEMpIrPiPs+vnwiFuqF39u0kb9n9SMkwmWPbEYoSrWj09nsQ97LXfnry2I9kfnDYtrT
         IHWZ9eH6GPH00ef6Z2aY2JSOM7g//m3foblx3jUIngdPqh44MVTKfHuO0aC5YgQk1umL
         jrTHHbESTQtyadMF/i/9KsQ2bnnf/MKcFMct/u6P/cvuR5bKJ4T1tVYb25EljlW7nKq8
         CXXm8ymfGSYRh3gi8x7vTDVo5NrSQmzw1pJYg+9LqlCgrM85K1Q9CF7jawAMwEGcvmuT
         t/uQ==
X-Gm-Message-State: AOJu0Yxr+IifHRLrogYGi/alWmXO+e1HSbi9ah4xZZZKNkV2XmWNNMQL
	OftNbPqG57HA66qjqluzzuiovm6P9KOqBgQREbGGcts7iyFW8CFVAQgQyBSdyz8je1zfAinTvyG
	J8UGz5w==
X-Google-Smtp-Source: AGHT+IFGOj6HuWIr46kZTUddMM4ANW6v8OEb2ufDZkJPU2sF80cAp+a0btxYkhyYdPaDQ3eUlWL4PqPkgXg=
X-Received: from plbmu14.prod.google.com ([2002:a17:903:b4e:b0:234:d7c5:a0e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32c6:b0:234:9052:2be6
 with SMTP id d9443c01a7336-23641b2919fmr13630285ad.41.1749596313412; Tue, 10
 Jun 2025 15:58:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:36 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-32-seanjc@google.com>
Subject: [PATCH v2 31/32] KVM: x86: Simplify userspace filter logic when
 disabling MSR interception
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Refactor {svm,vmx}_disable_intercept_for_msr() to simplify the handling of
userspace filters that disallow access to an MSR.  The more complicated
logic is no longer needed or justified now that KVM recalculates all MSR
intercepts on a userspace MSR filter change, i.e. now that KVM doesn't
need to also update shadow bitmaps.

No functional change intended.

Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 24 ++++++++++--------------
 arch/x86/kvm/vmx/vmx.c | 24 ++++++++++--------------
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e3c49c763225..5453478d1ca3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -691,24 +691,20 @@ void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	void *msrpm = svm->msrpm;
 
 	/* Don't disable interception for MSRs userspace wants to handle. */
-	if ((type & MSR_TYPE_R) &&
-	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
-		svm_set_msr_bitmap_read(msrpm, msr);
-		type &= ~MSR_TYPE_R;
+	if (type & MSR_TYPE_R) {
+		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+			svm_clear_msr_bitmap_read(msrpm, msr);
+		else
+			svm_set_msr_bitmap_read(msrpm, msr);
 	}
 
-	if ((type & MSR_TYPE_W) &&
-	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
-		svm_set_msr_bitmap_write(msrpm, msr);
-		type &= ~MSR_TYPE_W;
+	if (type & MSR_TYPE_W) {
+		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+			svm_clear_msr_bitmap_write(msrpm, msr);
+		else
+			svm_set_msr_bitmap_write(msrpm, msr);
 	}
 
-	if (type & MSR_TYPE_R)
-		svm_clear_msr_bitmap_read(msrpm, msr);
-
-	if (type & MSR_TYPE_W)
-		svm_clear_msr_bitmap_write(msrpm, msr);
-
 	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
 	svm->nested.force_msr_bitmap_recalc = true;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bdff81f8288d..277c6b5b5d5f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3962,23 +3962,19 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 
 	vmx_msr_bitmap_l01_changed(vmx);
 
-	if ((type & MSR_TYPE_R) &&
-	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
-		vmx_set_msr_bitmap_read(msr_bitmap, msr);
-		type &= ~MSR_TYPE_R;
+	if (type & MSR_TYPE_R) {
+		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+			vmx_clear_msr_bitmap_read(msr_bitmap, msr);
+		else
+			vmx_set_msr_bitmap_read(msr_bitmap, msr);
 	}
 
-	if ((type & MSR_TYPE_W) &&
-	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
-		vmx_set_msr_bitmap_write(msr_bitmap, msr);
-		type &= ~MSR_TYPE_W;
+	if (type & MSR_TYPE_W) {
+		if (kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+			vmx_clear_msr_bitmap_write(msr_bitmap, msr);
+		else
+			vmx_set_msr_bitmap_write(msr_bitmap, msr);
 	}
-
-	if (type & MSR_TYPE_R)
-		vmx_clear_msr_bitmap_read(msr_bitmap, msr);
-
-	if (type & MSR_TYPE_W)
-		vmx_clear_msr_bitmap_write(msr_bitmap, msr);
 }
 
 void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
-- 
2.50.0.rc0.642.g800a2b2222-goog


