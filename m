Return-Path: <kvm+bounces-57471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69B8CB55A33
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91F295C4B96
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 858452E0410;
	Fri, 12 Sep 2025 23:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BQ3fYdIr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E602DF129
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719458; cv=none; b=Zc9LQG/njhuo1bjzHnxwfeqtEDzP5ytaY8N30jMJDyNbeG1qEib9ksX9yiSHbLU22YWckDHeNF6AzzALIEb7xVXv/vqbNkUi5SAJCWg110PZL4cAGNz5Yv0fatcSbL5Mfg9jWOOtD0Y2rJAdRCWAr4KVavXk7j/Cs4SlAURCcVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719458; c=relaxed/simple;
	bh=D9+M1ofPK3BLJQzsUrcajnb1SD4gWSQfdTr3TnAALuU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aPwzIf8rfRSdUfpakSRBLTQDaMaUdBywnJxCfZawIYpihHdqO7LG6HVW+88dYdMBaS9JCyHH8qBh2RrD14rbAKRv0XRjrG9tMgACXqax9OjhZtejq9E+xAxb9WDJrXAxe7TluDQ3EKNOqNEbAummPCbEisz0tAcmCqLxqCJQWc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BQ3fYdIr; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7742e89771eso2104909b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719456; x=1758324256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LhbYsL9ohofofYA5WH0d+8AOzIebXp5NvMLeLGAcWt0=;
        b=BQ3fYdIr+B5rekEYPiq8hvuL7OHUkgr9QXDNRyFW09gMaC8mHNhyNxITqcxCH1PKYI
         JJrH4b01KQLWpvgcvP0ErAc+8KEWS0Kz7sXCBFDmtzRxk4mcesW7Uln97o6iF8vtA6xz
         zaGV4XHGelysfzZkVKJVvvJPxy7+VlM/WHdLXBrx7V/EAQRWsQoKn8v67UhnHlo8CMDI
         3qD+LsC/khoGy5b1LqCD+1q2VJTc5gFzUmDPn10xwYEabeGc+2ArHdCZmzLfxxD4yelf
         268lUoB9V/xIGJFYywR5Ob2YsWdfMPz+UAqBIP8YJkJcdL2cIOqzUcq5Vj0/I/zs1AlP
         dIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719456; x=1758324256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhbYsL9ohofofYA5WH0d+8AOzIebXp5NvMLeLGAcWt0=;
        b=E5wPhuUwdjXe/xKQvfxyJKcM3j3zBP8G2L6gFbSwrhayOoEhciKne54+Y7F6hu0T3s
         FugrkG6Ci/yAnoWcUdA8tI4dzDkKr7p7UdHL69EYAothQo27XpVBaocHDs07Tl4c5UGk
         dJa51hramD54kVx3FTSMuDoYcheau9/Sp1ui1mEUrCpT/ABANlFWxGEcyftctMmA0X7N
         POm6XvWcEvM3NWt0QaCD6CK7u9UsxwodC43qqtSA32BdiXDWoP7C9OLUHEclB9e6BJTt
         oHuqOvqTE411hKqEHwRb302p/mPH5ZjJQFeSJNIfCDXdZ9522HObYp6b623ncoBQI1ti
         aedA==
X-Gm-Message-State: AOJu0YxpLu9S5kqhJOHc0dvoyCiKo3UvVg27eicEFdAOR53GfapOXGwk
	bn6ly3ugfnVmcV1gQSHkNubRnVNBcYxmDdEu0jR/mPwiikWnOWwieECccyuTV2j+yIrwCc/6xX2
	M/PzXRg==
X-Google-Smtp-Source: AGHT+IGiazytCcQivJd/z18yTw4cuKfPDtfsmZgzKKLKFis41yXiyg2GvH7sp/nin02dzFY2c+tpO0ox1v0=
X-Received: from pfbhr19-n2.prod.google.com ([2002:a05:6a00:6b93:20b0:770:586c:bc01])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9194:b0:772:2bcc:d2d7
 with SMTP id d2e1a72fcca58-77602fd1bbcmr9213653b3a.2.1757719456310; Fri, 12
 Sep 2025 16:24:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:06 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-29-seanjc@google.com>
Subject: [PATCH v15 28/41] KVM: x86: SVM: Pass through shadow stack MSRs as appropriate
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
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
index c0a16481b9c3..dc4d34e6af33 100644
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
2.51.0.384.g4c02a37b29-goog


