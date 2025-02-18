Return-Path: <kvm+bounces-38479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3D5A3A977
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8D6D3AE3B7
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4232C20E314;
	Tue, 18 Feb 2025 20:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="jsgbUwxU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B1D204698;
	Tue, 18 Feb 2025 20:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910420; cv=none; b=hD1mCjWBaD8nJkQP4DyGZcf1Fuu9SlxUuvml9ciNsQ+vZHbuaArnN0PH3uAotgbJvjcQej7EJ3X/tpKhzm0YN4XqAmP6FOjVvToBNMVO0D4YzqhNHfMsxyiuCgBw5zBPavhJjpWxbUO19OvwyrGLM1Ul3lsQwThgb6xZ3avaV8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910420; c=relaxed/simple;
	bh=hZyWHf5U/cV8E8wKC4zSmWBUXR4xSLjgQjigQQLsgR4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZNQw7dL5wPYZzoh/sakIRjBx+NOMqVJR75FLdIjSAJBWZlU2bIQvyg0ovBEw2vQZtvP4OprcsBIFJOzi9E/c7qYo2A/lShjrAfGLbCINL6uibiFhr/8K0OYKEF+D0QFti7ob6rjWAU6o09l18x4AxEr0G4QmFpbjlwxcVzR0Be8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=jsgbUwxU; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1739910419; x=1771446419;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pd0nb1SQobzaPTk5SBtY7Fy71XHeU2kUV27RPzB/PjQ=;
  b=jsgbUwxUYwQI9G5Ot00KOnzIwtGyQQUHk0P+bjcOgtkpqsDmU1SrEWK+
   DHFiGLeEj//C2WPXw/cNFGSjMAa/382jcwNVbWANxD5uUtJmpf8kWyztq
   subopaOyf1JIW9B61waONz88WDgFhTx9Fia9wnlPSjO2fumlRUsj3/BGu
   k=;
X-IronPort-AV: E=Sophos;i="6.13,296,1732579200"; 
   d="scan'208";a="719883525"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 20:26:56 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:64401]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.107:2525] with esmtp (Farcaster)
 id 27c2d949-025e-452a-bd6c-e61c027dcf90; Tue, 18 Feb 2025 20:26:55 +0000 (UTC)
X-Farcaster-Flow-ID: 27c2d949-025e-452a-bd6c-e61c027dcf90
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 18 Feb 2025 20:26:54 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.227) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 18 Feb 2025 20:26:49 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <sieberf@amazon.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 0/3] kvm,sched: Add gtime halted
Date: Tue, 18 Feb 2025 22:26:00 +0200
Message-ID: <20250218202618.567363-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With guest hlt, pause and mwait pass through, the hypervisor loses
visibility on real guest cpu activity. From the point of view of the
host, such vcpus are always 100% active even when the guest is
completely halted.

Typically hlt, pause and mwait pass through is only implemented on
non-timeshared pcpus. However, there are cases where this assumption
cannot be strictly met as some occasional housekeeping work needs to be
scheduled on such cpus while we generally want to preserve the pass
through performance gains. This applies for system which don't have
dedicated cpus for housekeeping purposes.

In such cases, the lack of visibility of the hypervisor is problematic
from a load balancing point of view. In the absence of a better signal,
it will preemt vcpus at random. For example it could decide to interrupt
a vcpu doing critical idle poll work while another vcpu sits idle.

Another motivation for gaining visibility into real guest cpu activity
is to enable the hypervisor to vend metrics about it for external
consumption.

In this RFC we introduce the concept of guest halted time to address
these concerns. Guest halted time (gtime_halted) accounts for cycles
spent in guest mode while the cpu is halted. gtime_halted relies on
measuring the mperf msr register (x86) around VM enter/exits to compute
the number of unhalted cycles; halted cycles are then derived from the
tsc difference minus the mperf difference.

gtime_halted is exposed to proc/<pid>/stat as a new entry, which enables
users to monitor real guest activity.

gtime_halted is also plumbed to the scheduler infrastructure to discount
halted cycles from fair load accounting. This enlightens the load
balancer to real guest activity for better task placement.

This initial RFC has a few limitations and open questions:
* only the x86 infrastructure is supported as it relies on architecture
  dependent registers. Future development will extend this to ARM.
