Return-Path: <kvm+bounces-3189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F35801879
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E927F281385
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7853D82;
	Sat,  2 Dec 2023 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L1h7Y1D7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AC41725
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:33 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d3aa625542so17208727b3.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475472; x=1702080272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MdN/fXe06mNI/rx7xpLhmxtX8yoQrkzTbIXLwt/4RE8=;
        b=L1h7Y1D7+jirALHlwpBx/C8UuKNR0EiPyYpBUkcuZBOENFFXt7jwGMTnZH0naccBf6
         p1g48ya97PKgoKcF2L4G70TDMx1beW5yKGPYIUwtBnmPKs4bbJE0lXAMKderZ4bVfCk+
         05IcD9lBhSiS2zmS2zHvYlCe/pO093Wry9/qCAZ85WFMNxP+Q+H7A9CkKkWZ1gMJVWnx
         HCGij+VmFvd3fldpdHHLXZG1H2t8m1PkcgAi95ADHmHOmdn1pEtR6yWycowWDWHeqDG8
         WdBbGvKcJZzmyqYZl/62m1x0ybsioTKPTPIypga6Lh1BN/sqBVoC10cNMeWRrwwwHZxh
         tYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475472; x=1702080272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MdN/fXe06mNI/rx7xpLhmxtX8yoQrkzTbIXLwt/4RE8=;
        b=PEl11l870K32qgNBlGkcXHxfFNpRITeuTA5gWKpFR0gi8C3h+ITTe+gyytZj7fhFbe
         g+IRw8Z0fcOotKle81mqUDTnmyC7/3lkj4A/lLd9K3IRl5HwzvKH6SUdsnvVenl2we/x
         XaGQb89YVe1ZPCKprOMdg5AjoWA0dXlVnswEJ1+Zv6dGGw+fIo3ExGEg/2NFNwSa58Jy
         SzUSnZ5l10FEkE9Gqm5LuaWh7fvlrodudB+EkCsU8cnDqRYP75ovmwJRhVvI9Gi3tRmN
         5ro5K7lV/YGZLZD63tta7gOD4cUnMf+Nug8Dr65FwckP1p6LFSD29kVikHb59acgYdmm
         HUcw==
X-Gm-Message-State: AOJu0Yx6dnub0gONWn5b0hcC+xQ79mWAyeZ/FFV7W+fyVDF21Y1Kt6NU
	aDmlPrguSlAbMAtzISI57GFLmVCOCgQ=
X-Google-Smtp-Source: AGHT+IERz1rUps5EiMVy9w+tyG59EohoCR5CKWnINcLL7YhhxwxMailU70Dpdxt/Xg3oveOJFM69kOls0DI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3692:b0:5d1:6732:25a0 with SMTP id
 fu18-20020a05690c369200b005d1673225a0mr674144ywb.4.1701475472351; Fri, 01 Dec
 2023 16:04:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:03:55 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-7-seanjc@google.com>
Subject: [PATCH v9 06/28] KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC
 index on AMD
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Stop stripping bits 31:30 prior to validating/consuming the RDPMC index on
AMD.  Per the APM's documentation of RDPMC, *values* greater than 27 are
reserved.  The behavior of upper bits being flags is firmly Intel-only.

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/pmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 1475d47c821c..1fafc46f61c9 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -77,8 +77,6 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	idx &= ~(3u << 30);
-
 	return idx < pmu->nr_arch_gp_counters;
 }
 
@@ -86,7 +84,7 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	unsigned int idx, u64 *mask)
 {
-	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
+	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx);
 }
 
 static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.43.0.rc2.451.g8631bc7472-goog


