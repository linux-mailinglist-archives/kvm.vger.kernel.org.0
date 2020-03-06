Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD2D17BBA8
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 12:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgCFL2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 06:28:50 -0500
Received: from foss.arm.com ([217.140.110.172]:59936 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgCFL2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 06:28:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCAE731B;
        Fri,  6 Mar 2020 03:28:49 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1AB73F6C4;
        Fri,  6 Mar 2020 03:28:48 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 16/30] Don't ignore errors registering a
 device, ioport or mmio emulation
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-17-alexandru.elisei@arm.com>
 <20200130145156.3437ea6c@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a0d25a48-8fb5-7eb2-4dd6-14fa35728580@arm.com>
Date:   Fri, 6 Mar 2020 11:28:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200130145156.3437ea6c@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/30/20 2:51 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:51 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> An error returned by device__register, kvm__register_mmio and
>> ioport__register means that the device will
>> not be emulated properly. Annotate the functions with __must_check, so we
>> get a compiler warning when this error is ignored.
>>
>> And fix several instances where the caller returns 0 even if the
>> function failed.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Looks alright, one minor nit below, with that fixed:
>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>

[..]

>> diff --git a/ioport.c b/ioport.c
>> index a72e4035881a..d224819c6e43 100644
>> --- a/ioport.c
>> +++ b/ioport.c
>> @@ -91,16 +91,21 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
>>  	};
>>  
>>  	r = ioport_insert(&ioport_tree, entry);
>> -	if (r < 0) {
>> -		free(entry);
>> -		br_write_unlock(kvm);
>> -		return r;
>> -	}
>> -
>> -	device__register(&entry->dev_hdr);
>> +	if (r < 0)
>> +		goto out_free;
>> +	r = device__register(&entry->dev_hdr);
>> +	if (r < 0)
>> +		goto out_erase;
>>  	br_write_unlock(kvm);
>>  
>>  	return port;
>> +
>> +out_erase:
>> +	rb_int_erase(&ioport_tree, &entry->node);
> To keep the abstraction, shouldn't that rather be ioport_remove() instead?

ioport__register already uses rb_int_erase to remove a node (at the beginning, if
the requested port is already allocated). But you're right, it should use
ioport_remove in both cases, like ioport__unregister{,_all} does.

Thanks,
Alex
