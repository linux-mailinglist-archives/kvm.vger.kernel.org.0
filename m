Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03725368967
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 01:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhDVXf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 19:35:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235977AbhDVXf5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 19:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619134521;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WXUjBiBtw/xQjxnogOOcI5Cr8lsqNo0d3Mm0tliIk0s=;
        b=LVOKxKsrkgBCg1K9P4k8+RPYvvVcppcNVH7MQlQmC5xzry1wjWW5XtDB4fri+dRBOKVVwl
        tCqcRx/RBzoAQov0iYKYs9kpMqS8GZxIeTIR0dgDc8ZW9DTG992Z6h45FsK4sgtaR41zSm
        ZrOTBUFIo+Tgh/QtBsN3tI/VLfcjtOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-qQjUnm5-PBiLLxQUT-gf4w-1; Thu, 22 Apr 2021 19:35:19 -0400
X-MC-Unique: qQjUnm5-PBiLLxQUT-gf4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7FFD343A3;
        Thu, 22 Apr 2021 23:35:17 +0000 (UTC)
Received: from [10.64.54.94] (vpn2-54-94.bne.redhat.com [10.64.54.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AA4C19C71;
        Thu, 22 Apr 2021 23:35:14 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Santosh Shukla <sashukla@nvidia.com>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
 <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
 <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
 <f13bfc39-bee6-4562-fefc-76051bbf9735@redhat.com>
 <9eb47a6c-3c5c-cb4a-d1de-1a3ce1b60a87@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <d185bbe1-4bb3-6a38-7a94-b0c52126e583@redhat.com>
Date:   Fri, 23 Apr 2021 11:35:22 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <9eb47a6c-3c5c-cb4a-d1de-1a3ce1b60a87@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

On 4/22/21 5:41 PM, Keqian Zhu wrote:
> On 2021/4/22 10:12, Gavin Shan wrote:
>> On 4/21/21 4:28 PM, Keqian Zhu wrote:
>>> On 2021/4/21 14:38, Gavin Shan wrote:
>>>> On 4/16/21 12:03 AM, Keqian Zhu wrote:

[...]

>>
>> Yeah, Sorry that I missed that part. Something associated with Santosh's
>> patch. The flag can be not existing until the page fault happened on
>> the vma. In this case, the check could be not working properly.
>>
>>    [PATCH] KVM: arm64: Correctly handle the mmio faulting
> Yeah, you are right.
> 
> If that happens, we won't try to use block mapping for memslot with VM_PFNMAP.
> But it keeps a same logic with old code.
> 
> 1. When without dirty-logging, we won't try block mapping for it, and we'll
> finally know that it's device, so won't try to do adjust THP (Transparent Huge Page)
> for it.
> 2. If userspace wrongly enables dirty logging for this memslot, we'll force_pte for it.
> 

It's not about the patch itself and just want more discussion to get more details.
The patch itself looks good to me. I got two questions as below:

(1) The memslot fails to be added if it's backed by MMIO region and dirty logging is
enabled in kvm_arch_prepare_memory_region(). As Santosh reported, the corresponding
vma could be associated with MMIO region and VM_PFNMAP is missed. In this case,
kvm_arch_prepare_memory_region() isn't returning error, meaning the memslot can be
added successfully and block mapping isn't used, as you mentioned. The question is
the memslot is added, but the expected result would be failure.

(2) If dirty logging is enabled on the MMIO memslot, everything should be fine. If
the dirty logging isn't enabled and VM_PFNMAP isn't set yet in user_mem_abort(),
block mapping won't be used and PAGE_SIZE is picked, but the failing IPA might
be good candidate for block mapping. It means we miss something for blocking
mapping?

By the way, do you have idea why dirty logging can't be enabled on MMIO memslot?
I guess Marc might know the history. For example, QEMU is taking "/dev/mem" or
"/dev/kmem" to back guest's memory, the vma is marked as MMIO, but dirty logging
and migration isn't supported?

Thanks,
Gavin

