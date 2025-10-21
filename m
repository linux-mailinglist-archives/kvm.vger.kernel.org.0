Return-Path: <kvm+bounces-60663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0DBBF64C4
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 14:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2D619A2A2C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 12:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BFB355052;
	Tue, 21 Oct 2025 11:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FfNr3GcY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD9035503E
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 11:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761047336; cv=none; b=oAfg2eO+h9bvrb4FexbbmcMHK3MYqqUyrVOGfDM7GoUfrcrITbwvdCQ7uB61gsWDiiu0yIK8HyrgztWYXMl3InXTRh7XjQQbjter6ME5QN8Vs3mxliW6rUM3W5+rhmOjkM/AWVWSBiXtm7RRl6lkOiy56hu6tSH6E5AOcjtM1LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761047336; c=relaxed/simple;
	bh=QtdwNXriTZW5iF9c5LVt/LFC5bGIqvXyar8baxQoSAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sy5wILq4kssYtP6r+28FQon0Sltspo3Ledl/vBwYKU7/1jRketVIhXdxAsBy0m0tMx+xk5CNOsbgnU7Uu4PQw3qLmNLDhri3b5a0hzXPm50AijM8BWX+ZR0TvCSWU7C0475sEVCA60AODt9+8+xs+Ej3WMhu7OsTN+tczlUDGXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FfNr3GcY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L0nHpq030621;
	Tue, 21 Oct 2025 11:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BsXRN8
	ZkKjDQ3GCgX2SZL7Ql40UHIDVUIj58pBKJ+ms=; b=FfNr3GcY2AFATBmdyt4Y5O
	mWfqEmcxShkVNiNvyo4voL3DNbGAsz3u9eEV2DkvunFpUKGtn0CWMWTNYllvkn8/
	u5nEYILZbuiRZGUjGpZBeEJi6g2im5ymz6ZpN7uLy5d1d81R+zbIe0ZhWCb6bsch
	IP+2KXVAtRMizfgaoEVP/X3KUCFowBPreGMJ9UukXDI2DuxWS/eAmCCcra9f+/JK
	OMiAec62QAjEdH7VLgyjHrvZV60Geta+A5JL+Pnxbi5G6bj7m/i2dFW6TUsz8F9x
	cI2U26V9Zp6OgaC+CKllkyn7TEAI+czJXugtqVMguH4dMPTY6YaqsXe+qbZtAqqQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31c5fra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:48:47 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59LBmlai029444;
	Tue, 21 Oct 2025 11:48:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31c5fr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:48:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L80hXX032092;
	Tue, 21 Oct 2025 11:48:46 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vp7mtf2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 11:48:46 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59LBmjCj51642692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:48:46 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D607D5805A;
	Tue, 21 Oct 2025 11:48:45 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 287015805C;
	Tue, 21 Oct 2025 11:48:43 +0000 (GMT)
Received: from [9.79.201.141] (unknown [9.79.201.141])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Oct 2025 11:48:42 +0000 (GMT)
Message-ID: <75f6cd69-d1c9-4ad1-b0aa-22b555c0ded0@linux.ibm.com>
Date: Tue, 21 Oct 2025 17:18:40 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/11] hw/ppc/spapr: Remove
 SpaprMachineClass::phb_placement callback
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-10-philmd@linaro.org>
Content-Language: en-US
From: Chinmay Rath <rathc@linux.ibm.com>
In-Reply-To: <20251021084346.73671-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pRZwONH8SKrguf3gPTqXOXECYFRyoDhY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX+4fDutZTfO0s
 Q3M0DguuQ39OJ27PJTnzuKxqFATx4wqVkTnygs2X0rK55kTje2AXz8O6KggMUjUcw9c093mJd0e
 2MT9JXgwMBMr3VF7sldhe9sfAKs1goaXhYahhjnJKEdPWIOy1VdKzZYSQohO0I+SMvSRwYbmiRz
 7tYyYyO/Fukt/jtqPypG1FDY6Bw8O+mYYyjuiKr4sXsGlqqIW/Exz3PdepWNIibuV/JnnLcwnrm
 UQ4hQCHWEO1uF5iGdoNnwmDgzOFwtE4E7b3dNGilctKeuZgN4mH0uEbShKyKL8h6Ac2KeRoRfz8
 q5qen5/phVskvGLDhK/+y7EMunVDS5t4kwLHAw5xioznrPq8vidzeySaakcnmQO/RxlAlqwNh0v
 WrbR007TsrDQ45OgjHKj/rv0X5LXgA==
