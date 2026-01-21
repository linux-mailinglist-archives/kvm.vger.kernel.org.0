Return-Path: <kvm+bounces-68818-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAwAIHBZcWkNEwAAu9opvQ
	(envelope-from <kvm+bounces-68818-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:55:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CAA25F21D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B75B85A5F2F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A8644CF59;
	Wed, 21 Jan 2026 22:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YLlXm7Gh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833F440B6F6
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036110; cv=none; b=MIuyr6n9D68zQpWhzsZxVCF11aLhVqf5xoR+upIvjBv6AslkyXeaq5XCD8xGyOsSFX6U5ju3JkspeXB4VbSi8PchncA6CL/reY9qo2XaHD56u9wJUmtsT6akcP1YK/l4nRf3Y/iI2fik4JWlqgWku8DqX3gsqNWf3kYA23mzx7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036110; c=relaxed/simple;
	bh=tr63TBX3kw3rhNLR4KkCTKohb2Q3vQr3rghbN731DHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gPOM9AUqoDwBXOSfPscoodN39TTQO3ij1RnjOohA27nhDgg+StLLEuOUXRQrjOtIoOkPwXNBI2waKK4Guq50HInPzpJ2YwH8sA1DDDQGsA2xrgrdYXrnQokKVOvNin81ACRKT0xxN+8jwqvjmQ1hLLTYqPeQtFyFDs331ru6KdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YLlXm7Gh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so324989a91.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769036105; x=1769640905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXlvlmMGjx+7txGDPivw+jyaPXiVrEUwOPpV1iC4Qw0=;
        b=YLlXm7GhBJImVFMKSkMbyFKW/777Amb4LuCYph2aadlPnPuxq4qnvJYie8/hmtlV/L
         ccxOATpxh0M0sKf7nESKhgsMSfydkFhyD6Oxie3RDZ+FFuKs+4xlk0WeHc6PgFYQQrVt
         WoNpBW6murp5L7+W7heZGeOzEx5BxjemmltKLS9rFfrdX9fe51k6S3KRkx7vY/pYExFr
         ZmJ/iEKUDZ3ydf+FgkyKes9Ia+09bU1f0tFxue9x38S7Coc8t1MuVseB/XSydmfHUhlL
         Enr50Uj2rwIFMgniqXN2YXlXFYUhWrESnBFaiRUxJzELwAbeRCnLsS31b+AzmLoDOtwT
         Pz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769036105; x=1769640905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXlvlmMGjx+7txGDPivw+jyaPXiVrEUwOPpV1iC4Qw0=;
        b=qXncPiL4trgIFUsPPGXfOuzqDCuRBE/cQ7y8DEx6nJA1k7Ih+qPKEs2U5O7QFYiyhT
         cFwBjY9sNa9rn086EbwT9AgT8P7RQwukWE5kUMtRNk0yVcLyxWkNfdgS+3mJxsnQh46y
         N9/Y2r97L1rX7kN70NMJzlTFr6Ueil1/jUTh9QzWdjs5VnHEo266d1pKu/0OB1kruzwp
         cCaaU9FrOdZ2QlIPw7z3Fu6jpdikC1zepbsM8Fkgn13q5UOJhpM5bTt7kTjL9nRZrYW9
         0wfRrxJIibpKQltM5TXfN3EXyVsXmiQ7EMw9N2o1arae0idqVSi0hYV0WVPzjkhPdFKK
         d1/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXuAfOHsIj/qL4M7GGWKqEIkxrFkz3x6p5IzdDpNOgFg1Ueq+4q9R4o5mk6qTMPZp9oWUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI3QGnnKwoIbcxkq4xxRvFdvFZwgjpCiNu4ZYSiMx3+9vc/8Tr
	SJVH00WZBCKiig+N4klXDDT6+rj+nNwfyz8ZNKnfhGv4ina5IHAOd3vCTcZPI/amGOmAG8LlSJv
	5Xd93BT0y/pfa8A==
X-Received: from pjbpx10.prod.google.com ([2002:a17:90b:270a:b0:34c:3c14:d369])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3fd0:b0:33f:f22c:8602 with SMTP id 98e67ed59e1d1-352c403aademr5934916a91.26.1769036104764;
 Wed, 21 Jan 2026 14:55:04 -0800 (PST)
Date: Wed, 21 Jan 2026 14:53:59 -0800
In-Reply-To: <20260121225438.3908422-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121225438.3908422-2-jmattson@google.com>
Subject: [PATCH 1/6] KVM: x86/pmu: Introduce amd_pmu_set_eventsel_hw()
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
	TAGGED_FROM(0.00)[bounces-68818-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 3CAA25F21D
X-Rspamd-Action: no action

Extract the computation of eventsel_hw from amd_pmu_set_msr() into a
separate helper function, amd_pmu_set_eventsel_hw().

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/pmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 7aa298eeb072..33c139b23a9e 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -147,6 +147,12 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
+{
+	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
+		AMD64_EVENTSEL_GUESTONLY;
+}
+
 static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -166,8 +172,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			pmc->eventsel_hw = (data & ~AMD64_EVENTSEL_HOSTONLY) |
-					   AMD64_EVENTSEL_GUESTONLY;
+			amd_pmu_set_eventsel_hw(pmc);
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
-- 
2.52.0.457.g6b5491de43-goog


