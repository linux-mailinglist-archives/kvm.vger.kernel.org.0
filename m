Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F094EFC73
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 00:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353170AbiDAWBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 18:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353243AbiDAWBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 18:01:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4D4C1C231C
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 14:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648850384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=61wW65IickgTmxTx2khZS+SxGaK0lmd6zMvqkKt3GSY=;
        b=NY5LCWYLhsHliEE0u6U3x7nqmXm+7WGL7BY4dB6vn+nSMS+VZYtJ2eBCSXUuQ8Luu8KTho
        mPM7fQChdSO2NaNn3m3xE2ro4pkEstCOdbeBchiyiuu004AxiBnf/7xDCMD4Od9NW3kkU2
        mDquGrHfXjfJRvkdR7gBQNFD+DNOJOA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-GXQl4Wn7PweV-hPQMIlXug-1; Fri, 01 Apr 2022 17:59:43 -0400
X-MC-Unique: GXQl4Wn7PweV-hPQMIlXug-1
Received: by mail-ej1-f70.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so2228057eje.6
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 14:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=61wW65IickgTmxTx2khZS+SxGaK0lmd6zMvqkKt3GSY=;
        b=DGIPqpKclvp6kbZ6wDoNjavVQz2Qr10/Fj7iG322wUKabdSNUwz390YwpvvD12xTZ7
         wOR+GO7fIio83Lna6z1DhjiWSEsvfl3E/IeacH8AGDyTB9Q3hwWqqIYqhDheUWuCiPK6
         TZL6hfoNooryZN/oe092njPPAKXHzXd37gyGAKJIDtQNldfetFQiYAcy532WrRBTgAXp
         NchF5gXP0Fs9rQizTyqXadpDJ1KCJONkOZHfNSO72gKUA2sx5CTQdr+L7r8FMXpBACGD
         k94bh3RKF8PLLqIaD9OHIMEjm01IEyPA73IhY8cNR6dDT8L6GINbSsPSGDGKnFxf5Q8A
         wfGw==
X-Gm-Message-State: AOAM5314oMfZtAoT3XvUOzSPbBhgpaSpjyM+lOqYOKgTW1oAlWA34JuQ
        5sRgOBVXswLfQCRirRFcIP2APaoipt9mhBHfddvHY/Oe3wBYu9j369mfdzdgbRRQf9hUZKc4HFR
        Z4Yal/8lgmlJK
X-Received: by 2002:a05:6402:5107:b0:419:935d:bb6e with SMTP id m7-20020a056402510700b00419935dbb6emr22861737edd.242.1648850382152;
        Fri, 01 Apr 2022 14:59:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyVwN8jLrGhcGscqlNjTLvmUrq0hjTs8PZsenn7ftgxg0OLULJ9IB8wuh6jl4vWUU3f72jdw==
X-Received: by 2002:a05:6402:5107:b0:419:935d:bb6e with SMTP id m7-20020a056402510700b00419935dbb6emr22861728edd.242.1648850381896;
        Fri, 01 Apr 2022 14:59:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id o3-20020aa7dd43000000b00419db53ae65sm1691942edw.7.2022.04.01.14.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 14:59:41 -0700 (PDT)
Message-ID: <30ffdecc-6ecd-5194-14ec-40e8b818889a@redhat.com>
Date:   Fri, 1 Apr 2022 23:59:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.18
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20220401153256.103938-1-pbonzini@redhat.com>
 <CAHk-=wgSqvsP08ox-KwAU4TztVsjx07cMQni-rFEzxZQw6+iiA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAHk-=wgSqvsP08ox-KwAU4TztVsjx07cMQni-rFEzxZQw6+iiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 22:40, Linus Torvalds wrote:
> I've had enough with the big random kvm pull requests.
> 
> NONE of this has been in linux-next before the merge window. In fact,
> None of it was there even the first week of the merge window.
> 
> So by all means send me fixes.
> 
> But no more of this last-minute development stuff, which clearly was
> not ready to go before the merge window started, and must have been
> some wild last-minute merging thing.

tl;dr okey dokey, will resend in a few minutes.  But anyway here's a 
description of how I do things; there's certainly a lot of variability 
among subsystems, so perhaps it helps to share it.

All this stuff in general has been ready for a few weeks, even though it 
was not committed to linux-next.  It was not committed because in 
general I prioritize big merges that affect existing code, as those need 
a lot more time in linux-next and absolutely go in the first pull 
request.  These are the larger patch series with higher chance of 
introducing regressions, often nondeterministic ones with little 
possibility to bisect, and they take a lot of time for both reviewing 
and testing.

While I focus on the bigger stuff for the first pull request, others are 
busy sending and also reviewing smaller series.  I start to grab around 
-rc6, though this time it was a bit later due to a larger first PR and 
due to the whole family being sick at the wrong time.  But in general, 
things that spill into the second week of the merge window are usually:

* covered very well by the testsuites (today's pull request was 30% 
documentation and tests; those tests only cover new code and even more 
tests exist outside the selftests framework and outside the Linux tree).

* and/or only activated by userspace bits that only exist in developer 
trees, or sometimes do not exist at all outside Amazon/Google.

Very often, at the time this code is merged, there are zero chances that 
any linux-next tester ever hits the code except via selftests or static 
analysis; even syzkaller needs to be taught the new ioctls.

This is a workflow that I've been using for a few years.  If that's not 
okay, I can certainly stop doing that and only send one pull request.

> kvm needs to make stability as a priority.

We are, and this includes both selftests for new features and lots of 
eyes looking at older code.  Some of that crappy code I can definitely 
blame on my own inexperience or overwork; I am happy that people go 
through it with a fine-toothed comb and I try to help as well (which 
takes away time from development, so you could say it also helps stability).

Of the stuff you see from me during -rc, merge-window bugs are 
relatively rare and merge-window regressions even less so.  Instead 
you'll see a lot of new selftests, fixes to old bugs, cleaning up 
lockless code to removes nasty race conditions, etc. (one of these days 
I want to get some numbers to see if my intuition is correct, though).

Again, if you prefer this kind of work to go through the merge window 
because it's too large for -rc, that's fine by me.  But overall, rest 
assured that when I send things late it's not to sneak them into a 
release; if anything, it's out of abundance of caution, and wanting to 
keep linux-next.git and linux.git as stable and bisectable as possible.

Thanks,

Paolo

