Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0FC11C392
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfLLCt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 21:49:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60984 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727809AbfLLCt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 21:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576118998;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=URfNiMbEy5/1EnumIy4tV354rY6ao2mpANww7PqAfEU=;
        b=ca6fK2zOWKk9YwLj3/JcrR0oOwXRyXuslqHO4f4nL2MBgf3YF7Su7ja2ehRj480pwKNxgt
        z6jeO2DivQsg9hDEkex5EvtRt3/s8tkVihMg7wjX2klSOiCykEzl8E4oWEkCoxcUAZ1aqF
        YH4GVdPNZnh/i1D7MpzZ7ymuUgtxU5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-a60TPygzPqmbMJSTcavemw-1; Wed, 11 Dec 2019 21:49:55 -0500
X-MC-Unique: a60TPygzPqmbMJSTcavemw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADA2D107ACC5
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 02:49:54 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-40.bne.redhat.com [10.64.54.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8E066609A;
        Thu, 12 Dec 2019 02:49:50 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] tools/kvm_stat: Fix kvm_exit filter name
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com
References: <20191210044829.180122-1-gshan@redhat.com>
 <871rtcd0wo.fsf@vitty.brq.redhat.com>
 <9159a786-6a5f-e8be-33b8-19a765cedd68@redhat.com>
 <87y2vjawht.fsf@vitty.brq.redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <d2107575-ce05-e8c6-17d6-f7ef839266bf@redhat.com>
Date:   Thu, 12 Dec 2019 13:49:48 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87y2vjawht.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/19 11:15 PM, Vitaly Kuznetsov wrote:
> Gavin Shan <gshan@redhat.com> writes:
> 
>> On 12/10/19 7:45 PM, Vitaly Kuznetsov wrote:
>>> Gavin Shan <gshan@redhat.com> writes:
>>>
>>>> The filter name is fixed to "exit_reason" for some kvm_exit events, no
>>>> matter what architect we have. Actually, the filter name ("exit_reason")
>>>> is only applicable to x86, meaning it's broken on other architects
>>>> including aarch64.
>>>>
>>>> This fixes the issue by providing various kvm_exit filter names, depending
>>>> on architect we're on. Afterwards, the variable filter name is picked and
>>>> applied through ioctl(fd, SET_FILTER).
>>>
>>> Would it actually make sense to standardize (to certain extent) kvm_exit
>>> tracepoints instead?
>>>
>>
>> Yes, It makes sense, but it's something for future if you agree. Besides,
>> It seems that other kvm tracepoints need standardization either.
> 
> If we change kvm_stat the way you suggest we'll have reverse issues
> after changing tracepoints fields: updated kvm_stat won't work with the
> fixed kernel. I understand that kvm_stat doesn't have to work with
> anything but the corresponding kernel tree and so we can change it back
> in the same series, but wouldn't it be an unnecessary churn?
> 
> I'd suggest we standardize 'exit_reason' field name now just to fix the
> immediate issue, it shouldn't be a big change, probably the same size as
> this patch. Changing other tracepoints to match can be left for future
> generations :-) What do you say?
> 

Fair enough. A series of patches ("Standardize kvm exit reason field")
has been posted for review.

Regards,
Gavin

