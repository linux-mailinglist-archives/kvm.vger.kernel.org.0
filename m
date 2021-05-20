Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF28638AE40
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhETMcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:32:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232474AbhETMck (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 08:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621513877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aoSgvFFKVMc3G/pczWgV02L96fZbMJsKlQ5JwPhLQOM=;
        b=M6Y1xeNtzo4IDPx80lPmbzt46lVkJkkyrwUUbi267faXvsJCyKV6okTw6tizSxEC5zD4og
        QoAwsNxQyeXAAjMSyHqFTbEloGlXBSFArnf/CaaRk8m6nqCzvjApyvWFG7ePhbAuK+MgE+
        IWFjHeHyHh7iGqUAGhTSzoCXxu9b1r4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-8BLUYeeTNNK17EdY96YhlQ-1; Thu, 20 May 2021 08:31:15 -0400
X-MC-Unique: 8BLUYeeTNNK17EdY96YhlQ-1
Received: by mail-wr1-f70.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so8492122wrb.3
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 05:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aoSgvFFKVMc3G/pczWgV02L96fZbMJsKlQ5JwPhLQOM=;
        b=l9b5EY3fx3Fft63ynT2EcMjrMEwHM2vx7YlwO9hr7/7VJmSl0VZ2MRtY+QQxj4o2UV
         ooh/sCQQGxhxg3LB3PybcM7RNSPjFSt/vb1jpnCtG1qShWz7KN7J00p6x02bv5HmVgik
         lUqn/IM8DKG7FLUcN5pTkwBav/8CgHDcbo7UZv3vreaQ2lK4ffxiWh0NjDelGCBRniGE
         ZRJPKqTUHCk3lRm6XD2S6dz9nbCtQeoB5++5XqLoNh3KO6g+tSuzpbcGkZwM+lwjXokn
         FcVDquRX6+XWbf9vNdKQpVYX7+6lWCsWD/GbkVRXBM+9fP1w4Es+2mowWMjDhSTw9I3l
         FjTg==
X-Gm-Message-State: AOAM5316ndo3xeim1y6b6NFyLsfUUWxSBBZbfkucANhiKaZYXic9A+iS
        zZ1tiFzPe3zQe2h31/F1YwQMWGkzE3CQ0R/StK2X0yxSVhwt5X6frbXvXy/0F7/Str6QRUh0WLy
        Z0TMiFROZyETW
X-Received: by 2002:a05:600c:49a2:: with SMTP id h34mr3904564wmp.64.1621513874112;
        Thu, 20 May 2021 05:31:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRyVKUDco1XFJtBSF08deqU/vZWKPY1GiHaPpbP6ydk/mHwxQJrYLGMqxtartHHXDv+KRgjA==
X-Received: by 2002:a05:600c:49a2:: with SMTP id h34mr3904538wmp.64.1621513873934;
        Thu, 20 May 2021 05:31:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g5sm2734192wmi.8.2021.05.20.05.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 05:31:12 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
To:     Sean Christopherson <seanjc@google.com>,
        Jon Kohler <jon@nutanix.com>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210428173820.13051-1-jon@nutanix.com>
 <YIxsV6VgSDEdngKA@google.com>
 <9040b3d8-f83f-beb5-a703-42202d78fabb@redhat.com>
 <70B34A15-C4A1-4227-B037-7B26B40EDBFE@nutanix.com>
 <YKWI1GPdNc4shaCt@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3d3622c0-7c7a-3d24-d0f5-3204c5d105f9@redhat.com>
Date:   Thu, 20 May 2021 14:31:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKWI1GPdNc4shaCt@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/21 23:53, Sean Christopherson wrote:
>    1. Refactor check_nested_events() to split out a has_events() helper.
>    2. Move the has_events() call from kvm_vcpu_running() into kvm_vcpu_has_events()
>    3. Drop the explicit hv_timer_pending() in inject_pending_event().  It should
>       be dead code since it's just a pointer to nested_vmx_preemption_timer_pending(),
>       which is handled by vmx_check_nested_events() and called earlier.
>    4. Drop the explicit hv_timer_pending() in kvm_vcpu_has_events() for the same
>       reasons as (3).  This can also drop hv_timer_pending() entirely.

Sounds good except that I would do (3) first, since if I understand 
correctly it's a valid cleanup in the current code as well, and do (2) 
and (4) at the same time since you're basically enlarging the scope of 
the existing hv_timer_pending call to include all nested events.

Paolo

