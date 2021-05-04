Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C845137314D
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhEDUUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:20:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231579AbhEDUUN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 16:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620159557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XT5wmldVjcj9qzq2rbcAVF3LYdtWWQb01hB//6q8U0E=;
        b=YkAMpQTWV4EirDr71uhXgmVeEIfq7sxMJS7FwM6H+FYb1Qc0aY2KW+589Sm9quvvnQ9upb
        IpKw7FE9NRpGjm14v9kK/otJXR1AeCiaEH0OUwFR5E8cQ6WftQWpC0IDYhjfJ41WGXxuWe
        Wryq05wR4ZYmWskqmUors0hEBV0Z0kM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-BwjIy3VsMbaB1ys089EmrQ-1; Tue, 04 May 2021 16:19:15 -0400
X-MC-Unique: BwjIy3VsMbaB1ys089EmrQ-1
Received: by mail-ej1-f71.google.com with SMTP id yh1-20020a17090706e1b029038d0f848c7aso3614326ejb.12
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XT5wmldVjcj9qzq2rbcAVF3LYdtWWQb01hB//6q8U0E=;
        b=nDWmJo9z3eUM0b6NZnGGlurwBpPhi3VpV7Efg6J5erPehnRnXtQoF98a/VpjUU8Efg
         niRBCs4jSNXFJvB2hH6vqrY+JYHGKQe1zuqQsuY1gQhDuJFDw9Mn7pL9tn+PfAGs+ly7
         XTKUKN4OXjcS1Yh2Syat4kyAuTJXttdVFFbo3t1Bk4AaT6QpiffL57Kd5PA9E6//DAeK
         pL9HBM6fStCbv4W2WT67aXRVjD1+XtR6odFk0jLGK+RM3iW+vz9UF7NdZAg3GtCB7/G2
         MjigtuPh6pF7x9fY9EtIYDw2f7onDjzk8iKWVZvvSr5A5pYquQHOlZg0SpZdZoLNSRCD
         DjVA==
X-Gm-Message-State: AOAM530Iq+k3zVrEgPIv74Gc1f8vPF281zCtb4diRq28LENoHR4rNUUs
        SaF9ZH1fhjuWVdoCHvVrmfG7eakz3X2CVa2uSNvnbEJc4RSyk1qmSXRanYJF7lmXJzNpveDuecZ
        mNQ97gy3mh1eG
X-Received: by 2002:a17:906:f0d1:: with SMTP id dk17mr24298929ejb.256.1620159554133;
        Tue, 04 May 2021 13:19:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7qgPDq/WT4usRYakJCroraJvYEIPirrEpNH9of0IyZWOEVewfiFFivXTogMTwWuarhK6EJQ==
X-Received: by 2002:a17:906:f0d1:: with SMTP id dk17mr24298918ejb.256.1620159553980;
        Tue, 04 May 2021 13:19:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id m9sm2013860ejj.53.2021.05.04.13.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 13:19:13 -0700 (PDT)
Subject: Re: [PATCH v2 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-8-bgardon@google.com> <YJGqzZ/8CS8mSx2c@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <781d2549-bbb1-23a2-44bf-58379ba23054@redhat.com>
Date:   Tue, 4 May 2021 22:19:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJGqzZ/8CS8mSx2c@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 22:13, Sean Christopherson wrote:
>> +	/*
>> +	 * If set, the rmap should be allocated for any newly created or
>> +	 * modified memslots. If allocating rmaps lazily, this may be set
>> +	 * before the rmaps are allocated for existing memslots, but
>> +	 * shadow_mmu_active will not be set until after the rmaps are fully
>> +	 * allocated.
>> +	 */
>> +	bool alloc_memslot_rmaps;
> Maybe "need_rmaps" or "need_memslot_rmaps"?
> 

Since we're bikeshedding I prefer "memslots_have_rmaps" or something not 
too distant from that.

Paolo

