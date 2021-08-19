Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A02A3F1E4B
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhHSQsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:48:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhHSQsD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 12:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629391646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JS6+KgPuFS71NJ3a/aV8YKo6n5PSfgJ9w8mrHKj266c=;
        b=GyYtdgGqsBHGZ0erXqGzIjKorEpCV3M4HN5uI5Xf/JpKDoQYDw/E8dGmRVDGJzj38HVyR2
        qe01XaHan/6ArMLPExss/omUmR/56WTzfCO75gp7fEr9S2L0P2Z1nAAExtfWg929MzJ7Bs
        GEMpO/tGpPtviymnFBQk1RyCgFGSGW8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-47mtdvMnM9WzWbsEgy9hbg-1; Thu, 19 Aug 2021 12:47:25 -0400
X-MC-Unique: 47mtdvMnM9WzWbsEgy9hbg-1
Received: by mail-ed1-f70.google.com with SMTP id o17-20020aa7d3d1000000b003beaf992d17so3111882edr.13
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JS6+KgPuFS71NJ3a/aV8YKo6n5PSfgJ9w8mrHKj266c=;
        b=VqiANsrsXpJRY7hIEvX8/bCRknWU/9d/JiqNxvWDOXDA7oUml/QvnsBbfGrx7dsW7Z
         da6tVnKAKq/4OaI7YnQ1Nh6gA9uWFhBGJvQNMJe77mUcjiExXobjlEBY7lPk6IMlBqkR
         3Iu2qA/dMdvaQBzQh0SV5aseAwaJPSx0osybBTT8OOF03qWbVJUrDabxc8XcLVQ8MVpl
         vuoezeWVlwLsOE0KTW9M1AJSUPBXSh0jYcVkWYbAMnhrsl01MBGUAClkRylcWK1ydYKR
         yJCFWGeuknzOMiSoM9rz90uS5GCvXTub6P0cKhgbG+Rk9raZGPQPgl3CF+G+PDbSYRDI
         YUeQ==
X-Gm-Message-State: AOAM533jmwmNlORtPPb5sCgSI510g1HsWeOwfnaq4JKAeAtCH8IFtwxB
        d35EMHFcz5mon06SSsGwgVUhKvTefgLA6rLwcxrovF60dYZnAV1XO0uNs5FlJnRrReaq7Zq8e65
        7m1oTHGARS5Ee
X-Received: by 2002:a17:907:3e05:: with SMTP id hp5mr16688232ejc.527.1629391644045;
        Thu, 19 Aug 2021 09:47:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVdStx8EZOkBqFjVSj/6s9v6MyE7O8rtL2qYCu/AVVVxEB88b5ZeHRjLerFJVpOPyRgW4eHQ==
X-Received: by 2002:a17:907:3e05:: with SMTP id hp5mr16688212ejc.527.1629391643849;
        Thu, 19 Aug 2021 09:47:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id v8sm1917790edc.2.2021.08.19.09.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:47:23 -0700 (PDT)
Subject: Re: [RFC PATCH 5/6] KVM: x86/mmu: Avoid memslot lookup in rmap_add
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
 <20210813203504.2742757-6-dmatlack@google.com>
 <e6070335-3f7e-aebd-93cd-3fb42a426425@redhat.com>
 <CALzav=do97h9LtbWJfDaj0xRv5Ccq5m-bPq0u0=_h8ut=M6Eow@mail.gmail.com>
 <YR6JXKqSRlDcVqHL@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <03ed8989-5816-40e0-0047-b61d89e2a1fe@redhat.com>
Date:   Thu, 19 Aug 2021 18:47:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YR6JXKqSRlDcVqHL@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/08/21 18:39, Sean Christopherson wrote:
> On Thu, Aug 19, 2021, David Matlack wrote:
>> On Tue, Aug 17, 2021 at 5:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> I've started hacking on the above, but didn't quite finish.  I'll
>>> keep patches 4-6 in my queue, but they'll have to wait for 5.15.
>>
>> Ack. 5.15 sounds good. Let me know if you want any helping with testing.
> 
> Paolo, I assume you meant 5.16?  Or is my math worse than usual?

Yeah, of course.  In fact, kvm/queue is mostly final at this point, 
unless something bad happens in the next 2-3 hours of testing, and 
commit 5a4bfabcc865 will be my first pull request to Linus for 5.15.

Paolo

