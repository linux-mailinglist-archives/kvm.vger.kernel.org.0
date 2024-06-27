Return-Path: <kvm+bounces-20589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4335E91A22C
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC643B2126A
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39EC13792B;
	Thu, 27 Jun 2024 09:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="k35CYL/8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7824206D
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 09:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719479243; cv=none; b=fKkl3dpwNKiAq3dO7UEXvuYKSPDb4IPkjUwnNiG5OHL+MOKzSRNEPuzhuIYkSSi5/eTOvHLDbjlC+7V0e9j9reMaiOORWV8y+t9ZtHtK/Fh0lFjYNmTS513afXHmur7SH1x/no0ED+7Z/29oR2cQJj+vJwX5a0VpFlM0+HyVViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719479243; c=relaxed/simple;
	bh=D8k5XZRvNL8AErlVa7DC7XqsHyEpBEQM6QEaUn3z1D4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GlY/WB7R5e9ndmjZDbEXCwdJjVBVCjAauWphj5opotnSktwZ2y/N3AFpZAP1OZbl2tckRpGPfNiDDCG5CEftcESlvVfqIqmPnJ1wv1lC29TMTUSp3zbs2GuwLudsyXnl/3Flp1qWDEDGyE2lu6P2q/GQLDB8XWxCLLdPazQzbAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=k35CYL/8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R0pKOR018978;
	Thu, 27 Jun 2024 09:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TVZWuc4liTdd37erFPVATZ2/L40os4LFO5X8bspIulI=; b=k35CYL/8JOpU58it
	zIcej8VLMs8BdanS7qgppyny3k54FKAdvDVujnozpzO8OZN9fV71FeV4+1nIyyXz
	OpRmkMAIloysb36cN8x5mnp7HOsD0bMuGTfqW2CT+5Crp7DmJ0jd8DveSx+HdFPJ
	CQq9+WiESFmVgjJ8e4HYBsF8anFhhOFmvpiS0kVb+fkQPEeKsK0PAVjqcooH5VGk
	14R63/eZEVkAicJYQxF23mpLanhzGnhxJue/ChBIdniXm6i85zavK6ps5EwUV+ei
	SwMt/YpYvuNvXP+f5t9I652Tu8jqMdfLWtPk1Z7+ckw/A/fNEGXNfI9jB3MSSic/
	7SQBow==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 400c46bkew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:06:51 +0000 (GMT)
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
	by NALASPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45R96nUe004654
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:06:49 GMT
Received: from [10.251.40.202] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 27 Jun
 2024 02:06:43 -0700
Message-ID: <1ca0535b-e8f5-4624-8848-e79460bd60d6@quicinc.com>
Date: Thu, 27 Jun 2024 11:06:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/12] plugins: add migration blocker
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
 <20240620152220.2192768-10-alex.bennee@linaro.org>
Content-Language: en-US
From: Alwalid Salama <quic_asalama@quicinc.com>
In-Reply-To: <20240620152220.2192768-10-alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 5BrjWSbPRhJF4lC33TjwbE2-KplVXvp0
X-Proofpoint-GUID: 5BrjWSbPRhJF4lC33TjwbE2-KplVXvp0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406270069

Reviewed-by: Alwalid Salama <quic_asalama@qualcomm.com>

On 6/20/2024 5:22 PM, Alex Bennée wrote:
> If the plugin in controlling time there is some state that might be
> missing from the plugin tracking it. Migration is unlikely to work in
> this case so lets put a migration blocker in to let the user know if
> they try.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Suggested-by: "Dr. David Alan Gilbert" <dave@treblig.org>
> ---
>   plugins/api.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/plugins/api.c b/plugins/api.c
> index 4431a0ea7e..c4239153af 100644
> --- a/plugins/api.c
> +++ b/plugins/api.c
> @@ -47,6 +47,8 @@
>   #include "disas/disas.h"
>   #include "plugin.h"
>   #ifndef CONFIG_USER_ONLY
> +#include "qapi/error.h"
> +#include "migration/blocker.h"
>   #include "exec/ram_addr.h"
>   #include "qemu/plugin-memory.h"
>   #include "hw/boards.h"
> @@ -589,11 +591,17 @@ uint64_t qemu_plugin_u64_sum(qemu_plugin_u64 entry)
>    * Time control
>    */
>   static bool has_control;
> +Error *migration_blocker;
>   
>   const void *qemu_plugin_request_time_control(void)
>   {
>       if (!has_control) {
>           has_control = true;
> +#ifdef CONFIG_SOFTMMU
> +        error_setg(&migration_blocker,
> +                   "TCG plugin time control does not support migration");
> +        migrate_add_blocker(&migration_blocker, NULL);
> +#endif
>           return &has_control;
>       }
>       return NULL;

