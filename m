Return-Path: <kvm+bounces-22854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3AE944262
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D45541F22D10
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6185814AD3B;
	Thu,  1 Aug 2024 04:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PK0BQ5DH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608D014388E
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488391; cv=none; b=H4DIvpKH535nDtBuiRj7EQhnkpAy74JjrlDj1aZ9raZ0YIAHx8swzF+uBa6u0atx4j1occIjZb65i2NkgwoSMN0/B1HOG0Smac4j59X/SzH+NzRcVZXbQ8ZC1xr9eqKalT5qhFnLwcTrzjlcURJwxEDAZPMI5CXD30IBb6pYmm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488391; c=relaxed/simple;
	bh=BaHu02UFGqjoVlKM/KF0W8Z1EcBs0bxy9IzWhYDzC2A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hvo7243j387XfeL7wkNJjFArtQmTTSxd7q2X5TofUUeDHilt+EC/rKlk+CU4t+qhnvrz0UrcPiMBcujRUacuzUBEXzZ/snKTm6YQ+0SyXzrdK3tscKs66Xs/FFoduooYOkJjyQohaxhxWyJA3vwzGM1NjS9Ema2GCvT6ELhl81k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PK0BQ5DH; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ad78c1a019so4320608a12.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488390; x=1723093190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RUvQCQx/WMIpOOFe9mcTTW5PZCf+TCUSSqHzyb7UegQ=;
        b=PK0BQ5DH9hon1toAm7uuoTbuasYKVwaq1eEvGzpK7piVVqv6R60PqoPZQlP7xrqubf
         2kHO8Qe9aPc2Xs4tXeb9F0XdkvEsUdYobIbUF5xdS8sdHazjpLGfx+JT5FwsBFpyl3zG
         YpHF/kM2dLIOulCH38KzG4o3FkrE9BM1CcV6HZfa+EFm5NPqIPc9LTZAtbt4ZOgv6yAD
         9YpTYwwQ6FbZZdy4SxM1c06jmcqV0AyQ+pitkE663x2esSlfRit8uy7K4HNqyHhxMIMH
         YZFr4m40pngUZwHlhPbCU8KJnCpWC2eUw4TRp12XlJLtryoWVGa2wb074Yr7Mhgd7eUf
         Mozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488390; x=1723093190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RUvQCQx/WMIpOOFe9mcTTW5PZCf+TCUSSqHzyb7UegQ=;
        b=pmJtW5JljDRYuo+s5wqod/CD+/7Qs936gWK8bmrbxbrowDl/M3V34m/Npa3AJUyFny
         aOLfW5ZDbQYDDRn0b4h7ULayWvtW0rIJnvJxAjlxkzKDsgm92VKjao9LI/5bT6f3K0T3
         RVMk65Hk6NstcnAJwXuQC503InvMFO0OCdDbaAFEDj5ES4XirYOKWDVU2dOFjK+IigZq
         mQ8XRE2DsUYs+Ekxa2Eg67mFRmU1dvG0Lq0WgJ2yA4SIJYbr2PKJGyahG2kC0wsBf/Wm
         X4xvrwtZsWq6iw7nv57Fi7EBn0BqVux4IrdjFXOIo9O78rIp+2hEdy1agRDTTvyKtLCK
         do8A==
X-Forwarded-Encrypted: i=1; AJvYcCXMuHogrx4HWox3IjlIpS7d1sV6OvnkLNe6FY4WyytqZC/MzXccQi2/ZLm0wQxJk5FotmX5eQu1GTskh5eipT6CKnkc
X-Gm-Message-State: AOJu0Yx+5epPVwh+k/iD9oNGhGoH2YdRKsJlBr11AXmjfKwBZfBwjje8
	OnMiNZb0d03xUR7mf85vFUk4pIXKjXOE8imJg3ZEWvkMrKTfGwg09b3fvtSWymW3JH0Wcf2MNg6
	WIAQINg==
X-Google-Smtp-Source: AGHT+IHjXcgdfDuOm2S1Gi0CNX+VfGrMUYUIMcwlsSzve61nT6t1siC1nF2RVWD4E2UIzf/j4bY/WUAd3RI8
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a65:6813:0:b0:76c:26a8:e0dc with SMTP id
 41be03b00d2f7-7b634c51fcbmr2594a12.5.1722488389288; Wed, 31 Jul 2024 21:59:49
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:30 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-22-mizhang@google.com>
Subject: [RFC PATCH v3 21/58] KVM: x86/pmu: Add a helper to check if
 passthrough PMU is enabled
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

Add a helper to check if passthrough PMU is enabled for convenience as it
is vendor neutral.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/kvm/pmu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cf93be5e7359..56ba0772568c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -48,6 +48,11 @@ struct kvm_pmu_ops {
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
 
+static inline bool is_passthrough_pmu_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu_to_pmu(vcpu)->passthrough;
+}
+
 static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 {
 	/*
-- 
2.46.0.rc1.232.g9752f9e123-goog


