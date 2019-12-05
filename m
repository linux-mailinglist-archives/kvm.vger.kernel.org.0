Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C372114143
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 14:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfLENNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 08:13:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729099AbfLENNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 08:13:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575551602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6r1mJ8nXQoZMPn6qaVxM4ay08sZZBHL2nKfUet71uGI=;
        b=CQSeaQfZl5gAIc1EqpIMcq9B09Bn/uRpwPMSPXX77Rl45s2kOe0M1aLSdI11TPNSUakJqT
        z+jX2eAbOMth1S+51fa7kCBj+Jeum5IrOXtVYWqSKmvVWKhqa8RoVliCqhEy8FUUelOYcL
        v5Fcd9tIpkx46DAIK6JXtQVgHXwPDkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-hAnpWs5TOLifaQ46gRFRJg-1; Thu, 05 Dec 2019 08:13:21 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64A4F1005502;
        Thu,  5 Dec 2019 13:13:20 +0000 (UTC)
Received: from [10.72.12.247] (ovpn-12-247.pek2.redhat.com [10.72.12.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26B635D9C5;
        Thu,  5 Dec 2019 13:13:01 +0000 (UTC)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191204195230.GF19939@xz-x1>
 <efa1523f-2cff-8d65-7b43-4a19eff89051@redhat.com>
 <20191205120800.GA9673@xz-x1>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4d3e6552-8cbd-a644-b418-2605e637834f@redhat.com>
Date:   Thu, 5 Dec 2019 21:12:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191205120800.GA9673@xz-x1>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: hAnpWs5TOLifaQ46gRFRJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/5 =E4=B8=8B=E5=8D=888:08, Peter Xu wrote:
> On Thu, Dec 05, 2019 at 02:51:15PM +0800, Jason Wang wrote:
>> On 2019/12/5 =E4=B8=8A=E5=8D=883:52, Peter Xu wrote:
>>> On Wed, Dec 04, 2019 at 12:04:53PM +0100, Paolo Bonzini wrote:
>>>> On 04/12/19 11:38, Jason Wang wrote:
>>>>>> +=C2=A0=C2=A0=C2=A0 entry =3D &ring->dirty_gfns[ring->dirty_index & =
(ring->size - 1)];
>>>>>> +=C2=A0=C2=A0=C2=A0 entry->slot =3D slot;
>>>>>> +=C2=A0=C2=A0=C2=A0 entry->offset =3D offset;
>>>>> Haven't gone through the whole series, sorry if it was a silly questi=
on
>>>>> but I wonder things like this will suffer from similar issue on
>>>>> virtually tagged archs as mentioned in [1].
>>>> There is no new infrastructure to track the dirty pages---it's just a
>>>> different way to pass them to userspace.
>>>>
>>>>> Is this better to allocate the ring from userspace and set to KVM
>>>>> instead? Then we can use copy_to/from_user() friends (a little bit sl=
ow
>>>>> on recent CPUs).
>>>> Yeah, I don't think that would be better than mmap.
>>> Yeah I agree, because I didn't see how copy_to/from_user() helped to
>>> do icache/dcache flushings...
>>
>> It looks to me one advantage is that exact the same VA is used by both
>> userspace and kernel so there will be no alias.
> Hmm.. but what if the page is mapped more than once in user?  Thanks,


Then it's the responsibility of userspace program to do the flush I think.

Thanks

>

