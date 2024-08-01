Return-Path: <kvm+bounces-22838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D879944251
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 06:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBCA41F22D61
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 04:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B0F143C79;
	Thu,  1 Aug 2024 04:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fdJ8GY+b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCBC143885
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488363; cv=none; b=mZZuOC3gpQPsRhNO2bafWN7miTwUFz94O/29chSLn6CpMhx/Z4LAaVrwe5mGCmxZtPE37pywT9XVxzM3AIjI2Gzn2Z7TjDMjVeV7ojFLMjExo3wJhM/ovnaJR5H5bh3YDNWISLglnbAHsEfZpdi/CGRT15T8uPvndySQTHKdgH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488363; c=relaxed/simple;
	bh=XpWZVpP+1fU8zyiBCBEZSEjntYhRTb04Ki1oElLfW4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MF8sXIS35E4d+mlTZR+5ZWt16zM2fv+Q/q+HQofLJMoIEk8P6Ux6n/362Qwgsh4YGR1gWo8JqaIg7cMUzH63EFTF2/n0e1yVlwA4kpHfgq2yTWLTkBPLLRMqi5YdUqLM6vDUlYzV2dnDWkiPOEFjdtepHjCIgGInOsDVT+kiGNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fdJ8GY+b; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1df50db2so1762990b3a.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488361; x=1723093161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6duVsFRfrk0IpAUCyLOr5AOz6KYb78N++19JHZQFaLc=;
        b=fdJ8GY+bhcQyRIG8y92u20GHycTeC+kKZsEZj9XZ8VjPMkcCxfjrDhTF+RLMqx4THP
         FowQGy0dl7bDp8eH1TxiK4m1wr+p+qJ86MDliMYpXnIe+lsotMe3bUB3E8GyTjGh3rUw
         cDq7Vn/IATRqfZ2DH+GEPUvfZesjPH4miqdRvz5g+df2B5mCQFWcuCtQg4R7kusJGBGG
         /WBO5iftWgoIiMUR/A7lSCzpUI5pEOnI5sqdpTTYUi2LFwSeYvDb8DVJ0TylLrZHBnw8
         A6s8hUn5Mql72TFM9Qwuh0vAT0aHd+No6+lgknUiRt0ppQ+4Iq+QZQDpSoVPEN/KKkk1
         aYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488361; x=1723093161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6duVsFRfrk0IpAUCyLOr5AOz6KYb78N++19JHZQFaLc=;
        b=Fp7XJAZboBMpW8F8M6c7n9Llq0zSu2y1saEO2/zhhLvfJr1v9NKODCxE0/l7v3dU+l
         1p+XGjW75kkfdxPnTWXKUprr+To974gmWshVqOX40dDAmYQPiadZSrPdi0NO0e1kprO9
         CIcMFEl03GDlFSDkU+cyGmDJeCQmd8iBSZiEnHbFFrX2FYvQ4Igsq1fY2f+xycker1vn
         KJDNORdAQd4MWti7KvPy73BPiovlLUCheMFvCHWBQIuz3tZVATo+x9LdQ8bseNTGBDp2
         9/dvl30J25UndTmedPmFW9qeTBj29pNlx5hP+rNUKfxq+KktrieTKC3IouYAcexTGT9i
         OE5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWS/LLOvW+CvVytNYTQmY1WnbROt+oar+JHrFAv+1eFHxalXvI5let1fuq6spf46kgKloajXVh10d/Fg7Gt+D/y2o9R
X-Gm-Message-State: AOJu0Ywgv2Kq3pnptJ9DzgKG5MNQJwvUSzM3ja2eAF1Zly0l3qml0ijw
	oCsNpbh/moTWVXVws2QyD39uRQwjAhAqixledHZTf/tk9saxE2zcioqEMFVn0d2l+w86/xMC257
	PRnh4wQ==
X-Google-Smtp-Source: AGHT+IE0xF0ZWDReclAZ16EiEfEORg6bp7W7nUuzCTTl84dqX0CiNk3QO/0bqT1nO6h5B7MExJodqJcFutLy
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:9465:b0:706:6a2f:36b0 with SMTP id
 d2e1a72fcca58-71065e4ef40mr758b3a.2.1722488360754; Wed, 31 Jul 2024 21:59:20
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:14 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-6-mizhang@google.com>
Subject: [RFC PATCH v3 05/58] x86/msr: Introduce MSR_CORE_PERF_GLOBAL_STATUS_SET
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Add additional PMU MSRs MSR_CORE_PERF_GLOBAL_STATUS_SET to allow
passthrough PMU operation on the read-only MSR IA32_PERF_GLOBAL_STATUS.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b9f8744b47e5..1d7104713926 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1113,6 +1113,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
 
 #define MSR_PERF_METRICS		0x00000329
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


