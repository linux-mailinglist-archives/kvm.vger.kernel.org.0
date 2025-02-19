Return-Path: <kvm+bounces-38531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C67DA3AEE5
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0889A188DACA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BB91A315E;
	Wed, 19 Feb 2025 01:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u9jl//jl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24057192580
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928438; cv=none; b=AOavi6hwiQAkVRnUvWhvuuGYjyYi0js57sU3uaiJhl/4sOGJRRgUTyt6Cz88zPqI2eiRLaFi5q4mI1z8IhKLAqRdVLdr/6SN+p/kD0TphdllHBToq+8UwGk4IAt2BJ0YBNf+tOoJ5c6aRCv5TyxFGZQx0dDD9OjLT2KYCFj8cJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928438; c=relaxed/simple;
	bh=HS/OGyPieAUMN+o3iI2SoK4HV3gkuOhVEedxfxsJjPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lt1Pd0uPFeABS7NjhArS4ZxgaPGOwlQIHMC8fhvt17LUJhO6jwqL/gGXUyHQUz5/DrE4/7m0FUKenRJjDSsS1RLFevTOL0v+VtG/Zl3bZ3ENbivG1JNL1XmMiuUU/vvEAIgOFaI2F/r6YvoFzBhgr0n8AXYpSrirhk8wKovmGOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u9jl//jl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc4dc34291so6417241a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928436; x=1740533236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NOqNLm8zpj7r5p6cWzA7ewxdPggAPFsC3tCvVJWmq4Y=;
        b=u9jl//jlRAahR95FDOsHeizXwb1pgeMDafOZHlQQesOI1vN2zy6zUpZJT3fg48xV6f
         6X9kAVv/1h51opTnnjfrP1HfAxMcv/qWRhkMZKym3qbOXdwKQdLFNELQiD9q9K7buEkc
         C1i0tf/pduKH0Zm61BbHU5vKHd3BkR9s3+NSkM9kdIxmZiJbFwFreV/B2lnYjpq8Jzts
         OTn8aUZ+FkHqo03b6PRfK7o2z4qcWaAvTj7uj/qYWc0r84TJ6GgDHD0YSa45Gei6ESUj
         4v1Kg8QirG7L0bgyuidv3U6q0gi5jUa8Nb+O1yQamcMhQ2odZ6A4+fFeQR3oEIPaKPX3
         i5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928436; x=1740533236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NOqNLm8zpj7r5p6cWzA7ewxdPggAPFsC3tCvVJWmq4Y=;
        b=m7ChGIvspqlfNBdG75dLK/A4PQlnw0XxNFwCAlfd16J4DH9Pz5hhN75BmfSiIS51pB
         0RicQFPoRqjt0NrUHY19//aSZtagH3ITyapMFVX/nN3FQ9piPav6t0uXfm2cgONXqfnc
         guVdBsU1PLVbTCl1/ShBbIB/o+WRnwFX6dM+n0BA7XRF9pb+EebH/yicQf5227cSwJ+2
         KsrVkH7q4JN65HLJu4L8knAyBMfGI9WwlESBH8P5ZA6WzteV7p7rZqTMQe4GbtcIoGYF
         e8oW6pe/U/3SNEmk6hjg5mD7NDgfJ23jNVSKpAZQ7az3GhGd6UxQsr/cAU3jsdiwfvPh
         gnDw==
X-Gm-Message-State: AOJu0YwXUuV0HUeNtmEJbI+1KKPr/Sg/szlVa+uGtQcotPigJPHLJPOL
	KXvMc4Ov7myilS8q56Zt/tVAfzNQdiUn33vm4hBNQxHdImPKLALPL8KtLlkEecwdIML6k7Owfc8
	/Cw==
X-Google-Smtp-Source: AGHT+IGbOdETGV4/8dazx0YgIjrgRH1peDdIwCZwKiJ8gyxb6gn3o4TseTvRc52oNdBvm8Q95Zspls7KQ0E=
X-Received: from pjbli12.prod.google.com ([2002:a17:90b:48cc:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f06:b0:2fc:3264:3667
 with SMTP id 98e67ed59e1d1-2fc40d131bemr23974637a91.1.1739928436566; Tue, 18
 Feb 2025 17:27:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:27:00 -0800
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-6-seanjc@google.com>
Subject: [PATCH 05/10] KVM: SVM: Require AP's "requested" SEV_FEATURES to
 match KVM's view
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
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

Oppurtunistically fold the check into the relevant request flavors; the
"request < AP_DESTROY" check is just a bizarre way of implementing the
AP_CREATE_ON_INIT => AP_CREATE fallthrough.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 07125b2cf0a6..8425198c5204 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3934,6 +3934,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_vcpu *target_vcpu;
 	struct vcpu_svm *target_svm;
@@ -3965,26 +3966,18 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
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
2.48.1.601.g30ceb7b040-goog


