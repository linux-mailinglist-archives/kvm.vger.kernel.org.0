Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEBA2E902E
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 06:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbhADFi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 00:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727740AbhADFi5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 00:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609738651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iOL2OUOk4IJKETaoW+6g8PoYWJiORbk8mBDrcZMi3t8=;
        b=O1CvDSzr+UW0dAee0p5HFwQOPCQXs6DYNaFQto5+szRzWPHXGjh7KoKx7BSmAFYfc8deIY
        i/h5/H7bOo1ALVnrkdhwUfkpOLIZBDfro0X2VBRuOeLH9i/U6UHt1LCfle1RB+M5j/3Job
        k1tpmUuRwCilK0ryU3QfYx8BJFv4Jts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-6X9DrehoMriwAPMs0wq6Kg-1; Mon, 04 Jan 2021 00:37:27 -0500
X-MC-Unique: 6X9DrehoMriwAPMs0wq6Kg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E86391800D41;
        Mon,  4 Jan 2021 05:37:25 +0000 (UTC)
Received: from [10.72.13.91] (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AA065FC29;
        Mon,  4 Jan 2021 05:37:20 +0000 (UTC)
Subject: Re: [RFC 2/2] KVM: add initial support for ioregionfd blocking
 read/write operations
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
References: <cover.1609231373.git.eafanasova@gmail.com>
 <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
 <72556405-8501-26bc-4939-69e312857e91@redhat.com>
 <90e04958a3f57bbc1b0fcee4810942f031640a05.camel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9c1a10a5-2863-02af-bd9f-8a7b77f7e382@redhat.com>
Date:   Mon, 4 Jan 2021 13:37:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <90e04958a3f57bbc1b0fcee4810942f031640a05.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/4 上午4:37, Elena Afanasova wrote:
> On Thu, 2020-12-31 at 11:46 +0800, Jason Wang wrote:
>> On 2020/12/29 下午6:02, Elena Afanasova wrote:
>>> Signed-off-by: Elena Afanasova<eafanasova@gmail.com>
>>> ---
>>>    virt/kvm/ioregion.c | 157
>>> ++++++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 157 insertions(+)
>>>
>>> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
>>> index a200c3761343..8523f4126337 100644
>>> --- a/virt/kvm/ioregion.c
>>> +++ b/virt/kvm/ioregion.c
>>> @@ -4,6 +4,33 @@
>>>    #include <kvm/iodev.h>
>>>    #include "eventfd.h"
>>>    
>>> +/* Wire protocol */
>>> +struct ioregionfd_cmd {
>>> +	__u32 info;
>>> +	__u32 padding;
>>> +	__u64 user_data;
>>> +	__u64 offset;
>>> +	__u64 data;
>>> +};
>>> +
>> I wonder do we need a seq in the protocol. It might be useful if we
>> allow a pair of file descriptors to be used for multiple different
>> ranges.
>>
> I think it might be helpful in the case of out-of-order requests.
> In the case of in order requests seq field seems not to be necessary
> since there will be cmds/replies serialization. I’ll include the
> synchronization code in a RFC v2 series.


See my reply to V1. It might be helpful for the case of using single 
ioregionfd for multiple ranges.

Thanks


>
>> Thanks
>>
>>
>>> +struct ioregionfd_resp {
>>> +	__u64 data;
>>> +	__u8 pad[24];
>>> +};

