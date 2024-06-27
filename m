Return-Path: <kvm+bounces-20591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1E091A233
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 766501F21528
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E298713792B;
	Thu, 27 Jun 2024 09:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="MojdnZIf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05E94206D
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 09:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719479312; cv=none; b=f4aXWiwLPvgVui+EemetJfjjnns9S0wR2ZX5T90s+SPKXvYylBNDETjZujLKhN9CyoXXaShe6bqbV8MsYCe3Yt/1cVqFVioVC5ZCFy/Kogj8R1HHvF6Bp/hmZoRMU8Z4kd5rOmCBnMI3UfDlD2orY/vPx6aEbb1lNCDPAzDHzSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719479312; c=relaxed/simple;
	bh=HUkSdzsyI3c2qw84BgNuG91+LSyYvAaSp+yxC7Vuspc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TXyEAGVAIidLlV6rL+MSiqCUpyo4XTGRo+oSIYnhbCGh9MaolW9EZUyCsR/gNJuRShMyJY/CiDOiu+smJ/bkA+0bOTak6mEwd5DM7jwMudB0DnAkLH81D7vmjomGgjwomb3YrFT5BPcl2PJ0t2Y4HSfPmuKSXF/HeQhjKLEEhng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=MojdnZIf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R0OMKm015158;
	Thu, 27 Jun 2024 09:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SgutWFQ5xizB8FZae9vq8wbziDGllkdv1mj9mgHIz6s=; b=MojdnZIf3drhoKXy
	8OzzMwK9TczGTIE55vT57qjdP1bQxQyORfPZ2F+QHCN9o3/XSI78RodW/kZapxUL
	xSm45rKvDSccmiwcC11WYhU2D5/4GsosaIp/cK0oahRxI/khcLJ9qE38DujQUuP5
	rDwYAl8bEnWMweqmlF6dxRWasptvV8R/lNfEReQ9WuLML7zphgf+CsL3oR6K1sr0
	3MzCBHW3OCXTVdntbiug6jFp1f828tUy9p6xY5pE3w++I/Li9FfBrFxNkkvzkhRg
	Y56i2q5W7rJftw5woPTbStYCReDzTRMl/LYuPr1OUV+3rzACS7Gi9yIAIdIHWgc3
	GADP0A==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ywqshv1a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:07:52 +0000 (GMT)
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45R97owY005528
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:07:50 GMT
Received: from [10.251.40.202] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 27 Jun
 2024 02:07:45 -0700
Message-ID: <c42e7684-048f-437d-86ec-17b9ed0ad604@quicinc.com>
Date: Thu, 27 Jun 2024 11:07:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/12] plugins: fix inject_mem_cb rw masking
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
 <20240620152220.2192768-12-alex.bennee@linaro.org>
Content-Language: en-US
From: Alwalid Salama <quic_asalama@quicinc.com>
In-Reply-To: <20240620152220.2192768-12-alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Tr3qpDV8DfKDFF0NjTBs1M5ySgj49JXq
X-Proofpoint-GUID: Tr3qpDV8DfKDFF0NjTBs1M5ySgj49JXq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 mlxlogscore=933 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406270069

Reviewed-by: Alwalid Salama <quic_asalama@qualcomm.com>

On 6/20/2024 5:22 PM, Alex Bennée wrote:
> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> 
> These are not booleans, but masks.
> Issue found by Richard Henderson.
> 
> Fixes: f86fd4d8721 ("plugins: distinct types for callbacks")
> Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Message-Id: <20240612195147.93121-3-pierrick.bouvier@linaro.org>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   accel/tcg/plugin-gen.c | 4 ++--
>   plugins/core.c         | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
> index cc1634e7a6..b6bae32b99 100644
> --- a/accel/tcg/plugin-gen.c
> +++ b/accel/tcg/plugin-gen.c
> @@ -240,13 +240,13 @@ static void inject_mem_cb(struct qemu_plugin_dyn_cb *cb,
>   {
>       switch (cb->type) {
>       case PLUGIN_CB_MEM_REGULAR:
> -        if (rw && cb->regular.rw) {
> +        if (rw & cb->regular.rw) {
>               gen_mem_cb(&cb->regular, meminfo, addr);
>           }
>           break;
>       case PLUGIN_CB_INLINE_ADD_U64:
>       case PLUGIN_CB_INLINE_STORE_U64:
> -        if (rw && cb->inline_insn.rw) {
> +        if (rw & cb->inline_insn.rw) {
>               inject_cb(cb);
>           }
>           break;
> diff --git a/plugins/core.c b/plugins/core.c
> index badede28cf..9d737d8278 100644
> --- a/plugins/core.c
> +++ b/plugins/core.c
> @@ -589,7 +589,7 @@ void qemu_plugin_vcpu_mem_cb(CPUState *cpu, uint64_t vaddr,
>   
>           switch (cb->type) {
>           case PLUGIN_CB_MEM_REGULAR:
> -            if (rw && cb->regular.rw) {
> +            if (rw & cb->regular.rw) {
>                   cb->regular.f.vcpu_mem(cpu->cpu_index,
>                                          make_plugin_meminfo(oi, rw),
>                                          vaddr, cb->regular.userp);
> @@ -597,7 +597,7 @@ void qemu_plugin_vcpu_mem_cb(CPUState *cpu, uint64_t vaddr,
>               break;
>           case PLUGIN_CB_INLINE_ADD_U64:
>           case PLUGIN_CB_INLINE_STORE_U64:
> -            if (rw && cb->inline_insn.rw) {
> +            if (rw & cb->inline_insn.rw) {
>                   exec_inline_op(cb->type, &cb->inline_insn, cpu->cpu_index);
>               }
>               break;

