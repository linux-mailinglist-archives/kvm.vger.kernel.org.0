Return-Path: <kvm+bounces-30177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE91C9B7AEB
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C0321C2195A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 12:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F80619CCEA;
	Thu, 31 Oct 2024 12:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jXwB1F7L"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A78319D07A
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730378406; cv=none; b=D9b3TNRczRSac94b5BKaktZLiiqhI7K//VQTkNwRaMNLlMkwR9DmN5CSJeuAbNZ3FD63T1ZmUjOM5N37p7IN+eTnlbVe5fy/IBHMoa7U8KBDK1GR/pyYGsT0YNquhSUJfj4+ssd19hH7U+Qa7PaGMD9Lwy1iRMbbLkkmnLgHMBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730378406; c=relaxed/simple;
	bh=FgtjDzr/BRVc3ideDpqueht9zXX0aXCMvRGfoeQxN80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na4tGlpVSdI7BeumN4tsJCtbMv5MMs9sk/qKSHyNBLV7+/vPMllCxiE22CTl+0U343kRDLMoR4fjAva8X7Nc37SfjRTYX97in8vyV5aE8g+3dKwwR42SYNKRBWk8by+aQ/GCjdRr2Hp5kXDhEXg7s62UXW9d8olA79csYdFbrs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jXwB1F7L; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730378400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sdpDxlDP7qYJBIbsqSGSz+F9K7iMcqf9pogsQkjPxU=;
	b=jXwB1F7LrXVcvAi9BoxHOFzDAZ5xNofxLot+WMeczadZnh7CZROGqQsjqqn6q+J8lam8y1
	QLhHPvO0OjN7f3uzGEAdpYTaHHiRd9dFGSMfhw6Vqk7fuhXckB7KCHdgOwn366rdG6EDvH
	L28O8jJgjXD9IWlkHCmbwi0zCGud+xg=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/3] lib/on-cpus: Add barrier after func call
Date: Thu, 31 Oct 2024 13:39:51 +0100
Message-ID: <20241031123948.320652-7-andrew.jones@linux.dev>
In-Reply-To: <20241031123948.320652-5-andrew.jones@linux.dev>
References: <20241031123948.320652-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It's reasonable for users of on_cpu() and on_cpumask() to assume
they can read data that 'func' has written when the call completes.
Ensure the caller doesn't observe a completion (target cpus are again
idle) without also being able to observe any writes which were made
by func(). Do so by adding barriers to implement the following

 target-cpu                                   calling-cpu
 ----------                                   -----------
 func() /* store something */                 /* wait for target to be idle */
 smp_wmb();                                   smp_rmb();
 set_cpu_idle(smp_processor_id(), true);      /* load what func() stored */

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/on-cpus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/on-cpus.c b/lib/on-cpus.c
index f6072117fa1b..356f284be61b 100644
--- a/lib/on-cpus.c
+++ b/lib/on-cpus.c
@@ -79,6 +79,7 @@ void do_idle(void)
 			smp_wait_for_event();
 		smp_rmb();
 		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
+		smp_wmb(); /* pairs with the smp_rmb() in on_cpu() and on_cpumask() */
 	}
 }
 
@@ -145,12 +146,14 @@ void on_cpumask(const cpumask_t *mask, void (*func)(void *data), void *data)
 		smp_wait_for_event();
 	for_each_cpu(cpu, mask)
 		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
+	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
 }
 
 void on_cpu(int cpu, void (*func)(void *data), void *data)
 {
 	on_cpu_async(cpu, func, data);
 	cpu_wait(cpu);
+	smp_rmb(); /* pairs with the smp_wmb() in do_idle() */
 }
 
 void on_cpus(void (*func)(void *data), void *data)
-- 
2.47.0


