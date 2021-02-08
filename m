Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9060A312F22
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 11:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhBHKgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 05:36:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232445AbhBHKeA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 05:34:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612780345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIhiGi3tffrJB8M0CstOij6wS4dG9pmtFfNY7bosUBs=;
        b=IMDeNJ8ZxYxyrVWtcLKK3AF1xcsgDEmvIP/neKVWYvKhDEw+ML3YE69//ywc5PUHjuVF8Z
        HTGbQvlgV98rqd3VPz9laXOpDmOoaqiLtS8LGBDDdcI2nXtmKND/TK/IGgzNmaS7aVwCw1
        +QHjYgct2x4WgXODWMbV+mXBnYPtCSo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-ckRHezvHMMO_RL-Y-22N-w-1; Mon, 08 Feb 2021 05:32:23 -0500
X-MC-Unique: ckRHezvHMMO_RL-Y-22N-w-1
Received: by mail-wm1-f69.google.com with SMTP id 5so6192194wmq.0
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 02:32:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tIhiGi3tffrJB8M0CstOij6wS4dG9pmtFfNY7bosUBs=;
        b=LNs9b8OMtiYJwdzOXvbXRnQiiRYwK7NKOj0Jwuzazi0j0dyi+dd3CI9itxuG2s+H6+
         NbvbfRspxHwGkpeApVEMKxHwxXzLxHHi64KzV3ze9YfiuQ0lOC0rHEy97agYVPSDhyHM
         HIVcfaTcU3RHd9fY4JaF0L65ZreN3LKsfvize0ExJH6SVFQaifJyVW0r9TPdgMqsMGvU
         LFL8q0FIxnfArPeIN8zmHIwBB568fFAWOFUKySERu0mqzUGMRxDMcoHXkjVJ+hggVWy3
         09X/lYnC4fEFq4RwlwJI7d1xGU0xCvbDm7DQvBxj3uMoF/iejA7dUznZWSGSIMEM3wI7
         P3pA==
X-Gm-Message-State: AOAM531YOGmSgJ684IjsIKZEQuq+YqFAPY8uBcELDkgIbccL/K5i5hN6
        Mf9n6IWwKdLRoqCHz0o2DfXJjczFjwgTMsSvVhaLFWdChT2LyaeSyhC7ZR20KZ2tQAjGDvs7liq
        XnoldD+hNYp8r
X-Received: by 2002:a1c:ac85:: with SMTP id v127mr14206956wme.133.1612780342164;
        Mon, 08 Feb 2021 02:32:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5NDtNh03Fedde5BKPhn5Y/gWXzTwngzIIFuFdsSyJ7K6lVw0SD/V6IRFc6mQzGG18jB+nUQ==
X-Received: by 2002:a1c:ac85:: with SMTP id v127mr14206943wme.133.1612780342023;
        Mon, 08 Feb 2021 02:32:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q19sm21480201wmj.23.2021.02.08.02.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 02:32:19 -0800 (PST)
Subject: Re: [PATCH v2 20/28] KVM: x86/mmu: Use atomic ops to set SPTEs in TDP
 MMU map
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-21-bgardon@google.com>
 <81f13e36-b2f9-a4bc-ab8e-75cedb88bbb1@redhat.com>
 <YB3iUde728MPiuo9@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a3c8a2c7-988d-edeb-a509-1075ebba5c82@redhat.com>
Date:   Mon, 8 Feb 2021 11:32:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YB3iUde728MPiuo9@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/21 01:26, Sean Christopherson wrote:
> We could fudge around it via #ifdef around the xchg().  Making all of tdp_mmu.c
> x86-64 only would be nice to avoid future annoyance, though the number of stubs
> required would be painful...

It's really just a handful, so it's worth it.

Paolo

