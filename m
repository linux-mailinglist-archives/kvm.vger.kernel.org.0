Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F003731E64C
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 07:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhBRGZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 01:25:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbhBRGTH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 01:19:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613629053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRHtiUiCejhIuIq1xGel/12yHmBvxj9ugZ5iQQk0OWY=;
        b=M3qsEeDPPommeZWsdLTt6fNgexGyKx9rzstyljnufR55TU58Ir6SesnvZ4Bi8b1uA6akXh
        z23Kg4ces3zYsURTl3LJ7GvyTEYbmfNZJPblfvIPU+KL1QQRNcGbe9iPFLySQLIlgZy5FW
        veEPAx+pdqZk4E+szQ38rUhydXawXss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-wqXOOhT3OsGvPgVrao7S0g-1; Thu, 18 Feb 2021 01:17:30 -0500
X-MC-Unique: wqXOOhT3OsGvPgVrao7S0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DB8E8030B7;
        Thu, 18 Feb 2021 06:17:29 +0000 (UTC)
Received: from [10.72.13.28] (ovpn-13-28.pek2.redhat.com [10.72.13.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABEBD5C730;
        Thu, 18 Feb 2021 06:17:24 +0000 (UTC)
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for KVM_SET_IOREGION
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
References: <cover.1611850290.git.eafanasova@gmail.com>
 <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
 <a3794e77-54ec-7866-35ba-c3d8a3908aa6@redhat.com>
 <20210209145932.GB92126@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c39c5d1a-9977-03a5-689a-ba5de3997fd3@redhat.com>
Date:   Thu, 18 Feb 2021 14:17:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209145932.GB92126@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/9 下午10:59, Stefan Hajnoczi wrote:
> On Mon, Feb 08, 2021 at 02:21:35PM +0800, Jason Wang wrote:
>> On 2021/1/30 上午2:48, Elena Afanasova wrote:
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index ca41220b40b8..81e775778c66 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
>>>    	__u8  pad[36];
>>>    };
>>> +enum {
>>> +	kvm_ioregion_flag_nr_pio,
>>> +	kvm_ioregion_flag_nr_posted_writes,
>>> +	kvm_ioregion_flag_nr_max,
>>> +};
>>> +
>>> +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
>>> +#define KVM_IOREGION_POSTED_WRITES (1 << kvm_ioregion_flag_nr_posted_writes)
>>> +
>>> +#define KVM_IOREGION_VALID_FLAG_MASK ((1 << kvm_ioregion_flag_nr_max) - 1)
>>> +
>>> +struct kvm_ioregion {
>>> +	__u64 guest_paddr; /* guest physical address */
>>> +	__u64 memory_size; /* bytes */
>>
>> Do we really need __u64 here?
> I think 64-bit PCI BARs can be >4 GB. There is plenty of space in this
> struct to support a 64-bit field.
>
> That said, userspace could also add more ioregions if it needs to cover
> more than 4 GB. That would slow down ioregion lookups though since the
> in-kernel data structure would become larger.
>
> Making it 64-bit seems more future-proof and cleaner than having to work
> around the limitation using multiple ioregions. Did you have a
> particular reason in mind why this field should not be 64 bits?


Nope. Just wonder what's the use case for that.

Thanks


