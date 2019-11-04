Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B5EEE2C5
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfKDOmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:42:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42325 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728321AbfKDOmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 09:42:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572878541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/hSgM7HsKsQD8PfkIMz0SRCUEy0RHMIGBFVNz7s3MA=;
        b=E+lOn4XNBQxHuc/ZqXqikey1LEiSySbzc/ttaVVbPeaCgt8U4Memy1YAxo7fnjvhdjoB7X
        +nIDvgFfSDwj/fQ0JcBFExtq6Z+eWaVmqqyfFaJgCB5CfoUoNXclhhNVXsQmcX+8EESJDo
        iYBSpftDF+ShZJM7x3/bl3JS83Jl1kI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-rS3O_QJeM62VlGA1e7hrNQ-1; Mon, 04 Nov 2019 09:42:18 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BACE31800D53;
        Mon,  4 Nov 2019 14:42:16 +0000 (UTC)
Received: from [10.36.117.96] (ovpn-117-96.ams2.redhat.com [10.36.117.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E11E600CC;
        Mon,  4 Nov 2019 14:42:12 +0000 (UTC)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
From:   David Hildenbrand <david@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
 <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
 <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
 <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
 <2a7c4644-d718-420a-9bd7-723baccfb302@linux.ibm.com>
 <84bd87f0-37bf-caa8-5762-d8da58f37a8f@redhat.com>
 <69ddb6a7-8f69-fbc4-63a4-4f5695117078@de.ibm.com>
 <1fad0466-1eeb-7d24-8015-98af9b564f74@redhat.com>
Organization: Red Hat GmbH
Message-ID: <8a68fcbb-1dea-414f-7d48-e4647f7985fe@redhat.com>
Date:   Mon, 4 Nov 2019 15:42:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1fad0466-1eeb-7d24-8015-98af9b564f74@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: rS3O_QJeM62VlGA1e7hrNQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 15:08, David Hildenbrand wrote:
> On 04.11.19 14:58, Christian Borntraeger wrote:
>>
>>
>> On 04.11.19 11:19, David Hildenbrand wrote:
>>>>>> to synchronize page import/export with the I/O for paging. For examp=
le you can actually
>>>>>> fault in a page that is currently under paging I/O. What do you do? =
import (so that the
>>>>>> guest can run) or export (so that the I/O will work). As this turned=
 out to be harder then
>>>>>> we though we decided to defer paging to a later point in time.
>>>>>
>>>>> I don't quite see the issue yet. If you page out, the page will
>>>>> automatically (on access) be converted to !secure/encrypted memory. I=
f
>>>>> the UV/guest wants to access it, it will be automatically converted t=
o
>>>>> secure/unencrypted memory. If you have concurrent access, it will be
>>>>> converted back and forth until one party is done.
>>>>
>>>> IO does not trigger an export on an imported page, but an error
>>>> condition in the IO subsystem. The page code does not read pages throu=
gh
>>>
>>> Ah, that makes it much clearer. Thanks!
>>>
>>>> the cpu, but often just asks the device to read directly and that's
>>>> where everything goes wrong. We could bounce swapping, but chose to pi=
n
>>>> for now until we find a proper solution to that problem which nicely
>>>> integrates into linux.
>>>
>>> How hard would it be to
>>>
>>> 1. Detect the error condition
>>> 2. Try a read on the affected page from the CPU (will will automaticall=
y convert to encrypted/!secure)
>>> 3. Restart the I/O
>>>
>>> I assume that this is a corner case where we don't really have to care =
about performance in the first shot.
>>
>> We have looked into this. You would need to implement this in the low le=
vel
>> handler for every I/O. DASD, FCP, PCI based NVME, iscsi. Where do you wa=
nt
>> to stop?
>=20
> If that's the real fix, we should do that. Maybe one can focus on the
> real use cases first. But I am no I/O expert, so my judgment might be
> completely wrong.
>=20

Oh, and by the way, as discussed you really only have to care about=20
accesses via "real" I/O devices (IOW, not via the CPU). When accessing=20
via the CPU, you should have automatic conversion back and forth. As I=20
am no expert on I/O, I have no idea how iscsi fits into this picture=20
here (especially on s390x).

--=20

Thanks,

David / dhildenb

