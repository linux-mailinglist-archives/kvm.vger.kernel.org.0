Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565C2316990
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 15:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhBJO6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 09:58:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhBJO6s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 09:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612969040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PA7CbQ28iF3COQPnO4RZrKLSnHnB37vlar5EOpU27eg=;
        b=iMAFQ6/1SoKJJPIOKBfwtRtj3D3IILGPjzq1vwqelrF9l1YGnf0Y9pH5282i+zwuPzhE1x
        8bUftwNiOxVLLmdOfYW8KgJVwxX9p4VyVMb/RONmPToEMS8RqOQb0t25ULuqROgI24RWmW
        vROMDe4DYhiDZB9ekSnjs8Mc45uInN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-luhDp1vNMdKn38bF2w6E4Q-1; Wed, 10 Feb 2021 09:57:19 -0500
X-MC-Unique: luhDp1vNMdKn38bF2w6E4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30FCF106BC6D;
        Wed, 10 Feb 2021 14:57:17 +0000 (UTC)
Received: from llong.remote.csb (ovpn-115-20.rdu2.redhat.com [10.10.115.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42CFD57;
        Wed, 10 Feb 2021 14:57:12 +0000 (UTC)
Subject: Re: [PATCH v2 06/28] locking/rwlocks: Add contention detection for
 rwlocks
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-7-bgardon@google.com>
 <20210209203908.GA255655@roeck-us.net>
 <3ee109cd-e406-4a70-17e8-dfeae7664f5f@redhat.com>
 <20210209222519.GA178687@roeck-us.net>
 <fc7792e2-26f1-2b37-fb79-002d8d6d4ef7@redhat.com>
 <4e00a7a6-aad4-57cf-0cd3-93338a5f363f@roeck-us.net>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <d578ea0f-5177-929a-6a5f-4a3e79ab511c@redhat.com>
Date:   Wed, 10 Feb 2021 09:57:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <4e00a7a6-aad4-57cf-0cd3-93338a5f363f@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/21 1:04 AM, Guenter Roeck wrote:
> On 2/9/21 4:27 PM, Waiman Long wrote:
> [ ... ]
>
>> It is because in arch/mips/include/asm/spinlock.h, asm/qrwlock.h is included before asm/qspinlock.h. The compilation error should be gone if the asm/qrwlock.h is removed or moved after asm/qspinlock.h.
>>
>> I did a x86 build and there was no compilation issue.
>>
> I can not really comment on what exactly is wrong - I don't know the code well
> enough to do that - but I don't think this is a valid argument.
>
> Anyway, it seems like mips is the only architecture affected by the problem.
> I am not entirely sure, though - linux-next is too broken for that.

It does look like a rather common practice to include both qrwlock.h and 
qspinlock.h in asm/spinlock.h file. I have just a patch to make sure 
that qrwlock is always included after qspinlock.h if present. Hopefully 
that can fix the compilation problem.

Cheers,
Longman

