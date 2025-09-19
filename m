Return-Path: <kvm+bounces-58239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C66B8B7F0
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B35477BD07F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3342E717D;
	Fri, 19 Sep 2025 22:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1CdpEbhi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C136D2E2DCB
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321205; cv=none; b=Y76i+B8iJ4vIZ0x8iBNtQEcYslYxHYuv30lPUHyCr1nm+tGfpo8e8HBtSyOSqv3FnTWFAHRrepVzMpSNdQrgDLjHAwoEHG8o+vRLC75meHFGOEVrHdzy3I4KwJrGBjZMOX138esj+9YOLEAALbDAWb6pBqorvYNtp1SNBFebqGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321205; c=relaxed/simple;
	bh=XDTQ3tmfi6PZrBtBwIXn39EFZb7wdac6Jspf4/pSmcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ijKAyPz2E8r8JoESNihh4rMfU0Wqgxc74A1+QvkLMk+1+QvnK8rqBMWVEw1umbjOn13tX+fHJfEp3CwR+SRgs3JdYjyJ8fjFFISyG1O2b4RiJl6HtGGAvuh2+eZj7aO49ywb6gXzj0xfaJCmi4tBIo5JxiWjvaWb8W9bi+EpJVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1CdpEbhi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457ef983fso47227305ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321202; x=1758926002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vK7f/VGUWllVW7AxxNHDM2H0xPEmsYVTGx9qq6v/NuQ=;
        b=1CdpEbhiHsg9OTTHfstT6+UN5y9TLvg1ijYKBgZ6nV61eQVLxWAOf/sr+00+TfCEZi
         tjFY/GPtjUHU+48xAxzkICRE9xthzCuu58MprnBnbgEgHUYywExRJg2XtMquL3xj0T0k
         EPXeyK6kbSITJzk8oaXWJ+BSZQTPXe62B+ficmHFvmTBcpQ3HkVNiAHxGui2eCnOmOqO
         ABHJ+18Fv8m9DP9Ph/PCBaosE2YA7wl9qXtCtmuqvK2fTc/65zianMyKhDAbPyl0cQ/l
         EwqN2EZWi91Rnf+fenrNJ51MyhpfMUbtpuNcGp+HtRE/oWacYxSIGqPguZV2BQaXuTKB
         eiUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321202; x=1758926002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vK7f/VGUWllVW7AxxNHDM2H0xPEmsYVTGx9qq6v/NuQ=;
        b=ccFGai4JRe8lN4i3HIxTvIOulTdc2M/7aGQ1Sv56iVg6zDDDtZTvv+0RE1e9t0E9IX
         oLddbWrbwbauL8tBZOefe2h9Zm8WRg8WJ4GcwtDDx8DRG2PDGzt5z7fQ6spwJntguFR4
         xYZiRuFdq/YdSIXD4Y3dCfsJYndJCg1Epjrsdp6SJ0C2AgsugXufCeOSIkdUawCoXPyA
         ynCrM9g3C66A171eMwYEZK3frFzNiiHajeMKekP4BsdassKlbEAsM2t8zcGFnk7TpMgp
         h6BVyF7LWqbHR5WLLgT229ct5iNboRP/4t0kjAdx6aeV2hZu0+87YNw68ILIoSps7b1L
         QSdw==
X-Gm-Message-State: AOJu0Yw0hYObc3KJX0CGXhpNuWDH7hYXev7BKiKdXQW8P7BWuS9ylDpe
	VCauZ0sJUocmRggd81cqTXjnOGLx2g5Fl7PzxUMugKJJ0MK66myDNb7Iazur7orqaLQvIB9zNYH
	ZzO86Lg==
X-Google-Smtp-Source: AGHT+IEhLi+5mQCpDa2G+QupkEqfe8Hp43V+hOTG8T+hU1K21FndSGDLtWyQBh5uTqjUPG6FYD52vqx9Sh8=
X-Received: from plcz20.prod.google.com ([2002:a17:903:4094:b0:24c:cd65:485c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f8d:b0:269:6c70:ee2
 with SMTP id d9443c01a7336-269ba5455b6mr73260355ad.52.1758321201946; Fri, 19
 Sep 2025 15:33:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:18 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-12-seanjc@google.com>
Subject: [PATCH v16 11/51] KVM: x86: Report KVM supported CET MSRs as to-be-saved
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

Add CET MSRs to the list of MSRs reported to userspace if the feature,
i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d748b1ce1e81..5245b21168cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -344,6 +344,10 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR, MSR_IA32_XSS,
+
+	MSR_IA32_U_CET, MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -7603,6 +7607,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!kvm_caps.supported_xss)
 			return;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+			return;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cpu_cap_has(X86_FEATURE_LM))
+			return;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.51.0.470.ga7dc726c21-goog


