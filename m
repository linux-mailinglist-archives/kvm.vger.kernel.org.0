Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7066B4578B
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 10:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfFNIcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 04:32:11 -0400
Received: from foss.arm.com ([217.140.110.172]:56980 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfFNIcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 04:32:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9D3F2B;
        Fri, 14 Jun 2019 01:32:09 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FEB43F246;
        Fri, 14 Jun 2019 01:32:09 -0700 (PDT)
Subject: Re: [PATCH kvmtool 08/16] arm/pci: Do not use first PCI IO space
 bytes for devices
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        will.deacon@arm.com, Sami.Mujawar@arm.com
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-9-git-send-email-julien.thierry@arm.com>
 <20190405163127.4b10a581@donnerap.cambridge.arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <42fb92bf-e58a-41d0-0a7f-b72d7bca481c@arm.com>
Date:   Fri, 14 Jun 2019 09:32:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190405163127.4b10a581@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

(sorry for the delay in reply)

On 05/04/2019 16:31, Andre Przywara wrote:
> On Thu, 7 Mar 2019 08:36:09 +0000
> Julien Thierry <julien.thierry@arm.com> wrote:
> 
> Hi,
> 
>> Linux has this convention that the lower 0x1000 bytes of the IO space
>> should not be used. (cf PCIBIOS_MIN_IO).
>>
>> Just allocate those bytes to prevent future allocation assigning it to
>> devices.
>>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> ---
>>  arm/pci.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arm/pci.c b/arm/pci.c
>> index 83238ca..559e0cf 100644
>> --- a/arm/pci.c
>> +++ b/arm/pci.c
>> @@ -37,6 +37,9 @@ void pci__arm_init(struct kvm *kvm)
>>  
>>  	/* Make PCI port allocation start at a properly aligned address */
>>  	pci_get_io_space_block(align_pad);
>> +
>> +	/* Convention, don't allocate first 0x1000 bytes of PCI IO */
>> +	pci_get_io_space_block(0x1000);
> 
> Is this the same problem with mixing up I/O and MMIO space as in the other patch?
> io_space means MMIO, right?
> 

Oh yes, you're right. Thanks for catching that (and in the other patch
as well).

However, fixing it unveiled a bug which apparently requires me to change
a bunch of things w.r.t. how we handle the configuration. At boot time,
Linux (without probe only) reassigns bars without disabling the device
response (it assumes that none of the devices it can configure are being
used/accessed).

This means that during the reassignment, bars from different or same
devices can temporarily alias/overlap each other during boot time. And
the current handling of PCI io/mmio region doesn't support that.

I'll rework this to make things a little bit more flexible.

Thanks,

-- 
Julien Thierry
