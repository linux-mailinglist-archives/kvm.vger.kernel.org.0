Return-Path: <kvm+bounces-20592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1ED591A235
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74AED1F21BF5
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F94E137C37;
	Thu, 27 Jun 2024 09:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="pFHdE9Y8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0964C4206D
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 09:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719479363; cv=none; b=n1PDoa2wX6QCUUu0DBQo+koFNq0SFDEYF1bC5S8F+bHoT52dCUJ699RwclDfRmj2R/uN382RSf1Kk/Qn4eI7mHipocuXzmE24XMnEbRAdN63ANWF+tL82pXHXrgvVWXJHO+nTMBy5HAud4viBGJkTGhikhqffe6K1bu0+E3hXJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719479363; c=relaxed/simple;
	bh=6fFh533oLjt+XJ+jgHb1Yn5MJfr4RpyaufTAPSVLqno=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UV8CdFVTHzD5PA66ExlhaJpJhJiB5qVb0jVEw9G8X1Om0l+yaXzoOtaFdwRize+vBa3U9ylQyU8JheEDEaiX2iVrnix7qGxl1cEy1QGEKqQF0IrmGWufFaaM7mqA1GDael39Swh6c7h0cuDlgoGVR3bjsL3SjNdSHmPtS9zIe1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=pFHdE9Y8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R1AYe2019664;
	Thu, 27 Jun 2024 09:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WYAZCJTlNRD1YH3Teohr6tMxl7+IcOW1+PZf/Vf4C48=; b=pFHdE9Y8ZKviNaX9
	t5yyH28iNieUxGBGGtjmQDtEi75xFIFey61FDSdMzIoIw59f/vMZtrxID5+hmpN0
	kYNQF+tB1x2Pui6nzrq5/wLEAzs0LRaLJgx92eAMk/ZCYM5M8LLHJRSjiCs3uoMT
	Dgz5BY3O/Lb56n6Kjpv7e6bTzo0cfbRZLrZn4KHfDV+abWTe2NZ027+8EVXENomv
	YxfQxJOlursBTYXDTqZ6+BRA8zVRK86VNVn66jdxkNmbONtTHU543+UY7x01D8Ek
	mO2WAM3SViqKNZw0rA4BohpbRsYWk7MBpqr9lVqxMFKOuhevgOlOfZ0zKwVsK9ln
	ttmGyw==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 400f90k2qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:08:33 +0000 (GMT)
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45R98WI0006373
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:08:32 GMT
Received: from [10.251.40.202] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 27 Jun
 2024 02:08:26 -0700
Message-ID: <9239d8b8-2b22-47a7-b3c2-0699bab603f3@quicinc.com>
Date: Thu, 27 Jun 2024 11:08:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] accel/tcg: Avoid unnecessary call overhead from
 qemu_plugin_vcpu_mem_cb
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
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Max Chou
	<max.chou@sifive.com>, Frank Chang <frank.chang@sifive.com>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
 <20240620152220.2192768-13-alex.bennee@linaro.org>
Content-Language: en-US
From: Alwalid Salama <quic_asalama@quicinc.com>
In-Reply-To: <20240620152220.2192768-13-alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: fkXsrTe-vAZj3ikkYfqToUSMaguTzvi4
X-Proofpoint-GUID: fkXsrTe-vAZj3ikkYfqToUSMaguTzvi4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 spamscore=0 malwarescore=0 mlxlogscore=806 mlxscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270069

Reviewed-by: Alwalid Salama <quic_asalama@qualcomm.com>

On 6/20/2024 5:22 PM, Alex Bennée wrote:
> From: Max Chou <max.chou@sifive.com>
> 
> If there are not any QEMU plugin memory callback functions, checking
> before calling the qemu_plugin_vcpu_mem_cb function can reduce the
> function call overhead.
> 
> Signed-off-by: Max Chou <max.chou@sifive.com>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Frank Chang <frank.chang@sifive.com>
> Message-Id: <20240613175122.1299212-2-max.chou@sifive.com>
> ---
>   accel/tcg/ldst_common.c.inc | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/tcg/ldst_common.c.inc b/accel/tcg/ldst_common.c.inc
> index c82048e377..87ceb95487 100644
> --- a/accel/tcg/ldst_common.c.inc
> +++ b/accel/tcg/ldst_common.c.inc
> @@ -125,7 +125,9 @@ void helper_st_i128(CPUArchState *env, uint64_t addr, Int128 val, MemOpIdx oi)
>   
>   static void plugin_load_cb(CPUArchState *env, abi_ptr addr, MemOpIdx oi)
>   {
> -    qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_R);
> +    if (cpu_plugin_mem_cbs_enabled(env_cpu(env))) {
> +        qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_R);
> +    }
>   }
>   
>   uint8_t cpu_ldb_mmu(CPUArchState *env, abi_ptr addr, MemOpIdx oi, uintptr_t ra)
> @@ -188,7 +190,9 @@ Int128 cpu_ld16_mmu(CPUArchState *env, abi_ptr addr,
>   
>   static void plugin_store_cb(CPUArchState *env, abi_ptr addr, MemOpIdx oi)
>   {
> -    qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_W);
> +    if (cpu_plugin_mem_cbs_enabled(env_cpu(env))) {
> +        qemu_plugin_vcpu_mem_cb(env_cpu(env), addr, oi, QEMU_PLUGIN_MEM_W);
> +    }
>   }
>   
>   void cpu_stb_mmu(CPUArchState *env, abi_ptr addr, uint8_t val,

