Return-Path: <kvm+bounces-68598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F6FD3C3AC
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:35:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CF57166984E
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131323D1CBA;
	Tue, 20 Jan 2026 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VV+mjZl/"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB703C1FD0;
	Tue, 20 Jan 2026 09:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900572; cv=none; b=BCFNgM4ailV9Wx3wvciZsw2qtiU70jhuVRxo6Z2mX6r5Her7rLua6fTiqGsQOh+mfmoZw1OEWvAcjlCwRBBVWNWUZeqv6nHIKC8So5bu3bMY4G7giJrxsKYFiMtpAwS1+2erBGukmqAatObADzMRTPqAnBUCaHlo1DkWrXL81Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900572; c=relaxed/simple;
	bh=ixi0ifNzeSEQiJ9LZmwbscXKZV1WcE6SXBdPX85b2JM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X8g7EwZbGH/hYPusQwzoiKGHUrigjc/jv80dwTEwiX4ZTGz5Za8aKJQEmE2lkYfOlgGzfFVpTI3Z0rGwBwTldn4PoKN4AaeNYDlq+qNdyc/EB97SNQhAj66J7EXGWyEO3SeenwL+DErvmvPE34SJ++oAE0EU6Ria6cKDNuZN5tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VV+mjZl/; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=R3
	GG1uTsBaw7wJyjOqUBIPzVK+svny+NQUgMCT4+cv4=; b=VV+mjZl/DyW5Tt/gaO
	x3v41d+HStxuIKmqgyxxv8p47EhvPuCVFzuWG2YhImD9K1KlA5JrUGeZRISnLFhz
	+195oMKgLF1Snj+msbYfup0dtJzJ8Os4z3xyvTLbHWKOMDrPO1sqUTJNSAinNsqQ
	zWzMH5AGEZlEc72k+etiKNoA0=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCn5zu4R29pIOfPGw--.26432S2;
	Tue, 20 Jan 2026 17:15:37 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH 0/5] KVM: x86: selftests: Add Hygon CPUs support and fix failures
Date: Tue, 20 Jan 2026 17:14:43 +0800
Message-ID: <20260120091449.526798-1-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn5zu4R29pIOfPGw--.26432S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr1DAF4fJr15Wry3GFykZrb_yoW8ArWxpa
	93Jw4YkFZ7Ja4SkayfJF1kAr1xAFn3CF4UWr1Yyw47ZrW5G3Wxtw4Iga18X3WfCr4vvr15
	Za9rGFnrWw4DJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piBMKLUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwho2H2lvR7q98QAA3G

This series to add support for Hygon CPUs and fix some test failures.

Patch 1 add CPU vendor detection for Hygon and add a global variable
"host_cpu_is_hygon" to identify if the test is running on a Hygon CPU.
It is the prerequisite for the following fixes.

Patch 2 fix x86/fix_hypercall_test test failure by altering the instruction
of hypercall on Hygon CPUs.

Patch 3 fix following test failures by avoiding using the reserved memory
regions on Hygon CPUs.
- access_tracking_perf_test
- demand_paging_test
- dirty_log_perf_test
- dirty_log_test
- kvm_page_table_test
- memslot_modification_stress_test
- pre_fault_memory_test
- x86/dirty_log_page_splitting_test

Patch 4 fix x86/pmu_event_filter_test test failure by allowing the tests
for Hygon CPUs.

Patch 5 fix x86/msrs_test test failure by fixing the expectation while
writing the MSR_TSC_AUX reserved bits without RDPID support.

Zhiquan Li (5):
  KVM: x86: selftests: Add CPU vendor detection for Hygon
  KVM: x86: selftests: Alter the hypercall instruction on Hygon
  KVM: x86: selftests: Avoid failures due to reserved memory address
    regions on Hygon
  KVM: x86: selftests: Allow the PMU event filter test for Hygon
  KVM: x86: selftests: Fix write MSR_TSC_AUX reserved bits test failure
    on Hygon

 .../selftests/kvm/include/x86/processor.h     |  6 +++++
 .../testing/selftests/kvm/lib/x86/processor.c | 12 ++++++---
 .../selftests/kvm/x86/fix_hypercall_test.c    |  2 +-
 tools/testing/selftests/kvm/x86/msrs_test.c   | 26 +++++++++++++++----
 .../selftests/kvm/x86/pmu_event_filter_test.c |  6 ++---
 5 files changed, 39 insertions(+), 13 deletions(-)


base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
-- 
2.43.0


