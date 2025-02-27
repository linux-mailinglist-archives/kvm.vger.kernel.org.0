Return-Path: <kvm+bounces-39463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C024A47159
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 088483AE4C3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0CC1C5D7C;
	Thu, 27 Feb 2025 01:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ImvSxEue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F5117A2FF
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619553; cv=none; b=ks0Upgtt+WAe/XxOSGu5vOuRdfiap+MPWmtEjlX+zlrMkwFxyew6dR5G78FGL7Ox+u0ku4QVrolSmZSO6LUJPFVQv1xdctuayerEYS5grHIXqziyax/gNNLisPSUbMaJt2PBetLA2cwffwvyhid242qXi254/zVxaWZwKZ6RTBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619553; c=relaxed/simple;
	bh=Ewaz9FSthSc+aO9YPlgCWiZASwxM0Q3IHNbCrYZLtjE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V7hDWO4bReyqgUtkmjxNTuP17TAquam5OagLpL4mzCfA9iB/n7yOBG0ri9+sIKKa/7J2s6L7QUYu6lGMgVkxp8LtAwh4woiKdxpCQ0IeDB/+qFanq33OkKqk+1aJyN0+kBkKGJ2X/tEuQ6brLO7IwHjgpYY5MI1f7fA7c3LOu6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ImvSxEue; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so1430387a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619551; x=1741224351; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sGOwbvJmfkCQ/c7rRacZC8cGcdWEXYUj8tUGbmEnuuE=;
        b=ImvSxEueIAH4AOmrXFYV2IcuZtNnCapc0pNkrVWrOiqXXZtDcPrkyDfcVYIWWTRrAS
         uPARJMNA2kUev5LdmFd/mnNkb3JLTFON1kGj2gTceIkPduV8JuQ6lQqTNZZNuiDW3N4V
         U9Z8Zohb63sxYcvniUoj0PdqH+aOrgr0y4u0H1fyOoSFHAWce9X09N27ov8We47D4mP5
         2f8udvpxvvuF3DNtq1cE/AAJHMe00N0rudyXnuQlxReudj7duckLRdZkONPKFGBlDbRx
         9SUau9LHho3HrBtUWmaWYcU2Y1x55qBa66FC33jW97Tul0bkf98VQksi205GvsXTIYRG
         8+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619551; x=1741224351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sGOwbvJmfkCQ/c7rRacZC8cGcdWEXYUj8tUGbmEnuuE=;
        b=Rtdjg1v62EgWIjlf5G27a4NAbygaogR9pyJVnFdquXORxazWWf9iYg7SSyuAbDuk/d
         h0Q/oKVJxZ92eC9z8zEcmniw+B+HJIKsl29jJ0wj5lZB+2fA2EC319uiCfu/9xQyhH+6
         cVNT7TeBjRuZClwxCTmzrXf7PV2P81xN2n3Ai5+NYcIsVcgx0TCH1n3bMZ2POxDAYV4n
         v8Lqhyn3V4daEyWSfpeIBVc3/n1Vo5+VdrKMvdg+d3uNRiae4AUkr/OXj++jvZtupGtE
         0U2IQSVodhrCDcqFiJhFCnoYhHz4C8/XM/PXpciYOXYQQsXftBOtcAPtOLUKg4iEVdfr
         c8YQ==
X-Gm-Message-State: AOJu0YyfrCQXQWRnUP8Yo2OoNprteOwkH0WYHm7A+Byqp5mDG4pySx33
	HJeedX9wym3p04qNrV1+5mR8MFJJxNrOFaNMWpPzePMYkNx8c3gnIgBSFE8woRJ+rIKTm1j8NV/
	c7Q==
X-Google-Smtp-Source: AGHT+IFyryo7Y/u0uoVmOAJ5RVcaLpqcG1z9HpmL8i/TdRHGqTe/axQ2uqXYM/vYbUj6f5PszfDahrT6N+s=
X-Received: from pjtu16.prod.google.com ([2002:a17:90a:c890:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c84:b0:2fc:c262:ef4b
 with SMTP id 98e67ed59e1d1-2fce86cf0e0mr42713073a91.18.1740619550877; Wed, 26
 Feb 2025 17:25:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:35 -0800
In-Reply-To: <20250227012541.3234589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012541.3234589-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-5-seanjc@google.com>
Subject: [PATCH v2 04/10] KVM: SVM: Don't change target vCPU state on AP
 Creation VMGEXIT error
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

If KVM rejects an AP Creation event, leave the target vCPU state as-is.
Nothing in the GHCB suggests the hypervisor is *allowed* to muck with vCPU
state on failure, let alone required to do so.  Furthermore, kicking only
in the !ON_INIT case leads to divergent behavior, and even the "kick" case
is non-deterministic.

E.g. if an ON_INIT request fails, the guest can successfully retry if the
fixed AP Creation request is made prior to sending INIT.  And if a !ON_INIT
fails, the guest can successfully retry if the fixed AP Creation request is
handled before the target vCPU processes KVM's
KVM_REQ_UPDATE_PROTECTED_GUEST_STATE.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 218738a360ba..9aad0dae3a80 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3957,16 +3957,12 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 	/*
 	 * The target vCPU is valid, so the vCPU will be kicked unless the
-	 * request is for CREATE_ON_INIT. For any errors at this stage, the
-	 * kick will place the vCPU in an non-runnable state.
+	 * request is for CREATE_ON_INIT.
 	 */
 	kick = true;
 
 	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
 
-	target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-	target_svm->sev_es.snp_ap_waiting_for_reset = true;
-
 	/* Interrupt injection mode shouldn't change for AP creation */
 	if (request < SVM_VMGEXIT_AP_DESTROY) {
 		u64 sev_features;
@@ -4012,20 +4008,23 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
 		break;
 	case SVM_VMGEXIT_AP_DESTROY:
+		target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
 		break;
 	default:
 		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
 			    request);
 		ret = -EINVAL;
-		break;
+		goto out;
 	}
 
-out:
+	target_svm->sev_es.snp_ap_waiting_for_reset = true;
+
 	if (kick) {
 		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
 		kvm_vcpu_kick(target_vcpu);
 	}
 
+out:
 	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
 
 	return ret;
-- 
2.48.1.711.g2feabab25a-goog


