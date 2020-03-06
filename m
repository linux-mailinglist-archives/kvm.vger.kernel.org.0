Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D1617BCCB
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 13:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgCFMdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 07:33:41 -0500
Received: from foss.arm.com ([217.140.110.172]:60632 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgCFMdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 07:33:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61D4B31B;
        Fri,  6 Mar 2020 04:33:40 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 729783F6C4;
        Fri,  6 Mar 2020 04:33:39 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 17/30] hw/vesa: Don't ignore fatal errors
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-18-alexandru.elisei@arm.com>
 <20200130145220.52d61500@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <18c8399e-927b-e382-5ac4-f36722c5a073@arm.com>
Date:   Fri, 6 Mar 2020 12:33:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200130145220.52d61500@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/30/20 2:52 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:52 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Failling an mmap call or creating a memslot means that device emulation
>> will not work, don't ignore it.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  hw/vesa.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/vesa.c b/hw/vesa.c
>> index b92cc990b730..a665736a76d7 100644
>> --- a/hw/vesa.c
>> +++ b/hw/vesa.c
>> @@ -76,9 +76,11 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>  
>>  	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>>  	if (mem == MAP_FAILED)
>> -		ERR_PTR(-errno);
>> +		return ERR_PTR(-errno);
>>  
>> -	kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
>> +	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
>> +	if (r < 0)
>> +		return ERR_PTR(r);
> For the sake of correctness, we should munmap here, I think.
> With that fixed:
>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Actually, I think the correct cleanup order should be munmap(mem) ->
device__unregister(vesa_device) -> ioport__unregister(vesa_base_addr). I'll drop
your R-b.

Thanks,
Alex
>
> Cheers,
> Andre.
>
>>  
>>  	vesafb = (struct framebuffer) {
>>  		.width			= VESA_WIDTH,
