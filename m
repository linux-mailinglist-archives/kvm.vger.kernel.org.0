Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1F9B661F
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 16:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfIRObj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 10:31:39 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40985 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfIRObi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 10:31:38 -0400
Received: by mail-ed1-f67.google.com with SMTP id f20so173553edv.8;
        Wed, 18 Sep 2019 07:31:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aBUovupIahAYGyBEbJJYQYWcKpMNigDli6Z35qgINDE=;
        b=mjn3b2enW4qX6stNbo9qA/NxjOZ3QMb7e7LrrJOie2XYKHF567UrUnDDKgIz15xnOM
         HksasiaeLUQD805q/Ehr5LPN7e7tQ6/vCtvf+ku2g9hTWAY8TUwrbsCGScqxUbS2/yUJ
         gTzMvhM1V+cLM6zhxs8mpcxh/fUTgNAMFL/UMIzQjHy7DjFcL9G4ZiQWdJu8MIAw/+Bc
         ujcTMZM/k7EaSAdrOm6chfAlJzBCdOafn5fT0RDtH/n1BfKmger5myUXBx8qDF3PXHXl
         U+THzWNJhrwqMeza1khZkmNMOgmdHUUsR2H7RV7/zRfK4cHl0iI86WllAbycp6hKEhcA
         T4pA==
X-Gm-Message-State: APjAAAX5aOcTwpF7NDuwRulr+mIhruwTrgChErC5LidNu0aaby/Sq6la
        v24KQXJSMofUrftHQ4YXcVo=
X-Google-Smtp-Source: APXvYqzulPQd+vXUmWQEoMmxOk1mnx72mvpjn9QFdJLMa0AZcxKDkZ8k3fLyh2+OiPOCGjv4otwHNQ==
X-Received: by 2002:aa7:cdd6:: with SMTP id h22mr8762631edw.132.1568817095172;
        Wed, 18 Sep 2019 07:31:35 -0700 (PDT)
Received: from [10.10.2.174] (bran.ispras.ru. [83.149.199.196])
        by smtp.gmail.com with ESMTPSA id i7sm1065817edk.42.2019.09.18.07.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 07:31:34 -0700 (PDT)
Reply-To: efremov@linux.com
Subject: Re: [PATCH v3 17/26] vfio_pci: Loop using PCI_STD_NUM_BARS
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20190916204158.6889-1-efremov@linux.com>
 <20190916204158.6889-18-efremov@linux.com>
 <20190918091719.GA9720@e119886-lin.cambridge.arm.com>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <b2783460-1d70-f4f0-17fd-c7a901c41670@linux.com>
