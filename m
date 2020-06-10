Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE10C1F5D7B
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 23:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgFJVHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 17:07:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25313 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726134AbgFJVHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 17:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591823225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tu2jjGryr0LbbIINiT9lskQiUTJPT9zi4N6MojzSreQ=;
        b=Z2eIp/WeYmJOnJUmdWB5TqszJ3ojo48aIl+X68qz2X3/7n/ep24MacAZGO79WE/8qF3SFh
        B/kmO6aKISJ5vFAbzoOBIv5+fUKbo9LV+xh6U7ycyUccSIeu8UI3M+mCoE7y3Ey32Dyt3X
        ajg09lk2S53ydOHvfKOAEcV8pPceS6E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-Z0_qhRkZPUOqwYXCuaNjKw-1; Wed, 10 Jun 2020 17:07:03 -0400
X-MC-Unique: Z0_qhRkZPUOqwYXCuaNjKw-1
Received: by mail-wr1-f69.google.com with SMTP id s17so1594044wrt.7
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 14:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tu2jjGryr0LbbIINiT9lskQiUTJPT9zi4N6MojzSreQ=;
        b=WUB14NdBZ2m63KVIm8Vp7YeIglGvrGOVhsbkf8i8v9hvfvHuH5rmXKaQGEL4/xycxm
         RuAgdMw8VqU1uyxBoF8AFMjQseOVWnUrzbC4knAURltiL33zcHB1HZDHB/PpxAj659w0
         028eANTe6q0q/cx8LxqzpaxKpacQosKO5YNzt/TH3e56CZgclOyHbp9w3tFBJqQzvIiG
         4OG0bSHLR/xGe0QGVo/S7BHKXlE+UQ5Q/qgLxMF+fVeZ1NnQycljAYEIVXCN97zdSors
         vyqLlulGbbfwj7R0e8AMhURked7oz2zD3CbzsCOfxM5msUVXgJf+UDXfSiOdXH2UwInF
         lj/Q==
X-Gm-Message-State: AOAM5305ZBmfwGY50p5VTWmEaXH/PDvzh2IltHlPBAZ6qMCS7E4hx44+
        2lQ9H6haO9NATwGWp+6dThHKxv/YbVhoTkUlogB9TdoGv99vW1ipLCSaCXCqn/NIHKJz8LbeUAc
        Q3sExS2zwfCXG
X-Received: by 2002:a1c:7903:: with SMTP id l3mr4812439wme.50.1591823222125;
        Wed, 10 Jun 2020 14:07:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwB9u5OHRHTxISVcb8apV6jQZ2qzFcqJQzCsm1Vb79yhDGrB86d0X9sNVypofwaxUeYAbWMHw==
X-Received: by 2002:a1c:7903:: with SMTP id l3mr4812425wme.50.1591823221882;
        Wed, 10 Jun 2020 14:07:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id f11sm1369605wrm.13.2020.06.10.14.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 14:07:01 -0700 (PDT)
Subject: Re: [PATCH v2 08/10] KVM: x86: Switch KVM guest to using interrupts
 for page ready APF delivery
To:     Vivek Goyal <vgoyal@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-9-vkuznets@redhat.com>
 <20200610205145.GC243520@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da087813-7be4-0e3c-d93c-a29d6933b69d@redhat.com>
Date:   Wed, 10 Jun 2020 23:06:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200610205145.GC243520@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/20 22:51, Vivek Goyal wrote:
>> KVM now supports using interrupt for 'page ready' APF event delivery and
>> legacy mechanism was deprecated. Switch KVM guests to the new one.
> Hi Vitaly,
> 
> I see we have all this code in guest which tries to take care of
> cases where PAGE_READY can be delivered before PAGE_NOT_PRESENT. In
> this new schedume of things, can it still happen. We are using
> an exception to deliver PAGE_NOT_PRESENT while using interrupt to
> deliver PAGE_READY.
> 
> If re-ordeing is not possible, then it will be good to get rid of
> that extra complexity in guest.

It is perhaps less likely but still possible, because the interrupt
might be delivered to another CPU and race against the exception.

Paolo

