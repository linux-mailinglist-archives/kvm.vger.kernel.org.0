Return-Path: <kvm+bounces-60660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28880BF619F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5C053A7B6C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 11:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A28932E6A8;
	Tue, 21 Oct 2025 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U5rLIf7i"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63BC2AE68
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 11:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046771; cv=none; b=jqO9AylW2u55w2/vDmTcQdoqcvo4gJ4g8M8zcNfhy65BKs8hO4v+tChHw6KwiNfEJzsVbrFxQJ4cepsEGjaiIE7LeqZmiscWtC/+5UV6u8KZro706IGSKIjyBEEeNFxSrKhoHHv3Lx0WjbEK0A/fViW5BdbyWN6/1k59qtN2PDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046771; c=relaxed/simple;
	bh=a8p6/SXwUNBvTrg6toMvgoe65t+8VCnsrfCooNfVyDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DoqGJvcvlgW3UIc9IXc3asZZ/H9GwYCvAbRFaa5SbENmttUvFGIJwtJWkbPC/Pt9Nt2OZph0YbMWKneI/rGWvUH++EIShvscJvEH7uzkyLYIk2YKdLX252sbo8ucO1yy8KwC1fMQcxnDYNeotdF4x3+WoLvnFKCYmVjxIVEsJs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U5rLIf7i; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KMn6ew017502;
	Tue, 21 Oct 2025 11:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ObN/jW
	yz7jZQNGrgvSTAzT/wTutn7xnYw0hdm2qBObw=; b=U5rLIf7iLlvnPRY5oSGNIX
	LzZlhQrPq7jsg5rDOoenwaKAGmn4Zth5nTV7jRNcstdtEyOiLK2nYgausHjV7SGj
	G/+fg3xrq+q+dO4dV/HJvvUzg/ZheX/XMO4ABf+pG/FDfltrbyu8ZIaFr+qiD37B
	/MvuNqMCLFfatiSdUopeRYUtYGo9vT52WvNn4UhcnHcTCCa8Hp4ZW3HB3obaPoKE
	EfzZD5QMJnysIIbsgFN6uUQuy8RFx041o89iq0aUqrRQOhJ+w2KjatioVRljiX3t
	9BNUWQ1C6ICap+UHgjgPAuSHFs1n03xHEs2GAG/l1nYm5tfWSDGh2oZ/A9fFbdIw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vncp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:39:18 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59LBbfiv018048;
	Tue, 21 Oct 2025 11:39:17 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vncp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:39:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L8x7uO011049;
	Tue, 21 Oct 2025 11:39:17 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqx126eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:39:17 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59LBdGLm31588914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:39:16 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 997555805A;
	Tue, 21 Oct 2025 11:39:16 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C828258051;
	Tue, 21 Oct 2025 11:39:13 +0000 (GMT)
Received: from [9.79.201.141] (unknown [9.79.201.141])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Oct 2025 11:39:13 +0000 (GMT)
Message-ID: <028fdb03-7bee-4a76-932e-a9247db2f2ac@linux.ibm.com>
Date: Tue, 21 Oct 2025 17:09:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/11] target/ppc/kvm: Remove kvmppc_get_host_model()
 as unused
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-8-philmd@linaro.org>
Content-Language: en-US
From: Chinmay Rath <rathc@linux.ibm.com>
In-Reply-To: <20251021084346.73671-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OVF4HSMUdKU4xD4M7yuaZHQSyX2ecGbI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX4vncOItRNi2d
 CaKERxfIYEBxGH+vspKGf1Eogx7Op4/isnCS+wwyiDnTF6zQkf93qMvY17aB0FGMfl1VK6UnATQ
 FMfSkCbB/NGl0amXqf5WHat5pbSrZrZTfgjhHzXVSrV1abaaVD6GYMBLEGdr5Lf32BuzRYq2J9H
 LmtsugNBPcymXRk2GwHlc4UCQA4JXRAKGFs66Ipkd4dFbIL6VIrIDmjB6Picua7ughWzfSbwt35
 C3NHw62EMbMKojT3+LTr5KoVjJdd9Q1t2MkDQt2StV7dhigK3bX0SwvUPe18r6aAA313CnUMMQy
 c+QwECZz0SFWg6NMZQrEx+I5gLqQX+GCSUrDhgvjgIEJ7tnFwXK4+QMr7dxtUmuad76ttTzhBSY
 c2609UvahKWtf4RANW5HOk90Plxzbw==
X-Authority-Analysis: v=2.4 cv=MIJtWcZl c=1 sm=1 tr=0 ts=68f770e6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=cvRlsbrwNaNk8C4OaOUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: VFnuAz9LCY3QvhfgGYR41l5ntqgq0HH2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022


On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/ppc/kvm_ppc.h | 6 ------
>   target/ppc/kvm.c     | 5 -----
>   2 files changed, 11 deletions(-)
>
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index f24cc4de3c2..742881231e1 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -21,7 +21,6 @@
>   
>   uint32_t kvmppc_get_tbfreq(void);
>   uint64_t kvmppc_get_clockfreq(void);
> -bool kvmppc_get_host_model(char **buf);
>   int kvmppc_get_hasidle(CPUPPCState *env);
>   int kvmppc_get_hypercall(CPUPPCState *env, uint8_t *buf, int buf_len);
>   int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level);
> @@ -128,11 +127,6 @@ static inline uint32_t kvmppc_get_tbfreq(void)
>       return 0;
>   }
>   
> -static inline bool kvmppc_get_host_model(char **buf)
> -{
> -    return false;
> -}
> -
>   static inline uint64_t kvmppc_get_clockfreq(void)
>   {
>       return 0;
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index cb61e99f9d4..43124bf1c78 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -1864,11 +1864,6 @@ uint32_t kvmppc_get_tbfreq(void)
>       return cached_tbfreq;
>   }
>   
> -bool kvmppc_get_host_model(char **value)
> -{
> -    return g_file_get_contents("/proc/device-tree/model", value, NULL, NULL);
> -}
> -
>   /* Try to find a device tree node for a CPU with clock-frequency property */
>   static int kvmppc_find_cpu_dt(char *buf, int buf_len)
>   {
Reviewed-by: Chinmay Rath <rathc@linux.ibm.com>

