Return-Path: <kvm+bounces-70530-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kL4LFDaUhmnuOwQAu9opvQ
	(envelope-from <kvm+bounces-70530-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:24:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6401104785
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 38787301324A
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 01:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA3B289340;
	Sat,  7 Feb 2026 01:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+Ea/bvt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA235287263
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 01:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770427437; cv=none; b=XiDfACGgh3n6X6LFOyHoVMTq5NjdW4iNS4QOzTarx2WWG8DnxKjwnMVP9UsqXyEKlHyhALS2FoteEraI99q15JAeSNbh373Zcka9qbzt2xC4DDfwxUG41OXFigIP/5idcPJbm4z5ueFilrW77bpX5rCtLJzYWtcLv7tCbNtCD/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770427437; c=relaxed/simple;
	bh=I+RxoIGb1w+j2Z99Cy0rUjANHksL4tl1ovFMTp7mg1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K6iS7MOXmSV/vRcA+TCuh8mV84J9QpWCrBGavim7nHws2o3GnKCLauAjotszQW/GtOOMcrgUfQRINyLYBrgRQGykwOgWFI6wb7rs7qzWf2JBBaRdqycmjBS0DXKT9XwxuVVqBEd2d7Rp9lbGbAOEHVLxx/SwLePgo744B6C51R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v+Ea/bvt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c38781efcso2498998a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 17:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770427436; x=1771032236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dU5KMBJtS4wTduPehGSWJG7pWtZ+gBpfTPOt7bZn03I=;
        b=v+Ea/bvt3/x60lb1ffT5HH8hd7QIAVlYryxw8vP6rCYm/Q105iTczl5BFw5ZvnUgdh
         M5iiCb0oLA2sz+bEKCxL0Wf8LrTkH4JQWvZVwtCSxtJehcksSZxOTZx6BQMu9XM00vSy
         Tov+g+EXN/i5GPn8WNmd8UygWqvZoFWTQUegriL2enDzdHU9JvpQbaSg1pV5viOdvhJF
         JFe7upyZ4bcrc0yWBjuN9dOBRCpA0xv38X9AhyPSBz5j6C+LfFAjulH3/VlQJpazje11
         atc04gqaj2AtLEnjx/2W5D5QSiKkCn6T1sgHk9Edb1OLsNBBqZ1Z1lXsd4UyU/yqXkxU
         lmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770427436; x=1771032236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dU5KMBJtS4wTduPehGSWJG7pWtZ+gBpfTPOt7bZn03I=;
        b=jlo1DwGXCbdm1Wr7bVrwqVYPv/p263oyq9LF4i1aMmb/35BTaNUG1ik1xRMYneT9oL
         uSXhwUQ0quBr9e2DLTPEPiNnIfNwotiMzxSGOoeg9mVCQrjIBg7LyD82AqMhEdvNB4Em
         wErswxTLQYFLYJSaB6WmiuQMMiEhmr8jZj/rwtd9xuTVg9nCTXDDLb8k2Diw3Ti3Zlvz
         V0m55OOYt8zHtRnkkO5LmTzYcM1WDNqz4T18Hrh8olzB9qApHsv6XC3mCO1FpTqhl381
         MMLP7ACQclwYVwU5Fy2KXEwpn4IDl4IEbLpLrxeb+wlG9Q19jmmXuQWz4SCfJYxqCjnl
         loJw==
X-Forwarded-Encrypted: i=1; AJvYcCWIdSuR+SqMuZrnWvEH+nqpXrc/VkGMyqNXNLHIGAi9Defo7VvGQku8v7Xt389V/wBpnFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPy40n8UGWJAVlQ5Xg75WrJbTdRjAWUfYuUnD4e69Dgg4XCUN+
	wM1aQr3sjDugT4r1NIx7N2RonzdCVoULVPWUgOVGkgC98OU6yiL+u0PjsnhDHSdSgPfu+kpw7bh
	xqIzPSm+hqo7GxQ==
X-Received: from pgbbd9.prod.google.com ([2002:a65:6e09:0:b0:bac:6acd:8182])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d10:b0:390:ca32:da20 with SMTP id adf61e73a8af0-393aeea94fbmr4223884637.10.1770427436293;
 Fri, 06 Feb 2026 17:23:56 -0800 (PST)
Date: Fri,  6 Feb 2026 17:23:28 -0800
In-Reply-To: <20260207012339.2646196-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207012339.2646196-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207012339.2646196-3-jmattson@google.com>
Subject: [PATCH v3 2/5] KVM: x86/pmu: Disable Host-Only/Guest-Only events as
 appropriate for vCPU state
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70530-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E6401104785
X-Rspamd-Action: no action

Update amd_pmu_set_eventsel_hw() to clear the event selector's hardware
enable bit when the PMC should not count based on the guest's Host-Only and
Guest-Only event selector bits and the current vCPU state.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/perf_event.h |  2 ++
 arch/x86/kvm/svm/pmu.c            | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 0d9af4135e0a..4dfe12053c09 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -58,6 +58,8 @@
 #define AMD64_EVENTSEL_INT_CORE_ENABLE			(1ULL << 36)
 #define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD64_EVENTSEL_HOSTONLY				(1ULL << 41)
+#define AMD64_EVENTSEL_HOST_GUEST_MASK			\
+	(AMD64_EVENTSEL_HOSTONLY | AMD64_EVENTSEL_GUESTONLY)
 
 #define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT		37
 #define AMD64_EVENTSEL_INT_CORE_SEL_MASK		\
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index d9ca633f9f49..8d451110a94d 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -149,8 +149,26 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
 {
+	struct kvm_vcpu *vcpu = pmc->vcpu;
+	u64 host_guest_bits;
+
 	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
 			   AMD64_EVENTSEL_GUESTONLY;
+
+	if (!(pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE))
+		return;
+
+	if (!(vcpu->arch.efer & EFER_SVME))
+		return;
+
+	host_guest_bits = pmc->eventsel & AMD64_EVENTSEL_HOST_GUEST_MASK;
+	if (!host_guest_bits || host_guest_bits == AMD64_EVENTSEL_HOST_GUEST_MASK)
+		return;
+
+	if (!!(host_guest_bits & AMD64_EVENTSEL_GUESTONLY) == is_guest_mode(vcpu))
+		return;
+
+	pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
 static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
-- 
2.53.0.rc2.204.g2597b5adb4-goog


