Return-Path: <kvm+bounces-58276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 138A6B8B8BA
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F25B71897A65
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3880A322C68;
	Fri, 19 Sep 2025 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Huc7i+D5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D267F2D9EFF
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321272; cv=none; b=g78iqyPVsmyLxfZ7SM6HpiwBOLMRYcmZJMF3xmYQkR64qyqN7ZBC26qvWwRITnriVsowm1jI+oDS8EinjuGCy/HAgA38OTyURHHBJ2dXG+2LnxsNPo/eFiDKWfFmF0J4faBwbLjKuNmQY3cidrPObUnNPkaE6PMBNQh/3X5hqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321272; c=relaxed/simple;
	bh=dJruaGQ3F05Ma5fn/i7vIuVZEHwh1UZEyHwAWIgomQc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qWZf6ltvNmO093N6RLmTslWxRQwq++4LU/qrI/pOaZcjVB55MT2+lETcWNZZ2FfKHq0SdzkEbSrff+04C+pVQBiY2MhNbilcpetbH/yKj/10PnduEw87CZj9DGfvqj59ToWI8XhXmhJmPkjtfv5FsapFjcw29KEwYTFpx6J94Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Huc7i+D5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5527f0d39bso876049a12.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321270; x=1758926070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FM9v8UgMu6POlYV9dQiPZ5KwLlKlosNQEUVBs5xJtT8=;
        b=Huc7i+D5vwO61fIXimSomNh2i7DBgjBfd5D1i5mIWAMNLSPsvaQboL3D96kh78xTBe
         gCZWqo0NAGmq21sgKPsHwrVzH2ej/UeXroLua7R6mUw8BiTyoOMZpHtyCYs68zIvY9Ya
         wIKxftRNjYtDnn3K9aT6VpGl2KzZALDBVcGxC0m1i6zHD9yq1/D/pJnztecZRc6J40n0
         Di0EG21CeMvutIMxmEkQz6AkRdMis0Zcelxbf6KFrNDy46WbWOzFXrI5LwiWCS2jKjbR
         CcrpeojfSsGTChSh0GQ+je83nxdcv4G//YH673zvgJOXkbPs1oBbFttKX8t7KOUzeaC/
         dalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321270; x=1758926070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FM9v8UgMu6POlYV9dQiPZ5KwLlKlosNQEUVBs5xJtT8=;
        b=nLI8oWgn0aHMleTyb8VpsxAwxHQoIRua/d12T9HmLS9vrdl3Y4LhJpV1oajYsHGjwi
         13cIcciiQXLAw2t30XyL6qX1kz/4LlpEDubZd6i/+hASGHyyipy/J6xlN3Qh8scRfUMz
         8WtV8q5nmPOm7HKpx7nnqM3qnG3QprjWAyCr9rdD3g9/KYjXIBM7jIu26zxSr2aEnb7u
         xCGB0CJxbxX/CLnhRioIuDHJswmxTrLYuuPOZHMnGlbv7BcnGivlwOT05HMjByvjazse
         I8d1abHg6lFRFcT/FDCs9xv7D+1Zg63mtDSEfHbHuY0zt6wXEDXFh5OppeOQXMGlPjgb
         e/1Q==
X-Gm-Message-State: AOJu0Ywc88Ywo3YoER9amfqM4Gw8SPzO1G7SNfOgFAG4SR3S9B/YKIG3
	nBLsyaioFnbnZRslIf7vKecPXFrWqeAzyBsShIW/EJW+oBVmyGERPKgrzqfRbB8NdhBOUo+U2Tv
	VMWThJA==
X-Google-Smtp-Source: AGHT+IGz3iwZbuHnPd1skP5ZnQqIFSyE3922dFoUWfjAGRfr0Zq2zpTrmmvMDiu/w+L/FmceX1nx623YreY=
X-Received: from pjh11.prod.google.com ([2002:a17:90b:3f8b:b0:32b:65c6:661a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a9:b0:261:ed47:c9cf
 with SMTP id adf61e73a8af0-2926d9d9bcbmr7790088637.34.1758321270192; Fri, 19
 Sep 2025 15:34:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:55 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-49-seanjc@google.com>
Subject: [PATCH v16 48/51] KVM: selftests: Add KVM_{G,S}ET_ONE_REG coverage to
 MSRs test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

When KVM_{G,S}ET_ONE_REG are supported, verify that MSRs can be accessed
via ONE_REG and through the dedicated MSR ioctls.  For simplicity, run
the test twice, e.g. instead of trying to get MSR values into the exact
right state when switching write methods.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 22 ++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index f69091ebd270..2dc4017072c6 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -193,6 +193,9 @@ static void guest_main(void)
 	}
 }
 
+static bool has_one_reg;
+static bool use_one_reg;
+
 static void host_test_msr(struct kvm_vcpu *vcpu, u64 guest_val)
 {
 	u64 reset_val = msrs[idx].reset_val;
@@ -206,11 +209,21 @@ static void host_test_msr(struct kvm_vcpu *vcpu, u64 guest_val)
 	TEST_ASSERT(val == guest_val, "Wanted 0x%lx from get_msr(0x%x), got 0x%lx",
 		    guest_val, msr, val);
 
-	vcpu_set_msr(vcpu, msr, reset_val);
+	if (use_one_reg)
+		vcpu_set_reg(vcpu, KVM_X86_REG_MSR(msr), reset_val);
+	else
+		vcpu_set_msr(vcpu, msr, reset_val);
 
 	val = vcpu_get_msr(vcpu, msr);
 	TEST_ASSERT(val == reset_val, "Wanted 0x%lx from get_msr(0x%x), got 0x%lx",
 		    reset_val, msr, val);
+
+	if (!has_one_reg)
+		return;
+
+	val = vcpu_get_reg(vcpu, KVM_X86_REG_MSR(msr));
+	TEST_ASSERT(val == reset_val, "Wanted 0x%lx from get_reg(0x%x), got 0x%lx",
+		    reset_val, msr, val);
 }
 
 static void do_vcpu_run(struct kvm_vcpu *vcpu)
@@ -350,5 +363,12 @@ static void test_msrs(void)
 
 int main(void)
 {
+	has_one_reg = kvm_has_cap(KVM_CAP_ONE_REG);
+
 	test_msrs();
+
+	if (has_one_reg) {
+		use_one_reg = true;
+		test_msrs();
+	}
 }
-- 
2.51.0.470.ga7dc726c21-goog


