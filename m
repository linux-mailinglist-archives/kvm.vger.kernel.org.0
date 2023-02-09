Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732B869143A
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjBIXKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBIXKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:10:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBC560D4C
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675984195;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WimhJxIe8iT9z7n3inTmO+KOjBq/uTLLe8Wvsfx8ubk=;
        b=DOlBJ8iKJkvHkSQL32FU8NtwbJcbBaItJw/V0yY4xcw+lz4BqHFefwQY0yYFJ05DZ2Q7Bz
        /zhT0sbUnyaNsrJAknzZ14U0Tu+ZB5H84Gp0Sj40cVd0B5WdoUAPZdRIKmSLtWU0rn3djG
        GXLKtw2smp3TIhqG9+RojRO6JsVYbMo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-hcGkns8DM3mrKdD5dSa1MQ-1; Thu, 09 Feb 2023 18:09:51 -0500
X-MC-Unique: hcGkns8DM3mrKdD5dSa1MQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2B241C051A3;
        Thu,  9 Feb 2023 23:09:50 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 389C62026D4B;
        Thu,  9 Feb 2023 23:09:42 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 09/12] KVM: arm64: Split huge pages when dirty logging
 is enabled
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
References: <20230206165851.3106338-1-ricarkol@google.com>
 <20230206165851.3106338-10-ricarkol@google.com>
 <9201764f-baa1-250a-39ac-0305bce789a3@redhat.com>
 <CAOHnOrzGXU29JK+8aRq0SnMe6Ske04YWffJhPU6iUXjGyyoQtA@mail.gmail.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <f1e8d587-8c7a-8e97-522f-337915489cda@redhat.com>
Date:   Fri, 10 Feb 2023 10:09:40 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAOHnOrzGXU29JK+8aRq0SnMe6Ske04YWffJhPU6iUXjGyyoQtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 2/9/23 11:50 PM, Ricardo Koller wrote:
> On Wed, Feb 8, 2023 at 10:26 PM Gavin Shan <gshan@redhat.com> wrote:

[...]

>>
>>> +static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
>>> +                                 phys_addr_t end)
>>> +{
>>> +     struct kvm_mmu_memory_cache *cache;
>>> +     struct kvm_pgtable *pgt;
>>> +     int ret;
>>> +     u64 next;
>>> +     u64 chunk_size = kvm->arch.mmu.split_page_chunk_size;
>>> +     int cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
>>> +
>>> +     if (chunk_size == 0)
>>> +             return 0;
>>> +
>>> +     lockdep_assert_held_write(&kvm->mmu_lock);
>>> +
>>> +     cache = &kvm->arch.mmu.split_page_cache;
>>> +
>>> +     do {
>>> +             if (need_topup_split_page_cache_or_resched(kvm,
>>> +                                                        cache_capacity)) {
>>> +                     write_unlock(&kvm->mmu_lock);
>>> +                     cond_resched();
>>> +                     /* Eager page splitting is best-effort. */
>>> +                     ret = __kvm_mmu_topup_memory_cache(cache,
>>> +                                                        cache_capacity,
>>> +                                                        cache_capacity);
>>> +                     write_lock(&kvm->mmu_lock);
>>> +                     if (ret)
>>> +                             break;
>>> +             }
>>> +
>>> +             pgt = kvm->arch.mmu.pgt;
>>> +             if (!pgt)
>>> +                     return -EINVAL;
>>
>> I don't think the check to see @pgt is existing or not because the VM can't be
>> created with its page-table isn't allocated and set in kvm_init_stage2_mmu().
> 
> GIven that the lock is released/acquired every chunk, the intent was to check
> that the page-table wasn't freed in between.
> 

I don't understand how it can be possible. @pgt is free'd when the VM is released
when its reference count reaches zero. The major cross-point is close(vm-fd) and
this ioctl(). The VM file's release function won't be invoked until the file's
reference count is dropped to zero. The ioctl() already had one reference count
on the VM file taken to avoid it.

There may be other cases I missed. If so, I think a comment is still needed to
help reader to understand.

Thanks,
Gavin

