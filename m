Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E0A3FD7AA
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 12:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhIAK20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 06:28:26 -0400
Received: from foss.arm.com ([217.140.110.172]:35776 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233653AbhIAK2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 06:28:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 487B91063;
        Wed,  1 Sep 2021 03:27:29 -0700 (PDT)
Received: from [10.1.26.14] (e110479.cambridge.arm.com [10.1.26.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6263A3F766;
        Wed,  1 Sep 2021 03:27:27 -0700 (PDT)
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
To:     Will Deacon <will@kernel.org>, Vivek Gautam <vivek.gautam@arm.com>
Cc:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        alexandru.elisei@arm.com, lorenzo.pieralisi@arm.com,
        jean-philippe@linaro.org, eric.auger@redhat.com
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <20210831145424.GA32001@willie-the-truck>
From:   Andre Przywara <andre.przywara@arm.com>
Message-ID: <4f5307cf-0cea-461a-838f-85e82805c499@arm.com>
Date:   Wed, 1 Sep 2021 11:27:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210831145424.GA32001@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/31/21 3:54 PM, Will Deacon wrote:

Hi Will,

> On Tue, Aug 10, 2021 at 11:55:14AM +0530, Vivek Gautam wrote:
>> Add support to parse extended configuration space for vfio based
>> assigned PCIe devices and add extended capabilities for the device
>> in the guest. This allows the guest to see and work on extended
>> capabilities, for example to toggle PRI extended cap to enable and
>> disable Shared virtual addressing (SVA) support.
>> PCIe extended capability header that is the first DWORD of all
>> extended caps is shown below -
>>
>>     31               20  19   16  15                 0
>>     ____________________|_______|_____________________
>>    |    Next cap off    |  1h   |     Cap ID          |
>>    |____________________|_______|_____________________|
>>
>> Out of the two upper bytes of extended cap header, the
>> lower nibble is actually cap version - 0x1.
>> 'next cap offset' if present at bits [31:20], should be
>> right shifted by 4 bits to calculate the position of next
>> capability.
>> This change supports parsing and adding ATS, PRI and PASID caps.
>>
>> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
>> ---
>>   include/kvm/pci.h |   6 +++
>>   vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++----
>>   2 files changed, 103 insertions(+), 7 deletions(-)
> 
> Does this work correctly for architectures which don't define ARCH_HAS_PCI_EXP?

I think it does: the code compiles fine, and the whole functionality is 
guarded by:
+	/* Extended cap only for PCIe devices */
+	if (!arch_has_pci_exp())
+		return 0;

A clever compiler might even decide to not include this code at all.

Did you see any particular problem?

Cheers,
Andre
