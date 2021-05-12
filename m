Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731E937B89F
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhELIxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230295AbhELIxY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 04:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620809536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0wtuPVOomswhN3nKbizxfMzPJgWJmm0zGlVQ5c3NWyA=;
        b=N/yTTDZowlCD71r3u/DlRHsRSAYU6uK1AL4PUFRivlbSwXSnxePRVLcBY+WLmjlc9imMvz
        py1WG5WCoHNWQIVVztQ3NAImVVIS84mFOLMTARti8OiVQveTwl3uxCV/IoCAT8TMz9LC0Y
        HNHwkBYSvnq4kvwRozTJA23ArOQ/p8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-68KwoGpgOO-EJxJemm-tJg-1; Wed, 12 May 2021 04:52:14 -0400
X-MC-Unique: 68KwoGpgOO-EJxJemm-tJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ABEC107ACCA;
        Wed, 12 May 2021 08:52:13 +0000 (UTC)
Received: from [10.36.112.87] (ovpn-112-87.ams2.redhat.com [10.36.112.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D7ECAE159;
        Wed, 12 May 2021 08:52:10 +0000 (UTC)
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support for
 aarch64
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        drjones@redhat.com, alexandru.elisei@arm.com
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com> <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <YJRADhU4CcTE7bdm@google.com>
 <8a99d57b-0513-557c-79e0-98084799812f@redhat.com>
 <YJuDYZbqe8V47YCJ@google.com>
 <4e83daa3-3166-eeed-840c-39be71b1124d@redhat.com>
 <348b978aad60db6af7ba9c9ce51bbd87@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <628dca08-4108-8be1-9bea-8c388f28401e@redhat.com>
Date:   Wed, 12 May 2021 10:52:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <348b978aad60db6af7ba9c9ce51bbd87@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/12/21 10:33 AM, Marc Zyngier wrote:
> On 2021-05-12 09:19, Auger Eric wrote:
>> Hi Ricardo,
>>
>> On 5/12/21 9:27 AM, Ricardo Koller wrote:
>>> On Fri, May 07, 2021 at 04:08:07PM +0200, Auger Eric wrote:
>>>> Hi Ricardo,
>>>>
>>>> On 5/6/21 9:14 PM, Ricardo Koller wrote:
>>>>> On Thu, May 06, 2021 at 02:30:17PM +0200, Auger Eric wrote:
>>>>>> Hi Ricardo,
>>>>>>
>>>>>
>>>>> Hi Eric,
>>>>>
>>>>> Thank you very much for the test.
>>>>>
>>>>>> On 5/3/21 9:12 PM, Ricardo Koller wrote:
>>>>>>> On Mon, May 03, 2021 at 11:32:39AM +0100, Marc Zyngier wrote:
>>>>>>>> On Sat, 01 May 2021 00:24:06 +0100,
>>>>>>>> Ricardo Koller <ricarkol@google.com> wrote:
>>>>>>>>>
>>>>>>>>> Add the infrastructure needed to enable exception handling in
>>>>>>>>> aarch64
>>>>>>>>> selftests. The exception handling defaults to an
>>>>>>>>> unhandled-exception
>>>>>>>>> handler which aborts the test, just like x86. These handlers
>>>>>>>>> can be
>>>>>>>>> overridden by calling vm_install_vector_handler(vector) or
>>>>>>>>> vm_install_exception_handler(vector, ec). The unhandled exception
>>>>>>>>> reporting from the guest is done using the ucall type
>>>>>>>>> introduced in a
>>>>>>>>> previous commit, UCALL_UNHANDLED.
>>>>>>>>>
>>>>>>>>> The exception handling code is heavily inspired on kvm-unit-tests.
>>>>>>
>>>>>> running the test on 5.12 I get
>>>>>>
>>>
>>> Hi Eric,
>>>
>>> I'm able to reproduce the failure you are seeing on 5.6, specifically
>>> with kernels older than this commit:
>>>
>>>   4942dc6638b0 KVM: arm64: Write arch.mdcr_el2 changes since last
>>> vcpu_load on VHE
>>>
>>> but not yet on v5.12. Could you share the commit of the kernel you are
>>> testing, please?
>>
>> my host is a 5.12 kernel (8404c9fbc84b)
> 
> Time to compare notes then. What HW are you using? Running VHE or not?
VHE yes. Cavium Sabre system.

Thanks

Eric
> 
> Thanks,
> 
>         M.

