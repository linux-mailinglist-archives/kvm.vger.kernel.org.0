Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6F045EFB8
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 15:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348330AbhKZOTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 09:19:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352302AbhKZORJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 09:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637936035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S+ayN7nEUDOCOVOlb0Xt09tgsb4FSIikabfFFVESVsA=;
        b=D1feMQwcBPXl2snoP8N4ZJzLPtR6fCerDnOWu1TvfDkd5Uu9WF0ozLZ2wdCcRpP1x84a5g
        xdhTh2Gfxxpm4m+fOSSoX/Xznrv+mcQVHN9jUo69Z1nIMQVHvTe+3ws1YWLoxcTk+37JBy
        3HfZOW9TMYaAyox8VU4xYSK520CFmK0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-IysUm9s6MD-duDmZ2L6Wvw-1; Fri, 26 Nov 2021 09:13:54 -0500
X-MC-Unique: IysUm9s6MD-duDmZ2L6Wvw-1
Received: by mail-pl1-f198.google.com with SMTP id z3-20020a170903018300b0014224dca4a1so4051411plg.0
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 06:13:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S+ayN7nEUDOCOVOlb0Xt09tgsb4FSIikabfFFVESVsA=;
        b=jtwMPSveb35HHdjTFEe1q0JHu7SFtQLaaa2s1VwKu27uS+TCMgDTTxBDdFd9mpg4L7
         F0OEmHLkgRZvY0Nzoi4RASh+CuTyjX+OhJ6HVOaOxYSMm1lEoSwOu1TvOkyA2HiDfAhj
         mvJkkWFzM1W/XH8CIzTB04yKPcR7uvvzWMKEq0vqFS31C8bZJPwSP1QT286DcIskVn1G
         l82CGCAYAPgxaSnQ7ztJZyTPQHvH9O04uk+An5gaZkv6bnLxylZz5+5ME2fSSShiNPhD
         KuTVOWbbnUKuYnyQj6DQtHdcZscVVRk4o27fllQiEcalG+jAh0ShVJ7vtcIgtANdY+id
         fp5w==
X-Gm-Message-State: AOAM5328f1QydrffHY0YqAdMY+Ym3rn2xzxOYCiX79JCR++5h/5BK/aM
        nhoTfg4nR+2t3Pz/VYRUnTUnYgzEZYsa7WqyANxpFVOuaBW/nykyPSHzg1IMEbZTEaTOGSi3HG7
        l32+Kzol5nQbe
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr15757066pjb.8.1637936033492;
        Fri, 26 Nov 2021 06:13:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7XgK6MrbwoXugVsjZDZRDE9bL3phfHt/oecY1MEMqYGKYSm1Re8IqpPlV4yKjuBxSZaIpQA==
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr15757017pjb.8.1637936033132;
        Fri, 26 Nov 2021 06:13:53 -0800 (PST)
Received: from xz-m1.local ([94.177.118.150])
        by smtp.gmail.com with ESMTPSA id v63sm5182406pgv.71.2021.11.26.06.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 06:13:52 -0800 (PST)
Date:   Fri, 26 Nov 2021 22:13:44 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 00/15] KVM: x86/mmu: Eager Page Splitting for the TDP
 MMU
Message-ID: <YaDrmNVsXSMXR72Z@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, David,

On Fri, Nov 19, 2021 at 11:57:44PM +0000, David Matlack wrote:
> This series is a first pass at implementing Eager Page Splitting for the
> TDP MMU. For context on the motivation and design of Eager Page
> Splitting, please see the RFC design proposal and discussion [1].
> 
> Paolo, I went ahead and added splitting in both the intially-all-set
> case (only splitting the region passed to CLEAR_DIRTY_LOG) and the
> case where we are not using initially-all-set (splitting the entire
> memslot when dirty logging is enabled) to give you an idea of what
> both look like.
> 
> Note: I will be on vacation all of next week so I will not be able to
> respond to reviews until Monday November 29. I thought it would be
> useful to seed discussion and reviews with an early version of the code
> rather than putting it off another week. But feel free to also ignore
> this until I get back :)
> 
> This series compiles and passes the most basic splitting test:
> 
> $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 2 -i 4
> 
> But please operate under the assumption that this code is probably
> buggy.
> 
> [1] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t

Will there be more numbers to show in the formal patchset?  It's interesting to
know how "First Pass Dirty Memory Time" will change comparing to the rfc
numbers; I can have a feel of it, but still. :) Also, not only how it speedup
guest dirty apps, but also some general measurement on how it slows down
KVM_SET_USER_MEMORY_REGION (!init-all-set) or CLEAR_LOG (init-all-set) would be
even nicer (for CLEAR, I guess the 1st/2nd+ round will have different overhead).

Besides that, I'm also wondering whether we should still have a knob for it, as
I'm wondering what if the use case is the kind where eager split huge page may
not help at all.  What I'm thinking:

  - Read-mostly guest overload; split huge page will speed up rare writes, but
    at the meantime drag readers down due to huge->small page mappings.

  - Writes-over-very-limited-region workload: say we have 1T guest and the app
    in the guest only writes 10G part of it.  Hmm not sure whether it exists..

  - Postcopy targeted: it means precopy may only run a few iterations just to
    send the static pages, so the migration duration will be relatively short,
    and the write just didn't spread a lot to the whole guest mem.

I don't really think any of the example is strong enough as they're all very
corner cased, but just to show what I meant to raise this question on whether
unconditionally eager split is the best approach.

Thanks,

-- 
Peter Xu

