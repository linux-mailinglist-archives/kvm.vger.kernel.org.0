Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43161C3AAE
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 15:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgEDNAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 09:00:09 -0400
Received: from foss.arm.com ([217.140.110.172]:44306 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgEDNAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 09:00:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DBC71FB;
        Mon,  4 May 2020 06:00:08 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FA063F71F;
        Mon,  4 May 2020 06:00:07 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 24/32] pci: Limit configuration transaction
 size to 32 bits
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-25-alexandru.elisei@arm.com>
 <c1f0db1a-5df1-492b-8d91-a972fe2a4d42@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <30df4164-f7db-c00d-e67c-5d2cdb696354@arm.com>
Date:   Mon, 4 May 2020 14:00:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c1f0db1a-5df1-492b-8d91-a972fe2a4d42@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/2/20 9:34 AM, André Przywara wrote:
> On 26/03/2020 15:24, Alexandru Elisei wrote:
>> From PCI Local Bus Specification Revision 3.0. section 3.8 "64-Bit Bus
>> Extension":
>>
>> "The bandwidth requirements for I/O and configuration transactions cannot
>> justify the added complexity, and, therefore, only memory transactions
>> support 64-bit data transfers".
>>
>> Further down, the spec also describes the possible responses of a target
>> which has been requested to do a 64-bit transaction. Limit the transaction
>> to the lower 32 bits, to match the second accepted behaviour.
> That looks like a reasonable behaviour.
> AFAICS there is one code path from powerpc/spapr_pci.c which isn't
> covered by those limitations (rtas_ibm_write_pci_config() ->
> pci__config_wr() -> cfg_ops.write() -> vfio_pci_cfg_write()).
> Same for read.

The code compares the access size to 1, 2 and 4, so I think powerpc doesn't expect
64 bit accesses either. The change looks straightforward, I'll do it for consistency.

>
> I am not sure we really care, maybe you can fix it if you like.
>
> Either way this patch seems right, so:
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks!

Alex

>
> Cheers,
> Andre
>
>> ---
>>  pci.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/pci.c b/pci.c
>> index 7399c76c0819..611e2c0bf1da 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -119,6 +119,9 @@ static bool pci_config_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
>>  {
>>  	union pci_config_address pci_config_address;
>>  
>> +	if (size > 4)
>> +		size = 4;
>> +
>>  	pci_config_address.w = ioport__read32(&pci_config_address_bits);
>>  	/*
>>  	 * If someone accesses PCI configuration space offsets that are not
>> @@ -135,6 +138,9 @@ static bool pci_config_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16
>>  {
>>  	union pci_config_address pci_config_address;
>>  
>> +	if (size > 4)
>> +		size = 4;
>> +
>>  	pci_config_address.w = ioport__read32(&pci_config_address_bits);
>>  	/*
>>  	 * If someone accesses PCI configuration space offsets that are not
>> @@ -248,6 +254,9 @@ static void pci_config_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>>  	cfg_addr.w		= (u32)addr;
>>  	cfg_addr.enable_bit	= 1;
>>  
>> +	if (len > 4)
>> +		len = 4;
>> +
>>  	if (is_write)
>>  		pci__config_wr(kvm, cfg_addr, data, len);
>>  	else
>>
