Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4B83EA734
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbhHLPM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231392AbhHLPM6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 11:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628781153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QDxZXTIpTkSWXOwwbmUOwQM8t3jJ+z44eFSGMx58n2k=;
        b=Pw1DMEZqDt5AA0bJu0+kXQ8bsiiKzNG35PbBqJEPt1qlerR1JJNLhWj3JjO2nSiiFragxw
        4xLISMyOfc/CcxicVYJr6O1FznhSgN8bNe6btounfwxHw/Ajo9GISmwMAVCrgK4e8ZKQi5
        z6NGC60MU66SkcUwCmQJHVSmQUJIfME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-R1EPMqiGMYOL0ry8BjKPVw-1; Thu, 12 Aug 2021 11:12:31 -0400
X-MC-Unique: R1EPMqiGMYOL0ry8BjKPVw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A494987D545;
        Thu, 12 Aug 2021 15:12:30 +0000 (UTC)
Received: from localhost (unknown [10.39.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E98C610016F7;
        Thu, 12 Aug 2021 15:12:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x: lib: Add SCLP toplogy
 nested level
In-Reply-To: <08c479b7-491a-3f21-c869-d7a76a3af4e5@linux.ibm.com>
Organization: Red Hat GmbH
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
 <87czqivn1q.fsf@redhat.com>
 <08c479b7-491a-3f21-c869-d7a76a3af4e5@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 12 Aug 2021 17:12:25 +0200
Message-ID: <87a6lmvgrq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 8/12/21 2:56 PM, Cornelia Huck wrote:
>> On Tue, Aug 10 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:
>> 
>>> The maximum CPU Topology nested level is available with the SCLP
>>> READ_INFO command inside the byte at offset 15 of the ReadInfo
>>> structure.
>>>
>>> Let's return this information to check the number of topology nested
>>> information available with the STSI 15.1.x instruction.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>   lib/s390x/sclp.c | 6 ++++++
>>>   lib/s390x/sclp.h | 4 +++-
>>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>> index 9502d161..ee379ddf 100644
>>> --- a/lib/s390x/sclp.c
>>> +++ b/lib/s390x/sclp.c
>>> @@ -123,6 +123,12 @@ int sclp_get_cpu_num(void)
>>>   	return read_info->entries_cpu;
>>>   }
>>>   
>>> +int sclp_get_stsi_parm(void)
>>> +{
>>> +	assert(read_info);
>>> +	return read_info->stsi_parm;
>> 
>> Is this a generic "stsi parm", or always the concrete topology nested
>> level? IOW, is that name good, or too generic?
>
> It is the name used in the documentation, but for now only the 3 bits 
> 5-7 are used for the maximum value of the selector 2 of the STSI 
> instruction allowed by the machine.

Ok.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

