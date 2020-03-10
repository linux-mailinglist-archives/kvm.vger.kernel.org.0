Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82471802BD
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 17:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgCJQEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 12:04:54 -0400
Received: from foss.arm.com ([217.140.110.172]:39018 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgCJQEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 12:04:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 064631FB;
        Tue, 10 Mar 2020 09:04:53 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F316A3F67D;
        Tue, 10 Mar 2020 09:04:51 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 28/30] arm/fdt: Remove 'linux,pci-probe-only'
 property
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-29-alexandru.elisei@arm.com>
 <20200207173829.1ac1884e@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <bbdea8bf-4776-5a60-31d7-6cf5437d8577@arm.com>
Date:   Tue, 10 Mar 2020 16:04:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207173829.1ac1884e@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/7/20 5:38 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:48:03 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> From: Julien Thierry <julien.thierry@arm.com>
>>
>> PCI now supports configurable BARs. Get rid of the no longer needed,
>> Linux-only, fdt property.
> I was just wondering: what is the x86 story here?
> Does the x86 kernel never reassign BARs? Or is this dependent on something else?
> I see tons of pci kernel command line parameters for pci=, maybe one of them would explicitly allow reassigning?

I only see pci=conf1, can you post your kernel command line? Here's mine:

[    0.000000] Command line: noapic noacpi pci=conf1 reboot=k panic=1
i8042.direct=1 i8042.dumbkbd=1 i8042.nopnp=1 earlyprintk=serial i8042.noaux=1
console=ttyS0 earlycon root=/dev/vda1

Just for pci=conf1, from Documentation/admin-guide/kernel-parameters.txt:

"conf1        [X86] Force use of PCI Configuration Access
                Mechanism 1 (config address in IO port 0xCF8,
                data in IO port 0xCFC, both 32-bit)."

But you have a point, I haven't seen an x86 guest reassign BARs, I assumed it's
because it trusts the BIOS allocation. I'll try to figure out why this happens
(maybe I need a special kernel parameter).

Thanks,
Alex
>
> Cheers,
> Andre
>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/fdt.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/arm/fdt.c b/arm/fdt.c
>> index c80e6da323b6..02091e9e0bee 100644
>> --- a/arm/fdt.c
>> +++ b/arm/fdt.c
>> @@ -130,7 +130,6 @@ static int setup_fdt(struct kvm *kvm)
>>  
>>  	/* /chosen */
>>  	_FDT(fdt_begin_node(fdt, "chosen"));
>> -	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
>>  
>>  	/* Pass on our amended command line to a Linux kernel only. */
>>  	if (kvm->cfg.firmware_filename) {
