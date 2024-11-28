Return-Path: <kvm+bounces-32696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C5D9DB121
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F4A2B26DED
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D1031CBA02;
	Thu, 28 Nov 2024 01:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fy792BiM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4C61CB9F2
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757752; cv=none; b=jh+I8PO8Rm2kiOXgBJO6lyzyWEyHUJJhXuC2Hxp3xiAxRgTDefbSBTogxiafU7mOArjjYm3kw8zr1EysKan16DhsKEQHEpPvxiRJhTDqivBHdHFNm4qqGcIVoK0FY0SBQ8prMsmLk/AOaJ3QBK+JLiZGuPEJvMIrkAQnnF/Mn6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757752; c=relaxed/simple;
	bh=h1o6xxhiRsATofWeY4XS6nAFlEHdA1rnXtEd6OclfKY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uo1oyyUsufDr4NyOzNycsmldlNpB/3Im4mqN9yuTuSQRHmz9MHCrSfHm1b412NKJiwHAgIEIKIbOLVikHL/KzVholuw+Z9nHeObDpJsKNlBZLsumSlzE/e6FzByqrrYSxabfLuWZHfTyBo5rRr/Ik18vh/v8LZrPWJE9nHgNrWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fy792BiM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea42039766so386705a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757750; x=1733362550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vAP/rVhh2wy/ZcCYWV8qgeX607Ed3+jPmDcr0A7awL4=;
        b=Fy792BiMDJZMRmKcdsu0qJrDRwm/llELagsCUuiCMpTpyNN/ldQe9bVND59wtVoWPN
         lSsuB/JV6S5D0N6YppCnutblHAXz2954bTN05ojcTSKHolRjOMHJpp6Lmf1cynRjGuh9
         V13dHcyfulM/BVOD1wqLCfKNknBVhGnUWT7Gi1dBQoiW4KtKgEeLkciSad7FAJs7XBI4
         ZWWU92rKEBxHNdy6FUBer13s16mqNQEKnQOOfhqMG+JzvzJIJXG6tPN+eUyzAqWSQLZf
         dJ0foxooMOq9EwKxHiERutv6ZHwNWe3jsSG2lwWupDQ16rn3gM+MqCPwHz4Zw4kVBORO
         olPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757750; x=1733362550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAP/rVhh2wy/ZcCYWV8qgeX607Ed3+jPmDcr0A7awL4=;
        b=NOJ5DbKWY+GLxn2E2e1xbn1uXN8E2hfL9wauyu6G2IWeQ7cDd9R6TYsJQP3aUB8KDD
         YdZd8owyqNpwRypHWDLklRz3SneTWfKhKnDaHbm013kiyOOZptMrBVetukHH4v2wgzep
         Kk1y+t+nM8Eys8AN0gOLdJuuUXt4f8Va/LZxvPcWIp4RD8chx2dmfqE1bgVGOW9YVxGJ
         6nw9VPa/qh2JAHxk7pQCUUmfkHh3GZfPB9cRdRdd4JuDhi8WGoQvXbXOQNQ1lTllMfVz
         Q4YtgZQqrwiafC2vW4NQ1vo8YEpjdRwUcJfjXDc3VlpE/DCG+vuGUho6GOWXfM1Y2xBb
         I51g==
X-Gm-Message-State: AOJu0YylGbyNkKocTDwGj5FyDnZxJGIlh0mc/IAKQpQBnULetdvmuI95
	DGcHJReNcNN8pIZFuasZg3rG5M6tBFWXbAqOuPl8NiA9A5M9M1Hr6e2+pwCtC5AHHeQpVOVarU3
	/Hg==
X-Google-Smtp-Source: AGHT+IH4S299/Qme5T+EzZT4W2pDSlPNgfKHdrqsbTxhkEGzPyX9GiJRIR7nFXLTy67066kc1KKNhDPc3pM=
X-Received: from pjuj11.prod.google.com ([2002:a17:90a:d00b:b0:2ea:7d73:294e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380c:b0:2ea:c096:b738
 with SMTP id 98e67ed59e1d1-2ee097bafaemr5779058a91.28.1732757750554; Wed, 27
 Nov 2024 17:35:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:12 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-46-seanjc@google.com>
Subject: [PATCH v3 45/57] KVM: x86: Avoid double CPUID lookup when updating
 MWAIT at runtime
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

Move the handling of X86_FEATURE_MWAIT during CPUID runtime updates to
utilize the lookup done for other CPUID.0x1 features.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8015d6b52a69..16cfa839e734 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -283,6 +283,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
+
+		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
+			cpuid_entry_change(best, X86_FEATURE_MWAIT,
+					   vcpu->arch.ia32_misc_enable_msr &
+					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
@@ -298,14 +303,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
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
2.47.0.338.g60cca15819-goog


