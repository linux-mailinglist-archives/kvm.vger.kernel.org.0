Return-Path: <kvm+bounces-60808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A460ABFA7F5
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 09:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 085A64F5D69
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9A42ED165;
	Wed, 22 Oct 2025 07:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cX9DaB9j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9689A2741C9
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761117458; cv=none; b=ZlECAT993W3rwJJPMdzdxq8k9tbGG8h2N/3Z04Tz0tbvL/h1en0wLlnUSURwTvQGGhHS26QgwHkxBVN3CIEuP+A7IvKl+RFvPC7GZMKeh0K8OrfwWqEOlxRuC7WM7d64iURVOIaFXT6oNx3nVhDfe+iT0iQVE7lgS4yK7TEPGa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761117458; c=relaxed/simple;
	bh=5U8Tu8+hFqLJbEimHvIK9kOXFhdGhCf1xCzORf1YKJg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eLSFwDrgFy40sJn3ZWeMTiu8qzUn34kPbnLrIJsHKzw9LmQKKqykYAwDPl1njxicgSI3hYAGPrB9Na/0kwRLk0XZREAfCKKcFEzT49Qnz0sOhT1m/zbzQn9D3akWRwIGpIS63KZkkK1qCxcWTrF8Nss3UpUCPdqu3N62O8oVyrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cX9DaB9j; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M5MbbT027350;
	Wed, 22 Oct 2025 07:17:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WBhglN
	eWRShGc1ZivUAY9qN1Og2wqNBRKb+09V7NzNs=; b=cX9DaB9jm1dt6B3cATUiHo
	0Qn2FOUjfpbdB1/grCP6F2fTYUoCegInkx6qLZATgcnbHx4s0/Lm6mAYRB24fgrm
	oNd+elCWqUxWHPdZG38sLD/OeuXRodhKwuBALgEMhw0pBjL2HA8LU1/G5RJTgHt/
	f1cGKv38qHLYdCE26zcfgxfiacn6tNWV/OHXkoAv5omlKgN9An3odC16fXE7nRNA
	2aWsLSKVn46gnpVUtPwEkfXXXoS53UrVK3L9+J+29MQS/fbN9IcO0p59Bx+A5Feo
	nq66861ZMl8b5nmmpxx3l38nFVpfkK5L4bQLBZZUIAX3lAKzeTB9IkbkomMvsjPw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s3awy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 07:17:20 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59M71qr7028150;
	Wed, 22 Oct 2025 07:17:20 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s3awr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 07:17:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59M4Dit3002367;
	Wed, 22 Oct 2025 07:17:18 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqejeujb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 07:17:18 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59M7HHvD51380676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 07:17:17 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90C9A58053;
	Wed, 22 Oct 2025 07:17:17 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 908A85805D;
	Wed, 22 Oct 2025 07:17:14 +0000 (GMT)
Received: from [9.79.201.141] (unknown [9.79.201.141])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 22 Oct 2025 07:17:14 +0000 (GMT)
Message-ID: <bf149815-9782-4964-953d-73658b1043c9@linux.ibm.com>
Date: Wed, 22 Oct 2025 12:47:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs
 field
From: Chinmay Rath <rathc@linux.ibm.com>
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-3-philmd@linaro.org>
 <003640ee-8bd6-4366-b9eb-841c671bbf93@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <003640ee-8bd6-4366-b9eb-841c671bbf93@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hWqtPxmkkylRx0AZB1bwpoSUrOm6jcp6