* we assume that mperf accumulates as the same rate as tsc. While I am
  not certain whether this assumption is ever violated, the spec doesn't
  seem to offer this guarantee [1] so we may want to calibrate mperf.
* the sched enlightenment logic relies on periodic gtime_halted updates.
  As such, it is incompatible with nohz full because this could result
  in long periods of no update followed by a massive halted time update
  which doesn't play well with the existing PELT integration. It is
  possible to address this limitation with generalized, more complex
  accounting.

[1]
https://cdrdv2.intel.com/v1/dl/getContent/671427
"The TSC, IA32_MPERF, and IA32_FIXED_CTR2 operate at close to the
maximum non-turbo frequency, which is equal to the product of scalable
bus frequency and maximum non-turbo ratio."

Fernand Sieber (3):
  fs/proc: Add gtime halted to proc/<pid>/stat
  kvm/x86: Add support for gtime halted
  sched,x86: Make the scheduler guest unhalted aware

 Documentation/filesystems/proc.rst |  1 +
 arch/x86/include/asm/tsc.h         |  1 +
 arch/x86/kernel/tsc.c              | 13 +++++++++
 arch/x86/kvm/x86.c                 | 30 +++++++++++++++++++++
 fs/proc/array.c                    |  7 ++++-
 include/linux/sched.h              |  5 ++++
 include/linux/sched/signal.h       |  1 +
 kernel/exit.c                      |  1 +
 kernel/fork.c                      |  2 +-
 kernel/sched/core.c                |  1 +
 kernel/sched/fair.c                | 25 ++++++++++++++++++
 kernel/sched/pelt.c                | 42 +++++++++++++++++++++++++-----
 kernel/sched/sched.h               |  2 ++
 13 files changed, 122 insertions(+), 9 deletions(-)

=== TESTING ===

For testing I use a host running a VM via qEMU and I simulate host
interference via instances of stress.

The VM uses 16 vCPUs, which are pinned to pCPUs 0-15. Each vCPU is
pinned to a dedicated pCPU which follows the 'mostly non-timeshared CPU'
model.

We use the -overcommit cpu-pm=on qEMU flag to enable hlt, mwait and
pause pass through.

On the host, alongside qEMU, there are 8 stressors pinned to the same
CPUs (taskset -c 0-15 stress --cpu 8).

The VM then runs rtla on 8 cores to measure host interference. With the
enlightenment in the patch we expect the load balancer to move the
stressors to the remaining 8 idle cores and to mostly eliminate
interference.

With enlightenment:
rtla hwnoise -c 0-7 -P f:50 -p 27000 -r 26000 -d 2m -T 1000 -q --warm-up 60

Hardware-related Noise
duration:   0 00:02:00 | time is in us
CPU Period       Runtime        Noise  % CPU Aval   Max Noise   Max Single          HW          NMI
  0 #4443      115518000            0   100.00000           0            0           0            0
  1 #4442      115512416       144178    99.87518        4006         4006          37            0
  2 #4443      115518000            0   100.00000           0            0           0            0
  3 #4443      115518000            0   100.00000           0            0           0            0
  4 #4443      115518000            0   100.00000           0            0           0            0
  5 #4443      115518000            0   100.00000           0            0           0            0
  6 #4444      115547479        11018    99.99046        4006         4006           3            0
  7 #4444      115544000        12015    99.98960        4005         4005           3            0

Baseline without patches:
rtla hwnoise -c 0-7 -P f:50 -p 27000 -r 26000 -d 2m -T 1000 -q --warm-up 60

Hardware-related Noise
duration:   0 00:02:00 | time is in us
CPU Period       Runtime        Noise  % CPU Aval   Max Noise   Max Single          HW          NMI
  0 #4171      112394904     36139505    67.84595       29015        13006        4533            0
  1 #4153      111960227     38277963    65.81110       29015        13006        4748            0
  2 #3882      108016483     73845612    31.63486       29017        16005        8628            0
  3 #3881      108088929     73946692    31.58717       30017        14006        8636            0
  4 #4177      112380299     36646487    67.39064       28018        14007        4551            0
  5 #4157      112059732     37863899    66.21096       28017        13005        4689            0
  6 #4166      112312643     37458217    66.64826       29016        14005        4653            0
  7 #4157      112034934     36922368    67.04387       29015        14006        4609            0

--
2.43.0



Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


