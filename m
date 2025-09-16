Return-Path: <kvm+bounces-57679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E3BB58EAD
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 224881BC23A4
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 06:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23A02E0411;
	Tue, 16 Sep 2025 06:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K26DPqiL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0B82C0268
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 06:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758005561; cv=none; b=LhpDvMdZDn0hP6uq2CN+AlVsWCAbXivpfUmpggEF04v+2UPmjxf5FFL1GnjzmYmsFA3n1ImUNfU8W3X9qWa3FVWIJj3/1sjUhL4za5DqiJzboeuZwSSsIfccChGZKRr6FOM01ZZQn+sAwCNWi+eDO4fYtuAgDzTTT+kUH/iAJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758005561; c=relaxed/simple;
	bh=UyKHsrxSZ5d+t/uuNSoao881gpy1Tqfki37w866aktg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HRYXUE0rICUcPk3UeuWsCfvIAscVU12rKSind2jEH7dAOImH2a+Y+cukpuZm4NRXEQ7WvV6D1AfhJdSLJjz6BH+DwKeqfH1PerLGLO2kFgb8gGpIYHJgFZCpY2M3xyq2aXBzqHFqpBQhx/Mo1rl3gVypSjdv5d2kWUDh4WSrJZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K26DPqiL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758005558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AMVKJlLAy0pyT2tAKFDNaSbI5yrrK8zTASCBh6EKdo4=;
	b=K26DPqiLv4cqcfi7/xqAzmL09NnfBoTl2al0rT0MbOHyTiML6dzZUE3yGfxfWvLFuY7ANH
	+1+mshZv53Zo1Ebgj46MtdUInxM1x9lMaojdF9Mh3NvHeKcMwIGOJ1ZgzIcJ6VSrf78MEc
	2o9G19s7jO+noVw3DMO+hW2vAW9smbY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-dzJENGzZP9OU3eO8wtjUhQ-1; Tue, 16 Sep 2025 02:52:36 -0400
X-MC-Unique: dzJENGzZP9OU3eO8wtjUhQ-1
X-Mimecast-MFC-AGG-ID: dzJENGzZP9OU3eO8wtjUhQ_1758005555
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45df609b181so42406425e9.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 23:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758005555; x=1758610355;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AMVKJlLAy0pyT2tAKFDNaSbI5yrrK8zTASCBh6EKdo4=;
        b=OoEaBWi5wxBwcolcyToP0JyRg44+juPIwmbVmEIUr8sxSNrqVGjCSx56UaifLPzlZ3
         xpKvqCXf8V88GKnw6ByDv2+FPVw1FaUzMsf54sfnqthhyZdGZR0uJg1AEcoBCvkkOgfL
         o45rGnQp/1rqF+jONW72BF4U6qTVBimRN/Is4YJ/NHc384bdiZIYPnV3bqPvOcPNO1hg
         1c6vNPoOljeDg4by4ddmjIS6VU2tr0RKWUp7cxdV6IJ3s8+Q4eg6mHLjefqwlJJcBjIH
         RCpGM7bQh2xLf7Owlw/K4dPe0hJ8ynzleWIYKNIRlJK11MAyilWvdqGW47Fm9Yuxxl5S
         F6Og==
X-Forwarded-Encrypted: i=1; AJvYcCW8TmfSxp+8mHBfpoICrX1jDDVTU7J96x8kP/ozemNdzc+SN687/87WuiP03Z+IXtJ9MIU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIJ/JEkW1uwkk/rsbws9c2mkUWXIB5ZBMeriLdT+gCprTE2uuS
	xhSwjOr1+VRnwCGvABR5SlEolp1ghHUYYACZ5HMj6NmmoDvc47CfYTJwIGI7ZqTVTenC4IUk7Ls
	Ysv7eZbBQGAMcpQrT5XojGNkmMRRmYCWOjFIO9sPFeCqnpFacTVKHSw==
