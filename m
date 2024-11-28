Return-Path: <kvm+bounces-32671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4A99DB0ED
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:39:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00779164977
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3709199385;
	Thu, 28 Nov 2024 01:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kj57NTTt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DE17E59A
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757708; cv=none; b=sg5Hm4Fq0EhqyU8vEg2z5z6lrokXDXGSaxUeVoQ6hnKyxNJO5IhWLK03NA7weoVrfq0HF5fZGLMAxrnbWPqZ1KKbM2GH1aXFsVY6Vd8ZYQFdtiaS/adWOLRA5WRKOC+JXRfffZCJgYQnFPmW8CSee4vtR+s5iPmwLVWWS5H9GDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757708; c=relaxed/simple;
	bh=2Q1kVrEyCnyB3DjsUNAWh7he2DHh+lSAwEDhcvm0RHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pMBp80tG/j49y36C1ibuvS9zb04Cc6TNagy/jLDjB8twl0kBpYlvGtUtahMs8BcHoMaYhmddYwviKgHBW3LuRW5m8uf2x2jBnRPpeN16np8XExNvd220mPqe+hK93WdIItMpytuQ4GV4ujRgvdOwlhv8n8QXRBAIgQFUYev788w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kj57NTTt; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so286648a12.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757707; x=1733362507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sl6X5b0bxyRkVbn+G689ru052xqCH1IMhImemP9sZRw=;
        b=kj57NTTtd3xPYX+QUmYbH2dI45xf3uqtFUw1jR6NPFywnkEB7qMJbZCvFH/gqRjTIR
         uudzROw7hTQlYvVQcm03ZLm8SN+nQIgOyjo7xoNCxj5qJOgEXynyKGMJWuLwcjkdjPww
         XXEO9WMUWZM2OwQqpy9q6ZKTUtSkAVJYM9zmXoWsLXAxeO6V6zQOfZ1uuGdPfsRnifPv
         +Vci9jN/8DMrwTCf9Aiw8l5JXkFCquf0HHZZks961rla/B3qX2IRTn/niNp0RlrnVKlN
         J0ETxJLV6VvSUGRrW7bmFkspJwhqmeIZBjHqm9j+zeEisnYeVtpcnF5xX92Kkp66vpnf
         qheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757707; x=1733362507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sl6X5b0bxyRkVbn+G689ru052xqCH1IMhImemP9sZRw=;
        b=ISUP2LDH4EopZ4qUvc6P+2rDP17QNyMmjJ7DjFwdQCoyw3UpilLj5060zA8kwyaD1N
         20EzUs3SBjJPCfvOY7cLrCsBO5i/LdCBedMWJCmGXokxgWNByed6t8C5Ax6vxqCu3sfX
         bS9wUMDmK4i7Qg5qxmFIdxK1nrr8q+LtGycXwpQZz5mx1syfgIn3g+jwQ4DsS2GTiG7k
         DxSRZ6pSwD3v1b3Y4r58HDKoL+L1sLXgqatlESm0OCftPxOn8lLZqQ9OZr0i5JR81jcT
         bauZNcnuzjMkIr1ANQMfpydJwwpXbT+n3wzE1aTYToxSFRNyx09F55oAmu47XexZ0hXh
         yeTQ==
X-Gm-Message-State: AOJu0YzRtY3PyXWONnVN7xqjV/ezf3Q/ldAK4745xdjai9ftPsv6mE26
	PnHLR/l8wUadYFM+B3mgtW9Op79mH4p2Pqfn2D0YDrEijyhTFINmUuQOGkv6OpkXJu8R7WlDinn
	n/w==
X-Google-Smtp-Source: AGHT+IFDjKtecjGMKpdFToT37L1qnVgC6GL8sx1BJdKN0jqOJokIXOGEzKpUpCWGpaEd4aGPKFnXmjp1aMI=
X-Received: from pgg4.prod.google.com ([2002:a05:6a02:4d84:b0:7fc:2241:1b32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2583:b0:1e0:c8d9:3382
 with SMTP id adf61e73a8af0-1e0e0b8c5d1mr8141450637.45.1732757706780; Wed, 27
 Nov 2024 17:35:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:47 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-21-seanjc@google.com>
Subject: [PATCH v3 20/57] KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Do the compile-time sanity checks on reverse_cpuid in __feature_leaf() so
that higher level APIs don't need to "manually" perform the sanity checks.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.h         | 3 ---
 arch/x86/kvm/reverse_cpuid.h | 6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d4ece5db7b46..5d0fe3793d75 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -179,7 +179,6 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
 }
 
@@ -187,7 +186,6 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
@@ -195,7 +193,6 @@ static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index e46220ece83c..1d2db9d529ff 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -145,7 +145,10 @@ static __always_inline u32 __feature_translate(int x86_feature)
 
 static __always_inline u32 __feature_leaf(int x86_feature)
 {
-	return __feature_translate(x86_feature) / 32;
+	u32 x86_leaf = __feature_translate(x86_feature) / 32;
+
+	reverse_cpuid_check(x86_leaf);
+	return x86_leaf;
 }
 
 /*
@@ -168,7 +171,6 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	return reverse_cpuid[x86_leaf];
 }
 
-- 
2.47.0.338.g60cca15819-goog


