Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE975E9C72
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 10:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbiIZIud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 04:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiIZIuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 04:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A456316
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 01:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664182207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ISvikFtP5DIuopUJ+ZDU0jE0NajkftdGvG2rBa3msvE=;
        b=VVy7+IFHSEeTd6Vv7CW7t2VsN7ayRyo6wzOC23ITsstY9PynHCv69BTx3HEyRI8Aa233/D
        /zoeBpA+MrilVOpuimBJSfSLUalXE63ouxaC+a5oNdpiZKBi6dX6ufAlQI/ovSGSiaWYZ6
        nGhBOoLB/9quTfAFiF8Rs6DzKmY6G2Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-I8o_WjdcM7ODue3ULHuoSQ-1; Mon, 26 Sep 2022 04:50:06 -0400
X-MC-Unique: I8o_WjdcM7ODue3ULHuoSQ-1
Received: by mail-wm1-f70.google.com with SMTP id 62-20020a1c0241000000b003b4922046e5so3856586wmc.1
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 01:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ISvikFtP5DIuopUJ+ZDU0jE0NajkftdGvG2rBa3msvE=;
        b=jwTTGp16hp/WyoNErtgU0xwv4zYJ27nBa9rSYf9HNStHODWcCZcav/9gWZCiQj1pcj
         L65S8VUcI3aGCS5kb+EHTbOPuJWejJRgfMLtXQUERSLIorI5jdnik6nFY/ffGrRlg/eU
         L3P8FAB5CtnQYOSzA0E7/nOkYHakH8WtzhHSXdiZtmLLJ5BDOOI5O8wX/C9ZRfh+GKUd
         jGfAHgEyITCkDiIMWswKUtrLSU0IkjMFB4vXR8CJD0fXRI6qGbqs65ub/vJzuI6AE+4I
         szPhXeSOzkqTvBWJC//T82PItWtlHp32+qP5xUkn6o5UDp1kUFnt2UbE9xmME3jg5XkU
         8Ryg==
X-Gm-Message-State: ACrzQf2SZ8R/7xVZmL0mx0zL4a2sLcZdhTA3eJPXzouBblyA9GBABOKo
        4VSarYjrZF2AXVi0gjd6roN0KSHUV9zGw990kEgmRwjKu7pVdIYUjRARXCO0ufwCViJEXnPq3/T
        l7ToTnVGmnX6Y
X-Received: by 2002:a05:6000:1849:b0:228:c848:2593 with SMTP id c9-20020a056000184900b00228c8482593mr12788821wri.557.1664182205220;
        Mon, 26 Sep 2022 01:50:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Hfh3ycDEEf+U8H4S0LbycgueuKVXF2+jFJr6wuVTH0HDBDxm6tsWjWlimAj6cOgR6DfVtFg==
X-Received: by 2002:a05:6000:1849:b0:228:c848:2593 with SMTP id c9-20020a056000184900b00228c8482593mr12788811wri.557.1664182205014;
        Mon, 26 Sep 2022 01:50:05 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bg7-20020a05600c3c8700b003a5c999cd1asm13194689wmb.14.2022.09.26.01.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 01:50:04 -0700 (PDT)
Message-ID: <d9036fdc-1fd5-f5bd-1afa-7b7243f681c0@redhat.com>
Date:   Mon, 26 Sep 2022 10:50:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: The root cause of failure of access_tracking_perf_test in a
 nested guest
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>
References: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
 <CALMp9eSJbb6sSmv4c8c3ebCtfgdAARgryq5jHXdRmhxm6fYQsw@mail.gmail.com>
 <Yy4W86qofpjoh2LA@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <Yy4W86qofpjoh2LA@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 23/09/2022 um 22:28 schrieb David Matlack:
> On Fri, Sep 23, 2022 at 12:25:00PM -0700, Jim Mattson wrote:
>> On Fri, Sep 23, 2022 at 3:16 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>>>
>>> Because of this, when the guest clears the accessed bit in its nested EPT entries, KVM doesn't
>>> notice/intercept it and corresponding EPT sptes remain the same, thus later the guest access to
>>> the memory is not intercepted and because of this doesn't turn back
>>> the accessed bit in the guest EPT tables.
>>
>> Does the guest execute an INVEPT after clearing the accessed bit?
> 
> No, that's the problem. In L1, access_tracking_perf_test is using
> page_idle to mark guest memory as idle, which results in clear_young()
> notifiers being sent to KVM clear access bits. clear_young() is
> explicitly allowed to omit flushes, so KVM happily obliges.
> 
> 	/*
> 	 * clear_young is a lightweight version of clear_flush_young. Like the
> 	 * latter, it is supposed to test-and-clear the young/accessed bitflag
> 	 * in the secondary pte, but it may omit flushing the secondary tlb.
> 	 */
> 	int (*clear_young)(struct mmu_notifier *subscription,
> 			   struct mm_struct *mm,
> 			   unsigned long start,
> 			   unsigned long end);
> 
> We could modify page_idle so that KVM performs TLB flushes. For example,
> add a mechanism for userspace to trigger a TLB flush. Or change
> page_idle to use clear_flush_young() (although that would be incredibly
> expensive since page_idle only allows clearing one pfn at a time). But
> I'm not sure creating a new userspace API just for this test is really
> worth it, especially with multigen LRU coming soon.
> 

Thank you David and Jim for the feedback.
I sent a patch converting the assertion in warning here:
https://lkml.org/lkml/2022/9/26/238

Thank you,
Emanuele

