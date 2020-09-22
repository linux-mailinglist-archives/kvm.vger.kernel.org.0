Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FF927476D
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 19:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgIVR0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 13:26:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIVR0u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 13:26:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600795608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cC4vNo1CO1QG+EAvLuU0GIE7LU6JKUJNQ2JWRq7ZBKk=;
        b=jCFbomyQ7zj0q380JEOmPc4ml3z9Lf+zz1hySXIvUZMvpIeItCHYIFgj4eBtkXqO2C70hw
        0AFWPe0p6KH3ISHCIr6njY3J2HxoQz6oQoHnK2p5GUT3GFqXX5b2ayvGqs1yAJ98YcmpT4
        21YSgMKX20qNeM4Xm39VlyVtCqyUWKo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-hYqPkeQYMimDKv9Bxl7UaA-1; Tue, 22 Sep 2020 13:26:45 -0400
X-MC-Unique: hYqPkeQYMimDKv9Bxl7UaA-1
Received: by mail-wr1-f69.google.com with SMTP id y3so7697392wrl.21
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 10:26:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cC4vNo1CO1QG+EAvLuU0GIE7LU6JKUJNQ2JWRq7ZBKk=;
        b=kipAUavrkVstt4so6OdJgOV2hw0ch8DAB/o3WyHRZVZvSiBaTXLEtyJiuWmtm0Y5RD
         lPukPWbForkqDV+xBjzk9Glp5Cc/so/taJqYDVvk+AjjRCxhaFg+Q1jYy2hf4i56kgnK
         WvRM03dIfcVir2/rLa2drtwEVH3LHcX0yoQ+XLsaPfTA+HbXH8z+94KfwtNvw/TNXIVJ
         jcxzkO4zA59OVxhWFRUrHBWUvNjSfSeVbPzfuWzyK+Wzw8/dMv1komyLdPwZ5hsmIaKb
         CO79rExOlzQ5tUhRKD/9oLseMyg+8Ry375iyQD1fZKL93LBNd6I4uleER3ys2dXMCBhK
         o8yA==
X-Gm-Message-State: AOAM532nVmesnlereZRPsWpdKcTNyWUw3D1HtEHZvW/5zkWG+DVZX9mR
        M6MQZicGnayh8WNGn0TXXwOPabRjT6dj429KM9nANdlUtHEsUGKXSBrW7VPoCaLAtfkfuaNB0cp
        85BzFC2ZdNwmH
X-Received: by 2002:a5d:5281:: with SMTP id c1mr6523678wrv.184.1600795604403;
        Tue, 22 Sep 2020 10:26:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf78yXN9H1JnVlY2+AexGoxAZKl2EPY6g9RFBEDnRWEM1a5qJL0n4COjK00SE5kH31DZ3Lig==
X-Received: by 2002:a5d:5281:: with SMTP id c1mr6523659wrv.184.1600795604218;
        Tue, 22 Sep 2020 10:26:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id e13sm31243921wre.60.2020.09.22.10.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 10:26:43 -0700 (PDT)
Subject: Re: [PATCH] i386: Don't try to set MSR_KVM_ASYNC_PF_EN if
 kernel-irqchip=off
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     qemu-devel@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        1896263@bugs.launchpad.net, kvm@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20200922151455.1763896-1-ehabkost@redhat.com>
 <87v9g5es9n.fsf@vitty.brq.redhat.com> <20200922161055.GY57321@habkost.net>
 <87pn6depau.fsf@vitty.brq.redhat.com> <20200922172229.GB57321@habkost.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b22127f4-9a68-99b8-bf55-b6ede236dee0@redhat.com>
Date:   Tue, 22 Sep 2020 19:26:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922172229.GB57321@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 19:22, Eduardo Habkost wrote:
> If it was possible, did KVM break live migration of
> kernel-irqchip=off guests that enabled APF?  This would mean my
> patch is replacing a crash with a silent migration bug.  Not nice
> either way.

Let's drop kernel-irqchip=off completely so migration is not broken. :)

I'm actually serious, I don't think we need a deprecation period even.

Paolo

