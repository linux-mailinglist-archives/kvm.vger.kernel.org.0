Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3833793EE
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhEJQfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:35:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231374AbhEJQeu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620664423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdODaN2OuNSEexqz+L9Iw9HnmwvY9206zRfzY1Y1re8=;
        b=AI9BgH5wyf3tsACpy3zqeramlkUIHZt/0Zxw2BPQ7WFNwDonEWsk3nAVhadh33UzCyDLa7
        VJj1ApOruUw5vEwbKJrTfPLuFWYFbAv3fr0vWysu7utE4ixzwFSvDdk/+PcBlbD//oDO6n
        nCJIzGCilCEkORRo/BsUWxzc9godpmU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-EzsrWthDNNeypU6ztMBzNg-1; Mon, 10 May 2021 12:33:41 -0400
X-MC-Unique: EzsrWthDNNeypU6ztMBzNg-1
Received: by mail-wr1-f71.google.com with SMTP id a12-20020a5d6cac0000b0290109c3c8d66fso7711128wra.15
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qdODaN2OuNSEexqz+L9Iw9HnmwvY9206zRfzY1Y1re8=;
        b=UrjUOZDPFNEWQq6DJq6OF83tn+IVWtIpuhBVtnjL9QXOvHS5shnu9LVKZeBJ+oxI7C
         RB+BNzwh6OGzEv689/XvYvZZzsGtn9WLS+enTwWWe7+H7rPh0nIUVx+bxQbwLQ2Q96tq
         fzIHZT24kzP5jphwq4fw7tJp/BeRn10EfZba5SJVgCOeSC62nCe6gX3bdH2419nqoEb3
         KLGOfIz3+wLy3hIvyUjzhqwZM73o44xmHzuSp76MIYKDPQyb8TccagMXN7zgtueGQCDg
         EHmByRymzhetN3tlWBeXR8K7J6WmBbwuM/ih0cqrm5uWaOEAVZtDAnjo6O8n854/EdSy
         bdUg==
X-Gm-Message-State: AOAM533yNIxW4a79BtNq7dxfrC/8+RreDSCJeZ7GOrwygiRoY5gTm3mF
        2Ov9l57mhjkSDpKMy7zhAG8qUu3gg/yADZq/exRLvZ0F6/tDMyrmKAn/wNnzv2G/9Xkbb1bwGzj
        NQGFYUFf81Bg9
X-Received: by 2002:a5d:4acd:: with SMTP id y13mr31236158wrs.185.1620664420466;
        Mon, 10 May 2021 09:33:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEuMcVvwepkIW8kBENdv7Ek4C4HWRYfJRgWlPpdHVtYoJM2zVP457NBhPvPMR/41vsF70XQA==
X-Received: by 2002:a5d:4acd:: with SMTP id y13mr31236133wrs.185.1620664420237;
        Mon, 10 May 2021 09:33:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c15sm2310454wml.38.2021.05.10.09.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 09:33:39 -0700 (PDT)
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Add a field to control memslot rmap
 allocation
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-6-bgardon@google.com>
 <CANgfPd-eJsHRYARTa0tm4EUVQyXvdQxGQfGfj=qLi5vkLTG6pw@mail.gmail.com>
 <a12eaa7e-f422-d8f4-e024-492aa038a398@redhat.com>
 <CANgfPd8BNtsSwujZnk9GAfP8Xmjy7B3yHdTOnh45wbmNU_yOQw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <03e66630-b967-b91c-b74e-6944bdcaf2d7@redhat.com>
Date:   Mon, 10 May 2021 18:33:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd8BNtsSwujZnk9GAfP8Xmjy7B3yHdTOnh45wbmNU_yOQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/05/21 18:14, Ben Gardon wrote:
>> Possibly stupid (or at least lazy) question: why can't it be a "normal"
>> static inline function?
> That was my initial approach (hence the leftover inline) but I got
> some warnings about a forward declaration of struct kvm because
> arch/x86/include/asm/kvm_host.h doesn't include virt/kvm/kvm_host.h.
> Maybe there's a way to fix that, but I didn't want to mess with it.
> 

Let's just use the field directly.

Paolo

