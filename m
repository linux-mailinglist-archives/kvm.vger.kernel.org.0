Return-Path: <kvm+bounces-54164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEAEB1CCF1
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637C016A639
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815E42D876C;
	Wed,  6 Aug 2025 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uaHWKvu5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CE02D6608
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510292; cv=none; b=rP6/YexHDMh6tfNJFymmxL+j3W2zleBi6CpyRRvlGFYFW6zZHdxk2KZdCnlxSY/PM+Zt5WKFSulFgkMS/tDxcR9KEym6oCUKUIHEMYDZpUxvVtwWjjqZQrZGLkdlqp69jl8SGriYYuXwTIYlVlmqB05DvBPOlPS4qawwiUuYsww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510292; c=relaxed/simple;
	bh=C/4r70x0T0JzgUP1RnZOZXEA4d1zjXrhrDvqbtcZVy0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IIgeQfq8TdIKcgC2C4t5YxdMYi5KZwW2fGEH0eAPnVKy2TaBkFpaKek7Xxpb+GOEfDRba+beF0W4hdy9OpGvv1bzlG2kBULij9OFbvg1jUVzRLZNXhvgj2w1gtZx5E69VxT6snkHzgnxWCxZDWZLSvaXh5Rxd/ANr5gqpogYjWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uaHWKvu5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31edd69d754so283441a91.1
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510289; x=1755115089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ThGb/1cQlCkxXgvsmi9By0m3uFp5vZO1mPp34NlVQTI=;
        b=uaHWKvu5JZylMj7XjxGlrZ/pPL77UMOCKQfzD6qzIiWiMVWegwBeCKmRWi6NfHc7AL
         YQQ+U2l3Mhz5h69aoFFZj99nl9F3YyUqzTSiYP9RHyQnWaCRNEzZ9RFFn7AtOmN2ueO4
         fLfrhOSKbqyqrN+UyZ+hTQPKeWmEcZbv40rj3hdYyV2i4L9v9aN4aTcc0uEYCRsZNAvc
         slrWJs230D2GPPQb2O9yXpJNX4kAouMR2m2zNgu41OWXCYVzG63rjj+VwwdcG/IPPSYA
         Md5eWJTFNdt2QFZF1cqQbwQUrKaGZhfAISwwDHYlT4oLO7OGz189gyWRc/iIliiLIP4A
         yekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510289; x=1755115089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThGb/1cQlCkxXgvsmi9By0m3uFp5vZO1mPp34NlVQTI=;
        b=ijVbWElPkbpji5bTDCn5tHsJBtSUHnuVBQo+65a5mHFgX9fGB82GJKLHLSK7t9SXIu
         33PUpTNnq0ppx7W+8VNMg8z0cMOupRGZjcYI/9RH3vvwApMUgUIhiWWTKEyleTuEoB3C
         6RauBFXSUcEndTa1Kn1/P87384Rf+Mv4Z7HslJhZPJ8TBPjwj1AESzOnhzMLzQk7ZSd7
         d06WhYhv5PQa5ZO266340UX7F2+Rkkdmh0dSHkv3medhvHXh7O7wFqgDfkeZuVK9VtQW
         14gWkP+HyCdOXcMhVbh1kzNovpXr4cCLXcusvOYBGl5ni+FCOmnMf4tb2i2k8NMAfnzr
         gBZA==
X-Forwarded-Encrypted: i=1; AJvYcCUgJ7xSMzKSmfk/9yzqksOtGekD4W1uD6RR6E7pfLmkOJsIK3pwjVjoAlszq5T/q3bZ1Y8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYgfvYAo/YO4P1oYBT4JYY1h/K6FwDGtLz6cElvuZ9OqPzv9aB
	4r/rVJFHpvfTvZZNKJOd464pSI9NwMaA1CWGdJ6qgToWDJmxRAJMARM5mNzMPJnvbi7pxnF2x5Z
	fj599rg==
X-Google-Smtp-Source: AGHT+IEDX7osU0iIbko+P3lNad2rdh21UdoQ7zV3q9ejnGRLDtg0+KAFySIgmFRbYCqEx1sz5hOKZCwZh1w=
X-Received: from pjbci4.prod.google.com ([2002:a17:90a:fc84:b0:313:242b:1773])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dce:b0:31f:5ebe:fa1c
 with SMTP id 98e67ed59e1d1-32166d77ff2mr6724469a91.0.1754510289629; Wed, 06
 Aug 2025 12:58:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:44 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-23-seanjc@google.com>
Subject: [PATCH v5 22/44] KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Rename the two helpers vmx_vmentry/vmexit_ctrl() to
vmx_get_initial_vmentry/vmexit_ctrl() to represent their real meaning.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8c6343494e62..7b0b51809f0e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4304,7 +4304,7 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	return pin_based_exec_ctrl;
 }
 
-static u32 vmx_vmentry_ctrl(void)
+static u32 vmx_get_initial_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
 
@@ -4321,7 +4321,7 @@ static u32 vmx_vmentry_ctrl(void)
 	return vmentry_ctrl;
 }
 
-static u32 vmx_vmexit_ctrl(void)
+static u32 vmx_get_initial_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
 
@@ -4686,10 +4686,10 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
 		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
 
-	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
+	vm_exit_controls_set(vmx, vmx_get_initial_vmexit_ctrl());
 
 	/* 22.2.1, 20.8.1 */
-	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
+	vm_entry_controls_set(vmx, vmx_get_initial_vmentry_ctrl());
 
 	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
-- 
2.50.1.565.gc32cd1483b-goog


