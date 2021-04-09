Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C5435A0E5
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 16:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhDIOTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 10:19:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233688AbhDIOTV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 10:19:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617977948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3UH0r2xCKD4o2NrpBi1CrnYYl14AvSTiS+slBUMDUw=;
        b=Og0cdX228mBoxisHHhO2bD5aww+MgAJJe5s7eVcJRfRwfWOgvplbn/zuRymjxpszwvTahH
        ocDKfjq9NS6LYxIJfrRo2OramIKbk7nKJLvVnPAY1NNpfpui/dORIraFB5C0lEvjhkljDh
        MAuGmpVKFaQBSrk/esrtnBQ/bmXuHf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-Cv5cFVeBOO2Qwp9BMdJcpg-1; Fri, 09 Apr 2021 10:19:04 -0400
X-MC-Unique: Cv5cFVeBOO2Qwp9BMdJcpg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 561CF81744F;
        Fri,  9 Apr 2021 14:19:02 +0000 (UTC)
Received: from [10.36.115.11] (ovpn-115-11.ams2.redhat.com [10.36.115.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38AA16B8DD;
        Fri,  9 Apr 2021 14:18:57 +0000 (UTC)
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <5e934d94-414c-90de-c58e-34456e4ab1cf@redhat.com>
 <20210409133347.r2uf3u5g55pp27xn@box>
 <5ef83789-ffa5-debd-9ea2-50d831262237@redhat.com>
 <20210409141211.wfbyzflj7ygtx7ex@box.shutemov.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <8a845f8e-295b-1445-382c-75277ade45ae@redhat.com>
Date:   Fri, 9 Apr 2021 16:18:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210409141211.wfbyzflj7ygtx7ex@box.shutemov.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.04.21 16:12, Kirill A. Shutemov wrote:
> On Fri, Apr 09, 2021 at 03:50:42PM +0200, David Hildenbrand wrote:
>>>> 3. Allow selected users to still grab the pages (esp. KVM to fault them into
>>>> the page tables).
>>>
>>> As long as fault leads to non-present PTEs we are fine. Usespace still may
>>> want to mlock() some of guest memory. There's no reason to prevent this.
>>
>> I'm curious, even get_user_pages() will lead to a present PTE as is, no? So
>> that will need modifications I assume. (although I think it fundamentally
>> differs to the way get_user_pages() works - trigger a fault first, then
>> lookup the PTE in the page tables).
> 
> For now, the patch has two step poisoning: first fault in, on the add to
> shadow PTE -- poison. By the time VM has chance to use the page it's
> poisoned and unmapped from the host userspace.

IIRC, this then assumes that while a page is protected, it will remain 
mapped into the NPT; because, there is no way to remap into NPT later 
because the pages have already been poisoned.

-- 
Thanks,

David / dhildenb

