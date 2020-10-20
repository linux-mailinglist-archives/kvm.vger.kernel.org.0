Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31997293D36
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 15:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407438AbgJTNU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 09:20:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407064AbgJTNU1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 09:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603200026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hjGhG7pQFy3+PaQQQ6jOV7FVy3IgvsbvzMpmnkAsMLo=;
        b=RWSFtrIeegewprED9lhkCu8WcpW+R5JeA6/MTINjtOLcxKxByHdvdgMqCCGGwEuyLTHCj6
        N+Fr1KmQw8FBj4CrTGMMG66CeZjWQKTyVY7YJMguLq/zPbX8GAdxxuNbd4vVnOX53eY0vA
        mQ9SW2UFLpONvwvPMECUrAzPd+sgxW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-6nnLZCC-MlSWKvHuC5o9ew-1; Tue, 20 Oct 2020 09:20:22 -0400
X-MC-Unique: 6nnLZCC-MlSWKvHuC5o9ew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7754B803F49;
        Tue, 20 Oct 2020 13:20:19 +0000 (UTC)
Received: from [10.36.114.141] (ovpn-114-141.ams2.redhat.com [10.36.114.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6AA61002C0E;
        Tue, 20 Oct 2020 13:20:14 +0000 (UTC)
Subject: Re: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
From:   David Hildenbrand <david@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
 <f153ef1a-a758-dec7-b39c-9990aac9d653@redhat.com>
Organization: Red Hat GmbH
Message-ID: <2759b4bf-e1e3-d006-7d86-78a40348269d@redhat.com>
Date:   Tue, 20 Oct 2020 15:20:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <f153ef1a-a758-dec7-b39c-9990aac9d653@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.20 14:18, David Hildenbrand wrote:
> On 20.10.20 08:18, Kirill A. Shutemov wrote:
>> If the protected memory feature enabled, unmap guest memory from
>> kernel's direct mappings.
> 
> Gah, ugly. I guess this also defeats compaction, swapping, ... oh gosh.
> As if all of the encrypted VM implementations didn't bring us enough
> ugliness already (SEV extensions also don't support reboots, but can at
> least kexec() IIRC).
> 
> Something similar is done with secretmem [1]. And people don't seem to
> like fragmenting the direct mapping (including me).
> 
> [1] https://lkml.kernel.org/r/20200924132904.1391-1-rppt@kernel.org
> 

I just thought "hey, we might have to replace pud/pmd mappings by page
tables when calling kernel_map_pages", this can fail with -ENOMEM, why
isn't there proper error handling.

Then I dived into __kernel_map_pages() which states:

"The return value is ignored as the calls cannot fail. Large pages for
identity mappings are not used at boot time and hence no memory
allocations during large page split."

I am probably missing something important, but how is calling
kernel_map_pages() safe *after* booting?! I know we use it for
debug_pagealloc(), but using it in a production-ready feature feels
completely irresponsible. What am I missing?


-- 
Thanks,

David / dhildenb

