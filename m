Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65977354E1C
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhDFHo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:44:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232693AbhDFHo0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617695058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FF1uXJ/ehFZn2D0SiRBmUa38k2IDpVhcvasGXt63J3A=;
        b=YtmaRP3gkAc4e5P+fscZF15Ayy0LbUCXtcKnzKaM6SBSdthCvgZKkOqvXPe0I5g7x64ncq
        DchLTckc8MtCyNeLoestE1BF4Z71q7Kf0INf7oR2EhNytH8gGMbxjxW5iYbdudakBnVIyo
        vrReZLiSiXbhesFRf+Vywf+mWcMd3jo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-hwQxCJHxMGKyMmXMnWp8dQ-1; Tue, 06 Apr 2021 03:44:14 -0400
X-MC-Unique: hwQxCJHxMGKyMmXMnWp8dQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBAB5612A2;
        Tue,  6 Apr 2021 07:44:12 +0000 (UTC)
Received: from [10.36.113.79] (ovpn-113-79.ams2.redhat.com [10.36.113.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FED65D741;
        Tue,  6 Apr 2021 07:44:08 +0000 (UTC)
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Message-ID: <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
Date:   Tue, 6 Apr 2021 09:44:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.04.21 17:26, Kirill A. Shutemov wrote:
> TDX architecture aims to provide resiliency against confidentiality and
> integrity attacks. Towards this goal, the TDX architecture helps enforce
> the enabling of memory integrity for all TD-private memory.
> 
> The CPU memory controller computes the integrity check value (MAC) for
> the data (cache line) during writes, and it stores the MAC with the
> memory as meta-data. A 28-bit MAC is stored in the ECC bits.
> 
> Checking of memory integrity is performed during memory reads. If
> integrity check fails, CPU poisones cache line.
> 
> On a subsequent consumption (read) of the poisoned data by software,
> there are two possible scenarios:
> 
>   - Core determines that the execution can continue and it treats
>     poison with exception semantics signaled as a #MCE
> 
>   - Core determines execution cannot continue,and it does an unbreakable
>     shutdown
> 
> For more details, see Chapter 14 of Intel TDX Module EAS[1]
> 
> As some of integrity check failures may lead to system shutdown host
> kernel must not allow any writes to TD-private memory. This requirment
> clashes with KVM design: KVM expects the guest memory to be mapped into
> host userspace (e.g. QEMU).

So what you are saying is that if QEMU would write to such memory, it 
could crash the kernel? What a broken design.

"As some of integrity check failures may lead to system shutdown host" 
-- usually we expect to recover from an MCE by killing the affected 
process, which would be the right thing to do here.

How can it happen that "Core determines execution cannot continue,and it 
does an unbreakable shutdown". Who is "Core"? CPU "core", MM "core" ? 
And why would it decide to do a shutdown instead of just killing the 
process?

-- 
Thanks,

David / dhildenb

