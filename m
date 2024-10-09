Return-Path: <kvm+bounces-28158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B742995DE2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 04:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31418282E72
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 02:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3D513B58D;
	Wed,  9 Oct 2024 02:37:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084A11C6BE;
	Wed,  9 Oct 2024 02:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728441442; cv=none; b=CQynom1QeyiZaSG/ybaF6W6yqaGhJkS69XXxX658DjwRgDuAMomMWtBIcKlKp4pN1eFqmU3ApwASLsAvFBTVYS3m+Xyd+v4lIi+53qXc1lbBWCQlsvu8Rfoo5GUwgaoradgajNIPp+V0zmQRPE316fMTxnEgtaOdNkNuKqW86oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728441442; c=relaxed/simple;
	bh=ke+cx/U8Sjvi4bxCZyHFXJr+dGotHmeW77I7vgAAiaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rhyCobiA0cPMVSj5RzsHFDHJhETYIwlornJ20bFpuLBWSmlRxluJWgEm7Wd1ZH3dr7y4tiFQkVlGckQRPgLFAcFtxzVIF4FT7Nva3q8fBDqzExKYGNrXCmrIZv4c6lTKOIhoIcZKKHqG57HyRi1bskZR3wBav5WhDetc+ERvgh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XNcTg56XYz20pj7;
	Wed,  9 Oct 2024 10:36:39 +0800 (CST)
Received: from kwepemh100008.china.huawei.com (unknown [7.202.181.93])
	by mail.maildlp.com (Postfix) with ESMTPS id D7A7E1A016C;
	Wed,  9 Oct 2024 10:37:15 +0800 (CST)