X-Gm-Gg: ASbGnctoATz4nnhcDGXhrOEn7vgaLryrYxUJFwNjg4DwCCLBavMDc9/OvuUCCU9Nud6
	S4FOAl665K9sZWEQMJBTM3sO3T2X/XEEB+6BLIGU6FjHW1frrk2IpHdGwaSe39YbClETQ8Axs9M
	nZBmWzkVBDDIEjjjoBaWSyRWw66NcTNOpJ9lmdXVAftGFtctZjkEhSM2OxEQXFqhqHtWqkXDX33
	23YRNi7j73e9KAMhf23SBbuQtMO88Or4nufnrVKVSI5slqFQ2pZTgVZc5rISr0KLD1xRSeO5Ka0
	iPlKt7y6AEHdCCyk/nVZ70LbvllQZJNchNDdxWLRRT6cS8hC5uNcn/v/AB0h0nZIayMhZRCcd1s
	Z/Bs=
X-Received: by 2002:a05:6000:2289:b0:3e5:47a9:1c7a with SMTP id ffacd0b85a97d-3e765a157b7mr13505555f8f.62.1758005555222;
        Mon, 15 Sep 2025 23:52:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWAXNBenetL3FL9OBDBNc8qHNLpJT5WfiHBs96Rxm+WMgjku9hsruXibgjX6C0ZLNz1vwS8g==
X-Received: by 2002:a05:6000:2289:b0:3e5:47a9:1c7a with SMTP id ffacd0b85a97d-3e765a157b7mr13505524f8f.62.1758005554679;
        Mon, 15 Sep 2025 23:52:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037c4490sm208864185e9.19.2025.09.15.23.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 23:52:34 -0700 (PDT)
Message-ID: <07205677-09f0-464b-b31c-0fb5493a1d81@redhat.com>
Date: Tue, 16 Sep 2025 08:52:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] PCI: Allow per function PCI slots
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-4-alifm@linux.ibm.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250911183307.1910-4-alifm@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Ali,

