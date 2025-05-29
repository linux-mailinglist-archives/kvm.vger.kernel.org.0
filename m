Return-Path: <kvm+bounces-48046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0262AC8525
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBA6B17C751
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA152242D9C;
	Thu, 29 May 2025 23:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gy9o9MlP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AA125E817
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562035; cv=none; b=WlJyu+RdnW2dmk5vLsKAxg3tz7jM0CLmEmYNropD7mZHNGBCqMA7rLj5XJHpGvpd7GgERIZPyRnmbiGlvQWxN0jwAs+6G16aeFa1Y7vy//AB3+C09TAiQrK3A+k1kdpZ7BZ2aQYxH5X72C8pKkS7Sju76FeW5Iz5OdIVY6nfdSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562035; c=relaxed/simple;
	bh=BWfL4tsu0Ue0bwKAhcS2JArWqbNe3po1NVgATc5DF6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=diIrV7BIQ3lI0itjky9Iq/7Wfd6DtvPz5fZw7PcE8nbhEFUgUtdVsbLy0nOvu/V16e/BHTDE8JLRElQ/8v4uZVZtBXPjW4JHcMxTOK6amzGOJ9DZx6h5zWyBwaJeKkPqkLmZx5bZhxJkRvNlpda/bp3ENWPJSLWCgvtiLBg5SgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gy9o9MlP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234b133b428so11443815ad.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562033; x=1749166833; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YmWF5C6j3CuE2Z2v8U23p4Q7VC6VQiNVx49P6Fm7FXQ=;
        b=gy9o9MlPmittny4p6xPpPG2ZzJbEeRCGDLsSkdOXznnB8hzj8pXEbxem5s1sb2cA4q
         JUqdb+ndu5aI+7djJU1Os4CMH+FO8vYg+wOPyN3oHgWR0qksC7QxxGaE3FCX0JPsqXda
         W5nj24ZzKCfN2lYzMZPW53af3nTLrYvmvjbut9d1jabT4WkU2ALNCKGBECjRXRURLSz3
         SpMjR5/VgxPpY+izXddVm0WO44fmyohrfnsihM6/eKGGvsLoraQWe2uO4sjNOfxaR0h9
         cnfu+bIIjT+lKlZFXTZJo1+hCg3OPEycEssSMXa4WwvRP5lnNb0ivAAY7VOPO2g6ToOQ
         Kh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562033; x=1749166833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YmWF5C6j3CuE2Z2v8U23p4Q7VC6VQiNVx49P6Fm7FXQ=;
        b=mioWVTFtXbh+QXyoq3rcM24SPV6fHf/ZUSH/vbNtubiMSlfgT1RNOwMou2sLJLiCag
         vmZ91b9PpmGpX/0TXpV4+jQaAG52P86c/YyKrs5f1AoGiKJvk3WFDgHP1tIJddXHon0o
         Bkq54P3+/uUHG58mfkhr5kgxtlKzX0eGwRsGjpGnApYYbSA+Y/51OfjAodxP9xw0B7+c
         g6ImGpsbIyVSyVDvLn3cMtVkh44iVj22Kb3redcHomJ6W1wpoA86zzLnj/n0kq+cRP0p
         0gOuMG0s+752W0FwIJYbehKbPM9pynaonW/l8j88bK+Z2C1y1izqhqAjw9lED9FO/TR5
         R1QQ==
X-Gm-Message-State: AOJu0YwlXBSxB3d42rYdgMUjaPAFGNfJZfxKqlE+IJG5kF6nXfiv0XIU
	xfUj2sB6F7tOs9All6GFSmHxGx8pEXkuM8K7JRvXBHijr6I/eah6TcbiUlvLttPAwvJX5tMXwOY
	nvMmjTw==
X-Google-Smtp-Source: AGHT+IHyqXC/zsW+WKpmiYGX/mbfd8mZzWFpVVHt6P3gRVbvWbZ6b+oe1WcgOSzZ5m8tYyf03unfVSEKCcY=
X-Received: from pgbdm14.prod.google.com ([2002:a05:6a02:d8e:b0:b2c:4f8e:b169])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f78e:b0:234:c8f6:1b03
 with SMTP id d9443c01a7336-23529b45c61mr19508525ad.47.1748562033405; Thu, 29
 May 2025 16:40:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:55 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-11-seanjc@google.com>
Subject: [PATCH 10/28] KVM: nSVM: Don't initialize vmcb02 MSRPM with vmcb01's
 "always passthrough"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
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
index e4a079ea4b27..0026d2adb809 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1275,7 +1275,6 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->nested.msrpm)
 		goto err_free_vmcb02;
-	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
 
 	svm->nested.initialized = true;
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 84dd1f220986..d97711bdbfc9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -893,8 +893,9 @@ u32 *svm_vcpu_alloc_msrpm(void)
 	return msrpm;
 }
 
-void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
+static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu)
 {
+	u32 *msrpm = to_svm(vcpu)->msrpm;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
@@ -1403,7 +1404,7 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
+	svm_vcpu_init_msrpm(vcpu);
 
 	svm_init_osvw(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0a8041d70994..47a36a9a7fe5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -637,7 +637,6 @@ extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
-void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
-- 
2.49.0.1204.g71687c7c1d-goog


