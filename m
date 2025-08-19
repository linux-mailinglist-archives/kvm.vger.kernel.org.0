Return-Path: <kvm+bounces-55072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB09B2D070
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97FFB5663DB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7DF2765E1;
	Tue, 19 Aug 2025 23:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tuEIR0bH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A262749F2
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755647323; cv=none; b=N3BeHgoWmVcQV81r6j2ZpRrCjLdJ/n9NvD7jPaRR3bkpU4RetBKG5ceiEMvZFIgzmTEObCnXsmFw5BoUa+dTUsIUBatT80EO5KxlyIFq0cBJPltSN1NO2JvBKgShThZMA/Qmnh+kxMytuOcVKzZp9FDoXo46dRfxF+a4AH6sVzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755647323; c=relaxed/simple;
	bh=adx+8BVJXD6hnpBoSfGexmnW5fT1Mhc9heYL8oa7iek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UQP4zKL4vH9jKJsKaAKDuPTtZKnuTKdrNINR7iFxvgWYH9ikReIugklPulhMMTokTUWNk+jBj2UdqGhyl0k8Ym5Y6Zps1mja3p/kBuxNmXIl4Wz7Vouw0EASIh1aO4wbfreQPUKAa7AXJpsSAn5hPhhfedOTvGEGxWUPYmkYk2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tuEIR0bH; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2e9a98b4so333630b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755647321; x=1756252121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7/h4Lzi5fzI0qBE6eX0TONREqZIKaotMYznXSY25UL4=;
        b=tuEIR0bHsvYEvXhsTVqmoZ4BrBDhuYyb3V/966NSZyvhrbUNa+AU5UDJwuzF0fmT43
         SofyKHc4lAJQIxYqb/Z6L31Hju+CJxMhi3kgqaL92nhCPrXUqHQZ0yniH4DjKmQVJvhb
         lUvok0eRZw77MEQ8SmLdJJZ/E9P5wWUIQoahoVFShYSra3BS3pRNEZ9ftdN+v2Xd/Co9
         Lm99INfoRzO9D7jhLty1mJdTGJIGclUn/GbcjuOKrGcDnYZmBQYvNfRRHkOuWgj74nnt
         IowtIzZrBXgQcnY1/IjQIvW1hvXAg/7l3asamFGooPeacuOZs22CxJobuUujmV95iIVn
         gEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647321; x=1756252121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7/h4Lzi5fzI0qBE6eX0TONREqZIKaotMYznXSY25UL4=;
        b=KDTDXcYwRxcsn51KOccEnXbFfeVVg7x0xFfw4l707obnxgwQRbBgCtu+xl8KxO7BRr
         RAXriO/UHiI2ZxjP6J4ED8bGdqYghBq8isRYdVbC96GNZJJ7D1J13RzLqPRDLfIdOlo4
         72//fWsJ93Du/En98tCaM/EikTZoj/798bLNCqeCZkc/847WsnEdDio9FYA2IBjJBLVD
         lCCHY6XZlT/2gX/idceNQ9Bkr9tua3+Xujr7wxQDeNEf/83xcPEwBHWm+W+R2QWDPRjG
         hMBrxd30wR8AIc8OCwzb43cE759zftEvq3743ALIAQhzijh8bwaqkbHrEhyAp2QgcO5Z
         a7Qg==
X-Gm-Message-State: AOJu0Yz0qDszj9hjz6wkkKaRwADPq5F09HbqZ7TGE7B22cl3UAAVX02N
	4zOoSOSI244HmPe/sORd9e5OKi3s2J3i/WgZW4l4FJ8CAM+ZlK12oOV+dPQCZ2g2gGYj4VYPOaB
	RHCB47Q==
X-Google-Smtp-Source: AGHT+IGsqRabeQMqnGpLC270nNFX58626EJ3YMIELyl5iaczf7AIU8BO4Ll9FDhsNkRVMfrkARD0dI/rJ8Q=
X-Received: from pflr27.prod.google.com ([2002:aa7:989b:0:b0:748:fc2e:e489])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:8893:0:b0:748:a0b9:f873
 with SMTP id d2e1a72fcca58-76e8d7a3ba9mr1464991b3a.9.1755647321323; Tue, 19
 Aug 2025 16:48:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Aug 2025 16:48:26 -0700
In-Reply-To: <20250819234833.3080255-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819234833.3080255-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819234833.3080255-2-seanjc@google.com>
Subject: [PATCH v11 1/8] KVM: SEV: Drop GHCB_VERSION_DEFAULT and open code it
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Vaishali Thakkar <vaishali.thakkar@suse.com>, Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Nikunj A Dadhania <nikunj@amd.com>

Remove the GHCB_VERSION_DEFAULT macro and open code it with '2'. The macro
is used conditionally and is not a true default. KVM ABI does not
advertise/emumerates the default GHCB version. Any future change to this
macro would silently alter the ABI and potentially break existing
deployments that rely on the current behavior.

Additionally, move the GHCB version assignment earlier in the code flow and
update the comment to clarify that KVM_SEV_INIT2 defaults to version 2,
while KVM_SEV_INIT forces version 1.

No functional change intended.

Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..212f790eedd4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,7 +37,6 @@
 #include "trace.h"
 
 #define GHCB_VERSION_MAX	2ULL
-#define GHCB_VERSION_DEFAULT	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
 #define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
@@ -421,6 +420,14 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (data->ghcb_version > GHCB_VERSION_MAX || (!es_active && data->ghcb_version))
 		return -EINVAL;
 
+	/*
+	 * KVM supports the full range of mandatory features defined by version
+	 * 2 of the GHCB protocol, so default to that for SEV-ES guests created
+	 * via KVM_SEV_INIT2 (KVM_SEV_INIT forces version 1).
+	 */
+	if (es_active && !data->ghcb_version)
+		data->ghcb_version = 2;
+
 	if (unlikely(sev->active))
 		return -EINVAL;
 
@@ -429,14 +436,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->vmsa_features = data->vmsa_features;
 	sev->ghcb_version = data->ghcb_version;
 
-	/*
-	 * Currently KVM supports the full range of mandatory features defined
-	 * by version 2 of the GHCB protocol, so default to that for SEV-ES
-	 * guests created via KVM_SEV_INIT2.
-	 */
-	if (sev->es_active && !sev->ghcb_version)
-		sev->ghcb_version = GHCB_VERSION_DEFAULT;
-
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-- 
2.51.0.rc1.167.g924127e9c0-goog


