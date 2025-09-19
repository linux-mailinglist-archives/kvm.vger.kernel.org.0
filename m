Return-Path: <kvm+bounces-58235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12949B8B7DE
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26AF07B7925
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ADA2E091E;
	Fri, 19 Sep 2025 22:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zsRXvhyq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A02DF6FA
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321199; cv=none; b=o7JRl1T4mOfKlBgNF2um/TqZemXuQAMp7/LKXcDPDikkMdpQ8AUvfdpo0d0cLpM7NVyD7umyltxMQE5IcGYaEyB+mL8HarKmxITFhcCgRMmlGRvlNSgU0wvmW7+FN4c1ZUTgwtCy8t7VFYxEchHP/gS7R5sICODPgDWRlD3FEoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321199; c=relaxed/simple;
	bh=+2aUDwdBf5VX5aNs40ryCKzqWZJxUH2DBk9jyBgiLiI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P7LwlgsOtCNx4lvpEX2ufXEfhpNnmWxT2fQGgM5uOkxhD8nXnFxeXD3mQl9uG4Iyj+lqIcG7Y7hrvLnxHc5YEEMx0C7WYlqy2u+6Ogke785VsqzBVYc2yUfehenvC3lOSHQTcdHmSYDlJC1XLQ8zR+y0dZIT33OFQNdECe/HXtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zsRXvhyq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so2443049a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321195; x=1758925995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WxyHpgsKcQtDez3DsslxS7ZG1Vf1q8npPkky8cqh6mc=;
        b=zsRXvhyqhZfq+LGc72f0F0ZDzZ34hVTRg48Amm35ywXu3tV/fbCEIhrGT5BFMrXH2H
         tm8HPbXhZXqAEGJNJyKR1iuWNaV+dpTrjF/68WSFt38P5fPg4axMshQIDe4om3PHRXGs
         osk2Kaql/5sIpkUt1++V8FkMkQAIBDfy8ymjKVBocwOPF79b1kXv6e1raSr12DFJ7uuy
         kzoEP/+f6LPMFMxrgTJpUMyG1TtcA0phKu3i3sHGEUu7iLDxzBGIPB0zX8EolGfxUBw+
         jbgWGeKxq4rOZTXTOUebJRKokizdx8r68ivZmBka8zcoI++zENoBdC/x63G70WxLJnx3
         F79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321195; x=1758925995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WxyHpgsKcQtDez3DsslxS7ZG1Vf1q8npPkky8cqh6mc=;
        b=m7qd/bZbvbNDQ9nnxkTbVMVMx52laho2jPGBejBU1ELF2L/83ap2ZukpYvWx4Myy0z
         wxFxKf4ogWVDBLhCQGg2z2YVyNFZoeWH/QxQjrVJnst6AGL/1+pyoxPoEGdpyjSBVmqY
         YNWQHAxJZBkiPVmRV1NpH8kIR/Zv7gwyb6FLikRW6yRMevXx689caspA9Mgy0CNrgBt3
         V1ZbSkG4CCgwgBSZViGcFyizJCyItblXDk0p7QLkWkPIwRBzHdCqXlU0NBedffabGVF0
         VI0keQx3JmGNSuDJCyp41C2eeD8anFf3Hcy9mShWfhbFqBuFD3dSJAKJdG/Z/NAb5mCG
         UWcQ==
X-Gm-Message-State: AOJu0Yw0TEVwXuMMsUoypMMtV+8TlyYeXGIWR7EQGI7Sa+Oliihfx8wY
	sdnjKP2D3oEthpyNpMW0BLj4t1CG0j3fRxcFU/qUivX2sD8yE21krtHgsszO55sttIjzTyNgksF
	1bd0lgQ==
X-Google-Smtp-Source: AGHT+IHyGMuRch1NMw5bn170EMBOJ+XOXpveOIhzOqOnVTBwfaBx1NBMPmhB0U1bZLjZA351DafhPoYPm3M=
X-Received: from pjbsq12.prod.google.com ([2002:a17:90b:530c:b0:32e:cc38:a694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fd0:b0:330:852e:2bcc
 with SMTP id 98e67ed59e1d1-3309834e1f2mr5304908a91.21.1758321194783; Fri, 19
 Sep 2025 15:33:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:14 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-8-seanjc@google.com>
Subject: [PATCH v16 07/51] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
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
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 arch/x86/kvm/x86.c   | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6b8b5d8b13cc..32fde9e80c28 100644
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
index d4c192f4c06f..c87ed216f72a 100644
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
2.51.0.470.ga7dc726c21-goog


