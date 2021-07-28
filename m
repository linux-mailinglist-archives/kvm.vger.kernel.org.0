Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE643D9262
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 17:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhG1Pzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 11:55:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235754AbhG1Pzg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 11:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627487734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQeLlDrj+2zPGh64OQJME4svPnnDXTidciAnYNyVY3I=;
        b=bEF9tCWg2c4yRsdw4H6T97Q8HdweuEaFlGc8TlDjNFu1qIvbU0JxZ1AZC7a+SIC1S1Ou3T
        60m86LfzMZMCJczELb97Yi70aAnr0RzlPP3xoz4jp2Ar7HeHzz3XA5lNrtZFteSIAMlD/9
        O8zA+6UNatyumX3xRoNsnuMdBaoQieI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ipExhgk-N7a6PAFV2B4iMQ-1; Wed, 28 Jul 2021 11:55:33 -0400
X-MC-Unique: ipExhgk-N7a6PAFV2B4iMQ-1
Received: by mail-wr1-f71.google.com with SMTP id q7-20020a0560001367b02901541c53ad3aso490422wrz.10
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 08:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LQeLlDrj+2zPGh64OQJME4svPnnDXTidciAnYNyVY3I=;
        b=SAGh0Wf3M2K14rsacG5X9ZlN3yiBQh5OjfJy13vnqdDUbJRp4KfU462WOq+hIUSpXb
         bsXIO7AIarM+YLjDMIp9zqZ8EN0KasNJIdkAdUEXAkIZHcocXQtMuDzdLNTqWxetvjk/
         8+Z8un9pIZDwP+E135nFz9iiYJ0qbHj86y/CvZV7BjFjEG0dwC72TGHHJ/42EJsbJ5DX
         ZPJuMWS9L6wQwVOXNY3oIHZcDG0v0slzYAWvK72uG7VexxvwtiQUTwhBaEXvZZs5w85S
         yblQd285adJho/03YvlzidiwrvvUbeEgaOOEp9sYCqlljhCTtbcVJ6R1Q2V0PEEffip5
         u7TA==
X-Gm-Message-State: AOAM531HJP55HwPekTrtWBgVlH+2VDuDAe28v2RqUd9BvtXCmAnDEt4K
        zhA9r3yBKuwMEOAyOcXOIbccoEujpN+UpdUoZKj8BeEOMfWIvJI2yk4lbBDP94RLsggbIqscLl8
        WaQL8AlsTzT88TWRprrcGNsCIL9SMTP354U1qKEUjVIdgTSCh20xTKAbqNBEI9qs9
X-Received: by 2002:a5d:6184:: with SMTP id j4mr75411wru.340.1627487731855;
        Wed, 28 Jul 2021 08:55:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq32gJVrcQXXHobfwfbt6t5MlpipkUfSHbn6vLhAq9kx1TvR/Iqdm9vWPzj5mRQYkVSLgrQw==
X-Received: by 2002:a5d:6184:: with SMTP id j4mr75393wru.340.1627487731586;
        Wed, 28 Jul 2021 08:55:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v2sm180860wro.48.2021.07.28.08.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 08:55:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Exit to userspace when kvm_check_nested_events
 fails
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210728115317.1930332-1-pbonzini@redhat.com>
 <87o8am62ac.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <73c45041-6bb3-801c-bd80-f48b2e525548@redhat.com>
Date:   Wed, 28 Jul 2021 17:55:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87o8am62ac.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/21 14:39, Vitaly Kuznetsov wrote:
> Shouldn't we also change kvm_arch_vcpu_runnable() and check
> 'kvm_vcpu_running() > 0' now?

I think leaving kvm_vcpu_block on error is the better choice, so it 
should be good with returning true if kvm_vcpu_running(vcpu) < 0.

Paolo

