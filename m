Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB368304C69
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbhAZWli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:41:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726658AbhAZR5B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 12:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611683726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMaRRif4x/o1qr3EHWx3D3A3paOWJunfGP7cUczujlk=;
        b=dGBvKwyXPmaFmMVVL/XjxTlJoEI3/fuDrTbCFwMkEjm6+JClkzZNIpV+G/OenYSiRsqPb/
        wUOpmF3YRIsGnHFc5/Le74ptRWZtQ74PGG8nxYmJurFuC11IWtJr8IbPuq7r7WltHwOx9J
        cFMKYfTu53gSFGdIszVnl4tN59rYcyg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-iVn_it3tN3acqfVtYs3RHQ-1; Tue, 26 Jan 2021 12:55:25 -0500
X-MC-Unique: iVn_it3tN3acqfVtYs3RHQ-1
Received: by mail-ed1-f70.google.com with SMTP id a26so9829885edx.8
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 09:55:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rMaRRif4x/o1qr3EHWx3D3A3paOWJunfGP7cUczujlk=;
        b=YAwCvRuewmMkgdV3wEfckm0J21URaB6hDLHLc64l400wJmnH6iuPdMLDkqPR90gYzc
         y6jyM78+gZfK8VT7JBppcAmWvi0xBoODhBGjENtGpr9Kw+7LuMgF9lWAmL+Mi/IBR6nX
         WUhYuIfyTTIDRNoStaH5wrhVXu7oW8GyHfdxjjYVaYOl+142vKN+bx6OY5ASr6Mi4sUH
         uVXvaIoOcaRTzpWZgTZrbkOMXvfV1agdfQ7jkMbeTS/okQ2zs69GBDei+74uOW7qrUdx
         4M1Kr6FvAShDXCYij6HrO+To2ylTDjyEjR5BbmEFQf/67we0UXT1Yw+m2D3clP1zpd2h
         IqTw==
X-Gm-Message-State: AOAM5330h5L5tl/3DbeifgX79RpV5bhHgpYp9fGgDTgmYBwnRdqzvxh6
        oatYXUhA7fFHTswJEIRahAHBYtU6FzqBy0k+XCRfngMgQOKYl96DQJnRRITYim/S2xx6JqjQpda
        i4c10mfBAUcNH
X-Received: by 2002:a17:906:4159:: with SMTP id l25mr3994041ejk.311.1611683723885;
        Tue, 26 Jan 2021 09:55:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6rarq4cXLZKda6ZVXoCfOJgKXeUCmPj3eahyTXTqq3OCDu6EEaLCS8azd/93eAI0Bboegcg==
X-Received: by 2002:a17:906:4159:: with SMTP id l25mr3993860ejk.311.1611683718719;
        Tue, 26 Jan 2021 09:55:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x16sm10255151ejc.22.2021.01.26.09.55.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:55:17 -0800 (PST)
Subject: Re: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
To:     Ben Gardon <bgardon@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-16-bgardon@google.com> <YAjIddUuw/SZ+7ut@google.com>
 <460d38b9-d920-9339-1293-5900d242db37@redhat.com>
 <CANgfPd_WvXP=mOnxFR8BY=WnbR5Gn8RpK7aR_mOrdDiCh4VEeQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fae0e326-cfd4-bf5d-97b5-ae632fb2de34@redhat.com>
Date:   Tue, 26 Jan 2021 18:55:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_WvXP=mOnxFR8BY=WnbR5Gn8RpK7aR_mOrdDiCh4VEeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 18:47, Ben Gardon wrote:
> Enough that it motivated me to implement this more complex union
> scheme. While the difference was pronounced in the dirty log perf test
> microbenchmark, it's an open question as to whether it would matter in
> practice.

I'll look at getting some numbers if it's just the dirty log perf test. 
  Did you see anything in the profile pointing specifically at rwlock?

Paolo

