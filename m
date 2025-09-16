Return-Path: <kvm+bounces-57776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45379B5A0B2
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0F42324BCA
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14A02DC336;
	Tue, 16 Sep 2025 18:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ce9uqpsK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA191284889;
	Tue, 16 Sep 2025 18:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758047889; cv=none; b=K31DdICiuRlYD+Q6Ca3nXeWT1BSwBaq1ItdPUMlWS1nHle/wxrVBHfC8cp3lx9j4rVP7P6HoK3Ai9AYw09S4kFBMIZjbpSHf32dPs4qh7INwFzPcRHIvLiPQvB6L8ZzXAW0cfW8i7wjGeVTiRkEBxul061ThTYH4gTPGuDCMcEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758047889; c=relaxed/simple;
	bh=IpDq4Tciz2ORqiJy1wI4JKzfKJ+XkxMcUu/ZTaLKoxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p11V4WCMeevYgEfpa8dyM0XeoGPuupVOWOclheYOzoR004LaLbcY57qYHcMDbnxwBWjpA6TL3j1Sa6Mt/bCUmhrKzBdlkYn+97O7iOfDKKEXSLe+zNeyncoclinr5WvsjkbE1CWfGLf82cY7ZmQaX3+joFacBqK5KLf9oYTmij8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ce9uqpsK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GB3vCJ024250;
	Tue, 16 Sep 2025 18:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dRmI84
	CR+1H+W4KqtHLaB9gtGpEBCAQvehJ+XP4RHZc=; b=ce9uqpsKCQd8tl6YWap/Ee
	AEnk/8iDEFC4WO6oKQ99bgbV6I6Ak0bUjNci5lKFmWkLAmP3zYF5w0/jB3Y4n+Ey
	MEY9YazOOdJunPSENkRckU4x2976NRMXm1k/ujZmDShNCgWwYIPUtgSHBrnvLfCf
	HA2GECAbXsc+S6Whm2yo6RdToTpue/WLkRgbD/dvY+M/3szj/AgKB/CPR1yXSMfw
	3tSg9dRphOLbARYtnQGfp2WF1KzYtcCaDkrXowvZ9mLnoSHq0x25wGoUx3/BZwBJ
	uzG1DaPufbzcD71yxfSnTW5TUQ+9YGPe2OQqJuLnH1S9L+/UCT51/4oFM1SsCj8g
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496avnu5tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 18:38:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GHBOne005940;
	Tue, 16 Sep 2025 18:38:01 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu5pps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 18:38:01 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GIbx2E23528108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 18:38:00 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6CA45803F;
	Tue, 16 Sep 2025 18:37:59 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6B9958054;
	Tue, 16 Sep 2025 18:37:58 +0000 (GMT)
Received: from [9.61.252.174] (unknown [9.61.252.174])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 18:37:58 +0000 (GMT)
Message-ID: <e86caff6-8af0-48c9-9058-c1991e23160f@linux.ibm.com>
Date: Tue, 16 Sep 2025 11:37:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] PCI: Allow per function PCI slots
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-4-alifm@linux.ibm.com>
 <07205677-09f0-464b-b31c-0fb5493a1d81@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <07205677-09f0-464b-b31c-0fb5493a1d81@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a48L7LcWdbbzzgrG3cDw7JfR26Hlxgfb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDAyOCBTYWx0ZWRfXzR4WN/fQO4Ny
 kqHVfeVVWI/I7fTytUUEjtEBJX0o4U1IpJNk9GzfZvSK1BQwn0HmzI1Wvs19I+cJmLBKM4T9sTU
 q4o/b0v9LPfXCc2QiBM5/lTGfY+fipbHIucmjhTzf/94JacS0l22eGdbSAbRohY5B++7jhE29B6
 AOdDEVda6qsDOEh/gMVLegKS+eJwSMf3DdBj4nH/9veOX7dcpGF2HJ1ZdAEVvcqwVw3Q8Qc5Woe
 3VLDmFCQm4TG0rK/vo5i0NLnv8Ws7z3aijiNNQf8aAjfKyfttEwbF/hAW6Mw2lY9YcsY8lSqQiJ
 tnK4QGcr3+uNy5CKMZt/H+eA8RKNMt0YWiEZLOmeo/FkluTV9YuScgZQPVT+NgwRZzz8e/yD26n
 lE2wkJ2F
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=68c9ae8a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=ECVjj4BpMI1lRmso1gAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: a48L7LcWdbbzzgrG3cDw7JfR26Hlxgfb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150028


