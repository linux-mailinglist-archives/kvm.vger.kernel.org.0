Return-Path: <kvm+bounces-58257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6C7B8B83B
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 648FFA81F00
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3072FD7CE;
	Fri, 19 Sep 2025 22:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D3JeKjmI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516B02FDC44
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321238; cv=none; b=AzHBSE/7XpawL4UY0sJew0AzJkj5px2BJ7wjSKI5LIitSN5eLszBcLX+o23ZLUaOEUGhxzfSlIddCxArr7/7ubqKULQvQHsILNugb/ovAK8a7odHGgWeFJi1ogVthxHZ1Iw/iUiMiO1zYJUNieQMAUr2JdBbC9W0Pr+XAO07x/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321238; c=relaxed/simple;
	bh=81bLgs7WWEP4RHsG/996GiM8z8fF+N7LKbDI/yvDNY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i85/shFmjxtnXuMHo0AB+sfcffKDjP4WxBll1K2fyy3puuGOPiu3R9gJdLtNgb395nyEGiY3rU2pEUCYePLhnWg/nUJIPA1i5kH2rnDbdRGFTiStk6Q93AzrNThmFAFGZUbcDsg1vE5WvxFlDiWrOJJlMaXvSYzG/hDN8cNlYDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D3JeKjmI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b55153c5ef2so1334566a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321236; x=1758926036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FWNNcPWz59Ty6udq/sKrbnnVGPaggW2BoAcUNvSRGEE=;
        b=D3JeKjmITs/+ZaG4iJjC3DiPQwKFoEH3RxoN1bMMz966A58wKfjTbomvmWA8Fr8aqt
         CGxPPHt9Di+YJfMBtHicKUt11QyWzy2KUjxuyoXD6n6JIzEEQYZODkJvPRbUdMsn2Zmt
         o632P2Fkqk/Dw/ClO+65FH9K4gfse9Uo71Tc6lwNk7vVwwbXad2xGG4IgMP25c2RAVnI
         JUdSG7c9yf3ytCGkThTLYDPILhao6VjBgK95aSXCg3tHjSPvPYSlM1LouaKekOH7jBqh
         wmktWrWCx2y0w2blpkgtXFlBOzdkRVp8YZs3Y63FTq4kxpE2uIbzQR6Z52D9aEsGtKQI
         pcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321236; x=1758926036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FWNNcPWz59Ty6udq/sKrbnnVGPaggW2BoAcUNvSRGEE=;
        b=R5WYbZVaaa/k546KWOY3D/kndunFcOubK8owNnrSA8YLAUHX7xpr1imfLeG9cXbq0x
         pX8eEKvrkHKJiIARtwXt+nqWg13mevMM5Vlp+4FO+RjjlUx5WLqibXBbWr9p/HRLKvDa
         gmQ2ESg+k4t4P9Ro/6eaDWPNSYM7EJ/xZ4zNQ7OTlzvcZyZiRV0xc4kisHj6Mr7iW8Db
         cACypK/D8zdEezI94d/UKTfHnmDU+qK6lX7KQpSZvJNZCDSDgEOJhsuptptny+QOokZJ
         4KZ6ikJExtunxF4ZImcgEzJj7GtHRQFqpSdqaXYWeIEHmIQilawXa6t87ss1kpNI02Ll
         2Y7w==
X-Gm-Message-State: AOJu0YwT9ahNXd2fGYeBtYpwJG74Ycf/1m63cQW/0//6nh69ZrlwZuuZ
	RwIQhMngGHc/+omm7bMqd7Hkhv6sFLfl7CvrUs65BuHvj4yDnzVhKe2cQunkCoM0cwsYqpdzK8X
	DiCBXbw==
X-Google-Smtp-Source: AGHT+IHcBUk+tK3zNAtEgLO3ydAANiXuYpE2t7HChEGpqmf2Wh2ALYrEVAwmFv0js2gMpqhaC2ppaWjmLHk=
X-Received: from pjbpd9.prod.google.com ([2002:a17:90b:1dc9:b0:31f:b2f:aeed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9991:b0:220:10e5:825d
 with SMTP id adf61e73a8af0-29257e10c37mr7147586637.8.1758321236618; Fri, 19
 Sep 2025 15:33:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:36 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-30-seanjc@google.com>
Subject: [PATCH v16 29/51] KVM: VMX: Configure nested capabilities after CPU capabilities
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Swap the order between configuring nested VMX capabilities and base CPU
capabilities, so that nested VMX support can be conditioned on core KVM
support, e.g. to allow conditioning support for LOAD_CET_STATE on the
presence of IBT or SHSTK.  Because the sanity checks on nested VMX config
performed by vmx_check_processor_compat() run _after_ vmx_hardware_setup(),
any use of kvm_cpu_cap_has() when configuring nested VMX support will lead
to failures in vmx_check_processor_compat().

While swapping the order of two (or more) configuration flows can lead to
a game of whack-a-mole, in this case nested support inarguably should be
done after base support.  KVM should never condition base support on nested
support, because nested support is fully optional, while obviously it's
desirable to condition nested support on base support.  And there's zero
evidence the current ordering was intentional, e.g. commit 66a6950f9995
("KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking")
likely placed the call to kvm_set_cpu_caps() after nested setup because it
looked pretty.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 69e35440cee7..29e1bc118479 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8602,6 +8602,13 @@ __init int vmx_hardware_setup(void)
 
 	setup_default_sgx_lepubkeyhash();
 
+	vmx_set_cpu_caps();
+
+	/*
+	 * Configure nested capabilities after core CPU capabilities so that
+	 * nested support can be conditional on base support, e.g. so that KVM
+	 * can hide/show features based on kvm_cpu_cap_has().
+	 */
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
 
@@ -8610,8 +8617,6 @@ __init int vmx_hardware_setup(void)
 			return r;
 	}
 
-	vmx_set_cpu_caps();
-
 	r = alloc_kvm_area();
 	if (r && nested)
 		nested_vmx_hardware_unsetup();
-- 
2.51.0.470.ga7dc726c21-goog