X-Proofpoint-GUID: RpuvZamKzyK8T1w2pvquP6lzf90jTS0N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXygRr5Jw7DN5T
 uvRKe6GuZxlOqSxu2H7+gepBjQV8mZv+v9BC4qSwcU05tfZPkb4mAGeSsO21DMGlLHydYNOj0Eq
 Q+5gPMbHZ+PmRw4X5v+6217cef8Xs+6SOugVGxdtdMNdmRtk8GWxkBM2NjtJlR1+Srzfmfjf61L
 vOhzHWI9ZjEeLkYn5B9yxkrW3xctR+/b4t29HETNwZaNQJvsoh6awVwWoXhsyynoSAwoWd4Emfc
 LXUW2JAUAfokvq3pq14HwGG8PBzFKeIcD3irkX16fadk5HCxBELwe/OkOAid9mBFRowtkHwNutr
 IKwHTHsPVsiJjDrB5OqccoPMLKaVuVAGqcEdOm3cc6kdJfKfB4Z7vF3IUzjOgIoiafNvDIn+kUN
 ROOgInXOxPIFlZ8cVbprSOmHaUpYqg==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f88501 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=m-xGOo407m9TivMcS18A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=HhbK4dLum7pmb74im6QT:22
 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022


On 10/21/25 16:05, Chinmay Rath wrote:
>
> On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
>> The SpaprMachineClass::nr_xirqs field was only used by the
>> pseries-3.0 machine, which got removed. Remove it as now unused.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   include/hw/ppc/spapr.h |  1 -
>>   hw/ppc/spapr.c         |  1 -
>>   hw/ppc/spapr_irq.c     | 22 +++++++---------------
>>   3 files changed, 7 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
>> index 0c1e5132de2..494367fb99a 100644
>> --- a/include/hw/ppc/spapr.h
>> +++ b/include/hw/ppc/spapr.h
>> @@ -145,7 +145,6 @@ struct SpaprMachineClass {
>>       /*< public >*/
>>       bool dr_phb_enabled;       /* enable dynamic-reconfig/hotplug 
>> of PHBs */
>>       bool update_dt_enabled;    /* enable KVMPPC_H_UPDATE_DT */
>> -    uint32_t nr_xirqs;
>>       bool broken_host_serial_model; /* present real host info to the 
>> guest */
>>       bool pre_4_1_migration; /* don't migrate hpt-max-page-size */
>>       bool linux_pci_probe;
>> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
>> index 426a778d3e8..b5d20bc1756 100644
>> --- a/hw/ppc/spapr.c
>> +++ b/hw/ppc/spapr.c
>> @@ -4691,7 +4691,6 @@ static void 
>> spapr_machine_class_init(ObjectClass *oc, const void *data)
>>       smc->dr_phb_enabled = true;
>>       smc->linux_pci_probe = true;
>>       smc->smp_threads_vsmt = true;
>> -    smc->nr_xirqs = SPAPR_NR_XIRQS;
>>       xfc->match_nvt = spapr_match_nvt;
>>       vmc->client_architecture_support = 
>> spapr_vof_client_architecture_support;
>>       vmc->quiesce = spapr_vof_quiesce;
>> diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
>> index 317d57a3802..2ce323457be 100644
>> --- a/hw/ppc/spapr_irq.c
>> +++ b/hw/ppc/spapr_irq.c
>> @@ -279,15 +279,11 @@ void spapr_irq_dt(SpaprMachineState *spapr, 
>> uint32_t nr_servers,
>>     uint32_t spapr_irq_nr_msis(SpaprMachineState *spapr)
>>   {
>> -    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
>> -
>> -    return SPAPR_XIRQ_BASE + smc->nr_xirqs - SPAPR_IRQ_MSI;
>> +    return SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE - SPAPR_IRQ_MSI;
>>   }
> Hey,
> With this cleanup, I think we can get rid of the SpaprMachineState 
> argument passed to spapr_irq_nr_msis function since it is not used 
> anymore ^.
>
> Regards,
> Chinmay
On second thoughts, since the functions is just returning a constant 
value now, would it make sense to get rid of the functions all together 
and replace the calls with the respective constant ?

Regards,
Chinmay

>>     void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
>>   {
>> -    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
>> -
>>       if (kvm_enabled() && kvm_kernel_irqchip_split()) {
>>           error_setg(errp, "kernel_irqchip split mode not supported 
>> on pseries");
>>           return;
>> @@ -308,7 +304,7 @@ void spapr_irq_init(SpaprMachineState *spapr, 
>> Error **errp)
>>           object_property_add_child(OBJECT(spapr), "ics", obj);
>>           object_property_set_link(obj, ICS_PROP_XICS, OBJECT(spapr),
>>                                    &error_abort);
>> -        object_property_set_int(obj, "nr-irqs", smc->nr_xirqs, 
>> &error_abort);
>> +        object_property_set_int(obj, "nr-irqs", SPAPR_NR_XIRQS, 
>> &error_abort);
>>           if (!qdev_realize(DEVICE(obj), NULL, errp)) {
>>               return;
>>           }
>> @@ -322,7 +318,7 @@ void spapr_irq_init(SpaprMachineState *spapr, 
>> Error **errp)
>>           int i;
>>             dev = qdev_new(TYPE_SPAPR_XIVE);
>> -        qdev_prop_set_uint32(dev, "nr-irqs", smc->nr_xirqs + 
>> SPAPR_IRQ_NR_IPIS);
>> +        qdev_prop_set_uint32(dev, "nr-irqs", SPAPR_NR_XIRQS + 
>> SPAPR_IRQ_NR_IPIS);
>>           /*
>>            * 8 XIVE END structures per CPU. One for each available
>>            * priority
>> @@ -349,7 +345,7 @@ void spapr_irq_init(SpaprMachineState *spapr, 
>> Error **errp)
>>       }
>>         spapr->qirqs = qemu_allocate_irqs(spapr_set_irq, spapr,
>> -                                      smc->nr_xirqs + 
>> SPAPR_IRQ_NR_IPIS);
>> +                                      SPAPR_NR_XIRQS + 
>> SPAPR_IRQ_NR_IPIS);
>>         /*
>>        * Mostly we don't actually need this until reset, except that not
>> @@ -364,11 +360,10 @@ int spapr_irq_claim(SpaprMachineState *spapr, 
>> int irq, bool lsi, Error **errp)
>>   {
>>       SpaprInterruptController *intcs[] = ALL_INTCS(spapr);
>>       int i;
>> -    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
>>       int rc;
>>         assert(irq >= SPAPR_XIRQ_BASE);
>> -    assert(irq < (smc->nr_xirqs + SPAPR_XIRQ_BASE));
>> +    assert(irq < (SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE));
>>         for (i = 0; i < ARRAY_SIZE(intcs); i++) {
>>           SpaprInterruptController *intc = intcs[i];
>> @@ -388,10 +383,9 @@ void spapr_irq_free(SpaprMachineState *spapr, 
>> int irq, int num)
>>   {
>>       SpaprInterruptController *intcs[] = ALL_INTCS(spapr);
>>       int i, j;
>> -    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
>>         assert(irq >= SPAPR_XIRQ_BASE);
>> -    assert((irq + num) <= (smc->nr_xirqs + SPAPR_XIRQ_BASE));
>> +    assert((irq + num) <= (SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE));
>>         for (i = irq; i < (irq + num); i++) {
>>           for (j = 0; j < ARRAY_SIZE(intcs); j++) {
>> @@ -408,8 +402,6 @@ void spapr_irq_free(SpaprMachineState *spapr, int 
>> irq, int num)
>>     qemu_irq spapr_qirq(SpaprMachineState *spapr, int irq)
>>   {
>> -    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
>> -
>>       /*
>>        * This interface is basically for VIO and PHB devices to find the
>>        * right qemu_irq to manipulate, so we only allow access to the
>> @@ -418,7 +410,7 @@ qemu_irq spapr_qirq(SpaprMachineState *spapr, int 
>> irq)
>>        * interfaces, we can change this if we need to in future.
>>        */
>>       assert(irq >= SPAPR_XIRQ_BASE);
>> -    assert(irq < (smc->nr_xirqs + SPAPR_XIRQ_BASE));
>> +    assert(irq < (SPAPR_NR_XIRQS + SPAPR_XIRQ_BASE));
>>         if (spapr->ics) {
>>           assert(ics_valid_irq(spapr->ics, irq));
>

