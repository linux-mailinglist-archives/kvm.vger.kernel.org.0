Return-Path: <kvm+bounces-68594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A8515D3C3E3
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B6796667B89
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06EB3C1FE2;
	Tue, 20 Jan 2026 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="i1v16RnV"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A39B3B52F7;
	Tue, 20 Jan 2026 09:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900568; cv=none; b=Kipi7lDVX6UtCf8kV6SIBYt7RNoPRK7AhBMBLZoF0I+tJXDvhTJeF69pyAYAJz1zGqvpXi2BifrN/WXnmA0cYOQd7s/3IgKELhC0yr5Z//fJr/uIeFKE4bbS+2/a1ud02LSnRnc3HwCJZzjdDco9n+4/HW1ix4awcdCeP6PWPzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900568; c=relaxed/simple;
	bh=3JMOXPfQ61LnCVtpjwhEPTm3T/iAtHe/zWJvFIpZ4z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVHivz5GqemRPGd4NqYkxn4Nhk9A4gLGqmBUQXOfDTET8qBEpQ7d0Q8ysfXNrEZwo/u6TJULxaa61JaSX/cQnn5yy7qf3Nr1KqDhpjjz9xa/WYYhVLofvQN4m3U3mY4MH9D1+cKcPVlzXhTWT8HOcQ0Nl0CiPUCkceDmQe2/3Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=i1v16RnV; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Jx
	mNh8O5HvOhLdLZe6X+x7Ug4eY7zYzmJLmKHOIq20c=; b=i1v16RnVypOocKQ1yO
	EYnp0vSWDs9JyWkO7s4wWfWa9lWsd3hwJuw0aCArymHgsCq0iGMyJ60X90VbKZHd
	5bGUwfQTN8YGlFERk9UZn3ci1+Ip10ve/xHih0qLVcRuImsV+PG+r4DsqJiUFV/C
	rlL5WrEo9nFvoOvQSbBPhREO8=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCn5zu4R29pIOfPGw--.26432S5;
	Tue, 20 Jan 2026 17:15:43 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH 3/5] KVM: x86: selftests: Avoid failures due to reserved memory address regions on Hygon
Date: Tue, 20 Jan 2026 17:14:46 +0800
Message-ID: <20260120091449.526798-4-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120091449.526798-1-zhiquan_li@163.com>
References: <20260120091449.526798-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn5zu4R29pIOfPGw--.26432S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFykCr1Utr4fXr18Jr4Dtwb_yoW8ZF1Upa
	4fCw45WF48GF1ay3yxXws7ZFyvkFn7CF4xKryjy343u3W5WF13Xr4Sk3WYvrW3CrWrZw13
	Aa4fJF4DZw4jqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRm9a9UUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwh83IGlvR7++ewAA3x

There are similar reserved memory address regions for Hygon
architecture, mapping memory into these regions and accesses to them
results in a #PF.

Hygon CSV also makes the "physical address space width reduction", the
reduced physical address bits are reported by bits 11:6 of
CPUID[0x8000001f].EBX as well, so the logic is totally applicable
for Hygon processors.

Following test failures are fixed by this change:
- access_tracking_perf_test
- demand_paging_test
- dirty_log_perf_test
- dirty_log_test
- kvm_page_table_test
- memslot_modification_stress_test
- pre_fault_memory_test
- x86/dirty_log_page_splitting_test

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 64f9ecd2387d..252b04c8e944 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1270,8 +1270,8 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 
 	max_gfn = (1ULL << (guest_maxphyaddr - vm->page_shift)) - 1;
 
-	/* Avoid reserved HyperTransport region on AMD processors.  */
-	if (!host_cpu_is_amd)
+	/* Avoid reserved HyperTransport region on AMD or Hygon processors. */
+	if (!host_cpu_is_amd && !host_cpu_is_hygon)
 		return max_gfn;
 
 	/* On parts with <40 physical address bits, the area is fully hidden */
@@ -1285,7 +1285,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 
 	/*
 	 * Otherwise it's at the top of the physical address space, possibly
-	 * reduced due to SME by bits 11:6 of CPUID[0x8000001f].EBX.  Use
+	 * reduced due to SME or CSV by bits 11:6 of CPUID[0x8000001f].EBX.  Use
 	 * the old conservative value if MAXPHYADDR is not enumerated.
 	 */
 	if (!this_cpu_has_p(X86_PROPERTY_MAX_PHY_ADDR))
-- 
2.43.0


