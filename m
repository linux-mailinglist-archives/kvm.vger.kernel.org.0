Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8C1EB629
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 18:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfJaRam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 13:30:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728742AbfJaRal (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 13:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572543040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UGSSoPW9SbtoPw1zyBmx41eOb8KWOrUeRgITIL6IQKY=;
        b=hUqW6xJu+tYQPlpEe2L+G5itmkXtIn8CE9K5MC7zJei46S6UwtgvoM5t56oMoN56HfosDr
        VghQqG0CGaVKYuF7Y9PvWX3UVhgE8antUG3CAju4IHh6HNx5bh1jzj2v1jRgV9/bCImVIV
        eR4u17rFOhaVtPw0qTQw4/yvErkz8Ck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-GHoi6ENEO_Gu0KdCE_Y4Cw-1; Thu, 31 Oct 2019 13:30:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61324800C80;
        Thu, 31 Oct 2019 17:30:35 +0000 (UTC)
Received: from [10.36.116.51] (ovpn-116-51.ams2.redhat.com [10.36.116.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9928F19C7F;
        Thu, 31 Oct 2019 17:30:31 +0000 (UTC)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
 <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
 <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
Date:   Thu, 31 Oct 2019 18:30:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: GHoi6ENEO_Gu0KdCE_Y4Cw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.10.19 16:41, Christian Borntraeger wrote:
>=20
>=20
> On 25.10.19 10:49, David Hildenbrand wrote:
>> On 24.10.19 13:40, Janosch Frank wrote:
>>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>
>>> Pin the guest pages when they are first accessed, instead of all at
>>> the same time when starting the guest.
>>
>> Please explain why you do stuff. Why do we have to pin the hole guest me=
mory? Why can't we mlock() the hole memory to avoid swapping in user space?
>=20
> Basically we pin the guest for the same reason as AMD did it for their SE=
V. It is hard

Pinning all guest memory is very ugly. What you want is "don't page",=20
what you get is unmovable pages all over the place. I was hoping that=20
you could get around this by having an automatic back-and-forth=20
conversion in place (due to the special new exceptions).

> to synchronize page import/export with the I/O for paging. For example yo=
u can actually
> fault in a page that is currently under paging I/O. What do you do? impor=
t (so that the
> guest can run) or export (so that the I/O will work). As this turned out =
to be harder then
> we though we decided to defer paging to a later point in time.

I don't quite see the issue yet. If you page out, the page will=20
automatically (on access) be converted to !secure/encrypted memory. If=20
the UV/guest wants to access it, it will be automatically converted to=20
secure/unencrypted memory. If you have concurrent access, it will be=20
converted back and forth until one party is done.

A proper automatic conversion should make this work. What am I missing?

>=20
> As we do not want to rely on the userspace to do the mlock this is now do=
ne in the kernel.

I wonder if we could come up with an alternative (similar to how we=20
override VM_MERGEABLE in the kernel) that can be called and ensured in=20
the kernel. E.g., marking whole VMAs as "don't page" (I remember=20
something like "special VMAs" like used for VDSOs that achieve exactly=20
that, but I am absolutely no expert on that). That would be much nicer=20
than pinning all pages and remembering what you pinned in huge page=20
arrays ...

--=20

Thanks,

David / dhildenb

