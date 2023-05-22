Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FDE70B79A
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 10:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjEVI3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 04:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjEVI3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 04:29:05 -0400
X-Greylist: delayed 4400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 May 2023 01:29:03 PDT
Received: from out-45.mta1.migadu.com (out-45.mta1.migadu.com [IPv6:2001:41d0:203:375::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBDCBF
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 01:29:03 -0700 (PDT)
Message-ID: <05ab340a-d500-e742-fd59-5ef2e4ea86e0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684744141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LMykAnh9K8a8DhpkmHVAinUJdctqspZeCJeDVlxCjc=;
        b=LqXBFS6Cdr/XbW6ug56FJwR2eJFwuNCWNp5foT7HIBJKb2gQRgBGOKwQAdOh32ZBXXSQv0
        vo8DmU35b+7B9+Nsmvy16xlVLawLnSci+BhiRonXdG/h04WSXqSZ/IRYkIXWPE95y5vHQq
        zYJwMe3Uxz+cBNLhjMSy/psfVn5pTe4=
Date:   Mon, 22 May 2023 16:28:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        jgg@nvidia.com, John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20230522063725.284686-1-apopple@nvidia.com>
 <620eef7f-ee01-673c-b097-243d6fe25b09@linux.dev> <87a5xwajn4.fsf@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <87a5xwajn4.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/5/22 15:45, Alistair Popple wrote:
> 
> Qi Zheng <qi.zheng@linux.dev> writes:
> 
>> Hi Alistair,
>>
>> On 2023/5/22 14:37, Alistair Popple wrote:
> 
> [...]
> 
>>> +	if (changed) {
>>> +		struct mmu_notifier_range range;
>>> +
>>> +		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_UPGRADE,
>>> +					0, vmf->vma, vmf->vma->vm_mm,
>>> +					vmf->address & PAGE_MASK,
>>> +					(vmf->address & PAGE_MASK) + PAGE_SIZE);
>>> +		mmu_notifier_invalidate_range_start(&range);
>>> +		mmu_notifier_invalidate_range_end(&range);
>>> +	}
>>
>> There are four similar patterns, can we introduce a helper function to
>> deduplicate them?
> 
> For sure. How about something like this?
> 
> void mmu_notifier_range_start_end(enum mmu_notifier_event event,
>                                    struct vm_area_struct *vma,
>                                    struct mm_struct *mm,
>                                    unsigned long start,
>                                    unsigned long end)

LGTM. :)

> 
> As an aside I didn't just use mmu_notifier_invalidate_range() as that
> doesn't allow an event type to be set for interval notifiers which may
> want to filter this.
> 
>>> +
>>>    	return 0;
>>>    }
>>>    
> 

-- 
Thanks,
Qi
