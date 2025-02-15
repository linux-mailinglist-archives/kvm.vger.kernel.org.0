Return-Path: <kvm+bounces-38257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F890A36B13
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D67187A4750
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF97115198B;
	Sat, 15 Feb 2025 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="akPHG9nW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C625614A62A
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583405; cv=none; b=s1AU48/r+MfdrgJ/60epoK3Azd09heCNsg49jdSjQvW9GdxDVKLUNS7cxicddFv8gNYvhmQuBXdR094f++ZdJL7TsEVma/8Xyj0ANb/MzJklnVASE25SHVEMnIZAD0K1rRcTp564XnsV1IbnzK40OFOBGo8NZokphp8BhQAKDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583405; c=relaxed/simple;
	bh=O+KJBw6muUOB+UFyB4iU3b1Vb5wyvNxxlIoG+7p73KY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kwS6W+Rm6FXhWx1CKWcdlPa7M8kpwljLkuBP5Tl7UoQT3EOXVsYjX/WNWNJw9N9u76YhBU2/4MPc1kQX0gKyo1+2KGL/1RRQBds3n+XD0m+fc6I8Od/p8cmelVkStWfuMxE6nl6pnuFqTM1m8fJd0Ev7pCgohNlN5hv/CJIgcJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=akPHG9nW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so5492926a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583403; x=1740188203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a/YkqDIvA8UUBOI80gmKgHxGuQdInCYRvbuq3O5pFv4=;
        b=akPHG9nWvzF/8nw0jxBjU9goPb7ZqlrjIPHB5mdA3IjQn4YJa8YjxzBSx1NP8WkYrC
         yrPta94nHrgBu/BCl4/G6DgmhvgZTp7FIpXzQAKQOTEmsfG6bnjmG8XzaVKOa8jNiPdW
         w2UaEeEgg1EQt85IUDd3iE0FWEnaHSzqCotJcsFrgLJqWnpy1PiKYbwV0rjchrwVxn6v
         M9EP8xBiA1jn1bi1Q415YpSetThIR/KRSlGXThDdVgZZ+ukQ0F9hKn9ezmXIKal2u/82
         Ciu5pkGXXDIdTPF4us9/qonKxWHkYCAKyQ80OKQb7CeyjnrFGpCyvs/DotoIxHwkRfIO
         R/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583403; x=1740188203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/YkqDIvA8UUBOI80gmKgHxGuQdInCYRvbuq3O5pFv4=;
        b=D/Vp4pC+HixCnl6BTH70H7cyTaU6+iOEf/GwrumFHUA2J09OVQx5V5yph7BunoKcdr
         wmGM/kE4q83tF+DOZ/4ZHbkBCXBoOu0wUww/2j2f6lOZLnLsXqifmbMPodDI5QPv1lPw
         qIgaL+hfWhWL+eknPvwGEGQbaSqTRZ2r2m8j76gs3I0sWw8xJe644zvfVjUyinVjF0YU
         RwOD7JkvtJjuq/CaYpQKL3Qsl+x4ThWJg7y4woIxVa3VLTFUTwnvo1780ilREgztPvVr
         6jGQHe0aZ/03vYat5s8OgsP08If5f6cu6J8L0YMeBdWsbhCBuDDhiF8Tk9z5DdmequhD
         nyww==
X-Gm-Message-State: AOJu0YwBo5IUX+Kv1Kn9Cy8d8t+WX54ITMUqM1AbLLiro/0TusS3a+0K
	lwPgH4hUwO1gniXmyG9pWlJdxyVg/N/ijqgEQzoTosuUZCTcFJYLMPztG9sx8gOqUhF0L96yG22
	gZQ==
X-Google-Smtp-Source: AGHT+IEyT19Rx80mjcUyfkHqK4JsLb/v8Nu18r7S8cRcrjtv4kta0XbniJh6zU6zHg9aC106Smqpg9m8eS0=
X-Received: from pjtd10.prod.google.com ([2002:a17:90b:4a:b0:2fa:210c:d068])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f46:b0:2fa:f8d:65e7
 with SMTP id 98e67ed59e1d1-2fc40d1318cmr1953494a91.2.1739583403045; Fri, 14
 Feb 2025 17:36:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:20 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 03/18] x86: pmu: Refine fixed_events[] names
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

In SDM the fixed counter is numbered from 0 but currently the
fixed_events names are numbered from 1. It would cause confusion for
users. So Change the fixed_events[] names to number from 0 as well and
keep identical with SDM.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 865dbe67..60db8bdf 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -45,9 +45,9 @@ struct pmu_event {
 	{"branches", 0x00c2, 1*N, 1.1*N},
 	{"branch misses", 0x00c3, 0, 0.1*N},
 }, fixed_events[] = {
-	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
-	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
-	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
+	{"fixed 0", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
+	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
+	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
 char *buf;
-- 
2.48.1.601.g30ceb7b040-goog


