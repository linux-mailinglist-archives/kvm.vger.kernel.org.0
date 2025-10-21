Return-Path: <kvm+bounces-60658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9441BF604F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BB861891490
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 11:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE8B32B9BC;
	Tue, 21 Oct 2025 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DsnwwVaD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C40932B985
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046047; cv=none; b=U+hASmxMD8yj8QSVC1cvZ3c+LIk1syF02NESntKOBBDYlxK7/vHOMV9oH1r6h0KLkmfH/s7rnz1u/MebX1PDZ1sZiT3DVpQozVYpngbWsiTH9s1dNnzMxyHS3HSHTXezQOtfnHz4q53RCxcOJXn33LiPrBUbS9TU1DD21nQukMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046047; c=relaxed/simple;
	bh=HVpw7oKYIvSH9o/jTg20CkULWkTx+EO6Nbakt2/c3K8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKJNyG+NAgo/3WPRNDVN3/GQPeNX4+zlP7HLdN1PgmkYtspFeZcpZpHjPjy54C50uDmXJ3F7yEFVDRs89wtPQ1wujEJ8JMuSDBPeWz/vT94K219FHRXyB3rV51pOXhr6XA/3JXVwfC0yWWxUVm7jU1hWHJhJS8PS3phVsf9aFNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DsnwwVaD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L8GsF5017546;
	Tue, 21 Oct 2025 11:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Tcjchj
	A6/+BVFcTNQO+/OKE///DuvSoP75TVH+UCWyQ=; b=DsnwwVaDJpWC2ZZjtPjUxd
	uCmk20Bf7Yngq1r7jM5xGcffOwGpL9DXj6vfjD0WnsV4K+9MNeAloxUvuDp99L+F
	AwE/FvEPrnf4hfWZE8RHayHm3K9cWVWA87w1ik+7+yU5AsnjyJvQMUDzkNOiwl9/
	Pgka0OsIaFqkE21ic8BNG2MhTlSTwoqDkau6y33rFr3IELHtuHOmXMKubd632sFr
	Kk4SUZv+p5IZ7z3RurnROVX9uVjdNfj4HO22Yzd/6FDF2nnQ4GiuBXq+HH+zbMD6
	FYwf1xAKGbkJ85e0IfuNrjlp032a0R/WcsffUN1Oygi7ZQzd0BID9yCDowLl4JLw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v33f6p8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:27:14 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59LBIOtk013218;
	Tue, 21 Oct 2025 11:27:13 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v33f6p8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:27:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59LAuTTf014669;
	Tue, 21 Oct 2025 11:27:12 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vn7s2mm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:27:12 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59LBQxJR29491846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:26:59 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1D915805E;
	Tue, 21 Oct 2025 11:27:11 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 202D958051;
	Tue, 21 Oct 2025 11:27:09 +0000 (GMT)
Received: from [9.79.201.141] (unknown [9.79.201.141])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Oct 2025 11:27:08 +0000 (GMT)
Message-ID: <7f3143bc-505e-4120-938a-fa4bed982f7d@linux.ibm.com>
Date: Tue, 21 Oct 2025 16:57:06 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] hw/ppc/spapr: Inline few SPAPR_IRQ_* uses
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-6-philmd@linaro.org>
Content-Language: en-US
From: Chinmay Rath <rathc@linux.ibm.com>
In-Reply-To: <20251021084346.73671-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FMYWBuos c=1 sm=1 tr=0 ts=68f76e12 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=vLoeH9cbTDQAPZaO96UA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 2uTicLUVE8LEfvx4Yfdfrn4kf_sw6Wn7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX8E/s87B9akSr
 AmdiBld3qK00zSBQtRZFL+sAxBY9zTiOBmZhH7/d8SdTqUpKHQLGIuie3gneg+Q2KzxfH2IQi3v
 T4eCo1/4qguB4dZyZFusZ5o7p0H53cKCYDNPekbvMMpIc+vDzu+YjA1VCT3BEvpd+7Wzrxs7iF3
 Vo3r9y+/iybBFj/0alG4UjuurZcR1wdSuQS4/mtHWljU4wwNQaYeCFV+OZXSxuryOwPVGQTbuf7
 9gNeeexPTVTj0vV2sKzNCHIzexwVsjNAv/8b12URc7iIUPcmpaJUQU2Ulk4fRyXuVetSFHKL6UK
 ykj+8lYEB9EJ2C6aZUL+sbjjTXCIFSvuP40djug+XTZFV8EjqCkbePwZyyZ09nKciT8Jef1tUfh
 Mv6kjIZbMtP7FW/Dtz2NDjejU9ZUZg==
X-Proofpoint-ORIG-GUID: 5CcphESwmciE-fSZgbOPW1R0dGg74zBB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022


On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/ppc/spapr_events.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
> index 548a190ce89..892ddc7f8f7 100644
> --- a/hw/ppc/spapr_events.c
> +++ b/hw/ppc/spapr_events.c
> @@ -1041,16 +1041,14 @@ void spapr_clear_pending_hotplug_events(SpaprMachineState *spapr)
>   
>   void spapr_events_init(SpaprMachineState *spapr)
>   {
> -    int epow_irq = SPAPR_IRQ_EPOW;
> -
> -    spapr_irq_claim(spapr, epow_irq, false, &error_fatal);
> +    spapr_irq_claim(spapr, SPAPR_IRQ_EPOW, false, &error_fatal);
>   
>       QTAILQ_INIT(&spapr->pending_events);
>   
>       spapr->event_sources = spapr_event_sources_new();
>   
>       spapr_event_sources_register(spapr->event_sources, EVENT_CLASS_EPOW,
> -                                 epow_irq);
> +                                 SPAPR_IRQ_EPOW);
>   
>       /* NOTE: if machine supports modern/dedicated hotplug event source,
>        * we add it to the device-tree unconditionally. This means we may
> @@ -1061,12 +1059,10 @@ void spapr_events_init(SpaprMachineState *spapr)
>        * checking that it's enabled.
>        */
>       if (spapr->use_hotplug_event_source) {
> -        int hp_irq = SPAPR_IRQ_HOTPLUG;
> -
> -        spapr_irq_claim(spapr, hp_irq, false, &error_fatal);
> +        spapr_irq_claim(spapr, SPAPR_IRQ_HOTPLUG, false, &error_fatal);
>   
>           spapr_event_sources_register(spapr->event_sources, EVENT_CLASS_HOT_PLUG,
> -                                     hp_irq);
> +                                     SPAPR_IRQ_HOTPLUG);
>       }
>   
>       spapr->epow_notifier.notify = spapr_powerdown_req;
Reviewed-by: Chinmay Rath <rathc@linux.ibm.com>

