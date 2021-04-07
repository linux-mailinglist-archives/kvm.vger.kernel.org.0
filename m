Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D87356F66
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345433AbhDGO4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345325AbhDGO4R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 10:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617807367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3K37Ana68yLtXTYXYTNdCNXI4iqTOpD+NBf+2SOYuQo=;
        b=hcSvsvY1yML6BZ1BiSph2Bf6PWKJNqPXKyhrhk/5WFl1ruKtnTAS4YrQjUrmeNQWyJTm4p
        F72QSdRU8dAZ2rzq8H7ilEwgKNYyaya8taSGjFIO2+dRvJ4BZlAfNWj+xLkZKpPFGW52dN
        kPknYZbvvN60NE5p3vys4LnRz76DwgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-_q0AcofYMQSkxK5o71fQMw-1; Wed, 07 Apr 2021 10:56:03 -0400
X-MC-Unique: _q0AcofYMQSkxK5o71fQMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B1D783DD2A;
        Wed,  7 Apr 2021 14:55:59 +0000 (UTC)
Received: from [10.36.114.68] (ovpn-114-68.ams2.redhat.com [10.36.114.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9FC019D9F;
        Wed,  7 Apr 2021 14:55:55 +0000 (UTC)
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Message-ID: <5e934d94-414c-90de-c58e-34456e4ab1cf@redhat.com>
Date:   Wed, 7 Apr 2021 16:55:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
> 
> This patch aims to start discussion on how we can approach the issue.
> 
> For now I intentionally keep TDX out of picture here and try to find a
> generic way to unmap KVM guest memory from host userspace. Hopefully, it
> makes the patch more approachable. And anyone can try it out.
> 
> To the proposal:
> 
> Looking into existing codepaths I've discovered that we already have
> semantics we want. That's PG_hwpoison'ed pages and SWP_HWPOISON swap
> entries in page tables:
> 
>    - If an application touches a page mapped with the SWP_HWPOISON, it will
>      get SIGBUS.
> 
>    - GUP will fail with -EFAULT;
> 
> Access the poisoned memory via page cache doesn't match required
> semantics right now, but it shouldn't be too hard to make it work:
> access to poisoned dirty pages should give -EIO or -EHWPOISON.
> 
> My idea is that we can mark page as poisoned when we make it TD-private
> and replace all PTEs that map the page with SWP_HWPOISON.

It looks quite hacky (well, what did I expect from an RFC :) ) you can 
no longer distinguish actually poisoned pages from "temporarily 
poisoned" pages. FOLL_ALLOW_POISONED sounds especially nasty and 
dangerous -  "I want to read/write a poisoned page, trust me, I know 
what I am doing".

Storing the state for each individual page initially sounded like the 
right thing to do, but I wonder if we couldn't handle this on a per-VMA 
level. You can just remember the handful of shared ranges internally 
like you do right now AFAIU.


 From what I get, you want a way to

1. Unmap pages from the user space page tables.

2. Disallow re-faulting of the protected pages into the page tables. On 
user space access, you want to deliver some signal (e.g., SIGBUS).

3. Allow selected users to still grab the pages (esp. KVM to fault them 
into the page tables).

4. Allow access to currently shared specific pages from user space.

Right now, you achieve

1. Via try_to_unmap()
2. TestSetPageHWPoison
3. TBD (e.g., FOLL_ALLOW_POISONED)
4. ClearPageHWPoison()


If we could bounce all writes to shared pages through the kernel, things 
could end up a little easier. Some very rough idea:

We could let user space setup VM memory as
mprotect(PROT_READ) (+ PROT_KERNEL_WRITE?), and after activating 
protected memory (I assume via a KVM ioctl), make sure the VMAs cannot 
be set to PROT_WRITE anymore. This would already properly unmap and 
deliver a SIGSEGV when trying to write from user space.

You could then still access the pages, e.g., via FOLL_FORCE or a new 
fancy flag that allows to write with VM_MAYWRITE|VM_DENYUSERWRITE. This 
would allow an ioctl to write page content and to map the pages into NPTs.

As an extension, we could think about (re?)mapping some shared pages 
read|write. The question is how to synchronize with user space.

I have no idea how expensive would be bouncing writes (and reads?) 
through the kernel. Did you ever experiment with that/evaluate that?

-- 
Thanks,

David / dhildenb

