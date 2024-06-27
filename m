Return-Path: <kvm+bounces-20590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F405C91A22E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 743E81F21766
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B790413792B;
	Thu, 27 Jun 2024 09:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="m425ifnM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAB7132494
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 09:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719479276; cv=none; b=TDAMgaZcyFKT3+6CbBh0AVIhjIzYDRyaQki16ZEP9Wm2SvV6qA4OWzmBktzAfcGvfq/J2RfMxrvFs/IKR/TeBctz34p0AjzWjM2plCAr9YVs1qTfFIKuf3nijXhfMrpFOTZM8SJdNk14stsTxJngoiNeIP5P0rvHCMBvC1UOKwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719479276; c=relaxed/simple;
	bh=VkIGjwnd79fjqZMWH9laC0UZ72jnMXw3kZclP4/lh6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UgyB3VWGzNlpDf02LTkvvdYQiCLCkku0YGtJzgOfv+W/mtlQGAjnPy/5N1cccul8+6XtcFG91xEC4GuOafUKUL7qbkgZQ5aWlQYau2wVbsJYCBQQQGRYV2n+EHBjRUxHhC2M7Y1vl1+X6QboYxTFts8MO4R94C3kK5Rd6dMMRXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=m425ifnM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QM3U39003769;
	Thu, 27 Jun 2024 09:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DR1dpKBN0sU1FIFlMZ58QhGaV/3HCRARrQxqPx8DTpQ=; b=m425ifnME9/R3DHX
	0zMQeFhqzPQzvQ4HSE54w7r37TPrjsZA6hPoL0or0J1fOR2ihDBuXUZfpZsXVdSd
	X5mM0Z1Mbycyb/M12ZsIccQNHjgC8qb23c7m6YiT1aR3fN1qGc+6MyhQmZoYC7hp
	V+sktfYbGfJtc6K2l/wNukkOUBZIeUWkVp9Eu819bTNLGtMaT0U5H0IhpcozaeFN
	C6hyGwDU4Al8QSLkBSQ9De1n2oGLm9wgMbvSRkPEAMuRB75+r5j18HPfeWMHoHGb
	fRHAvFS93AK8H0xacnNi7D6BzPQhGU39Qs/wewB6qUkfkWZI5PmNKvmbGCtUIE44
	Q4gmbg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ywmaf4cnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:07:14 +0000 (GMT)
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45R97DPE014551
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:07:13 GMT
Received: from [10.251.40.202] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 27 Jun
 2024 02:07:08 -0700
Message-ID: <03ebcda6-f7f2-44d1-8bec-949dc9e0696d@quicinc.com>
Date: Thu, 27 Jun 2024 11:07:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] contrib/plugins: add Instructions Per Second
 (IPS) example for cost modeling
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        <qemu-devel@nongnu.org>
CC: Peter Maydell <peter.maydell@linaro.org>, <kvm@vger.kernel.org>,
        <qemu-ppc@nongnu.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jamie Iles <quic_jiles@quicinc.com>,
        David Hildenbrand <david@redhat.com>,
        Pierrick Bouvier
	<pierrick.bouvier@linaro.org>,
        Mark Burton <mburton@qti.qualcomm.com>,
        "Daniel Henrique Barboza" <danielhb413@gmail.com>,
        <qemu-arm@nongnu.org>, "Laurent Vivier" <lvivier@redhat.com>,
        Alexander Graf <agraf@csgraf.de>,
        "Ilya Leoshkevich" <iii@linux.ibm.com>,
        Richard Henderson
	<richard.henderson@linaro.org>,
        Marco Liebel <mliebel@qti.qualcomm.com>,
        Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        <qemu-s390x@nongnu.org>, Cameron Esfahani <dirty@apple.com>,
        Alexandre Iooss
	<erdnaxe@crans.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Roman Bolshakov
	<rbolshakov@ddn.com>,
        "Dr. David Alan Gilbert" <dave@treblig.org>,
        "Marcelo
 Tosatti" <mtosatti@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
 <20240620152220.2192768-11-alex.bennee@linaro.org>
Content-Language: en-US
From: Alwalid Salama <quic_asalama@quicinc.com>
In-Reply-To: <20240620152220.2192768-11-alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: A8nePsBmN9e4xBiKu9YSirGxCFvLO_NP
X-Proofpoint-GUID: A8nePsBmN9e4xBiKu9YSirGxCFvLO_NP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2406270068

Reviewed-by: Alwalid Salama <quic_asalama@qualcomm.com>

