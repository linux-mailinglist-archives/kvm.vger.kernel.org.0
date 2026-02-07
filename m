Return-Path: <kvm+bounces-70533-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBhoHOuUhmkUPAQAu9opvQ
	(envelope-from <kvm+bounces-70533-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:27:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1DA104801
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:27:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 06BA3309B5FA
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 01:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFD4284B3B;
	Sat,  7 Feb 2026 01:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IjOQ+/4R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167E428A72B
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 01:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770427444; cv=none; b=u9To+s7ZXT+NUshD5b+VNLmAlEnilwCU6ou+bkqcnb6yNAMihkGm7jLTTxSr0N2+5qf/z6tXPmluCIhSfftTfuJgzFL+2LLuW5VXuhP+wCo+3u6bpQVBQNDsp3EI57t1WkYwBVNGiXbDGP1DK9gfv6VKj89Fc9V2wjFtnZzDR74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770427444; c=relaxed/simple;
	bh=VX6DCgwNWjB+/bxyXx2Y/ERrnxSlvMrxT8BUrW+i6nk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iKQUIl43FiwmNpNsC8JT6RjIeonn7kIQ40CdlM6iL37r6SWq0i0BgI7ipMIWFOtYOYpsCeO8uAzbOIxV/fHa6Og5ajZgOuM0gu8CeMaFcARCGrRqfU2eT568W11EV66PjZw2YwEufGkFUZqhsRVsYlo+U1eije/38qAXOaLNifM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IjOQ+/4R; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354bc535546so726905a91.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 17:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770427439; x=1771032239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2fG+Y9KC4ijGwyN19NJSb/KoIzzrPjnkRSfXL2ajm3I=;
        b=IjOQ+/4RuSquwHXKoAa9vFe/yfc+SUwVw3ngAcB1u7guSkjCeZsNMJNJ4WD13gqXVz
         pRpSGajBjF4DIay+yyPeu8G5dPjn6gDCUiRdlkD5w7SXC7OMPulzV0FV6yqD86x7v4zl
         yMo4hbBLVzhTZF8AJwFz21LcE2DHOeSwH3UOU2uvEW8/juW9/pPJIrtj5SUmmQ+0CyKq
         4AioybtSBxjAM/hwTFgntglIw37/ibNhVh5Wq6UUtuyn8l0+wO0F0b77e7vuAz9xKyXK
         hq/NmHrph5WRnxJ02tc8KtI1/zmwP9omdNU8A4taYcj7rH23ffEy1lBZRckU8yoQRnwZ
         fsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770427439; x=1771032239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2fG+Y9KC4ijGwyN19NJSb/KoIzzrPjnkRSfXL2ajm3I=;
        b=V2EKNRncmeJzjwEonelEXJJEvGwGODZWoNsb6vNO9ZOOfqFEIDyRIPXaZU4Xgr5Qkn
         wKoHXG5ZQ2LJDzUTt0Ab0y3gjfGorxFOfndqQTmwErQwBoaa0I1rz0eHqfrbCoYB7DNu
         cGdyzGY/jhfXY3RcfZsqt4YtU+kqzfrb6USJnhlL3khz4W032pPO9mPR5u84awK2tG4U
         4iWl2PRPZMP4zXqEV6N3351uPewszkuo8T1LwoAiRYE+NWm2vEQLv3LxN3NR5SC7KN3l
         LqcwiOAfTTZUoZo/IqZccLlxRys1/WVdgXEJjIVYxESwZVx1LxIaJ3bNZyrRLaGXT1fC
         IoCw==
X-Forwarded-Encrypted: i=1; AJvYcCWcY1WO65J6rKtZkR1Wx07Q5c3tHXDTL2XwnXF5oEXflCOZo5B8/tB8q5hyd73gBzlmPQI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsEiF+JQEM/g88Gk1qYxKJkbQcKTRLSG3A/KFRO8gm7mfNkHaz
	OOXnqxY49qT38T+k69nYiWssAbDjmCEqYdzgg/l9ja8hVN/mUjebDPPc3T+Wjjtt9BRgK+AQq47
	KWdECLzZhs3m4eg==
X-Received: from pgum10.prod.google.com ([2002:a65:6a0a:0:b0:b49:d798:eefa])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a127:b0:366:14b0:4b0b with SMTP id adf61e73a8af0-393ad3ddbf4mr4788833637.71.1770427439372;
 Fri, 06 Feb 2026 17:23:59 -0800 (PST)
Date: Fri,  6 Feb 2026 17:23:30 -0800
In-Reply-To: <20260207012339.2646196-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207012339.2646196-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207012339.2646196-5-jmattson@google.com>
Subject: [PATCH v3 4/5] KVM: x86/pmu: Allow Host-Only/Guest-Only bits with
 nSVM and mediated PMU
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70533-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CC1DA104801
X-Rspamd-Action: no action

If the vCPU advertises SVM and uses the mediated PMU, allow the guest to
set the Host-Only and Guest-Only bits in the event selector MSRs.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/pmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index e2a849fc7daa..7de7d8d00427 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -243,6 +243,9 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->counter_bitmask[KVM_PMC_GP] = BIT_ULL(48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SVM) &&
+	    kvm_vcpu_has_mediated_pmu(vcpu))
+		pmu->reserved_bits &= ~AMD64_EVENTSEL_HOST_GUEST_MASK;
 	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-- 
2.53.0.rc2.204.g2597b5adb4-goog


