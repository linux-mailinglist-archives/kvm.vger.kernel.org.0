Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE24832C5EF
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385362AbhCDA1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232972AbhCCLjW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 06:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614771470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JxZcUgLg46LstW7R4po/TkX9GzlBOgrtyg+5Uxjfbt8=;
        b=CO0ztKbXywZR9YUNUnuPWettefKXy1AzFUetgYF38fb04zxm3KStM8EnqKAdGVY5RWTsMy
        nnlUIvM4I2VEHFyig7Qe2cptH+pvgnAFV3ick7T3hXuSadBrZW83BZ0UHK7Mf85Qw2CCXF
        nPTOqOrM4A6BRpThw3O2LDiYXDjFk8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-hWs68NFuNDKNZ9n3_5ZJrQ-1; Wed, 03 Mar 2021 06:37:49 -0500
X-MC-Unique: hWs68NFuNDKNZ9n3_5ZJrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BD78804039;
        Wed,  3 Mar 2021 11:37:47 +0000 (UTC)
Received: from [10.36.112.28] (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18C095D705;
        Wed,  3 Mar 2021 11:37:36 +0000 (UTC)
Subject: Re: [PATCH v1 7/9] memory: introduce RAM_NORESERVE and wire it up in
 qemu_ram_mmap()
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, qemu-devel@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
References: <20210209134939.13083-1-david@redhat.com>
 <20210209134939.13083-8-david@redhat.com> <20210302173243.GM397383@xz-x1>
 <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
 <20210303123517.04729c1e.cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <656d4494-ea36-39c2-2d47-bbb044a67f11@redhat.com>
Date:   Wed, 3 Mar 2021 12:37:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210303123517.04729c1e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.03.21 12:35, Cornelia Huck wrote:
> On Tue, 2 Mar 2021 20:02:34 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 02.03.21 18:32, Peter Xu wrote:
>>> On Tue, Feb 09, 2021 at 02:49:37PM +0100, David Hildenbrand wrote:
>>>> @@ -899,13 +899,17 @@ int kvm_s390_mem_op_pv(S390CPU *cpu, uint64_t offset, void *hostbuf,
>>>>     * to grow. We also have to use MAP parameters that avoid
>>>>     * read-only mapping of guest pages.
>>>>     */
>>>> -static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared)
>>>> +static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared,
>>>> +                               bool noreserve)
>>>>    {
>>>>        static void *mem;
>>>>    
>>>>        if (mem) {
>>>>            /* we only support one allocation, which is enough for initial ram */
>>>>            return NULL;
>>>> +    } else if (noreserve) {
>>>> +        error_report("Skipping reservation of swap space is not supported.");
>>>> +        return NULL
>>>
>>> Semicolon missing.
>>
>> Thanks for catching that!
> 
> Regardless of that (and this patch set), can we finally get rid of
> legacy_s390_alloc? We already fence off running with a kernel prior to
> 3.15, and KVM_CAP_S390_COW depends on ESOP -- are non-ESOP kvm hosts
> still relevant? This seems to be a generation 10 feature; do we
> realistically expect anyone running this on e.g. a z/VM host that
> doesn't provide ESOP?

Good question - last time I asked that question (~2 years ago) I was 
told that such z/VM environemnts are still relevant.

-- 
Thanks,

David / dhildenb