On 6/20/2024 5:22 PM, Alex Bennée wrote:
> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> 
> This plugin uses the new time control interface to make decisions
> about the state of time during the emulation. The algorithm is
> currently very simple. The user specifies an ips rate which applies
> per core. If the core runs ahead of its allocated execution time the
> plugin sleeps for a bit to let real time catch up. Either way time is
> updated for the emulation as a function of total executed instructions
> with some adjustments for cores that idle.
> 
> Examples
> --------
> 
> Slow down execution of /bin/true:
> $ num_insn=$(./build/qemu-x86_64 -plugin ./build/tests/plugin/libinsn.so -d plugin /bin/true |& grep total | sed -e 's/.*: //')
> $ time ./build/qemu-x86_64 -plugin ./build/contrib/plugins/libips.so,ips=$(($num_insn/4)) /bin/true
> real 4.000s
> 
> Boot a Linux kernel simulating a 250MHz cpu:
> $ /build/qemu-system-x86_64 -kernel /boot/vmlinuz-6.1.0-21-amd64 -append "console=ttyS0" -plugin ./build/contrib/plugins/libips.so,ips=$((250*1000*1000)) -smp 1 -m 512
> check time until kernel panic on serial0
> 
> Tested in system mode by booting a full debian system, and using:
> $ sysbench cpu run
> Performance decrease linearly with the given number of ips.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20240530220610.1245424-7-pierrick.bouvier@linaro.org>
> 
> ---
> v2
>    - more explicit Instructions Per Second (IPS)!
> ---
>   contrib/plugins/ips.c    | 164 +++++++++++++++++++++++++++++++++++++++
>   contrib/plugins/Makefile |   1 +
>   2 files changed, 165 insertions(+)
>   create mode 100644 contrib/plugins/ips.c
> 
> diff --git a/contrib/plugins/ips.c b/contrib/plugins/ips.c
> new file mode 100644
> index 0000000000..29fa556d0f
> --- /dev/null
> +++ b/contrib/plugins/ips.c
> @@ -0,0 +1,164 @@
> +/*
> + * Instructions Per Second (IPS) rate limiting plugin.
> + *
> + * This plugin can be used to restrict the execution of a system to a
> + * particular number of Instructions Per Second (IPS). This controls
> + * time as seen by the guest so while wall-clock time may be longer
> + * from the guests point of view time will pass at the normal rate.
> + *
> + * This uses the new plugin API which allows the plugin to control
> + * system time.
> + *
> + * Copyright (c) 2023 Linaro Ltd
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include <stdio.h>
> +#include <glib.h>
> +#include <qemu-plugin.h>
> +
> +QEMU_PLUGIN_EXPORT int qemu_plugin_version = QEMU_PLUGIN_VERSION;
> +
> +/* how many times do we update time per sec */
> +#define NUM_TIME_UPDATE_PER_SEC 10
> +#define NSEC_IN_ONE_SEC (1000 * 1000 * 1000)
> +
> +static GMutex global_state_lock;
> +
> +static uint64_t max_insn_per_second = 1000 * 1000 * 1000; /* ips per core, per second */
> +static uint64_t max_insn_per_quantum; /* trap every N instructions */
> +static int64_t virtual_time_ns; /* last set virtual time */
> +
> +static const void *time_handle;
> +
> +typedef struct {
> +    uint64_t total_insn;
> +    uint64_t quantum_insn; /* insn in last quantum */
> +    int64_t last_quantum_time; /* time when last quantum started */
> +} vCPUTime;
> +
> +struct qemu_plugin_scoreboard *vcpus;
> +
> +/* return epoch time in ns */
> +static int64_t now_ns(void)
> +{
> +    return g_get_real_time() * 1000;
> +}
> +
> +static uint64_t num_insn_during(int64_t elapsed_ns)
> +{
> +    double num_secs = elapsed_ns / (double) NSEC_IN_ONE_SEC;
> +    return num_secs * (double) max_insn_per_second;
> +}
> +
> +static int64_t time_for_insn(uint64_t num_insn)
> +{
> +    double num_secs = (double) num_insn / (double) max_insn_per_second;
> +    return num_secs * (double) NSEC_IN_ONE_SEC;
> +}
> +
> +static void update_system_time(vCPUTime *vcpu)
> +{
> +    int64_t elapsed_ns = now_ns() - vcpu->last_quantum_time;
> +    uint64_t max_insn = num_insn_during(elapsed_ns);
> +
> +    if (vcpu->quantum_insn >= max_insn) {
> +        /* this vcpu ran faster than expected, so it has to sleep */
> +        uint64_t insn_advance = vcpu->quantum_insn - max_insn;
> +        uint64_t time_advance_ns = time_for_insn(insn_advance);
> +        int64_t sleep_us = time_advance_ns / 1000;
> +        g_usleep(sleep_us);
> +    }
> +
> +    vcpu->total_insn += vcpu->quantum_insn;
> +    vcpu->quantum_insn = 0;
> +    vcpu->last_quantum_time = now_ns();
> +
> +    /* based on total number of instructions, what should be the new time? */
> +    int64_t new_virtual_time = time_for_insn(vcpu->total_insn);
> +
> +    g_mutex_lock(&global_state_lock);
> +
> +    /* Time only moves forward. Another vcpu might have updated it already. */
> +    if (new_virtual_time > virtual_time_ns) {
> +        qemu_plugin_update_ns(time_handle, new_virtual_time);
> +        virtual_time_ns = new_virtual_time;
> +    }
> +
> +    g_mutex_unlock(&global_state_lock);
> +}
> +
> +static void vcpu_init(qemu_plugin_id_t id, unsigned int cpu_index)
> +{
> +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> +    vcpu->total_insn = 0;
> +    vcpu->quantum_insn = 0;
> +    vcpu->last_quantum_time = now_ns();
> +}
> +
> +static void vcpu_exit(qemu_plugin_id_t id, unsigned int cpu_index)
> +{
> +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> +    update_system_time(vcpu);
> +}
> +
> +static void every_quantum_insn(unsigned int cpu_index, void *udata)
> +{
> +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> +    g_assert(vcpu->quantum_insn >= max_insn_per_quantum);
> +    update_system_time(vcpu);
> +}
> +
> +static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
> +{
> +    size_t n_insns = qemu_plugin_tb_n_insns(tb);
> +    qemu_plugin_u64 quantum_insn =
> +        qemu_plugin_scoreboard_u64_in_struct(vcpus, vCPUTime, quantum_insn);
> +    /* count (and eventually trap) once per tb */
> +    qemu_plugin_register_vcpu_tb_exec_inline_per_vcpu(
> +        tb, QEMU_PLUGIN_INLINE_ADD_U64, quantum_insn, n_insns);
> +    qemu_plugin_register_vcpu_tb_exec_cond_cb(
> +        tb, every_quantum_insn,
> +        QEMU_PLUGIN_CB_NO_REGS, QEMU_PLUGIN_COND_GE,
> +        quantum_insn, max_insn_per_quantum, NULL);
> +}
> +
> +static void plugin_exit(qemu_plugin_id_t id, void *udata)
> +{
> +    qemu_plugin_scoreboard_free(vcpus);
> +}
> +
> +QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
> +                                           const qemu_info_t *info, int argc,
> +                                           char **argv)
> +{
> +    for (int i = 0; i < argc; i++) {
> +        char *opt = argv[i];
> +        g_auto(GStrv) tokens = g_strsplit(opt, "=", 2);
> +        if (g_strcmp0(tokens[0], "ips") == 0) {
> +            max_insn_per_second = g_ascii_strtoull(tokens[1], NULL, 10);
> +            if (!max_insn_per_second && errno) {
> +                fprintf(stderr, "%s: couldn't parse %s (%s)\n",
> +                        __func__, tokens[1], g_strerror(errno));
> +                return -1;
> +            }
> +        } else {
> +            fprintf(stderr, "option parsing failed: %s\n", opt);
> +            return -1;
> +        }
> +    }
> +
> +    vcpus = qemu_plugin_scoreboard_new(sizeof(vCPUTime));
> +    max_insn_per_quantum = max_insn_per_second / NUM_TIME_UPDATE_PER_SEC;
> +
> +    time_handle = qemu_plugin_request_time_control();
> +    g_assert(time_handle);
> +
> +    qemu_plugin_register_vcpu_tb_trans_cb(id, vcpu_tb_trans);
> +    qemu_plugin_register_vcpu_init_cb(id, vcpu_init);
> +    qemu_plugin_register_vcpu_exit_cb(id, vcpu_exit);
> +    qemu_plugin_register_atexit_cb(id, plugin_exit, NULL);
> +
> +    return 0;
> +}
> diff --git a/contrib/plugins/Makefile b/contrib/plugins/Makefile
> index 0b64d2c1e3..449ead1130 100644
> --- a/contrib/plugins/Makefile
> +++ b/contrib/plugins/Makefile
> @@ -27,6 +27,7 @@ endif
>   NAMES += hwprofile
>   NAMES += cache
>   NAMES += drcov
> +NAMES += ips
>   
>   ifeq ($(CONFIG_WIN32),y)
>   SO_SUFFIX := .dll