X-Proofpoint-GUID: 8RGSN6O7iBi9lEzQojbKTAlDUIdh7f6k
X-Authority-Analysis: v=2.4 cv=SKNPlevH c=1 sm=1 tr=0 ts=68f7731f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=HSANSet5BusWp_HOxUwA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022


On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
> The SpaprMachineClass::phb_placement callback was only used by
> the pseries-4.0 machine, which got removed. Remove it as now
> unused, directly calling spapr_phb_placement().
> Move spapr_phb_placement() definition to avoid forward declaration.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
Reviewed-by: Chinmay Rath <rathc@linux.ibm.com>
>   include/hw/ppc/spapr.h |   5 --
>   hw/ppc/spapr.c         | 114 ++++++++++++++++++++---------------------
>   2 files changed, 55 insertions(+), 64 deletions(-)
>
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 58d31b096cd..bd783e92e15 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -147,11 +147,6 @@ struct SpaprMachineClass {
>       bool pre_5_1_assoc_refpoints;
>       bool pre_5_2_numa_associativity;
>       bool pre_6_2_numa_affinity;
> -
> -    bool (*phb_placement)(SpaprMachineState *spapr, uint32_t index,
> -                          uint64_t *buid, hwaddr *pio,
> -                          hwaddr *mmio32, hwaddr *mmio64,
> -                          unsigned n_dma, uint32_t *liobns, Error **errp);
>       SpaprResizeHpt resize_hpt_default;
>       SpaprCapabilities default_caps;
>       SpaprIrq *irq;
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index deab613e070..97736bba5a1 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -4068,12 +4068,62 @@ int spapr_phb_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
>       return 0;
>   }
>   
> +static bool spapr_phb_placement(SpaprMachineState *spapr, uint32_t index,
> +                                uint64_t *buid, hwaddr *pio,
> +                                hwaddr *mmio32, hwaddr *mmio64,
> +                                unsigned n_dma, uint32_t *liobns, Error **errp)
> +{
> +    /*
> +     * New-style PHB window placement.
> +     *
> +     * Goals: Gives large (1TiB), naturally aligned 64-bit MMIO window
> +     * for each PHB, in addition to 2GiB 32-bit MMIO and 64kiB PIO
> +     * windows.
> +     *
> +     * Some guest kernels can't work with MMIO windows above 1<<46
> +     * (64TiB), so we place up to 31 PHBs in the area 32TiB..64TiB
> +     *
> +     * 32TiB..(33TiB+1984kiB) contains the 64kiB PIO windows for each
> +     * PHB stacked together.  (32TiB+2GiB)..(32TiB+64GiB) contains the
> +     * 2GiB 32-bit MMIO windows for each PHB.  Then 33..64TiB has the
> +     * 1TiB 64-bit MMIO windows for each PHB.
> +     */
> +    const uint64_t base_buid = 0x800000020000000ULL;
> +    int i;
> +
> +    /* Sanity check natural alignments */
> +    QEMU_BUILD_BUG_ON((SPAPR_PCI_BASE % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
> +    QEMU_BUILD_BUG_ON((SPAPR_PCI_LIMIT % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
> +    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM64_WIN_SIZE % SPAPR_PCI_MEM32_WIN_SIZE) != 0);
> +    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM32_WIN_SIZE % SPAPR_PCI_IO_WIN_SIZE) != 0);
> +    /* Sanity check bounds */
> +    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_IO_WIN_SIZE) >
> +                      SPAPR_PCI_MEM32_WIN_SIZE);
> +    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_MEM32_WIN_SIZE) >
> +                      SPAPR_PCI_MEM64_WIN_SIZE);
> +
> +    if (index >= SPAPR_MAX_PHBS) {
> +        error_setg(errp, "\"index\" for PAPR PHB is too large (max %llu)",
> +                   SPAPR_MAX_PHBS - 1);
> +        return false;
> +    }
> +
> +    *buid = base_buid + index;
> +    for (i = 0; i < n_dma; ++i) {
> +        liobns[i] = SPAPR_PCI_LIOBN(index, i);
> +    }
> +
> +    *pio = SPAPR_PCI_BASE + index * SPAPR_PCI_IO_WIN_SIZE;
> +    *mmio32 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM32_WIN_SIZE;
> +    *mmio64 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM64_WIN_SIZE;
> +    return true;
> +}
> +
>   static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>                                  Error **errp)
>   {
>       SpaprMachineState *spapr = SPAPR_MACHINE(OBJECT(hotplug_dev));
>       SpaprPhbState *sphb = SPAPR_PCI_HOST_BRIDGE(dev);
> -    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
>       const unsigned windows_supported = spapr_phb_windows_supported(sphb);
>       SpaprDrc *drc;
>   
> @@ -4092,12 +4142,10 @@ static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>        * This will check that sphb->index doesn't exceed the maximum number of
>        * PHBs for the current machine type.
>        */
> -    return
> -        smc->phb_placement(spapr, sphb->index,
> -                           &sphb->buid, &sphb->io_win_addr,
> -                           &sphb->mem_win_addr, &sphb->mem64_win_addr,
> -                           windows_supported, sphb->dma_liobn,
> -                           errp);
> +    return spapr_phb_placement(spapr, sphb->index,
> +                               &sphb->buid, &sphb->io_win_addr,
> +                               &sphb->mem_win_addr, &sphb->mem64_win_addr,
> +                               windows_supported, sphb->dma_liobn, errp);
>   }
>   
>   static void spapr_phb_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
> @@ -4345,57 +4393,6 @@ static const CPUArchIdList *spapr_possible_cpu_arch_ids(MachineState *machine)
>       return machine->possible_cpus;
>   }
>   
> -static bool spapr_phb_placement(SpaprMachineState *spapr, uint32_t index,
> -                                uint64_t *buid, hwaddr *pio,
> -                                hwaddr *mmio32, hwaddr *mmio64,
> -                                unsigned n_dma, uint32_t *liobns, Error **errp)
> -{
> -    /*
> -     * New-style PHB window placement.
> -     *
> -     * Goals: Gives large (1TiB), naturally aligned 64-bit MMIO window
> -     * for each PHB, in addition to 2GiB 32-bit MMIO and 64kiB PIO
> -     * windows.
> -     *
> -     * Some guest kernels can't work with MMIO windows above 1<<46
> -     * (64TiB), so we place up to 31 PHBs in the area 32TiB..64TiB
> -     *
> -     * 32TiB..(33TiB+1984kiB) contains the 64kiB PIO windows for each
> -     * PHB stacked together.  (32TiB+2GiB)..(32TiB+64GiB) contains the
> -     * 2GiB 32-bit MMIO windows for each PHB.  Then 33..64TiB has the
> -     * 1TiB 64-bit MMIO windows for each PHB.
> -     */
> -    const uint64_t base_buid = 0x800000020000000ULL;
> -    int i;
> -
> -    /* Sanity check natural alignments */
> -    QEMU_BUILD_BUG_ON((SPAPR_PCI_BASE % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
> -    QEMU_BUILD_BUG_ON((SPAPR_PCI_LIMIT % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
> -    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM64_WIN_SIZE % SPAPR_PCI_MEM32_WIN_SIZE) != 0);
> -    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM32_WIN_SIZE % SPAPR_PCI_IO_WIN_SIZE) != 0);
> -    /* Sanity check bounds */
> -    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_IO_WIN_SIZE) >
> -                      SPAPR_PCI_MEM32_WIN_SIZE);
> -    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_MEM32_WIN_SIZE) >
> -                      SPAPR_PCI_MEM64_WIN_SIZE);
> -
> -    if (index >= SPAPR_MAX_PHBS) {
> -        error_setg(errp, "\"index\" for PAPR PHB is too large (max %llu)",
> -                   SPAPR_MAX_PHBS - 1);
> -        return false;
> -    }
> -
> -    *buid = base_buid + index;
> -    for (i = 0; i < n_dma; ++i) {
> -        liobns[i] = SPAPR_PCI_LIOBN(index, i);
> -    }
> -
> -    *pio = SPAPR_PCI_BASE + index * SPAPR_PCI_IO_WIN_SIZE;
> -    *mmio32 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM32_WIN_SIZE;
> -    *mmio64 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM64_WIN_SIZE;
> -    return true;
> -}
> -
>   static ICSState *spapr_ics_get(XICSFabric *dev, int irq)
>   {
>       SpaprMachineState *spapr = SPAPR_MACHINE(dev);
> @@ -4606,7 +4603,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
>       smc->resize_hpt_default = SPAPR_RESIZE_HPT_ENABLED;
>       fwc->get_dev_path = spapr_get_fw_dev_path;
>       nc->nmi_monitor_handler = spapr_nmi;
> -    smc->phb_placement = spapr_phb_placement;
>       vhc->cpu_in_nested = spapr_cpu_in_nested;
>       vhc->deliver_hv_excp = spapr_exit_nested;
>       vhc->hypercall = emulate_spapr_hypercall;

