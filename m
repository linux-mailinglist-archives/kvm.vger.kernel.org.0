Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96135113BF0
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 07:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfLEGv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 01:51:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58398 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725905AbfLEGv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 01:51:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575528688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+DU3T5dQyNYaNnp2KSExVI3M/SSBxmIkMbbcIbwNecU=;
        b=Gw8ND8PkMYA5bghbamyW+DcXMQjnu3luguFp2WTAmNOaVgPheH8v7P9ab3JbEMeZH8Y/gf
        tSU/VDJCtA3MHLqxuoXEoCh1KfHyxrtWIdPFVGU5TjQoQydjq/03lHQinIUNmLpVnjBNR8
        G3VsI+Y4JXLXcpMIq98cSm+IQi+EAKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-WWP2KC1HNgCn_njLjEo2vg-1; Thu, 05 Dec 2019 01:51:27 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13365800D4C;
        Thu,  5 Dec 2019 06:51:26 +0000 (UTC)
Received: from [10.72.12.247] (ovpn-12-247.pek2.redhat.com [10.72.12.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A44CE19481;
        Thu,  5 Dec 2019 06:51:17 +0000 (UTC)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191204195230.GF19939@xz-x1>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <efa1523f-2cff-8d65-7b43-4a19eff89051@redhat.com>
Date:   Thu, 5 Dec 2019 14:51:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191204195230.GF19939@xz-x1>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: WWP2KC1HNgCn_njLjEo2vg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/5 =E4=B8=8A=E5=8D=883:52, Peter Xu wrote:
> On Wed, Dec 04, 2019 at 12:04:53PM +0100, Paolo Bonzini wrote:
>> On 04/12/19 11:38, Jason Wang wrote:
>>>> +=C2=A0=C2=A0=C2=A0 entry =3D &ring->dirty_gfns[ring->dirty_index & (r=
ing->size - 1)];
>>>> +=C2=A0=C2=A0=C2=A0 entry->slot =3D slot;
>>>> +=C2=A0=C2=A0=C2=A0 entry->offset =3D offset;
>>>
>>> Haven't gone through the whole series, sorry if it was a silly question
>>> but I wonder things like this will suffer from similar issue on
>>> virtually tagged archs as mentioned in [1].
>> There is no new infrastructure to track the dirty pages---it's just a
>> different way to pass them to userspace.
>>
>>> Is this better to allocate the ring from userspace and set to KVM
>>> instead? Then we can use copy_to/from_user() friends (a little bit slow
>>> on recent CPUs).
>> Yeah, I don't think that would be better than mmap.
> Yeah I agree, because I didn't see how copy_to/from_user() helped to
> do icache/dcache flushings...


It looks to me one advantage is that exact the same VA is used by both=20
userspace and kernel so there will be no alias.

Thanks


>
> Some context here: Jason raised this question offlist first on whether
> we should also need these flush_dcache_cache() helpers for operations
> like kvm dirty ring accesses.  I feel like it should, however I've got
> two other questions, on:
>
>    - if we need to do flush_dcache_page() on kernel modified pages
>      (assuming the same page has mapped to userspace), then why don't
>      we need flush_cache_page() too on the page, where
>      flush_cache_page() is defined not-a-nop on those archs?
>
>    - assuming an arch has not-a-nop impl for flush_[d]cache_page(),
>      would atomic operations like cmpxchg really work for them
>      (assuming that ISAs like cmpxchg should depend on cache
>      consistency).
>
> Sorry I think these are for sure a bit out of topic for kvm dirty ring
> patchset, but since we're at it, I'm raising the questions up in case
> there're answers..
>
> Thanks,
>

