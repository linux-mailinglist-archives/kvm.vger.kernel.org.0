Return-Path: <kvm+bounces-38530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C6CA3AEE7
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D654216684A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CC4199EB2;
	Wed, 19 Feb 2025 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VxM/Ofvv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A799189902
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928437; cv=none; b=O/8XhoOszcGkjQ70FaltmQD7+NQya9/Lc77ALRr4UwIcWehMKUiXv+jIMcnWeImdObFIWi+XgrEdt0NlvTxhH4JM5rNuropTw5VUXs4l9kcjypUujvaRQOUA7o/MoIBWWBaZp73vKI/5opOXr89uPow+ZcFAkDF8+3ImtaPGPsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928437; c=relaxed/simple;
	bh=1uJkGwGwnraXe8zGYXAmtpbiv7YmImMEb/2dv74uGGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UoHeT+Km50rz2R82w8RpqyXcKAVc4oe2x0PMyo1YAN54x3N546idcPJnlbnLtihOAKWJSNWAdVwN/ajJinf/0z84BxPl8fz0gW6ywiApNzhnt0dnNz+q3RHLNFytDRYxSl6t+qL8sPWPHHjeDZ4ls+2d9HDCcUYC5LgUgw3ePrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VxM/Ofvv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220ee2e7746so94943595ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928435; x=1740533235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hUPfnDvapq0pxQUdNT93GvWgI0A9Rkgcd+wtudK6DPM=;
        b=VxM/Ofvvj1KSCj72kKG+3cJQ+TKjLfGW5NPIxPcD7N2G6MDKByTdWh+6kTIUQVRGWK
         uHrs6SktuMk96U57qioyvczKk7iiN6NFwEWWAiatpWa9OWeByUozQspG+/neGmkaclYq
         KRcI3ekToYpG0qjb5egoYJdnz1yLOMUgWMSlJQHELTPi4xwcalJZr8TWPcn627pGKm1D
         nnhUOWq0hiB4LVhoLkidRbjXk47JQh/fYlKhM1Lar2xQRys7i96BqrA6by1MIPTvBkmK
         MRNZEGrf1bs2Uan/pC+XI41O9HElaaqeMssP+PYUwPT1Y8cy4tbs0SzyDVDe/w/ThErR
         WdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928435; x=1740533235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hUPfnDvapq0pxQUdNT93GvWgI0A9Rkgcd+wtudK6DPM=;
        b=C++7pu/h/OM6C1Z9yrbNtxL6ZXEtDfOsS1Qf7KJMiUaf/TO+3+FxkjIfwQx0+QrAVF
         HYL1pQ3qe82+58ToREP7uRiI0R+zM/HVQibsy9XluDvbUeLwP8W/al7+25l9Ad8R8c2+
         BWKA9u5pgsTsKiPlRtBcNx0/V0APajrzZX+lqSUC8Ooo6Q3I1SfpAuAW9bZTq0im5dhj
         hmwh6EY8sgLBeROE8Nxx3Gxs641P7jSE/0Heh1CstMRPU+QFszulGb0KdQjArBp4EPf5
         wWwGqXzCLuZDOtedi5HmZkzP85f6yk5aCQ405VWqPI2QggXCKzV2qSuGZnX/4IcyDOkU
         DFrA==
X-Gm-Message-State: AOJu0YzUPwhHizTtwmvmJQfI5E/rPk8wMA1w4klgnMQo8TcO2fTjPiBr
	D5NIo+zT7Aqqz3PuMbfIomfxrA7QYperU7yS/QHrEbgRdGj90FoFQKSlJEczh1LC3BnQY4XXDEj
	miw==
X-Google-Smtp-Source: AGHT+IGUaZqmHLGvTqjTlq0pWgcuq9Yyr5LZzrmTiqligkFeuX7GjqON9gMPdFUYb6mGs2gDj48dSzgoiaQ=
X-Received: from pgah14.prod.google.com ([2002:a05:6a02:4e8e:b0:ae2:57bc:f8c8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c70b:b0:1ee:c6bf:7c49
 with SMTP id adf61e73a8af0-1eed4e3f207mr2507708637.6.1739928434840; Tue, 18
 Feb 2025 17:27:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:26:59 -0800
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-5-seanjc@google.com>
Subject: [PATCH 04/10] KVM: SVM: Don't change target vCPU state on AP Creation
 VMGEXIT error
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e14a37dbc6ea..07125b2cf0a6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3959,16 +3959,12 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
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
@@ -4014,20 +4010,23 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
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
2.48.1.601.g30ceb7b040-goog


