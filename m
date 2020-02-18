Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B255162255
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 09:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgBRI1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 03:27:34 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28098 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726786AbgBRI1c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 03:27:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582014450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=RLFOB1Um5yYznapRcEiBThGUUmsix2sS3gQtLIxx0c0=;
        b=TMpB9MP0ZqbTDUCGxeFRw28xcAvIdi1Y7UKrERbIUPAjehR/7FLEeozcZOaT5E00AjS1yD
        Um+jeLuFVBQMsjEhDKF0OmltKtCRgHVYZbogl15myOufccDc67l+SwgyVzs6CalMxkQpWd
        9xauoGwFJpv+k6uP+KN+JeZYpa87U1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-twumtT0BMsmaGiIywaqHkg-1; Tue, 18 Feb 2020 03:27:26 -0500
X-MC-Unique: twumtT0BMsmaGiIywaqHkg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87BEE8017DF;
        Tue, 18 Feb 2020 08:27:24 +0000 (UTC)
Received: from [10.36.116.190] (ovpn-116-190.ams2.redhat.com [10.36.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7382360BE1;
        Tue, 18 Feb 2020 08:27:21 +0000 (UTC)
Subject: Re: [PATCH v2 01/42] mm:gup/writeback: add callbacks for inaccessible
 pages
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-2-borntraeger@de.ibm.com>
 <107a8a72-b745-26f2-5805-c4d99ce77b35@redhat.com>
 <dd33cc1a-214d-b949-8f5e-9c2d40a8e518@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <a8f8786e-1ed0-0c44-08d0-ebc58f43ae40@redhat.com>
Date:   Tue, 18 Feb 2020 09:27:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <dd33cc1a-214d-b949-8f5e-9c2d40a8e518@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.02.20 12:10, Christian Borntraeger wrote:
> 
> 
> On 17.02.20 10:14, David Hildenbrand wrote:
>> On 14.02.20 23:26, Christian Borntraeger wrote:
>>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>
>>> With the introduction of protected KVM guests on s390 there is now a
>>> concept of inaccessible pages. These pages need to be made accessible
>>> before the host can access them.
>>>
>>> While cpu accesses will trigger a fault that can be resolved, I/O
>>> accesses will just fail.  We need to add a callback into architecture
>>> code for places that will do I/O, namely when writeback is started or
>>> when a page reference is taken.
>>>
>>> This is not only to enable paging, file backing etc, it is also
>>> necessary to protect the host against a malicious user space. For
>>> example a bad QEMU could simply start direct I/O on such protected
>>> memory.  We do not want userspace to be able to trigger I/O errors and
>>> thus we the logic is "whenever somebody accesses that page (gup) or
>>> doing I/O, make sure that this page can be accessed. When the guest
>>> tries to access that page we will wait in the page fault handler for
>>> writeback to have finished and for the page_ref to be the expected
>>> value.
>>>
>>> If wanted by others, the callbacks can be extended with error handlin
>>> and a parameter from where this is called.
>>
>> s/handlin/handling/
> 
> ack. 
>>
>> One last question from my side:
>>
>> Why is it OK to ignore errors here. IOW, why not squash "[PATCH v2
>> 39/42] example for future extension: mm:gup/writeback: add callbacks for
>> inaccessible pages: error cases" into this patch.
> 
> I can certainly squash this in. But I have never heard feedback from the 
> memory management people if they would prefer the patch as-is (no overhead
> at all for !s390) or already with the error handling. 
>>
>> I can see in patch "[PATCH v2 05/42] s390/mm: provide memory management
>> functions for protected KVM guests", that the call can fail for various
>> reasons. That puzzles me a bit - what would happen if any of that fails?
> 
> The convert _to_ secure has error handling. uv_convert_from_secure (the
> one that is used for arch_make_page_accessible can only fail if we mess up,
> e.g. an "export" on memory that we have donated to the ultravisor.

Okay, so more like a BUG_ON() in case it really fails.

> 
> 
>> Or will it actually never fail for s390x (and all that error handling in
>> arch_make_page_accessible() is essentially dead code in real life?)
> 
> So yes, if everything is setup properly this should not fail in real life
> and only we have a kernel (or firmware) bug.
> 

Then, without feedback from other possible users, this should be a void
function. So either introduce error handling or convert it to a void for
now (and add e.g., BUG_ON and a comment inside the s390x implementation).

As discussed in the other patch, I'd prefer a
CONFIG_HAVE_ARCH_MAKE_PAGE_ACCESSIBLE and handle it via kconfig, but not
sure what other people here prefer.

-- 
Thanks,

David / dhildenb

