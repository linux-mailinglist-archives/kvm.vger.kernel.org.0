Return-Path: <kvm+bounces-22884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1AF944281
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F44E1F21035
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE7A152DEB;
	Thu,  1 Aug 2024 05:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tpmkeodu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAABC152783
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488448; cv=none; b=b+YO9Af/qVaK5pnyuHy6EhwUp76oGCWj+V5TcfgJm33Yuiegy3Ce1IqjaX3k1M00ou6KCHYugxmREfccDhWZWORTfr538F/UvM9wz8IuFpHmc5hLbWFMPZvPuZJcpi/UNIYrahr4PIOqcwXpCb2W5tyu68+KTuKA/qMzuQZi/EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488448; c=relaxed/simple;
	bh=qqJCUZdQ2OMvCBwxsyPO9mS+RTuW+7jJ1oS93OxTWpU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ok4Bc5DgkWrBFXxYpsO6fQTdTxIFOHNK+55zecgMvgIJ+BhgCL6cBw+YlP84yQJx8m6uEyTQIVaFzafGG8ChUCzIr0TH8EJ0HpyO3x+SS/nczFzFvswh+IwgppRhmhD1Stnc2GEQDZQyXgsD3zdD0y0B0d9E3iWZS2HblZihGX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tpmkeodu; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d34fa1726so6898155b3a.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488446; x=1723093246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1ftBoMx0u0YKTugTE5W425aVzmDhuqmdSWnt6KFLZIM=;
        b=tpmkeoduhQGCmwNbtvDQfV+Q8PXvF2sFSpMvU4hWgRGloCgV9TrirdpphrKckY923u
         VepU4GzeW1VURN3Yb5YA272Xpzxb7/WONL8b/7rNQSLCldcDlndhlx3lVeYUzm19bX8X
         zLih7om6zUklgiRUl9RkFCZHSQ9f3s6JMlriY3SpZL1AiJU782MZmdx5M/z7bLvaz3AF
         h8KaYYBGLEMurwbq9zEd/+H9eDP52SeylgVMI2uylA4PFT71YH3n2yuwrXPguOUtkjaT
         m8eSwFsMjd+jMQp+0jmsANrtyDLDrKVQv4tRHWlJ3PlBY2zehaOyOxgiSOgP3XNEnFTf
         OCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488446; x=1723093246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ftBoMx0u0YKTugTE5W425aVzmDhuqmdSWnt6KFLZIM=;
        b=uMHOOGoY28QanQUjOL8il3Y05BLMWI7t8OgVQEAQaFAizs+sH3dOH/dL20x/hJxEx1
         cUU6D9IvO7//sRI8mUAYXjehTUA4ovYUx9c9iKQkABhod9DsIYPh6mVGY+3pIW5BGWJl
         WoboV8p6nfV+tY6rnKvkF+g1SShkktNcYyAcRYGX/Ux+VYe6r5vg582RpKigxYYlNHS1
         w/M+jgHrmTWQDR8cxzP5lBS23Wb89B6Zws0GQ4GonaGvBphqsxuzkMW6aJQkbLsyi13k
         /JHQCDorx0fVHW6uGjwslujxxrgrgBpqL+wskOnqydUC2toPnxH9FPwL+Vvuv6mQEarz
         VkoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtg7PTWqzt5TGEqlintprM/UTn2Pru/8d5Q8dZOtmWykRyAG2sHsCnMXut+Bkuh9F6hh16yR238Dmk2MYKUAMih5Oc
X-Gm-Message-State: AOJu0Yy2C9fY6NdUnEDpnTx85QbKHY4WAMIKPGjwgn4BzHWPx9VwhBmO
	43eyi8zL7apKiVW5/UQH+1b0/9IIxFVp8z1F3R2d6IGjFkMrrdXtwPwxDu+u4lveRDxVsXM0yr7
	ZCFF4gQ==
X-Google-Smtp-Source: AGHT+IHbs8qaJDfvFGAXP/rpBAwEhmqT0IS9EaOILk19416ojQXGwDiYFKRgx0TkGPVP948qxfLhKBzuwVNb
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:9444:b0:70d:2a24:245d with SMTP id
 d2e1a72fcca58-7105d7d6f05mr6682b3a.3.1722488446062; Wed, 31 Jul 2024 22:00:46
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:59:00 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-52-mizhang@google.com>
Subject: [RFC PATCH v3 51/58] KVM: x86/pmu/svm: Allow RDPMC pass through when
 all counters exposed to guest
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

If passthrough PMU is enabled and all counters exposed to guest, clear the
RDPMC interception bit in the VMCB Control Area (byte offset 0xc bit 15) to
let RDPMC instructions proceed without VM-Exits. This improves the guest
PMU performance in passthrough mode. If either condition is not satisfied,
then intercept RDPMC and prevent guest accessing unexposed counters.

Note that On AMD platforms, passing through RDPMC will only allow guests to
read the general-purpose counters. Details about the RDPMC interception bit
can be found in Appendix B the "Layout of VMCB" from the AMD64 Architecture
Programmer's Manual Volume 2.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12868b7e6f51..fc78f34832ca 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1229,6 +1229,11 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		/* No need to intercept these MSRs */
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+
+		if (kvm_pmu_check_rdpmc_passthrough(vcpu))
+			svm_clr_intercept(svm, INTERCEPT_RDPMC);
+		else
+			svm_set_intercept(svm, INTERCEPT_RDPMC);
 	}
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


