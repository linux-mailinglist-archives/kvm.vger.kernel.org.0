Return-Path: <kvm+bounces-41825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF29A6E10D
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3191B1893884
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD57D267384;
	Mon, 24 Mar 2025 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LQTiH46V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9FC266B65
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837590; cv=none; b=YHoFVLtKbvjs5uPtSPROxCsHsVKsgvRbEwmEJFXV5iHR6AZ0n71fiKq8XAZRPIBY+FRkTFBXdwrqjnqTBYVpYiooZ7UQXD8BIZ0r+QWO+C8eXAugDq+xmuyfcZP1bhg/u8ZFnSt9u66JFaNhU5gye9iFLmBVjA0IiItc8WaoGsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837590; c=relaxed/simple;
	bh=uZHApNHtC1srnE6XLFaAhncIb2YrpW9H049JpCQwpNA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GktBeTLQMlrLmWFjdNo+t/jxLPcpe1yvi1lX0rdVtuUU3e8O75IgJQ7qUtHHbMhDEE/vwRk28PRB8BT9W54C7UGJQJmM1HqZ3cMSzDodwyZFPf63z0iDq7TMeOa/HuySoRAeN+8j4JAdv+LXVu7i7jlLbXSK8rMLCvps7XRTYUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LQTiH46V; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2264e5b2b7cso69864105ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837588; x=1743442388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EQNh2u0xTlEo8Nzfc2nQDu4yd1/+qtwS3CX+UnSCF+k=;
        b=LQTiH46VZZ8v1TDQNAq/Ex4NBdXkNWMJTHryJN/9588OjpKKOS8JNsxJqfnhyjXye3
         +rxIM9CEyRNlt21i1RGwhgn8VbY1qwzcpaYZOxfX8Ac60s7F2k+Tzdy52XDREcWPvb+Y
         6r/4b+L6ZQRs4qHV5em2+3fQ52xzu5AJmm3BS2PfOT605ZYLK5sMPeOOkXViWi9R3Scc
         75CefBDWdpu3zYp/yLAuG/BYC8kILRxLm1L5vg4tGwnTnjN7IhFBpuKo7IJ3tkgrTU1t
         Clxm862XMEDXgE6PJRN6E81n8okOPKLh/xwccx9tSrRVktZraXZYPHB9w74vvPyvfIdP
         8hjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837588; x=1743442388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EQNh2u0xTlEo8Nzfc2nQDu4yd1/+qtwS3CX+UnSCF+k=;
        b=ZH68TcZ9r96x9gELsWu+9aG75GwrmJhQ3U2ZnhTG5NEepkVVvm0RV0f7ZIA5vqOWuK
         0bUffC+FGYKUkbBsz04Cf/B2txAa90l3WdTptic7k6ZzEyXo6D34aG9OkyF4Vfw980oD
         alVs5PaXeq1ianqaM/KEFKw15Y/Jshf4b1GUyySkMvcqgWvk7jl+RAhVFLiWwWNHR9d8
         ZEyUQNM01NY1E6nLo1iUJsyCVBq4l1XQDU57yQ3HMHKsJacZ6UwqxyNVDh12BQ2BgO3b
         7evfWx7gCsFu5TygueNq2EWa7uG7uTFSmo5yL1gAT96UQs1cpLUwf1fXelB8iwoUTEP8
         P7ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr7L6VN+WnJ58KseyEgBtZUk4q5f226Nc7to2vk1voqu0KmTp04bTeCVG+1Zdny7qTGdo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybi+r5WD4uN539EH4wpL+63GvuMzNmqCPwszotJ1nxIyGh+Yee
	PtVQAL/XwqMDO0io48nLesWgvZbBz/pgoNfbuaRFRY/7wigorPb1KUHSTcSLmx2+LSRVs5ZRpff
	UPc/ouw==
X-Google-Smtp-Source: AGHT+IHHgQ/VTpQK+Ek9oKOxqSwHtDlsEEsDEATZSstz5FpSTkUYvsnRaM4XcmWiSvU9k8/G75kMTSuBQ3o/
X-Received: from pjbsr7.prod.google.com ([2002:a17:90b:4e87:b0:2ff:5752:a78f])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db0f:b0:224:2a6d:55ae
 with SMTP id d9443c01a7336-22780e2aff0mr223959085ad.48.1742837588117; Mon, 24
 Mar 2025 10:33:08 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:30:50 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-11-mizhang@google.com>
Subject: [PATCH v4 10/38] perf/x86: Support switch_guest_ctx interface
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

Implement switch_guest_ctx interface for x86 PMU, switch PMI to dedicated
KVM_GUEST_PMI_VECTOR at perf guest enter, and switch PMI back to
NMI at perf guest exit.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 8f218ac0d445..28161d6ff26d 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2677,6 +2677,16 @@ static bool x86_pmu_filter(struct pmu *pmu, int cpu)
 	return ret;
 }
 
+static void x86_pmu_switch_guest_ctx(bool enter, void *data)
+{
+	u32 guest_lvtpc = *(u32 *)data;
+
+	if (enter)
+		apic_write(APIC_LVTPC, guest_lvtpc);
+	else
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
+}
+
 static struct pmu pmu = {
 	.pmu_enable		= x86_pmu_enable,
 	.pmu_disable		= x86_pmu_disable,
@@ -2706,6 +2716,8 @@ static struct pmu pmu = {
 	.aux_output_match	= x86_pmu_aux_output_match,
 
 	.filter			= x86_pmu_filter,
+
+	.switch_guest_ctx	= x86_pmu_switch_guest_ctx,
 };
 
 void arch_perf_update_userpage(struct perf_event *event,
-- 
2.49.0.395.g12beb8f557-goog