Received: from [10.67.121.90] (10.67.121.90) by kwepemh100008.china.huawei.com
 (7.202.181.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 9 Oct
 2024 10:37:14 +0800
Message-ID: <f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com>
Date: Wed, 9 Oct 2024 10:37:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
To: Ankur Arora <ankur.a.arora@oracle.com>, <linux-pm@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <pbonzini@redhat.com>,
	<wanpengli@tencent.com>, <vkuznets@redhat.com>, <rafael@kernel.org>,
	<daniel.lezcano@linaro.org>, <peterz@infradead.org>, <arnd@arndb.de>,
	<lenb@kernel.org>, <mark.rutland@arm.com>, <harisokn@amazon.com>,
	<mtosatti@redhat.com>, <sudeep.holla@arm.com>, <cl@gentwo.org>,
	<misono.tomohiro@fujitsu.com>, <maobibo@loongson.cn>,
	<joao.m.martins@oracle.com>, <boris.ostrovsky@oracle.com>,
	<konrad.wilk@oracle.com>, Jie Zhan <zhanjie9@hisilicon.com>,
	<lihuisong@huawei.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
From: "zhenglifeng (A)" <zhenglifeng1@huawei.com>
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemh100008.china.huawei.com (7.202.181.93)



On 2024/9/26 7:24, Ankur Arora wrote:
> This patchset enables the cpuidle-haltpoll driver and its namesake
> governor on arm64. This is specifically interesting for KVM guests by
> reducing IPC latencies.
> 
> Comparing idle switching latencies on an arm64 KVM guest with 
> perf bench sched pipe:
> 
>                                      usecs/op       %stdev   
> 
>   no haltpoll (baseline)               13.48       +-  5.19%
>   with haltpoll                         6.84       +- 22.07%
> 
> 
> No change in performance for a similar test on x86:
> 
>                                      usecs/op        %stdev   
> 
>   haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
>   haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%
> 
> Both sets of tests were on otherwise idle systems with guest VCPUs
> pinned to specific PCPUs. One reason for the higher stdev on arm64
> is that trapping of the WFE instruction by the host KVM is contingent
> on the number of tasks on the runqueue.
> 
> Tomohiro Misono and Haris Okanovic also report similar latency
> improvements on Grace and Graviton systems (for v7) [1] [2].
> 
> The patch series is organized in three parts: 
> 
>  - patch 1, reorganizes the poll_idle() loop, switching to
>    smp_cond_load_relaxed() in the polling loop.
>    Relatedly patches 2, 3 mangle the config option ARCH_HAS_CPU_RELAX,
>    renaming it to ARCH_HAS_OPTIMIZED_POLL.
> 
>  - patches 4-6 reorganize the haltpoll selection and init logic
>    to allow architecture code to select it. 
> 
>  - and finally, patches 7-11 add the bits for arm64 support.
> 
> What is still missing: this series largely completes the haltpoll side
> of functionality for arm64. There are, however, a few related areas
> that still need to be threshed out:
> 
>  - WFET support: WFE on arm64 does not guarantee that poll_idle()
>    would terminate in halt_poll_ns. Using WFET would address this.
>  - KVM_NO_POLL support on arm64
>  - KVM TWED support on arm64: allow the host to limit time spent in
>    WFE.
> 
> 
> Changelog:
> 
> v8: No logic changes. Largely respin of v7, with changes
> noted below:
> 
>  - move selection of ARCH_HAS_OPTIMIZED_POLL on arm64 to its
>    own patch.
>    (patch-9 "arm64: select ARCH_HAS_OPTIMIZED_POLL")
>    
>  - address comments simplifying arm64 support (Will Deacon)
>    (patch-11 "arm64: support cpuidle-haltpoll")
> 
> v7: No significant logic changes. Mostly a respin of v6.
> 
>  - minor cleanup in poll_idle() (Christoph Lameter)
>  - fixes conflicts due to code movement in arch/arm64/kernel/cpuidle.c
>    (Tomohiro Misono)
> 
> v6:
> 
>  - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
>    changes together (comment from Christoph Lameter)
>  - threshes out the commit messages a bit more (comments from Christoph
>    Lameter, Sudeep Holla)
>  - also rework selection of cpuidle-haltpoll. Now selected based
>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>  - moved back to arch_haltpoll_want() (comment from Joao Martins)
>    Also, arch_haltpoll_want() now takes the force parameter and is
>    now responsible for the complete selection (or not) of haltpoll.
>  - fixes the build breakage on i386
>  - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
>    Tomohiro Misono, Haris Okanovic)
> 
> 
> v5:
>  - rework the poll_idle() loop around smp_cond_load_relaxed() (review
>    comment from Tomohiro Misono.)
>  - also rework selection of cpuidle-haltpoll. Now selected based
>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>  - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
>    arm64 now depends on the event-stream being enabled.
>  - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
>  - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.
> 
> v4 changes from v3:
>  - change 7/8 per Rafael input: drop the parens and use ret for the final check
>  - add 8/8 which renames the guard for building poll_state
> 
> v3 changes from v2:
>  - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
>  - add Ack-by from Rafael Wysocki on 2/7
> 
> v2 changes from v1:
>  - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
>    (this improves by 50% at least the CPU cycles consumed in the tests above:
>    10,716,881,137 now vs 14,503,014,257 before)
>  - removed the ifdef from patch 1 per RafaelW
> 
> Please review.
> 
> [1] https://lore.kernel.org/lkml/TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com/
> [2] https://lore.kernel.org/lkml/104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com/
> 
> Ankur Arora (6):
>   cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
>   cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
>   arm64: idle: export arch_cpu_idle
>   arm64: select ARCH_HAS_OPTIMIZED_POLL
>   cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
>   arm64: support cpuidle-haltpoll
> 
> Joao Martins (4):
>   Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
>   cpuidle-haltpoll: define arch_haltpoll_want()
>   governors/haltpoll: drop kvm_para_available() check
>   arm64: define TIF_POLLING_NRFLAG
> 
> Mihai Carabas (1):
>   cpuidle/poll_state: poll via smp_cond_load_relaxed()
> 
>  arch/Kconfig                              |  3 +++
>  arch/arm64/Kconfig                        |  7 +++++++
>  arch/arm64/include/asm/cpuidle_haltpoll.h | 24 +++++++++++++++++++++++
>  arch/arm64/include/asm/thread_info.h      |  2 ++
>  arch/arm64/kernel/idle.c                  |  1 +
>  arch/x86/Kconfig                          |  5 ++---
>  arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
>  arch/x86/kernel/kvm.c                     | 13 ++++++++++++
>  drivers/acpi/processor_idle.c             |  4 ++--
>  drivers/cpuidle/Kconfig                   |  5 ++---
>  drivers/cpuidle/Makefile                  |  2 +-
>  drivers/cpuidle/cpuidle-haltpoll.c        | 12 +-----------
>  drivers/cpuidle/governors/haltpoll.c      |  6 +-----
>  drivers/cpuidle/poll_state.c              | 22 +++++++++++++++------
>  drivers/idle/Kconfig                      |  1 +
>  include/linux/cpuidle.h                   |  2 +-
>  include/linux/cpuidle_haltpoll.h          |  5 +++++
>  17 files changed, 83 insertions(+), 32 deletions(-)
>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
> 