Date:   Wed, 18 Sep 2019 17:31:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918091719.GA9720@e119886-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/18/19 12:17 PM, Andrew Murray wrote:
> On Mon, Sep 16, 2019 at 11:41:49PM +0300, Denis Efremov wrote:
>> Refactor loops to use idiomatic C style and avoid the fencepost error
>> of using "i < PCI_STD_RESOURCE_END" when "i <= PCI_STD_RESOURCE_END"
>> is required, e.g., commit 2f686f1d9bee ("PCI: Correct PCI_STD_RESOURCE_END
>> usage").
>>
>> To iterate through all possible BARs, loop conditions changed to the
>> *number* of BARs "i < PCI_STD_NUM_BARS", instead of the index of the last
>> valid BAR "i <= PCI_STD_RESOURCE_END".
>>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Denis Efremov <efremov@linux.com>
>> ---
>>  drivers/vfio/pci/vfio_pci.c         | 11 ++++++----
>>  drivers/vfio/pci/vfio_pci_config.c  | 32 +++++++++++++++--------------
>>  drivers/vfio/pci/vfio_pci_private.h |  4 ++--
>>  3 files changed, 26 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index 703948c9fbe1..cb7d220d3246 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -110,13 +110,15 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>>  static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
>>  {
>>  	struct resource *res;
>> -	int bar;
>> +	int i;
>>  	struct vfio_pci_dummy_resource *dummy_res;
>>  
>>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>>  
>> -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
>> -		res = vdev->pdev->resource + bar;
>> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>> +		int bar = i + PCI_STD_RESOURCES;
>> +
>> +		res = &vdev->pdev->resource[bar];
> 
> Why can't we just drop PCI_STD_RESOURCES and replace it was 0. I understand
> the abstraction here, but we don't do it elsewhere across the kernel. Is this
> necessary?

There was a discussion about this particular case:
https://lkml.org/lkml/2019/8/12/999

It was decided to save the original style for vfio drivers.

> 
> Thanks,
> 
> Andrew Murray
> 
>>  
>>  		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
>>  			goto no_mmap;
>> @@ -399,7 +401,8 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>>  
>>  	vfio_config_free(vdev);
>>  
>> -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
>> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>> +		bar = i + PCI_STD_RESOURCES;
>>  		if (!vdev->barmap[bar])
>>  			continue;
>>  		pci_iounmap(pdev, vdev->barmap[bar]);
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index f0891bd8444c..90c0b80f8acf 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -450,30 +450,32 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>>  {
>>  	struct pci_dev *pdev = vdev->pdev;
>>  	int i;
>> -	__le32 *bar;
>> +	__le32 *vbar;
>>  	u64 mask;
>>  
>> -	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
>> +	vbar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
>>  
>> -	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
>> -		if (!pci_resource_start(pdev, i)) {
>> -			*bar = 0; /* Unmapped by host = unimplemented to user */
>> +	for (i = 0; i < PCI_STD_NUM_BARS; i++, vbar++) {
>> +		int bar = i + PCI_STD_RESOURCES;
>> +
>> +		if (!pci_resource_start(pdev, bar)) {
>> +			*vbar = 0; /* Unmapped by host = unimplemented to user */
>>  			continue;
>>  		}
>>  
>> -		mask = ~(pci_resource_len(pdev, i) - 1);
>> +		mask = ~(pci_resource_len(pdev, bar) - 1);
>>  
>> -		*bar &= cpu_to_le32((u32)mask);
>> -		*bar |= vfio_generate_bar_flags(pdev, i);
>> +		*vbar &= cpu_to_le32((u32)mask);
>> +		*vbar |= vfio_generate_bar_flags(pdev, bar);
>>  
>> -		if (*bar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
>> -			bar++;
>> -			*bar &= cpu_to_le32((u32)(mask >> 32));
>> +		if (*vbar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
>> +			vbar++;
>> +			*vbar &= cpu_to_le32((u32)(mask >> 32));
>>  			i++;
>>  		}
>>  	}
>>  
>> -	bar = (__le32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
>> +	vbar = (__le32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
>>  
>>  	/*
>>  	 * NB. REGION_INFO will have reported zero size if we weren't able
>> @@ -483,14 +485,14 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>>  	if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
>>  		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
>>  		mask |= PCI_ROM_ADDRESS_ENABLE;
>> -		*bar &= cpu_to_le32((u32)mask);
>> +		*vbar &= cpu_to_le32((u32)mask);
>>  	} else if (pdev->resource[PCI_ROM_RESOURCE].flags &
>>  					IORESOURCE_ROM_SHADOW) {
>>  		mask = ~(0x20000 - 1);
>>  		mask |= PCI_ROM_ADDRESS_ENABLE;
>> -		*bar &= cpu_to_le32((u32)mask);
>> +		*vbar &= cpu_to_le32((u32)mask);
>>  	} else
>> -		*bar = 0;
>> +		*vbar = 0;
>>  
>>  	vdev->bardirty = false;
>>  }
>> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
>> index ee6ee91718a4..8a2c7607d513 100644
>> --- a/drivers/vfio/pci/vfio_pci_private.h
>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>> @@ -86,8 +86,8 @@ struct vfio_pci_reflck {
>>  
>>  struct vfio_pci_device {
>>  	struct pci_dev		*pdev;
>> -	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
>> -	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
>> +	void __iomem		*barmap[PCI_STD_NUM_BARS];
>> +	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
>>  	u8			*pci_config_map;
>>  	u8			*vconfig;
>>  	struct perm_bits	*msi_perm;
>> -- 
>> 2.21.0
>>

