Return-Path: <kvm+bounces-55073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8803B2D073
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6C635664C6
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215CD277CA2;
	Tue, 19 Aug 2025 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SwyH85sN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA42B275AF8
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755647325; cv=none; b=R6Tc0oa1dtoimuW7pcxJA6aocRajexGcBhIpOy6SI77t8sKSC7uwUQSHEdVinEQ1PNFiNq0azrAwNY8biZOLUZSNLeqcpSEqVn4FNsWDgnCKuRGxY7IuhlpBAQWTYPiv7Ebx/aXDlGg7pCJaO11UBWRucrXxFzcYAv3Q394eBoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755647325; c=relaxed/simple;
	bh=mmU8zygcUZCUXFONTWyt6rEvP+1h9unYkwdpbTDHFbs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cQ/sWu8Y3ligNK7HFyqUsTwomLma+Y9hPsWDKM74d1v3Qq9wGUYPem6alCChUjPbHPPL10ZVibj9Svt/F0vN/8I7CuFu9/7otp5GELLvMiZoe64zDZU5WhEmVrHfDS2o06JKidt1qJZAr574b5TxM8eZVsGHBrQcQEeECsGAGdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SwyH85sN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445827ab71so52781005ad.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755647323; x=1756252123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VoTBCaXY3tsMquNWLPxjI77aenMDU1kT0Y5i5aPfTX4=;
        b=SwyH85sNjLNGVm9VmrA9pQzN4nAeA/VJtlN+T1tnj4DE62muGfH5gXY4an1pwXaIY1
         TdDfikjQs/5oA/w3aWU/kGCH9qeQ7E51ziqbzWxKIhMZOGhBfpjivsO9uQ5RnGM17Z0f
         whv2mO8KlwNbMIbvT7LJ8UVzilLriWw41z+40WmgbqAyln/aL7kkz02dVyBouca5XbZC
         FqVEP34ItNPTCZkMbAHM0sEgF1QFjlFsWSgYD/WnkHf7eWamIJnaWucqERpI1J1d36W0
         9zt4Nnfn0JZlDfyDgY7G7ZEVoBLb4lzNpSVS2DkEjgZwAgAs51As4ywM8TF0oG1pmmPi
         xewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647323; x=1756252123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VoTBCaXY3tsMquNWLPxjI77aenMDU1kT0Y5i5aPfTX4=;
        b=F9DbiVvlgf4+1q2K66dgYNcXI5PbtR7jLX6oQxhg0Nzt0Fln0gNjJ6zxmD4fgCZa15
         m/YFUfoDXU8CQqAkI0H+zASh4uCqx1BY9GD7lY8+ym1GVattcQnwBcCdqFbfdmAC+yF5
         W7eYc5n0RkP8MexPIFKr/Ty09hmo0tI2Cj51lvdExUjsYwvK86vUCneUVghGant2iJ7j
         d4SbFDKkgaDA3ixhBCSSjRpuS4rJ+rrsfWaA/cbcdN4hOe9JtmtOZlfeCYsTh4/ofruh
         jGW5z3caQOQFvLPHtXCeVl5WqGU3JPWakZdWAv/g5WVz2PJZCmWL4phMQEOlVx6kWxIl
         u0xQ==
X-Gm-Message-State: AOJu0Yy2BkAcxwvV8WYuY1STTo70uY/3fSJWWwsWAVN4EAq4bCcV2bOo
	4Jk73fBDdeg78OPMnldpp3Hok7KQ/v7EBZn50KTSV8cinHDEQ/Qt35yOWwoeYjAke5mbylAn5xM
	TeAKEdw==
X-Google-Smtp-Source: AGHT+IHz6Nf29rgTStJH3LOOvkrvfJrg7KYd0YUyoNhZKV5AL3xY0E8ZF53ljkG7owqmAXeO9+/vk7Qe/eA=
X-Received: from plbma16.prod.google.com ([2002:a17:903:950:b0:242:fe5c:e0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccce:b0:240:2e93:8a9a
 with SMTP id d9443c01a7336-245ef269392mr7253585ad.42.1755647323253; Tue, 19
 Aug 2025 16:48:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Aug 2025 16:48:27 -0700
In-Reply-To: <20250819234833.3080255-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819234833.3080255-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819234833.3080255-3-seanjc@google.com>
Subject: [PATCH v11 2/8] KVM: SEV: Enforce minimum GHCB version requirement
 for SEV-SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Vaishali Thakkar <vaishali.thakkar@suse.com>, Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Nikunj A Dadhania <nikunj@amd.com>

Require a minimum GHCB version of 2 when starting SEV-SNP guests through
KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
incompatible GHCB version (less than 2), reject the request early rather
than allowing the guest kernel to start with an incorrect protocol version
and fail later with GHCB_SNP_UNSUPPORTED guest termination.

Not enforcing the minimum version typically causes the guest to request
termination with GHCB_SNP_UNSUPPORTED error code:

  kvm_amd: SEV-ES guest requested termination: 0x0:0x2

Fixes: 4af663c2f64a ("KVM: SEV: Allow per-guest configuration of GHCB protocol version")
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 212f790eedd4..e88dce598785 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -405,6 +405,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_platform_init_args init_args = {0};
 	bool es_active = vm_type != KVM_X86_SEV_VM;
+	bool snp_active = vm_type == KVM_X86_SNP_VM;
 	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
 	int ret;
 
@@ -428,6 +429,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (es_active && !data->ghcb_version)
 		data->ghcb_version = 2;
 
+	if (snp_active && data->ghcb_version < 2)
+		return -EINVAL;
+
 	if (unlikely(sev->active))
 		return -EINVAL;
 
@@ -436,7 +440,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->vmsa_features = data->vmsa_features;
 	sev->ghcb_version = data->ghcb_version;
 
-	if (vm_type == KVM_X86_SNP_VM)
+	if (snp_active)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
 	ret = sev_asid_new(sev);
@@ -454,7 +458,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	}
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
-	if (vm_type == KVM_X86_SNP_VM) {
+	if (snp_active) {
 		ret = snp_guest_req_init(kvm);
 		if (ret)
 			goto e_free;
-- 
2.51.0.rc1.167.g924127e9c0-goog


