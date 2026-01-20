Return-Path: <kvm+bounces-68593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6A4D3C34B
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8C52950040D
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EABF13C198B;
	Tue, 20 Jan 2026 09:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Uc9OglCo"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A92500965;
	Tue, 20 Jan 2026 09:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900568; cv=none; b=UAIwsE71pkYhrgmes753dO8a3Lgchlw2O2VCxcYtECxld72ydwsnhAEOSxzfR5xJtt3gkGazg5Qkdz9B8AFvC+09zP0sBUAPUnt5Sr7gCvFUAUK4RE83+ijowNAz6f6GkLwWjlm2S1O8DfBpW80Ol4jj8teD2cFxYzN4bMrWPIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900568; c=relaxed/simple;
	bh=887RL4BDFs3BO7HY/4FBnCKpsH5a9PRYlIJWBKHjmMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlgPytGM45D+GiyM+eZfXjzoNaMWUBtgGgdFE1VEra9fg7o411Obrw5+8E9MU0P1vdOmmmdSfPtuEa8xhed0ydHTwrsHJ4UvnXG91x3x3wzNoWZTzbgbvXe0+5hKwRx0UyMEcWnooTEDAf6uptc8uSMTnsZcqRGYQ+obaZT1NAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Uc9OglCo; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=sc
	dheWsKkBb8qVp39GFAKOTPxt9U9/o1zR2spPZolHI=; b=Uc9OglCovbhNGTmh7c
	Q6bYpUfP20gdG9/Kqrd7l/aOlzkkjSxvEFuKN43+43a0PEYWFW5MZCUdrntBac0n
	yfcFAiZBuQAMPmBlGAlKvhQThY8/zo0nfO4iK63ciGMzznBqPls0TTzwQNeLPQ1S
	V6I2xhdtQxRKFUOXsYDRQ+WdQ=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCn5zu4R29pIOfPGw--.26432S6;
	Tue, 20 Jan 2026 17:15:43 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH 4/5] KVM: x86: selftests: Allow the PMU event filter test for Hygon
Date: Tue, 20 Jan 2026 17:14:47 +0800
Message-ID: <20260120091449.526798-5-zhiquan_li@163.com>
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
X-CM-TRANSID:_____wCn5zu4R29pIOfPGw--.26432S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr4xtF4kWFyDJF4DCw1xZrb_yoW8CF13pF
	yruw1avF48KFnIk3WxG34kWr4fAw1kWF4kJ3s0gry8Zr1UJw1Iqr4jka43ta1YkFWFqw1Y
	yay7tFy5C34UKaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pMsjj9UUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbC6R83IGlvR7-EQgAA3Z

At present, the PMU event filter test is only available for Intel and
AMD architecture conditionally, but it is applicable for Hygon
architecture as well.

Since all known Hygon processors can re-use the test cases, so it isn't
necessary to create a wrapper like other architectures, using the
"host_cpu_is_hygon" variable directly.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/x86/pmu_event_filter_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index 1c5b7611db24..e6badd9a2a2a 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -842,14 +842,14 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
-	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
+	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu() || host_cpu_is_hygon);
 	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	TEST_REQUIRE(sanity_check_pmu(vcpu));
 
-	if (use_amd_pmu())
+	if (use_amd_pmu() || host_cpu_is_hygon)
 		test_amd_deny_list(vcpu);
 
 	test_without_filter(vcpu);
@@ -862,7 +862,7 @@ int main(int argc, char *argv[])
 	    supports_event_mem_inst_retired() &&
 	    kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS) >= 3)
 		vcpu2 = vm_vcpu_add(vm, 2, intel_masked_events_guest_code);
-	else if (use_amd_pmu())
+	else if (use_amd_pmu() || host_cpu_is_hygon)
 		vcpu2 = vm_vcpu_add(vm, 2, amd_masked_events_guest_code);
 
 	if (vcpu2)
-- 
2.43.0


