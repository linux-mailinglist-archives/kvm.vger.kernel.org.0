Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5119119961A
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgCaMQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:16:34 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32517 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730380AbgCaMQd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 08:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585656992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIkdm1RPzoMJraitwnvvrTQS82YbBm+BBWTAYvOw/a0=;
        b=V7ygkBjjVC7byuxTLIiu/9ck2JdtrQ2EaL1EAwyB90fy8M0AG/aTVgTb+5EGZgwXPKvDqQ
        h0qXSdUFKs8JuN2GuVKiiPAwnSS+On0oZXQrEHuObC52nL8HMEZEABvkpOV4CvBmAIt9ze
        nhMZtuhqfSeIEj6VJYL+U+7VZlRotc4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-WxlveDevNc-sWoiEONYcJQ-1; Tue, 31 Mar 2020 08:16:30 -0400
X-MC-Unique: WxlveDevNc-sWoiEONYcJQ-1
Received: by mail-wr1-f70.google.com with SMTP id q14so3297669wro.7
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 05:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AIkdm1RPzoMJraitwnvvrTQS82YbBm+BBWTAYvOw/a0=;
        b=BmDX7Sm5o5scW/EfsiP7M18gBioZD9/95lnIox4JSpIyfhLxoYnSLFuvAWQQx0iWvO
         f5F6QNBK84NJc1SHga2Ct2ejZmqdWzeAGAkVTGS5u6MwAb4enQ7CZK4NEFnpq0sZ64I9
         t5GymzhdpKyQYRVAd+JQY1LOg3GVsIAEjOZ6Kdj0k4YUyn0bwbsK5IQB6Hrpu/8R+mng
         DJTf49DSidrqTn1OL2nUBE+XrC2GHYwBlYkuPkXFm0RCtj0nd9GHgJgAp9B/04VV/Ohk
         gBlx4UZ2lk2gSt5VRa6ZRAc3n3xv1P343PH+tH2jf38bZLYEK8oi8plJbsaHauggu7vN
         KpUg==
X-Gm-Message-State: ANhLgQ3dleVlRxoCUI7Y4iAUEHEaznV3otHDQhUEbFaBOx6mQ7VQnecw
        sDZK5LQAz18l77tJALFpgDcu7s7bPkJdJRUtr/cK92rPy6y3mDVvL5i30oLRHXU5Q2cQ/HlcpNR
        pchLsZDEUES54
X-Received: by 2002:a1c:f409:: with SMTP id z9mr3340246wma.51.1585656989319;
        Tue, 31 Mar 2020 05:16:29 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvcbyZLww2LXTEarvjb+E499WK7YYqe/vu5BI2QScvGR8UQClxweAMw8FUdntCdulV276PfnA==
X-Received: by 2002:a1c:f409:: with SMTP id z9mr3340231wma.51.1585656989082;
        Tue, 31 Mar 2020 05:16:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id b199sm3939974wme.23.2020.03.31.05.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 05:16:28 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: x86: introduce kvm_mmu_invalidate_gva
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
 <20200326093516.24215-2-pbonzini@redhat.com>
 <20200328182631.GQ8104@linux.intel.com>
 <2a1f9477-c289-592e-25ff-f22a37044457@redhat.com>
 <20200330184726.GJ24988@linux.intel.com>
 <87v9mk24qy.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb7b1075-a4fc-e0d3-d8fd-f516d107d5e2@redhat.com>
Date:   Tue, 31 Mar 2020 14:16:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87v9mk24qy.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/20 12:33, Vitaly Kuznetsov wrote:
>> Works for me.  My vote is for anything other than guest_mmu :-)
>
> Oh come on guys, nobody protested when I called it this way :-)

Sure I take full responsibility for that. :)

> Peronally, I don't quite like 'shadow_tdp_mmu' because it doesn't have
> any particular reference to the fact that it is a nested/L2 related
> thing (maybe it's just a shadow MMU?)

Well, nested virt is the only case in which you shadow TDP.  Both
interpretations work:

* "shadow tdp_mmu": an MMU for two-dimensional page tables that employs
shadowing

* "shadow_tdp MMU": the MMU for two-dimensional page tables.

> Also, we already have a thing
> called 'nested_mmu'... Maybe let's be bold and rename all three things,
> like
>
> root_mmu -> l1_mmu
> guest_mmu -> l1_nested_mmu
> nested_mmu -> l2_mmu (l2_walk_mmu)

I am not particularly fond of using l1/l2 outside code that specifically
deals with nested virt.  Also, l1_nested_mmu is too confusing with
respect to the current nested_mmu (likewise for root_mmu I would rename
it to guest_mmu but it would be an awful source of mental confusion as
well as semantic source code conflicts).

That said, I wouldn't mind replacing nested_mmu to something else, for
example nested_walk_mmu.

Paolo

