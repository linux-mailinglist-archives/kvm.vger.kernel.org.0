Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4931A76B7
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 10:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437251AbgDNI4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 04:56:12 -0400
Received: from foss.arm.com ([217.140.110.172]:51278 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437215AbgDNI4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 04:56:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C65E61FB;
        Tue, 14 Apr 2020 01:56:09 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF9193F6C4;
        Tue, 14 Apr 2020 01:56:08 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 32/32] arm/arm64: Add PCI Express 1.1 support
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-33-alexandru.elisei@arm.com>
 <2b963524-3153-fc95-7bf2-b60852ea2f22@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3117c730-bc06-00c0-016b-45814a47aa52@arm.com>
Date:   Tue, 14 Apr 2020 09:56:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2b963524-3153-fc95-7bf2-b60852ea2f22@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/6/20 3:06 PM, André Przywara wrote:
>
>> @@ -792,7 +796,11 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>>  
>>  	/* Install our fake Configuration Space */
>>  	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
>> -	hdr_sz = PCI_DEV_CFG_SIZE;
>> +	/*
>> +	 * We don't touch the extended configuration space, let's be cautious
>> +	 * and not overwrite it all with zeros, or bad things might happen.
>> +	 */
>> +	hdr_sz = PCI_CFG_SPACE_SIZE;
> This breaks compilation on x86, do we miss to include a header file?
> Works on arm64, though...

I've been able to reproduce it on an x86 laptop with Ubuntu 16.04. You've stumbled
upon the reason I switched to using numbers for PCI_DEV_CFG_SIZE instead of using
the defines PCI_CFG_SPACE_SIZE and PCI_CFG_SPACE_EXP_SIZE from linux/pci_regs.h:
those defines don't exist on some distros. When that happened to Sami on arm64, I
made the change to PCI_DEV_CFG_SIZE, but I forgot to change it here. I'll switch
to using 256.

For the record, x86 compiles fine on the x86 machine which I used for testing.

Thanks,
Alex
>
> Cheers,
> Andre.
