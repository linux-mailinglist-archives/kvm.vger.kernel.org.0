Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23597EDC56
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfKDKTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:19:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47839 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727419AbfKDKTM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 05:19:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572862751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OQmuTzvK0kauEjAiX2TIjBp+3C2Io50adAm181rzj3s=;
        b=Uky1zfdvzZ/TGAmhvQtatH/YY5xtTk9sNRNx0jq+Fs8pq9HdOXK0h7WhF0+Yg5N4zc3Tyx
        xOon6nw4W2CUPGY1orW/U85CJgJJhScxVKTzYwgAh+rT8IVNMw2rG0HSBqlY7APVh9vFpo
        WhdnLxnPMVp2+00/355qt2YJ1p/WWCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-xtIxTS1nNDeF1KavHaSo6g-1; Mon, 04 Nov 2019 05:19:07 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CBE21800D53;
        Mon,  4 Nov 2019 10:19:06 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F0275D9CD;
        Mon,  4 Nov 2019 10:19:01 +0000 (UTC)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
 <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
 <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
 <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
 <2a7c4644-d718-420a-9bd7-723baccfb302@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <84bd87f0-37bf-caa8-5762-d8da58f37a8f@redhat.com>
Date:   Mon, 4 Nov 2019 11:19:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <2a7c4644-d718-420a-9bd7-723baccfb302@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: xtIxTS1nNDeF1KavHaSo6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> to synchronize page import/export with the I/O for paging. For example =
you can actually
>>> fault in a page that is currently under paging I/O. What do you do? imp=
ort (so that the
>>> guest can run) or export (so that the I/O will work). As this turned ou=
t to be harder then
>>> we though we decided to defer paging to a later point in time.
>>
>> I don't quite see the issue yet. If you page out, the page will
>> automatically (on access) be converted to !secure/encrypted memory. If
>> the UV/guest wants to access it, it will be automatically converted to
>> secure/unencrypted memory. If you have concurrent access, it will be
>> converted back and forth until one party is done.
>=20
> IO does not trigger an export on an imported page, but an error
> condition in the IO subsystem. The page code does not read pages through

Ah, that makes it much clearer. Thanks!

> the cpu, but often just asks the device to read directly and that's
> where everything goes wrong. We could bounce swapping, but chose to pin
> for now until we find a proper solution to that problem which nicely
> integrates into linux.

How hard would it be to

1. Detect the error condition
2. Try a read on the affected page from the CPU (will will automatically=20
convert to encrypted/!secure)
3. Restart the I/O

I assume that this is a corner case where we don't really have to care=20
about performance in the first shot.

>=20
>>
>> A proper automatic conversion should make this work. What am I missing?
>>
>>>
>>> As we do not want to rely on the userspace to do the mlock this is now =
done in the kernel.
>>
>> I wonder if we could come up with an alternative (similar to how we
>> override VM_MERGEABLE in the kernel) that can be called and ensured in
>> the kernel. E.g., marking whole VMAs as "don't page" (I remember
>> something like "special VMAs" like used for VDSOs that achieve exactly
>> that, but I am absolutely no expert on that). That would be much nicer
>> than pinning all pages and remembering what you pinned in huge page
>> arrays ...
>=20
> It might be more worthwhile to just accept one or two releases with
> pinning and fix the root of the problem than design a nice stopgap.

Quite honestly, to me this feels like a prototype hack that deserves a=20
proper solution first. The issue with this hack is that it affects user=20
space (esp. MADV_DONTNEED no longer working correctly). It's not just=20
something you once fix in the kernel and be done with it.
>=20
> Btw. s390 is not alone with the problem and we'll try to have another
> discussion tomorrow with AMD to find a solution which works for more
> than one architecture.

Let me know if there was an interesting outcome.

--=20

Thanks,

David / dhildenb

