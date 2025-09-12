Return-Path: <kvm+bounces-57481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B136B55A47
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F162B17EA05
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788322E7F27;
	Fri, 12 Sep 2025 23:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z9AD2Mek"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60E02E717B
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719475; cv=none; b=D+QlFAqPmFfZjndpAXyt6P2Al+opUZa5BAdSuOqO6cdUW/nLFwcuNlX6GTRKdKpY09JrUNawyq7oUCRefydx56wASfhPH88gy6NasJVpUBaVZavu7KndOQHsm79FACFhs91Wm/Ay6bLo84wcOXTMaBauMdg6WiQbTymB+DCvhlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719475; c=relaxed/simple;
	bh=bAvgZqDSKSZSgmY1Bh3aCmVMIAn3w0+mvtW8ENhAZxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OU02ocriRpyNAkwvWAxgYKUQ5apiq2rBQLSpMTmVQeo4E4BmpdHIQEEULuEo2r0ZCdMxxpTNoYgIsdEeTyoW7zauL9LusLvzn4Ep+VDOK3+CITEMdPwZKFQWCN6jZSISfiISPmmhu1EDVbXG+cBjwggTASoWcNviSA5rdnp4sgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z9AD2Mek; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7723d779674so2128061b3a.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719473; x=1758324273; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gImqUspRMTtFrNyNB/J/yT70FgdU10MOpzMgx8Aa2dM=;
        b=Z9AD2MekKLLqsMDU4I2LywzvUUexMUBpPad7GGj+M9bCqhUybPwB7hlpxEtwz6orDS
         9b3Qa9isVjkdL3+O/c0irCCtqFQpkGkfk/l5tIjTqzVjXiMX5Q2LKzJ9VevYJFXlHHXM
         XzQmoR/8nqxnWyoIqNIH3fgCvdvbOwMIowRecwiZtzR4yzfOr/Y9YbffUN/wa00QJI27
         MUVnZYHDsmeH+cSVF34I9c+UAYgxIzU5WralhPc3c1DeIeq12TUBGL+7SaYKxeI5RiGT
         DTAbufR4kLHGJFttKM0f5HCH0wuBncHMd55zIxoMOgSLWNrFVuMNMUeIRQY526YJH90v
         LfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719473; x=1758324273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gImqUspRMTtFrNyNB/J/yT70FgdU10MOpzMgx8Aa2dM=;
        b=R2npMKShiq9ixT9fGuup7gXAzSoUCVXjWgRz/qhjU6zPug/v+eTR5D14JPU2Hl4k5U
         Vffygt+nS/KBrvmV3VG3+XUAyT0CQ3VwNkx3uF14jrZjhFO3brNVOUBL+1+4ylGx2/5c
         Mr2Ut571Dfu1fwW939lYIsTI2dIKFhz9iNHoEVqRlJxImC6W11R0zokKYg2HUbDXqfpw
         L+MHf+c4yhFJ5os1dtannbqOQz5fi1vgHXBhrUbFcSYRrKi+l4Od5xAOBJM7/JkIoFxt
         QTit2V/cIjexQeZDwVVV6psSQQDxjyTqZkVI2YiuluIQDMOwHbp/DsLSJTsCzuO3+8Hk
         45HA==
X-Gm-Message-State: AOJu0YzvIlfwNlbaAw8RWlHfZbNTdJXLlEm3RNn7hsW9Um2VLxP5xdvy
	NhbiTNvqpxze7LzmLlzbSbb5Ask8ctT5qTZZM8da1Y4f5sbfYMf0UUH6hi9iASmNhzKrQZOwnCS
	qFQodHg==
X-Google-Smtp-Source: AGHT+IHRkUUjDiUAJiC1fpOe+Lr6xbhMzIbft4c1p/ekgTG9fgtV2fBAXwOEYkrIC3xU6auBXmeuJUM0C0I=
X-Received: from pfoo15.prod.google.com ([2002:a05:6a00:1a0f:b0:775:fbac:d698])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9150:b0:24e:84c9:e9b0
 with SMTP id adf61e73a8af0-2602aa8a513mr5926870637.17.1757719473102; Fri, 12
 Sep 2025 16:24:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:16 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-39-seanjc@google.com>
Subject: [PATCH v15 38/41] KVM: selftests: Add KVM_{G,S}ET_ONE_REG coverage to
 MSRs test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
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
index 98892467438c..53e155ba15d4 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -153,6 +153,9 @@ static void guest_main(void)
 	}
 }
 
+static bool has_one_reg;
+static bool use_one_reg;
+
 static void host_test_msr(struct kvm_vcpu *vcpu, u64 guest_val)
 {
 	u64 reset_val = msrs[idx].reset_val;
@@ -166,11 +169,21 @@ static void host_test_msr(struct kvm_vcpu *vcpu, u64 guest_val)
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
@@ -305,5 +318,12 @@ static void test_msrs(void)
 
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
2.51.0.384.g4c02a37b29-goog


