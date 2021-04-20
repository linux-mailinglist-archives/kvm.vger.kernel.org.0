Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D468D365D37
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 18:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhDTQZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 12:25:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232473AbhDTQZ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 12:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618935896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLcG5OyaNHku0PtrgN264QDcVOjTc4dbGZJwd4rN2TU=;
        b=V7Az/9mGEyxzLCtjUX9AeQJHEuNJ+OO4G7MmSBk6HLQzO3zF+ZEDTC9XjPic07reytT/rb
        GATXUD4/MqnMF+8O4lR5lxeZRW8QGhl/8nzpUWRUbMjaJvHa9R6dTffk0eeU/fsONe6uks
        NIO90GFoWuqYMVdsNoKmVIcKAZjnObY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-jmCYT37kNgm0qcWEBGGd3g-1; Tue, 20 Apr 2021 12:24:54 -0400
X-MC-Unique: jmCYT37kNgm0qcWEBGGd3g-1
Received: by mail-ed1-f72.google.com with SMTP id n18-20020a0564020612b02903853320059eso4387378edv.0
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 09:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLcG5OyaNHku0PtrgN264QDcVOjTc4dbGZJwd4rN2TU=;
        b=q79x/Xv4U0n2NpxyIUiVsRIx58an84HCUbAWGX91d7om0sgAQwyX9FF1rfljoIBJCe
         8d20NTpGdpCLzj/VTQsoGuD/lnfaGbZvLPPpuz76E3ry35cKSGYNmPhu0ytcRaA9y8jY
         OcE9yW38cWvgVdY/prVhoonljPQ54MdD8FlRHWpS0cUjtyrswMXuTeAkS31wJoVLI4i5
         TzIbj80CgUPs79Sxd0OPEZ9x0n5th4FGNX9EQLJqmap9zLafgg/ZneETU2fvWGIo2oP4
         mwHJSomWs5VaOIGY+3rV4+l2DhYb53xozDoNTw3S60cMs8Lpq4mm9IguexnVwiLARygb
         j7Yw==
X-Gm-Message-State: AOAM532f9kElK78dwpC3n1Ypt2xOEzG8HbEQmej5WJqsd7Sl9tIVvOIv
        dX804icfOFrw3Nse298jI9uqVD1MN+24ucDLm9aR9dTj3YldPYxRds+jGu8Cm0tpK7C3WGbxOug
        RV9NvIEFrVlH8
X-Received: by 2002:a17:906:34da:: with SMTP id h26mr27944391ejb.496.1618935893434;
        Tue, 20 Apr 2021 09:24:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws1XKsATYiny/fBfVmMA+efwU+NuFd8mA4iIaBE90k/UA9tkXxnm8FYavk2EfJmE9m/sgjwg==
X-Received: by 2002:a17:906:34da:: with SMTP id h26mr27944372ejb.496.1618935893207;
        Tue, 20 Apr 2021 09:24:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b22sm16228566edv.96.2021.04.20.09.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 09:24:52 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Always run vCPU thread with blocked
 SIG_IPI
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210420081614.684787-1-pbonzini@redhat.com>
 <20210420143739.GA4440@xz-x1> <20210420153223.GB4440@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <84c52ebe-58a2-6188-270e-c86409e44fa3@redhat.com>
Date:   Tue, 20 Apr 2021 18:24:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210420153223.GB4440@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 17:32, Peter Xu wrote:
> On Tue, Apr 20, 2021 at 10:37:39AM -0400, Peter Xu wrote:
>> On Tue, Apr 20, 2021 at 04:16:14AM -0400, Paolo Bonzini wrote:
>>> The main thread could start to send SIG_IPI at any time, even before signal
>>> blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
>>> blocked.
>>>
>>> Without this patch, on very busy cores the dirty_log_test could fail directly
>>> on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).
>>>
>>> Reported-by: Peter Xu <peterx@redhat.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Yes, indeed better! :)
>>
>> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> I just remembered one thing: this will avoid program quits, but still we'll get
> the signal missing.

In what sense the signal will be missing?  As long as the thread exists, 
the signal will be accepted (but not delivered because it is blocked); 
it will then be delivered on the first KVM_RUN.

Paolo

   From that pov I slightly prefer the old patch.  However
> not a big deal so far as only dirty ring uses SIG_IPI, so there's always ring
> full which will just delay the kick. It's just we need to remember this when we
> extend IPI to non-dirty-ring tests as the kick is prone to be lost then.
> 
> Thanks,
> 

