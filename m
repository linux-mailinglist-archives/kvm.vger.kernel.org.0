Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8D32B5C2
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449332AbhCCHTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381773AbhCBVA7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 16:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614718764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LFeFwgd416hJgfI8CWTw0qkdzSGitcUKICDrANuntTg=;
        b=ey1IjgD7oyZ616Yxs0Hb4E85ivxT0ktgRcltFj9EaMPYQyliGVU2ztLetTXslSvLs85DqA
        Xahz0bXboDeglvup54ANH90aDx49ht08tINYWQGWdJDyUXN/Z4ftVyfkLz5iHQ29vfRUx4
        106DVleCJ9nZ5nGvMyqKtsYWUiylJ7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-3qt4LCbVM_iATpODKkWvrA-1; Tue, 02 Mar 2021 15:59:23 -0500
X-MC-Unique: 3qt4LCbVM_iATpODKkWvrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5014A193578B;
        Tue,  2 Mar 2021 20:59:21 +0000 (UTC)
Received: from [10.36.112.56] (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 034C05D9C2;
        Tue,  2 Mar 2021 20:58:46 +0000 (UTC)
Subject: Re: [PATCH v1 7/9] memory: introduce RAM_NORESERVE and wire it up in
 qemu_ram_mmap()
To:     Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
References: <20210209134939.13083-1-david@redhat.com>
 <20210209134939.13083-8-david@redhat.com> <20210302173243.GM397383@xz-x1>
 <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
 <20210302205432.GP397383@xz-x1>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <9b7294f9-5269-0429-265d-47cf9c9b33c9@redhat.com>
Date:   Tue, 2 Mar 2021 21:58:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302205432.GP397383@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.21 21:54, Peter Xu wrote:
> On Tue, Mar 02, 2021 at 08:02:34PM +0100, David Hildenbrand wrote:
>>>> @@ -174,12 +175,18 @@ void *qemu_ram_mmap(int fd,
>>>>                        size_t align,
>>>>                        bool readonly,
>>>>                        bool shared,
>>>> -                    bool is_pmem)
>>>> +                    bool is_pmem,
>>>> +                    bool noreserve)
>>>
>>> Maybe at some point we should use flags too here to cover all bools.
>>>
>>
>> Right. I guess the main point was to not reuse RAM_XXX.
>>
>> Should I introduce RAM_MMAP_XXX ?
> 
> Maybe we can directly use MAP_*?  Since I see qemu_ram_mmap() should only exist

I think the issue is that there is for example no flag that corresponds 
to "is_pmem" - and the fallback logic in our mmap code to make "is_pmem" 
still work is a little bit more involved. In addition, "readonly" 
translates to PROT_READ ...

> with CONFIG_POSIX.  However indeed I see no sign to extend more bools in the
> near future either, so maybe also fine to keep it as is, as 4 bools still looks
> okay - your call. :)

Well, I had the same idea when I added yet another bool :) But I guess 
we won't be adding a lot of additional flags in the near future. 
(MAP_POPULATE? ;) fortunately we use a different approach to populate 
memory)

I'll think about it, not sure yet if this is worth proper flags. Thanks!

-- 
Thanks,

David / dhildenb

