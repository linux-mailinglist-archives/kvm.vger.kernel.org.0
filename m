Return-Path: <kvm+bounces-2817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2C47FE397
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 23:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C6391C20C3D
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5E247A43;
	Wed, 29 Nov 2023 22:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SunDNM5+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC6AF4
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:21 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6cde4342fe9so232967b3a.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701298161; x=1701902961; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jcB+0ufG8RNDzGznsHxIgoB+eIgiTMrBs/Lse4iREj8=;
        b=SunDNM5+HWKgI2Dw6O6zLkHFzNp81SfN6D8k9EE84c+NY1ZS5HjuXZtaPFvZz2lXuw
         wZZuNYc57zBjtx/iht6V13qU4sjzldsOIMBWaFlNAdOZorjGo64oxGaojZETQH4zBT9u
         w6vyWR7Jl6rzdrl/FOTjCn16aYZPvduNZ4pgRfgMzJYjGMZu/Hd5BuBuL8NJWu4msnhK
         jiz2FJpMcZ8+wmzwliDsp52VzW9dHvLz9QekyZwCGJ33DeL31SD36Pygv2MhkUZfPW6a
         kZPtgfW+RD8jkPRQNxNbuHI1hZ+yC28pigQe9r4ra4hSUiSlNlR97wAsMCm/wQ6Z/O3K
         wZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701298161; x=1701902961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jcB+0ufG8RNDzGznsHxIgoB+eIgiTMrBs/Lse4iREj8=;
        b=cYcm2vEKwlTvbBIIXAiuAai+lGVrCIASR0DcrRI6qF4W50hOmB6HpbhOve5nIokLSF
         w2N6r4QEnRTfHM3IdLh17x5PFK+5ekRd/A8Zp7q3ZmC3cuEobL95Bt68ANYHE0YVmhKE
         XeKvlOwAOdXcfS61IADAqQnyvOAubLRa7/RPR9rgmZ+vkXTRvIja/DoQQ4qKrVlg3T4L
         7bVyL1R9ZoojQAlroH5aVzKSjaF3c3W69ZMXWF3qff8O64Bzh00km0RQQ57W+k1j9nML
         gV+6QDtusHOf0WVt6zcgS/2XBBar/INNm8jpJuvWJxQd7XRAKqyky+tTNy09MdyrLUxp
         A6TQ==
X-Gm-Message-State: AOJu0YzFQmg20d/0rwVAz1dIra+fhKm9OswT1UD8de9Ro2AONeFLLvPq
	t+4ieB0P8Pn7TcelCA4UBlNN+UjZwtM=
X-Google-Smtp-Source: AGHT+IGlptR+ACsn5xm5Y7kirHJtCxe5a03VMwEUdpXfliyZg3YTs1xMsjqpw1vLtzpj7r+7POud+dCpEzA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1389:b0:6cb:95ab:cf8d with SMTP id
 t9-20020a056a00138900b006cb95abcf8dmr5297305pfg.6.1701298161246; Wed, 29 Nov
 2023 14:49:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 29 Nov 2023 14:49:13 -0800
In-Reply-To: <20231129224916.532431-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231129224916.532431-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231129224916.532431-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: selftests: Fix MWAIT error message when guest
 assertion fails
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Print out the test and vector as intended when a guest assert fails an
assertion regarding MONITOR/MWAIT faulting.  Unfortunately, the guest
printf support doesn't detect such issues at compile-time, so the bug
manifests as a confusing error message, e.g. in the most confusing case,
the test complains that it got vector "0" instead of expected vector "0".

Fixes: 0f52e4aaa614 ("KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest asserts")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20231107182159.404770-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 80aa3d8b18f8..853802641e1e 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -27,10 +27,12 @@ do {									\
 									\
 	if (fault_wanted)						\
 		__GUEST_ASSERT((vector) == UD_VECTOR,			\
-			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", vector); \
+			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", \
+			       testcase, vector);			\
 	else								\
 		__GUEST_ASSERT(!(vector),				\
-			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", vector); \
+			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", \
+			       testcase, vector);			\
 } while (0)
 
 static void guest_monitor_wait(int testcase)
-- 
2.43.0.rc1.413.gea7ed67945-goog


