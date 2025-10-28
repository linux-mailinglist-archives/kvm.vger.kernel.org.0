Return-Path: <kvm+bounces-61337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAE5C16F58
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 910D31C6280C
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251293587B5;
	Tue, 28 Oct 2025 21:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DEpEtK42"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06F350D63
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686470; cv=none; b=Y1Sbl97T0KBaBtqp3rgbImuLZZGpcL1o/BvtmdTWY2zgdnkNKd5Af2dk0/5ourb3PhzkdiVW2ApiTlNk4hS04h6nOlfPWxLktErlJBrDlV7E2CBvCVccaR+2Eri0paAE4BaTm7Ryo/NXEOwqjl8TjIITq39EsmQnxzLQEzVnmow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686470; c=relaxed/simple;
	bh=Beg5l5GnzctCJzgamlm3q3eIKOOQS9dc/q2TB/QjYmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ller1F0/kgqFQGagvA22L1LPfBpnp2LC1BrsQBGs88defknYVnDsNH53f/07+7lAV9FYNV5U4XwB3xDwb3wxWPUIx/s3OslFWJOmK6QRs2m4GSJpMMJTMuL+ngpyQp59J8NjmeJ2AwMh2tXhwh6oD3l8IMtxxFaqsYoYAew9m5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DEpEtK42; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-940f9efd090so2079337039f.3
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686468; x=1762291268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aqk3ap2s1j8LuUHJMTA+8RH7bEkzoQ7jFIzEsK1w1ok=;
        b=DEpEtK42Arm29HypAab/BnkUq0Xs+bs6W3zLUJwz8FkooJI5FKswlGWpl2LQh0cZcy
         Yg4hF1Rph6E43CAZ58WMVCQ3RwOJU/qZpqP9+a3nu3+/2PLPAZ9+keDqwpPyIu0dGtKh
         +JO/RYvjQ3SIuVLYk6rlGLWtTa0rFJVsClxOskeYGwt4bjG+CgbIrzbpGhn+6MH4f25Q
         +bq/d0oVrVvafJXdSjCIJ+qurrwJFvk3o3LFOvTmuQB6uMgVmJRsLDwOgBpQcbZqlX9M
         NxyrFGFWTPeUZif27tzpNGNbb5SveymPo9saH/+ZThvJDExbOQ7rbZhFYrWUBWtQtbBn
         oA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686468; x=1762291268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aqk3ap2s1j8LuUHJMTA+8RH7bEkzoQ7jFIzEsK1w1ok=;
        b=XFVKmB7RzwdD6ZIq7eA7rSX6IrccKmSgyt3wggQa1fNfCowXl99gjjpXRaDsIMxM0m
         9HpHaTyf5Px94ZOx9exKyixCV0DhjBYQEF9M+AR/Uh/qVvFVlRCkB9KUU1tVAdgxM/LO
         /qQOdvAtiCAlpm8lEnlZ5kIiedy9Y+Mxqytz2OkdxAtkMlxrAgAqN/6G2zaGC/4VmToc
         daLHVetIps+v79ijqn662wTWFdMsr/Wj0OyzojwOxrGOXaYlv9ieiNM7oHlSJC2BumRy
         hckOZcmFTOCwO+qEdvy//fwDWzzDJmFYWH2BcycmN7C7n2bpsOBUTyWISu+5lTxMPpwY
         bUKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuigeuBXYz+5buAGN2PqLb/OrkPfLeAL2ITN/zh1HJDsF1E9/UudUh2yKb1rjQ8t4YFeg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6c9Y+o5D+pJ37faqtnbcHQENlSJ1MGywTs2IZciVQSjp6ff2A
	cfNFUbgwz3MI+SrQXzBBMHOKhkMmxHnfU66tVRuV+YKdf1b6ODtun6XGjomFd/XCeoMTSGuSHSR
	aIA==
X-Google-Smtp-Source: AGHT+IGP1JAiIsh896FE5wlZg5zutyX7tNi20B033WUKmmsMam0fKRXd2ZWfh/OEDsGDBnIKNMeiTc5PvQ==
X-Received: from iov16.prod.google.com ([2002:a05:6602:7510:b0:8d2:d755:be95])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3f85:b0:945:a27c:ab2a
 with SMTP id ca18e2360f4ac-945c986cc06mr128542839f.13.1761686467984; Tue, 28
 Oct 2025 14:21:07 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:39 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-14-sagis@google.com>
Subject: [PATCH v12 13/23] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
 validate TDs' attribute configuration
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make sure that all the attributes enabled by the test are reported as
supported by the TDX module.

This also exercises the KVM_TDX_CAPABILITIES ioctl.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index 7a622b4810b1..2551b3eac8f8 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -231,6 +231,18 @@ static void vm_tdx_filter_cpuid(struct kvm_vm *vm,
 	free(tdx_cap);
 }
 
+static void tdx_check_attributes(struct kvm_vm *vm, uint64_t attributes)
+{
+	struct kvm_tdx_capabilities *tdx_cap;
+
+	tdx_cap = tdx_read_capabilities(vm);
+
+	/* Make sure all the attributes are reported as supported */
+	TEST_ASSERT_EQ(attributes & tdx_cap->supported_attrs, attributes);
+
+	free(tdx_cap);
+}
+
 void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 {
 	struct kvm_tdx_init_vm *init_vm;
@@ -250,6 +262,8 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 	memcpy(&init_vm->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
 	free(cpuid);
 
+	tdx_check_attributes(vm, attributes);
+
 	init_vm->attributes = attributes;
 
 	vm_tdx_vm_ioctl(vm, KVM_TDX_INIT_VM, 0, init_vm);
-- 
2.51.1.851.g4ebd6896fd-goog


