Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5C132C5F2
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388591AbhCDA1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234230AbhCCLmu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 06:42:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614771633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1uLPbSDetbxJhaXsYIA3ra1ACYvOe0wmHXTm7vuvL/M=;
        b=B1cXevNbGhMKIwiz60g4RF5buz43ScBY5GbhC8yb1lneBSb50L89QlCL6xqQ+lno7DvWl6
        N/fLpktTNIkLVDKTtOHks9XshVr8L8nIZgn8iD1C09HA2uYR+MbnX7lXGz/X5Zjuyin1ZY
        C7a1S+BPL4mwGYOLnF/4sCiNfqh+nWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-xqSsGdCxP7mE4uPqv7tJ1w-1; Wed, 03 Mar 2021 06:40:30 -0500
X-MC-Unique: xqSsGdCxP7mE4uPqv7tJ1w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E99D80403F;
        Wed,  3 Mar 2021 11:40:28 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-115-146.ams2.redhat.com [10.36.115.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9159D68D22;
        Wed,  3 Mar 2021 11:39:57 +0000 (UTC)
Subject: Re: [PATCH v1 7/9] memory: introduce RAM_NORESERVE and wire it up in
 qemu_ram_mmap()
To:     Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
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
        Stefan Weil <sw@weilnetz.de>, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org
References: <20210209134939.13083-1-david@redhat.com>
 <20210209134939.13083-8-david@redhat.com> <20210302173243.GM397383@xz-x1>
 <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
 <20210303123517.04729c1e.cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2c5a8d44-cde7-d9a9-c4c3-4c4af4087db7@redhat.com>
Date:   Wed, 3 Mar 2021 12:39:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303123517.04729c1e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/2021 12.35, Cornelia Huck wrote:
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

Looking at the support charts ( 
https://www.ibm.com/support/pages/ibm-mainframe-life-cycle-history ), the 
z10 is already unsupported. So if all newer mainframes have ESOP, I guess it 
should be fine to get rid of this code now.

  Thomas

