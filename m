Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1311EB61C
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 09:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgFBHE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 03:04:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25403 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgFBHEy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 03:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591081493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/iZrp8ajGOLBLXyeyKCmBTwZzJz+NsPsDgLUvIijOo=;
        b=EEBs0WKPRzJ4HCGK5INUHoFoLEdK2269Oi2WSbG6esIwuOFd/urvT9GeRDla5oyL0RdvyN
        CXtzaFR0x0Ha3h8VCbtvtklD47c26RREliPA9sjlqN1h1L0ZTtXax9GyGptk1/kVK4HAYH
        GPenio1zpSZXh4rMWdud3mjGoOVD1Kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-g0qtxZAyOOqho9Wf4GolhQ-1; Tue, 02 Jun 2020 03:04:49 -0400
X-MC-Unique: g0qtxZAyOOqho9Wf4GolhQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACEC3464;
        Tue,  2 Jun 2020 07:04:47 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F07E5C1D6;
        Tue,  2 Jun 2020 07:04:19 +0000 (UTC)
Subject: Re: [PATCH 1/6] vhost: allow device that does not depend on vhost
 worker
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-2-jasowang@redhat.com>
 <20200602005904-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <21e1bfbf-4b0c-5a73-6fdd-a58c43c733ea@redhat.com>
Date:   Tue, 2 Jun 2020 15:04:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602005904-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/6/2 下午1:01, Michael S. Tsirkin wrote:
> On Fri, May 29, 2020 at 04:02:58PM +0800, Jason Wang wrote:
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index d450e16c5c25..70105e045768 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -166,11 +166,16 @@ static int vhost_poll_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync,
>>   			     void *key)
>>   {
>>   	struct vhost_poll *poll = container_of(wait, struct vhost_poll, wait);
>> +	struct vhost_work *work = &poll->work;
>>   
>>   	if (!(key_to_poll(key) & poll->mask))
>>   		return 0;
>>   
>> -	vhost_poll_queue(poll);
>> +	if (!poll->dev->use_worker)
>> +		work->fn(work);
>> +	else
>> +		vhost_poll_queue(poll);
>> +
>>   	return 0;
>>   }
>>
> So a wakeup function wakes up eventfd directly.
>
> What if user supplies e.g. the same eventfd as ioeventfd?
>
> Won't this cause infinite loops?


I'm not sure I get this.

This basically calls handle_vq directly when eventfd is woken up. The 
infinite loops can only happen when handle_vq() tries to write to 
ioeventfd itslef which should be a bug of the device.

Thanks


>