On 9/15/2025 11:52 PM, Cédric Le Goater wrote:
> Hello Ali,
>
> On 9/11/25 20:33, Farhan Ali wrote:
>> On s390 systems, which use a machine level hypervisor, PCI devices are
>> always accessed through a form of PCI pass-through which fundamentally
>> operates on a per PCI function granularity. This is also reflected in 
>> the
>> s390 PCI hotplug driver which creates hotplug slots for individual PCI
>> functions. Its reset_slot() function, which is a wrapper for
>> zpci_hot_reset_device(), thus also resets individual functions.
>>
>> Currently, the kernel's PCI_SLOT() macro assigns the same pci_slot 
>> object
>> to multifunction devices. This approach worked fine on s390 systems that
>> only exposed virtual functions as individual PCI domains to the 
>> operating
>> system.  Since commit 44510d6fa0c0 ("s390/pci: Handling multifunctions")
>> s390 supports exposing the topology of multifunction PCI devices by
>> grouping them in a shared PCI domain. When attempting to reset a 
>> function
>> through the hotplug driver, the shared slot assignment causes the wrong
>> function to be reset instead of the intended one. It also leaks 
>> memory as
>> we do create a pci_slot object for the function, but don't correctly 
>> free
>> it in pci_slot_release().
>>
>> Add a flag for struct pci_slot to allow per function PCI slots for
>> functions managed through a hypervisor, which exposes individual PCI
>> functions while retaining the topology.
>>
>> Fixes: 44510d6fa0c0 ("s390/pci: Handling multifunctions")
>> Suggested-by: Niklas Schnelle <schnelle@linux.ibm.com>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/pci/hotplug/s390_pci_hpc.c | 10 ++++++++--
>>   drivers/pci/pci.c                  |  4 +++-
>>   drivers/pci/slot.c                 | 14 +++++++++++---
>>   include/linux/pci.h                |  1 +
>>   4 files changed, 23 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/s390_pci_hpc.c 
>> b/drivers/pci/hotplug/s390_pci_hpc.c
>> index d9996516f49e..8b547de464bf 100644
>> --- a/drivers/pci/hotplug/s390_pci_hpc.c
>> +++ b/drivers/pci/hotplug/s390_pci_hpc.c
>> @@ -126,14 +126,20 @@ static const struct hotplug_slot_ops 
>> s390_hotplug_slot_ops = {
>>     int zpci_init_slot(struct zpci_dev *zdev)
>>   {
>> +    int ret;
>>       char name[SLOT_NAME_SIZE];
>>       struct zpci_bus *zbus = zdev->zbus;
>>         zdev->hotplug_slot.ops = &s390_hotplug_slot_ops;
>>         snprintf(name, SLOT_NAME_SIZE, "%08x", zdev->fid);
>> -    return pci_hp_register(&zdev->hotplug_slot, zbus->bus,
>> -                   zdev->devfn, name);
>> +    ret = pci_hp_register(&zdev->hotplug_slot, zbus->bus,
>> +                zdev->devfn, name);
>> +    if (ret)
>> +        return ret;
>> +
>> +    zdev->hotplug_slot.pci_slot->per_func_slot = 1;
>> +    return 0;
>>   }
>>     void zpci_exit_slot(struct zpci_dev *zdev)
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 3994fa82df68..70296d3b1cfc 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -5061,7 +5061,9 @@ static int pci_reset_hotplug_slot(struct 
>> hotplug_slot *hotplug, bool probe)
>>     static int pci_dev_reset_slot_function(struct pci_dev *dev, bool 
>> probe)
>>   {
>> -    if (dev->multifunction || dev->subordinate || !dev->slot ||
>> +    if (dev->multifunction && !dev->slot->per_func_slot)
>> +        return -ENOTTY;
>> +    if (dev->subordinate || !dev->slot ||
>>           dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
>>           return -ENOTTY;
>>   diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
>> index 50fb3eb595fe..51ee59e14393 100644
>> --- a/drivers/pci/slot.c
>> +++ b/drivers/pci/slot.c
>> @@ -63,6 +63,14 @@ static ssize_t cur_speed_read_file(struct pci_slot 
>> *slot, char *buf)
>>       return bus_speed_read(slot->bus->cur_bus_speed, buf);
>>   }
>>   +static bool pci_dev_matches_slot(struct pci_dev *dev, struct 
>> pci_slot *slot)
>> +{
>> +    if (slot->per_func_slot)
>> +        return dev->devfn == slot->number;
>> +
>> +    return PCI_SLOT(dev->devfn) == slot->number;
>> +}
>> +
>>   static void pci_slot_release(struct kobject *kobj)
>>   {
>>       struct pci_dev *dev;
>> @@ -73,7 +81,7 @@ static void pci_slot_release(struct kobject *kobj)
>>         down_read(&pci_bus_sem);
>>       list_for_each_entry(dev, &slot->bus->devices, bus_list)
>> -        if (PCI_SLOT(dev->devfn) == slot->number)
>> +        if (pci_dev_matches_slot(dev, slot))
>>               dev->slot = NULL;
>>       up_read(&pci_bus_sem);
>>   @@ -166,7 +174,7 @@ void pci_dev_assign_slot(struct pci_dev *dev)
>>         mutex_lock(&pci_slot_mutex);
>>       list_for_each_entry(slot, &dev->bus->slots, list)
>> -        if (PCI_SLOT(dev->devfn) == slot->number)
>> +        if (pci_dev_matches_slot(dev, slot))
>>               dev->slot = slot;
>>       mutex_unlock(&pci_slot_mutex);
>>   }
>> @@ -285,7 +293,7 @@ struct pci_slot *pci_create_slot(struct pci_bus 
>> *parent, int slot_nr,
>>         down_read(&pci_bus_sem);
>>       list_for_each_entry(dev, &parent->devices, bus_list)
>> -        if (PCI_SLOT(dev->devfn) == slot_nr)
>> +        if (pci_dev_matches_slot(dev, slot))
>>               dev->slot = slot;
>>       up_read(&pci_bus_sem);
>>   diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 59876de13860..9265f32d9786 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -78,6 +78,7 @@ struct pci_slot {
>>       struct list_head    list;        /* Node in list of slots */
>>       struct hotplug_slot    *hotplug;    /* Hotplug info (move here) */
>>       unsigned char        number;        /* PCI_SLOT(pci_dev->devfn) */
>> +    unsigned int        per_func_slot:1; /* Allow per function slot */
>>       struct kobject        kobj;
>>   };
>
> This change generates a kernel oops on x86_64. It can be reproduced in 
> a VM.
>
>
> C.
>
> [    3.073990] BUG: kernel NULL pointer dereference, address: 
> 0000000000000021
> [    3.074976] #PF: supervisor read access in kernel mode
> [    3.074976] #PF: error_code(0x0000) - not-present page
> [    3.074976] PGD 0 P4D 0
> [    3.074976] Oops: Oops: 0000 [#1] SMP NOPTI
> [    3.074976] CPU: 18 UID: 0 PID: 1 Comm: swapper/0 Not tainted 
> 6.17.0-rc6-clg-dirty #8 PREEMPT(voluntary)
> [    3.074976] Hardware name: Supermicro Super Server/X13SAE-F, BIOS 
> 4.2 12/17/2024
> [    3.074976] RIP: 0010:pci_reset_bus_function+0xdf/0x160
> [    3.074976] Code: 4e 08 00 00 40 0f 85 83 00 00 00 48 8b 78 18 e8 
> 27 9d ff ff 83 f8 e7 74 17 48 83 c4 08 5b 5d 41 5c c3 cc cc cc cc 48 
> 8b 43 30 <f6> 40 21 01 75 b6 48 8b 53 10 48 83 7a 10 00 74 5e 48 83 7b 
> 18 00
> [    3.074976] RSP: 0000:ffffcd808007b9a8 EFLAGS: 00010202
> [    3.074976] RAX: 0000000000000000 RBX: ffff88c4019b8000 RCX: 
> 0000000000000000
> [    3.074976] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
> ffff88c4019b8000
> [    3.074976] RBP: 0000000000000001 R08: 0000000000000002 R09: 
> ffffcd808007b99c
> [    3.074976] R10: ffffcd808007b950 R11: 0000000000000000 R12: 
> 0000000000000001
> [    3.074976] R13: ffff88c4019b80c8 R14: ffff88c401a7e028 R15: 
> ffff88c401a73400
> [    3.074976] FS:  0000000000000000(0000) GS:ffff88d38aad5000(0000) 
> knlGS:0000000000000000
> [    3.074976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    3.074976] CR2: 0000000000000021 CR3: 0000000f66222001 CR4: 
> 0000000000770ef0
> [    3.074976] PKRU: 55555554
> [    3.074976] Call Trace:
> [    3.074976]  <TASK>
> [    3.074976]  ? pci_pm_reset+0x39/0x180
> [    3.074976]  pci_init_reset_methods+0x52/0x80
> [    3.074976]  pci_device_add+0x215/0x5d0
> [    3.074976]  pci_scan_single_device+0xa2/0xe0
> [    3.074976]  pci_scan_slot+0x66/0x1c0
> [    3.074976]  ? klist_next+0x145/0x150
> [    3.074976]  pci_scan_child_bus_extend+0x3a/0x290
> [    3.074976]  acpi_pci_root_create+0x236/0x2a0
> [    3.074976]  pci_acpi_scan_root+0x19b/0x1f0
> [    3.074976]  acpi_pci_root_add+0x1a5/0x370
> [    3.074976]  acpi_bus_attach+0x1a8/0x290
> [    3.074976]  ? __pfx_acpi_dev_for_one_check+0x10/0x10
> [    3.074976]  device_for_each_child+0x4b/0x80
> [    3.074976]  acpi_dev_for_each_child+0x28/0x40
> [    3.074976]  ? __pfx_acpi_bus_attach+0x10/0x10
> [    3.074976]  acpi_bus_attach+0x7a/0x290
> [    3.074976]  ? _raw_spin_unlock_irqrestore+0x23/0x40
> [    3.074976]  ? __pfx_acpi_dev_for_one_check+0x10/0x10
> [    3.074976]  device_for_each_child+0x4b/0x80
> [    3.074976]  acpi_dev_for_each_child+0x28/0x40
> [    3.074976]  ? __pfx_acpi_bus_attach+0x10/0x10
> [    3.074976]  acpi_bus_attach+0x7a/0x290
> [    3.074976]  acpi_bus_scan+0x6a/0x1c0
> [    3.074976]  ? __pfx_acpi_init+0x10/0x10
> [    3.074976]  acpi_scan_init+0xdc/0x280
> [    3.074976]  ? __pfx_acpi_init+0x10/0x10
> [    3.074976]  acpi_init+0x218/0x530
> [    3.074976]  do_one_initcall+0x40/0x310
> [    3.074976]  kernel_init_freeable+0x2fe/0x450
> [    3.074976]  ? __pfx_kernel_init+0x10/0x10
> [    3.074976]  kernel_init+0x16/0x1d0
> [    3.074976]  ret_from_fork+0x1ab/0x1e0
> [    3.074976]  ? __pfx_kernel_init+0x10/0x10
> [    3.074976]  ret_from_fork_asm+0x1a/0x30
> [    3.074976]  </TASK>
> [    3.074976] Modules linked in:
> [    3.074976] CR2: 0000000000000021
> [    3.074976] ---[ end trace 0000000000000000 ]---
> [    3.074976] RIP: 0010:pci_reset_bus_function+0xdf/0x160
>
Hi Cedric,

Thanks for pointing this out. I missed that dev->slot could be NULL and 
so the per_func_slot check should be done after the check for 
!dev->slot. I tried this change on top of the patch in an x86_64 VM and 
was able to boot the VM without the oops.

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 70296d3b1cfc..3631f7faa0cf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5061,10 +5061,9 @@ static int pci_reset_hotplug_slot(struct 
hotplug_slot *hotplug, bool probe)

  static int pci_dev_reset_slot_function(struct pci_dev *dev, bool probe)
  {
-       if (dev->multifunction && !dev->slot->per_func_slot)
-               return -ENOTTY;
         if (dev->subordinate || !dev->slot ||
-           dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
+           dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
+           (dev->multifunction && !dev->slot->per_func_slot))
                 return -ENOTTY;



Thanks
Farhan


