Return-Path: <kvm+bounces-69646-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGRREjLve2keJgIAu9opvQ
	(envelope-from <kvm+bounces-69646-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:37:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEA4CB5B93
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 14C1A3023524
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2BD374177;
	Thu, 29 Jan 2026 23:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c67zF+M2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com [209.85.160.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042A335081
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 23:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769729817; cv=none; b=pHG0VbKe0S7e9HJNdoyrHSRL92Zkjop8SfII4C13uu6RqdcxSVHAaBGsk4P+7CZyDYD2P791PKFEc2FuV60FC+CKXiZ2X7zyz4wa67CsA+2ouT2i4qUN1D3oZ1qpIDElLYINBOee8aNUb4arRJU2/WLlxmn20LJX55NBHc/ih4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769729817; c=relaxed/simple;
	bh=+Ao85fypcu2LNijyP/Yd5fo6qd6PkBX5yK78fvuZH0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kqjs4D8aJklQ/IP9dIbESh0VsJxIOyvptfoqzx2nq92olGkkZv9JmFfxC7gFxdGBIZvX0dEmXvmV5sY61K4wlSrJjzF9l95lZHWHlaKEGY18daL3WkyovoADOsF3FHR/plr5KrpPEec4Vko25tvPMxoKmFhTfJloADBgYL8Uoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c67zF+M2; arc=none smtp.client-ip=209.85.160.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-qt1-f202.google.com with SMTP id d75a77b69052e-501473ee94fso74664171cf.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769729815; x=1770334615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A1eDEoFXt8XkhH54WsqjXw1OZHZdHjK/gtE/fEZN/Ec=;
        b=c67zF+M2ZFNP3U+X8lH1rMIitsDaj8DpqFqHXD6bdblk56fEr94w9/Xoy/0gKqVZe1
         34JjnM99hNDpLJuvFuDG/a9e10tyd0z9noSUCPbanYOs29FHMMP++B0Zk+gd27cnzjkS
         n8XGf3s2KWey+PoGaesqszlz106ozucDsIFNwxnnSnTS3awozRl2Jwbnu2Cho7Nzmijm
         K+hmTBOOB1G/7GT5wAjyYbvQ/uWvvueAO0VwAwiw7XjmwAy3jloyEQoyKYpuCI3+Zg+k
         XE0WBBEFsiLBXipUNv/AbVTy2PVrTLfiYqQKhnRb0QEWVkg8GO6z9RJZ1VERIDzPRTFV
         lINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769729815; x=1770334615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A1eDEoFXt8XkhH54WsqjXw1OZHZdHjK/gtE/fEZN/Ec=;
        b=gb2RF7sIq593XIwOIR1bixvErukPbl1eL94mt3w9eXknmhhkrIEuOYi337wb8GdlkP
         03yzS4z+ov7ZcLZatft+XmRXUduf5HvOePHQSpYKZgCNI4vewZZnkv6/bUHBB65IX6H4
         cNxM6j3fX70b+lA/x+5oouP2BsR5OhCwFe6oVqdL9vJpohjZ9M/ej+A3iVHJ7lhXFi9I
         PcsoNrVJTSlSCM3OmQkcsYQXTXd+WKvZJDbPo31HJTKXNXaImv3KgCuZb6r5gUFbJjCc
         irW/AhddiJT3lYhdfQ5mIkgpL0AiQmvU1AuDFAAm7jlQd35ojJhE9LjI5rq5NKNnag+l
         +rmA==
X-Forwarded-Encrypted: i=1; AJvYcCX5/9uyufCLnKBoHdIvEZmuDt+Jlv/LjsBmyApD04XXdVl4x2V+NJPir6NyDOoelMqwojU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ4VaVd0YQowr0cjzQXssKaNxbbT1BoG0bMifPzi61ECd5DkRi
	WRGakO9R2WUQ4Fc9h5UqKrgjs2B6bO49K8Q6Beehg2qDWpDTGF9RAw3x6GNynDv8HXNNiDdl5Uo
	OxVWAados3D0wIg==
X-Received: from plcp2.prod.google.com ([2002:a17:902:e342:b0:2a5:9a63:12d0])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f552:b0:298:5abe:4b1 with SMTP id d9443c01a7336-2a8d99469cbmr8037505ad.52.1769729341586;
 Thu, 29 Jan 2026 15:29:01 -0800 (PST)
Date: Thu, 29 Jan 2026 15:28:06 -0800
In-Reply-To: <20260129232835.3710773-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129232835.3710773-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129232835.3710773-2-jmattson@google.com>
Subject: [PATCH v2 1/5] KVM: x86/pmu: Introduce amd_pmu_set_eventsel_hw()
From: Jim Mattson <jmattson@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: mizhang@google.com, yosryahmed@google.com, sandipan.das@amd.com, 
	Jim Mattson <jmattson@google.com>
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
	TAGGED_FROM(0.00)[bounces-69646-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: DEA4CB5B93
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
2.53.0.rc1.225.gd81095ad13-goog


