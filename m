Return-Path: <kvm+bounces-20588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E9191A22B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90395282923
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9693D137903;
	Thu, 27 Jun 2024 09:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="pM6zsNiT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FB24206D
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 09:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719479227; cv=none; b=LfB+b6wsL67uCW8QY3VjKu0HNJkkmNsYc167huKb0sMsKBZP2GOj4Xu1nxgNDBUK3akZ864f6JlLBqkepD9lr63VkV0zSIs43YyWF64sVRlWva3cQaTgcoS5HbpkeI+WPLtGP+vtjnQ8hY2ZblxTOBN/sezsJUEUaNH7tX39UjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719479227; c=relaxed/simple;
	bh=MT7C2onxbj2AuICiP6SyM042+H1z1G51bBEpauE2H1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YwcBZp9DYcJJZSWH90LHovsRX7MXhloowBkNK4qcAzyU5Sb5v2Nkfojjd351A4bu82vP3QfVIPq7YmcZRmdgr/UG1ZseJqMnSYeHZ6SQJpWxlJt+6wSgmJuYvktfrfAajJ/KOIPy3w2NWN8dtjsUEFq8pKY7WVuRIA0fQnDJ2hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=pM6zsNiT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R25NO7025879;
	Thu, 27 Jun 2024 09:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	g4vvZ/upJfzVZask2zMZl2y6PmzO5N8Z7fGEUkIWy94=; b=pM6zsNiTSlozFRtJ
	OGByLRAV9AqwTXjmxwmcN9qHXqhoxV44BdqHigMq9iRiPOvCy2hn54szq0+t2pdj
	erdND3ZJMrWZWeOxWJpz+jaPm+tZL56NtIyG9dcOUHFeZDEGBLbRVbQLziNLYctf
	SYg/qsZ8xLgptTdQSssSKVskfKflxkSrWk/F2YLUZ2RGOTrQRO9Ce/1AXpk/ABUl
	r10canhZRpUSic1srIdq5Hhhp6la6HUbXMNvlVc8RkOLLxhFWFyrxnaTqybInTIC
	PNVq1QIXzWPSfNuF12tpK5QNQxPbiwd5+oEguMUCs1vfJwTU8mzTRjgTTfcm1fU3
	qpbI/g==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ywnjs3ddc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:06:07 +0000 (GMT)
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45R9663a012972
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:06:06 GMT
Received: from [10.251.40.202] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 27 Jun
 2024 02:06:00 -0700
Message-ID: <db8cee6c-319f-416d-bf72-072d0f52bab6@quicinc.com>
Date: Thu, 27 Jun 2024 11:05:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] plugins: add time control API
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
 <20240620152220.2192768-9-alex.bennee@linaro.org>
Content-Language: en-US
From: Alwalid Salama <quic_asalama@quicinc.com>
In-Reply-To: <20240620152220.2192768-9-alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 5Qkt0HKQLvqvOis08rbwoyG0n0a4iuZl
X-Proofpoint-ORIG-GUID: 5Qkt0HKQLvqvOis08rbwoyG0n0a4iuZl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270069

Reviewed-by: Alwalid Salama <quic_asalama@qualcomm.com>

