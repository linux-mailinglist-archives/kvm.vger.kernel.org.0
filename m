Return-Path: <kvm+bounces-19441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F022190519F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 13:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 769691F2326C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F3B16F271;
	Wed, 12 Jun 2024 11:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zZO2NDaR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F328216F0E4
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 11:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718193101; cv=none; b=RGQWU2JHz7l5FxUdIdmeDIoyENrBdh8rTrfTrQfJLtgQmGHLm5I1Gsve4ILw9ex56m2RDwjCD38qe2tqUMhu+EmRtdEAt4jmFGFePo+d9tSpvsnfZnwhGwedUQuSScKN0iRxUSn/BBb9YyFiyeb2Ci+49e88dUdX7N5qEJ1w9NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718193101; c=relaxed/simple;
	bh=Cqxmc4vU6fJ1ptk84gOC8RIBnHsYAaGlG8/IcCyV160=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/8OMSU2MB7dDxNdDRTznLqZYA7aCJCOV8bC2tBhkJKC7wsv7EarNbmMRGeWUubO4N7K/DWf1JXan7sk0EmwbWMOqF1vDePaihvH+kKOWRvSOTSIpOpoq9TM2+HR/H4O0vt4yDaRqfX/8XRXgTBlXiCUj1OeyDQ6xruTeMBnHCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zZO2NDaR; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a6f0e153eddso498909966b.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 04:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718193098; x=1718797898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Md7Cta9c0UVJz/TGAYvqfK5C0UOgh9je44EY4i9/Lj8=;
        b=zZO2NDaRcaBHuQMozur+7Fm4cUyD18mS5kCo18VyegIi2+zicPXQ/TDCndb3n1NWYY
         TscsRuoWZabPoa4oM8TCUwNGE2ll2XNKpnp+0iamj/72zxs+y9INU1bSPbPTfGUdG+GO
         VihXA6Xs6tsyJga382tBdUp7EIN5H0rN01a4W1QstWSPEg3T8zbSdTPYHAx9lPccwTZl
         4sMpUDp1WKseREnNioka0NBTfvSMW2M67v3d+7MXIgbDs5JPw4ow3jgLig9wpYnK2ARH
         tBo7uOcoupWhzs3Z1ywIydueDCQGi+jw2uqR+5MDIpoo9VVSWR3IlZ3XnUdf86nuXaaH
         JpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718193098; x=1718797898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Md7Cta9c0UVJz/TGAYvqfK5C0UOgh9je44EY4i9/Lj8=;
        b=RG+X7M6ak1iyfNjd22P+MsNoInExAJLlaDMgElPBzHi9bWYB8HnE9h1pFIpMmSULAy
         5HATXG9n94nBfGqjZre0yLHCampnoY0PJWinajEaQEeqOZqp4+iGtaXZLHiKziAa8Apg
         Cluy8M4wVyLnmBUHN5Js2HjZOz7OiiYmeFKK1tEBnLNF4+fSo+JF5moNGx1zpNzIYCb8
         Qmo9jlxguzqYHHYXKplgJMte/jxcKbae7LKfv6V99Oid6fAdXHz+SmQJnXsqoaYndIDD
         y+Vu34jERJYgFvkq5xPt3k2Ro+IMwhwWwEN/LeJB3Z8wvJvmlFg23ZW7bXawik3GuvJB
         a/8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcF06IjPjrdRQKpcF9kKNte9+OfbPUrzisoB4+7/2Qom8DkJSzD6rxcWEibWw4K/gnyEZVvyu61ompjBnOEq0wR4re
X-Gm-Message-State: AOJu0YwiyEqifmAedia5Qtp5+xj9g8Q8wj6v1Z4X5vXg0ZXeKRakM4Rb
	uyMX2WkFA6vae3icG7IUp/ZMjiMFiRD9O6V6xlTwfPxS0SxgQTo69m3FvDK7oOk=
X-Google-Smtp-Source: AGHT+IHWofN4XRRk27pqtnbrMr8jm0y9pVLTuG5m4eo7uZs4c3yYHlfkS480GWAJdWtb1ZyWojDx9A==
X-Received: by 2002:a17:906:3bcb:b0:a6f:2ee7:b21a with SMTP id a640c23a62f3a-a6f48026d98mr104094766b.65.1718193098085;
        Wed, 12 Jun 2024 04:51:38 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f29d305b2sm5944700f8f.8.2024.06.12.04.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 04:51:37 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@linaro.org>
To: error27@gmail.com,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: SVM: Fix uninitialized variable bug
Date: Wed, 12 Jun 2024 14:50:38 +0300
Message-ID: <20240612115040.2423290-3-dan.carpenter@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240612115040.2423290-2-dan.carpenter@linaro.org>
References: <20240612115040.2423290-2-dan.carpenter@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If snp_lookup_rmpentry() fails then "assigned" is printed in the error
message but it was never initialized.  Initialize it to false.

Fixes: dee5a47cc7a4 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
The compiler is generally already zeroing stack variables so this doesn't cost
anything.

 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 43a450fb01fd..70d8d213d401 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2199,7 +2199,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 
 	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
 		struct sev_data_snp_launch_update fw_args = {0};
-		bool assigned;
+		bool assigned = false;
 		int level;
 
 		if (!kvm_mem_is_private(kvm, gfn)) {
-- 
2.43.0


