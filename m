Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B306EE779
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 19:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfKDSii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 13:38:38 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727998AbfKDSih (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 13:38:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572892717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFWqR6y5kr5x8dSoxmtAiWOMS/fTMSEKD3OFl5F0zsU=;
        b=bQ03jHr7Yop8JnHk3p+NsQaJ3f2nrjXNsxypshoR856sQH4LyESQmJdaVt7rGWBWxTKTrp
        CzREm38XfMAXWF1bWKL7OPr2i55B4qEe6jA7WoeIe94N7QZnfB1jKelvvm6sCrlfYY1n9w
        p3yckUBuosTGUrCq1sD/2bTSH0eSj0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-jDyMq2_GO5uZvm3jDNUHaQ-1; Mon, 04 Nov 2019 13:38:33 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 984BE1005500;
        Mon,  4 Nov 2019 18:38:32 +0000 (UTC)
Received: from [10.36.117.96] (ovpn-117-96.ams2.redhat.com [10.36.117.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F6245D6C8;
        Mon,  4 Nov 2019 18:38:27 +0000 (UTC)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
 <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
 <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
 <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
 <2a7c4644-d718-420a-9bd7-723baccfb302@linux.ibm.com>
 <84bd87f0-37bf-caa8-5762-d8da58f37a8f@redhat.com>
 <69ddb6a7-8f69-fbc4-63a4-4f5695117078@de.ibm.com>
 <1fad0466-1eeb-7d24-8015-98af9b564f74@redhat.com>
 <8a68fcbb-1dea-414f-7d48-e4647f7985fe@redhat.com>
 <20191104181743.3792924a.cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <2c36b668-e6a7-4497-62da-f2be09350896@redhat.com>
Date:   Mon, 4 Nov 2019 19:38:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104181743.3792924a.cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: jDyMq2_GO5uZvm3jDNUHaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 18:17, Cornelia Huck wrote:
> On Mon, 4 Nov 2019 15:42:11 +0100
> David Hildenbrand <david@redhat.com> wrote:
>=20
>> On 04.11.19 15:08, David Hildenbrand wrote:
>>> On 04.11.19 14:58, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 04.11.19 11:19, David Hildenbrand wrote:
>>>>>>>> to synchronize page import/export with the I/O for paging. For exa=
mple you can actually
>>>>>>>> fault in a page that is currently under paging I/O. What do you do=
? import (so that the
>>>>>>>> guest can run) or export (so that the I/O will work). As this turn=
ed out to be harder then
>>>>>>>> we though we decided to defer paging to a later point in time.
>>>>>>>
>>>>>>> I don't quite see the issue yet. If you page out, the page will
>>>>>>> automatically (on access) be converted to !secure/encrypted memory.=
 If
>>>>>>> the UV/guest wants to access it, it will be automatically converted=
 to
>>>>>>> secure/unencrypted memory. If you have concurrent access, it will b=
e
>>>>>>> converted back and forth until one party is done.
>>>>>>
>>>>>> IO does not trigger an export on an imported page, but an error
>>>>>> condition in the IO subsystem. The page code does not read pages thr=
ough
>>>>>
>>>>> Ah, that makes it much clearer. Thanks!
>>>>>  =20
>>>>>> the cpu, but often just asks the device to read directly and that's
>>>>>> where everything goes wrong. We could bounce swapping, but chose to =
pin
>>>>>> for now until we find a proper solution to that problem which nicely
>>>>>> integrates into linux.
>>>>>
>>>>> How hard would it be to
>>>>>
>>>>> 1. Detect the error condition
>>>>> 2. Try a read on the affected page from the CPU (will will automatica=
lly convert to encrypted/!secure)
>>>>> 3. Restart the I/O
>>>>>
>>>>> I assume that this is a corner case where we don't really have to car=
e about performance in the first shot.
>>>>
>>>> We have looked into this. You would need to implement this in the low =
level
>>>> handler for every I/O. DASD, FCP, PCI based NVME, iscsi. Where do you =
want
>>>> to stop?
>>>
>>> If that's the real fix, we should do that. Maybe one can focus on the
>>> real use cases first. But I am no I/O expert, so my judgment might be
>>> completely wrong.
>>>   =20
>>
>> Oh, and by the way, as discussed you really only have to care about
>> accesses via "real" I/O devices (IOW, not via the CPU). When accessing
>> via the CPU, you should have automatic conversion back and forth. As I
>> am no expert on I/O, I have no idea how iscsi fits into this picture
>> here (especially on s390x).
>>
>=20
> By "real" I/O devices, you mean things like channel devices, right? (So
> everything where you basically hand off control to a different kind of
> processor.)
>=20
> For classic channel I/O (as used by dasd), I'd expect something like
> getting a check condition on a ccw if the CU or device cannot access
> the memory. You will know how far the channel program has progressed,
> and might be able to restart (from the beginning or from that point).
> Probably has a chance of working for a subset of channel programs.
>=20
> For QDIO (as used by FCP), I have no idea how this is could work, as we
> have long-running channel programs there and any error basically kills
> the queues, which you would have to re-setup from the beginning.
>=20
> For PCI devices, I have no idea how the instructions even act.
>=20
>  From my point of view, that error/restart approach looks nice on paper,
> but it seems hard to make it work in the general case (and I'm unsure
> if it's possible at all.)

One thought: If all we do during an I/O request is read or write (or=20
even a mixture), can we simply restart the whole I/O again, although we=20
did partial reads/writes? This would eliminate the "know how far the=20
channel program has progressed". On error, one would have to touch each=20
involved page (e.g., try to read first byte to trigger a conversion) and=20
restart the I/O. I can understand that this might sound simpler than it=20
is (if it is even possible) and might still be problematic for QDIO as=20
far as I understand. Just a thought.


--=20

Thanks,

David / dhildenb

