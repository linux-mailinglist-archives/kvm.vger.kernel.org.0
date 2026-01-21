Return-Path: <kvm+bounces-68819-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBzELXxZcWkNEwAAu9opvQ
	(envelope-from <kvm+bounces-68819-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:55:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4225F23A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6EA595AA060
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945433D333B;
	Wed, 21 Jan 2026 22:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="blT4m+/B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E27258EFF
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036112; cv=none; b=pOECObF0eIoh1zmlRnE0ItMeF5EenM3XHPYUF2sH5cI+D42V2jsALsoYez+Q5MDdoLPIixWlbCyrhMFn+E2g2P/Y9dLf8MpYDdG/icXJGDIqIU7lyFbf17lLXtm4+GHZXXnWvhA+oPBVYbntsK6ukyRu2hxuV787doI8zGoWHbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036112; c=relaxed/simple;
	bh=Pk/3QwlgAbVKnYQPlfuyPgZDvQuA1ZpRf9r+jYY8pfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t2jzYQP0ftC7GdngHIPd2HXsjbCwtXMikXwE5i8HxI3ubRyVFcFwuybw2wQJ7L1qsaAPSFou7wmaAMSB4+pN5kpN7QXONa3HsH7dl6HPul9vCAkMgEuJF/NaDK52/EzOSlpIebnFwHctOJp5AWPu4dbJ6+gpSzTnbYqYVULjnnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=blT4m+/B; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352c79abf36so289598a91.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769036106; x=1769640906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HMs2hdc0hNqNKtUHLf8UfyYdyy8QH+t4ULVxDyYCi60=;
        b=blT4m+/BSEqVX3S/YUpCMTs4CbXTOZtziwFx6dwktDIMfbU/4HF/6yxvArLL+E7QYS
         w/UXg6qsGfeg/MST3MpH2PGCcFMch2FzDyFTNfPZsK0ob/H2BPHn6OXa6vt9eCYEBZ75
         1ba1mwlYf+6nnQmAzzaOWjjQVqTO3YrKatyUCD+eDNk1idPNV57HqOAZVlhFwR7HZfDm
         sUfAxOXWaAEOtthBlNMwhVcpL6/LfiYgt50dpssSXHRMKKwY8ERR/lN8gK6BpFRLpire
         HxqrRwrdxA46oChrKwpTSDDGY0GJx+islo3OkWoQ6CfPGkuM5zR0yjyajuVX7ftvsghE
         zcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769036106; x=1769640906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMs2hdc0hNqNKtUHLf8UfyYdyy8QH+t4ULVxDyYCi60=;
        b=c6WMkpZztoDOUrMk8JFG5Xf9HHGBz5o7GuZKRBJYFtTJufYg3kmubruMV5Z3QF2KU/
         kvbYChuu88bc9bXhBD194HHs5KKgW5GHMKsTFfSxUo7hu6HUspaHC32gpFUuG/RGDfTE
         gQVVdNSnraqWrAFlTM/+Z9n3CNzypxsqY/cjmpbHo0RPWv78HKfJ/ptxIbyWsylxTpJ6
         DNXDzrUBnofWoa4o2olRfFK9PJlVcXmWCW1Eg66PmS7iM8CP+YLrvLbfw7ewI1Jwdp6f
         K9itMQnL/GPFB8nBgSSZStHNLMpJ0l5crTWFTuqCktt8bw45tzDK+MfAQuJjVSRIVTLe
         Vucg==
X-Forwarded-Encrypted: i=1; AJvYcCVKqmnncS2vnoQtWziz4YO3gyTfRttyACGoVHbCavt90cIIdbnA6yKv0w9g9E47hDncZQo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYow/Y1HBGTXltrgeVejH4zm/WS1D67YXbivbppyKttrxr//mJ
	Jvep/Vtwg8AQ6KADiZvCNMy00pfxKAzxqcdPsgdRHEMUksyQnED70kg2hlF6VCTet835la4hfTk
	TDizPsBOs7KRnCg==
X-Received: from pjbge20.prod.google.com ([2002:a17:90b:e14:b0:352:c381:4153])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:570f:b0:330:bca5:13d9 with SMTP id 98e67ed59e1d1-352732775a8mr13429526a91.32.1769036106410;
 Wed, 21 Jan 2026 14:55:06 -0800 (PST)
Date: Wed, 21 Jan 2026 14:54:00 -0800
In-Reply-To: <20260121225438.3908422-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121225438.3908422-3-jmattson@google.com>
Subject: [PATCH 2/6] KVM: x86/pmu: Disable HG_ONLY events as appropriate for
 current vCPU state
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68819-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 7A4225F23A
X-Rspamd-Action: no action

Introduce amd_pmu_dormant_hg_event(), which determines whether an AMD PMC
should be dormant (i.e. not count) based on the guest's Host-Only and
Guest-Only event selector bits and the current vCPU state.

Update amd_pmu_set_eventsel_hw() to clear the event selector's enable bit
when the event is dormant.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/perf_event.h |  2 ++
 arch/x86/kvm/svm/pmu.c            | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 0d9af4135e0a..7649d79d91a6 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -58,6 +58,8 @@
 #define AMD64_EVENTSEL_INT_CORE_ENABLE			(1ULL << 36)
 #define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD64_EVENTSEL_HOSTONLY				(1ULL << 41)
+#define AMD64_EVENTSEL_HG_ONLY				\
+	(AMD64_EVENTSEL_HOSTONLY | AMD64_EVENTSEL_GUESTONLY)
 
 #define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT		37
 #define AMD64_EVENTSEL_INT_CORE_SEL_MASK		\
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 33c139b23a9e..f619417557f9 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -147,10 +147,33 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static bool amd_pmu_dormant_hg_event(struct kvm_pmc *pmc)
+{
+	u64 hg_only = pmc->eventsel & AMD64_EVENTSEL_HG_ONLY;
+	struct kvm_vcpu *vcpu = pmc->vcpu;
+
+	if (hg_only == 0)
+		/* Not an HG_ONLY event */
+		return false;
+
+	if (!(vcpu->arch.efer & EFER_SVME))
+		/* HG_ONLY bits are ignored when SVME is clear */
+		return false;
+
+	/* Always active if both HG_ONLY bits are set */
+	if (hg_only == AMD64_EVENTSEL_HG_ONLY)
+		return false;
+
+	return !!(hg_only & AMD64_EVENTSEL_HOSTONLY) == is_guest_mode(vcpu);
+}
+
 static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
 {
 	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
 		AMD64_EVENTSEL_GUESTONLY;
+
+	if (amd_pmu_dormant_hg_event(pmc))
+		pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
 static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
-- 
2.52.0.457.g6b5491de43-goog