Hi Ankur,

Thanks for the patches!

We have tested these patches on our machine, with an adaptation of ACPI LPI
states rather than c-states.

Include polling state, there would be three states to get in. Comparing idle
switching latencies of different state with perf bench sched pipe:

                                     usecs/op       %stdev   

  state0(polling state)                7.36       +-  0.35%
  state1                               8.78       +-  0.46%
  state2                              77.32       +-  5.50%
  
It turns out that it works on our machine.

Tested-by: Lifeng Zheng <zhenglifeng1@huawei.com>

The adaptation of ACPI LPI states is shown below as a patch. Feel free to
include this patch as part of your series, or I can also send it out after
your series being merged.

From: Lifeng Zheng <zhenglifeng1@huawei.com>

ACPI: processor_idle: Support polling state for LPI

Initialize an optional polling state besides LPI states.

Wrap up a new enter method to correctly reflect the actual entered state
when the polling state is enabled.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
---
 drivers/acpi/processor_idle.c | 39 ++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 44096406d65d..d154b5d77328 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1194,20 +1194,46 @@ static int acpi_idle_lpi_enter(struct cpuidle_device *dev,
 	return -EINVAL;
 }
 
+/* To correctly reflect the entered state if the poll state is enabled. */
+static int acpi_idle_lpi_enter_with_poll_state(struct cpuidle_device *dev,
+			       struct cpuidle_driver *drv, int index)
+{
+	int entered_state;
+
+	if (unlikely(index < 1))
+		return -EINVAL;
+
+	entered_state = acpi_idle_lpi_enter(dev, drv, index - 1);
+	if (entered_state < 0)
+		return entered_state;
+
+	return entered_state + 1;
+}
+
 static int acpi_processor_setup_lpi_states(struct acpi_processor *pr)
 {
-	int i;
+	int i, count;
 	struct acpi_lpi_state *lpi;
 	struct cpuidle_state *state;
 	struct cpuidle_driver *drv = &acpi_idle_driver;
+	typeof(state->enter) enter_method;
 
 	if (!pr->flags.has_lpi)
 		return -EOPNOTSUPP;
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL)) {
+		cpuidle_poll_state_init(drv);
+		count = 1;
+		enter_method = acpi_idle_lpi_enter_with_poll_state;
+	} else {
+		count = 0;
+		enter_method = acpi_idle_lpi_enter;
+	}
+
 	for (i = 0; i < pr->power.count && i < CPUIDLE_STATE_MAX; i++) {
 		lpi = &pr->power.lpi_states[i];
 
-		state = &drv->states[i];
+		state = &drv->states[count];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "LPI-%d", i);
 		strscpy(state->desc, lpi->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = lpi->wake_latency;
@@ -1215,11 +1241,14 @@ static int acpi_processor_setup_lpi_states(struct acpi_processor *pr)
 		state->flags |= arch_get_idle_state_flags(lpi->arch_flags);
 		if (i != 0 && lpi->entry_method == ACPI_CSTATE_FFH)
 			state->flags |= CPUIDLE_FLAG_RCU_IDLE;
-		state->enter = acpi_idle_lpi_enter;
-		drv->safe_state_index = i;
+		state->enter = enter_method;
+		drv->safe_state_index = count;
+		count++;
+		if (count == CPUIDLE_STATE_MAX)
+			break;
 	}
 
-	drv->state_count = i;
+	drv->state_count = count;
 
 	return 0;
 }
-- 
2.33.0




