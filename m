Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE49E1426
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 10:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390306AbfJWI0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 04:26:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390261AbfJWI0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 04:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571819213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HaclBkUySXchpujJDOKDQ24Kar8EqBHEiLvQYvykVcM=;
        b=atLm8UqZ2P1diJTrhVLykLL10B3a+Wwfh7AxxPcMci8CPn7s7taOqQuVP/JBQWgPj4aTlr
        QCqqjJqIQ8JtcVmdNutLl03qPQJMQvfc1C3DEJuxcv7D3eXxnsucNiRozuagRaxpB19vgr
        NwBOmtV0cR3RWq8ZPxNzRLaWGKjQruQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-LuY7b88DMPqLlrFS4Rg2Ag-1; Wed, 23 Oct 2019 04:26:50 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE743100550E;
        Wed, 23 Oct 2019 08:26:47 +0000 (UTC)
Received: from [10.36.117.79] (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B8CE19C78;
        Wed, 23 Oct 2019 08:26:33 +0000 (UTC)
Subject: Re: [PATCH v12 2/6] mm: Use zone and order instead of free area in
 free_list manipulators
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
 <20191022222805.17338.3243.stgit@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <c3544859-606d-4e8f-2e48-2d7868e0fa13@redhat.com>
Date:   Wed, 23 Oct 2019 10:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191022222805.17338.3243.stgit@localhost.localdomain>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: LuY7b88DMPqLlrFS4Rg2Ag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.10.19 00:28, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>=20
> In order to enable the use of the zone from the list manipulator function=
s
> I will need access to the zone pointer. As it turns out most of the
> accessors were always just being directly passed &zone->free_area[order]
> anyway so it would make sense to just fold that into the function itself
> and pass the zone and order as arguments instead of the free area.
>=20
> In order to be able to reference the zone we need to move the declaration
> of the functions down so that we have the zone defined before we define t=
he
> list manipulation functions. Since the functions are only used in the fil=
e
> mm/page_alloc.c we can just move them there to reduce noise in the header=
.
>=20
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>   include/linux/mmzone.h |   32 -----------------------
>   mm/page_alloc.c        |   67 +++++++++++++++++++++++++++++++++++------=
-------
>   2 files changed, 49 insertions(+), 50 deletions(-)

Did you see

https://lore.kernel.org/lkml/20191001152928.27008.8178.stgit@localhost.loca=
ldomain/T/#m4d2bc2f37bd7bdc3ae35c4f197905c275d0ad2f9

this time?

And the difference to the old patch is only an empty line.

--=20

Thanks,

David / dhildenb

