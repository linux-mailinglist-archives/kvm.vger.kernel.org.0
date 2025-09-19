Return-Path: <kvm+bounces-58089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 277B7B87869
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F05F417A840
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE40E24DCF6;
	Fri, 19 Sep 2025 00:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f9+makWz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691191A9F93
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758242718; cv=none; b=T02zHne5y3bdjLtSa0PSZY1vesw06yVOfL1t08/prqAROAYiW5qno+8IAdScOsQ5j6mqDA9jRfxTq/+T82LkdkzJGnyTlp31b3gNE3Sw0tt/pjQ92TNVbFmGpdQq/+kKVkCUuG8m8zS1oxf8YNL45/ZVQLE6zHGeXfk6fbbjbOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758242718; c=relaxed/simple;
	bh=GHMlzr2FhTOv+c4T5nvr/lgKTQoMQ7IduiCxorVExs4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZfuTNtsyPkkfOIgU/5N2Rn3fCpveZnqwWPuRwPPnqFl7jU48Zuh2+hn/yJLqyO+RLxQGHfKvw67hyqnh36asXTmucv0FaW4kwFXgObAoAfXlCDC7dbZx5nlgeqrrr81EO0xOgKnNpAb45PVfY0hETNYdk51OknE8h0LF+h7IE14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f9+makWz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so2743454a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758242716; x=1758847516; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=R7qTTFNHE+fMvr5BObVOavYnDFvgMV9D5f5f8nLVk4s=;
        b=f9+makWzCdMkti9MCyPqhd6NaBrYljckLQvbfVSPi4EIfFyldWCd9LnxGDaV9f9gCA
         8C3EM3YUXCFY/ntWrW4uTfY78aEOuTs+CJfANbtNKOoX/blB4RZCU7zsz3r58FJdmFuf
         lV5wZI+yenJO4DpOIMiZWTRLwSLa0JrpxU8KFRQyEziuMKTTUXs2jal5KYz7AVi8du54
         qrDsuNAQ94o9RRd/ALigIKFa3STsRuXTN8DuLv3qlGswOZUDbQJFmYT/jdwaxTNzT+vo
         tVsILbbAbhF3CVpsh9mko1EeAEfgCIoELZJeXHN+FIJ51+MgJYWf+r6oxicBK8vzHjkh
         Batg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758242716; x=1758847516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R7qTTFNHE+fMvr5BObVOavYnDFvgMV9D5f5f8nLVk4s=;
        b=j4U0Gp50XYst7NH62bZoxalZA4MZl41Bw0qJt196yzbXWkR9XX4uflkvJUzL5u01O8
         NOA1L8qP0cRSdp3/wndP5nEaDuRCBXnp8ECgVv6pXW2aZ7wByys7TU5SfvCAmqPgXNgv
         hGdqUDT3Uiwsh9oXGPaqd+UUb/eT+G9cE5n4bZWgIdj4s7AG6Op6g65M28/EVIZgjhES
         aLSmOm3mDJUzeXnwGaMmFkvTRxZRDOoaLJVu/hmet6CiTGkjzolTBaSx/xhqyTwCF6Zk
         tM7atnKZCvX83BX+28wmgoqqeum+qxOvbXMBmwm9vReaA/aZOoOeGPzZ8qVPapLAhSDp
         vjwg==
X-Gm-Message-State: AOJu0YyqP8/cpt9jrHpj1tsZNPJsHeq7bW7OoPQkJQxr1iQZYh4XCBzm
	+2C+Ww3V+BI0qeUFpFy/N1CryVsRcfaQOty/gQlYPOwb8MjJ2qZ7GbqjOMrwKRYPK0dMJYt37yH
	QAMQJbQ==
X-Google-Smtp-Source: AGHT+IEEQlj+6vJmW7RI1wxr1KK79HNPPL0eXn3RaPBcrhTf3Zc0J6v5CiAnOUQURMTOOtmxXlInkuLtiJk=
X-Received: from pjbhl16.prod.google.com ([2002:a17:90b:1350:b0:32d:a0b1:2b03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5408:b0:32b:9506:1780
 with SMTP id 98e67ed59e1d1-33097ff640dmr1633505a91.9.1758242716558; Thu, 18
 Sep 2025 17:45:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:45:08 -0700
In-Reply-To: <20250919004512.1359828-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919004512.1359828-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919004512.1359828-2-seanjc@google.com>
Subject: [PATCH v3 1/5] KVM: selftests: Add timing_info bit support in vmx_pmu_caps_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Yi Lai <yi1.lai@intel.com>, 
	dongsheng <dongsheng.x.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

A new bit PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
to indicated if PEBS supports to record timing information in a new
"Retried Latency" field.

Since KVM requires user can only set host consistent PEBS capabilities,
otherwise the PERF_CAPABILITIES setting would fail, add pebs_timing_info
into the "immutable_caps" to block host inconsistent PEBS configuration
and cause errors.

Opportunistically drop the anythread_deprecated bit.  It isn't and likely
never was a PERF_CAPABILITIES flag, the test's definition snuck in when
the union was copy+pasted from the kernel's definition.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
[sean: call out anythread_deprecated change]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
index a1f5ff45d518..f8deea220156 100644
--- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
@@ -29,7 +29,7 @@ static union perf_capabilities {
 		u64 pebs_baseline:1;
 		u64	perf_metrics:1;
 		u64	pebs_output_pt_available:1;
-		u64	anythread_deprecated:1;
+		u64	pebs_timing_info:1;
 	};
 	u64	capabilities;
 } host_cap;
@@ -44,6 +44,7 @@ static const union perf_capabilities immutable_caps = {
 	.pebs_arch_reg = 1,
 	.pebs_format = -1,
 	.pebs_baseline = 1,
+	.pebs_timing_info = 1,
 };
 
 static const union perf_capabilities format_caps = {
-- 
2.51.0.470.ga7dc726c21-goog


