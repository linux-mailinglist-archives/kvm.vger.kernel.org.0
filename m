Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DB4EDC80
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfKDK15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:27:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727236AbfKDK15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572863275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muLOkR11BEfb//VoVib3C5pn7Y2Cv3dk5IhFzAlm7u0=;
        b=HTVMYWb18gZyeYRySfb2uwmVrgj4+vUUmAkhkDK1d5vvmMebC04+PRgG44JIJLwwg+pIXN
        YaWIP7cqFjxXwonWvPb/RpnDhvuGEBh4XsmDrsVLn5Q8tVn+2kGNSHwYfiSPrWX/eErufk
        7a3F+GGDqMe/coeKhhotWe6n9t22e3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-gNyc4lcsNPaQJIAGuSjwvg-1; Mon, 04 Nov 2019 05:27:50 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 217581800D53;
        Mon,  4 Nov 2019 10:27:49 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 091676085E;
        Mon,  4 Nov 2019 10:27:46 +0000 (UTC)
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
 <84bd87f0-37bf-caa8-5762-d8da58f37a8f@redhat.com>
 <5a630f24-4d17-7844-e4e7-d3ab1c8507a4@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <a1dc5a6f-48f5-6c6a-3a87-46b033cd9d13@redhat.com>
Date:   Mon, 4 Nov 2019 11:27:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <5a630f24-4d17-7844-e4e7-d3ab1c8507a4@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: gNyc4lcsNPaQJIAGuSjwvg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 11:25, Janosch Frank wrote:
> On 11/4/19 11:19 AM, David Hildenbrand wrote:
>>>>> to synchronize page import/export with the I/O for paging. For exampl=
e you can actually
>>>>> fault in a page that is currently under paging I/O. What do you do? i=
mport (so that the
>>>>> guest can run) or export (so that the I/O will work). As this turned =
out to be harder then
>>>>> we though we decided to defer paging to a later point in time.
>>>>
>>>> I don't quite see the issue yet. If you page out, the page will
>>>> automatically (on access) be converted to !secure/encrypted memory. If
>>>> the UV/guest wants to access it, it will be automatically converted to
>>>> secure/unencrypted memory. If you have concurrent access, it will be
>>>> converted back and forth until one party is done.
>>>
>>> IO does not trigger an export on an imported page, but an error
>>> condition in the IO subsystem. The page code does not read pages throug=
h
>>
>> Ah, that makes it much clearer. Thanks!
>>
>>> the cpu, but often just asks the device to read directly and that's
>>> where everything goes wrong. We could bounce swapping, but chose to pin
>>> for now until we find a proper solution to that problem which nicely
>>> integrates into linux.
>>
>> How hard would it be to
>>
>> 1. Detect the error condition
>> 2. Try a read on the affected page from the CPU (will will automatically
>> convert to encrypted/!secure)
>> 3. Restart the I/O
>>
>> I assume that this is a corner case where we don't really have to care
>> about performance in the first shot.
>=20
> Restarting IO can be quite difficult with CCW, we might need to change
> request data...

I am no I/O expert, so I can't comment if that would be possible :(


>>>> A proper automatic conversion should make this work. What am I missing=
?
>>>>
>>>>>
>>>>> As we do not want to rely on the userspace to do the mlock this is no=
w done in the kernel.
>>>>
>>>> I wonder if we could come up with an alternative (similar to how we
>>>> override VM_MERGEABLE in the kernel) that can be called and ensured in
>>>> the kernel. E.g., marking whole VMAs as "don't page" (I remember
>>>> something like "special VMAs" like used for VDSOs that achieve exactly
>>>> that, but I am absolutely no expert on that). That would be much nicer
>>>> than pinning all pages and remembering what you pinned in huge page
>>>> arrays ...
>>>
>>> It might be more worthwhile to just accept one or two releases with
>>> pinning and fix the root of the problem than design a nice stopgap.
>>
>> Quite honestly, to me this feels like a prototype hack that deserves a
>> proper solution first. The issue with this hack is that it affects user
>> space (esp. MADV_DONTNEED no longer working correctly). It's not just
>> something you once fix in the kernel and be done with it.
>=20
> It is a hack, yes.
> But we're not the only architecture to need it x86 pins all the memory
> at the start of the VM and that code is already upstream...

IMHO that doesn't make it any better. It is and remains a prototype hack=20
in my opinion.

--=20

Thanks,

David / dhildenb

