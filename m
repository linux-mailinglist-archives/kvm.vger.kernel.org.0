Return-Path: <kvm+bounces-22882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A07094427F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:05:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44B15288D79
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC46152533;
	Thu,  1 Aug 2024 05:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EqNU98Ef"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF4152184
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488445; cv=none; b=HC1t6E74oQYCwaYQFrSUBsEJ97rfFHPtLQnQK9gVWyX6JfUXH3q+zt3wleQTSdoaVsQ8J8LjXXPWG3CX1do9xMx9duhjBKKDGL/yTg5WWYU9fuUiiHyIj18UlB23q6+qU/amEKcRmPEfIJOHn1soIPHXBZkZtcJVV5YxkcVu+2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488445; c=relaxed/simple;
	bh=khra115MfhwYq97yn8cJINr8xVP0oElGg1CFJMbnxbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=THJcpTWEjUyf9vJ4Ni/GqhZq94E5yGf9XA9wBW+d4YvJ3VJs283zgEJUyO4N8LaK27kyD9jF+2yuN0aKJiuNBPI3D4I6QtjZRDT0mLQzSZHJFcbAJIzsjFBnAkQ7jUPPCs9BshlLeL0EcJObS+3IoJU58pZybWJY6U73cJrnb3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EqNU98Ef; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-79d95667cfaso6712638a12.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488442; x=1723093242; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bMGNya1kRgnB01fzG2jSRfrVgJKNJ2jxqEMN5YgYGYs=;
        b=EqNU98Ef8l7SriLAZ0TmV7X0pKJ9EIC32pIZmehOL+SGj+9LuMmhrvQuA5FSNL7RoY
         9vnvQ8xSCZEUXimyoQSOOfqKiC9vbrBe47Aje6x18J3t8lmnbgEEoGnk4ZE05U6YBRzx
         Dn2rQAGioX6ZgQSCjsDqBQbLswArFDg14qonLSV0j3sMv7reU7SBAiIVL8W3xPeXoASW
         wBuIxseBgdDBQm1h9VHOuNRjrUc06y2XY9WDvXh3+CPnXgrifo8Jbl+jazu46TDFY6+R
         aHFodKZ4j1fYBsJ+Nn0K5R3o8uxSV06PY7ZEp/VGc8OBuQ7CjU66EQm2biizpVEFnI3d
         tvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488442; x=1723093242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMGNya1kRgnB01fzG2jSRfrVgJKNJ2jxqEMN5YgYGYs=;
        b=tGYyXdHF3WmnVTDVa2AoNj5z2/UwlwM6zv6tOSnn+3XXO1pOidER/+n+dxzLFxshMz
         mOUTXHMsXJl0hgCqZLM/yKyL5ljfrOWctgpGUmdUReaYaWGNDKVyb6E+MyCW2anrFRXc
         GjfTVRNdptxA6gzoO8SaUfRZqRXbJhQW0b3FD0Pr79z1C4YIpbr8irKCE7J6PeiiS+RV
         EbwUWn5E9mWtjDb9S4fVJdRRCG4k3kJKmsA7s7LWf08Tnu9qn1R+EDMtgxFDFfPgM0jp
         q4VBDCm3FaT4Bvs7GNy0C8unzbkiGeHfCXAiHeAIhHDicDj/h6yGevu0V2fUz5vnOGwB
         aB6A==
X-Forwarded-Encrypted: i=1; AJvYcCXNnhwSdmG30/K+uFNhPMvX6p5/+sWNczmxqZwdr41YMopjT5kFZES1ndR+0RDfSS0BNdVE9mPJHASHFWQA+NL8CjmP
X-Gm-Message-State: AOJu0YzvbT06FCSGSfXalW+yj7xq3iq5QV8g67wu8A4CZwXi11N61PE6
	cg5RC0537Gj17oDtYxsXSBapyBTsJvI3Q+610JXv1SlttQ0M3xMiPlxTifx+6Rtb3XhBG6rQhGf
	RD2Cl4Q==
X-Google-Smtp-Source: AGHT+IGfx7mO/NY4BArw2bym2Mie6tKCDGVNHh0oFe5aCqJBAueW7+HcjI5X9KNZUDZ4yiP5Y8S8ibw5gF+y
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:aa7:85cb:0:b0:70d:16a4:c34e with SMTP id
 d2e1a72fcca58-7105d807b66mr5878b3a.4.1722488442283; Wed, 31 Jul 2024 22:00:42
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:58 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-50-mizhang@google.com>
Subject: [RFC PATCH v3 49/58] KVM: x86/pmu/svm: Set passthrough capability for vcpus
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

From: Sandipan Das <sandipan.das@amd.com>

Pass on the passthrough PMU setting from kvm->arch into kvm_pmu for each
vcpu. As long as the host supports PerfMonV2, the guest PMU version does
not matter.

Note that guest vCPUs without a local APIC do not allocate an instance of
struct kvm_lapic because of which reading the guest LVTPC before switching
over to the PMI vector results in a NULL pointer dereference. Such vCPUs
also cannot receive PMIs. Hence, disable passthrough mode in such cases.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/pmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 64060cbd8210..0a16f0eb2511 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -211,6 +211,8 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+	pmu->passthrough = vcpu->kvm->arch.enable_passthrough_pmu &&
+			   lapic_in_kernel(vcpu);
 
 	if (pmu->version > 1 || guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
-- 
2.46.0.rc1.232.g9752f9e123-goog


