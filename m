Return-Path: <kvm+bounces-17693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F9A8C8BA1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DED771F22DF9
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324ED15885F;
	Fri, 17 May 2024 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jy4L2vtD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0496313FD7C
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967663; cv=none; b=JuqlpX62mV3XjdmBAh7NOSd6mTFW90dlLxBoB1/7gnOYkQdi36EZK6va3smMBC9ssqc9y3JXTunPAkVNkxF/cpINXklpBbc7pq2aqCrm0XvxKdR4SqJN1YeOCELn8B75YZd9x5btHJE79akGwq2Y5ha5iKszsPnqFsnNZDsMe0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967663; c=relaxed/simple;
	bh=WvZ4N9oYkA1Skm+4BtaWiBtO1cB3REDFN1MpLKSQ2NE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IE58US+WF87v8ZRCKfsA2habyOHdDTpRYSiFA4Tv8rNyhESWBsI7I5gBO0ffLZbpXvA/uP+Y1GmWOqA315erGkAUNaRZ3al7S72C/AMvSG3DHRFEYNnIay0mq/WUkCi2/UhZS2KCgX1GSKxQwVPe7iKZndfggyFw5JiJzLw+0zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jy4L2vtD; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f46eb81892so8860128b3a.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967661; x=1716572461; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l8oTz76tUDAvN6sZBnVH7v5zyJvjHU2O3KhRTzL+9sk=;
        b=Jy4L2vtDy4wlRzgqURTlaHLGEjUQq8oA0rI/r9mXZ96q0+5/2hmeVOZkDmHyJ9W9bF
         OuYdlGcDiVu+nb1gfP+R+fk0YFtIc9z8XHI54kOhCRiiQUYnh2rooMlOWDRTV8YgHJIc
         Y43GY58I5gaBKr0/jMQNu6pi+09kgjvo5OH4SiLQVsfXZblfRBjqeZpeYSFxktzoRBmb
         yzYbeQKQOgFbh12i0T9CVQq7T83eVm+lZk/gLWTCn2Y1BowbAdGjVfR84aAqcOV1vzfi
         S2o5EGYUTMWmkhNQyA0Z2CSU2XIE7MG32jl7UhiWu9JtfpB4GpbdVkv34P0WJZzOJ6lL
         ZLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967661; x=1716572461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l8oTz76tUDAvN6sZBnVH7v5zyJvjHU2O3KhRTzL+9sk=;
        b=TMs3vUamdj21quxY7wSSWN9yeAWigot8lvqhOiaGRP9c26YMP2ZKoxWNIZ+cEonvw/
         CU+5f3MaVpN4sPFlxuXD0C2m4XhZRJCgSsC8KG2AGy1wSPoRNT25CBk9XWRsVlDoLEGy
         kIzxS0LE4McuRGRlUmHeXQdD87+uhIApDegZYcz/XDUazmgHgssNExBfh7j4dCFyV1QD
         0VForzNGixgfSKqrE/vYNUoSsJWY7KpE8UJM+0QjSJa+WZKKyGwSYQz+MUie+YntL9cY
         SVuxqFr84uTHJeMF4RFINwmuV1YZb4JQb+kY7yxMRreZPfhwgaLRfWrNsDeesSs1+x0U
         9/OQ==
X-Gm-Message-State: AOJu0YxyfTbqKaJdgov4GVkfUKb/1LoCHwKuaT7fmQUqiHHeNHr/t9y1
	cliDuzhvYdi0qn4thHR/IrdLQfSmAqWqOZwfNEp4edsc7wAtqakHCNgidHLUrHbBvriiu2gwXVd
	+ag==
X-Google-Smtp-Source: AGHT+IHNkezKVDVPQt1yre2iYhwWFzdROZzD/QSqzYt/5aSibk510RO27ZDv5Hyf/OT54dNaFk0YPRtG+VU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3a0f:b0:6ea:88cd:67e9 with SMTP id
 d2e1a72fcca58-6f4e0376006mr1143306b3a.4.1715967661243; Fri, 17 May 2024
 10:41:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:18 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-42-seanjc@google.com>
Subject: [PATCH v2 41/49] KVM: x86: Avoid double CPUID lookup when updating
 MWAIT at runtime
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Move the handling of X86_FEATURE_MWAIT during CPUID runtime updates to
utilize the lookup done for other CPUID.0x1 features.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8ada1cac8fcb..258c5fce87fc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -343,6 +343,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
+
+		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
+			cpuid_entry_change(best, X86_FEATURE_MWAIT,
+					   vcpu->arch.ia32_misc_enable_msr &
+					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
@@ -358,14 +363,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
-
-	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x1);
-		if (best)
-			cpuid_entry_change(best, X86_FEATURE_MWAIT,
-					   vcpu->arch.ia32_misc_enable_msr &
-					   MSR_IA32_MISC_ENABLE_MWAIT);
-	}
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
-- 
2.45.0.215.g3402c0e53f-goog


