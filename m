Return-Path: <kvm+bounces-60665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4196DBF6C8E
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 732F818A3CDC
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E79338594;
	Tue, 21 Oct 2025 13:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pu/8MhRQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD25337BA3
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 13:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761053509; cv=none; b=LX0o50jCwvPe88MPnpkFlzDqSnDATpt15IWIUhqRfoJujrzOzOk+exuWLgg6aCSe8fi925f2vJSwCdRatDh8XPd82SXgGi2tPoeVQzYeQ579meERj3YL0rz8AFlPzNUhmwwkXF8s6E3oo84zB4YO5awoOqBjhtj7TJE600fyOyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761053509; c=relaxed/simple;
	bh=jdpZ/Rdvl9DMYoboJUQIxbMXJJVMjeSXcVTxV1G36KY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BJRuTM+bvYlJycaxOum9tkEfJYWUpUaberCu9mX+V45FCNVQDbtFiLZjtJsU4do1A7bGNatAB0+J/5LRwbYcgRgWR/OLdPuRQpfziKWDBJS/5sGbxFRKChNRiNMy2VGORBcyPmBhyOYgDbphySbbBBRxGpcgYzJnisZlDGOIEY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pu/8MhRQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LCDhB2001179;
	Tue, 21 Oct 2025 13:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cwImrI
	ZkdEztsUTOZiZHWIUdy0Yh1BFQJW+Pg4Ay8sk=; b=pu/8MhRQ3wURxI81YLuigO
	A5h/fOIOw0sm7erlsyaSl82w52zlGxh1Pb1cGgN4zI1g8WLhCyRxLhovWUiuRgNk
	gy1Cvnf6HLtXcE6Iq3Qw4Ttq40iuMwXufzB2MqxRSFrjwFWFWu6dFeCGL9evehTk
	SJE7NrvrJTXVUa7//fTmkgR7qzgyU9Gsq54OEju17obQhuItNBR9tX+g0fv9cMFV
	Ye6QMaYiW8KR6CYRtRj6jc4YRO+i96p9F37S0AI9hGaM4jS0Gx3WkET4O8of3wTc
	P9Wq4mCs/ItazHHJADB11ClauCxWVhXAIR8gNG2WWyjdVcTuqaXILToL3sSMzokg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v33f778a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 13:26:35 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59LDFEL4001474;
	Tue, 21 Oct 2025 13:26:35 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v33f7784-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 13:26:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59LCj5wB002324;
	Tue, 21 Oct 2025 13:26:34 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqejar0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 13:26:34 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59LDQX5663832428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 13:26:33 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E5B75805F;
	Tue, 21 Oct 2025 13:26:33 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A19E758043;
	Tue, 21 Oct 2025 13:26:30 +0000 (GMT)
Received: from [9.39.25.124] (unknown [9.39.25.124])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Oct 2025 13:26:30 +0000 (GMT)
Message-ID: <602c19bc-bed9-43c2-b98c-491b75921604@linux.ibm.com>
Date: Tue, 21 Oct 2025 18:55:53 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] hw/ppc/spapr: Inline spapr_dtb_needed()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-5-philmd@linaro.org>
Content-Language: en-US
From: Chinmay Rath <rathc@linux.ibm.com>
In-Reply-To: <20251021084346.73671-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FMYWBuos c=1 sm=1 tr=0 ts=68f78a0b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=Rnii0OVWSoyPs2-5-ZUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: OJPBdmFxcI1nz1-YSuMhFXb9JA2ldvK7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX+kRD5Uf7tfgT
 rTBvnuRFfZd8npAFBRc2yNrzDtXpgb6Iwcr1HCRkIUgMg01u1GXmnPf20fsmwGgXpU4T6rAlqP8
 ccJ4nCx/TqKiwng1D8ohreXFQSkuAj2oUfELEeFIYAYxda/cqPSPm4Qzglh3j4CgF2RhEgyP9WG
 KFKwXruEDuYbHbGCchKm9dXLRAWVtsyy/m3VmeOmBThg2vGELmRjwtjlXrDLBboHqTvXAEr4nRY
 e+kkOVgEom1fdQMoO1N80X2M1Vi6AeiXcZAc1tJz3gDV+N+hMtrUCE9Qff9Xx9MGQKWy/v7GZOt
 dHNx5DT1rsdMf3sombt/84+xlYDiSt1M/Gha7pcL7oFLVWl3qMHhZk7VZ1IpZcJrf8PsakhmbLK
 DW7fMXc/TkWkxIbUrWBvHs2Uca+afg==
X-Proofpoint-ORIG-GUID: dTGD7Ser0z01z-nMZKlhEMcmtjKsd02O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

Hey Philippe,
The commit message says that this commit is inline-ing 
spapr_dtb_needed(), but it is actually removing it. I think it's better 
to convey that in the commit message.
Or did I miss something ?

On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/ppc/spapr.c | 6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index 458d1c29b4d..ad9fc61c299 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -2053,11 +2053,6 @@ static const VMStateDescription vmstate_spapr_irq_map = {
>       },
>   };
>   
> -static bool spapr_dtb_needed(void *opaque)
> -{
> -    return true; /* backward migration compat */
> -}
> -
>   static int spapr_dtb_pre_load(void *opaque)
>   {
>       SpaprMachineState *spapr = (SpaprMachineState *)opaque;
> @@ -2073,7 +2068,6 @@ static const VMStateDescription vmstate_spapr_dtb = {
>       .name = "spapr_dtb",
>       .version_id = 1,

Does this version number need to be incremented ?

Regards,
Chinmay

>       .minimum_version_id = 1,
> -    .needed = spapr_dtb_needed,
>       .pre_load = spapr_dtb_pre_load,
>       .fields = (const VMStateField[]) {
>           VMSTATE_UINT32(fdt_initial_size, SpaprMachineState),

