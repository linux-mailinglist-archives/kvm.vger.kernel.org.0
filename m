Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C576EDC61
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfKDKW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:22:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20367 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726441AbfKDKW0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 05:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572862945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LLymiu9fDf2kNx9ndOTAz4HiICk3UlwgC5YYIufnvsQ=;
        b=Mf1redhX8uhDDUJoVULzDxzztIQ+VeTREaG9rKti5fueQ9Z/iVsDkcoZqFJ3EYVYet7JbM
        76DZ6euCY4W4xRSCFkvG9BX3QepjEl6E+RFcb+A8KGD+pKeTfAo2ZbS9Ebso/Rxf9gQBk2
        RxYeJqNxw2bLWId7h8RQxJyBC18eK0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-gsDzmFIpOJaURlOWot4KYQ-1; Mon, 04 Nov 2019 05:22:21 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CC8E800C73;
        Mon,  4 Nov 2019 10:22:20 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26141600C4;
        Mon,  4 Nov 2019 10:22:17 +0000 (UTC)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
 <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
 <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
 <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
 <20191101095016.0562fa76@p-imbrenda.boeblingen.de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <fe0f9eaa-6dde-1d53-67e3-000f9eb64bbc@redhat.com>
Date:   Mon, 4 Nov 2019 11:22:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191101095016.0562fa76@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: gsDzmFIpOJaURlOWot4KYQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.11.19 09:50, Claudio Imbrenda wrote:
> On Thu, 31 Oct 2019 18:30:30 +0100
> David Hildenbrand <david@redhat.com> wrote:
>=20
>> On 31.10.19 16:41, Christian Borntraeger wrote:
>>>
>>>
>>> On 25.10.19 10:49, David Hildenbrand wrote:
>>>> On 24.10.19 13:40, Janosch Frank wrote:
>>>>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>>
>>>>> Pin the guest pages when they are first accessed, instead of all
>>>>> at the same time when starting the guest.
>>>>
>>>> Please explain why you do stuff. Why do we have to pin the hole
>>>> guest memory? Why can't we mlock() the hole memory to avoid
>>>> swapping in user space?
>>>
>>> Basically we pin the guest for the same reason as AMD did it for
>>> their SEV. It is hard
>>
>> Pinning all guest memory is very ugly. What you want is "don't page",
>> what you get is unmovable pages all over the place. I was hoping that
>> you could get around this by having an automatic back-and-forth
>> conversion in place (due to the special new exceptions).
>=20
> we're not pinning all of guest memory, btw, but only the pages that are
> actually used.

Any longer-running guest will eventually touch all guest physical memory=20
(e.g., page cache, page shuffling), so this is only an optimization for=20
short running guests.

--=20

Thanks,

David / dhildenb