On 6/20/2024 5:22 PM, Alex Bennée wrote:
> Expose the ability to control time through the plugin API. Only one
> plugin can control time so it has to request control when loaded.
> There are probably more corner cases to catch here.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> [AJB: tweaked user-mode handling, merged QEMU_PLUGIN_API fix]
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20240530220610.1245424-6-pierrick.bouvier@linaro.org>
> 
> ---
> plugins/next
>    - make qemu_plugin_update_ns a NOP in user-mode
> v2
>    - remove From: header
>    - merged in plugins: missing QEMU_PLUGIN_API for time control
> ---
>   include/qemu/qemu-plugin.h   | 27 +++++++++++++++++++++++++++
>   plugins/api.c                | 35 +++++++++++++++++++++++++++++++++++
>   plugins/qemu-plugins.symbols |  2 ++
>   3 files changed, 64 insertions(+)
> 
> diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
> index 95703d8fec..c71c705b69 100644
> --- a/include/qemu/qemu-plugin.h
> +++ b/include/qemu/qemu-plugin.h
> @@ -661,6 +661,33 @@ void qemu_plugin_register_vcpu_mem_inline_per_vcpu(
>       qemu_plugin_u64 entry,
>       uint64_t imm);
>   
> +/**
> + * qemu_plugin_request_time_control() - request the ability to control time
> + *
> + * This grants the plugin the ability to control system time. Only one
> + * plugin can control time so if multiple plugins request the ability
> + * all but the first will fail.
> + *
> + * Returns an opaque handle or NULL if fails
> + */
> +QEMU_PLUGIN_API
> +const void *qemu_plugin_request_time_control(void);
> +
> +/**
> + * qemu_plugin_update_ns() - update system emulation time
> + * @handle: opaque handle returned by qemu_plugin_request_time_control()
> + * @time: time in nanoseconds
> + *
> + * This allows an appropriately authorised plugin (i.e. holding the
> + * time control handle) to move system time forward to @time. For
> + * user-mode emulation the time is not changed by this as all reported
> + * time comes from the host kernel.
> + *
> + * Start time is 0.
> + */
> +QEMU_PLUGIN_API
> +void qemu_plugin_update_ns(const void *handle, int64_t time);
> +
>   typedef void
>   (*qemu_plugin_vcpu_syscall_cb_t)(qemu_plugin_id_t id, unsigned int vcpu_index,
>                                    int64_t num, uint64_t a1, uint64_t a2,
> diff --git a/plugins/api.c b/plugins/api.c
> index 6bdb26bbe3..4431a0ea7e 100644
> --- a/plugins/api.c
> +++ b/plugins/api.c
> @@ -39,6 +39,7 @@
>   #include "qemu/main-loop.h"
>   #include "qemu/plugin.h"
>   #include "qemu/log.h"
> +#include "qemu/timer.h"
>   #include "tcg/tcg.h"
>   #include "exec/exec-all.h"
>   #include "exec/gdbstub.h"
> @@ -583,3 +584,37 @@ uint64_t qemu_plugin_u64_sum(qemu_plugin_u64 entry)
>       }
>       return total;
>   }
> +
> +/*
> + * Time control
> + */
> +static bool has_control;
> +
> +const void *qemu_plugin_request_time_control(void)
> +{
> +    if (!has_control) {
> +        has_control = true;
> +        return &has_control;
> +    }
> +    return NULL;
> +}
> +
> +#ifdef CONFIG_SOFTMMU
> +static void advance_virtual_time__async(CPUState *cpu, run_on_cpu_data data)
> +{
> +    int64_t new_time = data.host_ulong;
> +    qemu_clock_advance_virtual_time(new_time);
> +}
> +#endif
> +
> +void qemu_plugin_update_ns(const void *handle, int64_t new_time)
> +{
> +#ifdef CONFIG_SOFTMMU
> +    if (handle == &has_control) {
> +        /* Need to execute out of cpu_exec, so bql can be locked. */
> +        async_run_on_cpu(current_cpu,
> +                         advance_virtual_time__async,
> +                         RUN_ON_CPU_HOST_ULONG(new_time));
> +    }
> +#endif
> +}
> diff --git a/plugins/qemu-plugins.symbols b/plugins/qemu-plugins.symbols
> index aa0a77a319..ca773d8d9f 100644
> --- a/plugins/qemu-plugins.symbols
> +++ b/plugins/qemu-plugins.symbols
> @@ -38,6 +38,7 @@
>     qemu_plugin_register_vcpu_tb_exec_cond_cb;
>     qemu_plugin_register_vcpu_tb_exec_inline_per_vcpu;
>     qemu_plugin_register_vcpu_tb_trans_cb;
> +  qemu_plugin_request_time_control;
>     qemu_plugin_reset;
>     qemu_plugin_scoreboard_free;
>     qemu_plugin_scoreboard_find;
> @@ -51,5 +52,6 @@
>     qemu_plugin_u64_set;
>     qemu_plugin_u64_sum;
>     qemu_plugin_uninstall;
> +  qemu_plugin_update_ns;
>     qemu_plugin_vcpu_for_each;
>   };

