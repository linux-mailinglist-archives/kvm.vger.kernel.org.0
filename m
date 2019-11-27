Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AC710B49B
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 18:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfK0Rhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 12:37:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34482 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727033AbfK0Rhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 12:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574876258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=/EutEIL466ZUqNQMlg8zDkw8HWKGT4MM8Orz5FGtAII=;
        b=HDTfj4VyAfXflCYrVvYtaWj1YmBj4M3YXLAAmbhPWsKc9/uH+JAfkj6oMGnpQKYoXdbxNA
        HhVxLbCdOaa7rXkkansPPl2U6bKEVkwW09hzB+sZMJTxfOaJbJX1TaGz8nMtx7gSnXiPM6
        xYqeXIQft/wxMprPGE6vhur9qRXkNHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-7DlmekviN0OKh7IvD6j-Uw-1; Wed, 27 Nov 2019 12:37:37 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75391107ACE3;
        Wed, 27 Nov 2019 17:37:34 +0000 (UTC)
Received: from [10.36.116.69] (ovpn-116-69.ams2.redhat.com [10.36.116.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F9A119C6A;
        Wed, 27 Nov 2019 17:37:22 +0000 (UTC)
Subject: Re: [PATCH v14 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <052f7442-4500-cd02-af2e-56d2f97a232c@redhat.com>
 <2cd804f781b55d5c20e970dcd67b472fba6e1387.camel@linux.intel.com>
 <905bf376-b8a5-d101-fb8e-ec8aa9ce500e@redhat.com>
 <57f4c78f298a5e3d929c0026f7b323a3bb911848.camel@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <fd866a71-1d1a-1481-ffee-aefe0313ef38@redhat.com>
Date:   Wed, 27 Nov 2019 18:37:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <57f4c78f298a5e3d929c0026f7b323a3bb911848.camel@linux.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 7DlmekviN0OKh7IvD6j-Uw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.11.19 18:36, Alexander Duyck wrote:
> On Wed, 2019-11-27 at 11:01 +0100, David Hildenbrand wrote:
>> On 26.11.19 17:45, Alexander Duyck wrote:
>>> On Tue, 2019-11-26 at 13:20 +0100, David Hildenbrand wrote:
>>>> On 19.11.19 22:46, Alexander Duyck wrote:
> 
> <snip>
> 
>>>>> Below are the results from various benchmarks. I primarily focused on two
>>>>> tests. The first is the will-it-scale/page_fault2 test, and the other is
>>>>> a modified version of will-it-scale/page_fault1 that was enabled to use
>>>>> THP. I did this as it allows for better visibility into different parts
>>>>> of the memory subsystem. The guest is running with 32G for RAM on one
>>>>> node of a E5-2630 v3. The host has had some power saving features disabled
>>>>> by setting the /dev/cpu_dma_latency value to 10ms.
>>>>>
>>>>> Test                page_fault1 (THP)     page_fault2
>>>>> Name         tasks  Process Iter  STDEV  Process Iter  STDEV
>>>>> Baseline         1    1203934.75  0.04%     379940.75  0.11%
>>>>>                 16    8828217.00  0.85%    3178653.00  1.28%
>>>>>
>>>>> Patches applied  1    1207961.25  0.10%     380852.25  0.25%
>>>>>                 16    8862373.00  0.98%    3246397.25  0.68%
>>>>>
>>>>> Patches enabled  1    1207758.75  0.17%     373079.25  0.60%
>>>>>  MADV disabled  16    8870373.75  0.29%    3204989.75  1.08%
>>>>>
>>>>> Patches enabled  1    1261183.75  0.39%     373201.50  0.50%
>>>>>                 16    8371359.75  0.65%    3233665.50  0.84%
>>>>>
>>>>> Patches enabled  1    1090201.50  0.25%     376967.25  0.29%
>>>>>  page shuffle   16    8108719.75  0.58%    3218450.25  1.07%
>>>>>
>>>>> The results above are for a baseline with a linux-next-20191115 kernel,
>>>>> that kernel with this patch set applied but page reporting disabled in
>>>>> virtio-balloon, patches applied but the madvise disabled by direct
>>>>> assigning a device, the patches applied and page reporting fully
>>>>> enabled, and the patches enabled with page shuffling enabled.  These
>>>>> results include the deviation seen between the average value reported here
>>>>> versus the high and/or low value. I observed that during the test memory
>>>>> usage for the first three tests never dropped whereas with the patches
>>>>> fully enabled the VM would drop to using only a few GB of the host's
>>>>> memory when switching from memhog to page fault tests.
>>>>>
>>>>> Most of the overhead seen with this patch set enabled seems due to page
>>>>> faults caused by accessing the reported pages and the host zeroing the page
>>>>> before giving it back to the guest. This overhead is much more visible when
>>>>> using THP than with standard 4K pages. In addition page shuffling seemed to
>>>>> increase the amount of faults generated due to an increase in memory churn.
>>>>
>>>> MADV_FREE would be interesting.
>>>
>>> I can probably code something up. However that is going to push a bunch of
>>> complexity into the QEMU code and doesn't really mean much to the kernel
>>> code. I can probably add it as another QEMU patch to the set since it is
>>> just a matter of having a function similar to ram_block_discard_range that
>>> uses MADV_FREE instead of MADV_DONTNEED.
>>
>> Yes, addon patch makes perfect sense. The nice thing about MADV_FREE is
>> that you only take back pages from a process when really under memory
>> pressure (before going to SWAP). You will still get a pagefault on the
>> next access (to identify that the page is still in use after all), but
>> don't have to fault in a fresh page.
> 
> So I got things running with a proof of concept using MADV_FREE.
> Apparently another roadblock I hadn't realized is that you have to have
> the right version of glibc for MADV_FREE to be present.
> 
> Anyway with MADV_FREE the numbers actually look pretty close to the
> numbers with the madvise disabled. Apparently the page fault overhead
> isn't all that significant. When I push the next patch set I will include
> the actual numbers, but even with shuffling enabled the results were in
> the 8.7 to 8.8 million iteration range.
> 

Cool, thanks for evaluating!

-- 
Thanks,

David / dhildenb

