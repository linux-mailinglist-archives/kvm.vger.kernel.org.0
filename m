Return-Path: <kvm+bounces-32308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED589D532B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 058D4281AD1
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C8E1E411C;
	Thu, 21 Nov 2024 18:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pqMKSLaW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793BA1E376C
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215236; cv=none; b=QIWWCIxsvT44WjjF4l02LOA2zxhXITHOPIEh1bAdCphJSCQFY7WOdH9+9yjMKVKLtd2k7Bz4fGZIwqkyq40C3rJJZ0mKEWgfQWqe+ZcJ9omVSBV/2k8cGwmigkiDQ/dziSlhsFWnUAlrsvvNH8Ww+w8C406+Qpj2d19w6sMiRVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215236; c=relaxed/simple;
	bh=80AJRXxgHUR06s0FkZz93urmoI/O6TPv0yGQJeLF4Ws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fuJMFNxF6n9aa3Bbwrw1jmJJD8Ws8Fv5aC7zjVNVVFBxSRrRN+k5bg+t0yGqowYnWjac4EIdcfqDaqy9QQCjUKrsCoDkIH93excQlnm4p/eHvWWgH5uncPbLfACzpxSviJZugP9NtCMLb4MxBIcGPjen9DakKTUuPiNhrMa0jjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pqMKSLaW; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e648910e9so1638145b3a.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215234; x=1732820034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u7lzN3ovy8rt3qRKTNWPH3t6jAPHyPUfK7VhgkoNSLI=;
        b=pqMKSLaWv0Tsh7Nk1K4KFSSgLnBMVq5RMs38Tx+Wdr3KCVykc0Pfj1PCwvTAP7dtR/
         SZnPufL+Oa1SjX3IhI6iqJp2KQry44tsmllHW3AzhOfXkrGgSuAtvbmK/eXqlxBpU+7+
         PDHjDPfAAMvMyVWJMR2cxcfD5n/0tSOHpeod6O/kRWIdBIVpjl06Ij/XOuX5fojrcUu0
         r8dSZqFWO7mmQ1o+FMWdh7fVJ4XRJMwWV4WA3MD6wCwCyi1rMmqhFy+/CSUJFqW3PueQ
         LJCDPH5wksS80BBCWO1/KhSKmfLS6/WFGwWv9YDXjfso26mI8EqTX6/sYzhNMLrMkYbW
         UG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215234; x=1732820034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u7lzN3ovy8rt3qRKTNWPH3t6jAPHyPUfK7VhgkoNSLI=;
        b=JysCyshcDpDFkQwJY2JoCRd8E+nwy4JCSfe166zQPmb6fhohEPW3gwAJ6V1m5ybSOz
         +NPwA8OFo8ltQjKGJNxcRO6uZ7/7vy4erO/rQmvAu681nSia1MWr60mN9VqYhugOFDLW
         K3ZjyzQpgdUyOZuFOR00J62VrBktPeZA16C4XOjk/xBMExBcGOn7DscInfXFVH5Zx98X
         jEIQZmMQMk81sxB9I/hls9poYsMzpeNYJGwdYf+K8l7AeC4OcN6QYnx+ibBhfDJGjvhx
         G7oWqMEEV0ur+E1w3tAqsQ97bUzZtylDcA5cC0ZUWyUF+069hf7h5iIDngEDgdqX2FPw
         PgoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYse768sw+Xtlf0sMt3Ib4RFFJ01Jt7UNhCaepUe5j6xLW4VM4M2UyZ0XniLTXAuce2QQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBOeW7SAZJi4V6zmsRfkKVseI6q7hp3VIpmE3AwlTnJXgiN1ny
	LKnQtqQSz0TXFTLLNQtibiuVcmfW8RjtrUd3mQpP8XlLxzoa1yP/ehlFMa7Gd/3Z1Pvon1y4jdM
	/2v+V6Q==
X-Google-Smtp-Source: AGHT+IE0CLSo7knZFzWKfqBspTMKtJgzSjy6POJ7md/JMhCXlD1vM+E4fOblN3WVaGm9ltr3SlK9z7I68mrO
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a62:e811:0:b0:724:daf0:e060 with SMTP id
 d2e1a72fcca58-724df3c0f18mr43b3a.1.1732215233908; Thu, 21 Nov 2024 10:53:53
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:13 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-22-mizhang@google.com>
Subject: [RFC PATCH 21/22] KVM: SVM: Pass through guest reads of IA32_[AM]PERF
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow direct guest rdmsr access to IA32_APERF and IA32_MPERF while
continuing to intercept guest wrmsr. Direct read access reduces overhead
for guests that poll these MSRs frequently (e.g. every scheduler tick),
while write interception remains necessary to maintain proper host
offset tracking.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++++
 arch/x86/kvm/svm/svm.h | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81a..332947e0e9670 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -142,6 +142,8 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_IA32_APERF,			.always = false },
+	{ .index = MSR_IA32_MPERF,			.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -1231,6 +1233,11 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_APERF,
+			     guest_can_use(vcpu, X86_FEATURE_APERFMPERF), 0);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_MPERF,
+			     guest_can_use(vcpu, X86_FEATURE_APERFMPERF), 0);
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb191..5ae5a13b9771a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	50
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.47.0.371.ga323438b13-goog


