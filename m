Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D643A17B891
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 09:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCFIrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 03:47:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34486 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725923AbgCFIrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 03:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583484432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sq19uiYcnGylfdNqIKtaPqUrfK1PWX84fJ9AJQFeyjo=;
        b=cXz8NvjQ/rGVn38bIbJtOLRENigCgk1/XbwdqXvaTT4wdvk4huvCgBUQ3eff6KowZc46aR
        OKpYGMy5vkBrPdBULUaFGYGHiC0tV09/i2h8+492Wmr5mNSw0V1mHIFi7TRmQZQZIrnLlA
        QyPkrG1CnCI1gy3//FQBinLlUW+BsB4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-Rra_508PPTmzmoVbi6CsZQ-1; Fri, 06 Mar 2020 03:47:08 -0500
X-MC-Unique: Rra_508PPTmzmoVbi6CsZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34389107ACCA;
        Fri,  6 Mar 2020 08:47:06 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 267F75DA76;
        Fri,  6 Mar 2020 08:47:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 09/14] arm/arm64: ITS: Device and
 collection Initialization
To:     Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-10-eric.auger@redhat.com>
 <20200207125140.656ctxlmk3d4au7g@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <4d7f5611-e8e1-c143-1f2b-074222fda4c4@redhat.com>
Date:   Fri, 6 Mar 2020 09:47:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200207125140.656ctxlmk3d4au7g@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 2/7/20 1:51 PM, Andrew Jones wrote:
> On Tue, Jan 28, 2020 at 11:34:54AM +0100, Eric Auger wrote:
>> Introduce an helper functions to register
>> - a new device, characterized by its device id and the
>>   max number of event IDs that dimension its ITT (Interrupt
>>   Translation Table).  The function allocates the ITT.
>>
>> - a new collection, characterized by its ID and the
>>   target processing engine (PE).
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - s/report_abort/assert
>>
>> v1 -> v2:
>> - s/nb_/nr_
>> ---
>>  lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++-
>>  lib/arm/gic-v3-its.c     | 44 ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> index fe73c04..acd97a9 100644
>> --- a/lib/arm/asm/gic-v3-its.h
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -31,6 +31,19 @@ struct its_baser {
>>  };
>>  
>>  #define GITS_BASER_NR_REGS              8
>> +#define GITS_MAX_DEVICES		8
>> +#define GITS_MAX_COLLECTIONS		8
>> +
>> +struct its_device {
>> +	u32 device_id;	/* device ID */
>> +	u32 nr_ites;	/* Max Interrupt Translation Entries */
>> +	void *itt;	/* Interrupt Translation Table GPA */
>> +};
>> +
>> +struct its_collection {
>> +	u64 target_address;
>> +	u16 col_id;
>> +};
>>  
>>  struct its_data {
>>  	void *base;
>> @@ -38,6 +51,10 @@ struct its_data {
>>  	struct its_baser baser[GITS_BASER_NR_REGS];
>>  	struct its_cmd_block *cmd_base;
>>  	struct its_cmd_block *cmd_write;
>> +	struct its_device devices[GITS_MAX_DEVICES];
>> +	u32 nr_devices;		/* Allocated Devices */
>> +	struct its_collection collections[GITS_MAX_COLLECTIONS];
>> +	u32 nr_collections;	/* Allocated Collections */
>>  };
>>  
>>  extern struct its_data its_data;
>> @@ -90,7 +107,6 @@ extern struct its_data its_data;
>>  #define GITS_BASER_TYPE_DEVICE		1
>>  #define GITS_BASER_TYPE_COLLECTION	4
>>  
>> -
>>  struct its_cmd_block {
>>  	u64 raw_cmd[4];
>>  };
>> @@ -100,6 +116,8 @@ extern void its_init(void);
>>  extern int its_parse_baser(int i, struct its_baser *baser);
>>  extern struct its_baser *its_lookup_baser(int type);
>>  extern void its_enable_defaults(void);
>> +extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
>> +extern struct its_collection *its_create_collection(u32 col_id, u32 target_pe);
>>  
>>  #else /* __arm__ */
>>  
>> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
>> index d1e7e52..c2dcd01 100644
>> --- a/lib/arm/gic-v3-its.c
>> +++ b/lib/arm/gic-v3-its.c
>> @@ -175,3 +175,47 @@ void its_enable_defaults(void)
>>  
>>  	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
>>  }
>> +
>> +struct its_device *its_create_device(u32 device_id, int nr_ites)
>> +{
>> +	struct its_baser *baser;
>> +	struct its_device *new;
>> +	unsigned long n, order;
>> +
>> +	assert(its_data.nr_devices < GITS_MAX_DEVICES);
>> +
>> +	baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
>> +	if (!baser)
>> +		return NULL;
> 
> Should we assert here if we can't find a GITS_BASER_TYPE_DEVICE ?
> It seems none of the callers of its_create_device are checking
> for null.
I removed that code which is useless.
> 
>> +
>> +	new = &its_data.devices[its_data.nr_devices];
>> +
>> +	new->device_id = device_id;
>> +	new->nr_ites = nr_ites;
>> +
>> +	n = (its_data.typer.ite_size * nr_ites) >> PAGE_SHIFT;
>> +	order = is_power_of_2(n) ? fls(n) : fls(n) + 1;
> 
> I've seen this calculation several times now, so I think an
> arch-neutral order calculator is in order:
> 
>  int get_order(size_t size);
> 
>> +	new->itt = (void *)virt_to_phys(alloc_pages(order));
I added this get_order helper in lib/alloc_page.h/c
> 
> If this is a physical address then shouldn't itt be phys_addr_t ?
> 
>> +
>> +	its_data.nr_devices++;
>> +	return new;
>> +}
ITT now is a GVA (void *).
>> +
>> +struct its_collection *its_create_collection(u32 col_id, u32 pe)
>> +{
>> +	struct its_collection *new;
>> +
>> +	assert(its_data.nr_collections < GITS_MAX_COLLECTIONS);
>> +
>> +	new = &its_data.collections[its_data.nr_collections];
>> +
>> +	new->col_id = col_id;
>> +
>> +	if (its_data.typer.pta)
>> +		new->target_address = (u64)gicv3_data.redist_base[pe];
>> +	else
>> +		new->target_address = pe << 16;
>> +
>> +	its_data.nr_collections++;
>> +	return new;
>> +}
>> -- 
>> 2.20.1
>>
> 
> Thanks,
> drew 
> 
Thanks

Eric

