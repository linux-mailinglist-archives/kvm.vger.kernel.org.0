Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E79EE220
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfKDOXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:23:53 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55156 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727861AbfKDOXw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 09:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572877431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AfMyW8+LCIqHLvhPuWcxLTE7xUybHMrMbbyCul3ffx4=;
        b=W08g8eZV7iASWudQIMkJM2UVWbrF5dAcg/n7Z7F+dEPeLs/FxgvAipdxueUNEyVOhdTDqe
        594KwBvMW04G6MP1C4HPFBebhF2FtaIkEle7Vyzc6fV4wZ1FFqvt1ZENS+YpdhuVUlVqX3
        cGaRvg6/LuHToEZI5+DaFFhhOj1cI2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-CUh-XDwvOjaLI2NNirSaoA-1; Mon, 04 Nov 2019 09:23:34 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 794081005500;
        Mon,  4 Nov 2019 14:23:32 +0000 (UTC)
Received: from [10.36.117.96] (ovpn-117-96.ams2.redhat.com [10.36.117.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9146C60FC2;
        Mon,  4 Nov 2019 14:23:30 +0000 (UTC)
Subject: Re: [RFC 14/37] KVM: s390: protvirt: Implement interruption injection
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-15-frankja@linux.ibm.com>
 <f51f2146-834c-ba48-1015-b83c4fe6cd54@redhat.com>
 <b48afe44-8195-e9ed-d005-bfecbcebb1ca@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <b73c7a09-7901-3905-df6d-ce46a2f83aae@redhat.com>
Date:   Mon, 4 Nov 2019 15:23:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <b48afe44-8195-e9ed-d005-bfecbcebb1ca@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: CUh-XDwvOjaLI2NNirSaoA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 15:05, Christian Borntraeger wrote:
>=20
>=20
> On 04.11.19 11:29, David Hildenbrand wrote:
>> On 24.10.19 13:40, Janosch Frank wrote:
>>> From: Michael Mueller <mimu@linux.ibm.com>
>>>
>>> The patch implements interruption injection for the following
>>> list of interruption types:
>>>
>>>  =C2=A0=C2=A0 - I/O
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 __deliver_io (III)
>>>
>>>  =C2=A0=C2=A0 - External
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 __deliver_cpu_timer (IEI)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 __deliver_ckc (IEI)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 __deliver_emergency_signal (IEI)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 __deliver_external_call (IEI)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 __deliver_service (IEI)
>>>
>>>  =C2=A0=C2=A0 - cpu restart
>>>  =C2=A0=C2=A0=C2=A0=C2=A0 __deliver_restart (IRI)
>>
>> What exactly is IRQ_PEND_EXT_SERVICE_EV? Can you add some comments whet =
the new interrupt does and why it is needed in this context? Thanks
>=20
> I did that code. What about the following add-on description.
>=20
> The ultravisor does several checks on injected interrupts. For example it=
 will
> check that for an sclp interrupt with an sccb address we had an servc exi=
t
> and exit with a validity intercept.
> As the hypervisor must avoid valitity intercepts we now mask invalid inte=
rrupts.

s/valitity/validity/

>=20
> There are also sclp interrupts that only inject an event (e.g. an input e=
vent
> on the sclp consoles) those interrupts must not be masked.
> Let us split out these "event interupts" from the normal sccb interrupts =
into
> IRQ_PEND_EXT_SERVICE_EV.
>=20

Thanks for the clarification. From what I see, this is transparent from=20
user space - we only track these interrupts separately internally.

--=20

Thanks,

David / dhildenb

