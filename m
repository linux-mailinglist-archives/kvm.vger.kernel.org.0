Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA301113BED
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 07:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfLEGtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 01:49:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23301 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725905AbfLEGtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 01:49:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575528582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PN2kaQNnGa1We4eEVYDGchvloPKew2Z0oPxF8rZIDrk=;
        b=Fn2cowhJkJVDo34R4ijjBG34Rqrll+3FGrCbMG7j4c2cE7IqdFKrqzBDpes4t70bU/24a8
        HpvlwEQELymUqw3sbnyuSokEgRQ4SuRjj09NgdxOkSUrcuLXEiFrFTxPskvVxvDzcW7190
        h7XmgGUQ9EalHL21YJhlPXUZldVY78Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-as2qfbUSPIK-R_i6Z0vlEQ-1; Thu, 05 Dec 2019 01:49:41 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ACE1107ACCA;
        Thu,  5 Dec 2019 06:49:40 +0000 (UTC)
Received: from [10.72.12.247] (ovpn-12-247.pek2.redhat.com [10.72.12.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11D7E10013A1;
        Thu,  5 Dec 2019 06:49:32 +0000 (UTC)
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
To:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <776732ca-06c8-c529-0899-9d2ffacf7789@redhat.com>
 <20191204193357.GE19939@xz-x1>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d24d7100-0100-b74f-0761-37196ce16f7f@redhat.com>
Date:   Thu, 5 Dec 2019 14:49:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191204193357.GE19939@xz-x1>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: as2qfbUSPIK-R_i6Z0vlEQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/12/5 =E4=B8=8A=E5=8D=883:33, Peter Xu wrote:
> On Wed, Dec 04, 2019 at 06:39:48PM +0800, Jason Wang wrote:
>> On 2019/11/30 =E4=B8=8A=E5=8D=885:34, Peter Xu wrote:
>>> Branch is here:https://github.com/xzpeter/linux/tree/kvm-dirty-ring
>>>
>>> Overview
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>
>>> This is a continued work from Lei Cao<lei.cao@stratus.com>  and Paolo
>>> on the KVM dirty ring interface.  To make it simple, I'll still start
>>> with version 1 as RFC.
>>>
>>> The new dirty ring interface is another way to collect dirty pages for
>>> the virtual machine, but it is different from the existing dirty
>>> logging interface in a few ways, majorly:
>>>
>>>     - Data format: The dirty data was in a ring format rather than a
>>>       bitmap format, so the size of data to sync for dirty logging does
>>>       not depend on the size of guest memory any more, but speed of
>>>       dirtying.  Also, the dirty ring is per-vcpu (currently plus
>>>       another per-vm ring, so total ring number is N+1), while the dirt=
y
>>>       bitmap is per-vm.
>>>
>>>     - Data copy: The sync of dirty pages does not need data copy any mo=
re,
>>>       but instead the ring is shared between the userspace and kernel b=
y
>>>       page sharings (mmap() on either the vm fd or vcpu fd)
>>>
>>>     - Interface: Instead of using the old KVM_GET_DIRTY_LOG,
>>>       KVM_CLEAR_DIRTY_LOG interfaces, the new ring uses a new interface
>>>       called KVM_RESET_DIRTY_RINGS when we want to reset the collected
>>>       dirty pages to protected mode again (works like
>>>       KVM_CLEAR_DIRTY_LOG, but ring based)
>>>
>>> And more.
>>
>> Looks really interesting, I wonder if we can make this as a library then=
 we
>> can reuse it for vhost.
> So iiuc this ring will majorly for (1) data exchange between kernel
> and user, and (2) shared memory.  I think from that pov yeh it should
> work even for vhost.
>
> It shouldn't be hard to refactor the interfaces to avoid kvm elements,
> however I'm not sure how to do that best.  Maybe like irqbypass and
> put it into virt/lib/ as a standlone module?  Would it worth it?


Maybe, and it looks to me some dirty pages reporting API for VFIO is=20
proposed in the same time. It will be helpful to unify them (or at least=20
leave a chance for other users).

Thanks


>
> Paolo, what's your take?
>