On 9/11/25 20:33, Farhan Ali wrote:
> On s390 systems, which use a machine level hypervisor, PCI devices are
> always accessed through a form of PCI pass-through which fundamentally
> operates on a per PCI function granularity. This is also reflected in the
> s390 PCI hotplug driver which creates hotplug slots for individual PCI
> functions. Its reset_slot() function, which is a wrapper for
> zpci_hot_reset_device(), thus also resets individual functions.
> 
> Currently, the kernel's PCI_SLOT() macro assigns the same pci_slot object
> to multifunction devices. This approach worked fine on s390 systems that
> only exposed virtual functions as individual PCI domains to the operating
> system.  Since commit 44510d6fa0c0 ("s390/pci: Handling multifunctions")
> s390 supports exposing the topology of multifunction PCI devices by
> grouping them in a shared PCI domain. When attempting to reset a function
> through the hotplug driver, the shared slot assignment causes the wrong
> function to be reset instead of the intended one. It also leaks memory as
> we do create a pci_slot object for the function, but don't correctly free
> it in pci_slot_release().
> 
> Add a flag for struct pci_slot to allow per function PCI slots for
> functions managed through a hypervisor, which exposes individual PCI
> functions while retaining the topology.
> 
> Fixes: 44510d6fa0c0 ("s390/pci: Handling multifunctions")
> Suggested-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>   drivers/pci/hotplug/s390_pci_hpc.c | 10 ++++++++--
>   drivers/pci/pci.c                  |  4 +++-
>   drivers/pci/slot.c                 | 14 +++++++++++---
>   include/linux/pci.h                |  1 +
>   4 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/s390_pci_hpc.c b/drivers/pci/hotplug/s390_pci_hpc.c
> index d9996516f49e..8b547de464bf 100644
> --- a/drivers/pci/hotplug/s390_pci_hpc.c
> +++ b/drivers/pci/hotplug/s390_pci_hpc.c
> @@ -126,14 +126,20 @@ static const struct hotplug_slot_ops s390_hotplug_slot_ops = {
>   
>   int zpci_init_slot(struct zpci_dev *zdev)
>   {
> +	int ret;
>   	char name[SLOT_NAME_SIZE];
>   	struct zpci_bus *zbus = zdev->zbus;
>   
>   	zdev->hotplug_slot.ops = &s390_hotplug_slot_ops;
>   
>   	snprintf(name, SLOT_NAME_SIZE, "%08x", zdev->fid);
> -	return pci_hp_register(&zdev->hotplug_slot, zbus->bus,
> -			       zdev->devfn, name);
> +	ret = pci_hp_register(&zdev->hotplug_slot, zbus->bus,
> +				zdev->devfn, name);
> +	if (ret)
> +		return ret;
> +
> +	zdev->hotplug_slot.pci_slot->per_func_slot = 1;
> +	return 0;
>   }
>   
>   void zpci_exit_slot(struct zpci_dev *zdev)
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 3994fa82df68..70296d3b1cfc 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5061,7 +5061,9 @@ static int pci_reset_hotplug_slot(struct hotplug_slot *hotplug, bool probe)
>   
>   static int pci_dev_reset_slot_function(struct pci_dev *dev, bool probe)
>   {
> -	if (dev->multifunction || dev->subordinate || !dev->slot ||
> +	if (dev->multifunction && !dev->slot->per_func_slot)
> +		return -ENOTTY;
> +	if (dev->subordinate || !dev->slot ||
>   	    dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
>   		return -ENOTTY;
>   
> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> index 50fb3eb595fe..51ee59e14393 100644
> --- a/drivers/pci/slot.c
> +++ b/drivers/pci/slot.c
> @@ -63,6 +63,14 @@ static ssize_t cur_speed_read_file(struct pci_slot *slot, char *buf)
>   	return bus_speed_read(slot->bus->cur_bus_speed, buf);
>   }
>   
> +static bool pci_dev_matches_slot(struct pci_dev *dev, struct pci_slot *slot)
> +{
> +	if (slot->per_func_slot)
> +		return dev->devfn == slot->number;
> +
> +	return PCI_SLOT(dev->devfn) == slot->number;
> +}
> +
>   static void pci_slot_release(struct kobject *kobj)
>   {
>   	struct pci_dev *dev;
> @@ -73,7 +81,7 @@ static void pci_slot_release(struct kobject *kobj)
>   
>   	down_read(&pci_bus_sem);
>   	list_for_each_entry(dev, &slot->bus->devices, bus_list)
> -		if (PCI_SLOT(dev->devfn) == slot->number)
> +		if (pci_dev_matches_slot(dev, slot))
>   			dev->slot = NULL;
>   	up_read(&pci_bus_sem);
>   
> @@ -166,7 +174,7 @@ void pci_dev_assign_slot(struct pci_dev *dev)
>   
>   	mutex_lock(&pci_slot_mutex);
>   	list_for_each_entry(slot, &dev->bus->slots, list)
> -		if (PCI_SLOT(dev->devfn) == slot->number)
> +		if (pci_dev_matches_slot(dev, slot))
>   			dev->slot = slot;
>   	mutex_unlock(&pci_slot_mutex);
>   }
> @@ -285,7 +293,7 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
>   
>   	down_read(&pci_bus_sem);
>   	list_for_each_entry(dev, &parent->devices, bus_list)
> -		if (PCI_SLOT(dev->devfn) == slot_nr)
> +		if (pci_dev_matches_slot(dev, slot))
>   			dev->slot = slot;
>   	up_read(&pci_bus_sem);
>   
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 59876de13860..9265f32d9786 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -78,6 +78,7 @@ struct pci_slot {
>   	struct list_head	list;		/* Node in list of slots */
>   	struct hotplug_slot	*hotplug;	/* Hotplug info (move here) */
>   	unsigned char		number;		/* PCI_SLOT(pci_dev->devfn) */
> +	unsigned int		per_func_slot:1; /* Allow per function slot */
>   	struct kobject		kobj;
>   };
>   

This change generates a kernel oops on x86_64. It can be reproduced in a VM.


C.

[    3.073990] BUG: kernel NULL pointer dereference, address: 0000000000000021
[    3.074976] #PF: supervisor read access in kernel mode
[    3.074976] #PF: error_code(0x0000) - not-present page
[    3.074976] PGD 0 P4D 0
[    3.074976] Oops: Oops: 0000 [#1] SMP NOPTI
[    3.074976] CPU: 18 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-rc6-clg-dirty #8 PREEMPT(voluntary)
[    3.074976] Hardware name: Supermicro Super Server/X13SAE-F, BIOS 4.2 12/17/2024
[    3.074976] RIP: 0010:pci_reset_bus_function+0xdf/0x160
[    3.074976] Code: 4e 08 00 00 40 0f 85 83 00 00 00 48 8b 78 18 e8 27 9d ff ff 83 f8 e7 74 17 48 83 c4 08 5b 5d 41 5c c3 cc cc cc cc 48 8b 43 30 <f6> 40 21 01 75 b6 48 8b 53 10 48 83 7a 10 00 74 5e 48 83 7b 18 00
[    3.074976] RSP: 0000:ffffcd808007b9a8 EFLAGS: 00010202
[    3.074976] RAX: 0000000000000000 RBX: ffff88c4019b8000 RCX: 0000000000000000
[    3.074976] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88c4019b8000
[    3.074976] RBP: 0000000000000001 R08: 0000000000000002 R09: ffffcd808007b99c
[    3.074976] R10: ffffcd808007b950 R11: 0000000000000000 R12: 0000000000000001
[    3.074976] R13: ffff88c4019b80c8 R14: ffff88c401a7e028 R15: ffff88c401a73400
[    3.074976] FS:  0000000000000000(0000) GS:ffff88d38aad5000(0000) knlGS:0000000000000000
[    3.074976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.074976] CR2: 0000000000000021 CR3: 0000000f66222001 CR4: 0000000000770ef0
[    3.074976] PKRU: 55555554
[    3.074976] Call Trace:
[    3.074976]  <TASK>
[    3.074976]  ? pci_pm_reset+0x39/0x180
[    3.074976]  pci_init_reset_methods+0x52/0x80
[    3.074976]  pci_device_add+0x215/0x5d0
[    3.074976]  pci_scan_single_device+0xa2/0xe0
[    3.074976]  pci_scan_slot+0x66/0x1c0
[    3.074976]  ? klist_next+0x145/0x150
[    3.074976]  pci_scan_child_bus_extend+0x3a/0x290
[    3.074976]  acpi_pci_root_create+0x236/0x2a0
[    3.074976]  pci_acpi_scan_root+0x19b/0x1f0
[    3.074976]  acpi_pci_root_add+0x1a5/0x370
[    3.074976]  acpi_bus_attach+0x1a8/0x290
[    3.074976]  ? __pfx_acpi_dev_for_one_check+0x10/0x10
[    3.074976]  device_for_each_child+0x4b/0x80
[    3.074976]  acpi_dev_for_each_child+0x28/0x40
[    3.074976]  ? __pfx_acpi_bus_attach+0x10/0x10
[    3.074976]  acpi_bus_attach+0x7a/0x290
[    3.074976]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[    3.074976]  ? __pfx_acpi_dev_for_one_check+0x10/0x10
[    3.074976]  device_for_each_child+0x4b/0x80
[    3.074976]  acpi_dev_for_each_child+0x28/0x40
[    3.074976]  ? __pfx_acpi_bus_attach+0x10/0x10
[    3.074976]  acpi_bus_attach+0x7a/0x290
[    3.074976]  acpi_bus_scan+0x6a/0x1c0
[    3.074976]  ? __pfx_acpi_init+0x10/0x10
[    3.074976]  acpi_scan_init+0xdc/0x280
[    3.074976]  ? __pfx_acpi_init+0x10/0x10
[    3.074976]  acpi_init+0x218/0x530
[    3.074976]  do_one_initcall+0x40/0x310
[    3.074976]  kernel_init_freeable+0x2fe/0x450
[    3.074976]  ? __pfx_kernel_init+0x10/0x10
[    3.074976]  kernel_init+0x16/0x1d0
[    3.074976]  ret_from_fork+0x1ab/0x1e0
[    3.074976]  ? __pfx_kernel_init+0x10/0x10
[    3.074976]  ret_from_fork_asm+0x1a/0x30
[    3.074976]  </TASK>
[    3.074976] Modules linked in:
[    3.074976] CR2: 0000000000000021
[    3.074976] ---[ end trace 0000000000000000 ]---
[    3.074976] RIP: 0010:pci_reset_bus_function+0xdf/0x160


