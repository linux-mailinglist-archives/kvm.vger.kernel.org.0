Return-Path: <kvm+bounces-48055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1D7AC853B
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68E263A1CA8
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F7B2686B1;
	Thu, 29 May 2025 23:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b5P2PXIR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F20267712
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562052; cv=none; b=scwFn6iXFo3+p/9R9prVtTyOlYWGB5knGqW6BVHfixkZBtV0FjsAzrLBF3QpKCF3Fxj4zSnfxV0p5p+qTOoa34mEGoi6+K9Znv2rtSNdmvHFY1JxNpTNn+2PKqUGd6MlXH11z2GdRqHos4Lw1J/OJglO7jchSZMXS7RdPKTad2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562052; c=relaxed/simple;
	bh=3Ss96AAD1zcLzWkvW+r+tlN+q9wQb93Ov1S2Eah97js=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uOuHfdRVcEzf9TmwfrrBEiJoevAJ6qijM31i15zyM/BT4oTEYS0FY1WRJ+T5PzrTwAaWaRz+zxpwLEIlKvgRapXeEOobzCw6YIvHhJ63cG1Mb9rmuS5S16KpnBM05Rbdr1pt1ul8YUHREqavAaSy1VyLUYIp4r68RnmJLBFise8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b5P2PXIR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742c9c92bb1so1126316b3a.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562050; x=1749166850; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ICiJiSxOLmQxtER1UTGYaICTPY0kJa+u8J+f2toknpc=;
        b=b5P2PXIR4MBjxB7N5X+3FxGdyNrCepmaT7/H3Ycn2Bv9xBuwMuEKXwAm+Mz0qT0m0s
         OI+oy6r71PTNn92SmJgmlOwttNr36wqKktwOyTUdu6oRp4hxTSVQzfb6gO/9h0j7r7R+
         a9olOEJwu25TvT4W6AyVSObotmNdnf86MSTelEd3ovkyIEIF1HvCv4kTC9oWsAAIqdpa
         F34vMwQdvoP7QTwO2E3TxVzKcVijJ1QGf3yCbrelWtqX1VHEXu5Gun0olJsMk02eHO1X
         jnlOBivi5TMLvaBmdqBO3qFKVgwMrcURj/Mkm3El9AhKZYYi42EyhS8Wzkmmwrh7HdGt
         4vIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562050; x=1749166850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ICiJiSxOLmQxtER1UTGYaICTPY0kJa+u8J+f2toknpc=;
        b=J8TUVHIv66KWIhcj3E8f4BNj/VZZvh8P5SNSFTSy9BwLws/xR+jW6ob3m7a7FNQ4j8
         VdVKxgVecjltkZ+/7WBYd7WRFcsiB3GD17/dzTc7yx0H5T2zqFUvWcrs0dS1T/8K7SC7
         VvrI7RV6MbaCqFewUklv16w0zY7ZLWJUTko40d93M+CPpy9M8yF+2DuBIIDBU4KWx3y8
         K/SzCqrmEieY8AFiteY9HuQLl6ICK89h/1X8j7RcmxjZ3X8AanGq5XYdzV2GXMXsrl32
         G95YxWDS6X91ycnJ9d+NVKzBgimmbFsaYRcFAc9ghytNKMKfVZ3JBuZCdRhwa7pO/OQP
         Rt6g==
X-Gm-Message-State: AOJu0YxB0DAyDqvumh/qJvlaI9Raqp2kkojinYozTAZ1GJqZbTgYViM+
	yWoxqkeZwNUiNn/6QfBGttV0qS4iXw6Sr6V/uPUJ//oOCh45UumcZ9c3mCGekaPhbl/oNyo5RKj
	IiM3Clw==
X-Google-Smtp-Source: AGHT+IEkzQv92LgC6XPOHAO80Xw4IzD4slJRTbmhAV7VxAG9t7v05ThV8+ubj9WSHvkwXXpBOx2W0zebT8o=
X-Received: from pgbdk1.prod.google.com ([2002:a05:6a02:c81:b0:b2e:bef7:3f03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6494:b0:218:c22:e3e6
 with SMTP id adf61e73a8af0-21ad952e37cmr2162295637.12.1748562049784; Thu, 29
 May 2025 16:40:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:04 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-20-seanjc@google.com>
Subject: [PATCH 19/28] KVM: SVM: Rename init_vmcb_after_set_cpuid() to make it
 intercepts specific
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename init_vmcb_after_set_cpuid() to svm_recalc_intercepts_after_set_cpuid()
to more precisely describe its role.  Strictly speaking, the name isn't
perfect as toggling virtual VM{LOAD,SAVE} is arguably not recalculating an
intercept, but practically speaking it's close enough.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a9a801bcc6d0..bbd1d89d9a3b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1107,7 +1107,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 	}
 }
 
-static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
+static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1273,7 +1273,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		sev_init_vmcb(svm);
 
 	svm_hv_init_vmcb(vmcb);
-	init_vmcb_after_set_cpuid(vcpu);
+
+	svm_recalc_intercepts_after_set_cpuid(vcpu);
 
 	vmcb_mark_all_dirty(vmcb);
 
@@ -4522,7 +4523,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
 
-	init_vmcb_after_set_cpuid(vcpu);
+	svm_recalc_intercepts_after_set_cpuid(vcpu);
 }
 
 static bool svm_has_wbinvd_exit(void)
-- 
2.49.0.1204.g71687c7c1d-goog


