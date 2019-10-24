Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128C3E2D6B
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 11:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403994AbfJXJdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 05:33:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732686AbfJXJdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 05:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571909592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+aHv+pR5mZId7afsfSJDGJh91jfDpKxvVOzesly6jTQ=;
        b=eWH37P23sVSgLNwiu5tN4KAIMnhnRXB/Oau4+2FsIUqMcGq8jeBQRQ1DxHDSoo0aDtDi2F
        HzQmN1lHgRJIvtxe8cOLnblpV/iMDyvokJCo1/Dg5qlLT6pJg+MtpmfeD5iZcqpuTbyq/b
        Flw3Ht0ODTMuDyTFo1C0bhoi6L/cogI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-DFWeRJCOP32YI1hF-4AJrQ-1; Thu, 24 Oct 2019 05:33:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CD4C100550E;
        Thu, 24 Oct 2019 09:33:06 +0000 (UTC)
Received: from [10.36.117.225] (ovpn-117-225.ams2.redhat.com [10.36.117.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05C535D6D0;
        Thu, 24 Oct 2019 09:32:51 +0000 (UTC)
Subject: Re: [PATCH v12 2/6] mm: Use zone and order instead of free area in
 free_list manipulators
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
 <20191022222805.17338.3243.stgit@localhost.localdomain>
 <c3544859-606d-4e8f-2e48-2d7868e0fa13@redhat.com>
 <860dda361b6e0b94908d94beb0ad9f5519c8f2cf.camel@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <78caedba-fc29-20d8-3043-2d7598aa3652@redhat.com>
Date:   Thu, 24 Oct 2019 11:32:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <860dda361b6e0b94908d94beb0ad9f5519c8f2cf.camel@linux.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: DFWeRJCOP32YI1hF-4AJrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.10.19 17:16, Alexander Duyck wrote:
> On Wed, 2019-10-23 at 10:26 +0200, David Hildenbrand wrote:
>> On 23.10.19 00:28, Alexander Duyck wrote:
>>> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>>
>>> In order to enable the use of the zone from the list manipulator functi=
ons
>>> I will need access to the zone pointer. As it turns out most of the
>>> accessors were always just being directly passed &zone->free_area[order=
]
>>> anyway so it would make sense to just fold that into the function itsel=
f
>>> and pass the zone and order as arguments instead of the free area.
>>>
>>> In order to be able to reference the zone we need to move the declarati=
on
>>> of the functions down so that we have the zone defined before we define=
 the
>>> list manipulation functions. Since the functions are only used in the f=
ile
>>> mm/page_alloc.c we can just move them there to reduce noise in the head=
er.
>>>
>>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>> Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>> ---
>>>    include/linux/mmzone.h |   32 -----------------------
>>>    mm/page_alloc.c        |   67 +++++++++++++++++++++++++++++++++++---=
----------
>>>    2 files changed, 49 insertions(+), 50 deletions(-)
>>
>> Did you see
>>
>> https://lore.kernel.org/lkml/20191001152928.27008.8178.stgit@localhost.l=
ocaldomain/T/#m4d2bc2f37bd7bdc3ae35c4f197905c275d0ad2f9
>>
>> this time?
>>
>> And the difference to the old patch is only an empty line.
>>
>=20
> I saw the report. However I have not had much luck reproducing it in orde=
r
> to get root cause. Here are my results for linux-next 20191021 with that
> patch running page_fault2 over an average of 3 runs:

It would have been good if you'd reply to the report or sth. like that.=20
Then people (including me) are aware that you looked into it and what=20
your results of your investigation were.

>=20
> Baseline:   3734692.00
> This patch: 3739878.67
>=20
> Also I am not so sure about these results as the same patch had passed
> previously before and instead it was patch 3 that was reported as having =
a
> -1.2% regression[1]. All I changed in response to that report was to add

Well, previously there was also a regression in the successor=20
PageReported() patch, not sure how they bisect in this case.

> page_is_reported() which just wrapped the bit test for the reported flag
> in a #ifdef to avoid testing it for the blocks that were already #ifdef
> wrapped anyway.
>=20
> I am still trying to see if I can get access to a system that would be a
> better match for the one that reported the issue. My working theory is

I barely see false positives (well, I also barely see reports at all) on=20
MM, that's why I asked.

> that maybe it requires a high core count per node to reproduce. Either
> that or it is some combination of the kernel being tested on and the patc=
h
> is causing some loop to go out of alignment and become more expensive.

Yes, double check that the config and the setup roughly matches what has=20
been reported.

>=20
> I also included the page_fault2 results in my cover page as that seems to
> show a slight improvement with all of the patches applied.
>=20
> Thanks.
>=20
> - Alex
>=20
> [1]: https://lore.kernel.org/lkml/20190921152522.GU15734@shao2-debian/
>=20


--=20

Thanks,

David / dhildenb

