Return-Path: <kvm+bounces-38258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB20A36B14
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9A03188CEC8
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF5B8624B;
	Sat, 15 Feb 2025 01:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u3vcNXab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC6D44C94
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583406; cv=none; b=BGT9wHpHHj+VvtR09gAWoWt4mHgM72l5ds0W9VWYWYPm2hH5DnciqlUmQnILPHuHPQQG2+ZNb2Xdl6RF+SE0lKag+7SmnW3OMAiyHc3O5mgur4UI8ff6JDQNr9vJBKP8INsTCJS/J78HOYnMsnwRWzy5f322FmnHKCUm2usorPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583406; c=relaxed/simple;
	bh=JrG1MtpuWiUN76DSpn6MVWBxRepa4hpAC8UCnnWQWZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bHnWRqDswWY9llPO+pXwQfFN/F3XaC2uI+jrYMYCLxypwiRVhDqb1KdkL3ZgYJteF3byQiJGx9OL4d4kfKAGd08SqJ06AeFiNIxIsrce/EYiMyxEwSLXoQIFnTBOE541QliiXtBw6qMt/hk5xavi3GUSqGtwQ8MBl8m4wY8apV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u3vcNXab; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f816a85facso5429426a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583405; x=1740188205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SduRpuFn6rmtzZbzp/tLs7Dqzub3eRID21ZYgVQZ+Zc=;
        b=u3vcNXabHe9u5cJxA4I8SZ3Tm3RWgHQOIWHbftFjHzEu+U2Y+fA0ZmrMt+DwW4x/mI
         gXUWdm+rPTyNHVJJzyMn4KY/uz9kmsKIEM4kU5xGinxP6RcIIqfSRaet3irnecXBg/Fv
         +JxYRV2ck+kJ+C+IMef2BdSg97op1/4NGlkB01B6+TldvMIfFCMTJZF6XNpMvWrBpZ7D
         1Ha71/JxulMndex6XdJIwTrFLVXNMujZ8uE5HvkzveweC+Jztbs3/7cB3ixiMBjqux7s
         MPR2M5LgvHAWSrCpUuxdPESG8x6XCKsRRPREn+63EgL+wsrD0OmqxkW2mxbjxexko/p4
         yJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583405; x=1740188205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SduRpuFn6rmtzZbzp/tLs7Dqzub3eRID21ZYgVQZ+Zc=;
        b=GO17JQF3BdWNZkwYW3TKI399OB0TLYMXgoAR9MsskO87ssvr5Xx/ecQdXPDUz9wmvA
         AienP9x3abWB4ftg8Q7uhNKYIyaz66baU0RT9xoJEE53yV7Y+vFDVMjE1A4OYWqvu0k0
         0EClwbSVDPHoE6yYfUOz8TthDZqXaCC8PCFkkvJMdjkIEaY5o5refjQeGkb05DSxep7q
         pYjQFipkHAg1keIT2StbNztyjWkB9h++DfYbkSvjMvVlJ/JGI9b3W16BsArTMSjGNUj+
         Juog8i9RzimFYCw/zyjEcaTz3qcs+uUB4LFQM2uw86LN6zqOQ/Q+AgDJ17Ww1NZ6wV/I
         uJ6g==
X-Gm-Message-State: AOJu0YwkFADcTf0TfDVFPSYWMdGT60027netuesCUYIjJ5dCqwHrcr8T
	8sql1eqBuPg5B5Onnkvt/K7UwEWNGGC7lVEVOJELQ6Oc7byXtpPw8WynyChNbsVjjVcWoVgNB7D
	iJg==
X-Google-Smtp-Source: AGHT+IGaCWETsnp9pgitue/SsTFcdcfBqJxu2PVOj+toKx+mbtKTGj+IxHy75eiwwcmdBCETyTQgXrZpHNs=
X-Received: from pjbhl14.prod.google.com ([2002:a17:90b:134e:b0:2fc:201d:6026])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3886:b0:2ee:d433:7c50
 with SMTP id 98e67ed59e1d1-2fc4104509fmr1386777a91.23.1739583404723; Fri, 14
 Feb 2025 17:36:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:21 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 04/18] x86: pmu: Align fields in
 pmu_counter_t to better pack the struct
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Hoist "idx" up in the pmu_counter_t structure so that the structure is
naturally packed for 64-bit builds.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://lore.kernel.org/r/20240914101728.33148-5-dapeng1.mi@linux.intel.com
[sean: rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 60db8bdf..a0268db8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -21,9 +21,9 @@
 
 typedef struct {
 	uint32_t ctr;
+	uint32_t idx;
 	uint64_t config;
 	uint64_t count;
-	int idx;
 } pmu_counter_t;
 
 struct pmu_event {
-- 
2.48.1.601.g30ceb7b040-goog


