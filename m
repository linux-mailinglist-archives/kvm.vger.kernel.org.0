Return-Path: <kvm+bounces-63994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D31AC769E3
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4D7B834EBAB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4992F8BE8;
	Thu, 20 Nov 2025 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ai7n+9en"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5F626FDBF
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681520; cv=none; b=nJM6u7JMeeDpcP5oKnK6m0W9Ae+HH1FvpPXEobxiAsBQbk6+N9zZ7bSTwz/7TX8wubvRRyK3Cdc4+XpZiqT8qFJKtRA4ulmvsYIE1xbXd2Ie2QXcreRzwHorDkNs7hw6siT00HGm2TSHgG912EixIM/WrdoVNN3frYlZrkI213I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681520; c=relaxed/simple;
	bh=XMqnfqUj5kPi3dvGhEcouIf5OYL3gk+Ol0NGGJc9EpE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Orb3WS5E24pa1mOoMdogFRmD60T3r98iTSR9yJNoej+34O6s5iEkEjHuW0Ruwc/2b3YUGU9/4dguSjZG2Idl0csZ3wL7pdttjSq4m/nyoqov3V1MnMrQ9OQaRg1FJmc/x1XhdClCX3qK9kX4yGmNxYzqDUWfBTj4tEnr/wqnZVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ai7n+9en; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a26485fc5dso1624844b3a.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681518; x=1764286318; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bjwZkpTb6o8I4UE7FPG4vAI5gptUSAEN1+RC3O6/5UY=;
        b=Ai7n+9enj9WwR/TqyuJxPzi6SHr/2er1HC6YDAMZV4EKr/O15NaH7CfCp3XOZKMSli
         +0Ug/vZ9iPZ2DoelujtlHU/Ge5vtKu+phfoGUhAcxywvkBuOn8FO0g6PuKduO54HwLZB
         yDf0tsuPf7Fthyii6Hix9nyH+SgCF2EdYv0SGtMokA6BGUjRDmn6OjAKpQqxQrXAglur
         XQFXTF/a0aI3YXlYWP0JIW9vsx8KuZ7qlELKAg8baObcb2Yo4TkepFoiecD0HZ2F1suD
         CVBRGUo6mfVLMrXrxw/nRYMuDNZG6M1mrWwkc+GluCcgrS5uXrrAmqpThF8XEk7lsiHS
         /dXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681518; x=1764286318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bjwZkpTb6o8I4UE7FPG4vAI5gptUSAEN1+RC3O6/5UY=;
        b=ln/H9teFGHuuDckzzk07mFQHjZthH5zmytKdPB3/UyGvrwR8StMh4Re9zBipYbdyRN
         OAjlBJUosE0fZl9owckKYrbAKGdqIByNNSgq/PElEgIxDh6PYvzc7wFm9T8ae7+1y+vP
         Zhcs0bbbzIr8IZ2IxVQam96FP+y48/j0+et8xc9CrdUXTy4/XM6T5oHIAOcOOvGdDJrd
         xMxTwUsavoVIVuQPUK1AhRJyTc+J7GNCeOFy7nsfytxiqbgi3xTnp67zPrwXzXh/X/eW
         UsPaX4sOy3fQTCRQA4uS8mg1wwXJPos5xNj29q9cCpRscoMFchX9uWzRBCD0RXmIxUHd
         iJKA==
X-Gm-Message-State: AOJu0Yz0vtHWJjfTye2wM0XUc7qv5ST1uhKKzUhBJe3kyBIAhuwIa5Ul
	IlinwUZSeOAsGJji3kQBMdmB9O14ro1K9hK0u2B7k5Ib/wMkSvJf47ijAb6dePYEuyQ380xhiC5
	ugfv9SQ==
X-Google-Smtp-Source: AGHT+IHOCjTY3TLWVK6ds6VoiBnAFrJ8FuGPQL7plYN42ey/qT5F7s9d8uH7cbS7a7k3t0t53sqRG70bTvg=
X-Received: from pfki30.prod.google.com ([2002:a05:6a00:5e:b0:781:1533:32ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a9:b0:7a2:705c:5037
 with SMTP id d2e1a72fcca58-7c58c89cbf5mr20324b3a.11.1763681517836; Thu, 20
 Nov 2025 15:31:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:44 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 3/8] x86/pmu: Fix incorrect masking of fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: dongsheng <dongsheng.x.zhang@intel.com>

The current implementation mistakenly limits the width of fixed counters
to the width of GP counters.  Correct the logic to ensure fixed counters
are properly masked according to their own width.

Opportunistically refine the GP counter bitwidth processing code.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
[sean: keep measure_for_overflow() for fixed counter (see commit 7ec3b67a)]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index bd16211d..96b76d04 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -547,19 +547,19 @@ static void check_counter_overflow(void)
 		uint64_t status;
 		int idx;
 
-		cnt.count = overflow_preset;
-		if (pmu_use_full_writes())
-			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
-
 		if (i == pmu.nr_gp_counters) {
 			if (!pmu.is_intel)
 				break;
 
 			cnt.ctr = fixed_events[0].unit_sel;
 			cnt.count = measure_for_overflow(&cnt);
-			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
+			cnt.count &= (1ull << pmu.fixed_counter_width) - 1;
 		} else {
 			cnt.ctr = MSR_GP_COUNTERx(i);
+
+			cnt.count = overflow_preset;
+			if (pmu_use_full_writes())
+				cnt.count &= (1ull << pmu.gp_counter_width) - 1;
 		}
 
 		if (i % 2)
-- 
2.52.0.rc2.455.g230fcf2819-goog


