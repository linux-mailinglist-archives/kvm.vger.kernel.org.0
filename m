Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FCDFDF67
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 14:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKONzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 08:55:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37672 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727380AbfKONzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 08:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573826130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IHuD68DWh92JC6LTAKYYKk7KAKKtEegdfilinbWYb/8=;
        b=bo6VkRaJ3JH3zkWAaywkm0C72bc40cdNL0NzQdOFoc5wcW6RT500xGMlPerFPBtpVFhcIE
        FCwx7EGVyKBtLMGeWQjA4u94W4aPenR7nqEOIYQQ8q9QFKs3SqWevWL6/iWfWrY7ui1//q
        Kltfqz98OXHYkSg4LMVZTQyIDyLicWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-6PFqfyu8MjGJ1ShyYNgx6g-1; Fri, 15 Nov 2019 08:55:22 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 622A01005500;
        Fri, 15 Nov 2019 13:55:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-84.ams2.redhat.com [10.36.117.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9F5360C18;
        Fri, 15 Nov 2019 13:55:14 +0000 (UTC)
Subject: Re: [RFC 32/37] KVM: s390: protvirt: UV calls diag308 0, 1
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-33-frankja@linux.ibm.com>
 <6fb6b03f-5a33-34ec-53e6-d960ac7bbae6@redhat.com>
 <302337a3-5a1f-4ee9-2ee8-a10b7fe17479@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <76e04877-93c5-0785-290e-4d8739b4c4b8@redhat.com>
Date:   Fri, 15 Nov 2019 14:30:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <302337a3-5a1f-4ee9-2ee8-a10b7fe17479@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 6PFqfyu8MjGJ1ShyYNgx6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/11/2019 12.39, Janosch Frank wrote:
> On 11/15/19 11:07 AM, Thomas Huth wrote:
>> On 24/10/2019 13.40, Janosch Frank wrote:
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  arch/s390/include/asm/uv.h | 25 +++++++++++++++++++++++++
>>>  arch/s390/kvm/diag.c       |  1 +
>>>  arch/s390/kvm/kvm-s390.c   | 20 ++++++++++++++++++++
>>>  arch/s390/kvm/kvm-s390.h   |  2 ++
>>>  arch/s390/kvm/pv.c         | 19 +++++++++++++++++++
>>>  include/uapi/linux/kvm.h   |  2 ++
>>>  6 files changed, 69 insertions(+)
>>
>> Add at least a short patch description what this patch is all about?
>>
>>  Thomas
>>
>=20
> I'm thinking about taking out the set cpu state changes and move it into
> a later patch.
>=20
>=20
> How about:
> diag 308 subcode 0 and 1 require KVM and Ultravisor interaction, since
> the cpus have to be set into multiple reset states.
>=20
> * All cpus need to be stopped
> * The unshare all UVC needs to be executed
> * The perform reset UVC needs to be executed
> * The cpus need to be reset via the set cpu state UVC
> * The issuing cpu needs to set state 5 via set cpu state

Could you put the UVC names into quotes? Like:

* The "unshare all" UVC needs to be executed

... I first had to read the sentence three times to really understand it.

 Thomas

