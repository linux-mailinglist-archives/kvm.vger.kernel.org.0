Return-Path: <kvm+bounces-22867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8BC944270
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B12EA1C21A72
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23A114D718;
	Thu,  1 Aug 2024 05:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j7V3IFFd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EB914D711
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488416; cv=none; b=fyFM4iXuHtxhryaNDuG20BuYa+9So9DfpJKEmXmDx2O9e3sKTOwq0+9J2WN2DMPdQxQKfEpDZ9slC2g7PlOdIIFEwFhQh12hUImCzwav6ESunr8u/nZt0gcH53nqgtkWrwYZJBqsfGALRI8pOorP5xUIMimiVkclsJGWreBu2kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488416; c=relaxed/simple;
	bh=Bk+0nvKop0JHRtbRPrVchmKBbVyM3rgvuVxfqjS5P8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F4sBy7klORJnQf9JSlGq679ptZdoDy483afmIj31yB+wi1jsXbLccRcdBRGCI7dI3yeeMve1tPvsJjzfuePOT6cGjN5h5SSC2p9OCkYNbOPm37VmImIeS2zNMzo8qUR1GOKh1XiUTV31JcOiV9O0Yyvl5ALbw4ItHUkKFVCw2GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j7V3IFFd; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0bb6fa79b5so3076564276.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488414; x=1723093214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ofi3REk1BGr1x1WS6xJKcE1TSnEgsigC0M33dE9Lcio=;
        b=j7V3IFFdgM51eIUiEQpAA8hGjjuTD6kA72vZCTzO+rLENeMQpj2w/AzVBjufIc+VAA
         wzcNOfGscqL23M+UFUrtQac3/AlbOPmWhuCdgZWkWvQe5TyXPWQ8dwnnhBU1DDxiLmif
         oS9HY7whWHmx17eKnjE9v+sWpFnlqk78sjw7RPzhIY8hzkNgD3oTg8PFCM53H6kvAqoz
         aJGASCeFXgP8QS7/OJCZqiqzygOozwMSWaa+Wq++eYfcj82rztc3D8quAg8+CpGaQas6
         FWqgMGFrMKRuqjrrXQoaDOtDk16ZgNLeYgVB0pZn+VYS5ZeF6KE85vNXsE0FLYTqCSJW
         P46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488414; x=1723093214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ofi3REk1BGr1x1WS6xJKcE1TSnEgsigC0M33dE9Lcio=;
        b=YzESnDOAi5ayRMfpIv56vEUczo+pUhaWq//7cpOA4K1x6ZV5Q7+FLNRfqU7OpVAY+D
         ABN+YuzehDRpqVdXX1c2ZDjWKkGmZ8csOXdvRV4FBmvAAVaMuRMgz0anmRtEUm4vX/Ry
         yuF1iX6XJJAChIpWvOWsk0FYYdECLHsB5j7j9dx9+Esil6X/LTsTDHBG0PW1Qnix6BvX
         hPWijMX63aU4sbQyH79/4vAS9EEvkzY8PH+1ZRSAbcRwPLCfDFhRKgWQEBldW+36gBFY
         RPTlfW8Bb+/7D9ZnbBLkAvKdWVwvVljfE4wvuAnDbP8IJXKINvqrE9WyL1gX8VgIEFbd
         UHgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWygY+4cb5MVIhSvZ0q19OAiu6oxSWKGFBsJoFLUo2hQcL2VcAlB8GPL5GvxdD488AA8R/dHLSGl2yVoXv3SSGRp0SZ
X-Gm-Message-State: AOJu0Ywj2BmU/HCOvdHdubdI9qwdoOXHTyDGeqHiutNSnAWsDv2NnOe2
	BNrQ8fcM8Qq/kzhJj7RVxLJlTro5VnoAcRg7Ra0ZmV8qnhbbML44/Mp80uMQkAAA8czGoRnRAfe
	bF4t7GA==
X-Google-Smtp-Source: AGHT+IHatkdmPJu4KhGRiDjpGk6tcK6tPjwWCykTdQmn9N24iyfBIP7+GxGFvF7Jp7lm3F8hV0gNzxADhkbU
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:e10:b0:e08:6c33:7334 with SMTP id
 3f1490d57ef6-e0bcd377446mr3384276.8.1722488413693; Wed, 31 Jul 2024 22:00:13
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:43 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-35-mizhang@google.com>
Subject: [RFC PATCH v3 34/58] KVM: x86/pmu: Make check_pmu_event_filter() an
 exported function
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Make check_pmu_event_filter() exported to usable by vendor modules like
kvm_intel. This is because passthrough PMU intercept the guest writes to
event selectors and directly do the event filter checking inside the vendor
specific set_msr() instead of deferring to the KVM_REQ_PMU handler.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/kvm/pmu.c | 3 ++-
 arch/x86/kvm/pmu.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9bb733384069..9aa08472b7df 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -443,7 +443,7 @@ static bool is_fixed_event_allowed(struct kvm_x86_pmu_event_filter *filter,
 	return true;
 }
 
-static bool check_pmu_event_filter(struct kvm_pmc *pmc)
+bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
 	struct kvm_x86_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
@@ -457,6 +457,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 
 	return is_fixed_event_allowed(filter, pmc->idx);
 }
+EXPORT_SYMBOL_GPL(check_pmu_event_filter);
 
 static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 8bd4b79e363f..9cde62f3988e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -298,6 +298,7 @@ bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu);
 void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
 void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu);
 void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu);
+bool check_pmu_event_filter(struct kvm_pmc *pmc);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


