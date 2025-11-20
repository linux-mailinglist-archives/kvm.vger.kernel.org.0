Return-Path: <kvm+bounces-63997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 51715C769EF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 65F4A34DC2D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0F230AAC7;
	Thu, 20 Nov 2025 23:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1lZEVoLB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40A019E97F
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681525; cv=none; b=klb4zyFQK/wu46ub4aL66AXXPwx1K7F6/6jrZ4lwm2RRONYi4/pyFjmJauEGeeB+8ewnHICL0HEEziR3WHmASvmUYeo5azPYqkBCCydUvNN/+aejDZs3VLu1GksugGIjBoK2+T6Wh1p6pYsgwMUpNeFwu9qevgvjVKvmckcLbG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681525; c=relaxed/simple;
	bh=BRsQjm4hh4ulPuJztPV3HPybjtlna+MIAFMgfFG1CHo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O8EUaz1h8ZVw4/hRkvckxiuNTAy3lLm5zGGwHLkCOGTj1TiWJrW2Mu3Vkw0bJeswj1KScT0civknsyY3ozg9Pw89YeAfFJ0drxa0TVvvaPjNrY+yGPBAcAPBAPG2cJ+lAlejN9skSdO13VAcSTYBtjVBH8igqQjO2+5L2gr/HwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1lZEVoLB; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a998ab7f87so2802642b3a.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681523; x=1764286323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sIMGcnGTBDr0sJ5H5XN7Z6UAY5iTVTlfjKHZCjhzQsA=;
        b=1lZEVoLB4kw5WLByZenzmm2uD9buANOq3zyXxuIdLArclOzm5ljcSzumV5PlWyH9F4
         Wz8U6s3cFql3iqQTPPf38Qp/91P8gN9iSQTs4ZU9TIyIxejYN0JOGFSNKTPdhYbQpSH4
         k91nd5+oYhKghBYXrvPjouOR4Y9ytKLSnsooaeOmf4oaaTEbfRxTxadPdZRO8oWOEbnv
         cpLymXKnhstyH9tU63flB0ewvDuzhefutPsKwOIvtVswNIrai5Ft0WgNL7M7IHymQQjz
         KEujGvZJJmWkIXVYQ7F5Aq281OnRBWq9LZ8VdogacxXU7iXL9UItt4LxG6LiT3xx6Czn
         gTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681523; x=1764286323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sIMGcnGTBDr0sJ5H5XN7Z6UAY5iTVTlfjKHZCjhzQsA=;
        b=j9NA6e3yaRaa4+BaN1ebMOZIYY37vaL88zlqem0et12pZDAfYx6VV0TFzEryfB/uwI
         e1c3QiVhjWlX7zNwGManM1X/W96ygBi6TEZjrXrzg4juDeU7qRqaJC8FRzeQtrYO++6a
         qUEb2Xj8KqtWQmjtUKHM3YIwm6ljd6jUVA1thur6zH6n1an7UpU49eoon+qdv2JW5DC0
         zt3sWo2W+Z79EwsJwmcV7b485czsgpWQkupvhNQp0bxxw2q2mBVwqQMqTuZbuxTRDNaM
         ZQdQDcm3qBT1mANTk9ZpYMCp9eAobNSa9rVRt5x4iVr0znsBmhmaE1SENGOCna39S3PN
         pfOA==
X-Gm-Message-State: AOJu0Yxp7eETFaFFpM+ZpGvmU6r8HiIkQfQ01poub676+Pr4LXEC/mN8
	dy9OBEWgDcFBJvsiNT4ndN7nwgHMoqEjqZdhEc1z8mCM0V1/FL4lw1coXTq65gaIwGRHfs6b1Al
	gwvCVKw==
X-Google-Smtp-Source: AGHT+IFpxDbRCjQGW3OoUt+wbJVAD0klB/sCtAryIHWNnEEV33cHjlpa/SEuXqLsfdhM8q1WXWu3yVlYfpk=
X-Received: from pfbbd38.prod.google.com ([2002:a05:6a00:27a6:b0:7b9:55bc:4970])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9508:b0:7aa:9ca5:da9c
 with SMTP id d2e1a72fcca58-7c58e50cc8dmr552b3a.22.1763681522972; Thu, 20 Nov
 2025 15:32:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:47 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 6/8] x86/pmu: Expand "llc references" upper
 limit for broader compatibility
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: dongsheng <dongsheng.x.zhang@intel.com>

Increase the upper limit of the "llc references" test to accommodate
results observed on additional Intel CPU models, including CWF and
SRF.
These CPUs exhibited higher reference counts that previously caused
the test to fail.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index ccf4ee63..b262ea59 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -116,7 +116,7 @@ struct pmu_event {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
-	{"llc references", 0x4f2e, 1, 2*N},
+	{"llc references", 0x4f2e, 1, 2.5*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 1, 0.1*N},
-- 
2.52.0.rc2.455.g230fcf2819-goog


