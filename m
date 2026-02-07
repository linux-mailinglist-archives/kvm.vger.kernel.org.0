Return-Path: <kvm+bounces-70529-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJvpGViUhmnuOwQAu9opvQ
	(envelope-from <kvm+bounces-70529-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:24:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1125B1047C7
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 02:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F393E305BAA8
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 01:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8BD27816C;
	Sat,  7 Feb 2026 01:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xC9Ev/1B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1E280CF6
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770427435; cv=none; b=QY81Cea7u+G2G0nREwto0jK7H1mMcTakudTTVWBRyCPjhSMnUuY/aExrvvSaCJKq9Unp6AuxvbKZb74hgk+GdowK9nv14jjpIPSHZVouQzIPeGK09mpdr4qKjklWcwVlX6Rs60NKYI853x3Se5IwqRFzAZKazsWzWv1pzOjhwV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770427435; c=relaxed/simple;
	bh=rUj9ix3uDrXvjD+ufVp15UBmVgPFZ3lQbTxS5CHo8TA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EAo+VlT+UtDyTYB9kZu9XgI5c3YRTJWJeMrGOGPr22rxodDbv4ZGmoNCGkHNOfIoqiefbcIXxtegdRTzJCWTKQjlnbRbmou6j6Jfy+Ilk2Rq/5gqRtVUjwQbJnEUytUkQZLEpULkvo8b2rHw64gvdUQeBdKa/XSTC+oNg6VSXnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xC9Ev/1B; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso2643502a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 17:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770427435; x=1771032235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mngs9Ic51OGXCzrzlPYHhqLnfHfzn7x/zcXQZcf+JUA=;
        b=xC9Ev/1BaCnMn1BVZWCASpZ0YZPPZA0IleJk0+Q6STFiPgu+1qYSOpDL61NWOL/Dn4
         TreEjYPLcOEd4uejgtKlxfOQg/joWUK4fL/ZyaHfubi9vJhBmRJq0fOhp7CUlQhQM01h
         CStQNulq4EpubXIk/3OIWw8puutdp/K0CZSrTfWeEOIZriHrK3+Fy1NAsdm5EsJm6buL
         8pHJl3YX0jRthfVUa1R7yjLCzK3CmXLh9xJ+wsh8kMiLjhoQRAvq0S1+mM7x8sDHa0gf
         wzzJ0YrfkRQcTknq1JZM/P8jcPq8r5aMFb0U4IoMqliznVEjjOtd6qrTuw3P87hFR89g
         QrgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770427435; x=1771032235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mngs9Ic51OGXCzrzlPYHhqLnfHfzn7x/zcXQZcf+JUA=;
        b=MxajiHiCCKvEFRr+eeEQjssieb4i56y/Qngaur6ui3tIfoZ5k4cM/NGhCcnm9ThaP7
         YOTc6iB7S+WNd2AASft/Orbpg6YuZkO/g4ivDij79UcnmnTQd+fUAVG27qdnni1R1CrT
         zptozqNlWqKQ4ueFjgCDvDOHeVt9jTv6JiO/Uq2ciH7U+G427MdOoDn2AfGZlhukVoQa
         +pH42dhso4cr9TdFo+IX6buV4cVCb/Ih+JPAV/mj8/zhjzgPp+/KQNKCoqCCKT1sFAS2
         9C7gipI2lGvq5qKCxnHLscjc4L34HiEwt0oLMP3BsKgDvib88L5VLdsF4GFj1+qOdj8Z
         l3eQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvFAKOob04Kyx1vDEwIRS6UUPOgtcJjxS42cBAvQxYtqrhm5Y4AXwO0wwRK/kJgFhgqbY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxt4VZG+SZNREwFdwHgx5MvA2vPdojx8SRJZkYYG2Ou6XP8qTF
	XQudFMMgEuV5BY4a480Rs532tqkGndG2PklhXpu6RDWO44lH1X5XwvMHteT2USt5GL7jICkZYVN
	8dp/TBr23Uv3BtQ==
X-Received: from pjb13.prod.google.com ([2002:a17:90b:2f0d:b0:354:565c:69ac])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5348:b0:340:ec6f:5ac5 with SMTP id 98e67ed59e1d1-354b3c406a0mr3511383a91.2.1770427434980;
 Fri, 06 Feb 2026 17:23:54 -0800 (PST)
Date: Fri,  6 Feb 2026 17:23:27 -0800
In-Reply-To: <20260207012339.2646196-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207012339.2646196-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207012339.2646196-2-jmattson@google.com>
Subject: [PATCH v3 1/5] KVM: x86/pmu: Introduce amd_pmu_set_eventsel_hw()
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70529-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1125B1047C7
X-Rspamd-Action: no action

Extract the computation of eventsel_hw from amd_pmu_set_msr() into a
separate helper function, amd_pmu_set_eventsel_hw().

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/pmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 7aa298eeb072..d9ca633f9f49 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -147,6 +147,12 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
+{
+	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
+			   AMD64_EVENTSEL_GUESTONLY;
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
2.53.0.rc2.204.g2597b5adb4-goog


