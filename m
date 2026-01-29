Return-Path: <kvm+bounces-69641-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UP8dOHTte2kMJgIAu9opvQ
	(envelope-from <kvm+bounces-69641-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:29:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CEAB5B1F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C32A7303DD1F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCD3376BED;
	Thu, 29 Jan 2026 23:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iYXjNALK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19AA376BF8
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 23:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769729345; cv=none; b=iGuNyga2ZipThR5XHh4+eIGu9n5f7XMaQk/AZjXZbDkLGVrwWIdALDiO6eKlSZwgJp09tVYbiLcS5+E9dBFGlMpTsYydbq/X6N0bi4jQfqrrSayAf7hGifvCOAur7zbvnvMkg7UsQXXJ3J1sQyBytsmsTChMqgX3VsEGgDUelY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769729345; c=relaxed/simple;
	bh=rxUIt+q7usKdyM83oKGeQOrRZ8jjXQg7Zut/P6eD5vQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pr2zBRcUgaW5pJnqk+N3qpOZEKhBXce1/tALBw9XKQfqtkllO8YULxsJOYmWixtO/0nUy1KoL2RO3pbSpJuMdn2aXjjp/hNkEFsMiioctHBmQg54cTCCVqluMNWuaznfKiglzTM+0L+scvwyj4nN+ZoClHWj72idmUjE51QkxzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iYXjNALK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352c7924ebcso1510432a91.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769729343; x=1770334143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJF3W6JKHBnrv8F/Fuh9dIOMXuUt3tlkhxE5lP4gDnc=;
        b=iYXjNALKQ8O1HQZYHDQ0LHCC0KceNhjV2qSJkGPmIvgbrCPwCtV51TaB61q07UztNz
         +5lkzS3/VULs1EuR3EMS1Xcc9MuM+21OwyTXNr05gbMxNncjiAfZqi3pYuDw9v2WvLJu
         zQOjaXiD2c5UvXiyzzLJ3YiANbOgOnFMboo9ZyH23f0LX3U4UOiVdYWWMGpaVSzZv2jB
         vftLHxN6kqRrCbwEB7Uo39senSQPnfVc74luO/HkAKYy8nUzTuEEGAYmjUq1QNrT8yr0
         LRZlkM40PWVvnES7MXFkhBwq1LpLTB2t+ajELA9jvSvV1TQRG/Pe9XKJyogkxhCrsqbB
         XpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769729343; x=1770334143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJF3W6JKHBnrv8F/Fuh9dIOMXuUt3tlkhxE5lP4gDnc=;
        b=U52w5pcMIjx3BOZJUMAgPKQAAD9DwA+yBdpTlSh8CnXmBWj+nsejkqS/x5VCJBUeVy
         keBtQja9Nzy1FInqol3uCuPvNJclagOCV2TizV9pGpDtZ0HOlzvCUWvR5oUYs/KM8r0L
         +l53RGx5rt7MgDXjV9bLgvcW8kPHUe5f+T8+v+5Ax01j5eCu5wlh59UeTDTDEtXBYtmO
         MncDt+FudqrSLy5UA8SJGenGE8HXvpbzrDWByQGrX/PpeFBkG0r2omqxxnhrojRaotOP
         u1KpHawVCdCPCm4kD9J0P0y65C7J35YTyQ+CEC7qNknwHUw1vvGa20qCOqLjuuWSmUpY
         oD8g==
X-Forwarded-Encrypted: i=1; AJvYcCV/x719Q7OjYORL3UCy9rJTnxGjmC4nKIn8AyoaWcX5mqzR6OohFdHMsDvAaHwglU/egck=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNZX1P9lQOwdTpCy6R1onEPc+LcA5jsU3F7tvdxX/ZCO8Q685c
	x4b5Tl9KxgTEmjgbJAiy1UrjZ5YOPCVzjZL9IojaSmfXk7DwOTdJi1Ro/sAocOq5drTk99FLvp5
	7cLeCFnGm8HJ1rg==
X-Received: from pjvf5.prod.google.com ([2002:a17:90a:da85:b0:352:d19a:6739])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:518e:b0:34f:62e7:4cec with SMTP id 98e67ed59e1d1-3543b2e00c9mr820536a91.5.1769729343203;
 Thu, 29 Jan 2026 15:29:03 -0800 (PST)
Date: Thu, 29 Jan 2026 15:28:07 -0800
In-Reply-To: <20260129232835.3710773-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129232835.3710773-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129232835.3710773-3-jmattson@google.com>
Subject: [PATCH v2 2/5] KVM: x86/pmu: Disable Host-Only/Guest-Only events as
 appropriate for vCPU state
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69641-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 71CEAB5B1F
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
2.53.0.rc1.225.gd81095ad13-goog


