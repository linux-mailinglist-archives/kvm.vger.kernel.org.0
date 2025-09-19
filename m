Return-Path: <kvm+bounces-58266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3202B8B874
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3206CA033E6
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627AF30FC3B;
	Fri, 19 Sep 2025 22:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vmVo5RSh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0842830648E
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321255; cv=none; b=BRzefvqAYPT0HF+GPSfNtcWCfzReKqeYKeuEOdeAdihw5OXBehHdi3QhUeVOyVpo+2wpubqs0YKKkttcWnI1gWqcWfhY+Cv2W/6fZ+VZBDw/bPIYOil+7ej/55ISiAYx6MKoh5BF25B+a+GorfQLuR+F0c/V8oIXoJVad3vOciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321255; c=relaxed/simple;
	bh=FF0YNdYzHwSY46ksKq78ncvstuhhSVwb/Wk9sp5XIp8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sFipZ9najMdm8kH0604LK/SvNVzpulVE1iFkw32R44Kefv9DC3JcEpTrvMdKLhEbfoj8SpE2yXscipVg/NaQ1EgMjHxjrEUDDBPevpZHB5qiHKJUnEZrM0FcHEjIWDSD42P70mA0pRBDHExCnebSqpRMDGEfspMyEWo6WDz6cbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vmVo5RSh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so4309526a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321253; x=1758926053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BEmP/GsT5IlFUD0vcjfrEDepI8N6/XVRIquQ8fvmqN8=;
        b=vmVo5RSh951A2QRN3cdPwnRFhgcbOw2YRs/A1mwcmL4qdvGlFs1jo+xB/3O/qP1JYi
         JOURyBFhAr4+9a41SMRzq9vl6PLf9zjp7ErpS5U838DA3viGJiueAYCk2Gfr5G03DnFy
         ibXdJXAEJn/zUR37W6k0M0+zqtC8lUwSW4TMpm6odeHRDyxgoelRXwL9RwFJ/2p8Hv2i
         XFTUUdwGWqc6vyEEC2+FIQFaQ4dpDGS9XPHSzqqwmUTFD85Kbgo5RwSHuyyksHTTT5Fg
         GuEw48Nb8M+qB1yKc5C1TDKFRpfAPJbMZPmQv0o7YCXuT/Da8zGlM50X9eIbeDxwBiN8
         iV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321253; x=1758926053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BEmP/GsT5IlFUD0vcjfrEDepI8N6/XVRIquQ8fvmqN8=;
        b=Krw/WXX2i/YKhtCnQU6n9VRw3e9i0Soi36ClfQJZLA2M7Gtsa1XrOeOGrMpi9gsc9z
         +SQhcIVtKfaHFScXuX6xQQDm/zfdcowDXwsvbu13bv+Q+5vYSSryB7m9KNb0KNFzEDIU
         x/UhWQBuOWKLLEZMZRILnI+g/8nnBNhaShyOpBuaTDX3o7V0DDgjOZ04/yO31GwnVtr9
         qSY+hJub/hdcFZ/7hSU4z748V/RYusoRLlJSvzm4moyAOEcbAG/vdfHWsPw2uDSI34bM
         +yD+nXG+Qt0CUFu4jCbqZeORLd/epOfUG9JB9aWbv95pV9uxuuPDyoYWtkCeCvdj+YeK
         lAEA==
X-Gm-Message-State: AOJu0Yx7AxXd0v81X4sVm3HlOhlggqqxK5r+72LbsHoYfkdrOszfvzwR
	PLRzEcfAhbe36bwqXcyt04IQ1QQ6xmeqApFvAnfnPXofDAr+ZToW/Fg/PlpfZZLZYqMkhaiE/lH
	RD6t/+A==
X-Google-Smtp-Source: AGHT+IHUbP0czKsLHdhn/rdVGDEI3g7Pp41PPUqA9A1hT7Y0EvEbP3ye/5PDQ8UzNTKswDhISKcqoKahDVw=
X-Received: from pjbsj18.prod.google.com ([2002:a17:90b:2d92:b0:32e:a3c3:df27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d81:b0:32e:36f4:6fdc
 with SMTP id 98e67ed59e1d1-33097fdc41amr5642187a91.4.1758321253470; Fri, 19
 Sep 2025 15:34:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:45 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-39-seanjc@google.com>
Subject: [PATCH v16 38/51] KVM: SVM: Pass through shadow stack MSRs as appropriate
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: John Allen <john.allen@amd.com>

Pass through XSAVE managed CET MSRs on SVM when KVM supports shadow
stack. These cannot be intercepted without also intercepting XSAVE which
would likely cause unacceptable performance overhead.
MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e50e6847fe72..cabe1950b160 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -844,6 +844,17 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		svm_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
 	}
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		bool shstk_enabled = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, !shstk_enabled);
+	}
+
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_recalc_msr_intercepts(vcpu);
 
-- 
2.51.0.470.ga7dc726c21-goog


