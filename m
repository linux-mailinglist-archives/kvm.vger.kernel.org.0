Return-Path: <kvm+bounces-39464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C53A4716E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 899D01886D12
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1FC81CEAA3;
	Thu, 27 Feb 2025 01:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="25Zw1OxU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D011BEF8C
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619555; cv=none; b=pX+7LRY8wYE/XxcXX5Ue7wjHMXRzdFQ1bCqJXLEeFmmBgYwKigsp0dxs39neu3F4ItPpz6B2FwUdQRCTavGRYpeLnkK2QOYiX/bHXdETjUyHffL3z3Tw4cNPjELjeIpJNofnG9VHNHWZaq0W1vt8t94+h+uWSQ71elIwKeC3vxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619555; c=relaxed/simple;
	bh=8wNkxswFWdGH1HQRrKpFkvy/1TsnRMIlEykX12vyE8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dc2EBP4kEreHgPD6MJOLYNnK3HS8pLjy3+QX7IRvjn08f9Zlg/8ZUGTJPrEeIpZ88/iHIxbOKMGYdzZ6nasxGj8MRZ6eifKF3zGdRodGijk6bE9O1NMw7TphUXnC22A0tojvpPJ0b2ZN1vFNvmG5Ww+s1wb7ro1F+NnLt9Xzhfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=25Zw1OxU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fea8e4a655so11412a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619552; x=1741224352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/9g8YvMgE4u3p57YSBM8Zk/O02fgzICd+Y1XSuEDMWk=;
        b=25Zw1OxU+5yPGgv5C+BWcIzSDzSiQgS9yLR8C9b+G/Ga9PQFfUfhQNrrKJcQ/UNCHG
         CWWCiZgWydKcKq1W7hXeRaJNQRchuKJCCHC7icKZjjZ5leQJhsHgpZOvmmWblFWzAxF6
         C3FsPysw+Ih/M1/A/LQrzdUbl8AsdLqw4T9G3aYvuAFIVvSISixTX0Gy1Is25aCJsNLh
         OJsvJ9ud0W8dE918JCOAD4KmBSnBY9EGN2TysHGfFpyQqcE4RoBF2ROJzwXwsNA37Okp
         YQbgsLPVIi2NvFNPNBi59xjUlLcEw2NOxJcKgUMrgExmsz96xOxj+TKc6ZFY9Zs3+yIG
         C3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619552; x=1741224352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/9g8YvMgE4u3p57YSBM8Zk/O02fgzICd+Y1XSuEDMWk=;
        b=daWjXA2N0Mhuh3KFXNQNwXdvUYbeNBDTGSxosCJGtzX79MhrRDyyp5XToWhijgjmD4
         N32M17IqBQmTkUdYqkcm3xbO9Yc02g3+KLMRnvRrqnCN5wYzD+OyyQtpePyGmn/rKHnq
         j/qjJ13wcGeFhlDFirtq2lOnyGjlT2wYbqvQsp/LlujWfjEVHmP8MLlS7N4X6HDmdrGK
         jL5Z2+Ja9Afa0RsxbNToPwyeBVtCrQDoDblxmpTlSU+wEE4/vOHVVYmkeTuNoA264CdE
         l4rbLS0vAum6Oc7gEsPMSCay2dW5eFd5GjFggFkSBIjwzZ9zOTIXHSwAcCWSGjc9Xehz
         UBPQ==
X-Gm-Message-State: AOJu0Yw9wGG2MJu9XK3RhPMYyE13yYL1Md6jextELNq2qydgLcRcXP8f
	CHHvOZeEZ0THvo6ODLEjc7OFVKwTiNUSxgZx7FGa6jkuriDx/bMYKVFy5NXkWBVKi32DMD3Kskr
	kuw==
X-Google-Smtp-Source: AGHT+IF65rUIuTMqRgVl+qHoagCMc0Oa679N7rInTQJ8+VGZg85VOD9YW+b2TmMSzy1ThwGbMVoYpUEMUg8=
X-Received: from pjbse7.prod.google.com ([2002:a17:90b:5187:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2248:b0:2fa:2124:8782
 with SMTP id 98e67ed59e1d1-2fe7e39f185mr8673035a91.25.1740619552385; Wed, 26
 Feb 2025 17:25:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:36 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-6-seanjc@google.com>
Subject: [PATCH v2 05/10] KVM: SVM: Require AP's "requested" SEV_FEATURES to
 match KVM's view
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

When handling an "AP Create" event, return an error if the "requested" SEV
features for the vCPU don't exactly match KVM's view of the VM-scoped
features.  There is no known use case for heterogeneous SEV features across
vCPUs, and while KVM can't actually enforce an exact match since the value
in RAX isn't guaranteed to match what the guest shoved into the VMSA, KVM
can at least avoid knowingly letting the guest run in an unsupported state.

E.g. if a VM is created with DebugSwap disabled, KVM will intercept #DBs
and DRs for all vCPUs, even if an AP is "created" with DebugSwap enabled in
its VMSA.

Note, the GHCB spec only "requires" that "AP use the same interrupt
injection mechanism as the BSP", but given the disaster that is DebugSwap
and SEV_FEATURES in general, it's safe to say that AMD didn't consider all
possible complications with mismatching features between the BSP and APs.

Opportunistically fold the check into the relevant request flavors; the
"request < AP_DESTROY" check is just a bizarre way of implementing the
AP_CREATE_ON_INIT => AP_CREATE fallthrough.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9aad0dae3a80..bad5834ec143 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3932,6 +3932,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_vcpu *target_vcpu;
 	struct vcpu_svm *target_svm;
@@ -3963,26 +3964,18 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
 
-	/* Interrupt injection mode shouldn't change for AP creation */
-	if (request < SVM_VMGEXIT_AP_DESTROY) {
-		u64 sev_features;
-
-		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
-		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
-
-		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
-			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
-				    vcpu->arch.regs[VCPU_REGS_RAX]);
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
 	switch (request) {
 	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
 		kick = false;
 		fallthrough;
 	case SVM_VMGEXIT_AP_CREATE:
+		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
+			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
+				    vcpu->arch.regs[VCPU_REGS_RAX], sev->vmsa_features);
+			ret = -EINVAL;
+			goto out;
+		}
+
 		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
 			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
 				    svm->vmcb->control.exit_info_2);
-- 
2.48.1.711.g2feabab25a-goog


