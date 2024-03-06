Return-Path: <kvm+bounces-11215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BDD87435F
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1037287124
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444041C69A;
	Wed,  6 Mar 2024 23:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rVav1R9m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064341C2A8
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 23:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766120; cv=none; b=J5Pztmo/4dGDJFGWECodAIzd3VwNKq/o3OZ2PqYRhPJ/2SD0dS3fWmNmXFZWkP2F5eVDiumeO59FMLUx4Tz08R7ayDxLDy7yGg4gY+F8S34Qmn04VYqTLgMtkecx7B/4axJJr1ol5e+7jLpnTXWm+7uGRaumy8VQD77V8D7QBy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766120; c=relaxed/simple;
	bh=F6tQGExbalAmMiQxJduK+2k4ekpLe9FlNQn92O+QbFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oOopRJkjbzVmc3YY6uY4Zp/FRMwrlCRY5/SBUu2C8EIyYVlmGCxNdmu57YKLwT1FlFePwX4eavBzQIVBw29tF9jec+hM3PeaYO5/4FAF77VYJwRup3rSQr7fpA4mimWGFKuCucbfIS3VCDlwwWUU/Y9z8pjprpHz92oFx4jwheA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rVav1R9m; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60810219282so4474337b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 15:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709766118; x=1710370918; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P0WeiDnazmfwO4kq9FVwAuu2D/m0SwnnqZMq8DjgSXQ=;
        b=rVav1R9mlKIvnveQREKRJWOdNQloPyYA6Vd7lWiqL539VTD7WQOUJ6EtXiY/tGloWl
         ax2UC5f0QHx+rWEtGk+DOn9F9QMWOr1HLRHlWGfMm8qeToABpNDMsdFK9h0RgpijH+pM
         RNUl4BwNodi5geNzbBj2qTozXz482V9jd5cKWkSd1NJgTatr991AF1c2OSf+IzS+VAx0
         vkclwxZ6uo9iSPyEF9LONz5EPLjGnuLs8Xt2UhCuOTI2bHa8PkorIyQ6C16hHn8RymtG
         41fVyWJMsYP95KCbcPMKkls/7pCkvZq0xJmzVopFKdSDBZ6ncSFsPF72AbDavC+ESw3U
         awKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709766118; x=1710370918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P0WeiDnazmfwO4kq9FVwAuu2D/m0SwnnqZMq8DjgSXQ=;
        b=L5ENTFKh1AuS3G/sgQhT1TFVvnkvGHB6HZmS8XTektzOiyYel8qfUvPWISgvF0gNZc
         JFkaS6nx7GxNRc5oeXCUEr43+8g9QKzjTY8PyR+v7hKTChJyH4i8ZER7wUwBs7a54kEK
         u7I5JpjrG08qeVdQcaLW8jDbfFDCHNNxBmXyXktUA0zQuUbb9wOEHBrmfbQoqEQOxVSD
         I4We+UG2KyZvISIGK6OLiWbdUZegdUoFypZnMymxAsimGgXFtQVeLIV1sdGwGvxTJJnQ
         RepsNzCUpT77e3ABPcI+lAhK4G9nlMMNrH+e57MmRpz9kFvAMw6l84N9DRmBxlprt1Li
         RlhQ==
X-Gm-Message-State: AOJu0Yxif0Y2f08r9BIRaTEtThdWYLuGD3/pKsEITZ07NBYy9NUA2gwx
	QoSOP7bKXBLAIIP2KkjfxcdYVptijVpuDLZ1G1xOrKAlafsHaJDVPh5TY6g3gYX2RFd/nT1f0sO
	Y2Q==
X-Google-Smtp-Source: AGHT+IF33AScMRehRjloo2/F9B8jM0Ow73insOMNBjyMbqyGTECJjxUq3/7aYDET+V5PXcDi0FEARvuTgRA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:df41:0:b0:609:ebe5:7d2a with SMTP id
 i62-20020a0ddf41000000b00609ebe57d2amr140395ywe.7.1709766117996; Wed, 06 Mar
 2024 15:01:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Mar 2024 15:01:50 -0800
In-Reply-To: <20240306230153.786365-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306230153.786365-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306230153.786365-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/4] x86/pmu: Enable PEBS on fixed counters iff
 baseline PEBS is support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"

Enabling PEBS for fixed counters is only allowed if "Extended PEBS" is
supported, and unfortunately "Extended PEBS" is bundled with a pile of
other PEBS features under the "Baseline" umbrella.  KVM emulates this
correctly and disallows enabling PEBS on fixed counters if the vCPU
doesn't have Baseline PEBS support.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu_pebs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index f7b52b90..050617cd 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -356,13 +356,13 @@ static void check_pebs_counters(u64 pebs_data_cfg)
 	unsigned int idx;
 	u64 bitmask = 0;
 
-	for (idx = 0; idx < pmu.nr_fixed_counters; idx++)
+	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
 		check_one_counter(FIXED, idx, pebs_data_cfg);
 
 	for (idx = 0; idx < max_nr_gp_events; idx++)
 		check_one_counter(GP, idx, pebs_data_cfg);
 
-	for (idx = 0; idx < pmu.nr_fixed_counters; idx++)
+	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
 		bitmask |= BIT_ULL(FIXED_CNT_INDEX + idx);
 	for (idx = 0; idx < max_nr_gp_events; idx += 2)
 		bitmask |= BIT_ULL(idx);
-- 
2.44.0.278.ge034bb2e1d-goog


