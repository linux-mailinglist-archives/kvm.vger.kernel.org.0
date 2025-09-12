Return-Path: <kvm+bounces-57450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC9EB55A06
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD9F11CC2D17
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DA12C21F2;
	Fri, 12 Sep 2025 23:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVCTgE3F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B577F2BF3CF
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719419; cv=none; b=QAJ1XuUwq3HP0qzmzrrXJJSwMHxBPMRMW97iQOAIYhPsJy8eYOGKV1/t88EaWfygDPrdqx4ujw/6aKu5PmS8FxxuihFQ1Z+KqGz4THLosQxhyoTRNtSKvTjKks0Y/5x24PJm7RD0GFDnN/2eSaMK1yarKkrnskKTR0fME25gVlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719419; c=relaxed/simple;
	bh=R/hsEZ3OEznvSmN6Xu/NmYJshewwUaH/QtJ9rZVe4y0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lAwbHuj6N+b0RSURxwDtBxEjYsrt11iZEuxmBC0A1W8gPWMaz9ffL4gcP960Q0JOMw3X0TmZ3bCpaz1D88oT9N1E6v7DJtN2YlVh1NMkhJUw6tOI929jn33jVzdBuKoGvEYn1Ru3ZXyGUTULss1ZocVXxpR+gyIZElLMVkC1ZDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iVCTgE3F; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471757d82fso1603095a12.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719417; x=1758324217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4x8cFQ9I8IrL0w8PA5lioMQm1qn/X8VrzBwyUBJiKwk=;
        b=iVCTgE3FlSmFC9ZgtdmHpLzk3CA14ZaCuHajYKMOgVhLCAsRWHSBLcn52ocQeMhx91
         dk1z42P0GEDb8GDoUzpvBnr3a6EnbUNYqC0B64er0HvBTnD7n4Y/iDB131kq3MnSk2t8
         A9cfZ7zfvZ7wQKy2xtmLC2kWvpfRs+6nf4zp0vzZk9SFyzdFzgsiRM9TiTP5TRXTV6ap
         EuJCiOu6sE3OwpIsOHtiQKg+S4wczoNUHPIroBKzra7b+vXzo/mxVndsPCkDjcyMVQuR
         UOWJZNZH/55rt+L8z8Nd6fVwVuA3kgrkKkif46F8mYKdUKpzK7/DIM0cR8AZLgAL5oDO
         IZ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719417; x=1758324217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4x8cFQ9I8IrL0w8PA5lioMQm1qn/X8VrzBwyUBJiKwk=;
        b=O98ZRn0hRR5/rxW8Ib3LSA2sclzHWxw6WyKKpcUgiIQpFhZsfOcrz12oi6eYaDt+t3
         yRqak89FWTW93zI5GIKBnsnOQ9k+MxBY3S7BiinaafL7PtKoxtZtyehWk/mY6UC0O+4X
         PJm5oI7ffgchlqWaKZWaq1sOCXKeDLlJYUiisdfcmMiAdUo2Kyn0HUbLjoG/6YP66Lov
         gm9M83PI0oHQ7wwRHaptRWCXsmyUMFib0EHY4+iZWBtT8PESj0iUN7ckKErLMBVYOxwe
         N4XFTZcJZ/e9wzZS/ywBs/mvwBJkVj0ZYOVJwr6R7f+tltQmELvUmYZpZ22JqYPfDcvF
         6iag==
X-Gm-Message-State: AOJu0YzV9SAZPQchhio6vd2yY0fCFrLlhok7J2Dfry1Mx3QvT+OzfgCO
	tLCEyuGpvdCeZQrYNv5bced58ZxY/4jGdtbMN4xMIEDVALbW3rvwM66jjknkDbmd13FhsnIAFiQ
	BBGSeyQ==
X-Google-Smtp-Source: AGHT+IHL2nuJLf6q7uA5vbcBTUvwqLs20KOTZTeKNgV7CYzfjmBlfXMi0Vi99kCRqkOf1/zS/oAOJS5ZmwU=
X-Received: from pjbqb3.prod.google.com ([2002:a17:90b:2803:b0:32b:8eda:24e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6ba4:b0:251:e18:bcab
 with SMTP id adf61e73a8af0-2602c240dfcmr4538494637.38.1757719417056; Fri, 12
 Sep 2025 16:23:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:45 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-8-seanjc@google.com>
Subject: [PATCH v15 07/41] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
due to XSS MSR modification.
CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
before allocate sufficient xsave buffer.

Note, KVM does not yet support any XSS based features, i.e. supported_xss
is guaranteed to be zero at this time.

Opportunistically skip CPUID updates if XSS value doesn't change.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 arch/x86/kvm/x86.c   | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 46cf616663e6..b5f87254ced7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -316,7 +316,8 @@ static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
+						 vcpu->arch.ia32_xss, true);
 }
 
 static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a5af40c06a9..519d58b82f7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3993,6 +3993,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
+		if (vcpu->arch.ia32_xss == data)
+			break;
 		vcpu->arch.ia32_xss = data;
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 		break;
-- 
2.51.0.384.g4c02a37b29-goog


