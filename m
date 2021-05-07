Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EBC37614F
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 09:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhEGHl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 03:41:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231179AbhEGHl1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 03:41:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620373227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cytpn5HUqqHMQi7fHCbchsnpUSL44ZuNU5lozqiis8I=;
        b=Vj7VxN4KJSZLyja15lpWInfSGG3t2c5YptbWcP/AfwgzhrhmlM+ATPBnR730OWHtHKQnHY
        J0WNSHSCv6z/5JnAfyvYSpVDASJKKK3GhbBsdLjPvwGKtKh2IHk56/JBYfprDPquZhBCda
        NXobOMEmlfQgX6gYENnKO8kvTUVhq5A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384--oWfnzjPPx28lJP73_gG7A-1; Fri, 07 May 2021 03:40:25 -0400
X-MC-Unique: -oWfnzjPPx28lJP73_gG7A-1
Received: by mail-wm1-f71.google.com with SMTP id s66-20020a1ca9450000b0290149fce15f03so3602973wme.9
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 00:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cytpn5HUqqHMQi7fHCbchsnpUSL44ZuNU5lozqiis8I=;
        b=r0a5/9QpgJJnbfsK3WiLd3VOqIChuVWWKYl07KgcSAA42KA0e3tzJMFZDoijdubWyM
         vyd14AdWNS6nvpLtKIpprFmo876MLHFr6e8Hf+8pyPoSC4zUt7c/28GjjdGHNjfkPlwY
         ReWd+NI/nNpHrwzO0nCUsL9YOdwqjClXH2FhWgz8D528O4d772pC9aWHWJIfXPJXD3wW
         b03dKLAB0GzEV0DCGHimY7jmKMveO5AJqw1CyTZE+g6S9GiPH5FNK4EEEpfsBQvNmKnP
         6Y1klLudW19Zo7zwZSRgIi9cD18vA8rINpbr59iwbhFWowa6Ei2J6WrQOainAouIntNY
         Vd0w==
X-Gm-Message-State: AOAM531jVPDr+Z8dETv8oA/TuB3NnsnsUEkmti3vMVQNSf5MmgY5nkCz
        GvOyGFOTjR3+URgAX7g7etbnUmi3c/3qjW1+P8LxibPpy/U2IPQX2s6VvO9WlIsDft/Hz2LilSI
        hre52VHOgATrB
X-Received: by 2002:a5d:4532:: with SMTP id j18mr10234873wra.223.1620373224754;
        Fri, 07 May 2021 00:40:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzKBTGBiLC4DaItIJ6x7hljljQiDIHXoHip9FQtBMJTCeRTrmEtRTYf6EtYcNjww90epWJyg==
X-Received: by 2002:a5d:4532:: with SMTP id j18mr10234842wra.223.1620373224509;
        Fri, 07 May 2021 00:40:24 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c63c0.dip0.t-ipconnect.de. [91.12.99.192])
        by smtp.gmail.com with ESMTPSA id x8sm7313019wru.70.2021.05.07.00.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:40:24 -0700 (PDT)
Subject: Re: [PATCH v3 0/8] Lazily allocate memslot rmaps
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <05848766-b13c-2a58-81da-0f1e839a6cd0@redhat.com>
Date:   Fri, 7 May 2021 09:40:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506184241.618958-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.05.21 20:42, Ben Gardon wrote:
> This series enables KVM to save memory when using the TDP MMU by waiting
> to allocate memslot rmaps until they are needed. To do this, KVM tracks
> whether or not a shadow root has been allocated. In order to get away
> with not allocating the rmaps, KVM must also be sure to skip operations
> which iterate over the rmaps. If the TDP MMU is in use and we have not
> allocated a shadow root, these operations would essentially be op-ops
> anyway. Skipping the rmap operations has a secondary benefit of avoiding
> acquiring the MMU lock in write mode in many cases, substantially
> reducing MMU lock contention.
> 
> This series was tested on an Intel Skylake machine. With the TDP MMU off
> and on, this introduced no new failures on kvm-unit-tests or KVM selftests.
> 

Happy to see this change pop up, I remember discussing this with Paolo 
recently.

Another step to reduce the rmap overhead could be looking into using a 
dynamic datastructure to manage the rmap, instead of allocating a 
fixed-sized array. That could also significantly reduce memory overhead 
in some setups and give us more flexibility, for example, for resizing 
or splitting slots atomically.

-- 
Thanks,

David / dhildenb

